class GitTool
  def git_info(commit_count)
    @@info ||= begin
      {
        application: begin
          Rails.application.class.to_s.split('::').first
        rescue StandardError
          ''
        end,
        environment: Rails.env,
        remote_url: `git remote -v`,
        remote_branch: `git branch -r`,
        last_commits: gitparse(commit_count)
      }
    rescue StandardError
      {}
    end
  end

  def current
    `git describe --dirty --abbrev=6 --always`
  end

  private

  def gitparse(commit_count)
    cmd = "git log --abbrev-commit --max-count=#{commit_count}"

    result = IO.popen(cmd, 'r+') do |io|
      io.close_write
      io.read
    end

    commit_lines = result.split("\n")
    commit = nil

    commits = []
    commit_lines.each do |c|
      if c.start_with?('commit')
        commits << commit unless commit.nil?
        commit = {}
        commit[:id] = c.gsub(/^commit\ +/, '')
      elsif c.start_with?('Author:')
        commit[:author] = c.gsub(/^Author:\ +/, '')
      elsif c.start_with?('Date:')
        commit[:date] = DateTime.parse(c.gsub(/^Date:\ +/, ''))
      else
        commit[:lines] = [] if commit[:lines].nil?
        commit[:lines] << ("#{c}\n")
      end
    end

    commits
  end
end
