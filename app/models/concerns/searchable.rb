module Searchable
  extend ActiveSupport::Concern

  module ClassMethods
    def search_like(args = {}, options = {})
      raise ArgumentError, "should pass hash as argument #{args.class}" unless args.is_a? Hash

      if options[:joiner] && options[:joiner].to_s.upcase == "OR"
        joiner = :or
      else
        joiner = :and
      end

      strict = options[:strict]

      result = self.all

      if joiner == :and
        args.each do |key, value|
          if DatetimeUtils.is_db_date?(value) || exact_search?(value)
            value = (DatetimeUtils.is_db_date?(value)) ? DatetimeUtils.parse(value) : exact_search(value)
            result = result.where(key => value)
          else
            result = result.where_like key, value
          end
        end
      else
        conditions = []
        values = []

        args.each do |column, valuess|
          valuess.each do |value|
            if strict
              conditions << "#{column} = ?"
              values << "#{value}"
            else
              conditions << "#{column} LIKE ?"
              values << "%#{value}%"
            end
          end
        end

        conditions = conditions.join(" OR ")

        result = result.where(conditions, *values)
      end

      result
    end

    def where_like(column, search_term)
      where(self.arel_table[column].matches "%#{search_term}%")
    end

    def search_or(column, values)
      result = self.all
      conditions = []

      values.each do |value|
        conditions << "#{column} LIKE '%#{value}%'"
      end

      conditions = conditions.join(" OR ")

      result.where(conditions)
    end

    private

      def exact_search(value)
        value[1..-1]
      end

      def exact_search?(value)
        value[0].to_s.include? "@"
      end
  end
end
