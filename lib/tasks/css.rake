namespace :css do

  desc "Write company specific CSS files to /assets"

  task write: :environment do
    Parameter.all.each do |p|
      name = Rails.root.join('app', 'assets', 'stylesheets', 'company', "#{p.company.yhtio}.css")
      File.open(name, 'w') { |f| f.write(p.css) }
    end
  end

end
