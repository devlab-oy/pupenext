#!/bin/bash

hosti=$(hostname)
underline=$(tput -Txterm-color smul)
nounderline=$(tput -Txterm-color rmul)
green=$(tput -Txterm-color setaf 2)
red=$(tput -Txterm-color setaf 1)
white=$(tput -Txterm-color setaf 7)
normal=$(tput -Txterm-color sgr0)

# Check we have Git
command -v git > /dev/null

if [[ $? != 0 ]]; then
  echo "${red}Install git first!${normal}"
  exit
fi

# Make sure we have rbenv environment
if [[ -d ~/.rbenv ]]; then
  # Add rbenv to path
  export PATH="$HOME/.rbenv/bin:$PATH"

  # Load rbenv
  eval "$(rbenv init -)"
fi

# Check we have Bundler
command -v bundle > /dev/null

if [[ $? != 0 ]]; then
  echo "${red}Install bundle first!${normal}"
  exit
fi

if [ $(whoami) = "root" ]; then
  echo "${red}Ei ole suositeltavaa, että ajat tämän root -käyttäjällä!${normal}"
  echo
  exit
fi

# Get required directories
current_dir=`pwd`
dirname=`dirname $0`
app_dir=`readlink -m "${dirname}"`

# Katsotaan, onko parami syötetty
if [[ ! -z ${1} ]]; then
  jatketaan=${1}
fi

if [[ ! -z "${jatketaan}" && ("${jatketaan}" = "auto" || "${jatketaan}" = "autopupe") ]]; then
  jatketaanko="k"
else
  echo -n "${white}Päivitetäänkö Pupenext (k/e)? ${normal}"
  read jatketaanko
fi

if [[ "${jatketaanko}" = "k" ]]; then
  # Change to app directory
  cd "${app_dir}" &&

  # Update app with git
  git fetch origin &&
  git checkout . &&
  git checkout master &&
  git pull origin master &&
  git remote prune origin &&

  # Run bundle + rake
  RAILS_ENV="production" bundle --quiet &&
  RAILS_ENV="production" bundle exec rake css:write &&
  RAILS_ENV="production" bundle exec rake assets:precompile

  if [[ $? -eq 0 ]]; then
    echo
    echo "${green}Pupenext päivitetty!${normal}"
  else
    echo
    echo "${red}Pupenext päivitys epäonnistui!${normal}"
  fi

  # Check tmp dir
  if [ ! -d "${app_dir}/tmp" ]; then
    mkdir "${app_dir}/tmp"
  fi

  # Restart app
  touch "${app_dir}/tmp/restart.txt"
  chmod 777 "${app_dir}/tmp/restart.txt"
else
  echo "${red}Pupenextiä ei päivitetty!${normal}"
fi

# Change back to current dir
cd "${current_dir}"
echo
