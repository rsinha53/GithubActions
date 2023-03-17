({
    onInit: function (cmp, event, helper) {
        // US2405173	Preview Auto Doc Before Save Case- Plan Benefits clearing local storage for autodoc
        localStorage.removeItem(cmp.get("v.AutodocPageFeature"));
        // US2406096 Autodoc for Plan Benefits
        var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
        cmp.set('v.asOfDate', today);
        today = new Date();
        cmp.set("v.btnAutodocId", 'btnAutodoc' + today.getTime());
        // US1814440 Wrap to IBAAG/PASS for E&I - Sarma - 12-02-2020
        var policies = cmp.get('v.policyDetails');
        let uniquePoliciesMap;
        if ($A.util.isUndefinedOrNull(cmp.get('v.UniqueIdMap'))) {
            uniquePoliciesMap = new Map();
        } else {
            uniquePoliciesMap = cmp.get('v.UniqueIdMap');
        }

        if (!$A.util.isUndefinedOrNull(policies) && !$A.util.isUndefinedOrNull(policies.resultWrapper) && !$A.util.isUndefinedOrNull(policies.resultWrapper.policyRes)) {
            let uniqueKey = '';
            uniqueKey = policies.resultWrapper.policyRes.policyNumber + ':' + policies.resultWrapper.policyRes.benefitPackageLogNumber;
            if (!uniquePoliciesMap.has(uniqueKey)) {
                if (policies.resultWrapper.policyRes.isComPlan) {
                    cmp.set('v.btnLabel', 'IBAAG/PASS');
                    cmp.set('v.isComPlan', true);
                    var url = '';
                    if (policies.resultWrapper.policyRes.platform == 'UNET') {
                        var policyno = policies.resultWrapper.policyRes.policyNumber;
                        var setno = policies.resultWrapper.policyRes.benefitPackageLogNumber;
                        setno = setno.replace(/\D/g, ''); // removing non digit vals
                        // US2855779 Wrap to IBAAG/PASS for E&I - Enhancement - 25/08/2020 - Sarma
                        // make sure we are passing only last 3 digits of set no to the URL
                        var lengthOfSetNo = setno.length;
                        var trimmedNumber = setno.substring(lengthOfSetNo - 3);
                        url = $A.get("$Label.c.IBAAG_EI_URL"); //US1814475
                        url = url + '?policy_number=' + policyno + '&set_number=' + trimmedNumber + '&doc_type=t';
                    } else if (policies.resultWrapper.policyRes.platform == 'UNET-PRIME') {
                        if ($A.util.isUndefinedOrNull(cmp.get('v.btnUrl'))) {
                            url = $A.get("$Label.c.PASS_URL");
                        }
                    }
                    cmp.set('v.btnUrl', url);
                    //US1814475	Wrap to IBAAG for M&R - Sarma - 25-03-2020
                } else if (policies.resultWrapper.policyRes.isMedicarePlan) {
                    var url = '';
                    cmp.set('v.btnLabel', 'IBAAG');
                    cmp.set('v.isMedicarePlan', true);
                    var div = policies.resultWrapper.policyRes.cosmosDivision;
                    var bpl = policies.resultWrapper.policyRes.benefitPackageLogNumber;
                    bpl = bpl.replace(/\D/g, '');
                    url = $A.get("$Label.c.IBAAG_MR_URL");
                    url = url + '?div=' + div + '&bpl=' + bpl;
                    cmp.set('v.btnUrl', url);
                    //US1814475 End
                }
                uniquePoliciesMap.set(uniqueKey, url);
                cmp.set('v.UniqueIdMap', uniquePoliciesMap);
            }
        } else {
            if (uniquePoliciesMap.size > 0) {
                cmp.set('v.btnUrl', uniquePoliciesMap.get(uniqueKey));
            }
        }
        var financeData = cmp.get("v.financialsData");
        if (!$A.util.isUndefinedOrNull(financeData)) { //DE318082 - Adding null & Undefine check
            cmp.set("v.yearType", financeData.yearType);
            cmp.set("v.displayYear", financeData.displayYear);
        }

        if (!$A.util.isUndefinedOrNull(financeData) && !$A.util.isUndefinedOrNull(policies) && !$A.util.isUndefinedOrNull(policies.resultWrapper) && !$A.util.isUndefinedOrNull(policies.resultWrapper.policyRes)) {
            var isCdhp = policies.resultWrapper.policyRes.isCdhp;
            var isComPlan = policies.resultWrapper.policyRes.isComPlan;
            var isHsa = policies.resultWrapper.policyRes.isHsa;
            var isHra = financeData.isHra;
            var hraVal = financeData.hraVal;
            cmp.set("v.isCdhp", isCdhp);
            if (isCdhp && isComPlan) {
                if (isHsa) {
                    cmp.set("v.cdhpVal", 'This member has an HSA');
                }
                if (isHra) {
                    cmp.set("v.cdhpVal", 'HRA Balance $' + Number(hraVal).toFixed(2));
                }
            }
        }
        // US1814440 End
        // US2406096 Autodoc for Plan Benefits - Access IBAAG and IBAAG/PASS

        cmp.set("v.AutodocKeyMemberDtl", cmp.get('v.AutodocKey'));
        cmp.set('v.AutodocPageFeatureMemberDtl', cmp.get('v.AutodocPageFeature'));

        // Sanka - US3125207
        if (!$A.util.isUndefinedOrNull(policies) && !$A.util.isUndefinedOrNull(policies.resultWrapper) && !$A.util.isUndefinedOrNull(policies.resultWrapper.policyRes)){
            cmp.set("v.transactionId", policies.resultWrapper.policyRes.transactionId);
        }
        //helper.getBenefitRecords(cmp, event, helper);
    },

    /*Commented as part of US3237437 
    showBenefits: function(cmp, event, helper) {
        try{
            cmp.set("v.isShowBenefitAccordian", true); // US2386351
            //US2672003 - Planbenfits Benfit Details Stacking -  07/03/2020
            if (cmp.get("v.benefitRecordsAccordian") && cmp.get("v.benefitRecordsSelected") && cmp.get("v.benefitRecordsAccordian").length > 0) {
                let nextSelectedRec = cmp.get("v.benefitRecordsSelected").slice(cmp.get("v.benefitRecordsAccordian").length, cmp.get("v.benefitRecordsSelected").length);
                let finallstRecordsToAccordian = nextSelectedRec.concat(cmp.get("v.benefitRecordsAccordian"));
                cmp.set("v.benefitRecordsAccordian", finallstRecordsToAccordian);
            } else {
                cmp.set("v.benefitRecordsAccordian", cmp.get("v.benefitRecordsSelected"));
            }
        }
        catch(exception){
            console.log('=exception '+exception);
        }
        //US2672003 - Planbenfits Benfit Details Stacking -  07/03/2020
        
        
    },*/

    //US2034751	Tech - Benefits: Custom URL For Open Enrollment - 02/10/2019 - Sarma
    openWebPage: function (cmp, event, helper) {
        window.open('https://opendoor.uhc.com', '_blank');
        cmp.set("v.selectedEnrollment", true);
    },

    // US1814440 Wrap to IBAAG/PASS for E&I - Sarma - 12-02-2020
    // US2406096 Autodoc for Plan Benefits - Access IBAAG and IBAAG/PASS (E&I and M&R) & As of Date Update
    navigateToIbaag: function (cmp, event, helper) {
        cmp.set("v.isIbaagBtnClicked", true);
        cmp.set('v.enableAutodocWarningMessage', false);
        var btnAutodocId = cmp.get("v.btnAutodocId");
        //document.getElementById(btnAutodocId).getElementsByTagName('input')[0].checked = true;
        // US2402442: When selecting on New Policy - Refreshing for wrap to IBAAG/PASS
        var btnUrl = cmp.get('v.btnUrl');
        var memberTabId = cmp.get('v.memberTabId');
        var tabUniqueName = memberTabId + btnUrl;
        window.open(btnUrl, tabUniqueName);
    },

    //US2370110 //US2543190 - updating method name
    policyDetailsChanged: function (cmp, event, helper) {
        cmp.set("v.isAutoDocRefresh", 'true');
        cmp.set("v.isIbaagBtnClicked", false);
        cmp.set("v.selectedEnrollment", false);
        cmp.set("v.selectedHSA", false);
        cmp.set("v.selectedCalendarYear", false);
        cmp.set('v.enableAutodocWarningMessage', true);
        // US2449435 Benefit and Coverage Implementation: Benefit Limits (E&I and M&R) - Switching Policies - Sarma - 27-03-2020
        let lstSelectedRecords = [];
        let lstSelectedRecordsToAccordian = [];
        cmp.set("v.isShowBenefitAccordian", false);
        cmp.set("v.lstSelectedRecords", lstSelectedRecords);
        cmp.set("v.lstSelectedRecordsToAccordian", lstSelectedRecordsToAccordian);
        var policies = cmp.get('v.policyDetails');
        cmp.set('v.isComPlan', false);
        cmp.set('v.isMedicarePlan', false); // US2543190
        let uniquePoliciesMap;
        if ($A.util.isUndefinedOrNull(cmp.get('v.UniqueIdMap'))) {
            uniquePoliciesMap = new Map();
        } else {
            uniquePoliciesMap = cmp.get('v.UniqueIdMap');
        }

        if (!$A.util.isUndefinedOrNull(policies.resultWrapper.policyRes)) {
            let uniqueKey = '';
            uniqueKey = policies.resultWrapper.policyRes.policyNumber + ':' + policies.resultWrapper.policyRes.benefitPackageLogNumber;
            if (policies.resultWrapper.policyRes.isComPlan) {
                if (!uniquePoliciesMap.has(uniqueKey)) {
                    cmp.set('v.btnLabel', 'IBAAG/PASS');
                    cmp.set('v.isComPlan', true);
                    var url = '';
                    if (policies.resultWrapper.policyRes.platform == 'UNET') {
                        var policyno = policies.resultWrapper.policyRes.policyNumber;
                        var setno = policies.resultWrapper.policyRes.benefitPackageLogNumber;
                        setno = setno.replace(/\D/g, '');
                        url = $A.get("$Label.c.IBAAG_EI_URL"); //US1814475
                        // US2855779 Wrap to IBAAG/PASS for E&I - Enhancement - 25/08/2020 - Sarma
                        // make sure we are passing only last 3 digits of set no to the URL
                        var lengthOfSetNo = setno.length;
                        var trimmedNumber = setno.substring(lengthOfSetNo - 3);
                        url = url + '?policy_number=' + policyno + '&set_number=' + trimmedNumber + '&doc_type=t';
                    } else if (policies.resultWrapper.policyRes.platform == 'UNET-PRIME') {
                        url = $A.get("$Label.c.PASS_URL");
                    }
                    cmp.set('v.btnUrl', url);
                    uniquePoliciesMap.set(uniqueKey, url);
                    cmp.set('v.UniqueIdMap', uniquePoliciesMap);
                } else {
                    cmp.set('v.isComPlan', true);
                    cmp.set('v.btnUrl', uniquePoliciesMap.get(uniqueKey));
                }
            }

            // US2543190 - Wrap to IBAAG for M&R - Changing Between Policies
            if (policies.resultWrapper.policyRes.isMedicarePlan) {
                var url = '';
                cmp.set('v.btnLabel', 'IBAAG');
                cmp.set('v.isMedicarePlan', true);
                var div = policies.resultWrapper.policyRes.cosmosDivision;
                var bpl = policies.resultWrapper.policyRes.benefitPackageLogNumber;
                bpl = bpl.replace(/\D/g, '');
                url = $A.get("$Label.c.IBAAG_MR_URL");
                url = url + '?div=' + div + '&bpl=' + bpl;
                cmp.set('v.btnUrl', url);
            }
        }
        // CDHP update on policy switch
        var financeData = cmp.get("v.financialsData");
        if (!$A.util.isUndefinedOrNull(financeData)) { //DE318082 - Adding null & Undefine check
            cmp.set("v.yearType", financeData.yearType);
            cmp.set("v.displayYear", financeData.displayYear);
        }

        if (!$A.util.isUndefinedOrNull(financeData) && !$A.util.isUndefinedOrNull(policies) && !$A.util.isUndefinedOrNull(policies.resultWrapper) && !$A.util.isUndefinedOrNull(policies.resultWrapper.policyRes)) {
            var isCdhp = policies.resultWrapper.policyRes.isCdhp;
            var isComPlan = policies.resultWrapper.policyRes.isComPlan;
            var isHsa = policies.resultWrapper.policyRes.isHsa;
            var isHra = financeData.isHra;
            var hraVal = financeData.hraVal;
            cmp.set("v.isCdhp", isCdhp);
            if (isCdhp && isComPlan) {
                if (isHsa) {
                    cmp.set("v.cdhpVal", 'This member has an HSA');
                }
                if (isHra) {
                    cmp.set("v.cdhpVal", 'HRA Balance $' + Number(hraVal).toFixed(2));
                }
            }
        }
        cmp.set("v.isAutoDocRefresh", 'auto');
        helper.setDefaultAutodoc(cmp);
        // Sanka - US3125207
        if (!$A.util.isUndefinedOrNull(policies) && !$A.util.isUndefinedOrNull(policies.resultWrapper) && !$A.util.isUndefinedOrNull(policies.resultWrapper.policyRes)){
            cmp.set("v.transactionId", policies.resultWrapper.policyRes.transactionId);
        }
        //helper.getBenefitRecords(cmp, event, helper);
    },

    // US2386351 - Benefit and Coverage: All Benefit Code Descriptions UI - Sarma - 25/02/2020
    /*onfocus : function(cmp,event,helper){
        // show the spinner,show child search result component and call helper function
        // cmp.set("v.listOfSearchRecords", null );
        cmp.set("v.benefitRecordsFiltered", cmp.get("v.benefitRecords"));
        var forOpen = cmp.find("searchRes");
        $A.util.addClass(forOpen, 'slds-is-open');
        $A.util.removeClass(forOpen, 'slds-is-close');
        // Get Default 5 Records order by createdDate DESC
        var getInputkeyWord = '';
        // helper.searchHelper(cmp,event,getInputkeyWord);
    },
    /*keyPressController : function(cmp, event, helper) {
        
        var getInputkeyWord = cmp.get("v.SearchKeyWord");
        // check if getInputKeyWord size id more then 0 then open the lookup result List and
        // call the helper
        // else close the lookup result List part.
        if(getInputkeyWord.length > 0){
            // var forOpen = cmp.find("searchRes");
            // $A.util.addClass(forOpen, 'slds-is-open');
            // $A.util.removeClass(forOpen, 'slds-is-close');
            // helper.searchHelper(cmp,event,getInputkeyWord);
            var benefitRecords = cmp.get("v.benefitRecords");
            var filtered = benefitRecords.filter(function (benefit) {
                return benefit.categoryName.toUpperCase().includes(getInputkeyWord.toUpperCase());
            });
            cmp.set("v.benefitRecordsFiltered", filtered);
        } else {
            // cmp.set("v.listOfSearchRecords", null );
            cmp.set("v.benefitRecordsFiltered", cmp.get("v.benefitRecords"));
        }
        
    },*/

    // This function call when the end User Select any record from the result list.
    /*handleComponentEvent: function (cmp, event, helper) {
        cmp.set("v.SearchKeyWord", null);
        // get the selected object record from the COMPONENT event
        // var listSelectedItems =  cmp.get("v.lstSelectedRecords");
        var listSelectedItems = cmp.get("v.benefitRecordsSelected");
        var selectedAccountGetFromEvent = event.getParam("recordByEvent");
        var ctrlPressed = event.getParam("ctrlPressed");
        listSelectedItems.push(selectedAccountGetFromEvent);
        cmp.set("v.benefitRecordsSelected", listSelectedItems);
        var forclose = cmp.find("lookup-pill");
        $A.util.addClass(forclose, 'slds-show');
        $A.util.removeClass(forclose, 'slds-hide');
        cmp.set("v.benefitRecordsFiltered", cmp.get("v.benefitRecords"));
        setTimeout(function () {
            cmp.find("callTopicId").focus();
        }, 1000);
    },*/

    // function for clear the Record Selaction
    /*clear :function(cmp,event,helper){
        var selectedPillId = event.getSource().get("v.name");
        // var AllPillsList = cmp.get("v.lstSelectedRecords");
        // let selectedRecinAccordian = cmp.get("v.lstSelectedRecordsToAccordian");
        var AllPillsList = cmp.get("v.benefitRecordsSelected");
        let selectedRecinAccordian = cmp.get("v.benefitRecordsAccordian");
        
        for(var i = 0; i < AllPillsList.length; i++){
            if (AllPillsList[i].benefitId == selectedPillId) {
                AllPillsList.splice(i, 1);
                cmp.set("v.benefitRecordsSelected", AllPillsList);
            }
        }
        //US2672003 - Planbenfits Benfit Details Stacking -  07/03/2020
        for(var i = 0; i < selectedRecinAccordian.length; i++){
            if (selectedRecinAccordian[i].benefitId == selectedPillId) {
                selectedRecinAccordian.splice(i, 1);
                cmp.set("v.benefitRecordsAccordian", selectedRecinAccordian);
            }
        }
        
        cmp.set("v.SearchKeyWord", '');
        // To refresh the list
        cmp.set("v.benefitRecordsFiltered", []);
        cmp.set("v.benefitRecordsFiltered", cmp.get("v.benefitRecords"));
        // cmp.set("v.listOfSearchRecords", null);
    },*/
    /*onblur : function(cmp,event,helper){
        // on mouse leave clear the listOfSeachRecords & hide the search result component
        cmp.set("v.listOfSearchRecords", null );
        cmp.set("v.SearchKeyWord", '');
        var forclose = cmp.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
    },*/
    /*handleItemRemove: function (cmp, event) {
        var name = event.getParam("item").name;
        
        // Remove the pill from view
        var items = cmp.get('v.items');
        var item = event.getParam("index");
        items.splice(item, 1);
        cmp.set('v.items', items);
    },*/

    /*disableTopic : function(cmp,event,helper){
        var disableTopicBtn = event.getParam("isDisableTopic");
        cmp.set("v.isDisableTopic",disableTopicBtn)
        
    },*/

    // US3505126: Remove  Auto Doc Buttons: & Save Case - Krish - 19th May 2021
    /*
    // US2108659 - Case Creation - Plan Benefits - Sarma - 27-02-2020
    openModal: function (cmp, event, helper) {
        // US2618180
        var autoDocKey = cmp.get("v.AutodocPageFeature");
        var tabKey = cmp.get("v.AutodocKey");
        // US2442658
        cmp.set("v.AutodocKeyMemberDtl", cmp.get('v.AutodocKey')); // component.get("v.AutodocKey")
        cmp.set('v.AutodocPageFeatureMemberDtl', cmp.get('v.AutodocPageFeature'));
        // US2098648 - Sanka
        var caseWrapper = cmp.get('v.caseWrapper');
        var selectedPolicy = cmp.get('v.policyDetails');
        var sourceCode = '';
        if (!$A.util.isUndefinedOrNull(selectedPolicy) && !$A.util.isUndefinedOrNull(selectedPolicy.resultWrapper) &&
            !$A.util.isUndefinedOrNull(selectedPolicy.resultWrapper.policyRes) &&
            !$A.util.isUndefinedOrNull(selectedPolicy.resultWrapper.policyRes.sourceCode)) {
            sourceCode = selectedPolicy.resultWrapper.policyRes.sourceCode;
            if (!$A.util.isEmpty(sourceCode)) {
                if (sourceCode == 'AP') {
                    // if C&S member, no ORS case will be created
                    caseWrapper.createORSCase = false;
                } else {
                    // if other than C&S member, ORS case will be created
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
            if(benefitAutodoc != null){
                benefitAutodoc.forEach(element => {
                    if(element.type == 'table' && !$A.util.isEmpty(element.isAccu) && element.isAccu){
                        if(element.selectedRows != null && element.selectedRows.length == 0){
                            element.caseItemsEnabled = false;
                        }else if(element.selectedRows != null && element.selectedRows.length > 0){
                            element.caseItemsEnabled = true;
                        }
                    }
                    if(element.type == 'card' && !$A.util.isEmpty(element.isAccu) && element.isAccu){
                        element.caseItemsEnabled = false;
                        if(element.cardData != null && element.cardData.length > 0 && element.cardData[0].checked == true){
                            var spTable = _autodoc.getAutodocComponent(cmp.get("v.autodocUniqueId"), cmp.get("v.autodocUniqueIdCmp")+cmp.get("v.policySelectedIndex"),element.supHeadName);
                            console.log(JSON.stringify(spTable));
                            if(spTable!= null && $A.util.isEmpty(spTable.selectedRows)){
                                element.caseItemsEnabled = true;
                            }else if($A.util.isEmpty(spTable)){
                                element.caseItemsEnabled = true;
                            }
                        }
                    }
                });
            }
            // End
            var jsString = JSON.stringify(benefitAutodoc);
            caseWrapper.savedAutodoc = jsString;
        }
        cmp.set("v.caseWrapper", caseWrapper);
        // End
        // Set isModalOpen attribute to true
        cmp.set("v.isModalOpen", true);
    },

    closeModal: function (cmp, event, helper) {
        // Set isModalOpen attribute to false
        cmp.set("v.isModalOpen", false);
    }, */

    // US3505126: Remove  Auto Doc Buttons: & Save Case - Krish - 19th May 2021
    /*
    openPreview: function (cmp, event, helper) {
        helper.setDefaultAutodoc(cmp);
        helper.autodocHelper(cmp);
        //US3068299 - Sravan - Start
        helper.deleteAutoDoc(cmp, event, helper);
        //US3068299 - Sravan - End
        var benefitAutodoc = _autodoc.getAutodoc(cmp.get("v.autodocUniqueId"));
        cmp.set("v.tableDetails_prev", benefitAutodoc);
        cmp.set("v.showpreview", true);
    },

    openCommentsBox: function (cmp, event, helper) {
        cmp.set("v.isCommentsBox", true);
        cmp.set("v.disableCommentButton", true);
    }, */

    togglePopup: function (cmp, event) {
        let showPopup = event.currentTarget.getAttribute("data-popupId");
        cmp.find(showPopup).toggleVisibility();
    },

    handleKeyup: function (cmp) {
        var inputCmp = cmp.find("commentsBoxId");
        var value = inputCmp.get("v.value");
        var max = 2000;
        var remaining = max - value.length;
        cmp.set('v.charsRemaining', remaining);
        var errorMessage = 'Error!  You have reached the maximum character limit.  Add additional comments in Case Details as a new case comment.';
        if (value.length >= 2000) {
            inputCmp.setCustomValidity(errorMessage);
            inputCmp.reportValidity();
        } else {
            inputCmp.setCustomValidity('');
            inputCmp.reportValidity();
        }
    },

    // US2718114 - Thanish - 2nd Jul 2020
    handleACETCaseCreated: function (cmp) {
        var caseNotSavedTopics = cmp.get("v.caseNotSavedTopics");
        var index = caseNotSavedTopics.indexOf("Plan Benefits");
        if (index >= 0) {
            caseNotSavedTopics.splice(index, 1);
        }
        cmp.set("v.caseNotSavedTopics", caseNotSavedTopics);
        cmp.set("v.isIbaagBtnClicked", false);
        cmp.set("v.selectedEnrollment", false);
        cmp.set("v.selectedHSA", false);
        cmp.set("v.selectedCalendarYear", false);
    },
    
    handleAutodocRefresh: function (cmp, event) {
        if(event.getParam("autodocUniqueId") == cmp.get("v.autodocUniqueId")){
            var caseNotSavedTopics = cmp.get("v.caseNotSavedTopics");
            var index = caseNotSavedTopics.indexOf("Plan Benefits");
            if (index >= 0) {
                caseNotSavedTopics.splice(index, 1);
            }
            cmp.set("v.caseNotSavedTopics", caseNotSavedTopics);
            cmp.set("v.isIbaagBtnClicked", false);
            cmp.set("v.selectedEnrollment", false);
            cmp.set("v.selectedHSA", false);
            cmp.set("v.selectedCalendarYear", false);
        }
    },

    // Thanish - Commented as benefit related changes as it will be pushed to prod later - 20th Nov 2020
    // PLEASE DO NOT REMOVE THIS CODE
    // onRadioBtnSelect : function(cmp, event) {
    //     cmp.set("v.selectedRadioBtnValue", event.currentTarget.getAttribute("data-value"));
    // },

    // US2974811	Plan Benefits: Benefit Check with PA Button & PA Search Page UI - Sarma - 02/12/2020
    openPaCheck: function (cmp, event) {
        // US3089172	Plan Benefits: Benefit Check with PA Button Search DataPopulation - Sarma - 16/12/2020
        let memberInfo = {
            "memberId": "--",
            "memberPlan": '--',
            "memberName": "--",
            "relationshipType": "--",
            "relationshipCode": "--",
            "sourceCode":"--",
            "EEID" : "--",
            "firstServiceDate": "--",
            "lastServiceDate": "--",
            "firstName":"--"

        }
        let memberCardData = cmp.get('v.memberCardData');
        let policyDetails = cmp.get('v.policyDetails');
        let policySelectedIndex = cmp.get('v.policySelectedIndex');
        if (!$A.util.isUndefinedOrNull(memberCardData) && !$A.util.isUndefinedOrNull(memberCardData.CoverageLines) && memberCardData.CoverageLines.length > 0) {
            if (!$A.util.isUndefinedOrNull(memberCardData.CoverageLines[policySelectedIndex].GroupNumber)) {
                memberInfo.memberPlan = memberCardData.CoverageLines[policySelectedIndex].GroupNumber;
            }
            if (!$A.util.isUndefinedOrNull(memberCardData.CoverageLines[policySelectedIndex].eligibleDates)) {
                var datesArray  = memberCardData.CoverageLines[policySelectedIndex].eligibleDates.split("-");
                var startDate = datesArray[0].trim().split('/');
                var endDate = datesArray[1].trim().split('/');
                memberInfo.firstServiceDate = startDate[2] + '-' + startDate[0] + '-' + startDate[1];
                memberInfo.lastServiceDate = endDate[2] + '-' + endDate[0] + '-' + endDate[1];
            }

            if (!$A.util.isUndefinedOrNull(memberCardData.CoverageLines[policySelectedIndex].patientInfo)) {
                let patientInfo = memberCardData.CoverageLines[policySelectedIndex].patientInfo;
                if (!$A.util.isUndefinedOrNull(patientInfo.MemberId)) {
                    memberInfo.memberId = patientInfo.MemberId;
                }
                if (!$A.util.isUndefinedOrNull(patientInfo.fullName)) {
                    memberInfo.memberName = patientInfo.fullName;
                }
                if (!$A.util.isUndefinedOrNull(patientInfo.firstName)) {
                    memberInfo.firstName = patientInfo.firstName;
                }
                if (!$A.util.isUndefinedOrNull(patientInfo.relationship)) {
                    memberInfo.relationshipType = patientInfo.relationship;
                }
            }
        }
        if ( !$A.util.isUndefinedOrNull(policyDetails) && !$A.util.isUndefinedOrNull(policyDetails.resultWrapper)
            && !$A.util.isUndefinedOrNull(policyDetails.resultWrapper.policyRes) ){
            var sourceCode = policyDetails.resultWrapper.policyRes.sourceCode;
            var EEID = policyDetails.resultWrapper.policyRes.EEID;
            var relCode = policyDetails.resultWrapper.policyRes.relationshipCode;
            if(!$A.util.isUndefinedOrNull(sourceCode) && !$A.util.isEmpty(sourceCode) ){
                 memberInfo.sourceCode = sourceCode;
            }
           if(!$A.util.isUndefinedOrNull(EEID) && !$A.util.isEmpty(EEID) ){
                 memberInfo.EEID = EEID;
            }
             if(!$A.util.isUndefinedOrNull(relCode) && !$A.util.isEmpty(relCode) ){
                 memberInfo.relationshipCode = relCode;
            }
        }
        let workspaceAPI = cmp.find("workspace");
        //getting focused tab id
        var snapId;
        workspaceAPI.getFocusedTabInfo().then(function (response) {
            snapId = response.tabId;
        });
        workspaceAPI.openSubtab({
            pageReference: {
                "type": "standard__component",
                "attributes": {
                    "componentName": "c__ACET_PaCheckContainer"
                },
                "state": {
                    "c__interactionOverviewTabId": cmp.get('v.interactionOverviewTabId'),
                    "c__memberInfo": memberInfo,
                    "c__autodocUniqueId": cmp.get('v.autodocUniqueId'), // US2828663
                    "c__autodocUniqueIdCmp": cmp.get('v.autodocUniqueIdCmp'), // US2828663
                    "c__memberTabId": cmp.get('v.memberTabId'), // US3089189
                    "c__memberCardSnap": cmp.get('v.memberCardSnap'), // US3089189
                    "c__policySelectedIndex": cmp.get('v.policySelectedIndex'),
                    "c__caseWrapper": cmp.get('v.caseWrapper'),
                    "c__currentTabId": cmp.get('v.currentTabId'), // DE456362
                    "c__delegationValue": cmp.get("v.delegationValue"), //US3584404
                    "c__patientInfo": cmp.get("v.patientInfo") //US3584404
                }
            },
            focus: true
        }).then(function (response) {
            // US3089189
            _setAndGetSessionValues.settingValue(response, snapId);
            workspaceAPI.setTabLabel({
                tabId: response,
                label: 'Benefit/PA Check'
            });
            workspaceAPI.setTabIcon({
                tabId: response,
                icon: "standard:task2",
                iconAlt: "Benefit/PA Check"
            });
        }).catch(function (error) {});
    },

    // US3125215 - Thanish - 22nd Dec 2020
    onBenefitSearch: function (cmp, event, helper) {
        var searchField = cmp.find("searchField");
        var searchPhrase = searchField.get("v.value").trim();
        if (!$A.util.isEmpty(searchPhrase)) {
            helper.getBenefitSearchresults(cmp, searchPhrase);
        }
        searchField.set("v.value", "");
    },
    // US3351083: Plan Benefits: Launch Benefit - Enter Key - Krish - 4/6/2021
     onClickOfEnter: function(cmp, event, helper){
        if (event.keyCode === 13) {
            var action = cmp.get('c.onBenefitSearch');
            $A.enqueueAction(action);
        }
    },
    // US3507751 - Save Case Consolidation
    createCaseWrapper: function (cmp, event, helper) {
        var autodocUniqueId = event.getParam("autodocUniqueId");
        console.log('%cFrom Event' + autodocUniqueId, 'color:red');
        if(autodocUniqueId == cmp.get("v.autodocUniqueId")){
            helper.caseWrapperHelper(cmp, event, helper);
        }        
    }
})