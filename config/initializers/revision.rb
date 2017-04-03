gh = GitTool.new
GIT_INFO = gh.git_info(2)

last_commit = GIT_INFO[:last_commits]

GIT_REVISION =  gh.current
