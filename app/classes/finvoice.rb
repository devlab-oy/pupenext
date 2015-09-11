class Finvoice
  def initialize(invoice_id:, soap: true)
    @invoice = Head::SalesInvoice.find invoice_id
    @soap = soap
    @document = Nokogiri::XML::Builder.new(encoding: 'ISO-8859-15') do |xml|
    end
  end

  def to_xml

    doc.Finvoice(
      "Version" => "2.01",
      "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance",
      "xsi:noNamespaceSchemaLocation" => "Finvoice2.01.xsd") {

      doc.MessageTransmissionDetails {
        doc.MessageSenderDetails {
          senderdetails
        }
        doc.MessageReceiverDetails {
          receiverdetails
        }
        doc.MessageDetails {
          messagedetails
        }
      }
      doc.SellerPartyDetails {
        doc.SellerPartyIdentifier "9876543-0"
        doc.SellerPartyIdentifierUrlText ""
        doc.SellerOrganisationName "Pullin Musiikki oy "
        doc.SellerOrganisationName "Pullis Musik Ab"
        doc.SellerOrganisationDepartment ""
        doc.SellerOrganisationDepartment ""
        doc.SellerOrganisationTaxCode "FI98765430"
        doc.SellerPostalAddressDetails {
          doc.SellerStreetName "StreetName 99"
          doc.SellerTownName "Helsinki"
          doc.SellerPostCodeIdentifier "00100"
          doc.CountryCode "FI"
        }
      }
      doc.SellerInformationDetails {
        doc.SellerAccountDetails {
          doc.SellerAccountID("IdentificationSchemeName" => "IBAN") {
            doc.text("FI4819503000000010")
          }
          doc.SellerBic("IdentificationSchemeName" => "BIC") {
            doc.text("BANKFIHH")
          }
        }
        doc.SellerAccountDetails {
          doc.SellerAccountID("IdentificationSchemeName" => "IBAN") {
            doc.text("FI3819503000086423")
          }
          doc.SellerBic("IdentificationSchemeName" => "BIC") {
            doc.text("BANKFIHH")
          }
        }
        doc.SellerAccountDetails {
          doc.SellerAccountID("IdentificationSchemeName" => "IBAN") {
            doc.text("FI7429501800000014")
          }
          doc.SellerBic("IdentificationSchemeName" => "BIC") {
            doc.text("BANKFIHH")
          }
        }
      }
      doc.BuyerPartyDetails {
        doc.BuyerPartyIdentifier "7654321-2"
        doc.BuyerOrganisationName "Purjehdusseura Bitti ja Baatti ry"
        doc.BuyerOrganisationDepartment ""
        doc.BuyerOrganisationDepartment ""
        doc.BuyerOrganisationTaxCode "FI76543212"
        doc.BuyerPostalAddressDetails {
          doc.BuyerStreetName "Sempalokatu 2"
          doc.BuyerTownName "Tampere"
          doc.BuyerPostCodeIdentifier "00122"
          doc.CountryCode "FI"
          doc.CountryName "Suomi"
          doc.BuyerPostOfficeBoxIdentifier ""
        }
      }
      doc.DeliveryDetails {
        doc.DeliveryDate("Format" => "CCYYMMDD") {
          doc.text("20130812")
        }
      }
      doc.InvoiceDetails {
        doc.InvoiceTypeCode "INV01"
        doc.InvoiceTypeText "Invoice"
        doc.OriginCode "Original"
        doc.InvoiceNumber "2013000018"
        doc.InvoiceDate("Format" => "CCYYMMDD") {
          doc.text("20130814")
        }
        doc.OrderIdentifier "20130801"
        doc.InvoiceTotalVatExcludedAmount("AmountCurrencyIdentifier" => "EUR") {
          doc.text("133,50")
        }
        doc.InvoiceTotalVatAmount("AmountCurrencyIdentifier" => "EUR") {
          doc.text("32,04")
        }
        doc.InvoiceTotalVatIncludedAmount("AmountCurrencyIdentifier" => "EUR") {
          doc.text("165,54")
        }
        doc.VatSpecificationDetails {
          doc.VatBaseAmount("AmountCurrencyIdentifier" => "EUR") {
            doc.text("133,50")
          }
          doc.VatRatePercent "24,0"
          doc.VatRateAmount("AmountCurrencyIdentifier" => "EUR") {
            doc.text("32,04")
          }
        }
        doc.PaymentTermsDetails {
          doc.PaymentTermsFreeText "14 päivää netto"
          doc.InvoiceDueDate("Format" => "CCYYMMDD") {
            doc.text("20130828")
          }
          doc.PaymentOverDueFineDetails {
            doc.PaymentOverDueFineFreeText "Viivästyskorko"
            doc.PaymentOverDueFinePercent "7,5"
          }
        }
      }
      doc.PaymentStatusDetails {
        doc.PaymentStatusCode "NOTPAID"
      }
      doc.InvoiceRow {
        doc.ArticleIdentifier "12"
        doc.ArticleName "Nuottivihko"
        doc.DeliveredQuantity("QuantityUnitCode" => "kpl") {
          doc.text("89")
        }
        doc.OrderedQuantity "100"
        doc.InvoicedQuantity("QuantityUnitCode" => "EUR") {
          doc.text("165,54")
        }
        doc.UnitPriceAmount("AmountCurrencyIdentifier" => "EUR") {
          doc.text("1,50")
        }
        doc.RowPositionIdentifier "1"
        doc.RowFreeText "Puuttuvat toimitetaan mahdollisimman pian"
        doc.RowVatRatePercent "24,0"
        doc.RowVatAmount("AmountCurrencyIdentifier" => "EUR") {
          doc.text("32,04")
        }
        doc.RowVatExcludedAmount("AmountCurrencyIdentifier" => "EUR") {
          doc.text("133,50")
        }
      }
      doc.EpiDetails {
        doc.EpiIdentificationDetails {
          doc.EpiDate("Format" => "CCYYMMDD") {
            doc.text("20130814")
          }
          doc.EpiReference "0"
        }
        doc.EpiPartyDetails {
          doc.EpiBfiPartyDetails {
            doc.EpiBfiIdentifier("IdentificationSchemeName" => "BIC") {
              doc.text("BANKFIHH")
            }
          }
          doc.EpiBeneficiaryPartyDetails {
            doc.EpiNameAddressDetails "Pullin Musiikki Oy"
            doc.EpiBei "5647382910"
            doc.EpiAccountID("IdentificationSchemeName" => "IBAN") {
              doc.text("FI3329501800008512")
            }
          }
        }
        doc.EpiPaymentInstructionDetails {
          doc.EpiPaymentInstructionId "192837465"
          doc.EpiRemittanceInfoIdentifier("IdentificationSchemeName" => "ISO") {
            doc.text("RF471234567890")
          }
          doc.EpiInstructedAmount("AmountCurrencyIdentifier" => "EUR") {
            doc.text("165,54")
          }
          doc.EpiCharge("ChargeOption" => "SLEV") {
          }
          doc.EpiDateOptionDate("Format" => "CCYYMMDD") {
            doc.text("20130828")
          }
        }
      }
    }

    procinst = Nokogiri::XML::ProcessingInstruction.new(doc.doc, "xml-stylesheet",
                                                 'href="Finvoice.xsl" type="text/xsl" ')
    doc.doc.root.add_previous_sibling procinst
    doc.to_xml
  end

  private
    def doc
      @document
    end

    def senderdetails
      sndid = @invoice.company.parameter.finvoice_senderpartyid
      doc.FromIdentifier sndid

      sndint = @invoice.company.parameter.finvoice_senderintermediator
      doc.FromIntermediator sndint
    end

    def receiverdetails
      toid, toint = FinvoiceDetail.receiver_details @invoice
      doc.ToIdentifier toid
      doc.ToIntermediator toint
    end

    def messagedetails
      timenow = Time.now.strftime("%Y%m%d%H%M%S")
      mid = "#{timenow}-#{@invoice.laskunro}";
      tstamp = Time.now.strftime("%Y-%m-%dT%H:%M:%S")

      doc.MessageIdentifier mid
      doc.MessageTimeStamp tstamp
    end

    def rows
      @invoice.rows.each do |row|
        row.tuoteno
        row.nimitys
      end
    end
end
