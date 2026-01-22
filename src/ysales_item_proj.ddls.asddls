@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@EndUserText.label: 'PROJ CDS ITEM'


define root  view entity YSALES_ITEM_PROJ
 provider contract transactional_query
as projection on YSALES1_ITEM
{
    key Invno,
    key Sno,
    Material,
    MaterialDesc,
    Hsnno,
    Lotno,
    Pkg,
    Qty,
    Uom,
    Grosswt,
    Amtinr,
    Cgstper,
    Cgstamt,
    Sgstper,
    Sgstamt,
    Igstamt,
    Igstper,
    Totalamt,
    Amt_USD,
    basicAmt
}
