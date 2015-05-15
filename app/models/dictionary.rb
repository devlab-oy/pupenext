class Dictionary < ActiveRecord::Base
  include SaveByExtension
  include Searchable
  extend Translatable

  # Map old database schema table to class
  self.table_name = :sanakirja
  self.primary_key = :tunnus

  scope :created_order, -> { order({ luontiaika: :desc }, :fi) }

  def self.translate(string, language = 'fi')
    RequestStore.store[:translated_words] ||= []
    RequestStore.store[:translated_words] << string

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

  def self.allowed_languages
    [
      [t("Englanti"), "en"],
      [t("Ruotsi"), "se"],
      [t("Viro"), "ee"],
      [t("Saksa"), "de"],
      [t("Tanska"), "dk"],
      [t("Norja"), "no"],
      [t("Venäjä"), "ru"]
    ]
  end

  def self.default_language
    [t("Suomi"), "fi"]
  end

  def self.all_languages
    [default_language] | allowed_languages
  end

  def self.translated_words(format = false)
    translated_words = RequestStore.store[:translated_words].try(:uniq)
    translated_words.try(:join, "\n") if format == :to_s
  end
end
