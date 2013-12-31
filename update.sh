#!/bin/bash

# Check we have Git
command -v git > /dev/null

if [[ $? != 0 ]]; then
  echo "Install git first!"
  exit
fi

# Check we have Bundler
command -v bundle > /dev/null

if [[ $? != 0 ]]; then
  echo "Install bundle first!"
  exit
fi

# Get required directories
current_dir=`pwd`
dirname=`dirname $0`
app_dir=`readlink -m "${dirname}"`

# Change to app directory
cd "${app_dir}"

# Update app with git
git fetch origin
git checkout .
git checkout master
git pull origin master
git remote prune origin

# Run bundle + rake
RAILS_ENV="production" bundle
RAILS_ENV="production" bundle exec rake css:write
RAILS_ENV="production" bundle exec rake assets:precompile
RAILS_ENV="production" bundle exec rake db:migrate

# Check tmp dir
if [ ! -d "${app_dir}/tmp" ]; then
  mkdir "${app_dir}/tmp"
fi

# Restart app
touch "${app_dir}/tmp/restart.txt"
chmod 777 "${app_dir}/tmp/restart.txt"

# Change back to current dir
cd "${current_dir}"
