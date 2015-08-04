module TermsOfPaymentHelper
  def cash_options
    root = 'administration.terms_of_payments.cash_options'

    TermsOfPayment.kateinens.map do |key, value|
      [ t("#{root}.#{key}"), value ]
    end
  end
end
