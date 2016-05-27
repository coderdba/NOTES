# https://gist.github.com/caniszczyk/3856584
curl -s https://api.github.com/orgs/twitter/repos?per_page=200 | ruby -rubygems -e 'require "json"; JSON.load(STDIN.read).each { |repo| %x[git clone #{repo["ssh_url"]} ]}'

# http://stackoverflow.com/questions/19576742/how-to-clone-all-repos-at-once-from-github
USER=YOURUSERNAME;PAGE=1; curl "https://api.github.com/users/$USER/repos?page=$PAGE&per_page=100" | grep -e 'git_url*' | cut -d \" -f 4 | xargs -L1 git clone
