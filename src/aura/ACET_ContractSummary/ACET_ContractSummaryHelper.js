({
    getCNSContracts: function (cmp, event, helper) {
        cmp.set("v.showSpinner", true);
        let parameters = cmp.get("v.contractApiParameters");

        if(!($A.util.isEmpty(parameters.providerId) && $A.util.isEmpty(parameters.taxId) && $A.util.isEmpty(parameters.addressId))){
            let action = cmp.get("c.getFacetsCSNContractsData");
            action.setParams({
                "providerId": parameters.providerId,
                "taxId": parameters.taxId,
                "addressId": parameters.addressId,
                "isActive": false
            });

            action.setCallback(this, function (response) {
                let table = response.getReturnValue();
                if (response.getState() === "SUCCESS") {
                    if (table.success) {
                        table.originalTableBody = table.tableBody;
                        cmp.set("v.cnsTable", table);
                        // filter cns table
                        var cnsTable = cmp.get("v.cnsTable");
                        if(cmp.get("v.isCNSAll")) {
                            cnsTable.tableBody = cnsTable.originalTableBody;
                        } else {
                            cnsTable.tableBody = this.filterActiveDataForCAndS(false, cnsTable.originalTableBody);
                        }
                        if (!$A.util.isEmpty(cnsTable) && $A.util.isEmpty(cnsTable.tableBody)) {
                            cnsTable.tableBody = this.setEmptyRow(cnsTable.tableBody);
                        }
                        cmp.set("v.cnsTable", cnsTable);

                        var claimNo = cmp.get("v.claimNo");
                var maxAutoDocComponents = cmp.get("v.maxAutoDocComponents");
                var currentIndexOfOpenedTabs = cmp.get("v.currentIndexOfOpenedTabs");

               // console.log("claimNo in Active"+claimNo);
               // console.log("isClaim in bef Active"+component.get("v.isClaim"));
               if(cmp.get("v.isClaim")){
                //  console.log("isClaim in  afer Active"+cmp.get("v.isClaim"));
              //  var affData=JSON.stringify(cmp.get("v.affData"));
                                 //  var cspProviderStatus=component.get("v.cspProviderStatus");

              // console.log("affData in  afer Active"+cmp.get("v.affData"));
                cnsTable.componentName=cnsTable.componentName+": "+claimNo;
				cnsTable.autodocHeaderName=cnsTable.autodocHeaderName+": "+claimNo;
                  cnsTable.componentOrder=20.08+(maxAutoDocComponents*currentIndexOfOpenedTabs);
                  console.log("currentIndexOfOpenedTabs of cnsTable"+cnsTable.componentOrder);

                }
                    } else {
                        this.showToastMessage("We hit a snag.", table.message, "error", "dismissible", "30000");
                        /*let toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Error!",
                            "message": "Failed to retrieve C&S Contract Data! : " + table.message,
                            "type": "error",
                            "mode": "pester",
                            "duration": "10000"
                        });
                        toastEvent.fire();*/
                    }

                } else {
                    this.showToastMessage("We hit a snag.", table.message, "error", "dismissible", "30000");
                    /*let toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": "Failed to connect to Contract Service!",
                        "type": "error",
                        "mode": "pester",
                        "duration": "10000"
                    });
                    toastEvent.fire();*/
                }
                cmp.set("v.showSpinner", false);
            });
            $A.enqueueAction(action);
        }
    },

    getENIContracts: function (cmp, event, helper) {
        cmp.set("v.showSpinner", true);
        let parameters = cmp.get("v.contractApiParameters");

        if(!($A.util.isEmpty(parameters.providerId) && $A.util.isEmpty(parameters.taxId) && $A.util.isEmpty(parameters.addressSeq))){
            let action = cmp.get("c.getENIContractsData");
            action.setParams({
                "providerId": parameters.providerId,
                "taxId": parameters.taxId,
                "addressSeq": parameters.addressSeq,
                "isActive": false
            });

            action.setCallback(this, function (response) {
                let table = response.getReturnValue();
                if (response.getState() === "SUCCESS") {
                    if (table.success) {
                        table.originalTableBody = table.tableBody;
                        cmp.set("v.eniTable", table);
                        // filter eni table
                        var eniTable = cmp.get("v.eniTable");
                        cmp.set("v.ENIAllData", eniTable.originalTableBody); //US3767751

                        if(cmp.get("v.isENIAll")) {
                            eniTable.tableBody = eniTable.originalTableBody;
                        } else {
                            eniTable.tableBody = this.filterENIAccordingToMember(cmp, eniTable.originalTableBody);
                        }
                        if (!$A.util.isEmpty(eniTable) && $A.util.isEmpty(eniTable.tableBody)) {
                            eniTable.tableBody = this.setEmptyRow(eniTable.tableBody);
                        }
                        cmp.set("v.eniTable", eniTable);

                        var claimNo = cmp.get("v.claimNo");
                        var maxAutoDocComponents = cmp.get("v.maxAutoDocComponents");
                        var currentIndexOfOpenedTabs = cmp.get("v.currentIndexOfOpenedTabs");

                        if(cmp.get("v.isClaim")){
                            eniTable.componentName=eniTable.componentName+": "+claimNo;
                            eniTable.autodocHeaderName=eniTable.autodocHeaderName+": "+claimNo;
                            eniTable.componentOrder=20.08+(maxAutoDocComponents*currentIndexOfOpenedTabs);
                             console.log("currentIndexOfOpenedTabs of eniTable"+eniTable.componentOrder);

                        }

                    } else {
                        this.showToastMessage("We hit a snag.", table.message, "error", "dismissible", "30000");
                        /*let toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Error!",
                            "message": "Failed to retrieve E&I Contract Data! : " + table.message,
                            "type": "error",
                            "mode": "pester",
                            "duration": "10000"
                        });
                        toastEvent.fire();*/
                    }
                } else {
                    this.showToastMessage("We hit a snag.", table.message, "error", "dismissible", "30000");
                    /*let toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": "Failed to connect to Contract Service!",
                        "type": "error",
                        "mode": "pester",
                        "duration": "10000"
                    });
                    toastEvent.fire();*/
                }
                cmp.set("v.showSpinner", false);
            });
            $A.enqueueAction(action);
        }
    },

    getMNRContracts: function (cmp, event, helper) {
        cmp.set("v.showSpinner", true);
        let parameters = cmp.get("v.contractApiParameters");

        if(!($A.util.isEmpty(parameters.providerId) && $A.util.isEmpty(parameters.taxId) && $A.util.isEmpty(parameters.addressId))){
            let action = cmp.get("c.getMNRContractsData");
            action.setParams({
                "providerId": parameters.providerId,
                "taxId": parameters.taxId,
                "addressId": parameters.addressId,
                "isActive": false
            });

            action.setCallback(this, function (response) {
                let table = response.getReturnValue();
                if (response.getState() === "SUCCESS") {
                    if (table.success) {
                        table.originalTableBody = table.tableBody;
                        cmp.set("v.mnrTable", table);
                        // filter mnr table
                        var mnrTable = cmp.get("v.mnrTable");
                        if(cmp.get("v.isMNRAll")) {
                            mnrTable.tableBody = mnrTable.originalTableBody;
                        } else {
                            mnrTable.tableBody = this.filterMNRAccordingToMember(cmp, mnrTable.originalTableBody);
                        }
                        if (!$A.util.isEmpty(mnrTable) && $A.util.isEmpty(mnrTable.tableBody)) {
                            mnrTable.tableBody = this.setEmptyRow(mnrTable.tableBody);
                        }
                        cmp.set("v.mnrTable", mnrTable);
						var claimNo = cmp.get("v.claimNo");
                        var maxAutoDocComponents = cmp.get("v.maxAutoDocComponents");
                        var currentIndexOfOpenedTabs = cmp.get("v.currentIndexOfOpenedTabs");

                        if(cmp.get("v.isClaim")){
                            mnrTable.componentName=mnrTable.componentName+": "+claimNo;
                            mnrTable.autodocHeaderName=mnrTable.autodocHeaderName+": "+claimNo;
                            mnrTable.componentOrder=20.08+(maxAutoDocComponents*currentIndexOfOpenedTabs);
                            console.log("currentIndexOfOpenedTabs of mnrTable"+mnrTable.componentOrder);

                        }
                    } else {
                        this.showToastMessage("We hit a snag.", table.message, "error", "dismissible", "30000");
                        /*let toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Error!",
                            "message": "Failed to retrieve M&R Contract Data! : " + table.message,
                            "type": "error",
                            "mode": "pester",
                            "duration": "10000"
                        });
                        toastEvent.fire();*/
                    }
                } else {
                    this.showToastMessage("We hit a snag.", table.message, "error", "dismissible", "30000");
                    /*let toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": "Failed to connect to Contract Service!",
                        "type": "error",
                        "mode": "pester",
                        "duration": "10000"
                    });
                    toastEvent.fire();*/
                }
                cmp.set("v.showSpinner", false);
            });
            $A.enqueueAction(action);
        }
    },

    getPHSContracts: function(cmp){
        this.initiateEmptyPhsTable(cmp);
    },

    // filter only active contract summary
    filterActiveData: function (isAll, tbody) {
        if (!$A.util.isEmpty(tbody)) {
            if (!isAll && (tbody[0].rowColumnData[0].fieldLabel != "NO RECORDS")) {
                return tbody.filter(function (row) {
                    return (row.rowColumnData[1].iconName == "action:approval" && row.rowColumnData[2].fieldValue == "UHN");
                });
            }
        }
        return tbody;
    },
    
    setEmptyRow: function(tbody) {
        tbody = [{
            "checkBoxDisabled": false,
            "caseItemsExtId": "No Contract Summary Active UHN Results",
            "checked": false,
            "linkDisabled": false,
            "resolved": false,
            "rowColumnData": [{
                "fieldLabel": "NO RECORDS",
                "fieldValue": "No Contract Summary Active UHN Results",
                "isIcon": false,
                "isLink": false,
                "isNoRecords": true,
                "isOutputText": false,
                "tdStyle": "",
                "titleName": "",
                "isReportable": true
            }],
            "uniqueKey": "emptyrow"
        }];
        return tbody;
    },

    // filter only active contract summary for C AND S Policies
    filterActiveDataForCAndS: function (isAll, tbody) {
        if (!$A.util.isEmpty(tbody)) {
            if (!isAll && (tbody[0].rowColumnData[0].fieldLabel != "NO RECORDS")) {
                return tbody.filter(function (row) {
                    return (row.rowColumnData[2].iconName == "action:approval");
                });
            }
        }
        return tbody;
    },

    filterENIAccordingToMember: function (cmp, tbody) {
        if (!$A.util.isEmpty(tbody)) {
            if (!cmp.get("v.isENIAll") && (tbody[0].rowColumnData[0].fieldLabel != "NO RECORDS")) {
                /*if (cmp.get("v.isMemberFocused")) {
                    let filterParameters = cmp.get("v.filterParameters");
                    return tbody.filter(function (row) {
                        let marketSite = row.rowColumnData[5].fieldValue.split("-");
                        return (filterParameters.productType == row.rowColumnData[3].fieldValue || parseInt(filterParameters.marketSite) == parseInt(marketSite[0]) || filterParameters.marketType == row.rowColumnData[4].fieldValue);
                    });
                } else {*/
                return this.filterActiveData(cmp.get("v.isENIAll"), tbody);
                //}
            }
        }
        return tbody;
    },

    filterMNRAccordingToMember: function (cmp, tbody) {
        if (!$A.util.isEmpty(tbody)) {
            if (!cmp.get("v.isMNRAll") && (tbody[0].rowColumnData[0].fieldLabel != "NO RECORDS")) {
                /*if (cmp.get("v.isMemberFocused")) {
                    let filterParameters = cmp.get("v.filterParameters");
                    return tbody.filter(function (row) {
                        return (filterParameters.cosmosDiv == row.rowColumnData[3].fieldValue || filterParameters.cosmosPanelNbr == row.rowColumnData[4].fieldValue);
                    });
                } else {*/
                return tbody.filter(function (row) {
                    return (row.rowColumnData[1].iconName == "action:approval");
                });
                //}
            }
        }
        return tbody;
    },

    // assigning empty table for phs as it is an api gap
    initiateEmptyPhsTable: function (cmp) {
        var phsTable = {
            "autodocHeaderName": "PHS Contract Summary",
            "componentName": "PHS Contract Summary",
            "componentOrder": 0,
            "isSortable": true,
            "caseItemsEnabled": true,
            "message": "Success",
            "severity": {},
            "showComponentName": false,
            "statusCode": 200,
            "success": true,
            "tableBody": [{
                "checkBoxDisabled": false,
                "caseItemsExtId": "No Contract Summary Active UHN Results",
                "checked": false,
                "linkDisabled": false,
                "resolved": false,
                "rowColumnData": [{
                    "fieldLabel": "NO RECORDS",
                    "fieldValue": "No Contract Summary Active UHN Results",
                    "isIcon": false,
                    "isLink": false,
                    "isNoRecords": true,
                    "isOutputText": false,
                    "tdStyle": "",
                    "titleName": "",
                    "isReportable": true
                }],
                "uniqueKey": "phs0"
            }],
            "tableHeaders": [
              "CONTRACT ID",
              "STATUS",
              "ORG",
              "NETWORK ID",
              "DEC #",
              "PMG",
              "RISK",
              "PMG CRITERIA",
              "EFFECTIVE-CANCEL",
              "TYPE",
              "NEW PATIENTS?"
            ],
            "type": "table"
        }
        let today = new Date();
        let popupId = today.getTime();
        phsTable.tableHoverHeaders = [{
                "popupId": popupId + "contractId",
                "headerValue": "CONTRACT ID"
            },
            {
                "popupId": popupId + "status",
                "headerValue": "STATUS"
            },
            {
                "popupId": popupId + "org",
                "hasHover": true,
                "headerValue": "ORG",
                "alignRight": false,
                "hoverWidth": "600px",
                "hoverDescription": "See below for description:",
                "hoverDescriptionList": [
                    "HPHC - Harvard Pilgrim",
                    "UHN - UnitedHealthcare, CSP/GSP, NHP, River Valley, Beacon LBS, National Provider (Product code-CON), Nexus ACO, Charter/Navigate/Compass",
                    "UBH - United Behavioral Health",
                    "ACN - OptumHealth Physical Health (Formerly ACN [American Chiropractic Network] Group) American Chiropractic Network",
                    "MEDI - Medica"
                ]
            },
            {
                "popupId": popupId + "networkId",
                "headerValue": "NETWORK ID"
            },
            {
                "popupId": popupId + "desNum",
                "headerValue": "DEC #"
            },
            {
                "popupId": popupId + "pmg",
                "headerValue": "PMG"
            },
            {
                "popupId": popupId + "risk",
                "headerValue": "RISK"
            },
            {
                "popupId": popupId + "pmgCriteria",
                "headerValue": "PMG CRITERIA"
            },
            {
                "popupId": popupId + "effCancel",
                "headerValue": "EFFECTIVE-CANCEL"
            },
            {
                "popupId": popupId + "type",
                "headerValue": "TYPE"
            },
            {
                "popupId": popupId + "newPatients",
                "hasHover": true,
                "headerValue": "NEW PATIENTS?",
                "alignRight": true,
                "hoverWidth": "430px",
                "hoverDescription": "See below for description:",
                "hoverDescriptionList": [
                    "N - No new patients accepted",
                    "Y - New patients are being accepted",
                    "E - New patients accepted on exception basis only",
                    "R - Accepting new patients with restrictions (age, gender, etc)."
                ]
            }
        ];
        cmp.set("v.phsTable", phsTable);
        var claimNo = cmp.get("v.claimNo");
        var maxAutoDocComponents = cmp.get("v.maxAutoDocComponents");
        var currentIndexOfOpenedTabs = cmp.get("v.currentIndexOfOpenedTabs");

        if(cmp.get("v.isClaim")){
            phsTable.componentName=phsTable.componentName+": "+claimNo;
            phsTable.autodocHeaderName=phsTable.autodocHeaderName+": "+claimNo;
            phsTable.componentOrder=20.08+(maxAutoDocComponents*currentIndexOfOpenedTabs);
             console.log("currentIndexOfOpenedTabs of phsTable"+phsTable.componentOrder);

        }

    },
    
    noRecordFound: function (cmp,tableBody,tabType) {
        var selectedTab = cmp.get("v.selectedTab");
        if(tableBody.tableBody[0].rowColumnData[0].fieldLabel=='NO RECORDS'){
            if(tabType) {
                tableBody.tableBody[0].rowColumnData[0].fieldValue="No Contract Summary Results Found";
                tableBody.tableBody[0].caseItemsExtId='No Contract Summary Results Found';
            }
            else {
                tableBody.tableBody[0].rowColumnData[0].fieldValue="No Contract Summary Active UHN Results";
                tableBody.tableBody[0].caseItemsExtId='No Contract Summary Active UHN Results';
            }
        if(selectedTab=='CNS')
            cmp.set("v.cnsTable", tableBody);
        else if(selectedTab=='ENI')
            cmp.set("v.eniTable", tableBody);
            else  if(selectedTab=='MNR')
                cmp.set("v.mnrTable", tableBody);
                else
                    cmp.set("v.phsTable", tableBody);
        }
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
    }
})