module CurrentCompany
  extend ActiveSupport::Concern

  included do
    default_scope -> do
      if ActiveRecord::Base.connection.column_exists?(table_name, :yhtio) || ActiveRecord::Base.connection.column_exists?(table_name, :company_id)
        raise CurrentCompanyNil if Current.company.nil?
        where(company: Current.company)
      end
    end

    belongs_to :company, foreign_key: :yhtio, primary_key: :yhtio

    validates :company, presence: true
  end
end
