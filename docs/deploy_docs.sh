#!/bin/bash
# 1. Generate the latest docs
cd ../olist_dbt
dbt docs generate --select olist_dbt --profiles-dir . --static

# 2. Switch to gh-pages
git checkout gh-pages

# 3. Move the files to the root
cp -r target/* .

# 4. Add, commit, and push
git add .
git commit -m "Update dbt documentation"
git push origin gh-pages

# 5. Switch back
git checkout main
