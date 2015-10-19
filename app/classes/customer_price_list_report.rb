class CustomerPriceListReport
  def initialize(company_id:, user_id:, html:, binary:)
    Current.company = Company.find(company_id)
    Current.user    = User.find(user_id)
    @html           = html
  end

  def to_file
    kit = PDFKit.new @html

    kit.stylesheets << Rails.root.join('app', 'assets', 'stylesheets', 'report.css')

    filename = Tempfile.new(%w(customer_price_list- .pdf)).path

    kit.to_file(filename).path
  end
end
