class PostalOfficialLegend
  def self.options
    [
      [ "Ei valintaa" , [ "Ei valintaa" ]],
      [ "Pupesoft / Itella", [
        [ "Itella Express City 00", "Express City 00" ],
        [ "Itella Express Morning 9", "Express Morning 9" ],
        [ "Itella Express Business Day 14", "Express Business Day 14" ],
        [ "Itella Express Point 00/16", "Express Point 00/16" ],
        [ "Itella Express Flex 21", "Express Flex 21" ],
        [ "Itella Economy 16", "Economy 16" ],
        [ "Itella Customer Return", "Customer Return" ],
        [ "Itella Undelivered Shipment", "Undelivered Shipment" ],
        [ "Itella Lisäarvokuljetus", "Lisäarvokuljetus" ],
        [ "Itella Priority Ulkomaan lähetys", "Priority Ulkomaa" ]
      ]],
      [ "Unifaun / Itella",  [
        [ "Itella Economy Letter", "ITELLAMAILEC" ],
        [ "Itella Economy Parcel", "IT16" ],
        [ "Itella Express Business Day", "IT14" ],
        [ "Itella Express Business Day kuljetusyksikkö", "ITKY14" ],
        [ "Itella Express Business Day pallet (Ulkomaa)", "ITKY14I" ],
        [ "Itella Express Business Day parcel (Ulkomaa)", "IT14I" ],
        [ "Itella Express City", "ITEXPC" ],
        [ "Itella Express City kuljetusyksikkö", "ITKYEXPC" ],
        [ "Itella Express Flex", "IT21" ],
        [ "Itella Express Flex kuljetusyksikkö", "ITKY21" ],
        [ "Itella Express Morning", "IT09" ],
        [ "Itella Express Morning kuljetusyksikkö", "ITKY09" ],
        [ "Itella Logistics Oy, Kappaletavara", "TPSTD" ],
        [ "Itella Logistics Oy, Kotimaan Rahti", "ITELLALOGKR" ],
        [ "Itella Priority Letter", "ITELLAMAILPR" ],
        [ "Itella Priority Parcel", "ITPR" ],
        [ "Itella SmartPOST", "ITSP" ],
        [ "Itella VAK/ADR", "ITVAK" ],
        [ "Itella VAK/ADR kuljetusyksikkö", "ITKYVAK" ]
      ]],
      [ "Unifaun / Bring", [
        [ "Bring CarryOn Budget", "PNL359" ],
        [ "Bring CarryOn Business", "PNL330" ],
        [ "Bring CarryOn Business 09.00", "PNL335" ],
        [ "Bring CarryOn Business BulkReturn", "PNL333" ],
        [ "Bring CarryOn Business BulkSplit", "PNL332" ],
        [ "Bring CarryOn Business BulkSplit 09.00", "PNL334" ],
        [ "Bring CarryOn Business Pallet", "PNL336" ],
        [ "Bring CarryOn Business Pallet 09.00", "PNL339" ],
        [ "Bring CarryOn Business Return", "PNL331" ],
        [ "Bring CarryOn HomeShopping", "PNL340" ],
        [ "Bring CarryOn HomeShopping BulkReturn", "PNL343" ],
        [ "Bring CarryOn HomeShopping BulkSplit", "PNL342" ],
        [ "Bring CarryOn HomeShopping BulkSplit Home", "PNL349" ],
        [ "Bring CarryOn HomeShopping BulkSplit Mini", "PNL345" ],
        [ "Bring CarryOn HomeShopping Return", "PNL341" ],
        [ "Bring CarryOn Waybill", "PNLWAY" ],
        [ "Bring Express Business Distribution", "BOXBD" ],
        [ "Bring Express Business Distribution Pallet", "BOXBDP" ],
        [ "Bring Express Courier Ad-Hoc", "BOXCA" ],
        [ "Bring Express Courier Distribution", "BOXCD" ],
        [ "Bring Express Home Delivery", "BOXHD" ],
        [ "Bring Express Home Delivery Return", "BOXHDR" ],
        [ "Bring Express QuickPack", "BOXQP" ],
        [ "Bring Express Store Home Delivery", "BOXSHD" ],
        [ "Bring Express Store Home Delivery Return", "BOXSHDR" ]
      ]],
      [ "Unifaun / Dachser", [
       [ "Dachser Targofix", "DACTFIX" ],
       [ "Dachser Targofix 10:00", "DACTFIX10" ],
       [ "Dachser Targofix 12:00", "DACTFIX12" ],
       [ "Dachser Targoflex", "DACTFLEX" ],
       [ "Dachser Targospeed", "DACTSPEED" ],
       [ "Dachser Targospeed 10:00", "DACTSPEED10" ],
       [ "Dachser Targospeed 12:00", "DACTSPEED12" ],
       [ "Dachser Targospeed Plus", "DACTSPEEDPLUS" ]
      ]],
      [ "Unifaun / DANX", [
        [ "DANX", "DANXSTD" ]
      ]],
      [ "Unifaun / DB Schenker", [
        [ "DB SCHENKER Express (Finland)", "SBTLFIEXP" ],
        [ "DB SCHENKER Finland System", "SBTLFISY" ],
        [ "DB SCHENKERbudget", "BBU" ],
        [ "DB SCHENKERcoldsped - Europa", "BCSI" ],
        [ "DB SCHENKERcoldsped - Sverige", "BCS" ],
        [ "DB SCHENKERdirect", "BDI" ],
        [ "DB SCHENKERparcel", "BPA" ],
        [ "DB SCHENKERprivpak - Hem Dag (utan avisering och kvittens)", "BPHDP" ],
        [ "DB SCHENKERprivpak - Hem Dag med avisering (och kvittens) (Paket)", "BPHDAP" ],
        [ "DB SCHENKERprivpak - Hem Kväll med avisering (och kvittens)", "BPHKAP" ],
        [ "DB SCHENKERprivpak - Ombud Standard (1 kolli, &lt;20 kg)", "BHP" ],
        [ "DB SCHENKERprivpak - Terminal", "BPOSG" ],
        [ "DB SCHENKERprivpak - Till Jobbet", "BPTJP" ],
        [ "DB SCHENKERsystem", "BCF" ]
      ]],
      [ "Unifaun / DHL", [
        [ "DHL Euroconnect", "ASU" ],
        [ "DHL Euroconnect Plus", "ASUP" ],
        [ "DHL Express 09:00 (Tullinalainen)", "DASECD" ],
        [ "DHL Express 09:00 (Tullivapaa)", "DASE" ],
        [ "DHL Express 10:30 (Tullinalainen)", "DATDM" ],
        [ "DHL Express 10:30 (Tullivapaa)", "DATDL" ],
        [ "DHL Express 12:00 (Tullinalainen)", "DAMECD" ],
        [ "DHL Express 12:00 (Tullivapaa)", "DAME" ],
        [ "DHL Express Envelope (Tullivapaa)", "DAXPD" ],
        [ "DHL Express Worldwide (Kotimaa)", "DADOM" ],
        [ "DHL Express Worldwide (Tullinalainen)", "DAWPX" ],
        [ "DHL Express Worldwide (Tullivapaa EU:ssa)", "DAECX" ],
        [ "DHL Express Worldwide (Tullivapaa, Ei-EU)", "DADOX" ],
        [ "DHL Freight Domestic EE", "DHLFREIGHTESTDOM" ],
        [ "DHL Freight Euroconnect EE", "DHLFREIGHTESTEC" ],
        [ "DHL Freight Euroconnect FI", "DHLFREIGHTFIEC" ],
        [ "DHL Freight Kotimaa", "DHLFREIGHTFIKT" ],
        [ "DHL Global Forwarding Air Freight", "DGFAIR" ],
        [ "DHL Global Forwarding Air Freight PLUS", "DGFAIRPLUS" ],
        [ "DHL Paket", "AEX" ],
        [ "DHL Pall", "ASP2" ],
        [ "DHL Parti", "ASWP2" ],
        [ "DHL Service Point", "ASPO" ],
        [ "DHL Service Point C.O.D.", "ASPOC" ],
        [ "DHL Service Point Retur", "ASPOR" ],
        [ "DHL Stycke", "ASWS2" ],
        [ "DHL Swednet Partigods", "ASWP" ],
        [ "DHL Swednet Styckegods", "ASWS" ]
      ]],
      [ "Unifaun / DSV", [
        [ "DSV Road Kappaletavara", "DSVFIGRP" ],
        [ "DSV Road Osakuorma", "DSVFIFULL" ]
      ]],
      [ "Unifaun / Fennoway", [
        [ "Fennoway Fennorahti", "FENNORAHTI" ]
      ]],
      [ "Unifaun / GLS", [
        [ "GLS Suomi INTERNATIONAL", "GLSFIINT" ]
      ]],
      [ "Unifaun / Kaukokiito", [
        [ "Kaukokiito", "KKSTD" ]
      ]],
      [ "Unifaun / Kiitolinja", [
        [ "KIITOLINJA kappaletavara", "KLGRP" ]
      ]],
      [ "Unifaun / KN Road", [
        [ "KN Road", "KUEHNENAGELROAD" ]
      ]],
      [ "Unifaun / Tyvi", [
        [ "Kuljetusliike Tyvi Oy", "KTYVI" ]
      ]],
      [ "Unifaun / Matkahuolto", [
        [ "Matkahuolto Ahvenanmaan Jakopaketti", "MH68" ],
        [ "Matkahuolto Baltian Paketti", "MH63" ],
        [ "Matkahuolto Bussipaketti", "MH10" ],
        [ "Matkahuolto Dokumenttikuori", "MH43" ],
        [ "Matkahuolto Jakopaketti/Paikallispaketti", "MH3050" ],
        [ "Matkahuolto Lavarahti", "MH57" ],
        [ "Matkahuolto Lähellä-paketin palautus", "MH81" ],
        [ "Matkahuolto Lähellä-paketti", "MH80" ],
        [ "Matkahuolto Mannermaan Jakopaketti", "MH75" ],
        [ "Matkahuolto Mannermaan Paketti", "MH74" ],
        [ "Matkahuolto Pikapaketti", "MH20" ],
        [ "Matkahuolto Postaalipaketti", "MH82" ],
        [ "Matkahuolto Postaalipaketti palautus", "MH83" ],
        [ "Matkahuolto Rahtipussi", "MH40" ],
        [ "Matkahuolto Rahtipussi jakopaketti", "MH42" ]
      ]],
      [ "Unifaun / Neutraali", [
        [ "Neutraali Kappaletavarapalvelu (osoitekortti + rahtikirja)", "FREEG" ],
        [ "Neutraali Kappaletavarapalvelu (osoitekortti + rahtikirja): Transpori Oy", "FREEG_793" ],
        [ "Neutraali Kappaletavarapalvelu (osoitekortti + rahtikirja): AJ Laine Oy", "FREEG_794" ],
        [ "Neutraali Kirjepalvelu", "FREEB" ],
        [ "Neutraali pakettipalvelu (osoitekortti)", "FREEP" ]
      ]],
      [ "Unifaun / Posten Brev", [
        [ "Posten Brev - Brevpostförskott", "PAF" ],
        [ "Posten Brev - Express (kotimaa)", "BEXPD" ],
        [ "Posten Brev - Normaali", "BREV" ],
        [ "Posten Brev - Priority+", "BEXPI" ],
        [ "Posten Brev - Värde", "BVAL" ],
        [ "Posten Brev  Kirjattu kirje (BREKD)", "BREKD" ],
        [ "Posten Brev  Kirjattu kirje (BREKI)", "BREKI" ],
        [ "Posten EMS (brev/dokument)", "EMSD2" ],
        [ "Posten EMS (paket/varor)", "EMSP2" ]
      ]],
      [ "Unifaun / PostNord", [
        [ "PostNord DPD Classic (Suomi)", "DPDFI" ],
        [ "PostNord Logistics DPD Företagspaket", "P15" ],
        [ "PostNord Logistics DPD Företagspaket 12.00", "P14" ],
        [ "PostNord Logistics DPD Utrikes", "DPD" ],
        [ "PostNord Logistics Express - Express 07.00", "P42" ],
        [ "PostNord Logistics Hempaket", "P32" ],
        [ "PostNord Logistics Hjemlevering (Norge)", "DTPGHD" ],
        [ "PostNord Logistics InNight", "H48" ],
        [ "PostNord Logistics Kundretur", "P31" ],
        [ "PostNord Logistics MyPack", "P19" ],
        [ "PostNord Logistics MyPack (Suomi)", "P19FI" ],
        [ "PostNord Logistics MyPack (Norja)", "P19NO" ],
        [ "PostNord Logistics MyPack return", "P24" ],
        [ "PostNord Logistics MyPack return (Suomi)", "P24FI" ],
        [ "PostNord Logistics MyPack Return (Norja)", "P24NO" ],
        [ "PostNord Logistics PALL.ETT", "P52" ],
        [ "PostNord Logistics Partifrakt (Norja)", "DTPGPF" ],
        [ "PostNord Logistics Postpaket Utrikes", "P91" ],
        [ "PostNord Logistics Stykkgods (Norja)", "DTPGSG" ]
      ]],
      [ "Unifaun / Privpak", [
        [ "Privpak Finland (normaali & palautus)", "PPFITRRET" ],
        [ "Privpak Finland (normaali)", "PPFITR" ]
      ]],
      [ "Unifaun / R & P", [
        [ "R & P Kuljetus Pakettipalvelu", "RPPP" ]
      ]],
      [ "Unifaun / TK Logistik", [
        [ "TK Logistik Gods", "TKLOGGODS" ]
      ]],
      [ "Unifaun / TNT", [
        [ "TNT 08:00 Express (Domestic Docs)", "TNT08DOMD" ],
        [ "TNT 08:00 Express (Domestic Non Docs)", "TNT08DOMN" ],
        [ "TNT 09:00 Express (Docs)", "TNT09D" ],
        [ "TNT 09:00 Express (Domestic Docs)", "TNT09DOMD" ],
        [ "TNT 09:00 Express (Domestic Non Docs)", "TNT09DOMN" ],
        [ "TNT 09:00 Express (Domestic)", "TNT09" ],
        [ "TNT 09:00 Express (Non Docs)", "TNT09N" ],
        [ "TNT 10:00 Express (Docs)", "TNT10D" ],
        [ "TNT 10:00 Express (Domestic Docs)", "TNT10DOMD" ],
        [ "TNT 10:00 Express (Domestic Non Docs)", "TNT10DOMN" ],
        [ "TNT 10:00 Express (Domestic)", "TNT10" ],
        [ "TNT 10:00 Express (Non Docs)", "TNT10N" ],
        [ "TNT 12:00 Economy Express (Non Docs)", "TNT412" ],
        [ "TNT 12:00 Express (Docs)", "TNT12D" ],
        [ "TNT 12:00 Express (Domestic Docs)", "TNT12DOMD" ],
        [ "TNT 12:00 Express (Domestic Non Docs)", "TNT12DOMN" ],
        [ "TNT 12:00 Express (Domestic)", "TNT12" ],
        [ "TNT 12:00 Express (Non Docs)", "TNT12N" ],
        [ "TNT Economy Express (Non Docs)", "TNT48N" ],
        [ "TNT Express (Docs)", "TNT15D" ],
        [ "TNT Express (Domestic Docs)", "TNT15DOMD" ],
        [ "TNT Express (Domestic Non Docs)", "TNT15DOMN" ],
        [ "TNT Express (Domestic)", "TNT15" ],
        [ "TNT Express (Non Docs)", "TNT15N" ],
        [ "TNT Special Economy Express", "TNT728" ]
      ]],
      [ "Unifaun / UPK", [
        [ "Uudenmaan Pikakuljetus Oy Erikoisaikataulu", "UPKE" ],
        [ "Uudenmaan Pikakuljetus Oy Kotijakelu", "UPKK" ],
        [ "Uudenmaan Pikakuljetus Oy Normal 24h", "UPK24" ],
        [ "Uudenmaan Pikakuljetus Oy Normal 24h AVI", "UPK24A" ]
      ]]
    ]
  end
end
