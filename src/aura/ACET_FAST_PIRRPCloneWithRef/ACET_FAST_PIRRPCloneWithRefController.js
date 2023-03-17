({
    onInit : function(component, event, helper) {
        var pirRPRecId = component.get("v.recordId") 
        var action = component.get("c.clonePIRRPWithReference");
        action.setParams({
            pirRPId: pirRPRecId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === 'SUCCESS') {
                var pirRPRefData = response.getReturnValue();
                component.set("v.pirRPRefData",pirRPRefData);
                if(pirRPRefData.Case__r.Status == 'Closed'){
                    helper.closePopUpWindow(component, event);
                    helper.showToast(component, event,'Closed Case','warning', 'RP record cannot be created/cloned in closed case');
                }
                if(pirRPRefData.PIR_Resolution_Partners_References__r)
                component.set("v.pirRPRefNubList",pirRPRefData.PIR_Resolution_Partners_References__r);
                component.find("rpnField").set("v.value", pirRPRefData.Provider_Matrix_Reactive__c);
                component.find("caseField").set("v.value", pirRPRefData.Case__c);
                component.find("enField").set("v.value", pirRPRefData.Escalation_Notes__c);
                component.find("rpoField").set("v.value", pirRPRefData.Resolution_Partner_Outcome__c);
                component.find("slacdField").set("v.value", pirRPRefData.SLA_Completion_Date__c);
                component.find("slardField").set("v.value", pirRPRefData.SLA_Routed_Date__c);
            }
            else {
                alert('Error in getting data');
            }
        });
        $A.enqueueAction(action);

        
    },
    handleClose : function(component, event, helper){
        $A.get("e.force:closeQuickAction").fire();
    },
    handleSuccess : function(component, event, helper) {
        var record = event.getParam("response");
        var apiName = record.apiName;
        var myRecordId = record.id; // ID of updated or created record
        var pirRPRefNubList = '';
        pirRPRefNubList = component.get("v.pirRPRefNubList");
        if(pirRPRefNubList){
            var RowItemList = component.get("v.newPIRRPRefNubData");
            //alert('Before-->'+JSON.stringify(pirRPRefNubList));
            for (var i = 0; i < pirRPRefNubList.length; i++) {
                RowItemList.push({
                    'sobjectType': 'PIR_Resolution_Partners_Reference__c',
                    'PIR_Resolution_Partner__c': myRecordId,
                    'Reference__c': pirRPRefNubList[i].Reference__c,
                    'Completed__c': 'false'
                });
                component.set("v.newPIRRPRefNubData", RowItemList);

            }
            var action = component.get("c.savePIRRPReference");
            action.setParams({
                "lstPIRRPRefs": RowItemList
            }); 
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Success',
                        message: 'PIR References created successfully',
                        duration:' 3000',
                        key: 'info_alt',
                        type: 'success',
                        mode: 'pester'
                    });
                    
                    /*component.find("navigation").navigate({
                        "type" : "standard__recordPage",
                        "attributes": {
                            "recordId"      : myRecordId,
                            "actionName"    : "view"   //clone, edit, view
                        }
                    }, true);*/
                    var navEvt = $A.get("e.force:navigateToSObject");
                    navEvt.setParams({
                    "recordId": myRecordId
                    });
                    navEvt.fire();
                    $A.get("e.force:closeQuickAction").fire();
                    //$A.get('e.force:refreshView').fire();
                
                    toastEvent.fire();
                }
            });
            $A.enqueueAction(action);
        }
        
        
    }
})