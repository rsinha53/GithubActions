({
    doInit: function (cmp, event, helper) {
        var memberDetails = {
            "memberId": "",
            "dob": "",
            "firstName": "",
            "lastName": "",
            "groupNumber": "",
            "searchOption": "",
            "state": "",
            "zip": "",
            "phone": "",
            "memberNotFound": false
        };
        cmp.set("v.memberDetails", memberDetails);
        helper.getStateValues(cmp);
    },

    showOrHideAdvancedSearch: function (cmp, event, helper) {
        var eventSource = event.target;
        var linkName = eventSource.innerHTML;
        if (linkName == "Show Advanced Search") {
            eventSource.innerHTML = "Hide Advanced Search";
            cmp.set("v.isAdvancedSearch", true);
            helper.clearFieldValidations(cmp, event);
        } else if (linkName == "Hide Advanced Search") {
            eventSource.innerHTML = "Show Advanced Search";
            cmp.set("v.isAdvancedSearch", false);
        }
    },

    onMemSearchDisabledFromPrv: function (cmp, event, helper) {
        helper.clearFieldValidations(cmp, event);
    },

    searchMember: function (cmp, event, helper) {
        if (helper.checkValidation(cmp, event) && helper.checkDuplicateProviderOrMember(cmp, event)) {
            // call web service
            helper.searchMember(cmp, event)
        }
    },

    addMember: function (cmp, event, helper) {
        if (helper.checkValidation(cmp, event)) {
            // populate data to interaction overview
            helper.openInteractionOverview(cmp, event);
        }
    },

    clearFieldValidationsAndValues: function (cmp, event, helper) {
        helper.clearFieldValues(cmp, event);
        helper.clearFieldValidations(cmp, event);
    },

    handleMemberNotFound: function (cmp, event, helper) {
        if (event.getSource().get("v.checked")) {

        }
    },

    onChangeZip: function (cmp, event, helper) {
        helper.keepOnlyDigits(cmp, event);
    },

    onChangePhone: function (cmp, event, helper) {
        helper.keepOnlyDigits(cmp, event);
    },

    openMemberRecords : function(cmp, event, helper){
        cmp.set('v.showMemberListSection',!cmp.get('v.showMemberListSection'));
    },

    closeMemberRecords : function(cmp, event, helper){
        cmp.set('v.showMemberListSection',false);
    },

})