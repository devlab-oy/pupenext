module SplittableDates
  extend ActiveSupport::Concern

  module ClassMethods
    def splittable_dates(*columns)
      columns.each do |column|
        define_method("#{column}=") do |value|
          keys = [:year, :month, :day]

          if value.is_a?(Hash) && keys.all? { |key| value.key? key }
            value = [value[:year], value[:month], value[:day]].join '-'
          end

          write_attribute(column.to_sym, value)
        end
      end
    end
  end
end
