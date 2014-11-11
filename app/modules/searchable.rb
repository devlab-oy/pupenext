module Searchable
  def search_like(args)
    result = self.all

    args.each do |key, value|
      if exact_search? value
        value = exact_search value
        result = where(key => value)
      else
        result = where_like key, value
      end
    end

    result
  end

  def where_like(column, search_term)
    where(self.arel_table[column].matches "%#{search_term}%")
  end
end
