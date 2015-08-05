namespace :translations do
  desc "Pull all translations from Localeapp"
  task pull: :environment do
    Localeapp::CLI::Pull.new.execute
  end

  desc "Push all translations to Localeapp"
  task push: :environment do
    Localeapp::CLI::Push.new.execute "config/locales"
  end

  desc "Translate all locales from Finnish"
  task translate: :environment do
    dir   = Rails.root.join 'config', 'locales', '*'
    fi    = Rails.root.join 'config', 'locales', 'fi.yml'
    other = Dir[dir].reject { |file| file.ends_with? 'fi.yml' }
    dict  = YAML.load_file fi

    # Loop all locales, except fi
    other.each do |file|
      locale = file_locale file

      puts "Translating fi --> #{locale}"

      # Translate finnish yaml to locale
      new_hash = translate_hash dict, locale

      # Map to correct locale
      locale = pupe_locale_to_correct locale

      # Change root key to correct locale
      new_hash[locale] = new_hash['fi']
      new_hash.delete 'fi'

      # Merge new translations to old hash, don't overwrite existing translations
      old_hash = YAML.load_file file
      hash = new_hash.deep_merge(old_hash) do |key, new_value, old_value|
        old_value.nil? ? new_value : old_value
      end

      # Write translations to yaml file
      File.open(file, 'w') { |f| f.write(hash.to_yaml) }
    end
  end

  def file_locale(file)
    locale = File.basename file, ".yml"

    # map to pupesoft locales
    correct_locale_to_pupe locale
  end

  def translate_hash(hash, locale)
    translated_hash = {}

    hash.each_pair do |key, value|
      if value.is_a? Hash
        new_value = translate_hash value, locale
      else
        new_value = Dictionary.translate_raw value, locale
      end

      translated_hash[key] = new_value unless new_value.nil? || new_value.empty?
    end

    translated_hash
  end

  def pupe_locale_to_correct(locale)
    case locale
    when "se"
      "sv"
    when "ee"
      "et"
    when "dk"
      "da"
    else
      locale
    end
  end

  def correct_locale_to_pupe(locale)
    case locale
    when "sv"
      "se"
    when "et"
      "ee"
    when "da"
      "dk"
    else
      locale
    end
  end
end
