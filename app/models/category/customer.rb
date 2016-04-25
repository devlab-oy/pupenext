# we need to require this here, so we won't get namespace warnings
require 'customer'

class Category::Customer < Category
  # Rails requires sti_name method to return type column (laji) value
  def self.sti_name
    'asiakas'
  end
end
