module DateDatetimeDefaults
  extend ActiveSupport::Concern

  def set_date_fields
    self.class.columns.each do |column|
      next unless column.type.in?([:date, :datetime])
      next if send(column.name).present?
      next if column.null
      next if column.name.in?(%w(muutospvm luontiaika created_at updated_at'))

      assign_attributes value_for_column(column)
    end
  end

  def fix_datetime_fields
    params = {}
    zero   = '0000-00-00 00:00:00'
    epoch  = Time.zone.at 0

    # Change all datetime fields to zero if they are epoch
    self.class.columns.each do |column|
      next unless column.type == :datetime && send(column.name) == epoch

      params[column.name] = zero
    end

    # update_columns skips all validations and updates values directly with sql
    update_columns params if params.present?
  end

  private

    def value_for_column(column)
      case column.type
      # Date fields can be set to zero
      when :date
        value = 0
      # Datetime fields don't accept zero, so let's set them to epoch zero (temporarily)
      when :datetime
        value = Time.zone.at 0
      end

      { column.name => value }
    end
end
