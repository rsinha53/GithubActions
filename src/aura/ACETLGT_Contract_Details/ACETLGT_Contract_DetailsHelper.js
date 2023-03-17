({
	getProvAgreementWebservice : function(component,event,helper,rowData,providerinfoObj) {
        var providerinfoObj =providerinfoObj;
        var rowData =rowData;
       var action = component.get("c.GetMedProvAgreementWebservice");   
        action.setParams({
               ProviderId : providerinfoObj.providerId,
               TaxId :providerinfoObj.taxId,
               providerTINTypeCode:providerinfoObj.providerTINTypeCode,
               addressId:providerinfoObj.addressId,
               addressTypeCode:providerinfoObj.addressTypeCode,
               ContractHeaderId:rowData.ContractHeaderId,
               ContractDetailId:rowData.ContractDetailId,
               NetworkId:rowData.Network_ID
        });
       action.setCallback(this, function(a) {
            var state = a.getState();
            if(state == "SUCCESS"){
                var result = a.getReturnValue();
                if(!$A.util.isEmpty(result) && !$A.util.isUndefined(result)){
                    console.log(result);
                    component.set("v.GetMedProvAgreementresponce",result);
                    component.set("v.network",result.lstAgreementDetail[0].network);
                    component.set("v.lstAgreementDetail",result.lstAgreementDetail[0]);
                    component.set("v.pricingSetId",result.pricingSetId);
                }
            }else{
                console.log('getProvAgreementWebservice Error.');
            }
            var tabKey = component.get("v.AutodocKey")+component.get("v.GUIkey");
            setTimeout(function(){
                //alert("====");
                window.lgtAutodoc.initAutodoc(tabKey);
            },1);
        });
        $A.enqueueAction(action);
        
    }
})