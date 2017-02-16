if [ $# -lt 1 ]
then
  echo
  echo "Usage: $0 step1|step2"
  echo
  exit
fi

repo=repo-xyz
branch=add_a_new_db
commitmessage=$branch
repolocation=all-repos
forklocation=MyUserName

exec > ${repo}.$1  2>> ${repo}.$1

if [ $1 == "step1" ]
then

git clone git@www.gitbub.com:${forklocation}/${repo}.git

cd ${repo}

git remote add upstream git@www.gitbub.com:${repolocation}/${repo}.git

git remote -v

git checkout master

git pull upstream master

git checkout -b $branch

else

# At this point, edit files and do the rest
# If missed something, after 'push' again edit-add-commit-push

cd ${repo}

git add .

git commit -m "$commitmessage"

git push origin $branch

fi
