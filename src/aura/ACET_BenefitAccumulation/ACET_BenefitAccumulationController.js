({
    onInit : function(cmp, event, helper) {
        var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
        cmp.set('v.asOfDate', today);
        // Toggle
        cmp.set("v.toggleName", "slds-hide");
        cmp.set("v.icon", "utility:chevronright");
        // End
        
        var policies = cmp.get('v.policyDetails');
        if (!$A.util.isUndefinedOrNull(policies) && !$A.util.isUndefinedOrNull(policies.resultWrapper) && !$A.util.isUndefinedOrNull(policies.resultWrapper.policyRes)){
            cmp.set("v.transactionId", policies.resultWrapper.policyRes.transactionId);
        }
        //helper.getBenefitRecords(cmp, event, helper);
    },
    onblur : function(component, event, helper) {
        component.set("v.listOfSearchRecords", null );
        component.set("v.SearchKeyWord", '');
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
    },
    onfocus : function(component, event, helper) {
        var forOpen = component.find("searchRes");
        $A.util.addClass(forOpen, 'slds-is-open');
        $A.util.removeClass(forOpen, 'slds-is-close');
        var getInputkeyWord = '';
        helper.searchHelper(component,event,getInputkeyWord);
    },
    keyPressController : function(cmp, event, helper) {
        var getInputkeyWord = cmp.get("v.SearchKeyWord");
        // check if getInputKeyWord size id more then 0 then open the lookup result List and
        // call the helper
        // else close the lookup result List part.
        if(getInputkeyWord.length > 0){
            var forOpen = cmp.find("searchRes");
            $A.util.addClass(forOpen, 'slds-is-open');
            $A.util.removeClass(forOpen, 'slds-is-close');
            helper.searchHelper(cmp,event,getInputkeyWord);
        }
        else{
            cmp.set("v.listOfSearchRecords", null );
        }
    },
    selectRecord : function(component, event, helper) {
        console.log('Selected STC: '+event);
    },
    chevToggle : function(cmp, event, helper) {
        var iconName = cmp.find("chevInactive").get("v.iconName");
        
        if(iconName === "utility:chevrondown"){
            cmp.set("v.icon", "utility:chevronright");
            cmp.set("v.toggleName", "slds-hide");
        }else{
            cmp.set("v.icon", "utility:chevrondown");
            cmp.set("v.toggleName", "slds-show");
            // US1741780 - if condition for service call
            if(!cmp.get("v.isServiceCalled")){
                //helper.showBenefitResultSpinner(cmp);
                //helper.getBenefitCodeDetails(cmp,helper);
                helper.getTherapyData(cmp, event, helper);
            }
        }
    },
    // This function call when the end User Select any record from the result list.
    handleComponentEvent: function (cmp, event, helper) {
        
        cmp.set("v.SearchKeyWord", null);
        var listSelectedItems = cmp.get("v.lstSelectedRecords");
        var selectedAccountGetFromEvent = event.getParam("recordByEvent");
        var ctrlPressed = event.getParam("ctrlPressed");
        listSelectedItems.push(selectedAccountGetFromEvent);
        cmp.set("v.lstSelectedRecords", listSelectedItems);
        
        var forclose = cmp.find("lookup-pill");
        $A.util.addClass(forclose, 'slds-show');
        $A.util.removeClass(forclose, 'slds-hide');
        
        if(!ctrlPressed){
            var forclose = cmp.find("searchRes");
            $A.util.addClass(forclose, 'slds-is-close');
            $A.util.removeClass(forclose, 'slds-is-open');
        }else{
            var forOpen = cmp.find("searchRes");
            $A.util.addClass(forOpen, 'slds-is-open');
            $A.util.removeClass(forOpen, 'slds-is-close');
        }
        
        setTimeout(function () {
            cmp.find("callTopicId").focus();
        }, 1000);
    },
    showAccumulationsTable : function (cmp, event, helper) {
        try {
            // benefitRecordsAccordian
            cmp.set("v.isShowBenefitAccordian", true); 
            if (cmp.get("v.lstSelectedRecordsToAccordian") && cmp.get("v.lstSelectedRecords") && cmp.get("v.lstSelectedRecordsToAccordian").length > 0) 
            {
                let nextSelectedRec = cmp.get("v.lstSelectedRecords").slice(cmp.get("v.lstSelectedRecordsToAccordian").length, cmp.get("v.lstSelectedRecords").length);
                let finallstRecordsToAccordian = nextSelectedRec.concat(cmp.get("v.lstSelectedRecordsToAccordian"));
                cmp.set("v.lstSelectedRecordsToAccordian", finallstRecordsToAccordian);
                
            } else {
                cmp.set("v.lstSelectedRecordsToAccordian", cmp.get("v.lstSelectedRecords"));
            }
        } catch (exception) {
            console.log('=exception ' + exception);
        }
    },
    clear: function (cmp, event, helper) {
        var selectedPillId = event.getSource().get("v.name");
        var AllPillsList = cmp.get("v.lstSelectedRecords");
        let selectedRecinAccordian = cmp.get("v.lstSelectedRecordsToAccordian");
        
        for(var i = 0; i < AllPillsList.length; i++){
            if(AllPillsList[i].Id == selectedPillId){
                AllPillsList.splice(i, 1);
                cmp.set("v.lstSelectedRecords", AllPillsList);
            }
        }
        //US2672003 - Planbenfits Benfit Details Stacking -  07/03/2020
        for(var i = 0; i < selectedRecinAccordian.length; i++){
            if(selectedRecinAccordian[i].Id == selectedPillId){
                selectedRecinAccordian.splice(i, 1);
                cmp.set("v.lstSelectedRecordsToAccordian", selectedRecinAccordian);
            }
        }
        cmp.set("v.SearchKeyWord",null);
        cmp.set("v.listOfSearchRecords", null );
    },
    policyDetailsChanged: function (cmp, event, helper) {
        
        let lstSelectedRecords = [];
        let lstSelectedRecordsToAccordian = [];
        cmp.set("v.isShowBenefitAccordian", false);
        cmp.set("v.lstSelectedRecords", lstSelectedRecords);
        cmp.set("v.lstSelectedRecordsToAccordian", lstSelectedRecordsToAccordian);
        var policies = cmp.get('v.policyDetails');
    },
    toggleSection: function (component, event, helper) {
        var sectionAuraId = event.target.getAttribute("data-auraId");
        var sectionDiv = component.find(sectionAuraId).getElement();
        var sectionState = sectionDiv.getAttribute('class').search('slds-is-open');
        if (sectionState == -1) {
            helper.getNonTherapyData(component, event, helper);
            sectionDiv.setAttribute('class', 'slds-section slds-is-open');
        } else {
            sectionDiv.setAttribute('class', 'slds-section slds-is-close');
    }
    },
    selectedPolicyChanged: function (component, event, helper) {
        // DE450645: Regression: Error occurred popup displayed while switching from policy to policy - Krish - 6th June 2021
        var sectionAuraId = "nonTherapy";
        var sectionDiv = component.find(sectionAuraId).getElement();
        var sectionState = sectionDiv.getAttribute('class').search('slds-is-open');
        if (sectionState != -1) {
            sectionDiv.setAttribute('class', 'slds-section slds-is-close');
        }
    }
})