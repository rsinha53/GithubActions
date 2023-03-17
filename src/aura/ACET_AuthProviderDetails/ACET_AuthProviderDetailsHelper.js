({
    setTableData: function(cmp) {
        var authDetailsObj = cmp.get("v.authDetailsObj");
        var tableDetails = new Object();
        tableDetails.type = "table";
         var currentIndexOfOpenedTabs = cmp.get("v.currentIndexOfOpenedTabs");
        var maxAutoDocComponents = cmp.get("v.maxAutoDocComponents");
        var claimNo=cmp.get("v.claimNo");
         var currentIndexOfAuthOpenedTabs=cmp.get("v.currentIndexOfAuthOpenedTabs");
         var maxAutoDocAuthComponents=cmp.get("v.maxAutoDocAuthComponents");
         if(cmp.get("v.isClaimDetail")){
        tableDetails.autodocHeaderName = "Provider Details: " + cmp.get("v.SRN")+": "+claimNo;
        tableDetails.componentOrder = 16.07 +(maxAutoDocComponents*currentIndexOfOpenedTabs)+(maxAutoDocAuthComponents*currentIndexOfAuthOpenedTabs);
        tableDetails.componentName = "Provider Details: " + cmp.get("v.SRN")+": "+claimNo;
         }
        else{
        tableDetails.autodocHeaderName = "Provider Details: " + cmp.get("v.SRN");
        tableDetails.componentOrder = 10;
        tableDetails.componentName = "Provider Details: " + cmp.get("v.SRN");
        }
        tableDetails.componentName = 'Provider Details';
        tableDetails.showComponentName = false;
        tableDetails.tableHeaders = [
            "Role", "Name/Status", "TIN", "NPI", "MPIN", "Address", "Region", "Vanity City", "Specialty", "Steerage"
        ];
        tableDetails.tableBody = [];

        var i = 0; var pro;
        for(pro of authDetailsObj.providers){
            // US2969157 - TECH - View Authorization Enhancements for new auto doc framework - Sarma - 7/10/2020
            // Null check in each level of object nodes to prevent exception
            let vanitycity = "--";
            let steerage = "--";
            let role = "--";
            let nameStatus = "--";
            let address = "--";
            let specialtyTypeDesc = "--";

            if(!$A.util.isEmpty(pro.roleRendered)) {
                role = pro.roleRendered;
            }
            if(!$A.util.isEmpty(pro.nameStatusRendered)) {
                nameStatus = pro.nameStatusRendered;
            }
            if(!$A.util.isEmpty(pro.addressRendered)) {
                address = pro.addressRendered;
            }
            if(!$A.util.isEmpty(pro.specialtyTypeDesc)) {
                specialtyTypeDesc = pro.specialtyTypeDesc;
            }

            if(!$A.util.isEmpty(pro.address) && !$A.util.isEmpty(pro.address.vanitycity)) {
                vanitycity = pro.address.vanitycity;
            }
            if(!$A.util.isEmpty(pro.networkSteerageReason) && !$A.util.isEmpty(pro.networkSteerageReason.description)) {
                steerage = pro.networkSteerageReason.description;
            }
            var row = {
                "checked" : false,
                "uniqueKey" : i,
                "rowColumnData" : [
                    {
                        "isOutputText" : true,
                        "fieldLabel" : "Role",
                        "fieldValue" : (role.length > 20) ? role.substring(0,20) + "..." : role,
                        "titleName" : role,
                        "key" : i,
                        "isReportable": true // US2834058 - Thanish - 13th Oct 2020
                    },
                    {
                        "isLink": true, //US3653687
                        "fieldLabel" : "Name/Status",
                        "fieldValue" : (nameStatus.length > 20) ? nameStatus.substring(0,20) + "..." : nameStatus,
                        "titleName" : nameStatus,
                        "key" : i,
                        "isReportable": true // US2834058 - Thanish - 13th Oct 2020
                    },
                    {
                        "isOutputText" : true,
                        "fieldLabel" : "TIN",
                        "fieldValue" : $A.util.isEmpty(pro.tin) ? "--" : pro.tin,
                        "key" : i,
                        "isReportable": true // US2834058 - Thanish - 13th Oct 2020
                    },
                    {
                        "isOutputText" : true,
                        "fieldLabel" : "NPI",
                        "fieldValue" : $A.util.isEmpty(pro.npi) ? "--" : pro.npi,
                        "key" : i,
                        "isReportable": true // US2834058 - Thanish - 13th Oct 2020
                    },
                    {
                        "isOutputText" : true,
                        "fieldLabel" : "MPIN",
                        "fieldValue" : $A.util.isEmpty(pro.mpin) ? "--" : pro.mpin,
                        "key" : i,
                        "isReportable": true // US2834058 - Thanish - 13th Oct 2020
                    },
                    {
                        "isOutputText" : true,
                        "fieldLabel" : "Address",
                        "fieldValue" : (address.length > 20) ? address.substring(0,20) + "..." : address,
                        "titleName" : address,
                        "key" : i,
                        "isReportable": true // US2834058 - Thanish - 13th Oct 2020
                    },
                    {
                        "isOutputText" : true,
                        "fieldLabel" : "Region",
                        "fieldValue" : $A.util.isEmpty(pro.region) ? "--" : pro.region,
                        "key" : i,
                        "isReportable": true // US2834058 - Thanish - 13th Oct 2020
                    },
                    {
                        "isOutputText" : true,
                        "fieldLabel" : "Vanity City",
                        "fieldValue" : vanitycity,
                        "key" : i,
                        "isReportable": true // US2834058 - Thanish - 13th Oct 2020
                    },
                    {
                        "isOutputText" : true,
                        "fieldLabel" : "Specialty",
                        "fieldValue" : (specialtyTypeDesc.length > 20) ? specialtyTypeDesc.substring(0,20) + "..." : specialtyTypeDesc,
                        "titleName" : specialtyTypeDesc,
                        "key" : i,
                        "isReportable": true // US2834058 - Thanish - 13th Oct 2020
                    },
                    {
                        "isOutputText" : true,
                        "fieldLabel" : "Steerage",
                        "fieldValue" : steerage,
                        "key" : i,
                        "isReportable": true // US2834058 - Thanish - 13th Oct 2020
        }
                ]
            }
            // US3653575
				row.caseItemsExtId = cmp.get("v.isClaimDetail") ? claimNo : cmp.get("v.SRN");
            //US3653687
            row.providerDetails = pro.providerDetails;
            tableDetails.tableBody.push(row);
            i++;
        }
        if( i == 0){
            var row = {
                "checked" : false,
                "uniqueKey" : 0,
                "rowColumnData" : [
                    {
                        "isNoRecords" : true,
                        "fieldLabel" : "No Records",
                        "fieldValue" : "No Records Found",
                        "key" : 0,
                        "isReportable": true //US3653575
                    }
                ]
        }
            // US3653575
			row.caseItemsExtId = cmp.get("v.isClaimDetail") ? claimNo : cmp.get("v.SRN");
            tableDetails.tableBody.push(row);
        }
        cmp.set("v.tableDetails", tableDetails);
    },

    //US3653687
    navigateToDetails: function (cmp, event, helper) {
        var selectedRowdata = event.getParam("selectedRows");
        var currentRowIndex = event.getParam("currentRowIndex");
        var providerDetails = new Object();
        providerDetails.taxId = selectedRowdata.providerDetails.taxId;
        providerDetails.providerId = selectedRowdata.providerDetails.providerId;
        providerDetails.addressSequence = selectedRowdata.providerDetails.addressSequence;
        providerDetails.isPhysician = selectedRowdata.providerDetails.isPhysician;

        var tabUniqueKey = providerDetails.taxId + providerDetails.providerId + providerDetails.addressSequence;

        var rowData = new Object();
        rowData.caseItemsExtId = cmp.get("v.isClaimDetail") ? claimNo : cmp.get("v.SRN");

        var memberDetails = new Object();
        memberDetails.noMemberToSearch = false;

        let memberCardData = cmp.get('v.memberCardData');
        let policySelectedIndex = cmp.get('v.policySelectedIndex');
        var insuranceTypeCode = '';
        if (!$A.util.isEmpty(memberCardData)) {
            console.log(JSON.stringify(memberCardData.CoverageLines[policySelectedIndex]));
            if (!$A.util.isUndefinedOrNull(memberCardData.CoverageLines[policySelectedIndex])) {
                if (!$A.util.isUndefinedOrNull(memberCardData.CoverageLines[policySelectedIndex].insuranceTypeCode)) {
                    insuranceTypeCode = memberCardData.CoverageLines[policySelectedIndex].insuranceTypeCode;
                }
                if (!$A.util.isUndefinedOrNull(memberCardData.CoverageLines[policySelectedIndex].patientInfo)) {
                    memberDetails.memberId = memberCardData.CoverageLines[policySelectedIndex].patientInfo.MemberId;
                }
            }
        }

        let policyDetails = cmp.get("v.policy");
        let contractFilterData = {};
        if (!$A.util.isEmpty(policyDetails)) {
            contractFilterData = {
                "productType": policyDetails.resultWrapper.policyRes.productType,
                "marketSite": policyDetails.resultWrapper.policyRes.marketSite,
                "marketType": policyDetails.resultWrapper.policyRes.marketType,
                "cosmosDiv": policyDetails.resultWrapper.policyRes.cosmosDivision,
                "providerDiv": policyDetails.resultWrapper.policyRes.providerDiv,
                "cosmosPanelNbr": policyDetails.resultWrapper.policyRes.groupPanelNumber,
                "policyNumber": policyDetails.resultWrapper.policyRes.policyNumber,
                "subscriberID": policyDetails.resultWrapper.policyRes.subscriberID,
                "coverageLevelNum": policyDetails.resultWrapper.policyRes.coverageLevelNum,
                "insuranceTypeCode": insuranceTypeCode
            }
        }
        var workspaceAPI = cmp.find("workspace");
        workspaceAPI.openSubtab({
            pageReference: {
                "type": "standard__component",
                "attributes": {
                    "componentName": "c__ACET_ProviderLookupDetails"
                },
                "state": {
                    "c__slectedRowLinkData": null, //not used
                    "c__providerID": providerDetails.providerId,
                    "c__interactionRec": cmp.get("v.interactionRec"),
                    "c__memberDetails": memberDetails,
                    "c__noMemberToSearch": false,
                    "c__providerNotFound": cmp.get("v.providerNotFound"),//no
                    "c__providerDetails": providerDetails,
                    "c__sourceCode": cmp.get("v.sourceCode"),//no
                    "c__autodocPageFeature": cmp.get("v.autodocUniqueId"),
                    "c__autodocKey": cmp.get("v.autodocUniqueId"),
                    "c__currentRowIndex": currentRowIndex,
                    "c__provSearchResultsUniqueId": null,
                    "c__resultsTableRowData": rowData,
                    "c__contactUniqueId": cmp.get("v.contactUniqueId"),
                    "c__contractFilterData": contractFilterData,//no
                    "c__isProviderSnapshot": false,
                    "c__hipaaEndpointUrl": cmp.get("v.hipaaEndpointUrl"),
                    "c__providerDetailsForRoutingScreen": null,
                    "c__flowDetailsForRoutingScreen": null,
                    "c__autodocUniqueId": cmp.get("v.autodocUniqueId"),
                    "c__autodocUniqueIdCmp": cmp.get("v.autodocUniqueIdCmp"),
                    "c__claimNo": cmp.get("v.claimNo"),
                    "c__currentIndexOfOpenedTabs": cmp.get("v.currentIndexOfOpenedTabs"),
                    "c__maxAutoDocComponents": cmp.get("v.maxAutoDocComponents"),
                    "c__interactionOverviewTabId": cmp.get("v.interactionOverviewTabId"),
                    "c__isClaim": cmp.get("v.isClaimDetail"),
                    "c__transactionId": cmp.get("v.policy.resultWrapper.policyRes.transactionId"),
                    "c__callTopicLstSelected": "{}",
                    "c__tabUniqueKey": tabUniqueKey
                }
            },
            focus: true
        }).then(function (subtabId) {
            workspaceAPI.setTabLabel({
                tabId: subtabId,
                label: selectedRowdata.providerDetails.FullName
            });
            workspaceAPI.setTabIcon({
                tabId: subtabId,
                icon: "custom:custom55",
                iconAlt: "Provider Lookup Details"
            });
            var openedTabs = cmp.get("v.openedTabs");
            openedTabs[subtabId] = currentRowIndex;
            cmp.set("v.openedTabs", openedTabs);

        }).catch(function (error) {
            console.log(error);
        })
    }

})