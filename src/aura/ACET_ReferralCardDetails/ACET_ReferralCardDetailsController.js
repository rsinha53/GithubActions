({
    onDoInit : function(component, event, helper) {
        helper.getReferralDisplayMessages(component);
        let objPcpReferralDetailsHeader = {'strReferringToHeader' : 'Referral Details','showRefferingToName':false};
        component.set("v.objPcpReferralDetailsHeader", objPcpReferralDetailsHeader);
        if(component.find('idNoOfVisitsErrorMessage') && component.find('idNoOfVisitsErrorMessage').getElement() && !component.find('idNoOfVisitsErrorMessage').getElement().classList.contains('slds-hide')) {
            component.find('idNoOfVisitsErrorMessage').getElement().classList.add('slds-hide');
        }
    },

    submitAndReview : function(component, event, helper) {

        let strVal = '';
        
        if(component.find('idNoofVisitsDiv') && component.find('idNoofVisitsDiv').getElement() && component.find('idNoofVisitsDiv').getElement().querySelector('input')) {
            strVal = component.find('idNoofVisitsDiv').getElement().querySelector('input').value;
        }
        
        if(helper.checkIfValidVisitsIsEntered(component, strVal)) {
            return
        }

        var startDate = '';
        if(component.get("v.dtStartDate")){
            startDate = helper.formatDate(component.get("v.dtStartDate"));
        }
        var EndDate = '';
        if(component.get("v.dtEndDate")){
            EndDate =  helper.formatDate(component.get("v.dtEndDate"));
        }
        let ObjReferralDetails = {
            "referralDates" : startDate+ ' - ' +EndDate,
            "numberOfVists" : document.getElementById('idNumOfVists').value,
            "primaryDiagnoisCode" : component.get("v.strPrimaryDxCode"),
            "primaryDescription" :component.get("v.strPrimaryDxDescription"),
            "secondaryDiagnoisCode" : component.get("v.strSecondaryDxCode"),
            "secondaryDescription" :component.get("v.strSecondaryDxDescription"),
        };
        component.set("v.referralDetails",ObjReferralDetails);
		component.set("v.isModalOpen",true);
    },
    closeModal : function(component,event,helper){
         component.set('v.isModalOpen', false);
    },

    handleExchangePlanChange : function (component, event, helper) {
        if(event.getParam("oldValue") != event.getParam("value") && event.getParam("value") != 'undefined') {
            if(event.getParams('expression') && event.getParams('expression')['expression'] 
                && event.getParams('expression')['expression'] == 'v.strReasonForReferral' 
                /*&& component.get("v.strSourceCode") == 'CO'*/) {
                component.set("v.dtStartDate","");
                component.set("v.dtEndDate","");
            }
             helper.getReferralDisplayMessages(component);
        }
    }, 

    handleStartDateChange : function (component, event, helper) {
        if(event.getParam("oldValue") != event.getParam("value") && event.getParam("value") != 'undefined') {
            let dtStartDate = new Date(event.getParam("value"));
            let dtEndDate = new Date(dtStartDate.setDate(dtStartDate.getDate() + component.get("v.objSelectedVRecord.End_Date__c")));
            dtEndDate = $A.localizationService.formatDate(dtEndDate, "yyyy-MM-dd");
            component.set("v.dtEndDate", dtEndDate);
        }
    },

    handleNumofVisitsOnChange : function(component, event, helper) {
        if(event.currentTarget != 'undefined' && event.currentTarget.value != '' && event.currentTarget.value != null) {
            helper.checkIfValidVisitsIsEntered(component, event.currentTarget.value);
        }
    }
})