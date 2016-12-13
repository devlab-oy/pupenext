module Searchable
  extend ActiveSupport::Concern

  module ClassMethods
    def search_like(args = {})
      raise ArgumentError, "should pass hash as argument #{args.class}" unless args.is_a? Hash

      result = self.all

      args.each do |key, value|
        if exact_search? value
          result = result.where key => exact_search(value)
        elsif value == "true"
          result = result.where key => true
        elsif value == "false"
          result = result.where key => false
        elsif value.is_a? Array
          result = result.where key => value
        else
          result = result.where_like key, value
        end
      end

      result
    end

    def where_like(column, search_term)
      table_column = column.to_s.split '.'
      raise ArgumentError if table_column.length > 2

      if table_column.length == 2
        table = Arel::Table.new table_column.first
        column = table_column.second
      else
        table = arel_table
      end

      # Enumns don't play well with Arel::Predications#matches, so this hack is necessary
      if column.to_s.in?(defined_enums)
        ordinal_value = defined_enums[column.to_s][search_term]

        return self unless ordinal_value
        return where(column => ordinal_value)
      end

      p table[column]

      if column.ONKO_TÄÄ_NUMEERINEN_INTTI_TAI_DESIMAALI?
        return where(column => search_term)
      end

      where(table[column].matches("%#{search_term}%"))
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
