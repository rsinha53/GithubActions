({
    processData: function(cmp, event, helper) {
        if(!$A.util.isUndefinedOrNull(cmp.get("v.facilityDetails").providers)){
            var providers = cmp.get("v.facilityDetails").providers;
            var orgName = '--';
            var Status = '--';
            for(var i=0;i<providers.length;i++){
                if(!$A.util.isUndefinedOrNull(providers[i].categoryCode)){
                    if(providers[i].categoryCode == 'H'){
                        if(!$A.util.isUndefinedOrNull(providers[i].organizationName)){
                            orgName = providers[i].organizationName;
                        }
                        if(!$A.util.isUndefinedOrNull(providers[i].networkStatusType.description)){
                            Status = providers[i].networkStatusType.description;
                        }
                        break;
                    }
                }
            }

            // US2300701	Enhancement View Authorizations and Notifications - Inpatient/Outpatient Details UI (Specific Fields)  - Sarma - 20/01/2020
            var finalText = orgName + ' / ' + Status;

            cmp.set('v.hoverText', "");

            if(finalText.length > 20){
                cmp.set('v.hoverText', finalText);
                finalText =  finalText.substring(0, 20) + "...";
                cmp.set('v.finalText', finalText);
            } else{
                cmp.set('v.finalText', finalText);
            }
        }

        let descList =[
        'AN - Process based on provider\'s network status. The admitting physician is paid based on the provider\'s network status.' ,
        'AS - Process services at the INN/higher benefit level. All non-network health care providers will be reimbursed at the network level based on billed charges or the repriced amount.',
        //'OS - Process services at the OON/lower benefit level. All providers will be reimbursed at the OON level of benefits regardless of the provider\'s network status.' ,
        //'SS - Process based on claim comments.' ,
        'DC - Services do not meet coverage requirements for one of the following reasons: \r\n- The requested services are not covered based on a medical policy \r\n- Member does not active coverage. \r\n- The services ares not covered by the members plan.  \r\n- There is no benefit for the service or the service is excluded from coverage.',
        'DI - Services denied for lack of information received.',
        'DM - Services not medically necessary.',
        'DS - Services are covered and/or medically necessary but have not been approved to be performed in the location (site) requested.',
        //US2598259 - View Authorizations - Add MD to Claim Remark Code Hover - Durga -START
        'MD - The inpatient stay was deemed not medically necessary.',
        'OS - Process services at the OON/lower benefit level. All providers will be reimbursed at the OON level of benefits, regardless of the provider\'s network status.',
        'SS - Process based on claim comments.',
        //US2598259 - View Authorizations - Add MD to Claim Remark Code Hover - Durga -END
        'ZZ - Prior Authorization/Notification Cancelled.' ];

            cmp.set('v.descList',descList);

            helper.setCardDetails(cmp);
    },
	// US2300701	Enhancement View Authorizations and Notifications - Inpatient/Outpatient Details UI (Specific Fields)  - Sarma - 20/01/2020
    // Purpose - To show or hide hover popup depending on its current state.
	togglePopup : function(cmp, event) {
		let showPopup = event.currentTarget.getAttribute("data-popupId");
		cmp.find(showPopup).toggleVisibility();
	},
    //Swapna
     selectAll: function (cmp, event) {
       var checked = event.getSource().get("v.checked");
        var cardDetails = cmp.get("v.cardDetails");
        var cardData = cardDetails.cardData;
        for (var i of cardData) {
            if (i.showCheckbox && !i.defaultChecked) {
                i.checked = checked;
            }
        }
        cmp.set("v.cardDetails", cardDetails);
        //_autodoc.setAutodoc(cmp.get("v.autodocUniqueId"), cardDetails);
        _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"),cmp.get("v.autodocUniqueIdCmp"), cardDetails);
    },
    //Swapna
    // US2917421
    handleNameClick: function (cmp, event, helper) {
        var workspaceAPI = cmp.find("workspace");
        workspaceAPI.getTabInfo({
            tabId: cmp.get("v.tabId")
        }).then(function (response) {
            if (!$A.util.isEmpty(response)) {
                var details = cmp.get("v.facilityDetails");
                console.log(JSON.stringify(details));
                if (!$A.util.isEmpty(details) && !$A.util.isEmpty(details.providers)) {
                    // DE428952
                    for (var i = 0; i < details.providers.length; i++) {
                        if (!$A.util.isUndefinedOrNull(details.providers[i].categoryCode)) {
                            if (details.providers[i].categoryCode == 'H') {
                                var faciltyData = details.providers[i];
                    var searchObject = new Object();
                    searchObject.taxId = faciltyData.tin;
                    searchObject.lastName = faciltyData.organizationName;
                    searchObject.npi = faciltyData.npi;
                    searchObject.firstName = '';
                    searchObject.providerType = 'Facility';
                    var addrId = '000000000' + faciltyData.providerIdentifiers[1].id;
                    searchObject.addressId = addrId.slice(-9);
                    console.log('Auth Addr Seq ' + searchObject.addressId);

                    var appEvent = $A.get("e.c:ACET_AuthFacilityHeaderClickEvt");
                    appEvent.setParams({
                        "searchObject": searchObject,
                        "tabId": cmp.get("v.tabId")
                    });
                    appEvent.fire();
                                break;
                            }
                        }
                    }

                    // var faciltyData = details.providers[0];
                    // var searchObject = new Object();
                    // searchObject.taxId = faciltyData.tin;
                    // searchObject.lastName = faciltyData.organizationName;
                    // searchObject.npi = faciltyData.npi;
                    // searchObject.firstName = '';
                    // searchObject.providerType = 'Facility';
                    // searchObject.addressId = faciltyData.providerIdentifiers[1].id;

                    // var appEvent = $A.get("e.c:ACET_AuthFacilityHeaderClickEvt");
                    // appEvent.setParams({
                    //     "searchObject": searchObject,
                    //     "tabId": cmp.get("v.tabId")
                    // });
                    // appEvent.fire();

                    workspaceAPI.focusTab({tabId : cmp.get("v.tabId")});
                }
            }
        }).catch(function (err) {
            console.log('Cannot access hyperlink because Member Snapshot Page has been closed');
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": "error",
                "message": "Cannot access hyperlink because Member Snapshot Page has been closed",
                "duration": "5000",
                "mode": "dismissible"
            });
            toastEvent.fire();
        });
    }

})