#!/bin/bash

# Deployment to nisp.nw3.dk

# Enable error reporting to the console.
set -e

# Checkout Web generation tool package
git clone https://${GH_TOKEN}@github.com/stavnstrup/nisp-nation.git ../nisp-nation.master
cd ../nisp-nation.master

# Generate yaml and json representation of NISP database elements
saxonb-xslt -ext:on ../nisp-tools/src/standards/standards.xml _xsl/db2data.xsl

# Build website
bundle install
bundle exec jekyll build

# Checkout existing website and remove everything
git clone https://${GH_TOKEN}@github.com/nispworld/nispworld.github.io.git ../nisp-web.master
cd ../nisp-web.master
git checkout master
rm -rf *

# Copy generated HTML site from nisp-nation.
# Now the master branch will contain only the contents of the _site directory.
cp -R ../nisp-nation.master/_site/* .

# Configure bot data
git config user.email ${GH_EMAIL}
git config user.name "nisp-bot"

# Using a custom domain with GitHub Pages
echo "nisp.nw3.dk" > CNAME

# Commit and push generated content to master branch.
git status
git add -A .
git status
git commit -a -m "Travis #$TRAVIS_BUILD_NUMBER"
git push --quiet origin master > /dev/null 2>&1
