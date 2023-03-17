({
	doInit : function(component, event, helper) {
		var userProfile = component.get("v.userInfo").Profile_Name__c;
		if(userProfile.includes("Research User")){
			let saveCont = component.find("saveContinue");
			saveCont.set("v.disabled", true);
			let saveClose = component.find("saveClose");
			saveClose.set("v.disabled", true);
		}
        
	    //helper.clearFields(component,helper,false);
		/*var dropdownList = []; 
		if(component.get("v.businessUnit") == "NA Activity" || component.get("v.businessUnit") == "NA Internal Support Activity"){
			dropdownList = ["N/A"];
			component.set("v.defectType", "N/A");
			component.set("v.rootCauseIssueCategoryOptions",[{label: "N/A",value: "N/A"}]);
			component.set("v.rootCauseIssueCategory","N/A");
			//component.set("v.rootCause","DEFAULT");
			component.set("v.disabledByBusinessUnit",true);
		} else {
			dropdownList = ["None","Maintenance","Inquiry","Defect"];
			component.set("v.disabledByBusinessUnit",false);
		}*/
        component.set("v.rootCause","DEFAULT");
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
        } else if(isDefectVal != undefined && isDefectVal != null && isDefectVal) {
            component.set("v.defectType","Defect");
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
        }      
		/*var dropdownOptions = [];
		for(var i = 0; i < dropdownList.length; i++){
			dropdownOptions.push({
	            label: dropdownList[i],
	            value: dropdownList[i]
	        });
		}
		component.set('v.defectTypeOptions', dropdownOptions);*/
		var currentDate = new Date();
		var maxDate = currentDate.getFullYear() + "-" + (currentDate.getMonth() + 1) + "-" + currentDate.getDate();
		component.set('v.maxEventReceivedDate', maxDate);
	},
	selectDefectType: function(component, event, helper){
		let dateField = component.find("serviceImpactDate");
		dateField.set("v.required",false);
		var defectType = component.get("v.defectType");
		if(defectType == "Maintenance"){
			component.set("v.rootCauseIssueCategoryOptions",[{label: "Maintenance",value: "Maintenance"}]);
			component.set("v.rootCauseIssueCategory","Maintenance");
		} else if(defectType == "Inquiry"){
			component.set("v.rootCauseIssueCategoryOptions",[{label: "Inquiry",value: "Inquiry"}]);
			component.set("v.rootCauseIssueCategory","Inquiry");
		} else if(defectType == "Defect"){
			dateField.set("v.required",true);
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
			component.set("v.rootCauseIssueCategoryOptions",[{label: "None",value: "None"}]);
			component.set("v.rootCauseIssueCategory","None");
		}
	},
	selectRootCauseIssueCategory: function(component,event,helper){
		let briefDescField = component.find("briefDesc");
		briefDescField.set("v.required",false);
		if(component.get("v.rootCauseIssueCategory") == "Other UHG Business Partner" || component.get("v.rootCauseIssueCategory") == "Call Center Service Concern" || component.get("v.rootCauseIssueCategory") == "Multiple Members Affected"){
			briefDescField.set("v.required",true);
		}
	},
	closeRootCauseModel: function(component, event, helper){
		var evt = $A.get("e.c:ETSBE_closeRootCauseModal");
    	evt.setParams({"isRootCause":false});
    	evt.fire();	
	},
	saveAndCloseRootCauseModel: function(component, event, helper){
		//helper.submitRootCause(component,event);
		if(helper.validateSubmit(component,event)){
			var dateFormat = component.get("v.serviceImpactDate");
			if(dateFormat != '' && dateFormat != null && dateFormat.includes('-')){
				dateFormat = dateFormat.split('-')[1] + '/' + dateFormat.split('-')[2] + '/' + dateFormat.split('-')[0];
			}
			var rootCause = {
				issueCategory: component.get("v.issueCategory"),
	    		defectType: component.get("v.defectType"),
	    		rootCauseIssueCategory: component.get("v.rootCauseIssueCategory"),
	    		rootCause: component.get("v.rootCause").trim(),
	    		briefDesc: component.get("v.briefDesc"),
	    		serviceImpactDate: dateFormat,
	    		businessUnit: component.get("v.businessUnit").trim()
			};
			var evt = $A.get("e.c:ETSBE_submitRootCauseModal");
            if(component.get("v.rowIndex")==0)
            evt.setParams({"rootCauseDetails":rootCause,"update":false});
            if(component.get("v.rowIndex")>0)
            evt.setParams({"rootCauseDetails":rootCause,"update":true});
            
	    	evt.fire();	
	    	var evt1 = $A.get("e.c:ETSBE_closeRootCauseModal");
	    	evt1.setParams({"isRootCause":false});
	    	evt1.fire();
			helper.clearFields(component,helper,false);
		}
	},
	saveAndContinueRootCauseModel: function(component, event, helper){
		//helper.submitRootCause(component,event);
		if(helper.validateSubmit(component,event)){
			console.log('PASSED VALIDATIONS');
			var dateFormat = component.get("v.serviceImpactDate");
			if(dateFormat != '' && dateFormat != null && dateFormat.includes('-')){
				dateFormat = dateFormat.split('-')[1] + '/' + dateFormat.split('-')[2] + '/' + dateFormat.split('-')[0];
			}
			var rootCause = {
				issueCategory: component.get("v.issueCategory"),
	    		defectType: component.get("v.defectType"),
	    		rootCauseIssueCategory: component.get("v.rootCauseIssueCategory"),
	    		rootCause: component.get("v.rootCause").trim(),
	    		briefDesc: component.get("v.briefDesc"),
	    		serviceImpactDate: dateFormat,
	    		businessUnit: component.get("v.businessUnit").trim()
			};
			var evt = $A.get("e.c:ETSBE_submitRootCauseModal");
	    	evt.setParams({"rootCauseDetails":rootCause});
	    	evt.fire();	
            
			//helper.clearFields(component,helper,true);
		}
	},
	noManualEntry : function(component,event,helper){
		event.preventDefault();
        return false;
	},
	
})