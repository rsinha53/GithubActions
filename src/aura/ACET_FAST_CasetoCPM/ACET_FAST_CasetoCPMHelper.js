({
    submitRecord: function(component, event){
        var wJSONVar = JSON.stringify(component.get("v.cpmWrap"));
        console.log('wJSONVar==>'+wJSONVar);
        var action = component.get("c.sendToCPM");
        action.setParams({ "wrapperJSON" : wJSONVar });
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log('state==>'+state);
            if(state === "SUCCESS"){
                console.log('inside if');
                var finalResult = response.getReturnValue();
                if(finalResult.isSuccess == false){
                    this.showToast(component,event,"ERROR","ERROR",finalResult.message,5000);
                }else{
                    $A.get("e.force:closeQuickAction").fire();
                    var workspaceAPI = component.find("workspace");
                    workspaceAPI.openTab({
                        url: '/lightning/cmp/c__ACETLGT_AutoRouteCase?c__id='+finalResult.caseRecordId,
                        focus: true
                    }).then(function(response) {})
                    .catch(function(error) {
                    });
                    this.showToast(component,event,"SUCCESS","SUCCESS",finalResult.message,5000);
                } 
            }
            else{
                //code for not success
            }
        });
        $A.enqueueAction(action);
    },
    validateFirstScreen: function(component, event){
        var isValidated= true;
        var caseRec = component.get("v.cpmWrap.caseRec");
        var emptyFields = [];
        if(caseRec.Status == '' || caseRec.Status == null){emptyFields.push("Status");}
        if(caseRec.Retro_Reason_Code__c == '' || caseRec.Retro_Reason_Code__c == null){emptyFields.push("Retro Reason code");}
        if(caseRec.Submitting_Department__c == '' || caseRec.Submitting_Department__c == null){emptyFields.push("Submitting Department");}
        if(caseRec.Topic__c == '' || caseRec.Topic__c == null){emptyFields.push("Topic");}
        if(caseRec.PC_Contact_Type__c == '' || caseRec.PC_Contact_Type__c == null){emptyFields.push("Contact Type");}
        if(caseRec.Description == '' || caseRec.Description == null){emptyFields.push("Description");}
        if(caseRec.Origin == '' || caseRec.Origin == null){emptyFields.push("Case Origin");}
        if(caseRec.Subject == '' || caseRec.Subject == null){emptyFields.push("Subject");}
        if(caseRec.PC_Project_Description__c == '' || caseRec.PC_Project_Description__c == null){emptyFields.push("Project Description");}
        if(caseRec.Provider_Type__c == '' || caseRec.Provider_Type__c == null){emptyFields.push("Provider Type");}
        if(caseRec.PC_Provider_TIN__c == '' || caseRec.PC_Provider_TIN__c == null){emptyFields.push("Provide TIN");}
        if(caseRec.PC_Provider_State__c == '' || caseRec.PC_Provider_State__c == null){emptyFields.push("Provider State");}
        if(caseRec.PC_Provider_ID__c == '' || caseRec.PC_Provider_ID__c == null){emptyFields.push("Provider ID");}
        
        if(emptyFields.length>0){
            var fieldsToShow = '';
            for (var i = 0; i < emptyFields.length; i++) {
                fieldsToShow = fieldsToShow+'* '+emptyFields[i]+' \n';
            }
            this.showToast(component,event,"Below fields are required","Error",fieldsToShow,5000);
            isValidated=false;
        }
        return isValidated;
    },
    validateSecondScreen: function(component, event){
        console.log('inside validateSecondScreen');
        var isValidated= true;
        console.log('isValidated-->'+isValidated);
        var projectSubRec = component.get("v.cpmWrap.projectSubRec");
        var emptyFields = [];
        if(projectSubRec.Issue_Description__c == '' || projectSubRec.Issue_Description__c == null){emptyFields.push("Issue Description");}
        if(projectSubRec.Root_Cause_Remediated__c == '' || projectSubRec.Root_Cause_Remediated__c == null){emptyFields.push("Root Cause Remediated");}
        if(projectSubRec.Remediation_Details__c == '' || projectSubRec.Remediation_Details__c == null){emptyFields.push("Remediation Details");}
        if(projectSubRec.Dates_Within_Reconsideration_Timeframe__c == '' || projectSubRec.Dates_Within_Reconsideration_Timeframe__c == null){emptyFields.push("Dates Within Reconsideration Timeframe");}
        if(projectSubRec.Issue_Identified_By__c == '' || projectSubRec.Issue_Identified_By__c == null){emptyFields.push("Identified By");}
        if(emptyFields.length>0){
            var fieldsToShow = '';
            for (var i = 0; i < emptyFields.length; i++) {
                fieldsToShow = fieldsToShow+'* '+emptyFields[i]+' \n';
            }
            this.showToast(component,event,"Below fields are required","Error",fieldsToShow,5000);
            isValidated=false;
        }
        console.log('isValidated-->'+isValidated);
        return isValidated;
    },
    scrollTop: function(component, event){
        document.getElementById("popUpId").scrollIntoView(true);
    },
    showToast : function(component, event, title,type,message, duration){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "type": type,
            "message": message,
            "duration": duration
        });
        toastEvent.fire();
    },
})