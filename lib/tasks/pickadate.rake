namespace :pickadate do
  desc "Update pickadate.js assets"

  task :update do
    require 'open-uri'
    require 'pathname'

    js_dir  = Rails.root.join 'app', 'assets', 'javascripts', 'pickadate'
    css_dir = Rails.root.join 'app', 'assets', 'stylesheets', 'pickadate'
    github  = 'https://raw.githubusercontent.com/amsul/pickadate.js/master/lib'

    files = [
      { source: "#{github}/picker.js",               destination: "#{js_dir}/picker.js"         },
      { source: "#{github}/picker.date.js",          destination: "#{js_dir}/picker.date.js"    },
      { source: "#{github}/themes/classic.css",      destination: "#{css_dir}/classic.css"      },
      { source: "#{github}/themes/classic.date.css", destination: "#{css_dir}/classic.date.css" },
    ]

    files.each do |file|
      dest = file[:destination]
      src  = file[:source]
      name = Pathname.new(dest).basename

      puts "Fetching #{name}"

      File.open(dest, "w") do |saved_file|
        open(src, "r") do |read_file|
          saved_file.write(read_file.read)
        end
      end
    end
  end
end
