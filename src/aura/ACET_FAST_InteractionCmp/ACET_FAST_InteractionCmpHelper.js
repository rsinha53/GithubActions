({
    insertCaseRec: function(component, event){
        var wJSONVar = JSON.stringify(component.get("v.intWrap"));
        var action = component.get("c.finalSubmit");
        action.setParams({
            "wrapperJSON" : wJSONVar
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var finalResult = response.getReturnValue();
                if(finalResult.result === "ERROR"){
                    this.showToast(component,event,finalResult.result,finalResult.result,finalResult.errorMessage,15000);
                }else{
                    var workspaceAPI = component.find("workspace");
                    workspaceAPI.openTab({
                        url: '/lightning/r/Case/'+finalResult.caseRecordId+'/view',
                        focus: true
                    }).then(function(response) {})
                    .catch(function(error) {
                    });
                    this.showToast(component,event,finalResult.result,finalResult.result,finalResult.errorMessage,5000);
                    this.closeInterActionTab(component, event);
                }
                component.find("memberCardSpinnerAI").set("v.isTrue", false);  
            }
            else{
                component.find("memberCardSpinnerAI").set("v.isTrue", false);
            }
        });
        $A.enqueueAction(action);
    },
    validateFAST: function(component, event){
        var caseRec = component.get("v.intWrap.caseRec");
        var emptyFields = [];
        if(caseRec.Subject == '' || caseRec.Subject == null){emptyFields.push("Subject");}
        if(caseRec.Description == '' || caseRec.Description == null){emptyFields.push("Description");}
        if(caseRec.AccountId== undefined || caseRec.AccountId == null){emptyFields.push("Account");}
        if(caseRec.Origin == '' || caseRec.Origin == null){emptyFields.push("Case Origin");}
        if(caseRec.Provider_Type__c=='' || caseRec.Provider_Type__c==null){emptyFields.push("Provider Type");}
        var selectedMarketsList = [];
        selectedMarketsList = component.get("v.selectedMarketList");
        if(!selectedMarketsList.length>0){
            emptyFields.push("Markets");
        }
        if(caseRec.Topic__c=='' || caseRec.Topic__c==null){emptyFields.push("Topic");}
        if(caseRec.PC_Internal_Contact_Name__c=='' || caseRec.PC_Internal_Contact_Name__c==null){emptyFields.push("Contact Name");}
        if(caseRec.PC_Internal_Contact_Phone__c=='' || caseRec.PC_Internal_Contact_Phone__c==null){emptyFields.push("Contact Phone");}
        if(caseRec.PC_Internal_Contact_Email__c=='' || caseRec.PC_Internal_Contact_Email__c==null){emptyFields.push("Contact Email");}
        if(caseRec.Submitting_Department__c=='' || caseRec.Submitting_Department__c==null){emptyFields.push("Submitting Department");}
        if(caseRec.Original_Received_Date__c=='' || caseRec.Original_Received_Date__c==null){emptyFields.push("Original Received Date");}
        
        
        var pir = component.get("v.intWrap.pirDetailRecord");
        if(pir.Issue_Category__c=='' || pir.Issue_Category__c==null){emptyFields.push("Issue Category");}
        if((pir.Issue_Subcategory__c=='' || pir.Issue_Subcategory__c==null) &&(pir.Issue_Category__c!='Accounts Receivable' && pir.Issue_Category__c!='Early Warning System')){emptyFields.push("Issue Sub Category");}
        if(pir.Submitter_to_Contact_Provider_at_Closure__c=='' || pir.Submitter_to_Contact_Provider_at_Closure__c==null){emptyFields.push("Submitter to Contact Provider at Closure");}
        //if(pir.Line_of_Business__c=='' || pir.Line_of_Business__c==null){emptyFields.push("Line Of Business");}
        //if(pir.Platform__c=='' || pir.Platform__c==null){emptyFields.push("Platform");}
         //if(pir.Line_of_Business__c!='Community and State' && pir.Platform__c=='CSP Facets'){emptyFields.push("Platform");}
        
        //if(pir.What_will_it_take_to_close_in_Prac_Mgmt__c=='' || pir.What_will_it_take_to_close_in_Prac_Mgmt__c==null){emptyFields.push("What will it take to close in Prac Mgmt?");}
        //if(pir.Provider_Contact_Preference__c=='' || pir.Provider_Contact_Preference__c==null){emptyFields.push("Contact Preference");}
        //if(pir.Par_Provider__c=='' || pir.Par_Provider__c==null){emptyFields.push("Par Provider");}
        /*if(pir.Specialty_Team__c!='' && pir.Specialty_Team__c=='Region V' && pir.Region_V_Work_Type__c==''){
            emptyFields.push("Region V Work Type");
        }*/
        if(emptyFields.length>0){
            var fieldsToShow = '';
            for (var i = 0; i < emptyFields.length; i++) {
                fieldsToShow = fieldsToShow+'* '+emptyFields[i]+' \n';
            }
            this.showToast(component,event,"Below fields are required","Error",fieldsToShow,15000);
            component.find("memberCardSpinnerAI").set("v.isTrue", false);
        }else{
            var showValidationError = false;
            var vaildationFailReason = "Below Fields are mandatory"+"\n";
            var caseRecord = component.get("v.intWrap.caseRec");
            if(component.get("v.selectedMarketList").includes("Louisiana")  && pir.Line_of_Business__c=='Community and State' ){
                vaildationFailReason="Below Fields are mandatory if Markets 'Louisiana'and Line of business is C&S"+"\n";
                if(pir.LA_C_S_Reason_for_Provider_Issue__c=='' || pir.LA_C_S_Reason_for_Provider_Issue__c==null){
                    showValidationError = true;
                    vaildationFailReason = vaildationFailReason+"* LA C and S Reason for Provider Issue"+"\n";
                } 
                if(pir.LA_C_S_Summary_of_Provider_Issue__c =='' || pir.LA_C_S_Summary_of_Provider_Issue__c==null){
                    showValidationError = true;
                    vaildationFailReason = vaildationFailReason+"* LA C and S Summary of Provider Issue"+"\n";
                }
                if (showValidationError) {
                    this.showToast(component,event,'ERROR','ERROR',vaildationFailReason,15000);
                    component.find("memberCardSpinnerAI").set("v.isTrue", false);
                } 
            } 
            var ttoday=this.getDate(component, event);
            if(caseRec.Original_Received_Date__c<ttoday){
                if(pir.Reason_for_Submission_Delay__c=='' || pir.Reason_for_Submission_Delay__c==null ){
                    vaildationFailReason="Below Fields are mandatory if application received date was past"+"\n";   
                    showValidationError = true;
                    vaildationFailReason = vaildationFailReason+"* Reason for Submission Delay "+"\n";
                }
            }
            if(showValidationError){
                this.showToast(component,event,'ERROR','ERROR',vaildationFailReason,15000);
                component.find("memberCardSpinnerAI").set("v.isTrue", false);
            }else if(this.validateSubmitDate(component,event)){
                this.insertCaseRec(component, event);   
            }
            component.find("memberCardSpinnerAI").set("v.isTrue", false);
        }
    },
    validatePIP: function(component, event){
        var caseRec = component.get("v.intWrap.caseRec");
        var emptyFields = [];
        if(caseRec.Subject == '' || caseRec.Subject == null){emptyFields.push("Opportunity/Project Name");}
        if(caseRec.Description == '' || caseRec.Description == null){emptyFields.push("Opportunity Description/Problem Statement");}
        if(caseRec.Topic__c=='' || caseRec.Topic__c==null){emptyFields.push("Topic");}
        if(caseRec.PC_Internal_Contact_Name__c == '' || caseRec.PC_Internal_Contact_Name__c == null){emptyFields.push("Submitter Name");}
        if(caseRec.PC_Internal_Contact_Phone__c == '' || caseRec.PC_Internal_Contact_Phone__c == null){emptyFields.push("Submitter Phone");}
        if(caseRec.PC_Internal_Contact_Email__c == '' || caseRec.PC_Internal_Contact_Email__c == null){emptyFields.push("Submitter Email");}
        if(caseRec.Submitting_Department__c == '' || caseRec.Submitting_Department__c == null){emptyFields.push("Submitting Department");}
        if(caseRec.Original_Received_Date__c=='' || caseRec.Original_Received_Date__c==null){emptyFields.push("Original Received Date");}
        
        var selectedMarketsList = [];
        selectedMarketsList = component.get("v.selectedMarketList");
        if(!selectedMarketsList.length>0){
            emptyFields.push("Markets");
        }
        if(caseRec.Origin == '' || caseRec.Origin == null){emptyFields.push("Case Origin");}
        if(caseRec.PC_Line_of_Business_Platform__c == '' || caseRec.PC_Line_of_Business_Platform__c == null){emptyFields.push("Line of business");}
        
        var pir = component.get("v.intWrap.pirDetailRecord");
        if(pir.Insight_Source__c == '' || pir.Insight_Source__c == null){emptyFields.push("Insight Source");}
        if(pir.Project_Area_Focus__c == '' || pir.Project_Area_Focus__c == null){emptyFields.push("Project Area Focus");}
        if(pir.Platform_System__c == '' || pir.Platform_System__c == null){emptyFields.push("Platform/System");}
        if(pir.Provider_Type__c == '' || pir.Provider_Type__c == null){emptyFields.push("Provider Type");}
        if(pir.MBO_Check_List__c == '' || pir.MBO_Check_List__c == null){emptyFields.push("MBO Check List");}
        if(emptyFields.length>0){
            var fieldsToShow = '';
            for (var i = 0; i < emptyFields.length; i++) {
                fieldsToShow = fieldsToShow+'* '+emptyFields[i]+' \n';
            }
            this.showToast(component,event,"Below fields are required","Error",fieldsToShow,15000);
            component.find("memberCardSpinnerAI").set("v.isTrue", false);
        }else{
            var pirRecord = component.get("v.intWrap.pirDetailRecord");
            var showValidationError = false;
            var vaildationFailReason = "Below Fields are mandatory "+"\n";
            var validationTitle;  
            if(pirRecord.Insight_Source_Other__c == '' || pirRecord.Insight_Source_Other__c == null){
                if(pirRecord.Insight_Source__c=='Other' ){
                    showValidationError = true;
                    vaildationFailReason = vaildationFailReason+"* Insight Others"+" \n"; 
                    validationTitle='If insight source is Others';
                } 
                if(pirRecord.Insight_Source__c=='SWAT' &&(pirRecord.SWAT_Awareness_of_Issue__c== '' || pirRecord.SWAT_Awareness_of_Issue__c == null)){
                    showValidationError = true;
                    vaildationFailReason = vaildationFailReason+"SWAT Awareness of Issue?"+" \n"; 
                    validationTitle='If insight source is SWAT';
                }
                if(pirRecord.SWAT_Awareness_of_Issue__c=='Yes' && (pirRecord.SWAT_Contact_Partner__c='' ||pirRecord.SWAT_Contact_Partner__c == null ) ){
                    showValidationError = true;
                    vaildationFailReason = vaildationFailReason+"SWAT Contact/Partner"+" \n"; 
                    validationTitle='If SWAT Awareness of Issue is selected Yes';
                }
            }
            if(showValidationError){
                this.showToast(component,event,validationTitle,'ERROR',vaildationFailReason,15000); 
                component.find("memberCardSpinnerAI").set("v.isTrue", false);
            } else   if(this.validateSubmitDate(component,event)){
                this.insertCaseRec(component, event);   
            } 
        }
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
    validateSubmitDate: function(component,event){
        var isValidate = true;
        var caseRec = component.get("v.intWrap.caseRec");
        var today = new Date();
        var dd = String(today.getDate()).padStart(2, '0');
        var mm = String(today.getMonth() + 1).padStart(2, '0');
        var yyyy = today.getFullYear();
        today = yyyy + '-' + mm + '-' + dd;
        var caseRec = component.get("v.intWrap.caseRec");
        if(caseRec.Original_Received_Date__c>today){
            isValidate=false;
            
            this.showToast(component,event,"Submitter Recived Date","Error",'Submitter Received Date Cannot be greater than today',5000);
            component.find("memberCardSpinnerAI").set("v.isTrue", false);
        }
        
        return isValidate;
    },
    getDate : function(component, event) {
        var today = new Date();
        var dd = today.getDate();
        var mm = today.getMonth()+1; 
        var yyyy = today.getFullYear();
        if(dd<10) {
            dd='0'+dd;
        } 
        if(mm<10){
            mm='0'+mm;
        }
        today = yyyy+'-'+mm+'-'+dd;
        return today; 
    },
    closeInterActionTab: function(component, event){
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            var focusedTabId = response.tabId;
            workspaceAPI.closeTab({tabId: focusedTabId});
        })
        .catch(function(error) {
        });
    },
      openMisDirect:function(cmp){
        var exploreOriginator= 'Provider';
       	var providerDetails = cmp.get("v.providerDetails");
        var memberDetails = cmp.get("v.memberDetails");
        if( !$A.util.isUndefinedOrNull(providerDetails) && !$A.util.isUndefinedOrNull(providerDetails.isNoProviderToSearch) && providerDetails.isNoProviderToSearch
          && !$A.util.isUndefinedOrNull(memberDetails) && !$A.util.isUndefinedOrNull(memberDetails.isNoMemberToSearch) && !memberDetails.isNoMemberToSearch ){
            exploreOriginator = 'Member';
        }
        var workspaceAPI = cmp.find("workspace");
        //US2598275: Updates to Contact Name Entry Field
        _setandgetvalues.setContactValue('exploreContactData',cmp.get("v.flowDetails.contactName"),cmp.get("v.flowDetails.contactNumber"),cmp.get("v.flowDetails.contactExt"),cmp.get("v.flowDetails.contactFirstName"),cmp.get("v.flowDetails.contactLastName"));
        workspaceAPI.getEnclosingTabId().then(function(enclosingTabId) {
            if(enclosingTabId == false){
                workspaceAPI.openTab({
                    pageReference: {
                        "type": "standard__component",
                        "attributes": {
                            "componentName": "c__SAE_MisdirectComponent"
                        },
                        "state": {
                            "c__contactUniqueId": "exploreContactData",
							"c__focusedTabId": "exploretab",
                            "c__exploreOriginator":exploreOriginator,
                            "c__flowInfo":cmp.get("v.flowDetails"),
                            "c__isVCCD" : cmp.get("v.isVCCD"),
                            "c__VCCDRespId" : cmp.get("v.VCCDObjRecordId")
                        }
                    },
                    focus: true
                }).then(function(response) {
                    workspaceAPI.getTabInfo({
                        tabId: response
                    }).then(function(tabInfo) {
                        var focusedTabId = tabInfo.tabId;
                        workspaceAPI.setTabLabel({
                            tabId: focusedTabId,
                            label: "Misdirect"
                        });
                        workspaceAPI.setTabIcon({
                            tabId: focusedTabId,
                            icon: "standard:decision",
                            iconAlt: "Misdirect"
                        });
                    });
                }).catch(function(error) {
                    console.log(error);
                });
            }
        });
    },
})