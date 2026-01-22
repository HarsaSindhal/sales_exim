CLASS ysample_print DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

   INTERFACES if_oo_adt_classrun .


    CLASS-DATA : access_token TYPE string .
    CLASS-DATA : xml_file TYPE string .
    CLASS-DATA : template TYPE string .
    TYPES :
      BEGIN OF struct,
        xdp_template TYPE string,
        xml_data     TYPE string,
        form_type    TYPE string,
        form_locale  TYPE string,
        tagged_pdf   TYPE string,
        embed_font   TYPE string,
      END OF struct."


    CLASS-METHODS :

      create_client
        IMPORTING url           TYPE string
        RETURNING VALUE(result) TYPE REF TO if_web_http_client
        RAISING   cx_static_check ,

      read_posts
        IMPORTING VALUE(invno) TYPE string

        RETURNING VALUE(result12) TYPE string
        RAISING   cx_static_check .

  PROTECTED SECTION.
  PRIVATE SECTION.

   CONSTANTS lc_ads_render TYPE string VALUE '/ads.restapi/v1/adsRender/pdf'.

    CONSTANTS lc_storage_name TYPE string VALUE 'templateSource=storageName'.
    CONSTANTS lc_template_name TYPE string VALUE 'Sample_invoice/Sample_invoice'.

ENDCLASS.



CLASS YSAMPLE_PRINT IMPLEMENTATION.


 METHOD create_client .
    DATA(dest) = cl_http_destination_provider=>create_by_url( url ).
    result = cl_web_http_client_manager=>create_by_http_destination( dest ).

  ENDMETHOD .


  METHOD if_oo_adt_classrun~main.



    TRY.
        DATA(xml)  = read_posts( invno = '2324100026'  )   .
      CATCH cx_static_check.
        "handle exception
    ENDTRY.


  ENDMETHOD.


  METHOD read_posts .


 DATA descripition TYPE string.

    DATA gw TYPE string.
    DATA tot_gwt TYPE p DECIMALS 2.

    SELECT * FROM ysales1_item WHERE Invno = @invno INTO TABLE  @DATA(ITEM).
    SELECT * FROM  yeinvoice_cdss   WHERE billingdocument = @invno   INTO TABLE @DATA(it) .
    SELECT SINGLE * FROM i_billingdocumentbasic WHERE billingdocument =  @invno INTO @DATA(billhead) .
    SELECT SINGLE * FROM  i_billingdocumentitem AS a
    LEFT OUTER JOIN i_deliverydocumentitem AS b ON ( a~referencesddocument = b~deliverydocument AND a~referencesddocumentitem = b~deliverydocumentitem )
*    INNER JOIN   i_deliverydocument AS f ON ( b~deliverydocument = f~deliverydocument )
     LEFT JOIN   i_deliverydocument AS f ON ( b~deliverydocument = f~deliverydocument )
    LEFT OUTER JOIN i_shippingtypetext AS s ON ( f~shippingtype = s~shippingtype AND s~language = 'E'  )
       WHERE  billingdocument  =  @invno INTO @DATA(billingitem)  .
*IF BILLINGITEM-SA
    SELECT * FROM i_billingdocumentitem WHERE billingdocument = @billingitem-a-referencesddocument INTO TABLE @DATA(deli) .
    SORT deli BY referencesddocument .
    DELETE ADJACENT DUPLICATES FROM deli COMPARING referencesddocument.

*if billhead-CreatedByUser id
    SELECT SINGLE userdescription  FROM i_user WITH PRIVILEGED ACCESS WHERE  userid = @billhead-createdbyuser INTO @DATA(username).
    SELECT SINGLE * FROM ygate_itemcdsview AS a
    LEFT OUTER JOIN ygate_headercds AS b ON ( b~gateno = a~gateno )
     WHERE delievery = @billingitem-f-deliverydocument INTO @DATA(driver).


    SELECT SINGLE * FROM i_salesdocument WHERE salesdocument  =  @billingitem-a-salesdocument  INTO  @DATA(salesorder)  .
    READ TABLE it INTO  DATA(wt) INDEX 1 .

    SELECT SINGLE * FROM i_customer WHERE customer = @wt-billtoparty INTO @DATA(billto) .
    SELECT SINGLE * FROM  i_customer AS a  INNER JOIN i_billingdocumentpartner AS b ON ( a~customer = b~customer )
    WHERE b~partnerfunction = 'WE'  AND b~billingdocument = @invno   INTO @DATA(shipto)  .

    SELECT SINGLE * FROM i_regiontext   WHERE  region = @billto-region AND language = 'E' AND country = @billto-country  INTO  @DATA(regiontext1) .

    SELECT SINGLE * FROM i_paymenttermstext WHERE paymentterms = @billhead-customerpaymentterms AND language = 'E'
    INTO @DATA(terms) .
    SELECT SINGLE * FROM i_sddocumentpartner WITH PRIVILEGED ACCESS  WHERE sddocument = @wt-delivery_number  AND partnerfunction = 'WE' INTO @DATA(shiptoa) .

    SELECT SINGLE * FROM zsd_dom_address WITH PRIVILEGED ACCESS WHERE addressid = @shiptoa-addressid INTO @DATA(shiptoadd1)   .

    SELECT SINGLE * FROM zsd_dom_address WITH PRIVILEGED ACCESS WHERE addressid = @billto-addressid INTO @DATA(billtoadd1)   .
    SELECT SINGLE * FROM i_regiontext   WHERE  region = @shiptoadd1-region AND language = 'E' AND country = @shiptoadd1-country  INTO  @DATA(regiontext2) .
    SELECT SINGLE * FROM i_salesdocumentpartner WHERE salesdocument  =  @billingitem-a-salesdocument AND partnerfunction = 'Z1' INTO @DATA(part).
    SELECT SINGLE * FROM i_supplier WHERE supplier = @part-supplier INTO @DATA(part_supp).
    SELECT SINGLE * FROM i_salesdocumentpartner WHERE salesdocument  =  @billingitem-a-salesdocument AND partnerfunction = 'AG' INTO @DATA(part1).
**    SELECT SINGLE * FROM I_BillingDocumentBasic WHERE BillingDocument = @billingitem-a-BillingDocument into @data(bill5).
    SELECT SINGLE * FROM zfreght_caputring_cds WHERE invoiceno = @billingitem-a-billingdocument INTO @DATA(bill5).


*********4.06
    SELECT SINGLE * FROM i_billingdocument  WHERE billingdocument = @billingitem-a-billingdocument  INTO @DATA(bill) .
************4.06
    IF it IS NOT INITIAL .

      READ TABLE it INTO DATA(gathd) INDEX 1 .

    ENDIF .


    DATA table_1 TYPE string .
    IF salesorder-salesdocumenttype = 'CBFD'  .
      table_1  = 'ZSD_FOC'  .
      table_1  = to_upper( val = table_1 )  .
    ELSE  .
      table_1  = 'I_BillingDocumentItemPrcgElmnt'  .
      table_1  = to_upper( val = table_1 )  .
    ENDIF .



    CONCATENATE salesorder-salesdocumentdate+6(2) '/' salesorder-salesdocumentdate+4(2) '/' salesorder-salesdocumentdate+0(4) INTO DATA(salesorderdate) .
    CONCATENATE  billhead-yy1_lcdate_bdh+6(2) '/'  billhead-yy1_lcdate_bdh+4(2) '/'  billhead-yy1_lcdate_bdh+0(4) INTO  DATA(lcdate)  .

    CONCATENATE  billhead-yy1_lrdate_bdh+6(2) '/'  billhead-yy1_lrdate_bdh+4(2) '/'  billhead-yy1_lrdate_bdh+0(4) INTO  DATA(lrdate) .
    DATA: transmode TYPE string.
    IF billhead-yy1_precarrierbytransp_bdh = '1'.
      transmode  = 'By Road'  .
    ELSEIF billhead-yy1_precarrierbytransp_bdh = '2'.
      transmode  = 'By Air '  .
    ELSEIF billhead-yy1_precarrierbytransp_bdh = '3'.
      transmode  = 'By Sea '  .
    ELSEIF billhead-yy1_precarrierbytransp_bdh = '4'.
      transmode  = 'Road/Rail '  .
    ELSEIF billhead-yy1_precarrierbytransp_bdh = '5'.
      transmode  = 'Road/Air '  .
    ELSEIF billhead-yy1_precarrierbytransp_bdh = '6'.
      transmode  = 'Road/Sea'  .
    ELSEIF billhead-yy1_precarrierbytransp_bdh = '7'.
      transmode  = 'By Truck'.
    ENDIF .


******* GROSS WEIGHT LOGIC FOR

    IF billhead-division = '12' .



      SELECT * FROM
      i_billingdocumentitembasic AS z LEFT JOIN
         i_deliverydocumentitem  AS a ON ( z~referencesddocument =  a~deliverydocument
         AND z~referencesddocumentitem = a~higherlvlitmofbatspltitm  )
      WHERE z~billingdocument = @invno
     AND a~batch NE ' '
      INTO TABLE @DATA(bth) .

      LOOP AT bth INTO DATA(wbth).


        SELECT SINGLE grosswt FROM zpackn_cds WHERE batch = @wbth-a-batch INTO @DATA(grosswt) .



         tot_gwt  = tot_gwt + grosswt.

      ENDLOOP.
    ENDIF.


    SELECT
    SUM( billingquantity )
       FROM i_billingdocumentitem  AS a
       WHERE billingdocument = @billingitem-a-billingdocument
       INTO @DATA(netweight).



    DATA lv_cntr TYPE sy-index.

    DATA lv_ft TYPE i_billingdocumentitem-referencesddocument.


    SELECT  * FROM  i_billingdocumentitem   WHERE  billingdocument  =  @invno INTO TABLE @DATA(tabdel)  .
    SORT tabdel BY referencesddocument billingdocument .
    DELETE ADJACENT DUPLICATES FROM tabdel COMPARING referencesddocument billingdocument .

    TYPES : BEGIN OF it ,
              referencesddocument TYPE c LENGTH 250,
              billingdocument     TYPE i_billingdocumentitem-billingdocument,

            END OF it.

    DATA : it3 TYPE  TABLE OF it,
           wa1 TYPE it.

    LOOP AT tabdel INTO DATA(wa_tab) .
      MOVE-CORRESPONDING wa_tab TO wa1.
*      wa1-referencesddocument = wa_tab-referencesddocument .
      CLEAR:wa1-referencesddocument.
      SELECT DISTINCT referencesddocument FROM  i_billingdocumentitem WHERE  billingdocument = @wa_tab-billingdocument
*                                      AND  referencesddocumentitem   = @wa_tab-referencesddocumentitem
                                                                     INTO @DATA(lv_ftpye) .

        IF wa1-referencesddocument IS  INITIAL .
          wa1-referencesddocument  = lv_ftpye.
        ELSE.
          CONCATENATE lv_ftpye '/' wa1-referencesddocument INTO  wa1-referencesddocument .
        ENDIF.
      ENDSELECT.

      APPEND wa1 TO it3.
      CLEAR : wa_tab, lv_ft,wa1.

    ENDLOOP.

    READ TABLE it3 INTO DATA(wa3) WITH KEY billingdocument = invno .


*************************************************************************

SELECT SINGLE * FROM ysales_header WHERE Invno = @invno INTO @DATA(header).


*********************************************************************


    IF billhead-distributionchannel NE '20'  .

      IF billhead-division = '19' .
        template = 'Sample_invoice/Sample_invoice'  .

**        template = 'SCRAP_FI_SD_INVOICE/SCRAP_FI_SD_INVOICE'  .

      ELSE.

        template = 'Sample_invoice/Sample_invoice'  .

      ENDIF.

     data :matr1 TYPE string.
        matr1 = gathd-Material.
      data(dt4) = sy-datum.

      DATA(lv_xml) = |<form1>| &&
            |<AddressNode>| &&
            |<frmBillToAddress>| &&
            |<txtLine2>{ HEADER-CompanyName }</txtLine2>| &&
            |<txtLine3>{ header-Address1 }</txtLine3>| &&
            |<txtLine4>{ header-Address2 }</txtLine4>| &&
            |<txtLine5>{ header-Address3 }</txtLine5>| &&
            |<txtLine6>{ header-Address4 } </txtLine6>| &&
            |<txtLine7></txtLine7>| &&
            |<txtLine8></txtLine8>| &&
*
            |<txtLine8>{ billto-telephonenumber1  }</txtLine8>| &&
            |<txtRegion>{ regiontext1-region  }</txtRegion>| &&
            |<BillToPartyGSTIN></BillToPartyGSTIN>| &&
*       |<AckNo>{ gathd-AckNo }</AckNo>| &&
*       |<AckDate>{ gathd-AckDate }</AckDate>| &&
*       |<Ebillno>{ gathd-Ebillno }</Ebillno>| &&
            |</frmBillToAddress>| &&
            |<frmShipToAddress>| &&
            |<txtLine1/>| &&
            |<txtLine2>{ HEADER-Shipcompany }</txtLine2>| &&
            |<txtLine3>{ HEADER-ShipAddress1 }</txtLine3>| &&
            |<txtLine4>{ HEADER-ShipAddress2 }</txtLine4>| &&
            |<txtLine5>{ HEADER-ShipAddress3 }</txtLine5>| &&
            |<txtLine6>{ HEADER-ShipAddress4 } { header-Postal_Code }</txtLine6>| &&
            |<txtLine7>{ header-Country_Of_Destination }</txtLine7>| &&
            |<txtLine8></txtLine8>| &&
              |<txtRegion></txtRegion>| &&
              |<ShipToPartyGSTIN>{ HEADER-Gstin }</ShipToPartyGSTIN>| &&
              |</frmShipToAddress>| &&
              |<QrCode>| &&
              |<QRCodeBarcode1></QRCodeBarcode1>| &&
              |</QrCode>| &&
              |</AddressNode> | &&
              |<IRN>| &&
              |<AckNo></AckNo>| &&
              |<IRN></IRN>| &&
              |<AckDate></AckDate>| &&
              |<Ebillno></Ebillno>| &&
**              |<ValidUpto>{ gathd-validupto+6(2) }/{ gathd-validupto+4(2) }/{ gathd-validupto+0(4) }</ValidUpto>| &&
               |<ValidUpto></ValidUpto>| &&
              |<ApproxDistance></ApproxDistance>| &&
              |</IRN>| &&
              |<Subform2>| &&
              |<DocNo>| &&
              |<BillingDocument>{ HEADER-Invno }</BillingDocument>| &&
              |<BillingDocumentdate>{ HEADER-InvoiceDate }</BillingDocumentdate>| &&
              |<txtReferenceNumber>{ HEADER-Customerpo }</txtReferenceNumber>| &&
              |<txtSalesDocument>{ header-Salesdocdate  }</txtSalesDocument>| &&
*              |<DeliveryNo>{ billingitem-a-referencesddocument }</DeliveryNo>| &&
              |<DeliveryNo>{ wa3-referencesddocument }</DeliveryNo>| &&
              |<Agent>{ HEADER-Agent }</Agent>| &&
              |<Lcno></Lcno>| &&
              |</DocNo>| &&
              |<Transporter>| &&
              |<LrNo.>{ HEADER-Contactno }</LrNo.>| &&
              |<TruckNo.>{ HEADER-Noofcarton }</TruckNo.>| &&
              |<Transporter>{ HEADER-Contactpersonname }</Transporter>| && "{ gathd-transname }
              |<TransportMode>{ HEADER-Cones_No }</TransportMode>| &&
              |<DriverNo>{ HEADER-Driverno }</DriverNo>| &&
              |<material>{ matr1 }</material>| &&
              |<Lcdate>{ billhead-YY1_LCDate_BDH }</Lcdate>| &&
              |</Transporter>| &&
              |</Subform2>| &&
              |<Subform3>| &&
              |<Table1>| &&
              |<HeaderRow/>|
               .

      DATA rat TYPE p DECIMALS 2 .
      DATA xsml TYPE string .
      DATA count TYPE int8 .
************************************
*LOOPING DATA
************************************
      DATA(it1) = it.
      SORT it BY billingdocument  material."billingdocumentitem
      DELETE ADJACENT DUPLICATES FROM it COMPARING billingdocument material .  "billingdocumentitem     """"""3.07.2023
      LOOP AT ITEM INTO DATA(iv) .

    data : amount TYPE p DECIMALS 3.
           if header-Country_Of_Destination = 'INDIA'.
             AMOUNT = IV-Amtinr.
              ELSE.
              AMOUNT = IV-Amt_USD.
              ENDIF.


        DATA(lv_xml2) =
               |<Row1>| &&
               |<Cell1/>| &&
               |<MaterialDis.>{ IV-MaterialDesc }</MaterialDis.>| &&
               |<HSN>{ iv-Hsnno }</HSN>| &&
               |<Lot>{ IV-Lotno }</Lot>| &&
               |<NoOfPackages>{ IV-Pkg }</NoOfPackages>| &&
               |<PackageQty></PackageQty>| &&
               |<Qty>{ IV-Qty }</Qty>| &&
               |<UOM>{ IV-Uom }</UOM>| &&
               |<GrossWt>{ IV-Grosswt }</GrossWt>| &&
               |<Rate>{ IV-Amtinr  }</Rate>| &&
               |<CGSTP>{ IV-Cgstper }</CGSTP>| &&
               |<CGSTAMT>{ IV-Cgstamt }</CGSTAMT>| &&
               |<SGSTP>{ IV-Sgstper }</SGSTP>| &&
               |<SGSTAMT>{ IV-Sgstamt }</SGSTAMT>| &&
               |<IGSTP>{ IV-Igstper }</IGSTP>| &&
               |<IGSTAMT>{ IV-Igstamt }</IGSTAMT>| &&
               |<TotalAmount>{ iv-Totalamt }</TotalAmount>| &&
               |</Row1>|.
        CONCATENATE xsml lv_xml2 INTO  xsml .
        CLEAR  : iv,lv_xml2,rat,iv,count.

      ENDLOOP .

************************************
*LOOPING DATA END
************************************



********************   04.06
      DATA cancel TYPE string.

      IF billhead-billingdocumentiscancelled = 'X'.
        cancel = 'CANCELLED'.
      ENDIF.
************************

      DATA got TYPE string.
      DATA bci TYPE string.

 DATA INSU TYPE STRING.
 if billhead-YY1_PolicyNumber_BDH = '1'.
    INSU = 'INSURANCE IN BUYER ACCOUNT'.
  ELSEIF   billhead-YY1_PolicyNumber_BDH = '2'.
    INSU = '380400212410000001'.

    ENDIF.


*     if gathd-c

      DATA(lv_xml3) =  |</Table1>| &&
             |</Subform3>| &&
             |<Terms>| &&
             |<Terms>| &&
             |<DeliveryTerms></DeliveryTerms>| &&
             |<BasicValue></BasicValue>| &&
             |<PaymentTerms></PaymentTerms>| &&
             |<TotalNetWeight></TotalNetWeight>| &&
             |<TotalGrossWeight></TotalGrossWeight>| &&
             |</Terms>| &&
             |<PricingConditions>| &&   "Changes in Xml
             |<FrieightChargeNew>hp</FrieightChargeNew>| &&   "Changes in Xml
      |<Gst></Gst>| &&
      |<GstP></GstP>| &&
      |<TotInvAmount></TotInvAmount>| &&
      |<Insurance></Insurance>| &&
      |<DiscountP></DiscountP>| &&
      |<DiscountAmount></DiscountAmount>|  &&
      |<CGSTP></CGSTP>| &&
      |<CgstAmount></CgstAmount>| &&
      |<SGSTP></SGSTP>| &&
      |<SgstAmount></SgstAmount>| &&
      |<TCSP></TCSP>| &&
      |<TCSAmount></TCSAmount>| &&
      |<Rateunit>INR</Rateunit>| &&
*|<SubTotal>1000000</SubTotal>| &&
      |<FrieightCharge></FrieightCharge>| &&
       |<Loading></Loading>| &&
       |<Packing></Packing>| &&

*|<InvoiceValue>Am undique</InvoiceValue>| &&
      |<Roundedoff></Roundedoff>| &&

             |</PricingConditions>| &&
             |</Terms>| &&

              |<Goods>| &&
              |<GoodsDesc>{ billhead-YY1_GoodsDesc_BDH }</GoodsDesc>| &&
              |</Goods>| &&
             |<Remarks>| &&
             |<Division>{ gathd-division }</Division>| &&
             |<CustomerContantName></CustomerContantName>| && "{ salesorder-YY1_CustomerContactNam_SDH }
             |<CustomerContantNo></CustomerContantNo>| && "{ salesorder-YY1_CustomerContactNum_SDH }
             |<Remark>{ HEADER-Remark }</Remark>| &&
             |<Remark2>{ billhead-yy1_remarks1_bdh }</Remark2>| &&"
             |<SMPLBCI>{  billhead-division }</SMPLBCI>| &&
             |<SMPLGOTS>Policy Number : 380400212410000001</SMPLGOTS>| &&
             |<POLICY>{ INSU }</POLICY>| &&
             |<Subform6/>| &&
             |</Remarks>| &&
             |<Canceldoc></Canceldoc>| &&
             |<PreparedBy>{ username }</PreparedBy>| &&
             |</form1>| .

      CONCATENATE lv_xml xsml lv_xml3 INTO lv_xml .

      REPLACE ALL OCCURRENCES OF '&' IN lv_xml WITH 'and'.

    ENDIF .
 CALL METHOD ycl_test_adobe=>getpdf(
      EXPORTING
        xmldata  = lv_xml
        template = template
      RECEIVING
        result   = result12 ).



  ENDMETHOD.
ENDCLASS.
