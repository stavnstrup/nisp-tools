#!/bin/bash

# Enable error reporting to the console.
set -e

# Checkout master and remove everything
git clone https://${GH_TOKEN}@github.com/nispworld/live-nisp.git ../live-nisp.master
cd ../live-nisp.master
git checkout master
rm -rf *

# Copy generated HTML site from source branch in original repo.
# Now the master branch will contain only the contents of the _site directory.
cp -R ../nisp-tools/build/* .

# Make sure we have the updated .travis.yml file so tests won't run on master.
# cp ../nisp-tools/.travis.yml .
git config user.email ${GH_EMAIL}
git config user.name "nisp-bot"

# Commit and push generated content to master branch.
git status
git add -A .
git status
git commit -a -m "Travis #$TRAVIS_BUILD_NUMBER"
git push --quiet origin master > /dev/null 2>&1
