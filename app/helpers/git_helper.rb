module GitHelper
	def git_info
 		 @@info ||= begin
    	{
      		:application => app_name = (Rails.application.class.to_s.split('::').first rescue ""),
      		:environment => Rails.env,
      		:remote_url => `git remote -v`,
      		:remote_branch => `git branch -r`,
      		:last_commit => `git log --max-count=1`
    	}
  		rescue
    	{}
  		end
	end
end
