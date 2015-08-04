module TermsOfPaymentHelper
  ROOT = 'administration.terms_of_payments'

  def cash_options
    TermsOfPayment.kateinens.map do |key, value|
      [ t("#{ROOT}.cash_options.#{key}"), value ]
    end
  end

  def in_use_options
    TermsOfPayment.kaytossas.map do |key, value|
      [ t("#{ROOT}.in_use_options.#{key}"), value ]
    end
  end
end
