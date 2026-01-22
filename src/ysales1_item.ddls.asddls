@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'SALES ITEM CDS'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity YSALES1_ITEM as select from ysales_item
{
    key invno as Invno,
    key sno as Sno,
    material as Material,
    matedesc as MaterialDesc,
    hsnno as Hsnno,
    lotno as Lotno,
    pkg as Pkg,
    qty as Qty,
    uom as Uom,
    grosswt as Grosswt,
    amtinr as Amtinr,
    cgstper as Cgstper,
    cgstamt as Cgstamt,
    sgstper as Sgstper,
    sgstamt as Sgstamt,
    igstamt as Igstamt,
    igstper as Igstper,
    totalamt as Totalamt,
    basicamt as basicAmt,
    amt_usd as Amt_USD
    
}
