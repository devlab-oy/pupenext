class Dictionary < ActiveRecord::Base
  self.table_name = :sanakirja
  self.primary_key = :tunnus

  def self.translate(string, language = 'fi')
    language.downcase!

    # Return the string if we ask for a Finnish word
    return string if language == 'fi'

    # Generate a cache key for the string
    cache_key = string.hash

    # Fetch the translation (cache does not expire)
    translation = Rails.cache.fetch("translation_#{cache_key}") do
      where("fi = BINARY ?", string).first
    end

    # Return the string if don't have it in the database
    return string if translation.nil?

    # Get the translation for the given language
    t_string = translation.send(language)

    # Return the string if we don't have translation in correct languate
    t_string.present? ? t_string : string
  end
end
