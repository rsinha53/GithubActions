({
    //close tab after refreshing tab or logout session
    closeInteractionOverviewTabs: function (cmp, event) {
        var workspaceAPI = cmp.find("workspace");
        workspaceAPI.getAllTabInfo().then(function (response) {
                if (!$A.util.isEmpty(response)) {
                    for (var i = 0; i < response.length; i++) {
                        var focusedTabId = response[i].tabId;
                        workspaceAPI.closeTab({
                            tabId: focusedTabId
                        });
                    }
                }
            })
            .catch(function (error) {
                console.log(error);
            });
    },
    
    copyTextHelper : function(component,event,text) {
        debugger;
        // Create an hidden input
        var hiddenInput = document.createElement("input");
        // passed text into the input
        hiddenInput.setAttribute("value", text);
        // Append the hiddenInput input to the body
        document.body.appendChild(hiddenInput);
        // select the content
        hiddenInput.select();
        // Execute the copy command
        document.execCommand("copy");
        // Remove the input from the body after copy text
        document.body.removeChild(hiddenInput); 
        // store target button label value
        var orignalLabel = event.getSource().get("v.label");
        // change button icon after copy text
        //event.getSource().set("v.iconName" , 'utility:check');
        // change button label with 'copied' after copy text 
        event.getSource().set("v.label" , 'copied');
        
        // set timeout to reset icon and label value after 700 milliseconds 
        setTimeout(function(){ 
            //event.getSource().set("v.iconName" , 'utility:copy_to_clipboard'); 
            event.getSource().set("v.label" , orignalLabel);
        }, 700);
        
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
    // US1909477 - Thanish (30th July 2019)
 	// Purpose - Add misdirect button to page header.
 	// Copied from SAE_MisdirectHelper.js
	openMisDirect:function(component,event,helper){
        /**/
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getEnclosingTabId().then(function(enclosingTabId) {
            if(enclosingTabId == false){
                workspaceAPI.openTab({
                    pageReference: {
                        "type": "standard__component",
                        "attributes": {
                            "componentName": "c__SAE_MisdirectComponent" // c__<comp Name>
                        },
                        "state": {
                        }
                    },
                    focus: true
                }).then(function(response) {            
                    workspaceAPI.getTabInfo({
                        tabId: response
                    }).then(function(tabInfo) {
                        console.log("The recordId for this tab is: " + tabInfo.recordId);
                        var focusedTabId = tabInfo.tabId;
                        workspaceAPI.setTabLabel({
                            tabId: focusedTabId,
                            label: "Misdirect"
                        });
                        // US1831550 Thanish (Date: 5th July 2019) start {
                        workspaceAPI.setTabIcon({
                            tabId: focusedTabId,
                            icon: "standard:decision",
                            iconAlt: "Misdirect"
                        });
                        // } US1831550 Thanish end
                    });
                }).catch(function(error) {
                    console.log(error);
                });
            }else{
				// US1889740 - Sarma (Date: 1st Aug 2019) - Misdirect Case creation : passing data to misdirect tab via page ref. 
                //var originatorName =  component.get('v.originatorName');
                //Remove the follwing if part once provider search is implemented.
                //As no provider serach & member not found scenario giving undefined undefined as provider name, it's been hard coded.
                //if(originatorName=='undefined  undefined'){
                //originatorName = 'DAVID LOTSOFF';
                //}
                //removing above code as provider search has been implemented - Sarma
                //US1974270	Pilot -Misdirect Case Creation - Multiple Members Searches Revised - Sarma : Start
                var originatorType,originatorObj,originatorName;
                if(component.get("v.isProviderSearch") && !component.get("v.isProviderSearchDisabled")){
                    originatorObj = component.get("v.interactionCard");
                    originatorName = originatorObj.firstName + ' ' + originatorObj.lastName;
                } else if(component.get("v.isOtherSearch")){
                    originatorObj = component.get("v.otherDetails");
                    originatorName = originatorObj.firstName + ' ' + originatorObj.lastName;
                } else {
                    originatorName = component.get('v.memberFullName');
                }
                //US1974270 : End - Also page reference params
                workspaceAPI.openSubtab({
                    parentTabId: enclosingTabId,
                    pageReference: {
                        "type": "standard__component",
                        "attributes": {
                            "componentName": "c__SAE_MisdirectComponent" // c__<comp Name>
                        },
                        "state": {                          
                            "c__originatorName": originatorName,
                            "c__originatorType":'',
                            "c__contactName": component.get('v.contactName'),
                            "c__contactNumber": component.get('v.contactNumber'),
                            "c__subjectName": component.get('v.memberFullName'),                                                       
                            "c__subjectType": 'Member',
                            "c__subjectDOB": component.get('v.memberDOB'),
                            "c__subjectID": component.get('v.memberId'),
                            "c__subjectGrpID": component.get('v.memberGrpN'),
                            "c__interactionID": component.get('v.interactionID'),
                            "c__mnf": component.get('v.mnf'),
                            "c__isMms": component.get('v.isMms'),
                            "c__contactUniqueId": component.get('v.interactionID'),
							"c__focusedTabId": enclosingTabId
                        }
                    }
                }).then(function(subtabId) {
                    console.log("The new subtab ID is:" + subtabId);
                    workspaceAPI.setTabLabel({
                        tabId: subtabId,
                        label: "Misdirect" //set label you want to set
                    });
                    // US1831550 Thanish (Date: 5th July 2019) start {
                    workspaceAPI.setTabIcon({
                        tabId: subtabId,
                        icon: "standard:decision",
                        iconAlt: "Misdirect"
                    });
                    // } US1831550 Thanish end
                }).catch(function(error) {
                    console.log(error);
                });
            }
            
        });
    },
    // Thanish - End of code.
	
	refreshProviderCardHelper: function (cmp, event) {
        if (cmp.get("v.providerUniqueId") == event.getParam("providerUniqueId") && !cmp.get("v.isProviderSearchDisabled")) {
            var oldProviderDetails = cmp.get("v.interactionCard");
            var newProviderDetails = event.getParam("providerDetails");
            var oldPhoneNumber = oldProviderDetails.phone.replace("-").replace("/");
            var newPhoneNumber = newProviderDetails.phone.replace("-").replace("/");
            debugger;
            if (oldProviderDetails.taxIdOrNPI != newProviderDetails.taxIdOrNPI ||
                oldProviderDetails.contactName != newProviderDetails.contactName ||
                oldProviderDetails.filterType != newProviderDetails.filterType ||
                (oldProviderDetails.firstName != null && oldProviderDetails.firstName.toLowerCase()) != (newProviderDetails.firstName != null && newProviderDetails.firstName.toLowerCase()) ||
                (oldProviderDetails.lastName != null && oldProviderDetails.lastName.toLowerCase()) != (newProviderDetails.lastName != null && newProviderDetails.lastName.toLowerCase()) ||
                oldProviderDetails.state != newProviderDetails.state ||
                oldProviderDetails.zip != newProviderDetails.zip ||
                oldPhoneNumber != newPhoneNumber) {
                //DE282019
                var providerDetails = event.getParam("providerDetails");
                var providerPhoneNo = providerDetails.phone;
                providerDetails.phone = providerPhoneNo.substring(0, 3) + '-' + providerPhoneNo.substring(3, 6) + '-' + providerPhoneNo.substring(6, 10)
                /***DE282558 - Avish  ****/
                if (providerDetails.firstName != null) {
                    providerDetails.firstName = providerDetails.firstName.toUpperCase();
                }
                if (providerDetails.lastName != null) {
                    providerDetails.lastName = providerDetails.lastName.toUpperCase();
                }

                /***DE282558 - Ends  ***/
                cmp.set("v.interactionCard", providerDetails);
                if (!cmp.get("v.isProviderSearchDisabled")) {
                    this.showToastMessage("Success!", 'Updates you have made on a provider have been applied.', "success", "dismissible", "10000");
                }
            }
            //US1970508 - Ravindra
            this.updateInteractioRecord(cmp, event);
        }
    },


    //US1970508 - Ravindra
    updateInteractioRecord: function (cmp, event) {
        //var providerDetails = cmp.get("v.interactionCard");
        var action = cmp.get('c.createAccountContact');
        var interactionCard = cmp.get("v.interactionCard");
        console.log(JSON.parse(JSON.stringify(interactionCard)));
        var providerNameID = "";
        var providerId = "";
        if (cmp.get("v.providerNotFound")) {
            providerNameID = interactionCard.taxIdOrNPI;
        } else if (cmp.get("v.isProviderSearchDisabled") || cmp.get("v.isOtherSearch")) {
            providerNameID = "";
        } else {
            providerNameID = interactionCard.taxId;
            providerId = interactionCard.providerId;
        }
        var memberFirstName = "";
        var memberLastName = "";
        var subjectCard = cmp.get("v.subjectCard");
        if (!$A.util.isEmpty(subjectCard)) {
            memberFirstName = subjectCard.firstName;
            memberLastName = subjectCard.lastName;
        }
        action.setParams({
            "providerFN": interactionCard.firstName,
            "providerMN": '',
            "providerLN": interactionCard.lastName,
            "providerNameID": providerNameID,
            "providerId": providerId,
            "interactionType": cmp.get("v.interactionType"),
            "interactionIDParam": cmp.get("v.interactionID"),
            "originatorType": "Provider", //originatorType,
            "noProviderToSearch": cmp.get("v.isProviderSearchDisabled"),
            "providerNotFound": cmp.get("v.providerNotFound"),
            "noMemberToSearch": cmp.get("v.noMemberToSearch"),
            "mnf": cmp.get("v.mnf"),
            "isOtherSearch": cmp.get("v.isOtherSearch"),
            "memberFirstName": memberFirstName,
            "memberLastName": memberLastName,
            "isVCCD" :cmp.get("v.isVCCD"),//US2631703 - Durga- 08th June 2020
            "VCCDRecordId" :cmp.get("v.VCCDObjRecordId")//US2631703 - Durga- 08th June 2020
        });
        /** Code Ends here **/
        action.setCallback(this, function (response) {
            var state = response.getState(); // get the response state
            var res = response.getReturnValue();
            if (state == 'SUCCESS') {
                console.log('=====@@@@======');
                console.log(JSON.parse(JSON.stringify(res)));
                var interactionID = res.Id;
                cmp.set("v.interactionRec", res);
                cmp.find("alertsAI").alertsMethod();
                //Get the event using event name
                var appEvent = $A.get("e.c:InteractionEvent");
                if (interactionID != null && interactionID != '' && interactionID != undefined) {
                    //Set event attribute value
                    appEvent.setParams({
                        "interactionEventID": interactionID
                    });
                    //Setting interaction ID : Sarma : US1889740
                    cmp.set("v.interactionID", interactionID);

                } else {
                    appEvent.setParams({
                        "interactionEventID": ''
                    });
                }
                appEvent.fire();
                var setAddMembersAE = $A.get("e.c:SAE_SetAddMembersAE");
                setAddMembersAE.setParams({
                    "interactionCard": cmp.get('v.interactionCard'),
                    "contactName": cmp.get("v.contactName"),
                    "interactionRec": res,
                    "isOther":cmp.get("v.isOtherSearch")
                });
                setAddMembersAE.fire();
                //
            }
        });
        $A.enqueueAction(action);
    },
    //US2076634 - HIPAA Guidelines Button - Sravan
    getHipaaDetails:function(component, event, helper){
        var getHippaEndPoint = component.get("c.getHippaGuideLinesUrl");
        getHippaEndPoint.setCallback(this,function(response){
            var state = response.getState();
            if(state == 'SUCCESS'){
                var responseUrl = response.getReturnValue();
                component.set("v.hipaaEndpointUrl",responseUrl);
            }
        })
        $A.enqueueAction(getHippaEndPoint);
    }
})