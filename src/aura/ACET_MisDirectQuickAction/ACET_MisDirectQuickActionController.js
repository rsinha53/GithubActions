({
	doInit : function(component, event, helper) {
		var getCaseParams = component.get("c.getCaseDetails");
		getCaseParams.setParams({
			"caseId": component.get("v.recordId")
		});
		getCaseParams.setCallback(this,function(response){
			var state = response.getState();
			if(state == 'SUCCESS'){
				var caseParams = {};
				caseParams = response.getReturnValue();
				console.log('Case Params'+ JSON.stringify(caseParams));
				if(!$A.util.isUndefinedOrNull(caseParams) && !$A.util.isEmpty(caseParams)){
					for(var key in caseParams){
						if(key == 'ContactName'){
							component.set("v.contactName",caseParams[key]);	
						}
						if(key == 'ContactFirstName'){
							component.set("v.contactFirstName",caseParams[key]);	
						}
						if(key == 'ContactLastName'){
							component.set("v.contactLastName",caseParams[key]);	
						}
						if(key == 'PhoneNumber'){
							component.set("v.phoneNumber",caseParams[key]);
						}
						if(key == 'Ext'){
							component.set("v.ext",caseParams[key]);
						}
						if(key == 'OriginatorName'){
							component.set("v.originatorName",caseParams[key]);
						}
						if(key == 'OriginatorType'){
							component.set("v.originatorType",caseParams[key]);
						}
						if(key == 'SubjectName'){
							component.set("v.subjectName",caseParams[key]);
						}
						if(key == 'SubjectType'){
							component.set("v.subjectType",caseParams[key]);
						}
						if(key == 'SubjectDOB'){
							component.set("v.subjectDOB",caseParams[key]);
						}
						if(key == 'SubjectID'){
							component.set("v.subjectID",caseParams[key]);
						}
						if(key == 'SubjectGrpID'){
							component.set("v.subjectGrpID",caseParams[key]);
						}
						if(key == 'InteractionId'){
							component.set("v.interactionId",caseParams[key]);
						}
					}
					helper.navigateToMisdirect(component, event, helper);
				}
			}
		});
		$A.enqueueAction(getCaseParams);
	}
})