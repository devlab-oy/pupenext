module FinvoiceDetail

  def self.print_service_code(senderintermediator)
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

  def self.receiver_details(invoice)
    receiverpartyid = ""
    receiverintermediator = ""

    if invoice.company.parameter.ipost?
      # Posti Ipost
      receiverpartyid = invoice.verkkotunnus
      receiverintermediator = "003710948874"
    elsif invoice.verkkotunnus.index("@")
      receiverpartyid, receiverintermediator = invoice.verkkotunnus.split("@")
    else
      receiverpartyid = invoice.verkkotunnus
      receiverintermediator = ""
    end

    # If we are using Apix and we have no receiverintermediator,
    # we put Apix's OVT as receiverintermediator
    if receiverintermediator.empty? && invoice.company.parameter.apix?
      receiverintermediator = "003723327487"
    end

    # If we are still missing the receiverintermediator, we put the sender's
    # senderintermediator as the receiverintermediator
    # If we are using Maventa, we can leave the receiverintermediator empty
    if receiverintermediator.empty? && !invoice.company.parameter.maventa?
      receiverintermediator = invoice.company.parameter.finvoice_senderintermediator
    end

    # If we have no receiverpartyid, or our invoice is going to print service
    if (receiverpartyid.empty? && !invoice.company.parameter.apix?) || invoice.finvoice_printservice?
      receiverpartyid = print_service_code(receiverintermediator)
    end

    [receiverpartyid, receiverintermediator]
  end
end
