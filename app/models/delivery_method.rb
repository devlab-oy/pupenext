class DeliveryMethod < BaseModel
  include Translatable

  validates :tulostustapa, inclusion: { in: %w(H E K L X) }
  validates :selite, uniqueness: true

  scope :permit_adr, -> { where(vak_kielto: '') }
  scope :shipment, -> { where(nouto: '') }

  self.table_name = :toimitustapa
  self.primary_key = :tunnus

  def pickup_options
    [
      [t("Tilaukset toimitetaan asiakkaalle"), ""],
      [t("Asiakas noutaa tilaukset"), "o"]
    ]
  end

  def saturday_delivery_options
    [
      [t("Ei lauantaijakelua"), ""],
      [t("Itella lisäpalvelu: Lauantaijakelu"), "o"]
    ]
  end

  def transport_unit_options
    [
      [t("Ei kuljetusyksikkökuljetusta"), ""],
      [t("Itella lisäpalvelu: Kuljetusyksikkökuljetus"), "o"]
    ]
  end

  def carrier_options
    #company.carriers.map { |i| [ i.nimi, i.koodi ] }
  end

  def print_method_options
    [
      [t("Erätulostus"), "E"],
      [t("Hetitulostus"), "H"],
      [t("Koonti-hetitulostus"), "K"],
      [t("Koonti-erätulostus"), "L"],
      [t("Rahtikirjansyöttö ja -tulostus ohitetaan"), "X"]
    ]
  end

  def freight_contract_options
    [
      [t("Käytetään lähettäjän rahtisopimusta"), "K"],
      [t("Käytetään vastaanottajan rahtisopimusta"), ""]
    ]
  end

  def logy_waybill_number_options
    [
      [t("Ei käytetä LOGY:n rahtikirjanumeroita"), ""],
      [t("Käytetään LOGY:n rahtikirjanumeroita"), "K"]
    ]
  end

  def extranet_options
    [
      [t("Toimitustapa näytetään vain myynnissä"), ""],
      [t("Toimitustapa näytetään vain extranetissä"), "K"],
      [t("Toimitustapa näytetään molemmissa"), "M"]
    ]
  end

  def waybill_options
    company.keywords.waybills.map { |i| [ i.selitetark, i.selite ] }
  end

  def label_options
    options = [
      [t("Normaali"), ""],
      [t("Intrade"), "intrade"],
      [t("Tiivistetty"), "tiivistetty"]
    ]

    if company.parameter.kerayserat == "K"
      options << [t("Yksinkertainen, tulostusmedia valitaan kirjoittimen takaa"), "oslap_mg"]
    end

    options
  end

  def mode_of_transport_options
    company.keywords.mode_of_transports.map { |i| [ i.selitetark, i.selite ] }
  end

  def inland_mode_of_transport_options
    mode_of_transport_options
  end

  def nature_of_transaction_options
    company.keywords.nature_of_transactions.map { |i| [ i.selitetark, i.selite ] }
  end

  def exit_code_options
    company.keywords.customs.map { |i| [ "#{i.selite} #{i.selitetark}", i.selite ] }
  end

  def sorting_point_options
    company.keywords.sorting_points.map { |i| [ i.selitetark, i.selite ] }
  end

  def container_options
    [
      [t("Kyllä"), "1"],
      [t("Ei"), "0"]
    ]
  end

  def cash_on_delivery_prohibition_options
    [
      [t("Toimitustavalla saa toimittaa jälkivaatimuksia"), ""],
      [t("Toimitustavalla ei saa toimittaa jälkivaatimuksia"), "o"]
    ]
  end

  def adr_options(text)
    DeliveryMethod.permit_adr.shipment.map do |i|
      [ "#{text} #{i.selite}", i.selite ]
    end
  end

  def adr_prohibition_options
    [
      [t("Toimitustavalla saa toimittaa VAK-tuotteita"), ""],
      [t("Toimitustavalla ei saa toimittaa VAK-tuotteita"), "K"],
      adr_options(t("VAK-tuotteet toimitetaan toimitustavalla"))
    ].reject {|i,_| i.empty?}
  end

  def alternative_adr_delivery_method_options
    [
      [t("VAK-tuotteita ei siirretä omalle tilaukselleen"), ""],
      adr_options(t("VAK-tuotteet siirretään omalle tilaukselleen toimitustavalla"))
    ].reject {|i,_| i.empty?}
  end

  def official_legend_options
    {
      "Ei valintaa": "",
      "Pupesoft / Itella": {
        "Express City 00": "Itella Express City 00",
        "Express Morning 9": "Itella Express Morning 9",
        "Express Business Day 14": "Itella Express Business Day 14",
        "Express Point 00/16": "Itella Express Point 00/16",
        "Express Flex 21": "Itella Express Flex 21",
        "Economy 16": "Itella Economy 16",
        "Customer Return": "Itella Customer Return",
        "Undelivered Shipment": "Itella Undelivered Shipment",
        "Lisäarvokuljetus": "Itella Lisäarvokuljetus",
        "Priority Ulkomaa": "Itella Priority Ulkomaan lähetys"
      },
      "Unifaun / Itella": {
        "ITELLAMAILEC": "Itella Economy Letter",
        "IT16": "Itella Economy Parcel",
        "IT14": "Itella Express Business Day",
        "ITKY14": "Itella Express Business Day kuljetusyksikkö",
        "ITKY14I": "Itella Express Business Day pallet (Ulkomaa)",
        "IT14I": "Itella Express Business Day parcel (Ulkomaa)",
        "ITEXPC": "Itella Express City",
        "ITKYEXPC": "Itella Express City kuljetusyksikkö",
        "IT21": "Itella Express Flex",
        "ITKY21": "Itella Express Flex kuljetusyksikkö",
        "IT09": "Itella Express Morning",
        "ITKY09": "Itella Express Morning kuljetusyksikkö",
        "TPSTD": "Itella Logistics Oy, Kappaletavara",
        "ITELLALOGKR": "Itella Logistics Oy, Kotimaan Rahti",
        "ITELLAMAILPR": "Itella Priority Letter",
        "ITPR": "Itella Priority Parcel",
        "ITSP": "Itella SmartPOST",
        "ITVAK": "Itella VAK/ADR",
        "ITKYVAK": "Itella VAK/ADR kuljetusyksikkö"
      },
      "Unifaun / Bring": {
        "PNL359": "Bring CarryOn Budget",
        "PNL330": "Bring CarryOn Business",
        "PNL335": "Bring CarryOn Business 09.00",
        "PNL333": "Bring CarryOn Business BulkReturn",
        "PNL332": "Bring CarryOn Business BulkSplit",
        "PNL334": "Bring CarryOn Business BulkSplit 09.00",
        "PNL336": "Bring CarryOn Business Pallet",
        "PNL339": "Bring CarryOn Business Pallet 09.00",
        "PNL331": "Bring CarryOn Business Return",
        "PNL340": "Bring CarryOn HomeShopping",
        "PNL343": "Bring CarryOn HomeShopping BulkReturn",
        "PNL342": "Bring CarryOn HomeShopping BulkSplit",
        "PNL349": "Bring CarryOn HomeShopping BulkSplit Home",
        "PNL345": "Bring CarryOn HomeShopping BulkSplit Mini",
        "PNL341": "Bring CarryOn HomeShopping Return",
        "PNLWAY": "Bring CarryOn Waybill",
        "BOXBD": "Bring Express Business Distribution",
        "BOXBDP": "Bring Express Business Distribution Pallet",
        "BOXCA": "Bring Express Courier Ad-Hoc",
        "BOXCD": "Bring Express Courier Distribution",
        "BOXHD": "Bring Express Home Delivery",
        "BOXHDR": "Bring Express Home Delivery Return",
        "BOXQP": "Bring Express QuickPack",
        "BOXSHD": "Bring Express Store Home Delivery",
        "BOXSHDR": "Bring Express Store Home Delivery Return"
      },
      "Unifaun / Dachser": {
       "DACTFIX": "Dachser Targofix",
       "DACTFIX10": "Dachser Targofix 10:00",
       "DACTFIX12": "Dachser Targofix 12:00",
       "DACTFLEX": "Dachser Targoflex",
       "DACTSPEED": "Dachser Targospeed",
       "DACTSPEED10": "Dachser Targospeed 10:00",
       "DACTSPEED12": "Dachser Targospeed 12:00",
       "DACTSPEEDPLUS": "Dachser Targospeed Plus"
      },
      "Unifaun / DANX": {
        "DANXSTD": "DANX"
      },
      "Unifaun / DB Schenker": {
        "SBTLFIEXP": "DB SCHENKER Express (Finland)",
        "SBTLFISY": "DB SCHENKER Finland System",
        "BBU": "DB SCHENKERbudget",
        "BCSI": "DB SCHENKERcoldsped - Europa",
        "BCS": "DB SCHENKERcoldsped - Sverige",
        "BDI": "DB SCHENKERdirect",
        "BPA": "DB SCHENKERparcel",
        "BPHDP": "DB SCHENKERprivpak - Hem Dag (utan avisering och kvittens)",
        "BPHDAP": "DB SCHENKERprivpak - Hem Dag med avisering (och kvittens) (Paket)",
        "BPHKAP": "DB SCHENKERprivpak - Hem Kväll med avisering (och kvittens)",
        "BHP": "DB SCHENKERprivpak - Ombud Standard (1 kolli, &lt;20 kg)",
        "BPOSG": "DB SCHENKERprivpak - Terminal",
        "BPTJP": "DB SCHENKERprivpak - Till Jobbet",
        "BCF": "DB SCHENKERsystem"
      },
      "Unifaun / DHL": {
        "ASU": "DHL Euroconnect",
        "ASUP": "DHL Euroconnect Plus",
        "DASECD": "DHL Express 09:00 (Tullinalainen)",
        "DASE": "DHL Express 09:00 (Tullivapaa)",
        "DATDM": "DHL Express 10:30 (Tullinalainen)",
        "DATDL": "DHL Express 10:30 (Tullivapaa)",
        "DAMECD": "DHL Express 12:00 (Tullinalainen)",
        "DAME": "DHL Express 12:00 (Tullivapaa)",
        "DAXPD": "DHL Express Envelope (Tullivapaa)",
        "DADOM": "DHL Express Worldwide (Kotimaa)",
        "DAWPX": "DHL Express Worldwide (Tullinalainen)",
        "DAECX": "DHL Express Worldwide (Tullivapaa EU: ssa)",
        "DADOX": "DHL Express Worldwide (Tullivapaa, Ei-EU)",
        "DHLFREIGHTESTDOM": "DHL Freight Domestic EE",
        "DHLFREIGHTESTEC": "DHL Freight Euroconnect EE",
        "DHLFREIGHTFIEC": "DHL Freight Euroconnect FI",
        "DHLFREIGHTFIKT": "DHL Freight Kotimaa",
        "DGFAIR": "DHL Global Forwarding Air Freight",
        "DGFAIRPLUS": "DHL Global Forwarding Air Freight PLUS",
        "AEX": "DHL Paket",
        "ASP2": "DHL Pall",
        "ASWP2": "DHL Parti",
        "ASPO": "DHL Service Point",
        "ASPOC": "DHL Service Point C.O.D.",
        "ASPOR": "DHL Service Point Retur",
        "ASWS2": "DHL Stycke",
        "ASWP": "DHL Swednet Partigods",
        "ASWS": "DHL Swednet Styckegods"
      },
      "Unifaun / DSV": {
        "DSVFIGRP": "DSV Road Kappaletavara",
        "DSVFIFULL": "DSV Road Osakuorma"
      },
      "Unifaun / Fennoway": {
        "FENNORAHTI": "Fennoway Fennorahti"
      },
      "Unifaun / GLS": {
        "GLSFIINT": "GLS Suomi INTERNATIONAL"
      },
      "Unifaun / Kaukokiito": {
        "KKSTD": "Kaukokiito"
      },
      "Unifaun / Kiitolinja": {
        "KLGRP": "KIITOLINJA kappaletavara"
      },
      "Unifaun / KN Road": {
        "KUEHNENAGELROAD": "KN Road"
      },
      "Unifaun / Tyvi": {
        "KTYVI": "Kuljetusliike Tyvi Oy"
      },
      "Unifaun / Matkahuolto": {
        "MH68": "Matkahuolto Ahvenanmaan Jakopaketti",
        "MH63": "Matkahuolto Baltian Paketti",
        "MH10": "Matkahuolto Bussipaketti",
        "MH43": "Matkahuolto Dokumenttikuori",
        "MH3050": "Matkahuolto Jakopaketti/Paikallispaketti",
        "MH57": "Matkahuolto Lavarahti",
        "MH81": "Matkahuolto Lähellä-paketin palautus",
        "MH80": "Matkahuolto Lähellä-paketti",
        "MH75": "Matkahuolto Mannermaan Jakopaketti",
        "MH74": "Matkahuolto Mannermaan Paketti",
        "MH20": "Matkahuolto Pikapaketti",
        "MH82": "Matkahuolto Postaalipaketti",
        "MH83": "Matkahuolto Postaalipaketti palautus",
        "MH40": "Matkahuolto Rahtipussi",
        "MH42": "Matkahuolto Rahtipussi jakopaketti"
      },
      "Unifaun / Neutraali": {
        "FREEG": "Neutraali Kappaletavarapalvelu (osoitekortti + rahtikirja)",
        "FREEG_793": "Neutraali Kappaletavarapalvelu (osoitekortti + rahtikirja): Transpori Oy",
        "FREEG_794": "Neutraali Kappaletavarapalvelu (osoitekortti + rahtikirja): AJ Laine Oy",
        "FREEB": "Neutraali Kirjepalvelu",
        "FREEP": "Neutraali pakettipalvelu (osoitekortti)"
      },
      "Unifaun / Posten Brev": {
        "PAF": "Posten Brev - Brevpostförskott",
        "BEXPD": "Posten Brev - Express (kotimaa)",
        "BREV": "Posten Brev - Normaali",
        "BEXPI": "Posten Brev - Priority+",
        "BVAL": "Posten Brev - Värde",
        "BREKD": "Posten Brev  Kirjattu kirje (BREKD)",
        "BREKI": "Posten Brev  Kirjattu kirje (BREKI)",
        "EMSD2": "Posten EMS (brev/dokument)",
        "EMSP2": "Posten EMS (paket/varor)"
      },
      "Unifaun / PostNord": {
        "DPDFI": "PostNord DPD Classic (Suomi)",
        "P15": "PostNord Logistics DPD Företagspaket",
        "P14": "PostNord Logistics DPD Företagspaket 12.00",
        "DPD": "PostNord Logistics DPD Utrikes",
        "P42": "PostNord Logistics Express - Express 07.00",
        "P32": "PostNord Logistics Hempaket",
        "DTPGHD": "PostNord Logistics Hjemlevering (Norge)",
        "H48": "PostNord Logistics InNight",
        "P31": "PostNord Logistics Kundretur",
        "P19": "PostNord Logistics MyPack",
        "P19FI": "PostNord Logistics MyPack (Suomi)",
        "P19NO": "PostNord Logistics MyPack (Norja)",
        "P24": "PostNord Logistics MyPack return",
        "P24FI": "PostNord Logistics MyPack return (Suomi)",
        "P24NO": "PostNord Logistics MyPack Return (Norja)",
        "P52": "PostNord Logistics PALL.ETT",
        "DTPGPF": "PostNord Logistics Partifrakt (Norja)",
        "P91": "PostNord Logistics Postpaket Utrikes",
        "DTPGSG": "PostNord Logistics Stykkgods (Norja)"
      },
      "Unifaun / Privpak": {
        "PPFITRRET": "Privpak Finland (normaali & palautus)",
        "PPFITR": "Privpak Finland (normaali)"
      },
      "Unifaun / R & P": {
        "RPPP": "R & P Kuljetus Pakettipalvelu"
      },
      "Unifaun / TK Logistik": {
        "TKLOGGODS": "TK Logistik Gods"
      },
      "Unifaun / TNT": {
        "TNT08DOMD": "TNT 08:00 Express (Domestic Docs)",
        "TNT08DOMN": "TNT 08:00 Express (Domestic Non Docs)",
        "TNT09D": "TNT 09:00 Express (Docs)",
        "TNT09DOMD": "TNT 09:00 Express (Domestic Docs)",
        "TNT09DOMN": "TNT 09:00 Express (Domestic Non Docs)",
        "TNT09": "TNT 09:00 Express (Domestic)",
        "TNT09N": "TNT 09:00 Express (Non Docs)",
        "TNT10D": "TNT 10:00 Express (Docs)",
        "TNT10DOMD": "TNT 10:00 Express (Domestic Docs)",
        "TNT10DOMN": "TNT 10:00 Express (Domestic Non Docs)",
        "TNT10": "TNT 10:00 Express (Domestic)",
        "TNT10N": "TNT 10:00 Express (Non Docs)",
        "TNT412": "TNT 12:00 Economy Express (Non Docs)",
        "TNT12D": "TNT 12:00 Express (Docs)",
        "TNT12DOMD": "TNT 12:00 Express (Domestic Docs)",
        "TNT12DOMN": "TNT 12:00 Express (Domestic Non Docs)",
        "TNT12": "TNT 12:00 Express (Domestic)",
        "TNT12N": "TNT 12:00 Express (Non Docs)",
        "TNT48N": "TNT Economy Express (Non Docs)",
        "TNT15D": "TNT Express (Docs)",
        "TNT15DOMD": "TNT Express (Domestic Docs)",
        "TNT15DOMN": "TNT Express (Domestic Non Docs)",
        "TNT15": "TNT Express (Domestic)",
        "TNT15N": "TNT Express (Non Docs)",
        "TNT728": "TNT Special Economy Express"
      },
      "Unifaun / UPK": {
        "UPKE": "Uudenmaan Pikakuljetus Oy Erikoisaikataulu",
        "UPKK": "Uudenmaan Pikakuljetus Oy Kotijakelu",
        "UPK24": "Uudenmaan Pikakuljetus Oy Normal 24h",
        "UPK24A": "Uudenmaan Pikakuljetus Oy Normal 24h AVI"
      }
    }
  end
end
