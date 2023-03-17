({
	onInit : function(component, event, helper) {
        /*pagination test here*/
        var childcomp = component.find("autodoc");
        childcomp.refreshTable(component,event, helper);
        component.set("v.pageNumber", 1);
        /*pagination end here*/
        // DE482674 - Thanish - 1st Sep 2021
        // if(!$A.util.isEmpty(component.get("v.memberautodocUniqueId"))){
        //     helper.setDefaultAutodoc(component);
        // }
        console.log('before set'+JSON.stringify(component.get("v.autodocClaimResult")));
        console.log('memberCardData@@@@@@'+JSON.stringify(component.get("v.memberCardData")));
        console.log("init method is called of ACETClaimSearchResult component");
        console.log('policyDetails init method of claimSearch Result >>> ' + JSON.stringify( component.get("v.policyDetails")));
         console.log("memberid@@"+component.get("v.memberId"));
        // Added by Jay - Logic to update isMRlob flag
        var policydetails = component.get("v.policyDetails");
    if (policydetails.resultWrapper.policyRes.sourceCode == "CO") {
            component.set("v.isMRlob",true);
    } else {
            component.set("v.isMRlob",false);
        }
        // End of change

        var policySelectedIndex = component.get("v.policySelectedIndex");
        var memberCardData = component.get("v.memberCardData");
        if(!$A.util.isUndefinedOrNull(memberCardData) && !$A.util.isEmpty(memberCardData)){
            component.set("v.memberInfo",memberCardData.CoverageLines[policySelectedIndex].patientInfo);
        }

        var claimInput = component.get("v.claimInput");
        console.log('claimInput@@@@@@'+JSON.stringify(claimInput));
        helper.showSpinner(component);
        helper.getClaimData(component, event, helper,0);

	},
    deductibleSelect : function(component, event, helper) {
        helper.showSpinner(component);
        helper.getClaimData(component, event, helper,0);
        var childcomp = component.find("autodoc");
        childcomp.refreshTable(component,event, helper);
        component.set("v.pageNumber", 1);
    },
    appliedSelect : function(component, event, helper) {
        helper.showSpinner(component);
        helper.getClaimData(component, event, helper,0);
        var childcomp = component.find("autodoc");
        childcomp.refreshTable(component,event, helper);
        component.set("v.pageNumber", 1);
    },
    searchValueFunc: function(cmp,event,helper){
        var autoDocChild = cmp.find("autodoc");
        const inputValue = event.getSource().get('v.value');
        autoDocChild.searchFromParent(inputValue);

    },
    commentsShow:function(component, event, helper) {
        component.set("v.showComments",true);
    /*let button = event.getSource();
    button.set("v.disabled", true);*/
    },
    openModal: function(component, event, helper){
        let caseWrapper = component.get("v.caseWrapperMNF");
        //var caseitems = [];
		var extProviderTable = _autodoc.getAutodocComponent(component.get("v.autodocUniqueId"),component.get("v.policySelectedIndex"),'Claim Results');
        if(!$A.util.isUndefinedOrNull(extProviderTable) && !$A.util.isEmpty(extProviderTable)){
            console.log('@@@@@test'+JSON.stringify(extProviderTable.selectedRows[0]));

            var selectedRowdata = extProviderTable.selectedRows[0];
            if(!$A.util.isUndefinedOrNull(selectedRowdata) && !$A.util.isEmpty(selectedRowdata)){
                let selectedClaimNo = selectedRowdata.rowColumnData[0].fieldValue;
                let selectedserviceDate = selectedRowdata.rowColumnData[4].fieldValue;
                var dates = selectedserviceDate.split("-");
                var startDate = dates[0].split("/");
                var claimStartDate;
                if(startDate.length>1)
                    claimStartDate = startDate[2].trim()+"-"+startDate[0].trim()+"-"+startDate[1].trim();

                console.log('@@@@@test'+selectedClaimNo+'---'+claimStartDate);
                caseWrapper.claimNumber = selectedClaimNo;
                caseWrapper.serviceDate = claimStartDate;
            }
        }
        //caseWrapper.caseItems = caseitems;
        var selectedString = _autodoc.getAutodoc(component.get("v.autodocUniqueId"));
        var jsString = JSON.stringify(selectedString);
        caseWrapper.savedAutodoc = jsString;

		var claimDetCout = component.get("v.claimDetailsObj");
        caseWrapper.claimDetails= claimDetCout;

        var claimEngineCode = component.get("v.claimEngineCodeObj");
        caseWrapper.claimEngineCode= claimEngineCode;

        if( !$A.util.isUndefinedOrNull(caseWrapper)){
         	caseWrapper.Comments=component.get("v.commentsValue");
            component.set("v.caseWrapperMNF",caseWrapper);
        }
        component.set("v.isModalOpen",true);
    },
     closeModal: function(component, event, helper) {
        // Set isModalOpen attribute to false
        component.set("v.isModalOpen", false);

    },

    adVClaimChange: function(cmp,event,helper){
        console.log('=advancecliam'+JSON.stringify(cmp.get('v.advClaimInput')));
        var advClaimInput = cmp.get('v.advClaimInput');
        if(advClaimInput.selectedFilter == 'Deductible Only'){
            cmp.set('v.isDeductible',true);
            helper.getDeductibleInfo(cmp,event,helper);
        }
        else{
            cmp.set('v.isDeductible',false);
            helper.getAdVanceReq(cmp,event,helper);
        }


    },

    policySwitched : function(component, event, helper){
		var uniqueTabId = event.getParam("uniqueTabID");
        	var memberId=component.get("v.memberTabId");
            if(!$A.util.isUndefinedOrNull(uniqueTabId) && (memberId!=uniqueTabId))
            return false;
        var sourcecode= event.getParam("sourcecode");
        // Added by Jay - Logic to update isMRlob flag
    if (sourcecode == "CO") {
            component.set("v.isMRlob",true);
    } else {
            component.set("v.isMRlob",false);
        }
        // End of change
        //helper.setDefaultAutodoc(component);

        var autodocClaimResult = component.get("v.autodocClaimResult");

        console.log('policyswitched autodocClaimResult', autodocClaimResult);
        //_autodoc.setAutodoc(component.get("v.autodocUniqueId"), component.get("v.policySelectedIndex"), autodocClaimResult);
    },
    navigateToDetail : function (component, event, helper) {
        helper.setDefaultAutodoc(component); // DE487334 - Thanish - 8th Sept 2021
        //Added by Mani -- Start
        let policyDetails = component.get("v.policyDetails");
        console.log("P:oll"+JSON.stringify(policyDetails));
        let insuranceTypeCode = component.get("v.insuranceTypeCode");
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
        //Added by Mani -- End
        var selectedRowdata = event.getParam("selectedRows");
        var currentRowIndex = event.getParam("currentRowIndex");
        console.log('selectedRowdata in acet_claim_search_result'+JSON.stringify(selectedRowdata));
        console.log('claim number outside if '+ selectedRowdata.rowColumnData[0].fieldValue);
        //write better logic to get claim number
        if (!$A.util.isUndefinedOrNull(selectedRowdata)
            && !$A.util.isUndefinedOrNull(selectedRowdata.rowColumnData)
            && selectedRowdata.rowColumnData.length > 0

           ) {
            console.log('selectedRowdata in acet_claim_search_result'+JSON.stringify(selectedRowdata));
             console.log('claim number inside if '+ selectedRowdata.rowColumnData[0].fieldValue);
            //write better logic to get claim number
            let selectedClaimNo = selectedRowdata.rowColumnData[0].fieldValue;
            let selectedProcessedDate = selectedRowdata.rowColumnData[8].fieldValue;
            let taxId = selectedRowdata.rowColumnData[1].fieldValue;
            let claimStatus = selectedRowdata.rowColumnData[6].fieldValue;
            var claimStatusSet = component.get("v.claimStatusSet");
            let claimStatusSetNew = new Set();
            for (var x in claimStatusSet) {
                 claimStatusSetNew.add(claimStatusSet[x]);
             }
            let isClaimNotOnFile = claimStatusSetNew.has(claimStatus) ? true : false;
            let claimInput = component.get("v.claimInput");
            claimInput.processDate = selectedProcessedDate;
            claimInput.ClaimType = selectedRowdata.additionalData.ClaimType;
            let claimInputTxaId = claimInput.taxId;
            if(taxId != '--'){
                claimInput.taxId = taxId;
            }
            console.log('claimInput####'+JSON.stringify(claimInput));
            let arrClaimSummaryDetails = component.get("v.mapClaimSummaryDetails");
            let selectedClaimDetailCard = arrClaimSummaryDetails.find(v => v.componentName.includes(selectedClaimNo));

            let mapInOutPatientDetails = component.get("v.mapInOutPatientDetails");
            let mapInOutPatientDetail = mapInOutPatientDetails.find(v => v.componentName.includes(selectedClaimNo));

            let arrClaimAdditionalInfo = component.get("v.mapClaimAdditionalInfo");
            let arrClaimAdditionalInfoTable = arrClaimAdditionalInfo.find(v => v.componentName.includes(selectedClaimNo));

            let arrClaimStatusDetails = component.get("v.listClaimStatusDetails");
            let selectedClaimStatusTable = arrClaimStatusDetails.find(v => v.componentName.includes(selectedClaimNo));

            let memberInfoDetails = component.get("v.memberInfoDetails");
            let selectedmemberInfoDetails = memberInfoDetails.find(v => v.claimno.includes(selectedClaimNo));
            console.log("selectedmemberInfoDetails-" + JSON.stringify(selectedmemberInfoDetails));

            console.log("mapClaimSummaryDetails-" + JSON.stringify(selectedClaimDetailCard));
            let PROVIDERID = selectedRowdata.rowColumnData[2].fieldValue;

            //Added by mani --Start-12/22/2019
            let memberID = component.get("v.memberId");
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

            var firstSrvcDt =firstSvcDateParts[2]+'-'+firstSvcDateParts[0]+'-'+firstSvcDateParts[1];

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
                "policyNumber":component.get("v.policyNumber"),
                "platform":selectedmemberInfoDetails.platform,
                "referralId":selectedmemberInfoDetails.referralId,
                "firstSrvcDt":firstSrvcDt,
                "PatientFullName":selectedmemberInfoDetails.ptntFn+' '+selectedmemberInfoDetails.ptntLn
            };
            console.log("relatedDocData-" + JSON.stringify(relatedDocData));
            //Added by mani--End
   //chandra start
               var serviceDates = selectedRowdata.rowColumnData[4].fieldValue;
               var dates = serviceDates.split("-");
               var startDate = dates[0].split("/");
               var endDate = dates[1].split("/");
               var claimStartDate = startDate[2].trim()+"-"+startDate[0].trim()+"-"+startDate[1].trim();
               var claimEndDate = endDate[2].trim()+"-"+endDate[0].trim()+"-"+endDate[1].trim();
              //chandra End

            //Ketki Move to the top begin
            var tableDetails = component.get("v.autodocClaimResult");
            var newBody = [];
            var noRows=[];
            newBody.push(selectedRowdata);
            // US3537364
            for (let i = 0; i < tableDetails.tableBody.length; i++) {
                const element = tableDetails.tableBody[i];
                // if (i != currentRowIndex) {
                //     newBody.push(element);
                // }
                 if(element.caseItemsExtId=='No Matching Claim Results Found')
                            noRows.push(element);
                else if (element.caseItemsExtId != selectedRowdata.caseItemsExtId) {
                    newBody.push(element);
                }
                            }
            tableDetails.tableBody =noRows.concat(newBody);
            component.set("v.autodocClaimResult", tableDetails);
			//Ketki Move to the front end


            //US2876410 ketki 9/11:  Launch Claim Detail Page
            let workspaceAPI = component.find("workspace");
            workspaceAPI.getAllTabInfo().then(function (response) {

                let mapOpenedTabs = component.get('v.TabMap');
                let claimNoTabUniqueId = component.get('v.memberTabId') + selectedClaimNo;
                if ($A.util.isUndefinedOrNull(mapOpenedTabs)) {
                    mapOpenedTabs = new Map();
                }

                //KJ multiple tabs autodoc component order begin
                //let currentIndexOfOpenedTabs = component.get('v.currentIndexOfOpenedTabs');
                let  extProviderTable = _autodoc.getAutodocComponent(component.get("v.autodocUniqueId"),component.get("v.policySelectedIndex"),'Claim Results');
                let currentIndexOfOpenedTabs =extProviderTable.selectedRows.length-1;
                //KJ multiple tabs autodoc component order end

                //Duplicate Found
               /* if (mapOpenedTabs.has(claimNoTabUniqueId)) {
                    //let tabResponse = mapOpenedTabs.get(claimNoTabUniqueId);
                    let tabResponse;
                    if (!$A.util.isUndefinedOrNull(response)) {
                        for (let i = 0; i < response.length; i++) {
                            if (!$A.util.isUndefinedOrNull(response[i].subtabs.length) && response[i].subtabs.length > 0) {
                                for (let j = 0; j < response[i].subtabs.length; j++) {

                                   if(claimNoTabUniqueId === response[i].subtabs[j].pageReference.state.c__claimNoTabUnique)
                                   {

                                    tabResponse = response[i].subtabs[j];
                                    break;
                                   }
                               }
                            }
                        }
                     }

                    workspaceAPI.openTab({
                        url: tabResponse.url
                    }).then(function (response) {
                        workspaceAPI.focusTab({
                            tabId: response
                        });
                    }).catch(function (error) {
                    });
                } else {*/
                    console.log("Opening sub tab for claimNoTabUniqueId "+ claimNoTabUniqueId);
                    // Get selected claim service dates
                    var memberPolicesTOsend = component.get("v.memberPolicies");
                    console.log('===@@@####memberPolices is 202 '+JSON.stringify(component.get("v.memberPolicies")));
					 var selectedPolicy = component.get("v.selectedPolicy");
                    //US3189884 - Sravan - Start
                    var callTopicLstSelected = component.get("v.callTopicLstSelected");
                    var callTopics = [];
                    if(!$A.util.isUndefinedOrNull(callTopicLstSelected) && !$A.util.isEmpty(callTopicLstSelected)){
                        callTopics = JSON.stringify(callTopicLstSelected);
                    }
                    var providerDetails = JSON.stringify(component.get("v.providerDetails"));
                    //US3189884 - Sravan - End
        if(component.get("v.policyDetails").resultWrapper.policyRes.sourceCode == "CO")
        {
            component.set("v.isMRlob",true);
          } else {
            component.set("v.isMRlob",false);
        }
                    workspaceAPI.openSubtab({
                        pageReference: {
                            "type": "standard__component",
                            "attributes": {
                                "componentName": "c__ACET_ClaimDetails"
                            },
                            "state": {
                                "c__claimNo": selectedClaimNo,
                                "c__isClaim": true,
                                "c__resultsTableRowData": selectedRowdata,
                                "c__currentRowIndex":currentRowIndex,
                                "c__claimNoTabUnique": claimNoTabUniqueId,
                                "c__hipaaEndpointUrl": component.get("v.hipaaEndpointUrl"),
                                "c__contactUniqueId": component.get("v.contactUniqueId"),
                                "c__interactionRec": JSON.stringify(component.get('v.interactionRec')),
                                 "c__interactionOverviewTabId": component.get("v.interactionOverviewTabId"),
                                "c__claimInput":claimInput,
                                "c__isMRlob":component.get("v.isMRlob"),
                                "c__mapInOutPatientDetail": JSON.stringify(mapInOutPatientDetail),
                                "c__selectedClaimDetailCard": JSON.stringify(selectedClaimDetailCard),
                                "c__selectedClaimStatusTable": JSON.stringify(selectedClaimStatusTable),
                                "c__contractFilterData": JSON.stringify(contractFilterData),//Added By Mani
                                "c__autodocUniqueId":component.get("v.autodocUniqueId"),
                                "c__autodocUniqueIdCmp":component.get("v.autodocUniqueIdCmp"),
                                "c__caseWrapperMNF":component.get("v.caseWrapperMNF"),
                                //Added chandra for pcp Start
                                "c__componentId":component.get("v.componentId"),
                                "c__memberDOB":component.get("v.memberDOB"),
                                "c__policyDetails":component.get("v.policyDetails"),
                                "c__memberFN":component.get("v.memberFN"),
                                "c__memberCardData":component.get("v.memberCardData"),
                                "c__memberCardSnap":component.get("v.memberCardSnap"),
                                "c__policyNumber":component.get("v.policyNumber"),
                                "c__houseHoldData":JSON.stringify(component.get("v.houseHoldData")),
                                "c__dependentCode":component.get("v.dependentCode"),
                                "c__regionCode":component.get("v.regionCode"),
                                "c__cobData":JSON.stringify(component.get("v.cobData")),
                                "c__secondaryCoverageList":JSON.stringify(component.get("v.secondaryCoverageList")),
                                "c__cobMNRCommentsTable":JSON.stringify(component.get("v.cobMNRCommentsTable")),
                                "c__cobENIHistoryTable":JSON.stringify(component.get("v.cobENIHistoryTable")),
                                "c__houseHoldMemberId":component.get("v.houseHoldMemberId"),
                                "c__memberPolicies": JSON.stringify(memberPolicesTOsend),
                                //"c__memberPolicies": memberPolicesTOsend,
                                "c__policySelectedIndex":component.get("v.policySelectedIndex"),
                                "c__currentPayerId":component.get("v.currentPayerId"),
                                "c__memberautodocUniqueId":component.get("v.memberautodocUniqueId"),
                                "c__autoDocToBeDeleted":component.get("v.autoDocToBeDeleted"),
                                "c__serviceFromDate":claimStartDate,
                                "c__serviceToDate":claimEndDate,
                                //Added chandra for pcp END,
                                "c__memberLN": component.get("v.memberLN"),
                                "c__AuthAutodocPageFeatur": component.get("v.AuthAutodocPageFeature"),
                                "c__authContactName":component.get("v.authContactName"),
                                "c__SRNFlag": component.get("v.SRNFlag"),
                                "c__interactionType": component.get("v.interactionType"),
                                "c__AutodocPageFeatureMemberDtl":component.get("v.AutodocPageFeatureMemberDtl"),
                                "c__AutodocKeyMemberDtl":component.get("v.AutodocKeyMemberDtl"),
                                "c__isHippaInvokedInProviderSnapShot":component.get("v.isHippaInvokedInProviderSnapShot"),
                                "c__noMemberToSearch":component.get("v.noMemberToSearch"),
                                "c__interactionCard":component.get("v.interactionCard"),
                                "c__selectedTabTyp":component.get("v.selectedTabType"),
                                "c__originatorType": component.get("v.originatorType"),
                                "c__memberTabId": component.get("v.memberTabId"),
                                "c__providerId": PROVIDERID,
                                 //KJ multiple tabs autodoc component order begin
                                //"c__currentIndexOfOpenedTabs": component.get("v.currentIndexOfOpenedTabs"),
                                 "c__currentIndexOfOpenedTabs": (extProviderTable.selectedRows.length-1),
                                //KJ multiple tabs autodoc component order end
                                 "c__selectedPolicy":JSON.stringify(selectedPolicy),
                                "c__callTopicOrder":JSON.stringify(component.get("v.callTopicOrder")),
                                "c__planLevelBenefitsRes":JSON.stringify(component.get("v.planLevelBenefitsRes")),
                                "c__eligibleDate":component.get("v.eligibleDate"),
                                "c__highlightedPolicySourceCode":component.get("v.highlightedPolicySourceCode"),
                                "c__isSourceCodeChanged":component.get("v.isSourceCodeChanged"),
                                "c__policyStatus": component.get("v.policyStatus"),
                                "c__isTierOne": component.get("v.isTierOne"),
                                "c__callTopicLstSelected":callTopics,//US3189884 - Sravan
                                "c__callTopicTabId":component.get("v.callTopicTabId"),//US3189884 - Sravan
                                "c__relatedDocData": relatedDocData,
                                "c__providerDetails": providerDetails,
								"c__addClaimType": selectedRowdata.additionalData.ClaimType, //US3502296 - Raviteja - Team Blinkers
								"c__addnetworkStatus": selectedRowdata.additionalData.NetworkStatus, //US3502296 - Raviteja - Team Blinkers
								"c__addbilltype": selectedRowdata.additionalData.billtype, //US3502296 - Raviteja - Team Blinkers
								"c__isClaimNotOnFile": isClaimNotOnFile,
                                "c__selectedAdditionalInfoTable": JSON.stringify(arrClaimAdditionalInfoTable),
                                "c__memberEEID": component.get("v.subjectCard.EEID"), // US3177995 - Thanish - 22nd Jun 2021
                                "c__insuranceTypeCode": component.get("v.insuranceTypeCode"), // US3705824
                                "c__providerDetailsForRoutingScreen": component.get("v.providerDetailsForRoutingScreen"),
                                "c__flowDetailsForRoutingScreen": component.get("v.flowDetailsForRoutingScreen"),
                                "c__selectedIPAValue": component.get("v.selectedIPAValue"),
                                "c__ExploreTaxId": component.get("v.interactionCard.taxId"),
                                "c__contactName" :  component.get("v.contactName"),
                                "c__providerNotFound" :  component.get("v.providerNotFound"),
                                "c__isProviderSearchDisabled" :component.get("v.isProviderSearchDisabled"),
                                "c__isOtherSearch" : component.get("v.isOtherSearch"),
                                "c__contactCard": component.get("v.contactCard"),
                                "c__memberInfo": component.get("v.memberInfo")
                            }
                        },
                        focus: true
                    }).then(function (response) {
                        console.log("After opening sub tab for claimNoTabUniqueId "+ claimNoTabUniqueId);
                        console.log(JSON.stringify(response));

                        //KJ multiple tabs autodoc component order begin

              var info = {};
                        info.indexOfOpenedTab = currentIndexOfOpenedTabs;
                        info.response = response;
                        currentIndexOfOpenedTabs++;
                        component.set('v.currentIndexOfOpenedTabs',currentIndexOfOpenedTabs);
                        //KJ multiple tabs autodoc component order end

                        component.set('v.TabMap', mapOpenedTabs);

                        //mapOpenedTabs.set(claimNoTabUniqueId, response);
                        mapOpenedTabs.set(claimNoTabUniqueId, info);
                        console.log("mapOpenedTabs value "+ JSON.stringify(mapOpenedTabs));
                        component.set('v.TabMap', mapOpenedTabs);
                        workspaceAPI.setTabLabel({
                            tabId: response,
                            label: selectedClaimNo
                        });
                        workspaceAPI.setTabIcon({
                             tabId: response,
                            icon: "custom:custom17",
                            iconAlt: "Claim Detail"
                        });
                    }).catch(function (error) {
                    });
               // }
            }).catch(function (error) {
            });
        }
       //US2876410 ketki 9/11:  Launch Claim Detail Page
    },
    onTabClosed: function (cmp, event) {

        let tabFromEvent = event.getParam("tabId");

        if( !$A.util.isUndefinedOrNull(tabFromEvent)){
            let mapOpenedTabs = cmp.get('v.TabMap');
            let mapEntryToRemove =null ;
            if(!$A.util.isUndefinedOrNull(mapOpenedTabs)){
            	for (let elem of mapOpenedTabs.entries()) {

                	if(tabFromEvent === elem[1] ){
                    	mapEntryToRemove = elem[0];
                    	break;
                		}
            	}
            	if( !$A.util.isUndefinedOrNull(mapEntryToRemove)){
                	mapOpenedTabs.delete(mapEntryToRemove);
                	cmp.set('v.TabMap', mapOpenedTabs);
            	}
           	 }
         }

    },

     enableLink : function (cmp, event) {
        var openedLinkData =event.getParam('arguments').resultsTableRowData;
         var closedClaimDetails =cmp.get("v.closedClaimDetails");
        var tableDetails = cmp.get("v.autodocClaimResult");
        var tableRows = tableDetails.tableBody;
        var selectedRows = cmp.get("v.selectedRows");
        tableRows.forEach(element => {
                        for(var i=0;i<closedClaimDetails.length;i++){
                        if (element.uniqueKey ==closedClaimDetails[i]){
                        element.linkDisabled = false;
                        closedClaimDetails.splice(i, 1);
                        break;
                    }}
                                                  });
        var enabled = [];
        var disabled = [];
         var noRows=[];
        tableRows.forEach(element => {
           if(element.caseItemsExtId == 'No Matching Claim Results Found')
                          noRows.push(element);

            else if (element.linkDisabled) {
                disabled.push(element);
            }  else  {
                enabled.push(element);
            }
        });

        tableDetails.tableBody =noRows.concat(disabled.concat(enabled));
        cmp.set("v.autodocClaimResult",tableDetails);
        for (var i of selectedRows) {
              if (i.uniqueKey == openedLinkData.uniqueKey)
                i.linkDisabled = false;
        }
    },

  getSelectedRecords: function (cmp, event, helper) {
        // DE482674 - Thanish - 1st Sep 2021
        var tableDetails = cmp.get("v.autodocClaimResult");
        if(tableDetails.selectedRows.length > 0){
            helper.setDefaultAutodoc(cmp);
        } else{
            helper.deleteDefaultAutodoc(cmp);
        }

         //ketki retain selected record begin
     	 var data = event.getParam("selectedRows");
       	 console.log("KJ log selecter rows "+ JSON.stringify(data) );
   		 //ketki retain selected record end

    //Save Case Consolidation - US3505075 - Nikhil
    var claimResults = cmp.get("v.autodocClaimResult");
    if ($A.util.isEmpty(data)) {
      claimResults.hasUnresolved = false;
      cmp.set("v.autodocClaimResult", claimResults);
    }
    var hasUnresolved = !$A.util.isEmpty(claimResults) && claimResults.hasUnresolved != undefined ? claimResults.hasUnresolved : false;
    cmp.set("v.disableButtons", !hasUnresolved);
    if (cmp.get("v.disableButtons")) {
      cmp.set("v.showComments", false);
      cmp.set("v.commentsValue", "");
    }
    // DE477063 - Thanish - 13th Aug 2021
    //helper.setDefaultAutodoc(cmp);
    //US1983608
    if(data.length>1){
        cmp.set("v.disableClaimLauncher",false); 
    }else{
        cmp.set("v.disableClaimLauncher",true);
        
    }
  },

   /* enableLink : function (cmp, event) {
        var currentRowIndex = event.getParam("currentRowIndex");
        console.log('currentRowIndex =>' + currentRowIndex);
        var tableDetails = cmp.get("v.autodocClaimResult");
        var tableRows = tableDetails.tableBody;
        tableRows[currentRowIndex].linkDisabled = false;
        tableDetails.tableBody = tableRows;
        cmp.set("v.autodocClaimResult",tableDetails);
    },*/
    getPreview: function(cmp, event, helper){
        // DE482674 - Thanish - 1st Sep 2021 helper.setDefaultAutodoc(cmp);
        var selectedString01 = _autodoc.getAutodoc(cmp.get("v.autodocUniqueId"));
       console.log('selectedstring',selectedString01);
        cmp.set("v.tableDetails_prev",selectedString01);
        cmp.set("v.showpreview",true);
    },
    getResults : function(component,event,helper) {
        var pageNum = event.getParam('requestedPageNumber');
         component.set("v.pageNumber",pageNum);
        console.log('pageNum', pageNum);
		 //helper.showSpinner(component);
        var result = component.get("v.paginationClaimResult");
        var startnumber = ((pageNum-1)*100)>0?((pageNum-1)*100):0;
        var EndNumber = (result.tableBody.length-startnumber)>100?startnumber+100:result.tableBody.length;
        var tempresult = {};
        if(pageNum>1){
         helper.showSpinner(component);
        for (var x in result) {
            var t=result[x];
            tempresult[x] = t;
            if(x=='tableBody'){
                var temparray = [];
                for(var i=startnumber; i<EndNumber;i++){
                    temparray.push(result.tableBody[i]);
                }
                tempresult.tableBody = temparray;
                tempresult.startNumber=startnumber+1;
                tempresult.endNumber=EndNumber;
                 console.log('tmpresultinsideif+++', JSON.stringify(tempresult));
            }
		}
            tempresult.startNumber=startnumber+1;
            tempresult.endNumber=EndNumber;
            console.log('tmpresultoutsideif+++', JSON.stringify(tempresult));
            component.set("v.autodocClaimResult",tempresult);
            helper.hideSpinner(component);
    }
        console.log('tempresult',tempresult);
        if(pageNum==1){
            helper.showSpinner(component);
        var extProviderTable = _autodoc.getAutodocComponent(component.get("v.autodocUniqueId"),component.get("v.policySelectedIndex"),'Claim Results');
        for (var x in result) {
            var t=result[x];
            tempresult[x] = t;
            if(x=='tableBody'){
                var temparray = [];
                for(var i=startnumber; i<EndNumber;i++){
                    temparray.push(result.tableBody[i]);
                }
                tempresult.tableBody = temparray;
                tempresult.startNumber=startnumber+1;
                tempresult.endNumber=EndNumber;
            }
		}

        /*for(var y in extProviderTable){
            console.log('y',y);
            console.log('yy',extProviderTable[y]);
        }
        for(var y in extProviderTable.selectedRows){
            console.log(y);
            console.log(extProviderTable.selectedRows[y]);
        }*/
        let prevSelectedClaimRows = [];
            //if condition not empty
        if(extProviderTable !=null && extProviderTable.selectedRows!=null && extProviderTable.selectedRows.length>0){
            for(var i in extProviderTable.selectedRows){
                prevSelectedClaimRows.push(extProviderTable.selectedRows[i]);
            }
            console.log('beforeprevSelectedClaimRows',prevSelectedClaimRows);
        }
        for(var z=0;z<tempresult.tableBody.length;z++){
        prevSelectedClaimRows.push(tempresult.tableBody[z]);
        }
        tempresult.tableBody = prevSelectedClaimRows;
        component.set("v.autodocClaimResult",tempresult);
        console.log('afterprevSelectedClaimRows',prevSelectedClaimRows);
            helper.hideSpinner(component);
    }
        //helper.hideSpinner(component);
    },
    //KJ clear button functionality begin
    clearTable: function (cmp, event, helper) {

        var tempArry = [];
        var tableDetails = cmp.get("v.autodocClaimResult");
        if (!$A.util.isEmpty(tableDetails)) {
            var tableRows = tableDetails.tableBody;
            for (var i in tableRows) {
                var tableRow = tableRows[i];

                if (tableRow.checked) {
                    tempArry.push(tableRow);
                }
            }
        }

        tableDetails.startNumber = tempArry.length > 0 ? 1 : 0;
        tableDetails.endNumber = tempArry.length;
        tableDetails.recordCount = tempArry.length;
        tableDetails.noOfPages = 1;

        tableDetails.tableBody = tempArry;
        cmp.set("v.autodocClaimResult", tableDetails);
    },
     //KJ clear button functionality end
    switchClaimsNo: function (cmp, event, helper) {
        cmp.set("v.showWarning",false);
        cmp.set("v.isCheckboxDisabled",true);
        var claimResult = cmp.get("v.autodocClaimResult");
        var claimRes = JSON.stringify(claimResult.tableBody);
        console.log('claimResult@@@@@@'+claimRes);
        for(var i=0; i<claimResult.tableBody.length;i++){
            if(claimResult.tableBody[i].checked != true){
                claimResult.tableBody[i].checkBoxDisabled = true;
                claimResult.tableBody[i].linkDisabled = true;
            }
        }
        claimResult.startNumber=claimResult.tableBody.length > 0 ? 1 : 0;
        cmp.set("v.autodocClaimResult",claimResult);
    },
    switchClaimsYes: function (component, event, helper) {
        component.set("v.showWarning",false);
        component.set("v.isClaim",true);
        component.set("v.isCheckboxDisabled",false);
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
        //var selectedMemberFirstName= 'MURPHY';
        //var selectedMemberLasttName= 'RUDZEK';
        var selectedMemberId = component.get("v.claimsMemberId");
        var selectedMemberDob = component.get("v.claimsMemberDob");
        var selectedMemberFirstName=  component.get("v.claimsMemberFirstname");
        var selectedMemberLasttName= component.get("v.claimsMemberLastname");
        var policyDateRange= component.get("v.claimsServiceDates");
       // var policyNbr= component.get("v.claimspolicyNbr");
        var memUniqueId =  selectedMemberId + selectedMemberDob + selectedMemberFirstName;



        // US2060237	Other Card Validation - Snapshot - Other (Third Party) - 10/10/2019 - Sarma
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
                                    "c__providerNotFound": providerNotFound,
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
                                    "c__policyDateRange": policyDateRange,
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
                } else { //Tab focus for opened tabs
                    //Sanpshot - opned tabs
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

        // Ketki open member snapshot for claim end
    },
    
        handleAutodocRefresh: function (cmp, event, helper) {
            if (event.getParam("autodocUniqueId") == cmp.get("v.autodocUniqueId")) {
                cmp.set("v.disableButtons", true);
                cmp.set("v.showComments", false);
                cmp.set("v.commentsValue", "");
            }
        },

  // US3507751 - Save Case Consolidation
  createCaseWrapper: function (cmp, event, helper) {
    var autodocUniqueId = event.getParam("autodocUniqueId");
    console.log('%cFrom Event => ' + autodocUniqueId, 'color:red');
    if (autodocUniqueId == cmp.get("v.autodocUniqueId")) {
      helper.caseWrapperHelper(cmp, event, helper);
	}
    },
      getClaimDetails:function (cmp, event, helper) {
          console.log('event.getParam'+JSON.stringify(event.getParams()));
          var claimDetCout=cmp.get("v.claimDetailsObj");
          var claimDetails = new Object();
          claimDetails.flnNumber = event.getParam("dccFlnNbr");  
          claimDetails.claimNumber =   event.getParam("claimNumber");
          claimDetails.claimEngineCode = event.getParam("claimEngineCode");
          claimDetCout.push(claimDetails);
          cmp.set("v.claimDetailsObj", claimDetCout);
  },
  //US1983608
  launchSelectedClaim:function (cmp, event, helper) { 
    var selectedRows = cmp.get("v.selectedRows");
          
          var closedClaimDetails =cmp.get("v.closedClaimDetails");
          var tableDetails = cmp.get("v.autodocClaimResult");
          var tableRows = tableDetails.tableBody;
          var selectedRows = cmp.get("v.selectedRows");
          const map1 = new Map();
          
          //var disableSelectedClaims = [];
          var landing =false;
          console.log('qq>>'+selectedRows);
          for(var i=0;i<selectedRows.length;i++)
          {
              if(i==0){
                  landing =true;  
              }
              if(!selectedRows[i].linkDisabled) 
              helper.navigateToDetail(cmp, event, helper,i); 
              // disableSelectedClaims[i] = selectedRows[i];
          }
          
          for(var i=0;i<selectedRows.length;i++){
              map1.set(selectedRows[i].uniqueKey,selectedRows[i]);
          }
          console.log(JSON.stringify(map1));
          for(var i=0;i<tableRows.length;i++){
              if (map1.get(tableRows[i].uniqueKey)){
                  tableRows[i].linkDisabled = true; 
              }
          }
        var enabled = [];
        var disabled = [];
        tableRows.forEach(element => {
          if (element.linkDisabled) {
                disabled.push(element);
            }  else  {
                enabled.push(element);
            }
        });
        tableDetails.tableBody =disabled.concat(enabled);
        cmp.set("v.autodocClaimResult",tableDetails);
         // childcomp.refreshTable(component,event, helper);
      }
})