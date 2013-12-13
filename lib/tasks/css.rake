namespace :css do

  desc "Write company specific CSS files to /assets"

  task write: :environment do
    Parameter.all.each do |p|
      filename = Rails.root.join('app', 'assets', "#{p.company.yhtio}.css")
      File.open(filename, 'w') { |f| f.write(p.css) }
    end
  end

end
