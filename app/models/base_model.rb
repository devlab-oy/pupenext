class BaseModel < ActiveRecord::Base
  self.abstract_class = true

  def self.inherited(subclass)
    super

    unless subclass.abstract_class?
      subclass.class_eval do
        include CurrentCompany
        include CurrentUser
        include UserDefinedValidations

        before_create :set_date_fields
        after_create :fix_datetime_fields
      end
    end
  end

  def set_date_fields
    self.class.columns.each do |column|
      next if !column.type.in?([:date, :datetime]) || send(column.name)

      case column.type
      # Date fields can be set to zero
      when :date
        send("#{column.name}=", 0)
      # Datetime fields don't accept zero, so let's set them to epoch zero (temporarily)
      when :datetime
        send("#{column.name}=", Time.at(0))
      end
    end
  end

  def fix_datetime_fields
    params = {}
    zero   = '0000-00-00 00:00:00'
    epoch  = Time.at(0)

    # Change all datetime fields to zero if they are epoch
    self.class.columns.each do |column|
      next unless column.type == :datetime && send(column.name) == epoch

      params[column.name] = zero

      # update_columns skips all validations and updates values directly with sql
      update_columns params if params.present?
    end
  end
end
