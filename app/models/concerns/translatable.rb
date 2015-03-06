module Translatable
  extend ActiveSupport::Concern

  module ClassMethods
    private

    def t(string)
      Dictionary.translate(string, I18n.locale.to_s)
    end
  end
end
