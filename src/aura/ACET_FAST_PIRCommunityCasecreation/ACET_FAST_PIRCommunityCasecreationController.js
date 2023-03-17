({
    doInit: function (cmp, event, helper) {
        //helper.initializeObjects(cmp);
        var marketlist = [{'label':'Alabama','value':'Alabama'},
                          {'label':'Alaska','value':'Alaska'},
                          {'label':'Arizona','value':'Arizona'},
                          {'label':'Arkansas','value':'Arkansas'},
                          {'label':'California','value':'California'},
                          {'label':'Colorado','value':'Colorado'},
                          {'label':'Connecticut','value':'Connecticut'},
                          {'label':'Delaware','value':'Delaware'},
                          {'label':'Florida','value':'	Florida	'},
                          {'label':'	Georgia	','value':'	Georgia	'},
                          {'label':'	Hawaii	','value':'	Hawaii	'},
                          {'label':'	Idaho	','value':'	Idaho	'},
                          {'label':'	Illinois	','value':'	Illinois	'},
                          {'label':'	Indiana	','value':'	Indiana	'},
                          {'label':'	Iowa	','value':'	Iowa	'},
                          {'label':'	Kansas	','value':'	Kansas	'},
                          {'label':'	Kentucky	','value':'	Kentucky	'},
                          {'label':'	Louisiana	','value':'	Louisiana	'},
                          {'label':'	Maine	','value':'	Maine	'},
                          {'label':'	Maryland	','value':'	Maryland	'},
                          {'label':'	Massachusetts	','value':'	Massachusetts	'},
                          {'label':'	Michigan	','value':'	Michigan	'},
                          {'label':'	Minnesota	','value':'	Minnesota	'},
                          {'label':'	Mississippi	','value':'	Mississippi	'},
                          {'label':'	Missouri	','value':'	Missouri	'},
                          {'label':'	Montana	','value':'	Montana	'},
                          {'label':'	Nebraska	','value':'	Nebraska	'},
                          {'label':'	Nevada	','value':'	Nevada	'},
                          {'label':'	New Hampshire	','value':'	New Hampshire	'},
                          {'label':'	New Jersey	','value':'	New Jersey	'},
                          {'label':'	New Mexico	','value':'	New Mexico	'},
                          {'label':'	New York	','value':'	New York	'},
                          {'label':'	North Carolina	','value':'	North Carolina	'},
                          {'label':'	North Dakota	','value':'	North Dakota	'},
                          {'label':'	Ohio	','value':'	Ohio	'},
                          {'label':'	Oklahoma	','value':'	Oklahoma	'},
                          {'label':'	Oregon	','value':'	Oregon	'},
                          {'label':'	Pennsylvania	','value':'	Pennsylvania	'},
                          {'label':'	Rhode Island	','value':'	Rhode Island	'},
                          {'label':'	South Carolina	','value':'	South Carolina	'},
                          {'label':'	South Dakota	','value':'	South Dakota	'},
                          {'label':'	Tennessee	','value':'	Tennessee	'},
                          {'label':'	Texas	','value':'	Texas	'},
                          {'label':'	Utah	','value':'	Utah	'},
                          {'label':'	Vermont	','value':'	Vermont	'},
                          {'label':'	Virginia	','value':'	Virginia	'},
                          {'label':'	Washington	','value':'	Washington	'},
                          {'label':'	Washington	','value':'	Washington	'},
                          {'label':'	D.C	','value':'	D.C	'},
                          {'label':'	West Virginia	','value':'	West Virginia	'},
                          {'label':'	Wisconsin	','value':'	Wisconsin	'},
                          {'label':'	Wyoming	','value':'	Wyoming	'}
                         ];
        cmp.set("v.availableMarketList",marketlist);
        
    },
    handleSaveButton : function (cmp, event, helper) {
     //   alert('Hello');
        var CaseRecord = cmp.get("v.caseRec");
        CaseRecord.Origin ='Community';
        
        var caseType=cmp.get("v.selectedCaseType");
        var providerName=cmp.get("v.providerName");
        
        var pirRecord = cmp.get("v.pirRec");
        var validation = false;
        var ErrorMsg = '';
        //console.log('case records---'+ JSON.stringify(CaseRecord));
        //console.log('case records---'+ JSON.stringify(pirRecord));
        console.log('---' );
        console.log('case---'+ cmp.find("selectedmarketsId").get("v.value") );
        debugger;
        var mandatoryFieldsFilled=true;
        var emptyFields=[];
        
        if( $A.util.isUndefined(caseType) || $A.util.isEmpty(caseType) ){
            emptyFields.push("Case Type");
        }else {
            if(caseType=='Claim Issue' || caseType=='Project Request'){
                CaseRecord.Topic__c='Reactive Resolution';
            }else if(caseType=='Global Issue'){
                CaseRecord.Topic__c='FFA';
            }else if(caseType=='Balance Billing'){
                CaseRecord.Topic__c='Balance Billing';
            }
            
        }
        if( $A.util.isUndefined(providerName) || $A.util.isEmpty(providerName) ){
            emptyFields.push("Provider Name");
        }
        if( $A.util.isUndefined(CaseRecord.PC_Internal_Contact_Name__c) || $A.util.isEmpty(CaseRecord.PC_Internal_Contact_Name__c) ){
            emptyFields.push("Submitter Name");
        }
        if($A.util.isUndefined(CaseRecord.PC_Internal_Contact_Email__c) || $A.util.isEmpty(CaseRecord.PC_Internal_Contact_Email__c)){
            emptyFields.push("Submitter Email");
        }
        if($A.util.isUndefined(CaseRecord.PC_External_Contact_Name__c) || $A.util.isEmpty(CaseRecord.PC_External_Contact_Name__c)){
            emptyFields.push("Provider Contact");
        }
        if($A.util.isUndefined(CaseRecord.PC_Provider_TIN__c) || $A.util.isEmpty(CaseRecord.PC_Provider_TIN__c)){
            emptyFields.push("Provider TIN");
        }
        if( $A.util.isUndefined(CaseRecord.PC_External_Contact_Email__c) || $A.util.isEmpty(CaseRecord.PC_External_Contact_Email__c) ){
            emptyFields.push("Provider Contact email");
        }
        if( $A.util.isUndefined(CaseRecord.Type__c) || $A.util.isEmpty(CaseRecord.Type__c) ){
            emptyFields.push("Line of Business");
        }
        if( $A.util.isUndefined(CaseRecord.PC_Provider_Region__c) || $A.util.isEmpty(CaseRecord.PC_Provider_Region__c) ){
            emptyFields.push("Region");
        }
        if( $A.util.isUndefined(pirRecord.Issue_Category__c) || $A.util.isEmpty(pirRecord.Issue_Category__c) ){
            emptyFields.push("Issue category");
        }
        if( $A.util.isUndefined(pirRecord.Issue_Subcategory__c) || $A.util.isEmpty(pirRecord.Issue_Subcategory__c) ){
            emptyFields.push("Issue Subcategory");
        }
        
        var markets = cmp.find("selectedmarketsId").get("v.value");
        if( $A.util.isUndefined(markets) || $A.util.isEmpty(markets) ){
            emptyFields.push("Markets");
        }else{
            CaseRecord.FAST_PIP_Markets__c = markets;
        }
        
        if( $A.util.isUndefined(CaseRecord.Subject) || $A.util.isEmpty(CaseRecord.Subject) ){
            emptyFields.push("Subject");
        }
        if( $A.util.isUndefined(CaseRecord.Description) || $A.util.isEmpty(CaseRecord.Description) ){
            emptyFields.push("Description");
        }
        if(emptyFields.length>0){
            var fieldsToShow = '';
            for (var i = 0; i < emptyFields.length; i++) {
                fieldsToShow = fieldsToShow+'* '+emptyFields[i]+' \n';
            }
            if(mandatoryFieldsFilled){
                helper.showToast(cmp,event,"Below fields are required","Error",fieldsToShow,5000);
            }
        } else{
            console.log('validation---'+ JSON.stringify(CaseRecord) );
            var action = cmp.get('c.recordSave');
            action.setParams({
                "caseVal": CaseRecord,
                "pirVal": pirRecord,
                "providerName": providerName
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                console.log('state---'+state);
                //  alert('Status Value'+state);  enableForm
                
                if (state == 'SUCCESS') {
                    var result = response.getReturnValue();
                    // alert(JSON.stringify(response));
                    cmp.set("v.enableForm", false);
                    cmp.set("v.caseNumber", result);
                   /** var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type":"success",
                        "title": "SUCCESS",
                        "message": "PIR Case "+ result  +" submitted Successfully",
                        "duration": 5000
                        
                    });
                    toastEvent.fire();**/
                    console.log('result---'+result);
                }
            });
            $A.enqueueAction(action);
        }
        
    },
    handleMarketChange : function (cmp, event, helper) {
        var selectedValues = event.getParam("value");
        cmp.set("v.selectedMarketList", selectedValues);
        console.log('market--'+cmp.get("v.selectedMarketList"));
    },
    handleOnBlur: function (cmp, event, helper) {
        var eventSource = event.getSource();
        var fieldName = eventSource.get("v.name");
        var fieldValue = eventSource.get("v.value");
        if (fieldName == "ProviderTaxID") {
            if(!$A.util.isEmpty(fieldValue) && fieldValue.length < 9) {
                eventSource.setCustomValidity('Enter nine digits.');
            } else {
                eventSource.setCustomValidity('');
            }
            eventSource.reportValidity();   
        }
    },
    
    clearValues: function (cmp, event, helper) {
        helper.clearFieldValues(cmp);
    },
    finishHandle: function (cmp, event, helper) {
        cmp.set("v.enableForm", true);
        helper.clearFieldValues(cmp);
    }
})