namespace :translations do
  desc "Pull all translations from Localeapp"
  task pull: :environment do
    Localeapp::CLI::Pull.new.execute
  end

  desc "Push all translations to Localeapp"
  task push: :environment do
    Localeapp::CLI::Push.new.execute "config/locales"
  end
end
