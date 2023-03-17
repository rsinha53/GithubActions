({
    getCaseRec : function(component, event, helper){
        var caseId = component.get("v.recordId");
        var action = component.get("c.getCaseRecord");
        action.setParams({
            "caseRecId":caseId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var result = response.getReturnValue();
                component.set("v.caseRec",result);
                var caseRecord=component.get("v.caseRec");
                component.set("v.taxID",caseRecord.PC_Provider_TIN__c);
               // component.set("v.parentRecordType",result.RecordType.Name);
                 component.find("alertsAI").alertsMethod();
            }
        });
        $A.enqueueAction(action);

    
    },
})