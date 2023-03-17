({
    showBenefitResultSpinner: function (cmp) {
        var spinner = cmp.find("benefit-result-spinner");
        $A.util.removeClass(spinner, "slds-hide");
        $A.util.addClass(spinner, "slds-show");
    },
    
    hideBenefitResultSpinner: function (cmp) {
        var spinner = cmp.find("benefit-result-spinner");
        $A.util.removeClass(spinner, "slds-show");
        $A.util.addClass(spinner, "slds-hide");
    },
    
    setDefaultAutodoc: function(cmp){
        var defaultAutoDocPolicy = _autodoc.getAutodocComponent(cmp.get("v.memberautodocUniqueId"),cmp.get("v.policySelectedIndex"),'Policies');
        var defaultAutoDocMember = _autodoc.getAutodocComponent(cmp.get("v.memberautodocUniqueId"),cmp.get("v.policySelectedIndex"),'Member Details');
        var memberAutodoc = new Object();
        memberAutodoc.type = 'card';
        memberAutodoc.componentName = "Member Details";
        memberAutodoc.autodocHeaderName = "Member Details";
        memberAutodoc.noOfColumns = "slds-size_6-of-12";
        memberAutodoc.componentOrder = 2;
        var cardData = [];
        cardData = defaultAutoDocMember.cardData.filter(function(el){
            if(!$A.util.isEmpty(el.defaultChecked) && el.defaultChecked) {
                return el;
            }
        });
        memberAutodoc.cardData = cardData;
        var autodocSubId = cmp.get("v.autodocUniqueId") + cmp.get("v.policySelectedIndex");
        _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"), autodocSubId, defaultAutoDocPolicy);
        _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"), autodocSubId, memberAutodoc);
    },
    
    getBenefitCodeDetails : function(cmp) {
        let action = cmp.get("c.getBenefitDetails");
        let memberCardData = cmp.get('v.memberCardData');
        let policySelectedIndex = cmp.get('v.policySelectedIndex');
        let policyId = '';
        let patientKey = '';
        let serviceTypeDescription_API = cmp.get('v.serviceTypeDescription_API');
        
        if (!$A.util.isUndefinedOrNull(memberCardData.CoverageLines[policySelectedIndex])) {
            if (!$A.util.isUndefinedOrNull(memberCardData.CoverageLines[policySelectedIndex].patientInfo)) {
                patientKey = memberCardData.CoverageLines[policySelectedIndex].patientInfo.patientKey;
            }
        }
        
        if (!$A.util.isUndefinedOrNull(memberCardData.CoverageLines[policySelectedIndex].policyId)) {
            policyId = memberCardData.CoverageLines[policySelectedIndex].policyId;
        }
        
        let requestParamObj = {
            patientKey: patientKey,
            policyId: policyId,
            serviceTypeDescription_API: serviceTypeDescription_API
        }
        
        action.setParams({ 
            "requestObject": requestParamObj,
            "componentName": cmp.get("v.titleLabel"),
            "componentOrder": cmp.get("v.componentOrder") + 4,
            "policyIndex": cmp.get("v.policySelectedIndex")
        });
        
        action.setCallback(this, function (response) {
            let state = response.getState();
            this.hideBenefitResultSpinner(cmp);
            //this.setDefaultAutodoc(cmp);
            if (state == "SUCCESS") {
                let result = response.getReturnValue();
                cmp.set("v.isServiceCalled",true);
                cmp.set("v.benefitDetailList",result.benefitTable);
                if (!$A.util.isEmpty(result.benefitTable)) {
					result.benefitTable.hideResolveColumn = true; // DE378183 - Thanish - 21st Oct 2020
                    cmp.set("v.componentOrder",result.benefitTable.componentOrder);
                    if (result.benefitTable.statusCode != 200) {
                        this.fireToastMessage("Error!",result.benefitTable.errorMessage, "error", "dismissible", "10000");
                    }
                }
            } else {
                this.fireToastMessage("Error!", 'Server side error!', "error", "dismissible", "10000");
            }
        });
        $A.enqueueAction(action);
    },
    
    fireToastMessage: function (title, message, type, mode, duration) {
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
    
    // US2301694
    initAutoDocTab: function (cmp, event) {
        setTimeout(function () {
            var tabKey = cmp.get("v.AutodocKey");
            window.lgtAutodoc.initAutodoc(tabKey);
            var BDID = cmp.get("v.BenefitDescAutodocId");	
            document.getElementById(BDID).getElementsByClassName('autodoc')[1].checked = true; //US1934460 - Avish
        });
    },

    // US3308234 - Thanish - 1st Mar 2021
    getNotesDetails: function(cmp){
        var notesVal = cmp.get("v.objectData").notesList;
        var cardDetails = new Object();
        cardDetails.componentName = cmp.get("v.titleLabel") + " Notes";
        cardDetails.componentOrder = cmp.get("v.benefitDetailList").componentOrder + 0.5;
        cardDetails.noOfColumns = "slds-size_12-of-12";
        cardDetails.type = "card";
        cardDetails.allChecked = false;
        cardDetails.caseItemExtId = cmp.get("v.titleLabel") + ' - Benefit Accumulations';
        cardDetails.isAccu = true;
        cardDetails.supHeadName = cmp.get("v.titleLabel");
        cardDetails.caseItemsEnabled = false;
        cardDetails.cardData = [
            {
                "checked": false,
                "defaultChecked": false,
                "fieldName": "",
                "fieldType": "unescapedHtml",
                "fieldValue": !$A.util.isEmpty(notesVal) ? notesVal.join(' <br> ') : 'N/A',
                "showCheckbox": false,
                "isReportable":false
            }
        ];
        cmp.set("v.notesCardDetails", cardDetails);
    }
    
})