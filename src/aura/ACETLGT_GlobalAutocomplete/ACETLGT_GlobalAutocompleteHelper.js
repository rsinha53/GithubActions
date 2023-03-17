({
    searchHelper : function(component,event,getInputkeyWord, helper) {
        // call the apex class method
        var bookOfBusiness = component.get("v.businessTypeCode"); 
        var action = component.get("c.fetchLookUpValues");        
        // set param to method  
        action.setParams({
            'searchKeyWord': getInputkeyWord,
            'ObjectName' : component.get("v.objectAPIName"),
            'ExcludeitemsList' : component.get("v.lstSelectedRecords"),
            'detailpagename' : component.get("v.detailPgName"),
            'originatortype' : component.get("v.originatorName")
        });
        // set a callBack    
        action.setCallback(this, function(response) {
            $A.util.removeClass(component.find("mySpinner"), "slds-show");
            var state = response.getState();
            console.log("-------"+state);
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                console.log("-------"+JSON.stringify(storeResponse));
                // set message
                helper.setWarningMessage(component, storeResponse);
                
                var interaction = component.get("v.interaction");                
                var memberDetail = component.get("v.Memberdetail");
                var hsaInvalid = false;              

                if(memberDetail != undefined && memberDetail != null) {
                    if(memberDetail.originatorRel != null){
                     var originatorRelation = memberDetail.originatorRel.trim();
                    }
                    if(memberDetail.subjectRelation != null){
                    var subjectRelation = memberDetail.subjectRelation.trim();
                    }
                    if(originatorRelation != 'Self' || originatorRelation == '' || originatorRelation == undefined ||
                        subjectRelation != 'Self' || subjectRelation == '' || subjectRelation == undefined ||
                        (interaction != undefined && interaction != null && interaction.Third_Party__c != '' && interaction.Third_Party__c != undefined)) {
                            hsaInvalid = true;                            
                    }
                } else {
                    hsaInvalid = true;
                }

                if (storeResponse.length > 0) {
                    for (var i = 0; i < storeResponse.length; i++) { 
                        if (storeResponse[i].Name != null){ 
                            if((bookOfBusiness =='TU' && storeResponse[i].Name == $A.get("$Label.c.ACETCallTopicMaterialsRequest"))||(bookOfBusiness =='UH' && storeResponse[i].Name == $A.get("$Label.c.ACETCallTopicMaterialsRequest"))){
                                storeResponse.splice(i, 1);
                            }
                        }
                        if(!$A.util.isEmpty(storeResponse)){
                            if (hsaInvalid && storeResponse[i].Name != null && storeResponse[i].Name.trim() == $A.get("$Label.c.ACETCallTopicHSAAccount"))
                                storeResponse.splice(i, 1);
                            if (storeResponse[i].Name != null && storeResponse[i].Name.trim() == $A.get("$Label.c.ACETCallTopicViewMemberEligibility"))
                                storeResponse.splice(i, 1);
                        }
                    }
               }
               helper.setWarningMessage(component, storeResponse);
               var fastrrackflow = component.get("v.fastrrackflow");
                var storeResponsestr = JSON.stringify(storeResponse);
                var lstSelectedRecords = component.get("v.lstSelectedRecords");
             if(fastrrackflow =='yes' ){
                    if(Object.keys(storeResponse).length > 0 && getInputkeyWord){
                        component.set("v.fastrrackflow",'');
                            component.set("v.lstSelectedRecords", storeResponse); 
                                       }
                else{
                    component.set("v.fastrrackflow",'');
                    component.set("v.listOfSearchRecords", storeResponse);  
                }
            }else{
                   component.set("v.listOfSearchRecords", storeResponse);    

            }
  
            }
        });
        // enqueue the Action  
        $A.enqueueAction(action);
    },

    setWarningMessage: function(component, storeRes){
        // if storeResponse size is equal 0 ,display No Records Found... message on screen.                }
        if (storeRes.length == 0) {
            component.set("v.Message", 'No Records Found...');
        } else {
            component.set("v.Message", '');
            // set searchResult list with return value from server.
        }
    }
})