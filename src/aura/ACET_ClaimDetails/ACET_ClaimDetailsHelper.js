({
    //US2876410 - open misdirect subtab - ketki
	 openMisDirect: function (component, event, helper) {
         
        console.log("ACET_ClaimDetailController - openMisDirect" );
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getEnclosingTabId().then(function (enclosingTabId) {
            if (enclosingTabId == false) {
                workspaceAPI.openTab({
                    pageReference: {
                        "type": "standard__component",
                        "attributes": {
                            "componentName": "c__SAE_MisdirectComponent" // c__<comp Name>
                        },
                        "state": {}
                    },
                    focus: true
                }).then(function (response) {
                    workspaceAPI.getTabInfo({
                        tabId: response
                    }).then(function (tabInfo) {
                        
                        var focusedTabId = tabInfo.tabId;
                        workspaceAPI.setTabLabel({
                            tabId: focusedTabId,
                            label: "Misdirect"
                        });
                        workspaceAPI.setTabIcon({
                            tabId: focusedTabId,
                            icon: "standard:decision",
                            iconAlt: "Misdirect"
                        });
                    });
                }).catch(function (error) {
                    
                });
            } else {
                workspaceAPI.openSubtab({
                    parentTabId: enclosingTabId,
                    pageReference: {
                        "type": "standard__component",
                        "attributes": {
                            "componentName": "c__SAE_MisdirectComponent" // c__<comp Name>
                        },
                        "state": {
                            "c__originatorName": component.get('v.originatorName'),
                            "c__originatorType": component.get('v.originatorType'),
                            "c__contactName": component.get('v.contactName'),
                            "c__subjectName": component.get('v.subjectName'),
                            "c__subjectType": component.get('v.subjectType'),
                            "c__subjectDOB": component.get('v.subjectDOB'),
                            "c__subjectID": component.get('v.subjectID'),
                            "c__subjectGrpID": component.get('v.subjectGrpID'),
                            "c__interactionID": component.get('v.contactUniqueId'),
                            "c__contactUniqueId": component.get('v.contactUniqueId'),
							"c__focusedTabId": enclosingTabId
                        }
                    }
                }).then(function (subtabId) {

                    workspaceAPI.setTabLabel({
                        tabId: subtabId,
                        label: "Misdirect" //set label you want to set
                    });
                   
                    workspaceAPI.setTabIcon({
                        tabId: subtabId,
                        icon: "standard:decision",
                        iconAlt: "Misdirect"
                    });
                }).catch(function (error) {
                });
            }
        });
    },
    getMemberIdGroupIdAuthDtl: function (cmp) {
        var appEvent = $A.get("e.c:ACET_GetMemberIdGroupIdAuthDtl");
		appEvent.fire();
    },
    getClaimDetails: function (component, event, helper){
        var claimInput = component.get("v.claimInput");
        var claimNo = component.get("v.claimNo");
        component.set("v.claimInput.claimNumber",claimNo);
        var action = component.get('c.getClaimDetails');
         action.setParams({
            "claimInputs":claimInput
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state@@@' + state);
            if (state == "SUCCESS") {
                var data = response.getReturnValue();
                console.log('data##-->'+JSON.stringify(data));
                                if(data.isSuccess){
                                    console.log('Transactionid**'+data.transactionId);
                                    console.log('data##-->',data);

                console.log('Transactionid**'+data.transactionId);
                component.set("v.transactionId",data.transactionId);//Added by Mani
                component.set("v.claimLevelDiagnosisDetailsResult",data.claimLevelDiagnosisDetails);
                console.log("acet claim detail ", JSON.stringify(data.claimLevelDiagnosisDetails));
               	let causeCode=data.additionalClaimInfo.causeCode;
                let firstSev=data.additionalClaimInfo.firstSrvDate;
                let icn=data.additionalClaimInfo.icn;
                let dccflnNbr =data.dccflnNbr;
                var dccflnf3 =(!$A.util.isEmpty(dccflnNbr)) ? dccflnNbr.substring(0, 3):"";
                var dccflnl  =(!$A.util.isEmpty(dccflnNbr)) ? dccflnNbr.substring(3, dccflnNbr.length):"";
                console.log('firstSrvDate'+firstSev);
                console.log('icn@@@@'+icn);
                var relatedDocData = component.get("v.relatedDocData");
                relatedDocData.icn = icn;
                relatedDocData.flnNbr =dccflnNbr;
                relatedDocData.dccflnNbr =dccflnl+dccflnf3;
                console.log('relatedDocData@@@@'+JSON.stringify(relatedDocData));
                component.set("v.firstSrvDate",firstSev);//Added by Mani
				component.set("v.dccflnNbr",dccflnNbr);																																				   
                //let memResp= data.additionalClaimInfo.membResp;
                let selectedClaimDetailCard = component.get("v.selectedClaimDetailCard");
                console.log("selectedClaimDetailCard :"+JSON.stringify(selectedClaimDetailCard));
                selectedClaimDetailCard.cardData[9].fieldValue = causeCode
				component.set("v.selectedClaimDetailCard",selectedClaimDetailCard);

                 let selectedClaimStatusTable = component.get("v.selectedClaimStatusTable");
                 var interest = '--'
                 if(data.interest == '0.00' || data.interest == '0' || data.interest == '--'){
                 selectedClaimStatusTable.tableBody[0].rowColumnData.find( r=> r.fieldLabel == 'INTEREST').fieldType = 'outputText';
                 selectedClaimStatusTable.tableBody[0].rowColumnData.find( r=> r.fieldLabel == 'INTEREST').isOutputText = true;
                 selectedClaimStatusTable.tableBody[0].rowColumnData.find( r=> r.fieldLabel == 'INTEREST').isLink = false;
                 interest = data.interest;
                 }else{
                   interest = '$ ' +data.interest;
                 }
                selectedClaimStatusTable.tableBody[0].rowColumnData.find( r=> r.fieldLabel == 'INTEREST').fieldValue = interest;
                selectedClaimStatusTable.tableBody[0].rowColumnData.find( r=> r.fieldLabel == 'RESERVE').fieldValue = data.reserve;
                let claimStatusTableBody= selectedClaimStatusTable.tableBody;
                let lines=data.lines;
                let paymentInfo=data.paymentInfo;
                 if (component.get("v.claimspolicyDetails").resultWrapper.policyRes.sourceCode == "CS"){
                 if(!$A.util.isUndefinedOrNull(lines)){
                  for(var row in claimStatusTableBody){
                  let nySurchrgPaidAmt=0.00;
                  let count=0;
                   for(var line in lines){
                       if(claimStatusTableBody[row].rowColumnData[1].fieldValue===lines[line].processedDt){
                           if(!$A.util.isUndefinedOrNull((lines[line].nySurchrgPaidAmt))){
                               nySurchrgPaidAmt=nySurchrgPaidAmt+lines[line].nySurchrgPaidAmt;
                               count++;
                           }
                       }
                   }
                    if(count!=0)
                       claimStatusTableBody[row].rowColumnData.find( r=> r.fieldLabel == 'NY SUR').fieldValue =nySurchrgPaidAmt.toFixed(2);
                    if(nySurchrgPaidAmt>0 && !$A.util.isUndefinedOrNull(paymentInfo)){
                        for(var payment in paymentInfo){
                            if(nySurchrgPaidAmt.toFixed(0)==paymentInfo[payment].chkAmount.toFixed(0)){
                                claimStatusTableBody[row].rowColumnData.find( r=> r.fieldLabel == 'NY SUR #').isOutputText =false;
                                claimStatusTableBody[row].rowColumnData.find( r=> r.fieldLabel == 'NY SUR #').isLink = true ;
                                claimStatusTableBody[row].rowColumnData.find( r=> r.fieldLabel == 'NY SUR #').fieldValue =paymentInfo[payment].chkSrsDesg+''+paymentInfo[payment].checkNumber;
                            }
                        }
                    }
                  } }}
                   component.set("v.selectedClaimStatusTable",selectedClaimStatusTable);
                                    //edited 0 -> 1
                let TaxID=selectedClaimDetailCard.cardData[1].fieldValue;//Added by Mani
                //let ProviderID=selectedClaimDetailCard.cardData[1].fieldValue;//Added by Mani
                let ProviderID=component.get("v.providerId");
                component.set("v.taxId",TaxID);
                component.set("v.providerId",ProviderID);
                console.log("Tax id,provider id"+TaxID+"/"+ProviderID);

                console.log("data.serviceLines :"+JSON.stringify(data.serviceLines));
                console.log("data.serviceLineDetails :"+JSON.stringify(data.serviceLineDetails));
             var relatedDocData = component.get("v.relatedDocData");
             for(var i in data.serviceLines.tableBody){
                 if(data.serviceLines.tableBody[i].rowColumnData.find( r=> r.fieldLabel == 'LINE').fieldValue =='0'){
                     data.serviceLines.tableBody.splice(i, 1);
                     break;
                 }

                 if(data.referralNumber != '--' && !$A.util.isUndefinedOrNull(data.referralNumber)){
                     data.serviceLines.tableBody[i].rowColumnData.find( r=> r.fieldLabel == 'REFERRAL #').fieldValue = data.referralNumber;
                     data.serviceLines.tableBody[i].rowColumnData.find( r=> r.fieldLabel == 'REFERRAL #').isOutputText = false;
                     data.serviceLines.tableBody[i].rowColumnData.find( r=> r.fieldLabel == 'REFERRAL #').isLink = true ;
                 }
             }
				//Ketki 11/5/2020 US2338191
                component.set("v.claimServiceLineDetails",data.serviceLines);
                component.set("v.intrestCardData",data.intrestDetails);
                component.set("v.allSvlLineCardData", data.serviceLineDetails);
                component.set("v.allSvlLnAddInfoCardData", data.serviceLineAdditionalInfo);
                component.set("v.additionalClaimInfoCNF", data.additionalClaimInfoCNF);

		// US3464932 27 April 2021
                component.set('v.claimsFeeScheduleData', data.feeData);
                //Ketki 11/5/2020 US2338191
                component.set("v.showPageComponents",true);
                 }
                                //added by sravani for error handling
                                else{
                                    this.showToastMessage("Error!",data.errorMessage, "error", "dismissible", "10000");
                                }
                                this.hideSpinner(component);
                helper.hideSpinner(component);
            }
            else if (state === "INCOMPLETE") {
                this.hideSpinner(component);
                console.log("Failed to connect Salesforce!!");
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("error :"+errors[0].message);
                    }
                }
                this.hideSpinner(component);
            }
        });
        $A.enqueueAction(action);

    },
    showSpinner: function (cmp) {
        var spinner = cmp.find("clmdtl-spinner");
        $A.util.removeClass(spinner, "slds-hide");
        $A.util.addClass(spinner, "slds-show");
    },

    hideSpinner: function (cmp) {
        var spinner = cmp.find("clmdtl-spinner");
        $A.util.removeClass(spinner, "slds-show");
        $A.util.addClass(spinner, "slds-hide");
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
    // US3474282 - Thanish - 15th Jul 2021 - removed unwanted code
     callGetClaimsDetails : function (component, event, helper) {
        var claimNumber = event.getParam("claimNumber");
        var fieldValue = event.getParam("fieldName");

        let memberNotInFocus=false;

        var providerData = component.get("v.providerData");

        var action = component.get('c.getClaimDetailsByClaimId');
        var claimInput = {
            "claimNumber": component.get("v.originalKeyedClaim"),
            "taxId": providerData.taxId,
            "ClaimType": "A",
            "FromDate":"Invalid Date",
            "ToDate":"Invalid Date",
            "AuthId": "",
            "sourceCode": "",
            "selectedop": "",
            "startDateCompare": "",
            "payerId": "87726",
            "memberId": "",
            "memberDOB": ""
        }

        action.setParams({
            "ClaimInputs":claimInput,
            "isDeductible":false,
            "isApplied":false,
            "start": 1,
            "isMoreThan90days" : false
        });
        action.setCallback(this, function(response) {

            var state = response.getState();

            var result = response.getReturnValue();

            if(state == 'SUCCESS') {
                if (result.statusCode == 200) {
                    console.log('response from service is>>> ' + JSON.stringify(result));

                    if(!$A.util.isUndefinedOrNull(claimInput.claimNumber) && !$A.util.isEmpty(claimInput.claimNumber)){
                        if(!$A.util.isUndefinedOrNull(result.memberInfo) && !$A.util.isEmpty(result.memberInfo)){
                            var memberDob = result.memberInfo[0].ptntDob;
                            var memberFullname = result.memberInfo[0].ptntFn+' '+result.memberInfo[0].ptntLn;
                            var memberFirstName = result.memberInfo[0].ptntFn;
                            var memberLastName = result.memberInfo[0].ptntLn;
                            var memberId = result.memberInfo[0].sbmtMembrId;
                            var policyNbr=result.memberInfo[0].policyNbr;

                            var serviceDates = result.claimSearchResult.tableBody[0].rowColumnData.
                            find( r=> r.fieldLabel == 'SERVICE DATES').fieldValue;
                            //var eligibleDate = component.get("v.eligibleDate").split(" - ");
                            //var higStartDate=$A.localizationService.formatDate(new Date(eligibleDate[0]),"yyyy-MM-dd");
                            //var higEndDate=$A.localizationService.formatDate(new Date(eligibleDate[1]),"yyyy-MM-dd");
                            var claimServiceDates= serviceDates.split(" - ");
                            var startDate=$A.localizationService.formatDate(new Date(claimServiceDates[0]),"yyyy-MM-dd");
                            var endDate=$A.localizationService.formatDate(new Date(claimServiceDates[1]),"yyyy-MM-dd");
                            var claimNumber = result.claimSearchResult.tableBody[0].rowColumnData.
                            find( r=> r.fieldLabel == 'CLAIM #').fieldValue;
                            var memberCardData = component.get("v.memberInfo");
                            component.set("v.claimsMemberFullname",memberFullname);
                            component.set("v.claimsMemberFirstname",memberFirstName);
                            component.set("v.claimsMemberLastname",memberLastName);
                            component.set("v.claimsMemberDob",memberDob);
                            component.set("v.claimsMemberId", memberId);
                            component.set("v.claimsServiceDates", serviceDates);
                            component.set("v.claimspolicyNbr", policyNbr);

                            var claimMemberFullName = component.get("v.memberFN") +' '+component.get("v.memberLN");
                            var claimMemberDob = component.get("v.memberDOB");

                            if(claimMemberFullName.toUpperCase() != memberFullname.toUpperCase() && claimMemberDob != memberDob){
                                component.set("v.showWarning",true);
                                //memberNotInFocus=true;

                            }
                            /*else if(!(startDate >= higStartDate && startDate <= higEndDate) && !(endDate >= higStartDate && endDate <= higEndDate))
                            {
                                var msg='The claim number '+claimNumber+' has service date(s) '+serviceDates+' that are beyond the Policy eligible dates. Highlight the appropriate policy and perform your claim search again. ';
                                component.set("v.showNewMessage",false);
                                //this.showToastMessage("We hit a snag.",msg, "error", "dismissible", "30000");
                            }*/
                        }
                    }
                    component.set("v.paginationClaimResult", result.claimSearchResult);
                    /*pagination start here*/

                    console.log('end++++++++++++',end);
                    var tmpresult = {};
                    tmpresult.tableBody = [];
                    tmpresult.tableHeaders = result.claimSearchResult.tableHeaders;
                    tmpresult.startNumber=1;
                    tmpresult.endNumber=0;
                    tmpresult.noOfPages=1;
                    tmpresult.recordCount=0;
                    if(!memberNotInFocus){
                        var end = (result.claimSearchResult.tableBody.length>100)?100:result.claimSearchResult.tableBody.length;
                        for(var x in result.claimSearchResult){
                            var t=result.claimSearchResult[x];
                            tmpresult[x] = t;
                            if(x=='tableBody'){
                                var temparray = [];
                                for(var i=0; i<end;i++){
                                    temparray.push(result.claimSearchResult.tableBody[i]);
                                }
                                if(temparray.length> 0 && component.get("v.highlightedPolicySourceCode") == "CS" ){
                                    //component.set("v.showAdvanceSearch",true);
                                    //component.set("v.enablePopup",!component.get("v.enablePopup"));
                                }
                                tmpresult.tableBody = temparray;
                                tmpresult.startNumber=temparray.length > 0 ? 1 : 0;
                                tmpresult.endNumber=end;
                            }
                        }
                    }
                    console.log('tmpresult+++', tmpresult);
                    /*pagination end here*/
                    var extProviderTable = [];//_autodoc.getAutodocComponent(component.get("v.autodocUniqueId"),component.get("v.policySelectedIndex"),'Claim Results');
                    var preSelectCLiamList=[];
                    var preSelectMemberList=[];
                    var preSelectClaimStatusList=[];
                    let prevSelectedClaimRows = [];
                    if( !$A.util.isEmpty(extProviderTable)  && !$A.util.isEmpty(extProviderTable.selectedRows))  {

                        if(!(tmpresult.tableBody)) {
                            tmpresult.tableBody = [];
                        }
                        prevSelectedClaimRows = extProviderTable.selectedRows;
                        var closedClaimDetails = component.get("v.closedClaimDetails");
                        if(closedClaimDetails.length>0){
                            prevSelectedClaimRows.forEach(element => {
                                for(var i=0;i<closedClaimDetails.length;i++){
                                if (element.uniqueKey ==closedClaimDetails[i]){
                                element.linkDisabled = false;
                                closedClaimDetails.splice(i, 1);
                                break;
                            }}
                                                          });
                        }
                        var enabled = [];
                        var disabled = [];
                        prevSelectedClaimRows.forEach(element => {
                            if (element.linkDisabled)
                            disabled.push(element);
                            else
                            enabled.push(element);
                        });
                        prevSelectedClaimRows= disabled.concat(enabled);
                        component.set("v.selectedRows", prevSelectedClaimRows);
                        for(var i=0;i<prevSelectedClaimRows.length;i++){
                            if (prevSelectedClaimRows[i].caseItemsExtId =="No Results Found")
                                prevSelectedClaimRows.splice(i, 1);
                        }
                        prevSelectedClaimRows.forEach(element => {
                            for(var i=0;i<tmpresult.tableBody.length;i++){
                            if (element.caseItemsExtId ==tmpresult.tableBody[i].caseItemsExtId){
                            tmpresult.tableBody.splice(i, 1);
                            break;
                        }}
                                                      });
                        tmpresult.tableBody = prevSelectedClaimRows.concat(tmpresult.tableBody);
                        var temparray1 = component.get("v.mapClaimSummaryDetails");
                        let memberInfoDetails = component.get("v.memberInfoDetails");
                        let arrClaimStatusDetails = component.get("v.listClaimStatusDetails");
                        for(i in prevSelectedClaimRows){
                            if(!$A.util.isUndefinedOrNull(temparray1) && !$A.util.isEmpty(temparray1)  && temparray1!="[]"){
                                preSelectCLiamList.push(temparray1.find(v => v.componentName.includes(prevSelectedClaimRows[i].rowColumnData[0].fieldValue)));
                            }
                            if(!$A.util.isUndefinedOrNull(memberInfoDetails) && !$A.util.isEmpty(memberInfoDetails)  && memberInfoDetails!="[]"){
                                preSelectMemberList.push(memberInfoDetails.find(v => v.claimno.includes(prevSelectedClaimRows[i].rowColumnData[0].fieldValue)));
                            }
                            if(!$A.util.isUndefinedOrNull(arrClaimStatusDetails) && !$A.util.isEmpty(arrClaimStatusDetails)  && arrClaimStatusDetails!="[]"){
                                preSelectClaimStatusList.push(arrClaimStatusDetails.find(v => v.componentName.includes(prevSelectedClaimRows[i].rowColumnData[0].fieldValue)));
                            }
                        }

                    }


                    if (prevSelectedClaimRows.length > 0) {
                        debugger;
                        tmpresult.recordCount=tmpresult.tableBody.length;
                        var end = (tmpresult.tableBody.length>100)?100:tmpresult.tableBody.length;
                        tmpresult.endNumber = end;
                        tmpresult.noOfPages = Math.ceil(tmpresult.tableBody.length/100);
                        console.log('tmpresult+++1', JSON.stringify(tmpresult));
                    }
                    console.log('after set'+JSON.stringify(component.get("v.autodocClaimResult")));
                    if(!memberNotInFocus){
                        component.set("v.mapClaimSummaryDetails" ,result.claimSummayByClaim );
                        component.set("v.mapClaimAdditionalInfo" ,result.claimAdditionalInfoByClaim );
                        component.set("v.listClaimStatusDetails" ,result.claimStatusByClaim );
                    }
                    component.set("v.memberInfoDetails" ,result.memberInfo );
                    if (preSelectCLiamList.length > 0) {
                        var cliamSummary = component.get("v.mapClaimSummaryDetails");
                        for(i in preSelectCLiamList){
                            cliamSummary.push(preSelectCLiamList[i]);
                        }
                        component.set("v.mapClaimSummaryDetails" ,cliamSummary);
                    }
                    if(preSelectClaimStatusList.length > 0){
                        var cliamStatus = component.get("v.listClaimStatusDetails");
                        for(i in preSelectClaimStatusList){
                            cliamStatus.push(preSelectClaimStatusList[i]);
                        }
                        component.set("v.listClaimStatusDetails" ,cliamStatus);
                    }
                    if (preSelectMemberList.length > 0) {
                        var memberInfo = component.get("v.memberInfoDetails");
                        for(i in preSelectMemberList){
                            memberInfo.push(preSelectMemberList[i]);
                        }
                        component.set("v.memberInfoDetails" ,memberInfo);
                    }

                    tmpresult.callTopic = 'View Claims';

                    var selectedRowdata = tmpresult.tableBody[0];

                    component.set("v.selectedRowdata",selectedRowdata);

                    component.set("v.autodocClaimResult",tmpresult);
                    //helper.openClaimDetails(component, event, helper);
                    if(claimMemberFullName.toUpperCase() == memberFullname.toUpperCase() && claimMemberDob == memberDob){
                        component.set("v.showWarning",false);
                        helper.openClaimDetails(component, event, helper);

                    }

                }else{

                }
            }else if(state == 'ERROR'){
                //this.showToastMessage("We hit a snag.", this.claimSearchErrorMessage, "error", "dismissible", "30000");
            }
            helper.hideSpinner(component);
        });
        $A.enqueueAction(action);

    },

    openClaimDetails: function (cmp, event, helper) {
        let policyDetails = cmp.get("v.policyDetails");
        console.log("P:oll"+JSON.stringify(policyDetails));
        let insuranceTypeCode = cmp.get("v.insuranceTypeCode");
        console.log("insuranceTypeCode"+insuranceTypeCode);
        let contractFilterData = {};
        if(!$A.util.isEmpty(policyDetails)){
            contractFilterData = {
                "marketType": policyDetails.resultWrapper.policyRes.marketType,
                "marketSite": policyDetails.resultWrapper.policyRes.marketSite,
                "productCode": insuranceTypeCode,
                "platform": policyDetails.resultWrapper.policyRes.platform

            }
        }
        console.log("Policy Details--102"+JSON.stringify(contractFilterData));

        var selectedRowdata = cmp.get("v.selectedRowdata");//event.getParam("selectedRows");
        var currentRowIndex = event.getParam("currentRowIndex");
        console.log('selectedRowdata in acet_claim_search_result'+JSON.stringify(selectedRowdata));
        console.log('claim number outside if '+ selectedRowdata.rowColumnData[0].fieldValue);
        //write better logic to get claim number
        if (!$A.util.isUndefinedOrNull(selectedRowdata)
            && !$A.util.isUndefinedOrNull(selectedRowdata.rowColumnData)
            && selectedRowdata.rowColumnData.length > 0

           ) {}
        console.log('selectedRowdata in acet_claim_search_result'+JSON.stringify(selectedRowdata));
        console.log('claim number inside if '+ selectedRowdata.rowColumnData[0].fieldValue);
        //write better logic to get claim number
        let selectedClaimNo = selectedRowdata.rowColumnData[0].fieldValue;
        let selectedProcessedDate = selectedRowdata.rowColumnData[8].fieldValue;
        let taxId = selectedRowdata.rowColumnData[1].fieldValue;
        let claimStatus = selectedRowdata.rowColumnData[6].fieldValue;
        var claimStatusSet = cmp.get("v.claimStatusSet");
        let claimStatusSetNew = new Set();
        for (var x in claimStatusSet) {
            claimStatusSetNew.add(claimStatusSet[x]);
        }
        let isClaimNotOnFile = claimStatusSetNew.has(claimStatus) ? true : false;
        let claimInput = cmp.get("v.claimInput");
        claimInput.processDate = selectedProcessedDate;
        claimInput.ClaimType = selectedRowdata.additionalData.ClaimType;
        let claimInputTxaId = claimInput.taxId;
        if(taxId != '--'){
            claimInput.taxId = taxId;
        }
        console.log('claimInput####'+JSON.stringify(claimInput));
        let arrClaimSummaryDetails = cmp.get("v.mapClaimSummaryDetails");
        let selectedClaimDetailCard = arrClaimSummaryDetails[0];// arrClaimSummaryDetails.find(v => v.cmpName.includes(selectedClaimNo));

        let arrClaimAdditionalInfo = cmp.get("v.mapClaimAdditionalInfo");
        let arrClaimAdditionalInfoTable = arrClaimAdditionalInfo[0];//arrClaimAdditionalInfo.find(v => v.cmpName.includes(selectedClaimNo));

        let arrClaimStatusDetails = cmp.get("v.listClaimStatusDetails");
        let selectedClaimStatusTable = arrClaimStatusDetails[0];// arrClaimStatusDetails.find(v => v.cmpName.includes(selectedClaimNo));

        let memberInfoDetails = cmp.get("v.memberInfoDetails");
        let selectedmemberInfoDetails = memberInfoDetails[0];// memberInfoDetails.find(v => v.claimno.includes(selectedClaimNo));
        console.log("selectedmemberInfoDetails-" + JSON.stringify(selectedmemberInfoDetails));

        console.log("mapClaimSummaryDetails-" + JSON.stringify(selectedClaimDetailCard));
        let PROVIDERID = selectedRowdata.rowColumnData[2].fieldValue;

        let memberID = cmp.get("v.memberId");
        if(!$A.util.isUndefinedOrNull(selectedClaimDetailCard) && !$A.util.isEmpty(selectedClaimDetailCard)){
            var fieldString = selectedClaimDetailCard.cardData[6].fieldValue;
            var array = [];
            array = fieldString.split('-');
        }

        var firstSvcDateParts =array[0].trim().split('/');
        var firstSvcDate =firstSvcDateParts[2]+'-'+firstSvcDateParts[0]+'-'+firstSvcDateParts[1]+ 'T00:00:00.000Z';

        var lastSvcDateParts =array[1].trim().split('/');
        var lastSvcDate = lastSvcDateParts[2]+'-'+lastSvcDateParts[0]+'-'+lastSvcDateParts[1]+ 'T00:00:00.000Z';

        var receivedDate =selectedmemberInfoDetails.receivedDate.trim().split('/');
        var receivedDate =receivedDate[2]+'-'+receivedDate[0]+'-'+receivedDate[1]+ 'T00:00:00.000Z';


        let relatedDocData={
            "FirstDateofService":firstSvcDate,
            "LastDateofService":lastSvcDate,
            "MemberID": memberID,
            "TIN":selectedRowdata.rowColumnData[1].fieldValue,
            "ClaimNumber":selectedClaimNo,
            "FirstName":selectedmemberInfoDetails.ptntFn,
            "LastName":selectedmemberInfoDetails.ptntLn,
            "receivedDate":receivedDate,
            "selectedmemberInfoDetails":selectedmemberInfoDetails,
            "policyNumber":cmp.get("v.policyNumber"),
            "platform":selectedmemberInfoDetails.platform,
            "PatientFullName":selectedmemberInfoDetails.ptntFn+' '+selectedmemberInfoDetails.ptntLn
        };
        console.log("relatedDocData-" + JSON.stringify(relatedDocData));

        var serviceDates = selectedRowdata.rowColumnData[4].fieldValue;
        var dates = serviceDates.split("-");
        var startDate = dates[0].split("/");
        var endDate = dates[1].split("/");
        var claimStartDate = startDate[2].trim()+"-"+startDate[0].trim()+"-"+startDate[1].trim();
        var claimEndDate = endDate[2].trim()+"-"+endDate[0].trim()+"-"+endDate[1].trim();
        var tableDetails = cmp.get("v.autodocClaimResult");
        var newBody = [];
        var noRows=[];
        newBody.push(selectedRowdata);
        for (let i = 0; i < tableDetails.tableBody.length; i++) {
            const element = tableDetails.tableBody[i];
            if(element.caseItemsExtId=='No Results Found')
                noRows.push(element);
            else if (element.caseItemsExtId != selectedRowdata.caseItemsExtId) {
                newBody.push(element);
            }
        }
        tableDetails.tableBody =noRows.concat(newBody);
        //cmp.set("v.autodocClaimResult", tableDetails);
        var providerDetails = JSON.stringify(cmp.get("v.providerDetails"));
        var selectedPolicy = cmp.get("v.selectedPolicy");
        var callTopicLstSelected = cmp.get("v.callTopicLstSelected");
        var callTopics = [];
        if(!$A.util.isUndefinedOrNull(callTopicLstSelected) && !$A.util.isEmpty(callTopicLstSelected)){
            callTopics = JSON.stringify(callTopicLstSelected);
        }

        let workspaceAPI = cmp.find("workspace");
        workspaceAPI.getAllTabInfo().then(function (response) {
            workspaceAPI.openSubtab({
                pageReference: {
                    "type": "standard__component",
                    "attributes": {
                        "componentName": "c__ACET_ClaimDetails"
                    },
                    "state": {
                        "c__claimNo": selectedClaimNo,
                        "c__currentRowIndex":'1',
                        "c__claimNoTabUnique": '1',
                        "c__hipaaEndpointUrl": cmp.get("v.hipaaEndpointUrl"),
                        "c__contactUniqueId": cmp.get("v.contactUniqueId"),
                        "c__interactionRec": JSON.stringify(cmp.get('v.interactionRec')),
                        "c__interactionOverviewTabId": cmp.get("v.interactionOverviewTabId"),
                        "c__claimInput":claimInput,
                        "c__isMRlob":cmp.get("v.isMRlob"),
                        "c__selectedClaimDetailCard": JSON.stringify(selectedClaimDetailCard),//need details
                        "c__selectedClaimStatusTable": JSON.stringify(selectedClaimStatusTable), //need details
                        "c__contractFilterData": JSON.stringify(contractFilterData),//need details
                        "c__autodocUniqueId":cmp.get("v.autodocUniqueId"),
                        "c__autodocUniqueIdCmp":cmp.get("v.autodocUniqueIdCmp"),
                        "c__caseWrapperMNF":cmp.get("v.caseWrapperMNF"),
                        "c__cmpId":cmp.get("v.cmpId"),
                        "c__memberDOB":cmp.get("v.claimsMemberDob"),
                        "c__policyDetails":cmp.get("v.claimspolicyDetails"),
                        "c__memberFN":cmp.get("v.claimsMemberFirstname"),
                        "c__memberCardData":cmp.get("v.memberCardData"),
                        "c__memberCardSnap":cmp.get("v.memberCardSnap"),
                        "c__policyNumber":cmp.get("v.policyNumber"),
                        "c__houseHoldData":JSON.stringify(cmp.get("v.houseHoldData")),
                        "c__dependentCode":cmp.get("v.dependentCode"),
                        "c__regionCode":cmp.get("v.regionCode"),
                        "c__cobData":JSON.stringify(cmp.get("v.cobData")),
                        "c__secondaryCoverageList":JSON.stringify(cmp.get("v.secondaryCoverageList")),
                        "c__cobMNRCommentsTable":JSON.stringify(cmp.get("v.cobMNRCommentsTable")),
                        "c__cobENIHistoryTable":JSON.stringify(cmp.get("v.cobENIHistoryTable")),
                        "c__houseHoldMemberId":cmp.get("v.houseHoldMemberId"),
                        "c__memberPolicies": JSON.stringify(cmp.get("v.memberPolicies")),
                        "c__policySelectedIndex":cmp.get("v.policySelectedIndex"),
                        "c__currentPayerId":cmp.get("v.currentPayerId"),
                        "c__memberautodocUniqueId":cmp.get("v.memberautodocUniqueId"),
                        "c__autoDocToBeDeleted":cmp.get("v.autoDocToBeDeleted"),
                        "c__serviceFromDate":claimStartDate,
                        "c__serviceToDate":claimEndDate,
                        "c__memberLN": cmp.get("v.claimsMemberLastname"),
                        "c__AuthAutodocPageFeatur": cmp.get("v.AuthAutodocPageFeature"),
                        "c__authContactName":cmp.get("v.authContactName"),
                        "c__SRNFlag": cmp.get("v.SRNFlag"),
                        "c__interactionType": cmp.get("v.interactionType"),
                        "c__AutodocPageFeatureMemberDtl":cmp.get("v.AutodocPageFeatureMemberDtl"),
                        "c__AutodocKeyMemberDtl":cmp.get("v.AutodocKeyMemberDtl"),
                        "c__isHippaInvokedInProviderSnapShot":cmp.get("v.isHippaInvokedInProviderSnapShot"),
                        "c__noMemberToSearch":cmp.get("v.noMemberToSearch"),
                        "c__interactionCard":cmp.get("v.interactionCard"),
                        "c__selectedTabTyp":cmp.get("v.selectedTabType"),
                        "c__originatorType": cmp.get("v.originatorType"),
                        "c__memberTabId": cmp.get("v.memberTabId"),
                        "c__providerId": PROVIDERID,
                        "c__currentIndexOfOpenedTabs": '5',
                        "c__selectedPolicy":JSON.stringify(selectedPolicy),
                        "c__callTopicOrder":JSON.stringify(cmp.get("v.callTopicOrder")),
                        "c__planLevelBenefitsRes":JSON.stringify(cmp.get("v.planLevelBenefitsRes")),
                        "c__eligibleDate":cmp.get("v.eligibleDate"),
                        "c__highlightedPolicySourceCode":cmp.get("v.highlightedPolicySourceCode"),
                        "c__isSourceCodeChanged":cmp.get("v.isSourceCodeChanged"),
                        "c__policyStatus": cmp.get("v.policyStatus"),
                        "c__isTierOne": cmp.get("v.isTierOne"),
                        "c__callTopicLstSelected":callTopics,
                        "c__callTopicTabId":cmp.get("v.callTopicTabId"),
                        "c__relatedDocData": relatedDocData,
                        "c__providerDetails": providerDetails,
                        "c__addClaimType": selectedRowdata.additionalData.ClaimType,
                        "c__addnetworkStatus": selectedRowdata.additionalData.NetworkStatus,
                        "c__addbilltype": selectedRowdata.additionalData.billtype,
                        "c__isClaimNotOnFile": isClaimNotOnFile,
                        "c__selectedAdditionalInfoTable": JSON.stringify(arrClaimAdditionalInfoTable),
                        "c__mapInOutPatientDetail":JSON.stringify(cmp.get("v.selectedInOutDetailCard")),
                        "c__contactName" :  cmp.get("v.contactName"),
                        "c__providerNotFound" :  cmp.get("v.providerNotFound"),
                        "c__isProviderSearchDisabled" :cmp.get("v.isProviderSearchDisabled"),
                        "c__isOtherSearch" : cmp.get("v.isOtherSearch"),
                        "c__contactCard": cmp.get("v.contactCard"),
                        "c__memberInfo": cmp.get("v.memberInfo"),
                        "c__claimDetailPageOpenedFromCNFPage": true

                    }
                },
                focus: true
            }).then(function (response) {
                workspaceAPI.setTabLabel({
                    tabId: response,
                    label: cmp.get("v.originalKeyedClaim")
                });
                workspaceAPI.setTabIcon({
                    tabId: response,
                    icon: "custom:custom17",
                    iconAlt: "Claim Detail"
                });

            }).catch(function(error) {
                console.log(error);
            });
        }).then(function (response) {

        }).catch(function(error) {
            console.log(error);
        });
    },

    openMemberSnapshotPage: function (component, event, helper) {
        component.set("v.showWarning",false);
        //component.set("v.isClaim",true);
        //component.set("v.isCheckboxDisabled",false);
        // Ketki open member snapshot for claim

        let interactionRecord = component.get("v.interactionRec");

        var workspaceAPI = component.find("workspace");

        var interactionCard = component.get("v.interactionCard");
        var contactName =  component.get("v.contactName");
        var searchOption =  'NameDateOfBirth';


        //Table Row values
        var memberGrpN =  component.get("v.claimspolicyNbr");
        var groupId = '';
        //var selectedMemberId = '974314757';
        //var selectedMemberDob = '01/01/1980';
        //var selectedMemberFirstName = 'MURPHY';
        //var selectedMemberLasttName = 'RUDZEK';
        var selectedMemberId = component.get("v.claimsMemberId");
        var selectedMemberDob = component.get("v.claimsMemberDob");
        var selectedMemberFirstName=  component.get("v.claimsMemberFirstname");
        var selectedMemberLasttName= component.get("v.claimsMemberLastname");
        var policyDateRange= component.get("v.claimsServiceDates");
       // var policyNbr= component.get("v.claimspolicyNbr");
        var memUniqueId =  selectedMemberId + selectedMemberDob + selectedMemberFirstName;

        var isOtherSearch = component.get("v.isOtherSearch");
        var otherCardDataObj = component.get("v.interactionCard");
        var providerNotFound = component.get("v.providerNotFound");
        var noMemberToSearch = component.get("v.noMemberToSearch");
        var isProviderSearchDisabled = component.get("v.isProviderSearchDisabled");
        var memberCardFlag = component.get("v.memberCardFlag");

        var matchingTabs = [];

        var claimInput=component.get("v.claimInput");
        claimInput.memberId=component.get("v.claimsMemberId");
        claimInput.memberDOB=component.get("v.claimsMemberDob");

		//Open Sub Tab - Checking duplicate tabs
		workspaceAPI.getAllTabInfo().then(function(response) {
            if(!$A.util.isEmpty(response)) {
				for(var i = 0; i < response.length; i++) {

					for(var j = 0; j < response[i].subtabs.length; j++) {
						if(response[i].subtabs.length > 0){
							var	tabMemUniqueId = response[i].subtabs[j].pageReference.state.c__memberUniqueId;

							if(memUniqueId === tabMemUniqueId) {
								matchingTabs.push(response[i]);
								break;
                            }
						}
					}
				}
			}

            var memberCardSnap = component.get("v.memberCardSnap");

            //Open Sub Tab
                if(matchingTabs.length === 0) {
                    workspaceAPI.getEnclosingTabId().then(function(enclosingTabId) {
                        workspaceAPI.openSubtab({
                            parentTabId: enclosingTabId,
                            pageReference: {
                                "type": "standard__component",
                                "attributes": {
                                    "componentName": "c__SAE_SnapshotOfMemberAndPolicies" // c__<comp Name>
                                },
                                "state": {
                                    "c__interactionCard":interactionCard,
                                    "c__contactName": contactName ,
                                    "c__searchOption": "NameDateOfBirth",
                                    "c__memberId": selectedMemberId,
                                    "c__groupId":'',
                                    "c__memberDOB": selectedMemberDob,
                                    "c__memberFN": selectedMemberFirstName,
                                    "c__memberLN": selectedMemberLasttName,
                                    "c__memberGrpN": memberGrpN,
                                    "c__memberUniqueId": memUniqueId,
                                    "c__subjectCard": null,
                                    "c__houseHoldUnique": memUniqueId,
                                    "c__payerID" : "87726",
				    				// US2060237	Other Card Validation - Snapshot - Other (Third Party) - 10/10/2019 - Sarma
                                    "c__providerNotFound": providerNotFound,//need
                                    "c__noMemberToSearch": noMemberToSearch,
                                    "c__isProviderSearchDisabled": isProviderSearchDisabled,
                                    "c__interactionRecord":interactionRecord,
                                    "c__mnf":'',
                                    "c__isOtherSearch" : isOtherSearch,
                                    "c__otherDetails" : otherCardDataObj,
                                    "c__isAdditionalMemberIndividualSearch" : false,
                                    "c__isfindIndividualFlag" : false,
                                    "c__memberCardFlag" : true,
                                    "c__contactCard":component.get("v.contactCard"),
                                    "c__providerDetailsForRoutingScreen": component.get("v.providerDetailsForRoutingScreen"),
                                    "c__flowDetailsForRoutingScreen": component.get("v.flowDetailsForRoutingScreen"),
									"c__providerDetails": component.get("v.providerDetailsForRoutingScreen"),// Not sure if we can use this
                                    "c__interactionOverviewTabId": component.get("v.interactionOverviewTabId") ,
                                    //"c__policyDateRange": policyDateRange,
                                    "c__isClaim": component.get("v.isClaim"),
                                    "c__claimInput": claimInput
                                }
                            }
                        }).then(function(subtabId) {

                            var tabLabel = "";
                            if(!$A.util.isEmpty(selectedMemberFirstName)){
                                tabLabel = selectedMemberFirstName.charAt(0).toUpperCase() + selectedMemberFirstName.slice(1).toLowerCase() + " ";
                            }
                            if(!$A.util.isEmpty(selectedMemberLasttName)){
                                tabLabel = tabLabel + selectedMemberLasttName.charAt(0).toUpperCase() + selectedMemberLasttName.slice(1).toLowerCase();
                            }
                            workspaceAPI.setTabLabel({
                                tabId: subtabId,
                                label: tabLabel
                            });
                            workspaceAPI.setTabIcon({
                                tabId: subtabId,
                                icon: "custom:custom38",
                                iconAlt: "Snapshot"
                            });
                        }).catch(function(error) {

                        });

                    });
                } else {
                    let mapOpenedTabs = new Map();
                    for(var i = 0; i < response.length; i++) {
                        for(var j = 0; j < response[i].subtabs.length; j++) {
                            let subTab = response[i].subtabs[j];
                            mapOpenedTabs.set(subTab.pageReference.state.c__memberUniqueId,subTab);
                         }
                    }

                    if(mapOpenedTabs.has(memUniqueId)) {
                        let currentTab = mapOpenedTabs.get(memUniqueId);
                        var focusTabId = currentTab.tabId;
                        var tabURL = currentTab.url;

                        workspaceAPI.openTab({
                            url: currentTab.url
                        }).then(function(response) {
                            workspaceAPI.focusTab({tabId : response});
                       }).catch(function(error) {

                        });
                    }
                }
        })
    },
    openDocument: function(cmp, event, helper){

        var titleDocID = "";

        var docId = 'documentId=';

        var encodedString = btoa(docId);
        var URLToSend = encodedString;
        var memberTabId = "";//cmp.get("v.memberTabId");
        var workspaceAPI = cmp.find("workspace");

        workspaceAPI.getEnclosingTabId().then(function (enclosingTabId) {
            workspaceAPI.openSubtab({
                parentTabId: enclosingTabId,
                pageReference: {
                    "type": "standard__component",
                    "attributes": {
                        "componentName": "c__ACET_ICUEDocIframe" // c__<comp Name>
                    },
                    "state": {
                        "iframeUrl":URLToSend,
                        "memberTabId" : memberTabId,
                        "docID": titleDocID
                    }
                },
                focus: true
            }).then(function (subtabId) {
                let mapSubTabID = new Map();
                mapSubTabID.set(titleDocID,subtabId);
                cmp.set("v.subTabMap",mapSubTabID);
                workspaceAPI.setTabLabel({
                    tabId: subtabId,
                    label: titleDocID
                });
                workspaceAPI.setTabIcon({
                    tabId: subtabId,
                    icon: "action:record",
                    iconAlt: titleDocID
                });
            }).catch(function (error) {
                console.log(error);
            });
        });

    },

    createDocInputs : function(cmp, event, helper) {
        var relatedDocClaimImages = {};
        relatedDocClaimImages.docName = 'Claim Images';
        relatedDocClaimImages.docHelpText = '';
        relatedDocClaimImages.docSectionId = 'ClaimImages';

        var relatedDocumentList = cmp.get("v.relatedDocumentList");
         relatedDocumentList.push(relatedDocClaimImages);

        cmp.set("v.relatedDocumentList",relatedDocumentList);
    },

    navigateToClaimsDoc: function (component, event, helper) {
        var claimId = component.get("v.originalKeyedClaim");
        var dccflnf1  =(!$A.util.isEmpty(claimId)) ? claimId.substring(0, 3):"";
        var dccflnl2  =(!$A.util.isEmpty(claimId)) ? claimId.substring(3, claimId.length):"";
        var dccflnl3  =(!$A.util.isEmpty(dccflnl2)) ? dccflnl2.substring(0, dccflnl2.length - 2):"";
        let relatedDocData={
            "dccflnNbr": dccflnl3 + dccflnf1
        };

        var relatedDocClaimImages = {};
        relatedDocClaimImages.docName = 'Claim Images';
        relatedDocClaimImages.docHelpText = '';
        relatedDocClaimImages.docSectionId = 'ClaimImages';

        var relatedDocumentList = component.get("v.relatedDocumentList");
         relatedDocumentList.push(relatedDocClaimImages);

        component.set("v.relatedDocumentList",relatedDocumentList);

        var relatedDoc = component.get("v.relatedDocumentList")[0];

        var workspaceAPI = component.find("workspace");
        var matchingTabs = [];
        var relUniqueId = component.get('v.originalKeyedClaim') + relatedDoc;

        var indexNameList = "";
        var selectedClaimDetailCard = component.get("v.selectedClaimDetailCard");
        if(!$A.util.isUndefinedOrNull(selectedClaimDetailCard) && !$A.util.isUndefinedOrNull(selectedClaimDetailCard.cardData)){
            var cardDataList =  selectedClaimDetailCard.cardData;
            for(var x in cardDataList){
                var fieldRec = cardDataList[x];
                if(fieldRec.fieldName =="Type"){
                    if(fieldRec.fieldValue == "Electronic"){
                        indexNameList = "u_edi_claim";
                    }
                    if(fieldRec.fieldValue == "Paper"){
                        indexNameList = "u_keyed_claim";
                    }
                }
            }
        }

        workspaceAPI.getAllTabInfo().then(function (response) {
            if (!$A.util.isEmpty(response)) {
                for (var i = 0; i < response.length; i++) {
                    for (var j = 0; j < response[i].subtabs.length; j++) {
                        if (response[i].subtabs.length > 0) {
                            var tabRelDocUniqueId = response[i].subtabs[j].pageReference.state.c__relatedDocTabUnique;
                            if (relUniqueId === tabRelDocUniqueId) {
                                matchingTabs.push(response[i].subtabs[j]);
                                break;
                            }
                        }
                    }
                }
            }

            if (true) {
                if(!(matchingTabs.length === 0)){
                    workspaceAPI.closeTab({
                        tabId:matchingTabs[0].tabId
                    });
                }

                workspaceAPI.getEnclosingTabId().then(function (enclosingTabId) {
                    workspaceAPI.openSubtab({
                        parentTabId: enclosingTabId,
                        pageReference: {
                            "type": "standard__component",
                            "attributes": {
                                "componentName": "c__ACET_ClaimDocuments"
                            },
                            "state": {
                                "c__claimNo": component.get("v.originalKeyedClaim"),
                                "c__relatedDocTabUnique": relUniqueId,
                                "c__hipaaEndpointUrl": component.get("v.hipaaEndpointUrl"),
                                "c__docSectionId": relatedDoc.docSectionId,
                                "c__interactionID": component.get('v.contactUniqueId'),
                                "c__contactUniqueId": component.get('v.contactUniqueId'),
                                "c__autodocUniqueId": component.get("v.autodocUniqueId"),
                                "c__relatedDocData": relatedDocData,//component.get("v.relatedDocData"),
                                "c__isClaimNotOnFile": true,
                                "c__indexNameList" : indexNameList

                            }
                        },
                        focus: !event.ctrlKey
                    }).then(function (subtabId) {


                        workspaceAPI.setTabLabel({
                            tabId: subtabId,
                            label: 'Documents'
                        });
                        workspaceAPI.setTabIcon({
                            tabId: subtabId,
                            icon: "standard:file",
                            iconAlt:" Claim Documents"
                        });
                    }).catch(function (error) {
                        console.log(error);
                    });
                });
            } else {
                var focusTabId = matchingTabs[0].tabId;
                var tabURL = matchingTabs[0].url;
                tabURL= tabURL.replace(/(c__docSectionId=)[^\&]+/, '$1' + relatedDoc.docSectionId);
                workspaceAPI.openTab({
                    url: tabURL
                }).then(function (response) {
                    workspaceAPI.refreshTab({
                        tabId: response
                    });
                }).catch(function (error) {
                    console.log(error);
                });

                $A.util.removeClass(event.currentTarget, "disableLink");
            }
        })

    },

    autoKeyedOriginalClaim: function (component, event, helper, fieldName) {
        var selectedClaimDetailCard = component.get("v.selectedClaimDetailCard");
        var cardDataListRec =  selectedClaimDetailCard.cardData;
        for(var x in cardDataListRec){
            var fieldRec = cardDataListRec[x];
            if(fieldRec.fieldName.toUpperCase() == fieldName.toUpperCase()){
                cardDataListRec[x].checked = true;
            }
        }
        selectedClaimDetailCard.cardData = cardDataListRec;
        component.set("v.selectedClaimDetailCard", selectedClaimDetailCard);

        try {
            _autodoc.setAutodoc(component.get("v.autodocUniqueId"),component.get("v.autodocUniqueIdCmp"), selectedClaimDetailCard);
        }catch(err) {
            console.log("Claim not on file Claim summary autodoc: "+err);
        }

/*
        if (cardDetails.cardData[indexValue].isParent == true) {
            var parentName = cardDetails.cardData[indexValue].parentName;
            var checked = cardDetails.cardData[indexValue].checked;
            for(var i= 0; i<cardDetails.cardData.length; i++){
                var parentNames = cardDetails.cardData[i].parentName;
                var isParent = cardDetails.cardData[i].isParent;
                var isChild = cardDetails.cardData[i].isChild;
                if(parentName == parentNames && isChild && !isParent){
                    cardDetails.cardData[i].checked = checked;
                }
            }
            cmp.set("v.cardDetails", cardDetails);
        }
*/
    },
    getContractExceptions: function (cmp, event, helper, platform) {
        try{
            var exceptionDesc = "Able to submit notes for no auth denials.";
        var selectedInOutDetailCard = cmp.get("v.selectedInOutDetailCard");
        var selectedClaimDetailCard = cmp.get("v.selectedClaimDetailCard");
        var cardData=selectedClaimDetailCard.cardData;
        let taxId = cardData.find(x => x.fieldName === 'AdjTaxID').fieldValue;
        let providerId = cardData.find(x => x.fieldName === 'Adjudicated Provider ID').fieldValue;
        let contractId = '';
        if(platform == 'UNET'){
        contractId = cardData.find(x => x.fieldName === 'contractId').fieldValue;
        }else{
           contractId = cmp.get("v.contractNumber");
        }
        if(!$A.util.isEmpty(providerId) && !$A.util.isEmpty(taxId) && !$A.util.isEmpty(contractId)){
            var action =  cmp.get("c.getContractExceptions");
            action.setParams({
                "providerId": providerId,
                "taxId": taxId,
                "contractId": contractId
            });
            action.setCallback(this, function (response) {
                var data = response.getReturnValue();
                console.log('data@@-->',JSON.stringify(data));
                if (response.getState() === "SUCCESS") {
                    if(data.statusCode === 200 && data.success == true){
                        var indicator = data.medicalNecessityIndicator;
                        selectedInOutDetailCard.cardData.find( r=> r.fieldName == 'Contract Exceptions').fieldValue = indicator;
                        if(indicator == 'Y'){
                            selectedInOutDetailCard.cardData.find( r=> r.fieldName == 'Contract Exceptions').description = exceptionDesc;
                        }
                        cmp.set("v.selectedInOutDetailCard", selectedInOutDetailCard);
                    }
                }
            });
            $A.enqueueAction(action);
        }
        }catch(error){
            console.log("getContractExceptions: "+error);
        }
    },
})