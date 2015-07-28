class Finvoice
  def initialize(invoice_id:)
    @invoice = Head::SalesInvoice.find invoice_id
  end

  def to_xml
    builder = Nokogiri::XML::Builder.new do
      root {
        kissa "whee"
      }
    end

    builder.to_xml
  end
end
