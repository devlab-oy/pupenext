module AttributeSanitator

  def float_columns(*columns)
    columns.each do |column|
      define_method("#{column}=") do |val|
        val = val.tr(',', '.') if val.respond_to? :tr
        super val
      end
    end
  end

end
