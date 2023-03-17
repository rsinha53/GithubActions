({
	 // US2300701	Enhancement View Authorizations and Notifications - Inpatient/Outpatient Details UI (Specific Fields)  - Sarma - 20/01/2020
	processData: function(cmp, event, helper) {
        if(!$A.util.isUndefinedOrNull(cmp.get("v.authDetailsObj").facility)){
			
			if(!$A.util.isUndefinedOrNull(cmp.get("v.authDetailsObj").facility.facilityDecision)){

				if(!$A.util.isUndefinedOrNull(cmp.get("v.authDetailsObj").facility.facilityDecision.decisionReasonCode.description)){

					var finalText = cmp.get("v.authDetailsObj").facility.facilityDecision.decisionReasonCode.description;
					var hoverText = finalText;
					cmp.set('v.hoverText', hoverText);
		
					var charLength = finalText.length;
		
					if(charLength > 20){
						finalText =  finalText.substring(0, 20);
						//alert(finalText);
						finalText = finalText +'...';
						//alert(finalText);
						cmp.set('v.finalText', finalText);
					} else{
						cmp.set('v.finalText', finalText);
					}

				}

			}
        }
    },
})