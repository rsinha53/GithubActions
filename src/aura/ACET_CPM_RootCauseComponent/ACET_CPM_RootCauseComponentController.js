({
	handleSelect: function (component, event, helper){
        var selectedMenuItemValue = event.getParam("value");
        if(selectedMenuItemValue =='updateRootCause'){
        var recId = component.get("v.recordId");
        var action = component.get("c.fetchRootCauseData");
        action.setParams({
            'recordId' : recId
        });
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var StoreResponse = response.getReturnValue();
                
                var jsonData = component.get("v.fieldsJSON");
                if(undefined!=StoreResponse.Root_Cause_1_Key_Code__c && ''!=StoreResponse.Root_Cause_1_Key_Code__c && null!=StoreResponse.Root_Cause_1_Key_Code__c)
                jsonData['rc1KeyCode'] = StoreResponse.Root_Cause_1_Key_Code__c;
                if(undefined!=StoreResponse.Root_Cause_1__c && ''!=StoreResponse.Root_Cause_1__c && null!=StoreResponse.Root_Cause_1__c)
            	jsonData['rc1'] = StoreResponse.Root_Cause_1__c;
                if(undefined!=StoreResponse.Root_Cause_2_Key_Code__c && ''!=StoreResponse.Root_Cause_2_Key_Code__c && null!=StoreResponse.Root_Cause_2_Key_Code__c)
                jsonData['rc2KeyCode'] = StoreResponse.Root_Cause_2_Key_Code__c;
                if(undefined!=StoreResponse.Root_Cause_2__c && ''!=StoreResponse.Root_Cause_2__c && null!=StoreResponse.Root_Cause_2__c)
            	jsonData['rc2'] = StoreResponse.Root_Cause_2__c;
                if(undefined!=StoreResponse.Root_Cause_3_Key_Code__c && ''!=StoreResponse.Root_Cause_3_Key_Code__c && null!=StoreResponse.Root_Cause_3_Key_Code__c)
                jsonData['rc3KeyCode'] = StoreResponse.Root_Cause_3_Key_Code__c;
                if(undefined!=StoreResponse.Root_Cause_3__c && ''!=StoreResponse.Root_Cause_3__c && null!=StoreResponse.Root_Cause_3__c)
            	jsonData['rc3'] = StoreResponse.Root_Cause_3__c;
                if(undefined!=StoreResponse.Root_Cause_4_Key_Code__c && ''!=StoreResponse.Root_Cause_4_Key_Code__c && null!=StoreResponse.Root_Cause_4_Key_Code__c)
                jsonData['rc4KeyCode'] = StoreResponse.Root_Cause_4_Key_Code__c;
                if(undefined!=StoreResponse.Root_Cause_4__c && ''!=StoreResponse.Root_Cause_4__c && null!=StoreResponse.Root_Cause_4__c)
            	jsonData['rc4'] = StoreResponse.Root_Cause_4__c;
                if(undefined!=StoreResponse.Root_Cause_5_Key_Code__c && ''!=StoreResponse.Root_Cause_5_Key_Code__c && null!=StoreResponse.Root_Cause_5_Key_Code__c)
                jsonData['rc5KeyCode'] = StoreResponse.Root_Cause_5_Key_Code__c;
                if(undefined!=StoreResponse.Root_Cause_5__c && ''!=StoreResponse.Root_Cause_5__c && null!=StoreResponse.Root_Cause_5__c)
            	jsonData['rc5'] = StoreResponse.Root_Cause_5__c;
                component.set("v.fieldsJSON",jsonData);
                component.set("v.editRootCause", true);
                
            }else{
                alert('Something went wrong..');
            }
        });
        $A.enqueueAction(action);
        }
    },
    
    saveRootCasue: function (component, event, helper){
        var recId = component.get("v.recordId");
        var jsonDataForRC = component.get("v.fieldsJSONforRC");
       
        var jsonData = component.get("v.fieldsJSON");
        if(undefined!=jsonData.rc1KeyCode && ''!=jsonData.rc1KeyCode && null!=jsonData.rc1KeyCode)
            jsonDataForRC['Root_Cause_1_Key_Code__c'] = jsonData.rc1KeyCode;
        if(undefined!=jsonData.rc1 && ''!=jsonData.rc1 && null!=jsonData.rc1)
            jsonDataForRC['Root_Cause_1__c'] = jsonData.rc1;
        if(undefined!=jsonData.rc2KeyCode && ''!=jsonData.rc2KeyCode && null!=jsonData.rc2KeyCode)
            jsonDataForRC['Root_Cause_2_Key_Code__c'] = jsonData.rc2KeyCode;
        if(undefined!=jsonData.rc2 && ''!=jsonData.rc2 && null!=jsonData.rc2)
            jsonDataForRC['Root_Cause_2__c'] = jsonData.rc2;
        if(undefined!=jsonData.rc3KeyCode && ''!=jsonData.rc3KeyCode && null!=jsonData.rc3KeyCode)
            jsonDataForRC['Root_Cause_3_Key_Code__c'] = jsonData.rc3KeyCode;
        if(undefined!=jsonData.rc3 && ''!=jsonData.rc3 && null!=jsonData.rc3)
            jsonDataForRC['Root_Cause_3__c'] = jsonData.rc3;
        if(undefined!=jsonData.rc4KeyCode && ''!=jsonData.rc4KeyCode && null!=jsonData.rc4KeyCode)
            jsonDataForRC['Root_Cause_4_Key_Code__c'] = jsonData.rc4KeyCode;
        if(undefined!=jsonData.rc4 && ''!=jsonData.rc4 && null!=jsonData.rc4)
            jsonDataForRC['Root_Cause_4__c'] = jsonData.rc4;
        if(undefined!=jsonData.rc5KeyCode && ''!=jsonData.rc5KeyCode && null!=jsonData.rc5KeyCode)
            jsonDataForRC['Root_Cause_5_Key_Code__c'] = jsonData.rc5KeyCode;
        if(undefined!=jsonData.rc5 && ''!=jsonData.rc5 && null!=jsonData.rc5)
            jsonDataForRC['Root_Cause_5__c'] = jsonData.rc5;
        
        var selectedMenuItemValue = event.getParam("value");
        //if(selectedMenuItemValue =='updateRootCause'){
        var action = component.get("c.saveRootCauseData");
        action.setParams({
            'recordId' : recId,
            'keyValuePairs' : jsonDataForRC
        });
        
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var StoreResponse = response.getReturnValue();
                //alert('success');
                component.set("v.editRootCause", false);
                $A.get('e.force:refreshView').fire();
                
            }else{
                alert('Something went wrong..');
            }
        });
        $A.enqueueAction(action);
        //}
    },
    
    closePopUp : function (component, event, helper){
        component.set("v.editRootCause", false); 
    }
})