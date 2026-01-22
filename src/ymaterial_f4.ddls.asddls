@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Search Help'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define  view entity YMATERIAL_F4 as select from I_Product as a
 left outer join I_ProductDescription as b on ( b.Product = a.Product and b.Language = 'E')
 left outer join I_ProductPlantBasic as c on (c.Product = a.Product)
 
{
 key a.Product ,
 b.ProductDescription,
 c.ConsumptionTaxCtrlCode   
}



//where
//b.Product like 'YG%'

