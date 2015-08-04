module TermsOfPaymentHelper
  ROOT = 'administration.terms_of_payments'

  def cash_options
    TermsOfPayment.kateinens.map do |key,_|
      [ t("#{ROOT}.cash_options.#{key}"), key ]
    end
  end

  def in_use_options
    TermsOfPayment.kaytossas.map do |key,_|
      [ t("#{ROOT}.in_use_options.#{key}"), key ]
    end
  end
end
