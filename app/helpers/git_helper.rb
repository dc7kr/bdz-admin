module GitHelper
	def git_info
 		 @@info ||= begin
    	{
      		:application => app_name = (Rails.application.class.to_s.split('::').first rescue ""),
      		:environment => Rails.env,
      		:remote_url => `git remote -v`,
      		:remote_branch => `git branch -r`,
      		:last_commits => gitparse(`git log --max-count=5 `)
    	}
  		rescue
    	{}
  		end
	end
  private 
  def gitparse(gitlines) 
    commit_lines = gitlines.split("\n")
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
        commit[:date]= c.gsub(/^Date:\ +/,"")
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
