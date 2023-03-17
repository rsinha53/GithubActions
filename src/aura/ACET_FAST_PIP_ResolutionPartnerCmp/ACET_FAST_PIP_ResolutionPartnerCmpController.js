({
    doInit : function(component, event, helper) {
        var pageRef = component.get("v.pageReference");
        var state = pageRef.state; // state holds any query params
        var base64Context = state.inContextOfRef;
        /*
            *For some reason, the string starts with "1.", if somebody knows why,
            *this solution could be better generalized.
        */
        if (base64Context.startsWith("1\.")) {
            base64Context = base64Context.substring(2);
        }
        var addressableContext = JSON.parse(window.atob(base64Context));
        var caseRecID = addressableContext.attributes.recordId;
        var action=component.get("c.getCaseRecordType");
        action.setParams({ 
            "caseRecId":caseRecID
        });
        action.setCallback(this, function(response){ 
            var state = response.getState();
            if (state === "SUCCESS")
            {
                var res = response.getReturnValue();
                component.set("v.caseWrap", res);
                console.log('caseRec-->'+ res.caseRec);
                if(res.objectName =='Case'){
                    component.set("v.caseRecType",res.caseRec.RecordType.Name);
                   // console.log('caseRecType==>'+component.get("v.caseRecType"));
                  component.set("v.caseNum",res.caseRec.CaseNumber);
                    if(res.caseRec.Status == 'Closed'){
                        //helper.closePopUpWindow(component, event);
                    
                        helper.showToast(component, event,'Closed Case','warning', 'RP record cannot be created/cloned in closed case');
                    helper.goBackToCase(component, event);
                    }
                    if(component.get("v.caseRecType")=='Reactive Resolution'){
                        component.set("v.resolutionType",'Reactive Resolution Partners');
                        component.set("v.rpReactiveRecordtypeId",res.resolutionRcordtypeId);
                    }else{
                        component.set("v.resolutionType",'Proactive Active Partners');
                        component.set("v.rpProactiveRecordtypeId",res.resolutionRcordtypeId);
                    }
                } else if(res.objectName =='Case_Item__c'){
                    component.set("v.caseRecType",'Reactive Resolution');
                    component.set("v.rpReactiveRecordtypeId",res.resolutionRcordtypeId);
                    component.set("v.resolutionType",'Reactive Resolution Partners');
                }
                
            }
        });
        $A.enqueueAction(action);
    },
    onRecordSubmit: function(component, event, helper) {
        event.preventDefault(); // stop form submission
        if(component.get("v.caseRecType")=='Reactive Resolution'){
            var showValidationError = false;
            var vaildationFailReason = "Below Fields are mandatory"+"\n";
            if($A.util.isEmpty(component.find("fastRPName").get("v.value"))){
                showValidationError = true;
                component.find("fastRPName").set("v.required",true);
                vaildationFailReason = vaildationFailReason+"* Resolution Partners Name"+" \n";
            }
           /* if($A.util.isEmpty(component.find("slaRoute").get("v.value"))){
                showValidationError = true;
                vaildationFailReason = vaildationFailReason+"* SLA Routed Date"+" \n";   
            } */
            if($A.util.isEmpty(component.find("rpOutcome").get("v.value"))){
                showValidationError = true;
                vaildationFailReason = vaildationFailReason+"* Resolution Partner Outcome"+" \n";   
            }
            if (!showValidationError) {                
                var eventFields = event.getParam("fields");
                //eventFields["RecordTypeId"] =component.get("v.caseWrap.resolutionRcordtypeId");
                component.find('FastPipForm').submit(eventFields);  
            } else {
                component.find('fastMessage').setError(vaildationFailReason);
            }
         } 
        else{
             var showValidationError = false;
            var vaildationFailReason = "Below Fields are mandatory"+"\n";
            
             if($A.util.isEmpty(component.find("pipRPName").get("v.value"))){
                showValidationError = true;
                component.find("pipRPName").set("v.required",true);
                vaildationFailReason = vaildationFailReason+"* Internal Business Partner"+" \n";
            }
		
            if (!showValidationError) {                
                var eventFields = event.getParam("fields");
                //eventFields["RecordTypeId"] =component.get("v.caseWrap.resolutionRcordtypeId");
                component.find('FastPipForm').submit(eventFields);  
            } else {
                component.find('pipMessage').setError(vaildationFailReason);
            }
            
        }   
    },     
    onRecordSubmitCaseItem: function(component, event, helper) {
        event.preventDefault(); // stop form submission
        if(component.get("v.caseRecType")=='Reactive Resolution'){
            var showValidationError = false;
            var vaildationFailReason = "Below Fields are mandatory"+"\n";
            if($A.util.isEmpty(component.find("fastRPName").get("v.value"))){
                showValidationError = true;
                component.find("fastRPName").set("v.required",true);
                vaildationFailReason = vaildationFailReason+"* Resolution Partners Name"+" \n";
            }
            /* if($A.util.isEmpty(component.find("slaRoute").get("v.value"))){
                showValidationError = true;
                vaildationFailReason = vaildationFailReason+"* SLA Routed Date"+" \n";   
            } */
            if($A.util.isEmpty(component.find("rpOutcome").get("v.value"))){
                showValidationError = true;
                vaildationFailReason = vaildationFailReason+"* Resolution Partner Outcome"+" \n";   
            }
            if (!showValidationError) {                
                var eventFields = event.getParam("fields");
                //eventFields["RecordTypeId"] =component.get("v.caseWrap.resolutionRcordtypeId");
                component.find('CaseItemForm').submit(eventFields);  
            } else {
                component.find('fastMessage').setError(vaildationFailReason);
            }
         }
    },
    handleOnSuccess : function(component, event, helper){
        //var record = event.getParam("response");
        var payload = event.getParams().response;
        console.log(payload.id);
        
        var recId = payload.id;
        
        var action = component.get("c.getRPName");        
        action.setParams({
            "recId": recId
        });      
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state-->'+state);
            if (state === "SUCCESS") {
                var finalResult = response.getReturnValue();
                console.log('rpName-->'+finalResult.rpName);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Success',
                    message: 'Resolution Partner '+ finalResult.rpName+' saved successfully',
                    duration:' 3000',
                    key: 'info_alt',
                    type: 'success',
                    mode: 'dismissible'
                });
                toastEvent.fire();
                //US3246254 - RP record - Details page view   
                var workspaceAPI = component.find("workspace");
                workspaceAPI.getFocusedTabInfo().then(function(response) {
                    var focusedTabId = response.tabId;
                    workspaceAPI.closeTab({tabId: focusedTabId});
                    $A.get('e.force:refreshView').fire();
                    workspaceAPI.openTab({
                        url: '/lightning/r/PIR_Resolution_Partner__c/'+ finalResult.rpID +'/view',
                        focus: true
                    }).then(function(response) {})
                    .catch(function(error) {
                    });
                })
            }
        });
        $A.enqueueAction(action);       
    },
    
    handlersubmite: function(component, event, helper){
        console.log('submitte success');
    },
    goBackToCase: function(component, event, helper){
 		helper.goBackToCase(component, event);
    },
})