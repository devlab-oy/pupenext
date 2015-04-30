module CurrentCompany
  extend ActiveSupport::Concern

  included do
    after_initialize do |record|
      record.company ||= Company.current if Company.current
    end

    validates :company, presence: true

    default_scope { where(yhtio: Company.current.yhtio) } if Company.current
  end
end
