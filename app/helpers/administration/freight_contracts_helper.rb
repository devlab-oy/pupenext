module Administration::FreightContractsHelper
  def customer_text(customer_name)
    customer_name.present? ? customer_name : "*#{t("administration.freight_contract.index.no_customer")}*"
  end
end
