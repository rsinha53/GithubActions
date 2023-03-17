({
    getCNSAppealTable: function (cmp) {
        cmp.set("v.showSpinner", true);
        var action = cmp.get("c.getCNSAppealTable");
        var appealRequest = new Object();
        appealRequest.tin = cmp.get("v.taxId");
        appealRequest.memberId = cmp.get("v.isOpenSearch") ? '' : cmp.get("v.memberId");
        appealRequest.patientFn = cmp.get("v.isOpenSearch") ? '' : cmp.get("v.memberFN");
        appealRequest.patientLn = cmp.get("v.isOpenSearch") ? '' : cmp.get("v.memberLN");
        appealRequest.appealId = cmp.get("v.appealNum");
        appealRequest.claimNumber = cmp.get("v.claimNum");
        appealRequest.firstSubmDt = cmp.get("v.fromDate");
        appealRequest.lastSubmDt = cmp.get("v.toDate");
        action.setParams({
            "appealRequest": appealRequest
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                result.callTopic = 'View Appeals';
                result.isResolvedHidden = true;
                cmp.set("v.appealTableDetails", result);
                _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"), cmp.get("v.policySelectedIndex"), result);
                this.setRetainedAutodoc(cmp);

                var caseNotSavedTopics = cmp.get("v.caseNotSavedTopics");
                if (!caseNotSavedTopics.includes("View Appeals")) {
                    caseNotSavedTopics.push("View Appeals");
                }
                cmp.set("v.caseNotSavedTopics", caseNotSavedTopics);
            } else {
                this.showToastMessage("We hit a snag.", "Cannot retreive Appeal Results", "error", "dismissible", "30000");
            }
            cmp.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },

    getENIMNRAppealTable: function (cmp) {
        cmp.set("v.showSpinner", true);
        var action = cmp.get("c.getENIMNRAppealTable");
        var appealRequest = new Object();
        appealRequest.tin = cmp.get("v.taxId");
        appealRequest.memberId = cmp.get("v.isOpenSearch") ? '' : cmp.get("v.memberId");
        appealRequest.patientFn = cmp.get("v.isOpenSearch") ? '' : cmp.get("v.memberFN");
        appealRequest.patientLn = cmp.get("v.isOpenSearch") ? '' : cmp.get("v.memberLN");
        appealRequest.appealId = cmp.get("v.appealNum");
        appealRequest.claimNumber = cmp.get("v.claimNum");
        appealRequest.firstSubmDt = cmp.get("v.fromDate");
        appealRequest.lastSubmDt = cmp.get("v.toDate");
        action.setParams({
            "appealRequest": appealRequest
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                result.callTopic = 'View Appeals';
                cmp.set("v.appealTableDetails", result);
                _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"), cmp.get("v.policySelectedIndex"), result);
                this.setRetainedAutodoc(cmp);

                var caseNotSavedTopics = cmp.get("v.caseNotSavedTopics");
                if (!caseNotSavedTopics.includes("View Appeals")) {
                    caseNotSavedTopics.push("View Appeals");
                }
                cmp.set("v.caseNotSavedTopics", caseNotSavedTopics);
            } else {
                this.showToastMessage("We hit a snag.", "Cannot retreive Appeal Results", "error", "dismissible", "30000");
            }
            cmp.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },

    showToastMessage: function (title, message, type, mode, duration) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type": type,
            "mode": mode,
            "duration": duration
        });
        toastEvent.fire();
    },

    setDefaultAutodoc: function (cmp) {
        if (!cmp.get("v.isProviderSnapshot")) {
            var defaultAutoDocPolicy = _autodoc.getAutodocComponent(cmp.get("v.memberautodocUniqueId"), cmp.get("v.policySelectedIndex"), 'Policies');
            var defaultAutoDocMember = _autodoc.getAutodocComponent(cmp.get("v.memberautodocUniqueId"), cmp.get("v.policySelectedIndex"), 'Member Details');
            var memberAutodoc = new Object();
            memberAutodoc.type = 'card';
            memberAutodoc.componentName = "Member Details";
            memberAutodoc.autodocHeaderName = "Member Details";
            memberAutodoc.noOfColumns = "slds-size_6-of-12";
            memberAutodoc.componentOrder = 0.5;
            memberAutodoc.ignoreClearAutodoc = false;
            var cardData = [];
            if (!$A.util.isUndefinedOrNull(defaultAutoDocMember)) {
                cardData = defaultAutoDocMember.cardData.filter(function (el) {
                    if (!$A.util.isEmpty(el.defaultChecked) && el.defaultChecked) {
                        return el;
                    }
                });
            }

            memberAutodoc.cardData = cardData;
            memberAutodoc.ignoreAutodocWarningMsg = true;
            var policyAutodoc = new Object();
            policyAutodoc.type = "table";
            policyAutodoc.autodocHeaderName = "Policies";
            policyAutodoc.componentName = "Policies";
            policyAutodoc.tableHeaders = ["GROUP #", "SOURCE", "PLAN", "TYPE", "PRODUCT", "COVERAGE LEVEL", "ELIGIBILITY DATES", "STATUS", "REF REQ", "PCP REQ", "RESOLVED"];
            policyAutodoc.tableBody = defaultAutoDocPolicy.tableBody;
            policyAutodoc.selectedRows = defaultAutoDocPolicy.selectedRows;
            policyAutodoc.callTopic = 'View Member Eligibility';
            policyAutodoc.componentOrder = 0;
            policyAutodoc.ignoreAutodocWarningMsg = true;
            policyAutodoc.ignoreClearAutodoc = false;
            _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"), cmp.get("v.policySelectedIndex"), policyAutodoc);
            _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"), cmp.get("v.policySelectedIndex"), memberAutodoc);
        }
    },

    setRetainedAutodoc: function (cmp) {
        // Setting Retained autodoc
        var appealTableDetails = cmp.get('v.appealTableDetails');
        var selectedRows = [];
        var extingAppealTable = _autodoc.getAutodocComponent(cmp.get("v.autodocUniqueId"), cmp.get("v.policySelectedIndex"), 'Appeal Results');
        if (!$A.util.isEmpty(extingAppealTable)) {
            selectedRows = extingAppealTable.selectedRows;
        }
        if (!$A.util.isUndefinedOrNull(appealTableDetails) && !$A.util.isEmpty(appealTableDetails)) {
            if (!$A.util.isEmpty(selectedRows)) {
                appealTableDetails.selectedRows = selectedRows;
                cmp.set('v.selectedRows', selectedRows);
            } else {
                appealTableDetails.selectedRows = [];
                cmp.set('v.selectedRows', []);
            }
        }
        cmp.set('v.appealTableDetails', appealTableDetails);
    }
})