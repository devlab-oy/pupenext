module Translatable
  def t(string)
    Dictionary.translate(string, I18n.locale.to_s)
  end
end
