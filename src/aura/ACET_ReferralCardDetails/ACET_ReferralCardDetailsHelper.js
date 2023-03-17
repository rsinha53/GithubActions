({
    getReferralDisplayMessages : function(component) {
        let strSourceCode, isExchangePlanorPcpOnFile, result, strReason;
        strSourceCode = component.get("v.strSourceCode");
        isExchangePlanorPcpOnFile = (strSourceCode == 'AP' ? (component.get("v.isExchangePlan")): (component.get("v.isPcpOnFile") ? 'Yes':'No'));
        strReason = (strSourceCode == 'CO' ?  component.get("v.strReasonForReferral") : '');
        let action = component.get("c.getACETReferralDisplayMessages");
        action.setParams({
            "sourceCode": strSourceCode,
            "isExchangePlanorPcpOnFile" : isExchangePlanorPcpOnFile,
            "reason" : strReason
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state == "SUCCESS"){
                result = response.getReturnValue();
                if(result && result.length > 0) {
                    component.set("v.objSelectedVRecord", result[0]);
                }
            }
        });
        $A.enqueueAction(action);
    },

    formatDate : function(strDate) {
        if(strDate && strDate.split('-') && strDate.split('-').length > 0) {
            let lstVal = strDate.split('-');
            return lstVal[1]+'/'+lstVal[2]+'/'+lstVal[0];
        }
    }, 

    checkIfValidVisitsIsEntered : function(component, strVisit) {
        //061330992
        let boolIsInValid = false; //US3574032
        if(component.get("v.strSourceCode") == 'CO' && !$A.util.isUndefinedOrNull(component.get("v.objSelectedVRecord.No_of_Visits__c")) && !$A.util.isEmpty(component.get("v.objSelectedVRecord.No_of_Visits__c"))
            && (Number(strVisit) > Number(component.get("v.objSelectedVRecord.No_of_Visits__c")) 
            || Number(strVisit) <= 0 
            || strVisit == '' 
            || strVisit == null)) { 
            boolIsInValid = true;
            if(component.find('idNoOfVisitsErrorMessage').getElement().classList.contains('slds-hide')) {
                component.find('idNoOfVisitsErrorMessage').getElement().classList.remove('slds-hide');
            } 
        } else {
            component.find('idNoOfVisitsErrorMessage').getElement().classList.add('slds-hide');
        }
        return boolIsInValid;
    }
})