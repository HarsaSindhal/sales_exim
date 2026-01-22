@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@EndUserText.label: 'PROJ CDS'



define root view entity YSALES_HEADER_PROJ
 provider contract transactional_query
 as projection on YSALES_HEADER
{
    key Invno,
    Billtoparty,
    Statecode1,
    Customerpo,
    Salesdocdate,
    Deliveryno,
    Agent,
    Shiptoparty,
    Shipstatecode,
    Gstin,
    Transporter,
    Lrdate,
    Vehicleno,
    Driverno,
    Transportmode,
    LRNo,
    Cones_No,
    Remark,
    InvoiceDate,
    CompanyName,
    Address1,
    Address2,
    Address3,
    Address4,
    ExpireDate,
    Shipcompany,
    ShipAddress1,
    ShipAddress2,
    ShipAddress3,
    ShipAddress4,
    Contactpersonname,
    Contactno,
    Noofcarton,
    Country_Of_Origin,
    Postal_Code,
    Country_Of_Destination,
    Regioncode
}
