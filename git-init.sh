echo "# NOTES" >> README.md
git init
git add README.md
git add .
git commit -m "first commit"
git remote add origin git@github.com:coderdba/NOTES.git
git push -u origin master
