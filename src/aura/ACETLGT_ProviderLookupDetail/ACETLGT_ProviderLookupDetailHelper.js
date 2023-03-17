({
    getProviderLookupDetail : function(component,event,helper,providerId,taxId,providerTINTypeCode,addressId,addressTypeCode,returningFrom) {
     var action = component.get("c.getProviderDetail");   
        action.setParams({
            providerId: providerId,
            taxId : taxId,
            providerTINTypeCode: providerTINTypeCode,
            addressId: addressId,
            addressTypeCode:addressTypeCode,
            returningFrom:returningFrom
        });
       action.setCallback(this, function(a) {
            
            var state = a.getState();
            console.log('----state---'+state);
            //check if result is successfull
            if(state == "SUCCESS"){
                var result = a.getReturnValue();
                console.log('------result--------'+JSON.stringify(result));
                if(!$A.util.isEmpty(result) && !$A.util.isUndefined(result)){
                    if (!$A.util.isEmpty(result.resultWrapper) && !$A.util.isUndefined(result.resultWrapper)){
                        console.log('!!!provider Detail'+result.resultWrapper);
                        console.log('!!!provider Detail'+JSON.stringify(result.resultWrapper));
                        component.set("v.detailResult",result.resultWrapper);
                        console.log('!!!provider Detail language'+JSON.stringify(result.LanguageList));
                        component.set("v.languageList",result.LanguageList);
                    }   
                }
                setTimeout(function(){
                    var tabKey = component.get("v.AutodocKey")+component.get("v.GUIkey");
                    //alert(tabKey);
                    window.lgtAutodoc.initAutodoc(tabKey);
                },2);  
            }else if(state == "ERROR"){
                
                
            }
           
        });
        $A.enqueueAction(action);
                
    }
})