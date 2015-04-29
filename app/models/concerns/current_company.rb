module CurrentCompany
  extend ActiveSupport::Concern

  included do
    after_initialize do |record|
      record.company = Company.current if Company.current
    end
  end

  module ClassMethods
    def default_scope
      where(company: Company.current) if Company.current
    end
  end
end
