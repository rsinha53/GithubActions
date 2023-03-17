({
    validateFastMandatoryFields: function(component, event){
        var mandatoryFieldsFilled=true;
        var emptyFields=[];
        if($A.util.isEmpty(component.find("statusId").get("v.value"))){emptyFields.push("Status");}
        if($A.util.isEmpty(component.find("issueCtgryId").get("v.value"))){emptyFields.push("Issue Category");}
        if($A.util.isEmpty(component.find("issueSubCtgryId").get("v.value"))&& (component.find("issueCtgryId").get("v.value")!='Accounts Receivable' && component.find("issueCtgryId").get("v.value")!='Early Warning System')){emptyFields.push("Issue Subcategory");}
        //if($A.util.isEmpty(component.find("lobID").get("v.value"))){emptyFields.push("Line of Business");}
       	//if($A.util.isEmpty(component.find("pltfrmId").get("v.value"))){emptyFields.push("Platform");}
       	//if($A.util.isEmpty(component.find("practMgtId").get("v.value"))){emptyFields.push("What will it take to close in Prac Mgmt?");}
       	//if($A.util.isEmpty(component.find("pcPrefId").get("v.value"))){emptyFields.push("Provider Contact Preference");}
       	//if($A.util.isEmpty(component.find("parProviderId").get("v.value"))){emptyFields.push("Par Provider");}
       	//if($A.util.isEmpty(component.find("sCPrdClsId").get("v.value"))){emptyFields.push("Submitter to Contact Provider at Closure");}
       
        if(component.find("pWasContctedId").get("v.value")=='Yes' || component.find("pWasContctedId").get("v.value")=='No Response'){
            if($A.util.isEmpty(component.find("howContactId").get("v.value"))){
             emptyFields.push("How Was Provider Contacted?");   
            }
        }
        if(component.find("wtbciPMgmtId").get("v.value")=='No'){
            if($A.util.isEmpty(component.find("ifNoWhyNotId").get("v.value"))){
                emptyFields.push("If No, Why Not");   
            }
        }
        
        if(emptyFields.length>0){
            var fieldsToShow = '';
            for (var i = 0; i < emptyFields.length; i++) {
                fieldsToShow = fieldsToShow+'* '+emptyFields[i]+' \n';
            }
            this.showToast(component,event,"Below fields are required","Error",fieldsToShow,5000);
            mandatoryFieldsFilled=false;
        }
        return mandatoryFieldsFilled;
    },
    validateMarketLOBFields: function(component, event, caseRecord){
        var isValidated=true;
        var vaildationFailReason="Below Fields are mandatory if Markets 'Louisiana'and Line of business is C&S"+"\n";
      /**  if(caseRecord.FAST_PIP_Markets__c.includes("Louisiana") && component.find("lobID").get("v.value")==='Community and State'){
            if($A.util.isEmpty(component.find("rpIssueId").get("v.value")) ){
                isValidated = false;
                vaildationFailReason = vaildationFailReason+"* LA C and S Reason for Provider Issue"+"\n";
            }
            if($A.util.isEmpty(component.find("spIssueId").get("v.value")) ){
                isValidated = false;
                vaildationFailReason = vaildationFailReason+"* LA C and S Summary of Provider Issue"+"\n";
            }
        }  **/
        if(!isValidated) {
            this.showToast(component,event,'ERROR','ERROR',vaildationFailReason);
        }
        return isValidated;
    },
    validateReceivedDate: function(component, event, caseRecord){
        var isDateValid= true;
        var vaildationFailReason='';
        var ttoday=this.getDate(component, event);
        if(caseRecord.Original_Received_Date__c<ttoday){
            if($A.util.isEmpty(component.find("rSubDelayId").get("v.value")) ){
                isDateValid = false;
                vaildationFailReason="Below Fields are mandatory if application received date was past"+"\n";   
                vaildationFailReason = vaildationFailReason+"* Reason for Submission Delay "+"\n";
            }
            if(!isDateValid) {
                this.showToast(component,event,'ERROR','ERROR',vaildationFailReason);
            }
        }
        return isDateValid;
    },
    validateClosedStatus: function(component, event, caseRecord){
        var isClosedCaseValidated=true;
        var vaildationFailReason = "Below Fields are mandatory while closing PIR Details"+"\n";
        if($A.util.isEmpty(component.find("wtbciPMgmtId").get("v.value"))){
            isClosedCaseValidated = false;
            vaildationFailReason = vaildationFailReason+"* Will this be closed in practice management"+" \n";
        }
        else{
            if(component.find("wtbciPMgmtId").get("v.value")=='No'){
                if($A.util.isEmpty(component.find("ifNoWhyNotId").get("v.value"))){
                    isClosedCaseValidated = false;
                    vaildationFailReason = vaildationFailReason+"* If No, Why Not"+" \n";   
                }
            }
        }
  
        if($A.util.isEmpty(component.find("pWasContctedId").get("v.value"))){
            isClosedCaseValidated = false;
            vaildationFailReason = vaildationFailReason+"* Provider Was Contacted"+" \n";   
        }  
        if($A.util.isEmpty(component.find("cloSubStatusId").get("v.value"))){
            isClosedCaseValidated = false;
            vaildationFailReason = vaildationFailReason+"* Closure Sub Status"+" \n";   
        }
          if($A.util.isEmpty(component.find("subContactId").get("v.value"))){
            isClosedCaseValidated = false;
            vaildationFailReason = vaildationFailReason+"* Submitter to Contact Provider at Closure";   
        }   
      
        
        if(!isClosedCaseValidated){
            component.find('fastMessage').setError(vaildationFailReason);
            this.showToast(component,event,'ERROR','ERROR',vaildationFailReason);
        }
        return isClosedCaseValidated;
    },
    showToast: function(component, event, title,type,message ){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "type": type,
            "message": message
            
        });
        toastEvent.fire();
    },
    validatePipMandatoryFields: function(component, event){
        var isValidationSucces = true;
        var emptyFields=[];
        if($A.util.isEmpty(component.find("queriesId").get("v.value"))){emptyFields.push("Queries");}
        if($A.util.isEmpty(component.find("dataAnalysisId").get("v.value"))){emptyFields.push("Data Analysis");}
        if($A.util.isEmpty(component.find("sourceOfDataId").get("v.value"))){emptyFields.push("Source Of Data");}
        if($A.util.isEmpty(component.find("MeasurSysId").get("v.value"))){emptyFields.push("Measurement System");}
        if($A.util.isEmpty(component.find("inSourceId").get("v.value"))){emptyFields.push("Insight Source");}
        if($A.util.isEmpty(component.find("projAreaFocId").get("v.value"))){emptyFields.push("Project Area Focus");}
        if($A.util.isEmpty(component.find("platFormSysId").get("v.value"))){emptyFields.push("PlatForm/System");}
        if($A.util.isEmpty(component.find("mboCheckListId").get("v.value"))){emptyFields.push("MBO Check List");}
       /* if(component.find("PMOPRId").get("v.value")=='Yes')
        {
            //alert('test');
            if($A.util.isEmpty(component.find("PMOconId").get("v.value"))){
             emptyFields.push("PMO Contact Id");   
            }
        }*/
        if($A.util.isEmpty(component.get("v.rootCause1"))){emptyFields.push("Root Cause 1"); }
        if($A.util.isEmpty(component.get("v.rootCause2"))){emptyFields.push("Root Cause 2");}
        if($A.util.isEmpty(component.get("v.rootCause3"))){emptyFields.push("Root Cause 3");}
        if($A.util.isEmpty(component.get("v.rootCause4"))){emptyFields.push("Root Cause 4");}
        if($A.util.isEmpty(component.get("v.rootCause5"))){emptyFields.push("Root Cause 5");} 
        if(emptyFields.length>0){
            isValidationSucces=false;
            var fieldsToShow = '';
            for (var i = 0; i < emptyFields.length; i++) {
                fieldsToShow = fieldsToShow+'* '+emptyFields[i]+' \n';
            }
            this.showToast(component,event,"Below fields are required","Error",fieldsToShow,5000);
        }
        return isValidationSucces;
    },
    validatePipCustom: function(component, event){
        var isValidationSuccess = true;
        var vaildationFailReason = "Below Fields are mandatory "+"\n";
        var validationTitle='';
        
        if(!$A.util.isEmpty(component.find("inSourceId").get("v.value"))){
            if(component.find("inSourceId").get("v.value")=='Other' &&$A.util.isEmpty(component.find("inSourceOthId").get("v.value")) ){
                vaildationFailReason = vaildationFailReason+"* Insight Others"+" \n"; 
                validationTitle='If insight source is Others';
            } 
            if(component.find("inSourceId").get("v.value")=='SWAT' &&$A.util.isEmpty(component.find("sAwareIssueId").get("v.value")) ){
                vaildationFailReason = vaildationFailReason+"SWAT Awareness of Issue?"+" \n"; 
                validationTitle='If insight source is SWAT';
            }
            if(component.find("sAwareIssueId").get("v.value")=='Yes' &&$A.util.isEmpty(component.find("sWATConPartId").get("v.value")) ){
                vaildationFailReason = vaildationFailReason+"SWAT Contact/Partner"+" \n"; 
                validationTitle='If SWAT Awareness of Issue is selected Yes';
            }
        }
        if(!$A.util.isEmpty(component.find("PMOPRId").get("v.value"))){
            if(component.find("PMOPRId").get("v.value")=='Yes' &&$A.util.isEmpty(component.find("PMOconId").get("v.value")) ){
                vaildationFailReason = vaildationFailReason+"* PMO Contact"+" \n"; 
                validationTitle='If PMO Provider Relationshipe is Yes';
            } 
        }

        if(validationTitle!=''){
         	isValidationSuccess=false;   
            this.showToast(component,event,validationTitle,'ERROR',vaildationFailReason); 
        }
        return isValidationSuccess;
    },
    validatePipClosedStatus: function(component, event){
        var isClosedCaseValidationSuccess = true;
        var MadatoryFields = '';
        if($A.util.isEmpty(component.find("inSourceId").get("v.value"))){MadatoryFields = MadatoryFields+"* Insight Source"+" \n";}
        if($A.util.isEmpty(component.find("projAreaFocId").get("v.value"))){MadatoryFields = MadatoryFields+"* Project Area Focus"+" \n";}
        if($A.util.isEmpty(component.find("platFormSysId").get("v.value"))){MadatoryFields = MadatoryFields+"* Platform/System"+" \n";}
        if($A.util.isEmpty(component.find("mboCheckListId").get("v.value"))){MadatoryFields = MadatoryFields+"* MBO Check List"+" \n";} 
        if($A.util.isEmpty(component.find("MeasurSysId").get("v.value"))){MadatoryFields = MadatoryFields+"* Measurement System"+" \n";}
        if($A.util.isEmpty(component.find("sourceOfDataId").get("v.value"))){MadatoryFields = MadatoryFields+"* Sources of Data"+" \n";}
        if($A.util.isEmpty(component.find("queriesId").get("v.value"))){MadatoryFields = MadatoryFields+"* Queries"+" \n";}
        if($A.util.isEmpty(component.find("dataAnalysisId").get("v.value"))){MadatoryFields = MadatoryFields+"* Data Analysis"+" \n";}
        if($A.util.isEmpty(component.find("subStatusId").get("v.value"))){MadatoryFields = MadatoryFields+"* Sub Status"+" \n";}
        
        /*if($A.util.isEmpty(component.get("v.rootCause1"))){MadatoryFields = MadatoryFields+"* Root Cause 1"+" \n";}
        if($A.util.isEmpty(component.get("v.rootCause2"))){MadatoryFields = MadatoryFields+"* Root Cause 2"+" \n";}
        if($A.util.isEmpty(component.get("v.rootCause3"))){MadatoryFields = MadatoryFields+"* Root Cause 3"+" \n";}
        if($A.util.isEmpty(component.get("v.rootCause4"))){MadatoryFields = MadatoryFields+"* Root Cause 4"+" \n";}
        if($A.util.isEmpty(component.get("v.rootCause5"))){MadatoryFields = MadatoryFields+"* Root Cause 5"+" \n";}  */
       
        if(MadatoryFields!='' && MadatoryFields!=undefined && MadatoryFields!=null){
            isClosedCaseValidationSuccess=false;
            this.showToast(component,event,'Below field are Mandatory when Status is Closed','ERROR',MadatoryFields); 
        }
        return isClosedCaseValidationSuccess;
    },
    getDate: function(cmp, event){
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
    assignRootCauseFieldsData: function(component, event, fields){
        fields["Root_Cause_1__c"] = component.get("v.rootCause1Value");
        fields["Root_Cause_1_Key_Code__c"] = component.get("v.rootCause1");
        fields["Root_Cause_2__c"] = component.get("v.rootCause2Value");
        fields["Root_Cause_2_Key_Code__c"] = component.get("v.rootCause2");
        fields["Root_Cause_3__c"] = component.get("v.rootCause3Value");
        fields["Root_Cause_3_Key_Code__c"] = component.get("v.rootCause3");
        fields["Root_Cause_4__c"] = component.get("v.rootCause4Value");
        fields["Root_Cause_4_Key_Code__c"] = component.get("v.rootCause4");
        fields["Root_Cause_5__c"] = component.get("v.rootCause5Value");
        fields["Root_Cause_5_Key_Code__c"] = component.get("v.rootCause5");
    },
    showSpinner: function(component, event){
        var spinner = component.find("dropdown-spinner");
        $A.util.removeClass(spinner, "slds-hide");
    },
    hideSpinner: function(component, event){
        var spinner = component.find("dropdown-spinner");
        $A.util.addClass(spinner, "slds-hide");
    },
})