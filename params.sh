version="stable"
#version="git"
version="mea"

trans_version="atom-qa-2.1.x"

git_branch='mea-elasticsearch-0.90'
git_branch='mea'

A="atom-2.0.1"
[ "$version" = "git" ] && A="atom-qa-2.1.x"
[ "$version" = "mea" ] && A="atom-qa-2.1.x-mea"
