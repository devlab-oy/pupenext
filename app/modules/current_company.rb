module CurrentCompany
  extend ActiveSupport::Concern

  included do
    after_initialize do |record|
      record.company ||= Company.current
    end

    default_scope { where(company: Company.current) } if Company.current
  end
end
