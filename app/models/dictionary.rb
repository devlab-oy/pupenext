class Dictionary < ActiveRecord::Base
  self.table_name = :sanakirja
  self.primary_key = :tunnus

  SUPPORTED_LOCALES = %w(fi ee en no se de dk ru).freeze

  def self.translate(string, language = 'fi')
    # Return the string if don't have the translation
    translate_raw(string, language) || string
  end

  def self.translate_raw(string, language)
    language.downcase!

    # Return nil if we're asking for finnish
    return if language == 'fi'

    # Fetch the translation
    translation = fetch_translation string

    # Return nil if don't have it in the database
    return if translation.nil?

    # Get the translation for the given language
    t_string = translation.send(language)

    # Return nil if we don't have translation in correct languate
    t_string.present? ? t_string : nil
  end

  def self.locales
    SUPPORTED_LOCALES
  end

  def self.fetch_translation(string)
    # Generate a cache key for the string
    cache_key = string.hash

    # Fetch the translation (cache does not expire)
    translation = Rails.cache.fetch("translation_#{cache_key}") do
      find_by('fi = BINARY ?', string.to_s)
    end

    translation
  end
end
