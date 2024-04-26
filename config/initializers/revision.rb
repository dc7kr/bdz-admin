Rails.application.config.to_prepare do
  yml= YAML.load_file(Rails.root.join('config','version.yml'))
  
  GIT_REVISION =  yml["version_info"]["current"]

  gh = GitTool.new
  GIT_INFO = gh.git_info(2)

  last_commit = GIT_INFO[:last_commits]

end
