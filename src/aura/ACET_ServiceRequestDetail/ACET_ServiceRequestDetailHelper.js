({
    openServiceRequestDetail: function(cmp, event, helper, orsId, issueType) {
        let openedTabs = cmp.get("v.openedTabs");
        console.log(JSON.stringify(openedTabs));
        openedTabs.push(orsId);
        cmp.set("v.openedTabs", openedTabs);
        $A.util.addClass(event.currentTarget, orsId);
        $A.util.addClass(event.currentTarget, "disableLink");
        if (issueType == "ORS") {
            this.openORSDetail(cmp, event, orsId, issueType);
        } else {
            this.openClaimDetail(cmp, event, orsId, issueType);
        }
    },

    openClaimDetail: function(cmp, event, orsId, issueType) {
        var workspaceAPI = cmp.find("workspace");
        workspaceAPI.getEnclosingTabId().then(function (enclosingTabId) {
            workspaceAPI.openSubtab({
                parentTabId: enclosingTabId,
                pageReference: {
                    "type": "standard__component",
                    "attributes": {
                        "componentName": "c__ACET_ClaimServiceRequestDetail"
                    },
                    "state": {
                        "c__issueId": orsId,
                        "c__issueType": issueType,
                        "c__taxId": cmp.get("v.issueDetails.externalIdDetails.origTaxId"),
                        "c__parentUniqueId": cmp.get("v.cmpUniqueId"),
                        "c__recordId": cmp.get("v.recordId")
                    }
                },
                focus: true
            }).then(function (subtabId) {
                workspaceAPI.setTabLabel({
                    tabId: subtabId,
                    label: orsId
                });
                workspaceAPI.setTabIcon({
                    tabId: subtabId,
                    icon: "action:record",
                    iconAlt: "Service Request Detail"
                });
            }).catch(function (error) {
                console.log(error);
            });
        });
    },

    openORSDetail: function(cmp, event, orsId, issueType) {
        var workspaceAPI = cmp.find("workspace");
        workspaceAPI.getEnclosingTabId().then(function (enclosingTabId) {
            workspaceAPI.openSubtab({
                parentTabId: enclosingTabId,
                pageReference: {
                    "type": "standard__component",
                    "attributes": {
                        "componentName": "c__ACET_ServiceRequestDetail"
                    },
                    "state": {
                        "c__caseId": orsId,
                        "c__parentUniqueId": cmp.get("v.cmpUniqueId"),
                        "c__sfCaseId": cmp.get("v.recordId"),
                        "c__isFacetsDataPresent": false,
                        "c__facetsResponse": null,
                        "c__recordId": cmp.get("v.recordId"),
                        "c__idType": issueType
                    }
                },
                focus: true
            }).then(function (subtabId) {
                workspaceAPI.setTabLabel({
                    tabId: subtabId,
                    label: orsId
                });
                workspaceAPI.setTabIcon({
                    tabId: subtabId,
                    icon: "action:record",
                    iconAlt: "Service Request Detail"
                });
            }).catch(function (error) {
                console.log(error);
            });
        });
    },

    getClaimRelatedRecords: function (cmp, event, helper, claimId) {
        var action = cmp.get("c.getClaimIssues");
        action.setParams({
            "claimNumber": claimId,
            "taxId": cmp.get("v.issueDetails.externalIdDetails.origTaxId"),
            "issueId": cmp.get("v.caseId")
        });
        action.setCallback(this, function (response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                if(!$A.util.isEmpty(result)) {
                    cmp.set("v.externalIdRecs", result);
                    // US3480373: Service Request Detail Page Alignment - Krish - 5 May 2021
                    cmp.set("v.filteredExternalIdRecs", result);
                } else {
                    cmp.set("v.externalIdRecs", cmp.get("v.externalIdRecs"));
                    cmp.set("v.filteredExternalIdRecs", cmp.get("v.filteredExternalIdRecs"));
                }
            } else {
                cmp.set("v.externalIdRecs", cmp.get("v.externalIdRecs"));
                cmp.set("v.filteredExternalIdRecs", cmp.get("v.filteredExternalIdRecs"));
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +
                            errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
                this.fireToastMessage("Unexpected error occured. Please try again. If problem persists, contact help desk.");
            }
            cmp.set("v.isExternalIdsLoaded", true);
        });
        $A.enqueueAction(action);
    },

    getORSIssueDetails: function (cmp, event, helper, strIdType) {
		var commentskey = [
            			", ISSUE-", "CONTACT NUMBER-", "HOURS OF OPERATION-", "PAYMENT #-", "CLAIM #-",
            			"SERVICE DATES-", "PAY LOC/ENGINE-", "FLN/DCC-", "PROVIDER STATUS-", "BENEFIT LEVEL-", "EXPECTED ALLOWED $-", 
            			" , REASON", "CHECK #-", "DATE CHECK SENT-", "OVERPAYMENT REASON GIVEN-",
            			"REASON FOR REVIEW BEING REQUESTED-", "ORIGINAL CLAIM/FLN #-", "CORRECTED CLAIM/FLN #-",
            			"RECEIVED DATE-", "TFL DATE-", "UHC ERROR-", "FLN #-", "MATCHING REFERRAL-",
            			"CHARGED-", "UNDER $ 7,000?-", "PAE CRITERIA MET-", "SOURCE-",
            			"MISQUOTED INFORMATION-", "RECEIVED DATE OF FLN-", "LAST UPDATED DATE-", "PROCESSED DATE-",
            			"MATCHING SRN-", "TYPE-", "CASHED-","CASHED AMOUNT-", "CHECK DATE-","CASHED DATE-", "COVERAGE LEVEL-", "ELIGIBILITY DATES-", "METHOD OF DELIVERY-",
            			"FIRST NAME-", "LAST NAME-", "ADDRESS-", "CITY-", "STATE-", "ZIP CODE-", "FAX-", "IS THIS AN ESCALATED REQUEST?-",
            			"ESCALATION REASON-","PRIOR EXTERNAL ID'\S-", "EXPECTED PAYMENT AMOUNT-", "TAT PROVIDED-",
            			"EXTERNAL ID-","-I ATTEST", "ISSUE- ","PROVIDER NAME- ","TIN- ","MPIN AND SUFFIX- ",
            			"NPI- ","SPECIALTY- ", "State- "
        ];
        let action = cmp.get("c.getORSIssueDetails");
        action.setParams({
            "issueId" : cmp.get("v.caseId"),
            "strIdType" : strIdType,
            "caseId" : cmp.get("v.recordId")
        });

        action.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {

                // US2667560 - ORS ReadIssue Error Handling - Sanka
                var success = response.getReturnValue().success;
                var userTimeZone = response.getReturnValue().userTimeZone;
                var extORSFacetsTimeZone = response.getReturnValue().extORSFacetsTimeZone;
                if (success) {
                    var claimServiceDate = response.getReturnValue().externalIdDetails.claimServiceDate;
                    if(!$A.util.isUndefinedOrNull(claimServiceDate) && !$A.util.isEmpty(claimServiceDate)){
                        var claimServiceDate = claimServiceDate;
                        var ServiceDate = [];
                        ServiceDate = claimServiceDate.split('-');
                        var servicedate = ServiceDate[1]+'/'+ServiceDate[2]+'/'+ServiceDate[0];
                        console.log('before@@@@@@'+servicedate);
                        response.getReturnValue().externalIdDetails.claimServiceDate = servicedate;
                    }
                    var surveycodeMap = cmp.get('v.surveyMap');
                    var surveyCode = response.getReturnValue().externalIdDetails.surveyCode;
                    if(surveyCode && surveycodeMap.hasOwnProperty(surveyCode)){
                        cmp.set('v.surveyHover',surveycodeMap[surveyCode]);
                    }
                    cmp.set("v.issueDetails", response.getReturnValue());
                    // US3480373: Service Request Detail Page Alignment - Krish - 5 May 2021
                    cmp.set('v.providerId', cmp.get('v.issueDetails.externalIdDetails.origMPIN'));
                    cmp.set('v.taxId', cmp.get('v.issueDetails.externalIdDetails.origTaxId'));
                    console.log('Issue Details: '+JSON.stringify(response.getReturnValue()));
                    var claimId = response.getReturnValue().externalIdDetails.claimNumber;
                    if (claimId == "0000000000" || claimId == "" || claimId == "--") {
                        cmp.set("v.isExternalIdsLoaded", true);
                    } else {
                        cmp.set("v.claimNumber", claimId);
                    }
                    //Formatting datetime field
                    let formattedHistoryList = response.getReturnValue().historyList;
                    //console.log('apexResponse: '+JSON.stringify(response.getReturnValue()));
                    var claimNumber = response.getReturnValue().externalIdDetails.claimNumber;
                    //console.log('claimNumber: '+JSON.stringify(response.getReturnValue().externalIdDetails.claimNumber));
                    //console.log('formattedHistoryList: '+JSON.stringify(formattedHistoryList));
                    for (var i = 0; i < formattedHistoryList.length; i++) {
                        //formattedHistoryList[i].dateAndTime = $A.localizationService.formatDate(formattedHistoryList[i].dateAndTime, "MM/dd/yyyy hh:mm a");
                        formattedHistoryList[i].dateAndTime = this.convertDateTimeToUserTimeZone(formattedHistoryList[i].dateAndTime,extORSFacetsTimeZone,userTimeZone);
						if(formattedHistoryList[i].addedBy!='SYSTEM'){
                            for(var j = 0; j< commentskey.length; j++){
                                if(formattedHistoryList[i].comments.includes(commentskey[j])){
                                	formattedHistoryList[i].comments= formattedHistoryList[i].comments.replaceAll(commentskey[j],'\n'+commentskey[j]);
                                    formattedHistoryList[i].comments=formattedHistoryList[i].comments.replace(' , REASON-','\n'+"REASON-");
									formattedHistoryList[i].comments=formattedHistoryList[i].comments.replace(' , IS THIS AN ESCALATE  D REQUEST?-','\n'+"IS THIS AN ESCALATE  D REQUEST-");
                                    formattedHistoryList[i].comments=formattedHistoryList[i].comments.replace(' , IS THIS AN   ESCALATED REQUEST?-','\n'+"IS THIS AN ESCALATED REQUEST-");
                                    formattedHistoryList[i].comments=formattedHistoryList[i].comments.replace('E  SCALATION REASON-','\n'+"ESCALATION REASON-");
                                    formattedHistoryList[i].comments=formattedHistoryList[i].comments.replace('FLN/D  CC-','\n'+"FLN/DCC-");
									formattedHistoryList[i].comments=formattedHistoryList[i].comments.replace('EXPE  CTED PAYMENT AMOUNT-','\n'+"EXPECTED PAYMENT AMOUNT-");
                                    formattedHistoryList[i].comments=formattedHistoryList[i].comments.replace('ESCA  LATION REASON-','\n'+"ESCLATION REASON-");
                                    formattedHistoryList[i].comments= formattedHistoryList[i].comments.replace(/ ,/g,"");
                                    formattedHistoryList[i].comments=formattedHistoryList[i].comments.replace(', ISSUE-',"ISSUE-");
									formattedHistoryList[i].comments=formattedHistoryList[i].comments.replace('EXPECTED PAYMENT AMOU  NT-',"EXPECTED PAYMENT AMOUNT-");
                                    formattedHistoryList[i].comments=formattedHistoryList[i].comments.replace('EXPECT    ED PAYMENT AMOUNT-',"EXPECTED PAYMENT AMOUNT-");
                                    formattedHistoryList[i].comments=formattedHistoryList[i].comments.replace('C ASHED AMOUNT-',"CASHED AMOUNT-");
                                    formattedHistoryList[i].comments=formattedHistoryList[i].comments.replace('NULL,',"");
                                    formattedHistoryList[i].comments=formattedHistoryList[i].comments.replace('NULLNULLNULL, ',"");
                                    formattedHistoryList[i].comments=formattedHistoryList[i].comments.replace('NULL',"");
                                }
                            }
                            formattedHistoryList[i].comments= formattedHistoryList[i].comments.replace(/^(?=\n)$|^\s*|\s*$|\n\n+/gm, "");
                        }																				 
                    }
                    // sorting the history table according to date and time on load ...
                    let filteredHistoryList = this.sortObjectList(formattedHistoryList, "dateAndTime", "des");
                    if(claimNumber==''){
                    	helper.formatHistory(cmp, filteredHistoryList);
                    }else{
                        cmp.set("v.filteredHistoryList", filteredHistoryList);
                    }

                    cmp.set("v.sortingIcon", "utility:arrowdown");
                    //cmp.set("v.filteredHistoryList", filteredHistoryList);
                    cmp.set("v.historySortColumn", "dateAndTime");
                } else {
                    this.fireToastMessage(response.getReturnValue().errorMessage);
                }

            } else {
                let errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
            cmp.set("v.isIssueDetailsLoaded", true);
            // US3480373: Service Request Detail Page Alignment - Krish - 5 May 2021
            cmp.find('alertsAI').getAlertsOnServiceRequestDetail();
        });
        $A.enqueueAction(action);
    },

    sortObjectList : function(dataList, sortingProperty, sortOrder) {

        dataList.sort(function(a, b) {
            if(a[sortingProperty] < b[sortingProperty]) {
                if(sortOrder == "asc") {
                    return -1;
                } else {
                    return 1;
                }
            } else if(a[sortingProperty] > b[sortingProperty]) {
                if(sortOrder == "asc") {
                    return 1;
                } else {
                    return -1;
                }
            } else {
                return 0;
            }
        });

        return dataList;
    },

    filter : function(cmp, unfilteredList) {
        let searchText = cmp.find("searchBox").get("v.value").toLowerCase().trim();

        if($A.util.isEmpty(searchText)) {
            return unfilteredList;
        } else {
            let filteredData = unfilteredList.filter(function (obj) {
                // get all attributes of the object as string, convert to lowercase and then filter
                return 	JSON.stringify(Object.values(obj)).toLowerCase().includes(searchText);
            });
            return filteredData;
        }
    },
    insertFacetsComments: function(cmp,event,helper){
        cmp.set("v.isIssueDetailsLoaded", false);
        var action = cmp.get("c.insertFacetsComments");
        action.setParams({
            comment: cmp.get("v.commentsValue"),
            facetId: cmp.get("v.caseId")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                var response = response.getReturnValue();
                if(response.statusCode != 204 ){
                    this.fireToastMessage(response.Message);
                }
                else{
                    cmp.set("v.RefereshTab",!cmp.get("v.RefereshTab"));
                }
            } else {
                this.fireToastMessage("Unexpected error occured. Please try again. If problem persists contact help desk.");
            }
            cmp.set("v.isIssueDetailsLoaded", true);
        });
        $A.enqueueAction(action);
    },

    insertOnlyORSComments : function(component,event,helper){
        component.set("v.isIssueDetailsLoaded", false);
        var action = component.get("c.updateOnlyORSCaseComments");

        var contactmethod = '';
        var originatoryTypeCode = '';
        var originatorName = '';
        var isuseDetails = component.get("v.issueDetails");
        if(!$A.util.isUndefinedOrNull(isuseDetails) &&  !$A.util.isUndefinedOrNull(isuseDetails.externalIdDetails))
        {
            if(!$A.util.isUndefinedOrNull(isuseDetails.externalIdDetails.additionalInfo)){
                if(!$A.util.isUndefinedOrNull(isuseDetails.externalIdDetails.additionalInfo.contactMethodCode)){
                    contactmethod = isuseDetails.externalIdDetails.additionalInfo.contactMethodCode;
                }
                if(!$A.util.isUndefinedOrNull(isuseDetails.externalIdDetails.additionalInfo.originatorTypeCode)){
                    originatoryTypeCode = isuseDetails.externalIdDetails.additionalInfo.originatorTypeCode;
                }
            }
            if(!$A.util.isUndefinedOrNull(isuseDetails.externalIdDetails.origName)){
                originatorName = isuseDetails.externalIdDetails.origName;
            }

        }
        action.setParams({
            ORSCaseId: component.get("v.caseId"),
            comment: component.get("v.commentsValue"),
            contactMethod : contactmethod,
            originatoryTypeCode :originatoryTypeCode,
            originatorName : originatorName
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            // US2101461 - Thanish - 23rd Jun 2020 - Error Code Handling ...
            if(state === "SUCCESS") {
                var responseList = response.getReturnValue();
                if(responseList.length > 0) {
                    if(responseList[0].responseStatus != 201 && responseList[0].responseStatus != 200){
                        this.fireToastMessage(responseList[0].responseStatusMessage);
                    }
                    else{
                        component.set("v.RefereshTab",!component.get("v.RefereshTab"));
                    }
                }
            } else {
                this.fireToastMessage("Unexpected error occured. Please try again. If problem persists contact help desk.");
            }
            component.set("v.isIssueDetailsLoaded", true);
        });
        $A.enqueueAction(action);
    },

    insertCaseCommentsWithSF : function(component,event,helper){
         component.set("v.isIssueDetailsLoaded", false);
          var action = component.get("c.insertCaseComments");
        action.setParams({
            caseId: component.get("v.sfCaseId"),
            caseComment: component.get("v.commentsValue"),
            isPublic: false
        });

        action.setCallback(this, function (response) {
            var state = response.getState();

            if (state === "SUCCESS") {
                component.set("v.isIssueDetailsLoaded", true);
                //US3183026
                /*var feedback = response.getReturnValue();
                if (feedback.success) {
                    var action = component.get("c.updateORSCaseComments");
                    action.setParams({
                        caseId: component.get("v.sfCaseId"),
                        comment: component.get("v.commentsValue")
                    });
                    action.setCallback(this, function (response) {
                        var state = response.getState();
                        // US2101461 - Thanish - 23rd Jun 2020 - Error Code Handling ...
                        if(state === "SUCCESS") {
                            var responseList = response.getReturnValue();
                            if(responseList.length > 0) {
                                if(responseList[0].responseStatus != 201  && responseList[0].responseStatus != 200){
                                    this.fireToastMessage(responseList[0].responseStatusMessage);
                                }
                                else{
                                    component.set("v.RefereshTab",!component.get("v.RefereshTab"));
                                }
                            }
                        } else {
                            this.fireToastMessage("Unexpected error occured. Please try again. If problem persists contact help desk.");
                        }
                       component.set("v.isIssueDetailsLoaded", true);
                    });
                    $A.enqueueAction(action);
                }else{
                   component.set("v.isIssueDetailsLoaded", true);
                    this.fireToastMessage(feedback.message);
                }*/

            } else if (state === "INCOMPLETE") {
                component.set("v.isIssueDetailsLoaded", true);
                // do something

            } else if (state === "ERROR") {
                component.set("v.isIssueDetailsLoaded", true);
                var errors = response.getError();

                if (errors) {

                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +
                            errors[0].message);
                    }

                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },

    fireToastMessage: function (message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "",
            "message": message,
            "type": "error",
            "mode": "pesky",
            "duration": "10000"
        });
        toastEvent.fire();
    },

    convertDateTimeToUserTimeZone: function (dateTimeToConvert,inputTimeZone,outputTimeZone) {
        var dttocon = dateTimeToConvert;
        var res = dttocon.split("/");
        var adateval = res[0];
        var atimeval = res[1];
        var datearray = adateval.split("-");
        var timearray = atimeval.split(":");
        var dttoconstr = res[0]+" "+res[1];
        var dt = new Date(dttoconstr);
        var datetimetemp;
        $A.localizationService.WallTimeToUTC(dt, inputTimeZone, function(walltime) {
            datetimetemp = $A.localizationService.formatDate(walltime, "yyyy-MM-dd HH:mm:ss");
        });
        var dtoutput = new Date(datetimetemp);
        var displayValue;
        $A.localizationService.UTCToWallTime(dtoutput, outputTimeZone, function(walltime) {
            displayValue = $A.localizationService.formatDate(walltime, "MM/dd/yyyy h:mm a");
        })
        return displayValue;
    },

     formatHistory : function(cmp, lstData) {
         try {
             let lstComments, caseData = [], strData = '',lstExternalData = [], lstDateTime = [],
                 issueStartedWith = 0, lstEnteredComments = [],
                 strFormattedComment = '', externalIDStartedWith = 0, strExternalId;
             if(lstData && lstData[2] && lstData[2]['comments']) {
                 lstComments = lstData[2]['comments'].split('\n');
                 var i;

                 for (i = 0; i < lstComments.length; i++) {
                     if(lstComments[i].startsWith('ISSUE')){
                         issueStartedWith = i;
                     }

                     if(lstComments[i].startsWith('EXTERNAL')){
                         externalIDStartedWith = i;
                     }
                 }

                 for (i = 0; i < lstComments.length; i++) {
                     if( i == 0) {
                        caseData.push(lstComments[i]);
                     } else {
                         if(lstComments[i].startsWith('ISSUE')){
                             strData = strData + '...' + lstComments[i];
                         } else if( i >= externalIDStartedWith && externalIDStartedWith < (lstComments.length - 2)) {
                             lstExternalData.push(lstComments[i]);
                         } else if(i == (lstComments.length - 1)){
                             // Do Nothing
                         } else if(i == (lstComments.length - 2)) {
                             lstDateTime.push(lstComments[i]);
                         } else if(i != 0 && i <= issueStartedWith ) {
                             lstEnteredComments.push(lstComments[i])
                         } else {
                             strData = strData + '...' + lstComments[i];
                         }
                     }
                 }
             }
             strFormattedComment = caseData.join('\n') + '\n' + lstEnteredComments.join('\n') + '\n' + strData.replaceAll('...','').split(',').join('\n') + lstExternalData.join('\n') + '\n' + lstDateTime.join('\n');
             lstData[2]['comments'] = strFormattedComment;
         } catch(exception) {
             console.log(' Inside exception of History split ');
         }
         cmp.set("v.filteredHistoryList", lstData);
     },

    // US3480373: Service Request Detail Page Alignment - Krish - 5 May 2021
    filterExternalIdRecords : function(cmp, unfilteredList){
        let searchText = cmp.find("externalIdSearchBox").get("v.value").toLowerCase().trim();
        if ($A.util.isEmpty(searchText)) {
            return unfilteredList;
        } else {
            let filteredData = unfilteredList.filter(function (obj) {
                // get all attributes of the object as string, convert to lowercase and then filter
                return JSON.stringify(Object.values(obj)).toLowerCase().includes(searchText);
            });
            return filteredData;
        }
    },
    // US3177995 - Thanish - 22nd Jun 2021
    getPurgedORSRecords: function(cmp){
        cmp.set("v.isExternalIdsLoaded", false);
        var action = cmp.get("c.getPurgedORSRecords");
        action.setParams({
            "searchId": cmp.get("v.memberEEID")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state=='SUCCESS') {
                var result = response.getReturnValue();
                var filteredExternalIdRecs = cmp.get("v.filteredExternalIdRecs");
                var concatData = filteredExternalIdRecs.concat(result.response);

                cmp.set("v.filteredExternalIdRecs", concatData);
            } else if(state=='ERROR') {
            }
            cmp.set("v.isExternalIdsLoaded", true);
        });
        $A.enqueueAction(action);
    },

    removePurgedORSRecords: function(cmp){
        cmp.set("v.isExternalIdsLoaded", false);
        var filteredExternalIdRecs = cmp.get("v.filteredExternalIdRecs");
        if(!$A.util.isEmpty(filteredExternalIdRecs)){
            cmp.set("v.filteredExternalIdRecs", filteredExternalIdRecs.filter(record => record.IdType != 'Purged ORS'));
        }
        cmp.set("v.isExternalIdsLoaded", true);
    }
})