module Administration::FreightContractsHelper
  def customer_text(customer_name)
    customer_name.present? ? customer_name : "*#{t("tyhjä")}*"
  end
end
