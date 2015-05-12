module CurrentCompany
  extend ActiveSupport::Concern

  included do
    after_initialize do |record|
      record.company ||= Current.company
    end

    if name.constantize == FixedAssets::Commodity
      modern_scope
    else
      legacy_scope
    end
  end

  module ClassMethods
    def modern_scope
      validates :company, presence: true
      default_scope -> do
        raise CurrentCompanyNil if Current.company.nil?
        where(company: Current.company)
      end
    end

    def legacy_scope
      validates :yhtio, presence: true
      default_scope -> do
        raise CurrentCompanyNil if Current.company.nil?
        where(yhtio: Current.company.yhtio)
      end
    end
  end
end
