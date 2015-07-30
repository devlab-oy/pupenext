module SplittableDates
  extend ActiveSupport::Concern

  module ClassMethods
    def splittable_dates(*columns)
      columns.each do |column|
        define_method("#{column}=") do |value|
          defaults = { year: 0, month: 0, day: 0 }

          if value.is_a?(Hash)
            value = defaults.merge(value)
            value = [value[:year], value[:month], value[:day]].join '-'
          end

          write_attribute(column.to_sym, value)
        end
      end
    end
  end
end
