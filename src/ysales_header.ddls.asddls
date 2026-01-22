@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'HEADER CDS'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity YSALES_HEADER as select from ysales


{
    key invno as Invno,
    billtoparty as Billtoparty,
    statecode1 as Statecode1,
    customerpo as Customerpo,
    salesdocdate as Salesdocdate,
    deliveryno as Deliveryno,
    agent as Agent,
    shiptoparty as Shiptoparty,
    shipstatecode as Shipstatecode,
    gstin as Gstin,
    transporter as Transporter,
    lrdate as Lrdate,
    vehicleno as Vehicleno,
    driverno as Driverno,
    transportmode as Transportmode,
    lrno as LRNo,
    cones_no as Cones_No,
    remark as Remark,
    invoicedate as InvoiceDate,
    companyname as CompanyName,
    address1 as Address1,
    address2 as Address2,
    address3 as Address3,
    address4 as Address4,
    expiredate as ExpireDate,
    shipcompany as Shipcompany,
    shipaddress1 as ShipAddress1,
    shipaddress2 as ShipAddress2,
    shipaddress3 as ShipAddress3,
    shipaddress4   as ShipAddress4,
    contactpersonname as Contactpersonname,
    contactno         as Contactno,
    noofcarton        as Noofcarton,
    country_of_origin  as Country_Of_Origin,  
    postal_code         as Postal_Code,   
    country_of_destination as Country_Of_Destination,
    regioncode             as Regioncode
    
}
