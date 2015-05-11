module CurrentCompany
  extend ActiveSupport::Concern

  included do
    after_initialize do |record|
      record.company ||= Current.company
    end

    if name.constantize == FixedAssets::Commodity
      validates :company, presence: true
      default_scope -> do
        raise CurrentCompanyNil if Current.company.nil?
        where(company: Current.company)
      end
    else
      validates :yhtio, presence: true
      default_scope -> do
        raise CurrentCompanyNil if Current.company.nil?
        where(yhtio: Current.company.yhtio)
      end
    end
  end
end
