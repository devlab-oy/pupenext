class Administration::BankDetailsController < AdministrationController
  def index
    @bank_details = current_company.bank_details
  end
end
