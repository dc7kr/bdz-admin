class GitTool
	def git_info(commit_count)
 		 @@info ||= begin
    	{
      		:application => app_name = (Rails.application.class.to_s.split('::').first rescue ""),
      		:environment => Rails.env,
      		:remote_url => `git remote -v`,
      		:remote_branch => `git branch -r`,
      		:last_commits => gitparse(commit_count)
    	}
  		rescue
    	{}
  		end
	end

  def current
    `git describe --dirty --abbrev=6 --always`
  end
  private 
  def gitparse(commit_count) 
    cmd = "git log --abbrev-commit --max-count=#{commit_count}" 

    result = IO.popen(cmd, 'r+') {|io| 
        io.close_write
        io.read
    }


    commit_lines = result.split("\n")
    commit=nil

    commits = Array.new
    commit_lines.each do |c|
      if c.start_with?("commit")
        if not commit.nil?
          commits << commit
        end
        commit = Hash.new
        commit[:id] = c.gsub(/^commit\ +/,"")
      elsif c.start_with?("Author:")
        commit[:author]= c.gsub(/^Author:\ +/,"")
      elsif c.start_with?("Date:")
        commit[:date]= DateTime.parse(c.gsub(/^Date:\ +/,""))
      else
        if commit[:lines].nil? then
          commit[:lines] = Array.new
        end
        commit[:lines] << c
      end
    end
  
    return commits
  end
end
