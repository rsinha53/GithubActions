({
    onLoad: function (component, event, helper) {
        // DE307193 - Thanish 20th March 2020
        component.set("v.cmpUniqueId", new Date().getTime());

        helper.getProviderData(component, event, helper, 0);
        var provDetails = component.get("v.providerDetails");
        var policyDetails = component.get("v.policyDetails");
    },
        
    searchLookups: function (component, event, helper) {
        helper.getProviderData(component, event, helper, 0);
    },

    openTTSPopup  : function(component, event, helper){
        // US2543182 - Thanish - 13th May 2020
		if(component.get("v.AutodocKey") == event.getParam("autodocKey")) {
			component.set("v.routingSOPLinkClicked", event.getParam("linkClicked"));
			component.set("v.isTTSModalOpen", event.getParam("openPopup"));
		}
    },

    getProviderLookupInputs: function (component, event, helper) {
        var searchResults = event.getParam('prvLookupInputs');
    },
    
    openCommentsBox : function (component, event, helper) {
        component.set("v.isCommentsBox",true);
        component.set("v.disableCommentButton",true);
    },
    
    togglePopup : function(cmp, event) {
        let showPopup = event.currentTarget.getAttribute("data-popupId");
        cmp.find(showPopup).toggleVisibility();
    },
    
    handleKeyup : function(cmp) {
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

    saveCase : function(cmp, event, helper) {
        //US2634539: AutoDoc for provider lookup results Praveen CR Start
        var autoDocKey = cmp.get("v.AutodocPageFeature");
        var tabKey = cmp.get("v.AutodocKey");
        var cmpid = cmp.get('v.componentId');

        //DE347278 -  componentId attribute null check
        if((cmpid !== undefined || cmpid !== null) && !cmp.get('v.isProviderSnapshot')){
            document.getElementById(cmp.get('v.componentId')).setAttribute("data-auto-doc-feature", tabKey + "providerLookupResults");
            document.getElementById(tabKey+tabKey+'memberdetailsclone').setAttribute("data-auto-doc-feature", tabKey + "providerLookupResults");
            document.getElementById(tabKey+tabKey+'memberdetailsclone2').setAttribute("data-auto-doc-feature", tabKey + "providerLookupResults");
        }

        //US2634539: AutoDoc for provider lookup results Praveen CR End

        // US2320729 - Thanish - 2nd Mar 2020 - to toggle auto doc multiple pages attribute in provider search results programatically
        cmp.set("v.providerSearchResultsADMultiplePages", true);
        // US2543737 - Thanish - 22nd Apr 2020
        cmp.set("v.AutodocPageFeatureMemberDtl", cmp.get("v.autodocPageFeature"));
        cmp.set("v.AutodocKeyMemberDtl", cmp.get("v.AutodocKey"));

        // US2712146
        helper.fireCallTopicAutodoc(cmp, event, helper);

        // US2098661 - Thanish - 19th Mar 2020 - temperary selected provider, remove once ORS for multiple selected provider is implelemented
        let selectedProvider = cmp.get("v.selectedProvider");
        let caseWrapper = cmp.get("v.caseWrapper");

        if(!$A.util.isEmpty(selectedProvider)) {
            let name = selectedProvider.providerName.split(' ');
            let address = selectedProvider.address.split(',');
            caseWrapper.plFirstName = name[0];
            caseWrapper.plLastName = name[2];
            caseWrapper.plFirstInitial = '';
            caseWrapper.plMpin = '';
            caseWrapper.plProviderID = selectedProvider.providerId;
            caseWrapper.plState = address[address.length - 2];
            caseWrapper.plStreet1 = address[0];
            caseWrapper.plStreet2 = address[1];
            caseWrapper.plZip = address[address.length - 1];
            caseWrapper.plTaxId = selectedProvider.taxId;
            caseWrapper.plTaxPrefix = '';
            caseWrapper.plTaxSuffix = '';
            caseWrapper.phoneNumber = selectedProvider.EffectivePhoneNumber;////US2784325 - TECH: Case Details - Caller ANI/Provider Add'l Elements Mapped to ORS - Durga
        	caseWrapper.providerInfoCity =  selectedProvider.AddressCity;
        }

        if(!cmp.get("v.isProviderSnapshot")) {
            // if member snapshot, do the following
            let sourceCode = cmp.get("v.sourceCode");
            if(!$A.util.isEmpty(sourceCode)) {

                if(sourceCode == 'AP') {
                    // if C&S member, no ORS case will be created
                    caseWrapper.createORSCase = false;
                } else {
                    // if other than C&S member, ORS case will be created
                    caseWrapper.createORSCase = true;

                    let memberData = cmp.get("v.memberDetails");
                    if(!$A.util.isEmpty(memberData)) {
                        caseWrapper.SubjectAge = memberData.age;
                    }
                }
            }
        }

        cmp.set("v.caseWrapper", caseWrapper);
        // US2098661 - Thanish - 19th Mar 2020 - End of Code

        cmp.set("v.isTTSModalOpen", true);
    },

    // US1958733
    initComplete_Event: function (component, event, helper) {
        var settings = event.getParam("settings");
    },

    handledtcallbackevent: function (component, event, helper) {
        var settings = event.getParam("settings");
        var lgt_dt_table_ID = event.getParam("lgt_dt_table_ID");

        // US2431041 - Thanish - 28th Apr 2020 - removed unwanted code
    },

    handlecreatedRow_Event: function (cmp, event, helper) {
        var row = event.getParam("row");
        var data = event.getParam("data");

        // DE307193 - Thanish - 20th Mar 2020
        $(row).addClass(data.addressId);

        // US2098661 - Thanish - 19th Mar 2020 - temperary selected provider, remove once ORS for multiple selected provider is implelemented
        if($A.util.isEmpty(cmp.get("v.selectedProvider"))) {
            cmp.set("v.selectedProvider", data);
        }
        
        $(row).find("td:eq(4)").html("<a id='' href='javascript:void(0);'>" + data.providerName + "</a>");
        
        if (data.uhpd == 'Y') {
            var effciencyString = data.effRatingCd + ' - ' + data.effRatingDesc + ' ' + data.qualityRatingCd + ' - ' + data.qualityRatingDesc;
            var uhpdHtml = '<div class="tooltip">' + data.uhpd + '<span class="tooltiptext">' + effciencyString + '</span></div>';
            $(row).find("td:eq(3)").html(uhpdHtml);
        }else if(data.uhpd == 'N'){
            var uhpdHtml = '<div class="tooltip">' + data.uhpd + '<span class="tooltiptext">NOT EVALUATED</span></div>';
            $(row).find("td:eq(3)").html(uhpdHtml);
        }else{
            $(row).find("td:eq(3)").html(data.uhpd);
        }
        
        
        //Address
        var addressSubstring = data.address.substring(0,20) + '...';
        $(row).find("td:eq(6)").html(addressSubstring);
        $(row).find("td:eq(6)").attr("title", data.address);
        
        if (data.selectedProvider == true) {
            $(row).find("td:eq(4)").addClass("disabledLink");
            $(row).find("td:eq(4)").html('<a class="disabledLink">' + data.providerName + '</a>');
        }
        $(row).find("td:eq(4)").on('click', function (e) {
            // DE356017 - Thanish - 13th Aug 2020 - ignore if the link is disabled...
            if(e.currentTarget.getElementsByClassName("disabledLink").length == 0){
            // test
            if (data.selectedProvider == undefined) {
                var selectedProvs = cmp.get("v.selectedProviders");
                data.selectedProvider = true;
                selectedProvs.push(data);
                cmp.set("v.selectedProviders", selectedProvs);
            }
            
            // US2431041 - Thanish - 23rd Apr 2020
            //helper.handleCellClick(e);
            helper.handleCellClickforTab(e); //US2544945:  Provider Lookup - Detail Page Logic -Durga
            
            $(this).html('<a class="disabledLink">' + data.providerName + '</a>');
            // US1958736 - Thanish - 6th Feb 2020
            var memberDetails = cmp.get("v.memberDetails");
            if($A.util.isEmpty(memberDetails)) {
                memberDetails = new Object();
            }
            memberDetails.noMemberToSearch = cmp.get("v.noMemberToSearch");
            
            var providerDetails = new Object();
            providerDetails.providerId = data.providerId;
            providerDetails.taxId = data.taxId;
            // US1958736 - Thanish - 5th Feb 2020
            providerDetails.addressSequence = data.addressSequence;
            providerDetails.addressId = data.addressId;
            providerDetails.isNiceProvider = data.isNiceProvider;
            
            // US2320729 - Thanish - 26th Feb 2020
            let pageFeature = cmp.get("v.autodocPageFeature");
            let autodocKey = cmp.get("v.AutodocKey");
            // US2623985 - Thanish - 10th Jun 2020
            let policyDetails = cmp.get("v.policyDetails");
            let contractFilterData = {};

            //  US2696849 - Thanish - 22nd Jul 2020
            let memberCardData = cmp.get('v.memberCardData');
            let policySelectedIndex = cmp.get('v.policySelectedIndex');
            var insuranceTypeCode = '';
            if(!$A.util.isEmpty(memberCardData)){
                if (!$A.util.isUndefinedOrNull(memberCardData.CoverageLines[policySelectedIndex])) {
                    if (!$A.util.isUndefinedOrNull(memberCardData.CoverageLines[policySelectedIndex].insuranceTypeCode)) {
                        insuranceTypeCode = memberCardData.CoverageLines[policySelectedIndex].insuranceTypeCode;
                    }
                }
            }

            if(!$A.util.isEmpty(policyDetails)){
                contractFilterData = {
                    "productType": policyDetails.resultWrapper.policyRes.productType,
                    "marketSite": policyDetails.resultWrapper.policyRes.marketSite,
                    "marketType": policyDetails.resultWrapper.policyRes.marketType,
                    "cosmosDiv": policyDetails.resultWrapper.policyRes.cosmosDivision,
                    "cosmosPanelNbr": policyDetails.resultWrapper.policyRes.groupPanelNumber,
                    "policyNumber": policyDetails.resultWrapper.policyRes.policyNumber, //  US2696849 - Thanish - 22nd Jul 2020
                    "subscriberID": policyDetails.resultWrapper.policyRes.subscriberID, //  US2696849 - Thanish - 22nd Jul 2020
                    "coverageLevelNum": policyDetails.resultWrapper.policyRes.coverageLevelNum, //  US2696849 - Thanish - 22nd Jul 2020
                    "insuranceTypeCode": insuranceTypeCode //  US2696849 - Thanish - 22nd Jul 2020
                }
            }

                var workspaceAPI = cmp.find("workspace");
                workspaceAPI.getEnclosingTabId().then(function (enclosingTabId) {
                    workspaceAPI.openSubtab({
                        parentTabId: enclosingTabId,
                        pageReference: {
                            "type": "standard__component",
                            "attributes": {
                                "componentName": "c__ACET_ProviderLookupDetails"
                            },
                            "state": {
                                "c__interactionRec": cmp.get("v.interactionRec"),
                                "c__memberDetails": memberDetails,
                                "c__noMemberToSearch": cmp.get("v.noMemberToSearch"),
                                "c__providerNotFound": cmp.get("v.providerNotFound"),
                                "c__providerDetails": providerDetails,
                            "c__isPhysician": data.isPhysician,
                            "c__sourceCode": cmp.get("v.sourceCode"),
                                "c__autodocPageFeature": pageFeature,
                                "c__autodocKey": autodocKey,
                                "c__provSearchResultsUniqueId": cmp.get("v.cmpUniqueId"), // DE307193 - Thanish 20th March 2020
                                "c__resultsTableRowData": data, // DE307193 - Thanish 20th March 2020
                                "c__contactUniqueId": cmp.get("v.contactUniqueId"),
                                // US2623985 - Thanish - 10th Jun 2020
                                "c__contractFilterData": contractFilterData,
                                "c__isProviderSnapshot": cmp.get("v.isProviderSnapshot"),
                                "c__hipaaEndpointUrl":cmp.get("v.hipaaEndpointUrl"),//US2076634 - Sravan - 22/06/2020
                                "c__providerDetailsForRoutingScreen": cmp.get("v.providerDetailsForRoutingScreen"),//US2740876 - Sravan
                                "c__flowDetailsForRoutingScreen": cmp.get("v.flowDetailsForRoutingScreen")//US2740876 - Sravan
                        }
                    },
                    focus: true
                }).then(function (subtabId) {
                    // US2718112 - Thanish - 2nd Jul 2020
                    var openedLookupDetails = cmp.get("v.openedLookupDetails");
                    openedLookupDetails.push(subtabId);

                    // DE351685 - Thanish - 29th Jul 2020
                    $(row).find("td:eq(5)").addClass(subtabId);

                    workspaceAPI.setTabLabel({
                        tabId: subtabId,
                        label: data.providerName
                    });
                    workspaceAPI.setTabIcon({
                        tabId: subtabId,
                        icon: "custom:custom55",
                        iconAlt: "Provider Lookup Details"
                    });
                }).catch(function (error) {
                    console.log(error);
                });
            });
            }
        });

        // DE330069 - Thanish - 11th Jun 2020
        $(row).on('click', function (e) {
            setTimeout(function(){
                let tdList = e.currentTarget.getElementsByTagName("td");
                let autodocCheckbox = tdList[0].getElementsByTagName("input")[0];
                if(autodocCheckbox.checked){
                    $A.util.addClass(e.currentTarget, "clickedRow");
                } else{
                    $A.util.removeClass(e.currentTarget, "clickedRow");
                }
            }, 10);
        });
        $(row).find("td:eq(0)").on('click', function (e) {
            helper.handleCellClick(e);
        });
        $(row).find("td:eq(1)").on('click', function (e) {
            helper.handleCellClick(e);
        });
        $(row).find("td:eq(2)").on('click', function (e) {
            helper.handleCellClick(e);
        });
        $(row).find("td:eq(3)").on('click', function (e) {
            helper.handleCellClick(e);
        });
        $(row).find("td:eq(5)").on('click', function (e) {
            helper.handleCellClick(e);
        });
        $(row).find("td:eq(6)").on('click', function (e) {
            helper.handleCellClick(e);
        });
        $(row).find("td:eq(7)").on('click', function (e) {
            helper.handleCellClick(e);
        });
        $(row).find("td:eq(8)").on('click', function (e) {
            helper.handleCellClick(e);
        });
        $(row).find("td:eq(9)").on('click', function (e) {
            helper.handleCellClick(e);
        });
    },

    handle_dt_pageNum_Event: function (component, event, helper) {
        var pgnum = event.getParam("pageNumber");
        component.set("v.pageNumber", pgnum);

        // US2431041 - Thanish - 23rd Apr 2020
        let providerSearchResultsTable = document.getElementById(component.get("v.autodocPageFeature"));
        let rows = providerSearchResultsTable.getElementsByTagName("tr");
        let row;
        for(row of rows) {
            let thList = row.getElementsByTagName("td");
            if(thList.length > 0) {
                let rsvldTH = thList[thList.length - 1];
                let rsvldcheckbox = rsvldTH.getElementsByTagName("input")[0];

                // DE330061 - Thanish - 20th May 2020
                rsvldTH.onclick = function(e) {
                    let elementList = thList[0].getElementsByClassName("autodoc");
                    let autodocCheckbox;
                    for(autodocCheckbox of elementList) {
                        if(autodocCheckbox.getAttribute("type") == "checkbox") {

                            if(rsvldcheckbox.checked) {
                                autodocCheckbox.disabled = true;
                            } else if(autodocCheckbox.checked) {
                                autodocCheckbox.disabled = false;
                            } else {
                                // do nothing ...
                            }
                        }
                    }
                };

                // DE330061 - Thanish - 20th May 2020
                let autodocTH = thList[0];
                autodocTH.onclick = function() {
                    let autodocCheckbox = autodocTH.getElementsByTagName("input")[0];
                    if(!$A.util.isEmpty(autodocCheckbox)){
                        if(autodocCheckbox.checked) {
                            $A.util.addClass(autodocTH.parentNode, "clickedRow");
                        } else {
                            $A.util.removeClass(autodocTH.parentNode, "clickedRow");
                        }
                    }
                };
            }
        }

        // DE330069 - Thanish - 11th Jun 2020
        let thCheckboxList = rows[0].getElementsByTagName("th")[0].getElementsByTagName("input");
        if(thCheckboxList.length > 0){
            let thCheckbox = thCheckboxList[0];

            thCheckbox.onclick = function(e){
                if(!e.currentTarget.checked){
                    setTimeout(function(){
                        let clickedRows = providerSearchResultsTable.getElementsByClassName("clickedRow");
                        let clickedRow;
                        for(clickedRow of clickedRows) {
                            clickedRow.getElementsByTagName("td")[0].getElementsByTagName("input")[0].disabled = false;
                            $A.util.removeClass(clickedRow, "clickedRow");
                        }
                    }, 50);
                }
            };
        }

    },

    openModel: function (component, event, helper) {
        //US2634539:AutoDoc for provider lookup results Praveen CR
        var autoDocKey = component.get("v.AutodocPageFeature");
        var tabKey = component.get("v.AutodocKey");
        var cmpid = component.get('v.componentId');

        // US2712146
        //DE347278 -  componentId attribute null check
        if((cmpid !== undefined || cmpid !== null) && !component.get('v.isProviderSnapshot')){
            document.getElementById(component.get('v.componentId')).setAttribute("data-auto-doc-feature", tabKey + "providerLookupResults");
            document.getElementById(tabKey+tabKey+'memberdetailsclone').setAttribute("data-auto-doc-feature", tabKey + "providerLookupResults");
            document.getElementById(tabKey+tabKey+'memberdetailsclone2').setAttribute("data-auto-doc-feature", tabKey + "providerLookupResults");
        }
        // US2712146
        helper.fireCallTopicAutodoc(component, event, helper);

        //US2634539:AutoDoc for provider lookup results Praveen CR
        var isHippaInvokedInProviderSnapShot = component.get("v.isHippaInvokedInProviderSnapShot");
        console.log(isHippaInvokedInProviderSnapShot);
        if(isHippaInvokedInProviderSnapShot){
            document.getElementById(tabKey+'HIPPA').setAttribute("data-auto-doc-feature",tabKey + 'providerLookupResults');
        }


        // US2320729 - Thanish - 2nd Mar 2020 - to toggle auto doc multiple pages attribute in provider search results programatically
        component.set("v.providerSearchResultsADMultiplePages", true);
        // US2543737 - Thanish - 22nd Apr 2020
        component.set("v.AutodocPageFeatureMemberDtl", component.get("v.autodocPageFeature"));
        component.set("v.AutodocKeyMemberDtl", component.get("v.AutodocKey"));

        component.set("v.isModalOpen", true);
    },

    // DE307193 - Thanish - 20th Mar 2020
    handleLookupDetailsClosed: function (cmp, event) {
        let provSearchResultsUniqueId = event.getParam("provSearchResultsUniqueId");

        if(provSearchResultsUniqueId == cmp.get("v.cmpUniqueId")) {
            let closedTabId = event.getParam("closedTabId");
            let lookupResultsRowData = event.getParam("lookupResultsTableRowData");
            let searchTaxId = cmp.get("v.providerDetails.taxId");

            if(searchTaxId == lookupResultsRowData.taxId) {
                let rowLink = document.getElementsByClassName(closedTabId);
                if(rowLink.length > 0) {
                    $A.util.removeClass(rowLink[0].firstChild, 'disabledLink');
                }

            } else {
                let row = document.getElementsByClassName(lookupResultsRowData.addressId);
                if(row.length > 0) {
                    row[0].style.display = "none";
                }
            }

            let selectedProviders = cmp.get("v.selectedProviders");
            let index;
            for(index = 0; index < selectedProviders.length; index++) {
                if(selectedProviders[index].addressId == lookupResultsRowData.addressId) {
                    selectedProviders.splice(index, 1);
                    cmp.set("v.selectedProviders", selectedProviders);
                    break;
                }
            }
        }
    },

    activeToggle : function(component,event,helper){
        var activeState = ! component.get("v.isOnlyActive");
        component.set("v.isOnlyActive",activeState);
        helper.getProviderData(component, event, helper, 0);
    },
    providerLookupAutoDocHandler : function(component,event,helper){
        // US2634539: AutoDoc for provider lookup results Praveen CR
        var setPageNum = $A.get("e.c:ACET_providerLookupSetPageNum");
        setPageNum.setParams({
            "providerPageNumber" : component.get("v.pageNumber"),
            "tableIdPrvd" : component.get("v.lgt_dt_table_ID")+'_section'
        });
        setPageNum.fire();
    },
    showToast : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Information!",
            "type": "warning",
            "message": "Update your search criteria and try your search again."
        });
        toastEvent.fire();
    }

})