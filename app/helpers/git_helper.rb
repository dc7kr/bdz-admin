module GitHelper
  def git_info
    info ||= {
        application: Rails.application.class.to_s.split("::").first,
        environment: Rails.env,
        remote_url: `git remote -v`,
        remote_branch: `git branch -r`,
        last_commits: gitparse
      }
  end

  private

  def gitparse
    data = File.read(Rails.root.join("changelog.txt"))

    commit_lines = data.split("\n")
    commit = nil

    commits = []
    commit_lines.each do |c|
      if c.start_with?("commit")
        commits << commit unless commit.nil?
        commit = {}
        commit[:id] = c.gsub(/^commit\ +/, "")
      elsif c.start_with?("Author:")
        commit[:author] = c.gsub(/^Author:\ +/, "")
      elsif c.start_with?("Date:")
        commit[:date] = DateTime.parse(c.gsub(/^Date:\ +/, ""))
      else
        commit[:lines] = [] if commit[:lines].nil?
        commit[:lines] << c unless c.empty?
      end
    end

    commits
  end
end
