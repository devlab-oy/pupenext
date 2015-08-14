module PupenextSingleTableInheritance
  extend ActiveSupport::Concern

  # To use this concern model must implement 'child_class_names' class method.
  # This should return hash, where the key is string value stored into the database and
  # value is the class that represents the value.
  #
  # def self.child_class_names
  #   {
  #     'FOO' => YourModule::YourClass
  #   }
  # end

  class_methods do

    def child_class(value)
      child_class_names[value.to_s]
    end

    # This functions purpose is to return the child class name.
    # Aka. it should allways return .constantize
    # This function is called from   persistence.rb function: instantiate
    #                             -> inheritance.rb function: discriminate_class_for_record
    # This is the reason we need to map the db column with correct child class in this model
    # type_name = "S", type_name = "U" ...
    def find_sti_class(value)
      child_class value
    end

    # This method is originally defined in inheritance.rb and needs to be overridden, so that
    # rails knows how to initialize a proper subclass because the subclass name is different than the
    # value in the inheritance column.
    def subclass_from_attributes(attrs)
      subclass_name = attrs.with_indifferent_access[inheritance_column]
      subclass_name = child_class(subclass_name).to_s

      if subclass_name.present? && subclass_name != self.name
        return subclass_name.safe_constantize
      end

      nil
    end
  end
end
