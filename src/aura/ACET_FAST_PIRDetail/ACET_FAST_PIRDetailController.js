({
    getCaseRec: function(component, event, helper){
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
                component.set("v.parentRecordType",result.RecordType.Name);
                
            }
        });
        $A.enqueueAction(action);
        
        var Useraction = component.get("c.getUserDetails");
        Useraction.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var result = response.getReturnValue();
                component.set("v.userDetails",result);
                if(result.UserRole.Name == 'OPO PIR' ){
                    component.set("v.OPOuser",true);
                }
                if(result.UserRole.Name == 'PIR - Proactive Action' || result.UserRole.Name == 'PIR - Reactive Resolution' ){
                    component.set("v.RorPuser",true);
                }
            }
        });
        $A.enqueueAction(Useraction);
    },
    getPIRID: function(component, event, helper){
        var parentRecordTypeName = component.get("v.parentRecordType");
        var caseId = component.get("v.recordId");
        var action = component.get("c.getPIRRecId");
        action.setParams({
            "caseRecId":caseId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" && parentRecordTypeName ==="Proactive Action"){
                var result = response.getReturnValue();
                component.set("v.pirId",result);
            }else if (state === "SUCCESS"){
                var result = response.getReturnValue();
                component.set("v.pirId",result);
            }
        });
        $A.enqueueAction(action);
    },
    handleonLoad: function(component, event, helper){
        helper.showSpinner(component, event);
        var pirIdVar = component.get("v.pirId");
        var parentRecordTypeName = component.get("v.parentRecordType");
        if(pirIdVar!='' && pirIdVar!=null && pirIdVar!=undefined){
            var action = component.get("c.getPIRRec");
            action.setParams({
                "pirID":pirIdVar
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                console.log('state==>'+state);
                if(state === "SUCCESS"){
                    var result = response.getReturnValue();
                    component.set("v.pirRec",result.pirRecord);
                    console.log('result==>'+JSON.stringify(result));
                  	console.log('root cause 1==>'+result.pirRecord.Root_Cause_1_Key_Code__c);
                    console.log('root cause 2==>'+result.pirRecord.Root_Cause_2_Key_Code__c);
                    console.log('root cause 3==>'+result.pirRecord.Root_Cause_3_Key_Code__c);
                    console.log('root cause 4==>'+result.pirRecord.Root_Cause_4_Key_Code__c);
                    console.log('root cause 5==>'+result.pirRecord.Root_Cause_5_Key_Code__c);
                    component.set("v.rootCause1", result.pirRecord.Root_Cause_1_Key_Code__c);
                    component.set("v.rootCause1Value", result.pirRecord.Root_Cause_1__c); 
                    component.set("v.rootCause1List", result.rc1List);
                    component.set("v.rootCause2", result.pirRecord.Root_Cause_2_Key_Code__c);
                    component.set("v.rootCause2Value", result.pirRecord.Root_Cause_2__c);
                    component.set("v.rootCause2List", result.rc2List);
                    component.set("v.rootCause3", result.pirRecord.Root_Cause_3_Key_Code__c);
                    component.set("v.rootCause3Value", result.pirRecord.Root_Cause_3__c);
                    component.set("v.rootCause3List", result.rc3List);
                    component.set("v.rootCause4", result.pirRecord.Root_Cause_4_Key_Code__c);
                    component.set("v.rootCause4Value", result.pirRecord.Root_Cause_4__c);
                    component.set("v.rootCause4List", result.rc4List);
                    component.set("v.rootCause5", result.pirRecord.Root_Cause_5_Key_Code__c);
                    component.set("v.rootCause5Value", result.pirRecord.Root_Cause_5__c);
                    component.set("v.rootCause5List", result.rc5List); 
                    /*if(parentRecordTypeName==='Reactive Resolution'){
                        var isNoRef=component.get("v.pirRec.No_Reference_Facilitated_Referral__c");
                        component.find("noRefId").set("v.value", isNoRef);
                        var isMultipleClaims=component.get("v.pirRec.Exact_Count_Unknown_Multiple_Claims__c");
                        component.find("countUnkownId").set("v.value", isMultipleClaims);  
                    }*/
                }
                helper.hideSpinner(component, event);
            });
            $A.enqueueAction(action);   
        }else{
            if(parentRecordTypeName == 'Reactive Resolution' || parentRecordTypeName != 'Proactive Action'){
               // component.find("noRefId").set("v.value", true);
               // component.find("countUnkownId").set("v.value", true);
            }
            helper.hideSpinner(component, event);
        }
    },
    handleRefNumChange: function(component, event, helper){
        var refValue =  event.getSource().get("v.value");
        if(refValue!='' && refValue!=null && refValue!=undefined){
            component.find("noRefId").set("v.value", false);
        }else{
            component.find("noRefId").set("v.value", true);
        }
    },
    handleCountChange: function(component, event, helper){
        var countValue =  event.getSource().get("v.value");
        if(countValue!='' && countValue!=null && countValue!=undefined){
            component.find("countUnkownId").set("v.value", false);
        }else{
            component.find("countUnkownId").set("v.value", true);
        }
    },
    handleOnSubmit: function(component, event, helper){
        helper.showSpinner(component, event);
        var caseRecord=component.get("v.caseRec");
        event.preventDefault();
        var fields = event.getParam("fields");
        helper.assignRootCauseFieldsData(component, event, fields);
        if(component.get("v.parentRecordType")=='Reactive Resolution'){
            //Fast Submit
            if(helper.validateFastMandatoryFields(component, event) && helper.validateMarketLOBFields(component, event, caseRecord)){
                if(component.find("statusId").get("v.value")==='Closed'){
                    if(helper.validateClosedStatus(component, event, caseRecord)){
                        component.find("FASTform").submit(fields);
                    }
                }
                else{
                    component.find("FASTform").submit(fields); 
                }   
            }
        }else{
            //PIP Submit
            helper.assignRootCauseFieldsData(component, event,fields);
            if(helper.validatePipMandatoryFields(component, event) && helper.validatePipCustom(component, event)){
                if(component.find("pipStatusId").get("v.value")=='Closed'){
                    if(helper.validatePipClosedStatus(component, event)){
                        component.find("form").submit(fields);
                    }
                }else{
                    component.find("form").submit(fields);
                }
            }
        }
        helper.hideSpinner(component, event);
    },
    handleOnSuccess: function(component, event, helper){
        var record = event.getParam("response");
        component.find("notificationsLibrary").showToast({
            "variant":"success",
            "title": "SUCCESS",
            "message": "PIR Detail updated Successfull",
            "duration": 5000
        });
        var closeActionMethod = component.get('c.closeAction');
        $A.enqueueAction(closeActionMethod);
    },
    handleError: function (component, event, helper) {
        console.log('error---');
    },
    closeAction: function(component, event, helper){
        var popVar = component.get("v.editPIRVar");
        if(popVar){
            component.set("v.editPIRVar",false);
        }else{
            $A.get("e.force:closeQuickAction").fire();
            $A.get('e.force:refreshView').fire();
        }
    },
    handleRC1Change: function(component, event, helper){
        helper.showSpinner(component, event);
        var selectedValue = event.getSource().get("v.value");
        component.set("v.rootCause1Value","");
        var rc1List = component.get("v.rootCause1List");
        for (var i = 0; i < rc1List.length; i++) {
            if(rc1List[i].rcCode==selectedValue){component.set("v.rootCause1Value",rc1List[i].rcName);}
        }
        component.set("v.rootCause2","");
        component.set("v.rootCause2Value","");
        component.set("v.rootCause2List",[]);
        component.set("v.rootCause3","");
        component.set("v.rootCause3Value","");
        component.set("v.rootCause3List",[]);
        component.set("v.rootCause4","");
        component.set("v.rootCause4Value","");
        component.set("v.rootCause4List",[]);
        component.set("v.rootCause5","");
        component.set("v.rootCause5Value","");
        component.set("v.rootCause5List",[]);
        
        
        var action = component.get("c.getrootCause2List");
        action.setParams({ "prntRCCode":selectedValue });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                component.set("v.rootCause2List",response.getReturnValue());                
            }
            helper.hideSpinner(component, event);
        });
        $A.enqueueAction(action);
    },
    handleRC2Change: function(component, event, helper){
        helper.showSpinner(component, event);
        component.set("v.rootCause3","");
        component.set("v.rootCause3Value","");
        component.set("v.rootCause3List",[]);
        component.set("v.rootCause4","");
        component.set("v.rootCause4Value","");
        component.set("v.rootCause4List",[]);
        component.set("v.rootCause5","");
        component.set("v.rootCause5Value","");
        component.set("v.rootCause5List",[]);
        
        var selectedValue = event.getSource().get("v.value");
        component.set("v.rootCause2Value","");
        var rc2List = component.get("v.rootCause2List");
        for (var i = 0; i < rc2List.length; i++) {
            if(rc2List[i].rcCode==selectedValue){component.set("v.rootCause2Value",rc2List[i].rcName);}
        }
        var action = component.get("c.getrootCause3List");
        action.setParams({ "prntRCCode":selectedValue });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                component.set("v.rootCause3List",response.getReturnValue());                
            }
            helper.hideSpinner(component, event);
        });
        $A.enqueueAction(action);
    },
    handleRC3Change: function(component, event, helper){
        helper.showSpinner(component, event);
        component.set("v.rootCause4","");
        component.set("v.rootCause4Value","");
        component.set("v.rootCause4List",[]);
        component.set("v.rootCause5","");
        component.set("v.rootCause5Value","");
        component.set("v.rootCause5List",[]);
        
        var selectedValue = event.getSource().get("v.value");
        component.set("v.rootCause3Value","");
        var rc3List = component.get("v.rootCause3List");
        for (var i = 0; i < rc3List.length; i++) {
            if(rc3List[i].rcCode==selectedValue){component.set("v.rootCause3Value",rc3List[i].rcName);}
        }
        var action = component.get("c.getrootCause4List");
        action.setParams({ "prntRCCode":selectedValue });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                component.set("v.rootCause4List",response.getReturnValue()); 
            }
            helper.hideSpinner(component, event);
        });
        $A.enqueueAction(action);
    },
    handleRC4Change: function(component, event, helper){
        helper.showSpinner(component, event);
        component.set("v.rootCause5","");
        component.set("v.rootCause5Value","");
        component.set("v.rootCause5List",[]);
        
        var selectedValue = event.getSource().get("v.value");
        component.set("v.rootCause4Value","");
        var rc4List = component.get("v.rootCause4List");
        for (var i = 0; i < rc4List.length; i++) {
            if(rc4List[i].rcCode==selectedValue){component.set("v.rootCause4Value",rc4List[i].rcName);}
        }
        var action = component.get("c.getrootCause5List");
        action.setParams({ "prntRCCode":selectedValue });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                component.set("v.rootCause5List",response.getReturnValue());                
            }
            helper.hideSpinner(component, event);
        });
        $A.enqueueAction(action);
    },
    handleRC5Change: function(component, event, helper){
        helper.showSpinner(component, event);
        var selectedValue = event.getSource().get("v.value");
        component.set("v.rootCause5Value","");
        var rc5List = component.get("v.rootCause5List");
        for (var i = 0; i < rc5List.length; i++) {
            if(rc5List[i].rcCode==selectedValue){component.set("v.rootCause5Value",rc5List[i].rcName);}
        }
        helper.hideSpinner(component, event);
    },
    
})