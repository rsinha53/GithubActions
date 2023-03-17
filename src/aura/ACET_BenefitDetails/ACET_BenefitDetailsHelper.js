({
    // US3304569 - Thanish - 17th Mar 2021
    benefitDetailsErrorMessage: "Unexpected Error Occurred in the Benefit Details Card. Please try again. If problem persists please contact the help desk",

    autodocHelper: function (cmp) {
        var benefitCard = new Object();
        benefitCard.type = 'card';
        benefitCard.componentName = 'Benefit Details';
        benefitCard.autodocHeaderName = 'Benefit Details';
        benefitCard.noOfColumns = 'slds-size_3-of-12';
        benefitCard.componentOrder = 5;
        var cardData = [];
        if (cmp.get("v.isIbaagBtnClicked")) {
            cardData.push(new fieldDetails(true, false, true, cmp.get("v.btnLabel"), 'Accessed', 'outputText'));
        }
        if (cmp.get("v.selectedCalendarYear")) {
            cardData.push(new fieldDetails(true, false, true, cmp.get("v.yearType"), cmp.get("v.displayYear"), 'outputText'));
        }
        if (cmp.get("v.selectedHSA")) {
            cardData.push(new fieldDetails(true, false, true, 'HRA/H.S.A', cmp.get("v.cdhpVal"), 'outputText'));
        }
        if (cmp.get("v.selectedEnrollment")) {
            cardData.push(new fieldDetails(true, false, true, 'Open Enrollment', 'Accessed', 'outputText'));
        }

        //Case item for IBAAG/CalendarYear/HSA/Enrollment
        if (cmp.get("v.isIbaagBtnClicked") || cmp.get("v.selectedCalendarYear") || cmp.get("v.selectedHSA") || cmp.get("v.selectedEnrollment")) {
            benefitCard.caseItemsEnabled = true;
            benefitCard.caseItemExtId = 'Benefit Details';
            benefitCard.caseItemsExtId = 'Benefit Details';
        }
        benefitCard.cardData = cardData;
        this.setDefaultAutodoc(cmp);
        // Change - autodoc duplicating
        // _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"), cmp.get("v.autodocUniqueIdCmp") + cmp.get("v.policySelectedIndex"), benefitCard);
        _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"), cmp.get("v.autodocUniqueId") + cmp.get("v.policySelectedIndex"), benefitCard);

        function fieldDetails(c, dc, sc, fn, fv, ft) {
            this.checked = c;
            this.defaultChecked = dc;
            this.showCheckbox = sc;
            this.fieldName = fn;
            this.fieldValue = fv;
            this.fieldType = ft;
            this.isReportable = true;
        }
    },

    setDefaultAutodoc: function (cmp) {
        var defaultAutoDocPolicy = _autodoc.getAutodocComponent(cmp.get("v.memberautodocUniqueId"), cmp.get("v.policySelectedIndex"), 'Policies');
        var defaultAutoDocMember = _autodoc.getAutodocComponent(cmp.get("v.memberautodocUniqueId"), cmp.get("v.policySelectedIndex"), 'Member Details');
        console.log('member' + JSON.stringify(defaultAutoDocMember));
        var memberAutodoc = new Object();
        memberAutodoc.type = 'card';
        memberAutodoc.componentName = "Member Details";
        memberAutodoc.autodocHeaderName = "Member Details";
        memberAutodoc.noOfColumns = "slds-size_6-of-12";
        memberAutodoc.componentOrder = 2;
        var cardData = [];
        cardData = defaultAutoDocMember.cardData.filter(function (el) {
            if (!$A.util.isEmpty(el.defaultChecked) && el.defaultChecked) {
                return el;
            }
        });
        memberAutodoc.cardData = cardData;
        var autodocSubId = cmp.get("v.autodocUniqueId") + cmp.get("v.policySelectedIndex");
        _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"), autodocSubId, defaultAutoDocPolicy);
        _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"), autodocSubId, memberAutodoc);
        // US3804847 - Krish - 26th August 2021
        var interactionCard = cmp.get("v.interactionCard");
        var providerFullName = '';
        var providerComponentName = '';
        var defaultAutoDocProvider;
        if(!$A.util.isUndefinedOrNull(interactionCard) && !$A.util.isEmpty(interactionCard)){
            providerFullName = interactionCard.firstName + ' ' + interactionCard.lastName;
            providerComponentName = 'Provider: '+ ($A.util.isEmpty(providerFullName) ? "" : providerFullName);
        }
        if(!$A.util.isEmpty(providerComponentName) && providerComponentName != 'Provider: '){
            defaultAutoDocProvider = _autodoc.getAutodocComponent(cmp.get("v.memberautodocUniqueId"), cmp.get("v.policySelectedIndex"), providerComponentName);
        } 
        if(!$A.util.isUndefinedOrNull(defaultAutoDocProvider) && !$A.util.isEmpty(defaultAutoDocProvider)){
            defaultAutoDocProvider.ignoreClearAutodoc = false;
            defaultAutoDocProvider.componentOrder = 1.5;
            _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"), autodocSubId, defaultAutoDocProvider);
        }
        
    },

    /*searchHelper : function(cmp,event,getInputkeyWord) {
        // call the apex class method 
        var action = cmp.get("c.fetchBenefitCodes");
        // set param to method  
        console.log('Page Names :: '+cmp.get("v.detailPgName"));
        
        action.setParams({
            'searchKeyWord': getInputkeyWord,
            'ObjectName' : 'Benefit_Configuration__c',
            'ExcludeitemsList' : cmp.get("v.lstSelectedRecords")
            
        });
        // set a callBack    
        action.setCallback(this, function(response) {
            // $A.util.removeClass(component.find("mySpinner"), "slds-show");
            var state = response.getState();
            console.log("-------"+state);
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                // if storeResponse size is equal 0 ,display No Records Found... message on screen.                }
                if (storeResponse.length == 0) {
                    cmp.set("v.Message", 'No Records Found...');
                } else {
                    cmp.set("v.Message", '');
                    // set searchResult list with return value from server.
                }
                cmp.set("v.listOfSearchRecords", storeResponse);                
                
            }
        });
        // enqueue the Action  
        $A.enqueueAction(action);
    },*/

    // US2618180
    /*fireCallTopicAutodoc: function(cmp, event, helper) {
        var appEvent = $A.get("e.c:ACET_CallTopicAutodoc");
        appEvent.setParams({
            memberTabId: cmp.get('v.memberTabId'),
            AutodocKey: cmp.get('v.AutodocKey'),
            AutodocPageFeature: cmp.get('v.AutodocPageFeature')
        });
        appEvent.fire();
    },*/

    //US3068299 - Sravan - Start
    deleteAutoDoc: function (component, event, helper) {
        var autoDocToBeDeleted = component.get("v.autoDocToBeDeleted");
        console.log('autoDocToBeDeleted' + JSON.stringify(component.get("v.autoDocToBeDeleted")));
        console.log('cmp.get("v.autodocUniqueId")' + component.get("v.autodocUniqueId"));
        if (!$A.util.isUndefinedOrNull(autoDocToBeDeleted) && !$A.util.isEmpty(autoDocToBeDeleted)) {
            if (autoDocToBeDeleted.doNotRetainAutodDoc) {
                _autodoc.deleteAutodoc(component.get("v.autodocUniqueId"), component.get("v.autodocUniqueId") + autoDocToBeDeleted.selectedPolicyKey);
                _autodoc.deleteAutodoc(component.get("v.autodocUniqueId"), component.get("v.autodocUniqueIdCmp") + autoDocToBeDeleted.selectedPolicyKey);
            }
        }
    },
    //US3068299 - Sravan - End

    // Sanka - US3125207
    /*getBenefitRecords: function (cmp, event, helper) {
        var action = cmp.get("c.getBenefitInfo");
        action.setParams({
            "transactionId": cmp.get("v.transactionId")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set("v.benefitRecords", response.getReturnValue());
                cmp.set("v.benefitRecordsFiltered", response.getReturnValue());
                cmp.set("v.benefitRecordsSelected", []);
                cmp.set("v.benefitRecordsAccordian", []);
            }
        });
        $A.enqueueAction(action);
    },*/

    // US3125215 - Thanish - 22nd Dec 2020
    getBenefitSearchresults: function (cmp, searchPhrase) {
        $A.util.removeClass(cmp.find("benefitDetailsSpinner"), "slds-hide");
        var action = cmp.get("c.getBenefitSearchResults");
        action.setParams({
            "transactionId": cmp.get("v.transactionId"),
            "searchPhrase": searchPhrase
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                // US3304569 - Thanish - 17th Mar 2021
                var result = response.getReturnValue();
                var searchedResults = result.benefitList;
                if(result.statusCode ==200){
                    if (!$A.util.isEmpty(searchedResults)) {
                        cmp.set("v.isShowBenefitAccordian", true);
                        cmp.set("v.benefitRecordsAccordian", result.benefitList);
                    } else {
                        cmp.set("v.isShowBenefitAccordian", false);
                        cmp.set("v.benefitRecordsAccordian", searchedResults);
                        this.showToastMessage("Warning!", "Search criteria does not match a benefit", "warning", "dismissible", "10000");
                    }
                } else{
                    this.showToastMessage("We hit a snag.", this.benefitDetailsErrorMessage, "error", "dismissible", "30000");
                }
                /*if(searchedResults.length > 0) {
                    var benefitRecords = cmp.get("v.benefitRecords");
                    var reversed = searchedResults.reverse();
                    
                    for(var result of reversed){
                        benefitRecords.unshift(result);
                    }
                    cmp.set("v.benefitRecords", benefitRecords);
                    cmp.set("v.benefitRecordsFiltered", benefitRecords);
                }
                
                var forOpen = cmp.find("searchRes");
                $A.util.addClass(forOpen, 'slds-is-open');
                $A.util.removeClass(forOpen, 'slds-is-close');*/
            } else {
                this.showToastMessage("We hit a snag.", this.benefitDetailsErrorMessage, "error", "dismissible", "30000"); // US3304569 - Thanish - 17th Mar 2021
            }
            $A.util.addClass(cmp.find("benefitDetailsSpinner"), "slds-hide");
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
    // US3507751 - Save Case Consolidation
    caseWrapperHelper: function (cmp, event, helper) {
        // US2442658
        cmp.set("v.AutodocKeyMemberDtl", cmp.get('v.AutodocKey')); // component.get("v.AutodocKey")
        cmp.set('v.AutodocPageFeatureMemberDtl', cmp.get('v.AutodocPageFeature'));
        var caseWrapper = cmp.get('v.caseWrapper');
        var selectedPolicy = cmp.get('v.policyDetails');
        var sourceCode = '';
        if (!$A.util.isUndefinedOrNull(selectedPolicy) && !$A.util.isUndefinedOrNull(selectedPolicy.resultWrapper) &&
            !$A.util.isUndefinedOrNull(selectedPolicy.resultWrapper.policyRes) &&
            !$A.util.isUndefinedOrNull(selectedPolicy.resultWrapper.policyRes.sourceCode)) {
            sourceCode = selectedPolicy.resultWrapper.policyRes.sourceCode;
            if (!$A.util.isEmpty(sourceCode)) {
                if (sourceCode == 'AP') {
                    caseWrapper.createORSCase = false;
                } else {
                    caseWrapper.createORSCase = true;
                }
            }
            caseWrapper.policyNumber = selectedPolicy.resultWrapper.policyRes.policyNumber;
            caseWrapper.benefitPackage = selectedPolicy.resultWrapper.policyRes.benefitPackageLogNumber;
            caseWrapper.alternateId = selectedPolicy.resultWrapper.policyRes.alternateId;
            helper.setDefaultAutodoc(cmp);
            helper.autodocHelper(cmp);
            //US3068299 - Sravan - Start
            helper.deleteAutoDoc(cmp, event, helper);
            //US3068299 - Sravan - End
            var benefitAutodoc = _autodoc.getAutodoc(cmp.get("v.autodocUniqueId"));
            // Accumalation autodoc
            var autodocSubId = cmp.get("v.autodocUniqueId") + cmp.get("v.policySelectedIndex");
            if (benefitAutodoc != null) {
                benefitAutodoc.forEach(element => {
                    if (element.type == 'table' && !$A.util.isEmpty(element.isAccu) && element.isAccu) {
                        if (element.selectedRows != null && element.selectedRows.length == 0) {
                            element.caseItemsEnabled = false;
                        } else if (element.selectedRows != null && element.selectedRows.length > 0) {
                            element.caseItemsEnabled = true;
                        }                        
                        _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"), autodocSubId, element);
                    }
                    if (element.type == 'card' && !$A.util.isEmpty(element.isAccu) && element.isAccu) {
                        element.caseItemsEnabled = false;
                        if (element.cardData != null && element.cardData.length > 0 && element.cardData[0].checked == true) {
                            // var spTable = _autodoc.getAutodocComponent(cmp.get("v.autodocUniqueId"), cmp.get("v.autodocUniqueIdCmp") + cmp.get("v.policySelectedIndex"), element.supHeadName);
                            // Change - autodoc duplicating
                            var spTable = _autodoc.getAutodocComponent(cmp.get("v.autodocUniqueId"), autodocSubId, element.supHeadName);
                            console.log(JSON.stringify(spTable));
                            if (spTable != null && $A.util.isEmpty(spTable.selectedRows)) {
                                element.caseItemsEnabled = true;
                            } else if ($A.util.isEmpty(spTable)) {
                                element.caseItemsEnabled = true;
                            }
                        }
                        _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"), autodocSubId, element);
                    }
                });
            }
        }
        cmp.set("v.caseWrapper", caseWrapper);
    }
})