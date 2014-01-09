class Dictionary < ActiveRecord::Base

  # Map old database schema table to class
  self.table_name  = "sanakirja"
  self.primary_key = "tunnus"
  self.record_timestamps = false

  def self.translate(string, language = nil)
    language ||= "fi"
    language.downcase!

    # Return string if we ask for Finnish word
    return string if language == "fi"

    # Generate cache key for string
    cache_key = string.hash

    # Fetch translation (cache does not expire)
    translation = Rails.cache.fetch("translation_#{cache_key}") do
      where("fi = BINARY ?", string).first || string
    end

    # Return string if we don't have translation
    translation[language].present? ? translation[language] : string
  end

end
