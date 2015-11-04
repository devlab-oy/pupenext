xml.instruct! :xml, version: "1.0", encoding: "ISO-8859-15"
xml.instruct! 'xml-stylesheet',  href: "Finvoice.xsl", type: "text/xsl"

attributes = {
  'xmlns:xsi' => "http://www.w3.org/2001/XMLSchema-instance",
  'Version' => "2.01",
  'xsi:noNamespaceSchemaLocation' => "Finvoice2.01.xsd",
}

xml.Finvoice(attributes) do
  xml.MessageTransmissionDetails do
    xml.MessageSenderDetails do
      xml.FromIdentifier "1234567890"
      xml.FromIntermediator "HELSFIHH"
    end

    xml.MessageReceiverDetails do
      xml.ToIdentifier "0987654321"
      xml.ToIntermediator "BANKFIHH"
    end

    xml.MessageDetails do
      xml.MessageIdentifier "123"
      xml.MessageTimeStamp "2013-08-14T12:17:50"
    end
  end

  xml.SellerPartyDetails do
    xml.SellerPartyIdentifier "9876543-0"
    xml.SellerPartyIdentifierUrlText nil
    xml.SellerOrganisationName "Pullin Musiikki oy"
    xml.SellerOrganisationName "Pullis Musik Ab"
    xml.SellerOrganisationDepartment nil
    xml.SellerOrganisationDepartment nil
    xml.SellerOrganisationTaxCode "FI98765430"

    xml.SellerPostalAddressDetails do
      xml.SellerStreetName "StreetName 99"
      xml.SellerTownName "Helsinki"
      xml.SellerPostCodeIdentifier "00100"
      xml.CountryCode "FI"
    end
  end

  xml.SellerInformationDetails do
    xml.SellerAccountDetails do
      xml.SellerAccountID "FI4819503000000010", "IdentificationSchemeName" => "IBAN"
      xml.SellerBic "BANKFIHH", "IdentificationSchemeName" => "BIC"
    end

    xml.SellerAccountDetails do
      xml.SellerAccountID "FI3819503000086423", "IdentificationSchemeName" => "IBAN"
      xml.SellerBic "BANKFIHH", "IdentificationSchemeName" => "BIC"
    end

    xml.SellerAccountDetails do
      xml.SellerAccountID "FI7429501800000014", "IdentificationSchemeName" => "IBAN"
      xml.SellerBic "BANKFIHH", "IdentificationSchemeName" => "BIC"
    end
  end

  xml.BuyerPartyDetails do
    xml.BuyerPartyIdentifier "7654321-2"
    xml.BuyerOrganisationName "Purjehdusseura Bitti ja Baatti ry"
    xml.BuyerOrganisationDepartment nil
    xml.BuyerOrganisationDepartment nil
    xml.BuyerOrganisationTaxCode "FI76543212"

    xml.BuyerPostalAddressDetails do
      xml.BuyerStreetName "Sempalokatu 2"
      xml.BuyerTownName "Tampere"
      xml.BuyerPostCodeIdentifier "00122"
      xml.CountryCode "FI"
      xml.CountryName "Suomi"
      xml.BuyerPostOfficeBoxIdentifier nil
    end
  end

  xml.DeliveryDetails do
    xml.DeliveryPeriodDetails do
      xml.StartDate "20151003", "Format" => "CCYYMMDD"
      xml.EndDate "20151004", "Format" => "CCYYMMDD"
    end

    xml.DeliveryMethodText "Posten Logistik"
    xml.DeliveryTermsText "EXW Helsinki"
  end

  xml.InvoiceDetails do
    xml.InvoiceTypeCode "INV01"
    xml.InvoiceTypeText "Invoice"
    xml.OriginCode "Original"
    xml.InvoiceNumber "2013000018"
    xml.InvoiceDate "20151010", "Format" => "CCYYMMDD"
    xml.SellerReferenceIdentifier "1037272446"
    xml.OrderIdentifier "20130801"
    xml.AgreementIdentifier "Hauki on kala"
    xml.InvoiceTotalVatExcludedAmount "1477,00", "AmountCurrencyIdentifier" => "EUR"
    xml.InvoiceTotalVatAmount "354,48", "AmountCurrencyIdentifier" => "EUR"
    xml.InvoiceTotalVatIncludedAmount "1831,48", "AmountCurrencyIdentifier" => "EUR"

    xml.VatSpecificationDetails do
      xml.VatBaseAmount "1477,00", "AmountCurrencyIdentifier" => "EUR"
      xml.VatRatePercent "24,00"
      xml.VatRateAmount "354,48", "AmountCurrencyIdentifier" => "EUR"
    end

    xml.PaymentTermsDetails do
      xml.PaymentTermsFreeText "14 päivää netto"
      xml.InvoiceDueDate "20130828", "Format" => "CCYYMMDD"

      xml.PaymentOverDueFineDetails do
        xml.PaymentOverDueFineFreeText "Viivästyskorko"
        xml.PaymentOverDueFinePercent "7,5"
      end
    end
  end

  xml.PaymentStatusDetails do
    xml.PaymentStatusCode "NOTPAID"
  end

  xml.InvoiceRow do
    xml.ArticleIdentifier "PNV"
    xml.ArticleName "Nuottivihko"
    xml.DeliveredQuantity "1,00", "QuantityUnitCode" => "kpl"
    xml.OrderedQuantity "100,00", "QuantityUnitCode" => "kpl"
    xml.InvoicedQuantity "165,54", "QuantityUnitCode" => "EUR"
    xml.UnitPriceAmount "133,50", "AmountCurrencyIdentifier" => "EUR"
    xml.RowPositionIdentifier "1"
    xml.RowFreeText "Puuttuvat toimitetaan mahdollisimman pian"
    xml.RowVatRatePercent "24,0"
    xml.RowVatAmount "32,04", "AmountCurrencyIdentifier" => "EUR"
    xml.RowVatExcludedAmount "133,50", "AmountCurrencyIdentifier" => "EUR"
  end

  xml.InvoiceRow do
    xml.ArticleIdentifier "PNP"
    xml.ArticleName "Piano"
    xml.DeliveredQuantity "1,00", "QuantityUnitCode" => "kpl"
    xml.OrderedQuantity "1,00", "QuantityUnitCode" => "kpl"
    xml.InvoicedQuantity "1665,94", "QuantityUnitCode" => "EUR"
    xml.UnitPriceAmount "1343,50", "AmountCurrencyIdentifier" => "EUR"
    xml.RowPositionIdentifier "2"
    xml.RowFreeText "Musta piano"
    xml.RowVatRatePercent "24,00"
    xml.RowVatAmount "322,44", "AmountCurrencyIdentifier" => "EUR"
    xml.RowVatExcludedAmount "1343,50", "AmountCurrencyIdentifier" => "EUR"
  end

  xml.EpiDetails do
    xml.EpiIdentificationDetails do
      xml.EpiDate "20151010", "Format" => "CCYYMMDD"
      xml.EpiReference "123"
    end

    xml.EpiPartyDetails do
      xml.EpiBfiPartyDetails do
        xml.EpiBfiIdentifier "BANKFIHH", "IdentificationSchemeName" => "BIC"
      end

      xml.EpiBeneficiaryPartyDetails do
        xml.EpiNameAddressDetails "Pullin Musiikki Oy"
        xml.EpiBei "9876543-0"
        xml.EpiAccountID "FI4819503000000010", "IdentificationSchemeName" => "IBAN"
      end
    end

    xml.EpiPaymentInstructionDetails do
      xml.EpiPaymentInstructionId "192837465"
      xml.EpiRemittanceInfoIdentifier "RF471234567890", "IdentificationSchemeName" => "ISO"
      xml.EpiInstructedAmount "1831,48", "AmountCurrencyIdentifier" =>"EUR"
      xml.EpiCharge nil, "ChargeOption" => "SLEV"
      xml.EpiDateOptionDate "20151024", "Format" => "CCYYMMDD"
    end
  end
end
