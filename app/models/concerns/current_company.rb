module CurrentCompany
  extend ActiveSupport::Concern

  included do
    after_initialize do |record|
      record.company ||= Company.current if Company.current
    end

    # This works
    default_scope { where(yhtio: Company.current.yhtio) } if Company.current
  end

  # This doesnt. Nor does any else class method implementation
  module ClassMethods
    def default_scope
      l = lambda do |company|
        where(company: company)
      end

      l.call(Company.current) if Company.current
    end
  end
end
