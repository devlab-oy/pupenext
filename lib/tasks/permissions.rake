namespace :pupesoft do
  desc 'Fix Pupesoft Permissions'

  task fix_permissions: :environment do
    Company.find_each do |company|
      Current.company = company.yhtio
      company_name = "#{company.nimi} (#{company.yhtio})"

      puts "Käsitellään #{company_name}"

      # check do we have invalid menus/profiles
      menus    = company.menus.select(&:invalid?)
      profiles = company.user_profiles.select(&:invalid?)

      # if all are valid, update user permissions
      company.users.find_each(&:update_permissions) if menus.empty? && profiles.empty?

      puts "Virheellisiä valikoita yrityksessä #{company_name}" if menus.present?
      puts "Virheellisiä profiileja yrityksessä #{company_name}" if profiles.present?
    end
  end
end
