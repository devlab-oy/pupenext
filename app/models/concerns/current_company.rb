module CurrentCompany
  extend ActiveSupport::Concern

  included do
    default_scope -> do
      raise CurrentCompanyNil if Current.company.nil?
      where(company: Current.company)
    end

    validates :company, presence: true
  end
end
