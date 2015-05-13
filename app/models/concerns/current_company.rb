module CurrentCompany
  extend ActiveSupport::Concern

  included do
    after_initialize do |record|
      record.company ||= Current.company
    end

    default_scope -> do
      raise CurrentCompanyNil if Current.company.nil?
      where(company: Current.company)
    end

    validates :company, presence: true
  end
end
