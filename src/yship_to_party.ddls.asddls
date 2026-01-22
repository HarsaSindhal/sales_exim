@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'F4 SHIPTOPARTY'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity YSHIP_TO_PARTY as select from I_Customer as A 
inner join I_BillingDocumentPartner as b on (b.Customer = A.Customer and b.PartnerFunction = 'WE' )
{
 key A.Customer,
  A.CustomerName,
  A.CityName ,
  A.TaxNumber3,
  A.StreetName,
  A.PostalCode,
  A.Country,
  A.Region 
}
