({
	clearFields: function(component,event,continueBtn){
		var dropdownOptions = [];
		dropdownOptions.push({
            label: "None",
            value: "None"
        });
		
        var isDefectVal = component.get("v.isDefect");
        if((isDefectVal != undefined && isDefectVal != null && !isDefectVal) && (component.get('v.businessUnit') == 'NA  Issue' || component.get('v.businessUnit') == 'NA Activity' || component.get('v.businessUnit') == 'NA Internal Support Activity' || component.get('v.businessUnit') == 'NA Internal Support Issue')){
        	component.set("v.defectType","N/A");
        	var rootCauseIssueCategoryList = ["None","Call Center Contacted First","Call Center Service Concern","Executive VIP","Multiple Members Affected","New Claim","Rework (Non-UHG)","Rework (UHG)"];
            var rootCauseIssueCategoryOptions = [];
            for(var i = 0; i < rootCauseIssueCategoryList.length; i++){
                rootCauseIssueCategoryOptions.push({
                    label: rootCauseIssueCategoryList[i],
                    value: rootCauseIssueCategoryList[i]
                });
            }
            component.set("v.rootCauseIssueCategoryOptions",rootCauseIssueCategoryOptions);
            component.set("v.rootCauseIssueCategory","None");
        } else if(isDefectVal != undefined && isDefectVal != null && isDefectVal && continueBtn) {
            component.set("v.defectType", "Defect");
            component.set("v.rootCause", "DEFAULT");
            var rootCauseIssueCategoryList = ["None","ECS","Implementation","Sales or Health Plan","Other UHG Business Partner","Client","Broker or General Agent","Provider","Member"];
			var rootCauseIssueCategoryOptions = [];
			for(var i = 0; i < rootCauseIssueCategoryList.length; i++){
				rootCauseIssueCategoryOptions.push({
		            label: rootCauseIssueCategoryList[i],
		            value: rootCauseIssueCategoryList[i]
		        });
			}
			component.set("v.rootCauseIssueCategoryOptions",rootCauseIssueCategoryOptions);
			component.set("v.rootCauseIssueCategory","None");
        } else {
            component.set("v.defectType", "None");
            component.set("v.rootCause", "");
            component.set('v.rootCauseIssueCategoryOptions', dropdownOptions);
			component.set("v.rootCauseIssueCategory", "None");	
        }			
		component.set("v.briefDesc", "");
		component.set("v.serviceImpactDate", "");
    },
    validateSubmit: function(component,event){
    	var validationSuccess = false;
    	var validationCounter = 0;
    	var rootCause = {
    		defectType: component.get("v.defectType"),
    		rootCauseIssueCategory: component.get("v.rootCauseIssueCategory"),
    		rootCause: component.get("v.rootCause").trim(),
    		briefDesc: component.get("v.briefDesc"),
    		serviceImpactDate: component.get("v.serviceImpactDate"),
    		businessUnit: component.get("v.businessUnit").trim()
		};
    	//$A.util.removeClass(component.find("defectType"), "slds-has-error");  
		//component.find("defectTypeError").set("v.errors", null);
		$A.util.removeClass(component.find("rootCauseIssueCategory"), "slds-has-error");  
		component.find("rootCauseIssueCategoryError").set("v.errors", null);
    	/*if(rootCause.defectType == "None"){
    		validationCounter++;
    		$A.util.addClass(component.find("defectType"), "slds-has-error");
    		component.find("defectTypeError").set("v.errors", [{message:"Must select an option."}]);
    	}*/
    	if(rootCause.rootCauseIssueCategory == "None"){
    		validationCounter++;
    		$A.util.addClass(component.find("rootCauseIssueCategory"), "slds-has-error");
    		component.find("rootCauseIssueCategoryError").set("v.errors", [{message:"Must select an option."}]);
    	}
    	/*if(rootCause.rootCause == ""){
    		validationCounter++;
    		component.find("rootCause").reportValidity();
    	}*/
    	if(rootCause.defectType == "Defect" && (rootCause.serviceImpactDate == null || rootCause.serviceImpactDate == "")){
    		validationCounter++;
    		component.find("serviceImpactDate").reportValidity();
    	}
    	if(rootCause.defectType == "Defect" && rootCause.rootCauseIssueCategory == "Other UHG Business Partner" && rootCause.briefDesc == ""){
    		validationCounter++;
    		component.find("briefDesc").reportValidity();
    	}
    	if((rootCause.businessUnit == 'NA  Issue' || rootCause.businessUnit == 'NA Activity' || rootCause.businessUnit == 'NA Internal Support Activity' || rootCause.businessUnit == 'NA Internal Support Issue') && (rootCause.rootCauseIssueCategory == "Multiple Members Affected" || rootCause.rootCauseIssueCategory == "Call Center Service Concern") && rootCause.briefDesc == ""){
    		validationCounter++;
    		component.find("briefDesc").reportValidity();
    	}
    	
    	if(validationCounter == 0){
    		validationSuccess = true;
    	}
    	return validationSuccess;
    }
})