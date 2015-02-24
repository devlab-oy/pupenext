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
current_dir=$(pwd)
dirname=$(dirname $0)
app_dir=$(cd "${dirname}" && pwd)

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

  # Jos toinen parametri on bundle, niin bundlataan aina eikä tarvitse tsekata git-juttuja
  if [[ -n "${2}" && ${2} = "bundle" ]]; then
    OLD_HEAD=0
  else
    # Get old head
    OLD_HEAD=$(cd "${app_dir}" && git rev-parse HEAD)
  fi

  # Change to app directory
  cd "${app_dir}" &&

  # Jos toinen parametri on bundle, niin bundlataan aina eikä tarvitse tsekata git-juttuja
  if [[ -n "${2}" && ${2} = "bundle" ]]; then
    STATUS=0
    NEW_HEAD=1
  else
    # Update app with git
    git fetch origin &&
    git checkout . &&
    git checkout master &&
    git pull origin master &&
    git remote prune origin

    # Save git exit status
    STATUS=$?

    # Get new head
    NEW_HEAD=$(git rev-parse HEAD)
  fi

  # Check tmp dir
  if [ ! -d "${app_dir}/tmp" ]; then
    mkdir "${app_dir}/tmp"
  fi

  echo

  # Ei päivitettävää
  if [[ ${STATUS} -eq 0 && ${OLD_HEAD} = ${NEW_HEAD} ]]; then
    echo "${green}Pupenext ajantasalla, ei päivitettävää!${normal}"
  elif [[ ${STATUS} -eq 0 ]]; then
    # Setataan rails env
    export RAILS_ENV="production"

    # Run bundle + rake
    bundle --quiet &&
    bundle exec rake css:write &&
    bundle exec rake assets:precompile &&

    # Restart rails App
    touch "${app_dir}/tmp/restart.txt" &&
    chmod 777 "${app_dir}/tmp/restart.txt" &&

    # Restart Resque workers
    bundle exec rake resque:stop_workers &&
    TERM_CHILD=1 BACKGROUND=yes QUEUES=* bundle exec rake resque:work &&

    # Tehdään requesti Rails appiin, jotta latautuu valmiiksi seuraavaa requestiä varten
    curl --silent --connect-timeout 1 --insecure "https://$(hostname -I)/pupenext" > /dev/null &&
    curl --silent --connect-timeout 1 --insecure "https://$(hostname)/pupenext" > /dev/null

    if [[ ${STATUS} -eq 0 ]]; then
      echo "${green}Pupenext päivitetty!${normal}"
    else
      echo "${red}Rails päivitys/uudelleenkäynnistys epäonnistui!${normal}"
    fi

    # Poistetaan rails env
    unset RAILS_ENV
  else
    echo "${red}Pupenext päivitys epäonnistui!${normal}"
  fi
else
  echo "${red}Pupenextiä ei päivitetty!${normal}"
fi

# Change back to current dir
cd "${current_dir}"
echo
