class Finvoice
  include ActionView::Helpers::NumberHelper

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
        sellerpartydetails
      }

      sellerinfo

      doc.SellerInformationDetails {
        sellerinfodetails
      }

      recipientdetails

      buyerpartydetails

      deliverypartydetails

      doc.DeliveryDetails {
        deliverydetails
      }

      doc.InvoiceDetails {
        invoicedetails
      }

      doc.PaymentStatusDetails {
        paymentstatus
      }

      invoicerows

      doc.EpiDetails {
        epidetails
      }
    }

    procinst = Nokogiri::XML::ProcessingInstruction.new(doc.doc, "xml-stylesheet",
                                                 'href="Finvoice.xsl" type="text/xsl" ')
    doc.doc.root.add_previous_sibling procinst

    return_valid_xml
  end

  private
    def doc
      @document
    end

    def finvoice_number(num)
      number_to_currency(num, separator: ",", delimiter: "", format: "%n")
    end

    def company_contact_details
      if @invoice.location
        # Invoice has specific location
        {
          puhelin: @invoice.location.puhelin,
          fax:     @invoice.location.fax,
          email:   @invoice.location.email,
          www:     @invoice.location.www,
        }
      else
        # Default sender details
        {
          puhelin: @invoice.company.puhelin,
          fax:     @invoice.company.fax,
          email:   @invoice.company.email,
          www:     @invoice.company.www,
        }
      end
    end

    def return_valid_xml
      file = Rails.root.join 'vendor', 'assets', 'finvoice', 'Finvoice2.01.xsd'
      xsd = Nokogiri::XML::Schema(File.read(file))

      kala = Nokogiri::XML(doc.to_xml)

      xsd.validate(kala).each do |error|
        puts error.message
      end

      File.write("/tmp/finvoice201.xml", doc.to_xml)
      doc.to_xml
    end

    def print_service_code(senderintermediator)
      case senderintermediator
      when "NDEAFIHH"
        return "tulostukseen"
      when "PSPBFIHH"
        return "003718062728810P"
      when "DABAFIHH"
        return "003718062728810P"
      when "HELSFIHH"
        return "TULOSTUSPALVELU"
      when "OKOYFIHH"
        return "TULOSTUSPALVELU"
      when "003710948874"
        return "EKIRJE"
      when "003723327487"
        return "TULOSTUS"
      when "003721291126"
        return "PRINT"
      when "ITELFIHH"
        return "TULOSTUSPALVELU"
      else
        return nil
      end
    end

    def receiver_details
      receiverpartyid = ""
      receiverintermediator = ""

      if @invoice.company.parameter.ipost?
        # Posti Ipost
        receiverpartyid = @invoice.verkkotunnus
        receiverintermediator = "003710948874"
      elsif @invoice.verkkotunnus.index("@")
        receiverpartyid, receiverintermediator = @invoice.verkkotunnus.split("@")
      else
        receiverpartyid = @invoice.verkkotunnus
        receiverintermediator = ""
      end

      # If we are using Apix and we have no receiverintermediator,
      # we put Apix's OVT as receiverintermediator
      if receiverintermediator.empty? && @invoice.company.parameter.apix?
        receiverintermediator = "003723327487"
      end

      # If we are still missing the receiverintermediator, we put the sender's
      # senderintermediator as the receiverintermediator
      # If we are using Maventa, we can leave the receiverintermediator empty
      if receiverintermediator.empty? && !@invoice.company.parameter.maventa?
        receiverintermediator = @invoice.company.parameter.finvoice_senderintermediator
      end

      # If we have no receiverpartyid, or our invoice is going to print service
      if (receiverpartyid.empty? && !@invoice.company.parameter.apix?) || @invoice.finvoice_printservice?
        receiverpartyid = print_service_code(receiverintermediator)
      end

      [receiverpartyid, receiverintermediator]
    end

    def senderdetails
      sndid = @invoice.company.parameter.finvoice_senderpartyid
      doc.FromIdentifier sndid

      sndint = @invoice.company.parameter.finvoice_senderintermediator
      doc.FromIntermediator sndint
    end

    def receiverdetails
      toid, toint = receiver_details
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

    def sellerpartydetails
      doc.SellerPartyIdentifier @invoice.company.ytunnus_human
      doc.SellerOrganisationName @invoice.yhtio_nimi
      doc.SellerOrganisationTaxCode @invoice.company_vatnumber_human
      doc.SellerPostalAddressDetails {
        doc.SellerStreetName @invoice.yhtio_osoite
        doc.SellerTownName @invoice.yhtio_postitp
        doc.SellerPostCodeIdentifier @invoice.yhtio_postino
        doc.CountryCode @invoice.yhtio_maa
        doc.CountryName @invoice.yhtio_maa
      }
    end

    def sellerinfo
      companyinfo = company_contact_details

      doc.SellerOrganisationUnitNumber @invoice.yhtio_ovttunnus
      doc.SellerContactPersonName @invoice.seller.nimi

      doc.SellerCommunicationDetails {
       doc.SellerPhoneNumberIdentifier companyinfo[:puhelin]
       doc.SellerEmailaddressIdentifier companyinfo[:email]
      }
    end

    def sellerinfodetails
      companyinfo = company_contact_details

      doc.SellerHomeTownName @invoice.yhtio_kotipaikka
      doc.SellerVatRegistrationText "Alv.Rek"
      doc.SellerPhoneNumber companyinfo[:puhelin]
      doc.SellerFaxNumber companyinfo[:fax]
      doc.SellerCommonEmailaddressIdentifier companyinfo[:email]
      doc.SellerWebaddressIdentifier companyinfo[:www]

      @invoice.terms_of_payment.bank_account_details.each do |account|
        doc.SellerAccountDetails {
          doc.SellerAccountID("IdentificationSchemeName" => "IBAN") {
            doc.text(account[:iban])
          }
          doc.SellerBic("IdentificationSchemeName" => "BIC") {
            doc.text(account[:bic])
          }
        }
      end
    end

    def recipientdetails
      if @invoice.has_separate_invoice_recipient
        doc.InvoiceRecipientPartyDetails {
          doc.InvoiceRecipientPartyIdentifier @invoice.ytunnus_human
          doc.InvoiceRecipientOrganisationName @invoice.extra.laskutus_nimi
          doc.InvoiceRecipientOrganisationName @invoice.extra.laskutus_nimitark

          if @invoice.company.parameter.maventa?
            # Maventa ei salli tyhjänä, optionaalinen
            doc.InvoiceRecipientOrganisationTaxCode @invoice.vatnumber_human
          end

          doc.InvoiceRecipientPostalAddressDetails {
            doc.InvoiceRecipientStreetName @invoice.extra.laskutus_osoite
            doc.InvoiceRecipientTownName @invoice.extra.laskutus_postitp
            doc.InvoiceRecipientPostCodeIdentifier @invoice.extra.laskutus_postino
            doc.CountryCode @invoice.extra.laskutus_maa
            doc.CountryName @invoice.extra.laskutus_maa
          }
        }

        doc.InvoiceRecipientOrganisationUnitNumber @invoice.ovttunnus
      end
    end

    def buyerpartydetails
      doc.BuyerPartyDetails {
        doc.BuyerPartyIdentifier @invoice.ytunnus_human
        doc.BuyerOrganisationName @invoice.nimi
        doc.BuyerOrganisationName @invoice.nimitark
        doc.BuyerOrganisationTaxCode @invoice.vatnumber_human
        doc.BuyerPostalAddressDetails {
          doc.BuyerStreetName @invoice.osoite
          doc.BuyerTownName @invoice.postitp
          doc.BuyerPostCodeIdentifier @invoice.postino
          doc.CountryCode @invoice.maa
          doc.CountryName @invoice.maa
        }
      }

      doc.BuyerOrganisationUnitNumber @invoice.ovttunnus
      doc.BuyerContactPersonName @invoice.contact_person_name
    end

    def deliverypartydetails
      doc.DeliveryPartyDetails {
        doc.DeliveryPartyIdentifier @invoice.ytunnus_human
        doc.DeliveryOrganisationName @invoice.toim_nimi
        doc.DeliveryOrganisationName @invoice.toim_nimitark
        doc.DeliveryOrganisationTaxCode @invoice.vatnumber_human
        doc.DeliveryPostalAddressDetails {
          doc.DeliveryStreetName @invoice.toim_osoite
          doc.DeliveryTownName @invoice.toim_postitp
          doc.DeliveryPostCodeIdentifier @invoice.toim_postino
          doc.CountryCode @invoice.toim_maa
          doc.CountryName @invoice.toim_maa
        }
      }

      doc.DeliveryOrganisationUnitNumber @invoice.toim_ovttunnus
    end

    def deliverydetails
      doc.DeliveryPeriodDetails {
        doc.StartDate("Format" => "CCYYMMDD") {
          doc.text(@invoice.deliveryperiod_start.strftime("%Y%m%d"))
        }
        doc.EndDate("Format" => "CCYYMMDD") {
          doc.text(@invoice.deliveryperiod_end.strftime("%Y%m%d"))
        }
      }
      doc.DeliveryMethodText @invoice.toimitustapa
      doc.DeliveryTermsText @invoice.toimitusehto
    end

    def invoicedetails
      if @invoice.credit?
        doc.InvoiceTypeCode "INV02"
        doc.InvoiceTypeText "HYVITYSLASKU"
      else
        doc.InvoiceTypeCode "INV01"
        doc.InvoiceTypeText "LASKU"
      end

      doc.OriginCode "Original"
      doc.InvoiceNumber @invoice.laskunro
      doc.InvoiceDate("Format" => "CCYYMMDD") {
        doc.text(@invoice.tapvm.strftime("%Y%m%d"))
      }
      doc.SellerReferenceIdentifier @invoice.tunnus

      if @invoice.asiakkaan_tilausnumero.strip.present?
        doc.OrderIdentifier @invoice.asiakkaan_tilausnumero
      else
        doc.OrderIdentifier @invoice.viesti
      end

      doc.AgreementIdentifier @invoice.viesti

      doc.InvoiceTotalVatExcludedAmount("AmountCurrencyIdentifier" => @invoice.valkoodi) {
        doc.text(finvoice_number(@invoice.arvo_valuutassa))
      }
      doc.InvoiceTotalVatAmount("AmountCurrencyIdentifier" => @invoice.valkoodi) {
        alv = (@invoice.summa_valuutassa - @invoice.arvo_valuutassa).round(2)
        doc.text(finvoice_number(alv))
      }
      doc.InvoiceTotalVatIncludedAmount("AmountCurrencyIdentifier" => @invoice.valkoodi) {
        doc.text(finvoice_number(@invoice.summa_valuutassa))
      }

      @invoice.vat_specification.each do |vat|
        doc.VatSpecificationDetails {
          doc.VatBaseAmount("AmountCurrencyIdentifier" =>  @invoice.valkoodi) {
            doc.text(finvoice_number(vat[:base_amount]))
          }
          doc.VatRatePercent finvoice_number(vat[:vat_rate])
          doc.VatRateAmount("AmountCurrencyIdentifier" =>  @invoice.valkoodi) {
           doc.text(finvoice_number(vat[:vat_amount]))
          }

          if @invoice.reverse_charge
            doc.VatFreeText "Ostaja verovelvollinen AVL 8c §"
          end
        }
      end

      doc.InvoiceFreeText @invoice.public_comment

      doc.PaymentTermsDetails {
        doc.PaymentTermsFreeText @invoice.terms_of_payment.teksti
        doc.InvoiceDueDate("Format" => "CCYYMMDD") {
          doc.text(@invoice.erpcm.strftime("%Y%m%d"))
        }

        if @invoice.kasumma_valuutassa != 0
          doc.CashDiscountDate("Format" => "CCYYMMDD") {
            doc.text(@invoice.kapvm.strftime("%Y%m%d"))
          }
          doc.CashDiscountBaseAmount("AmountCurrencyIdentifier" =>  @invoice.valkoodi) {
            doc.text(finvoice_number(@invoice.summa_valuutassa))
          }
          doc.CashDiscountPercent finvoice_number(@invoice.terms_of_payment.kassa_alepros)
          doc.CashDiscountAmount("AmountCurrencyIdentifier" =>  @invoice.valkoodi) {
            doc.text(finvoice_number(@invoice.kasumma_valuutassa))
          }
        end

        doc.PaymentOverDueFineDetails {
          korko = finvoice_number(@invoice.viikorkopros)

          doc.PaymentOverDueFineFreeText "Viivästyskorko #{korko}%"
          doc.PaymentOverDueFinePercent korko
        }
      }
    end

    def paymentstatus
      doc.PaymentStatusCode "NOTPAID"
    end

    def invoicerows
      @invoice.rows.each do |row|
        doc.InvoiceRow {
          doc.ArticleIdentifier row.tuoteno
          doc.ArticleName row.nimitys
          doc.DeliveredQuantity("QuantityUnitCode" => row.yksikko) {
            doc.text(finvoice_number(row.kpl))
          }
          doc.OrderedQuantity("QuantityUnitCode" => row.yksikko) {
            doc.text(finvoice_number(row.tilkpl))
          }
          doc.UnitPriceAmount("AmountCurrencyIdentifier" => @invoice.valkoodi) {
            doc.text(finvoice_number(row.hinta_valuutassa))
          }

          if row.tilaajanrivinro > 0
            doc.RowIdentifier row.tilaajanrivinro
          end

          if row.order.luontiaika.strftime("%Y%m%d") < row.delivery_date.strftime("%Y%m%d")
            doc.RowIdentifierDate("Format" => "CCYYMMDD") {
              doc.text(row.order.luontiaika.strftime("%Y%m%d"))
            }
          end

          doc.RowDeliveryIdentifier row.order.id

          doc.RowDeliveryDate("Format" => "CCYYMMDD") {
            doc.text(row.delivery_date.strftime("%Y%m%d"))
          }

          if row.invoice_comment.present?
            doc.RowFreeText row.invoice_comment
          end

          doc.RowDiscountPercent finvoice_number(row.total_discount)
          doc.RowVatRatePercent finvoice_number(row.vat_percent)
          doc.RowVatAmount("AmountCurrencyIdentifier" => @invoice.valkoodi) {
            doc.text(finvoice_number(row.vat_amount))
          }
          doc.RowVatExcludedAmount("AmountCurrencyIdentifier" => @invoice.valkoodi) {
            doc.text(finvoice_number(row.rivihinta_valuutassa))
          }
          doc.RowAmount("AmountCurrencyIdentifier" => @invoice.valkoodi) {
            doc.text(finvoice_number(row.rivihinta_verollinen))
          }
        }
      end
    end

    def epidetails
      doc.EpiIdentificationDetails {
        doc.EpiDate("Format" => "CCYYMMDD") {
          doc.text(@invoice.tapvm.strftime("%Y%m%d"))
        }
        doc.EpiReference @invoice.viite
      }

      bank_account = @invoice.terms_of_payment.bank_account_details.first

      doc.EpiPartyDetails {
        doc.EpiBfiPartyDetails {
          doc.EpiBfiIdentifier("IdentificationSchemeName" => "BIC") {
            doc.text(bank_account[:bic])
          }
        }
        doc.EpiBeneficiaryPartyDetails {
          doc.EpiNameAddressDetails @invoice.company.nimi
          doc.EpiBei @invoice.company.ytunnus_human
          doc.EpiAccountID("IdentificationSchemeName" => "IBAN") {
            doc.text(bank_account[:iban])
          }
        }
      }
      doc.EpiPaymentInstructionDetails {
        doc.EpiPaymentInstructionId "192837465"
        doc.EpiRemittanceInfoIdentifier("IdentificationSchemeName" => "ISO") {
          doc.text("RF471234567890")
        }
        doc.EpiInstructedAmount("AmountCurrencyIdentifier" => @invoice.valkoodi) {
          doc.text(finvoice_number(@invoice.summa_valuutassa))
        }
        doc.EpiCharge("ChargeOption" => "SLEV") {
        }
        doc.EpiDateOptionDate("Format" => "CCYYMMDD") {
          doc.text(@invoice.erpcm.strftime("%Y%m%d"))
        }
      }
    end
end
