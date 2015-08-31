module UserDefinedValidations
  extend ActiveSupport::Concern

  included do
    mattr_accessor :table_set_name

    validate :validate_user_defined_columns
  end

  private

    def validate_user_defined_columns
      mandatory_fields.each do |field|
        field_name  = field.field.to_sym
        field_value = self.send field_name

        errors.add field_name, I18n.t('errors.messages.blank') if field_value.blank?
      end
    end

    def mandatory_fields
      table_name = self.class.table_name
      set_name   = self.table_set_name || Keyword::CustomAttribute::DEFAULT_SET_NAME

      Keyword::CustomAttribute.mandatory.fetch_set table_name: table_name, set_name: set_name
    end
end
