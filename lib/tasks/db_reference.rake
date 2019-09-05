namespace :db do
  desc "Pull reference database from pupeapi.sprintit.fi to development db"
  task pull_reference: :environment do

    unless Rails.env.development?
      puts "This task can be run only in development environment!"
      exit
    end

    username = Rails.application.secrets.db_user
    database = Rails.application.secrets.db_name
    hostname = Rails.application.secrets.db_host
    password = Rails.application.secrets.db_pass
    dbport   = Rails.application.secrets.db_port

    devlab   = 'http://api.devlab.fi/'
    mysql    = "mysql --user=#{username} --host=#{hostname} --port=#{dbport} --password=#{password}"
    schema   = "/tmp/pupe_schema.sql"
    data     = "/tmp/pupe_data.sql"

    commands = [
      "curl --progress-bar -o #{schema} http://pupeapi.sprintit.fi/referenssitietokantakuvaus.sql",
      "curl --progress-bar -o #{data} http://pupeapi.sprintit.fi/referenssidata.sql",
      "#{mysql} -e 'drop database #{database}'",
      "#{mysql} -e 'create database #{database}'",
      "#{mysql} #{database} < #{schema}",
      "#{mysql} #{database} < #{data}",
      "rm -f #{schema} #{data}",
    ]

    commands.each do |cmd|
      %x(#{cmd})
    end
  end
end
