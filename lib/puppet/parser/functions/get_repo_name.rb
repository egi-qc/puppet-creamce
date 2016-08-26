module Puppet::Parser::Functions
  newfunction(:get_repo_name, :type => :rvalue, :doc => "Extra the repo name from url") do |args|
    repo_url = args[0]
    
    tmpl1 = repo_url.split(".")
    if tmpl1[-1] == "repo"
      return repo_url.split("/")[-1]
    else
      tmps = repo_url.hash()
      return "creamrepo_#{tmps}.repo"
    end

  end
end

