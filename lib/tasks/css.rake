namespace :css do

  desc "Write company specific CSS files to /assets"

  task write: :environment do
    Parameter.all.each do |p|
      cssnew = Rails.root.join('app', 'assets', 'stylesheets', 'company', "#{p.company.yhtio}.css")
      cssold = Rails.root.join('app', 'assets', 'stylesheets', 'company', "#{p.company.yhtio}_classic.css")
      File.open(cssnew, 'w') { |f| f.write(p.css) }
      File.open(cssold, 'w') { |f| f.write(p.css_classic) }
    end
  end

end
