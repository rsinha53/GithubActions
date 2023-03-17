({
	handleSelect: function (component, event,helper) {
        // This will contain the string of the "value" attribute of the selected
        // lightning:menuItem
        debugger;
        var selectedMenuItemValue = event.getParam("value");
        var source = event.getSource();
        var srcName = source.get('v.name');
        var subjectCard = component.get('v.subjectCard');
        if(selectedMenuItemValue =='CopySSN'){
            var textforcopy = subjectCard[srcName].SSN;
            helper.copyTextHelper(component,event,textforcopy);
        }else if(selectedMenuItemValue =='CopyEEID'){
            var textforcopy = subjectCard[srcName].EEID;
            helper.copyTextHelper(component,event,textforcopy);
        }else if(selectedMenuItemValue =='UnMaskSSN'){
            var unMask = component.find("formattedSSN");
            if($A.util.isArray(unMask)){
                unMask = unMask[srcName];
            }
            $A.util.removeClass(unMask, "slds-hide");
            var mask = component.find("maskedSSN");
            if($A.util.isArray(mask)){
                mask = mask[srcName];
            }
            $A.util.addClass(mask, "slds-hide");
        }
        else if(selectedMenuItemValue =='UnMaskEEID'){
            var unMask = component.find("unMaskedEEID");
            $A.util.removeClass(unMask, "slds-hide");
            var mask = component.find("maskedEEID");
            $A.util.addClass(mask, "slds-hide");
        }
    },
	
    //gg - tab close test
    handleTestEvent: function (cmp, event) {
        debugger;
        cmp.set("v.testBoolean", true);
    },

    handleApplicationEvent: function (cmp, event, helper) {
        //US2132239 : Member Only - No Provider to Search
        let householdId = cmp.get("v.HouseholdIdForFindIndividualSearch");
        let isProviderSearchDisabled = cmp.get("v.isProviderSearchDisabled");
        let isFindIndividualSearch = cmp.get("v.isfindIndividualFlag");
        //US2132239 : Member Only - No Provider to Search (22 NOV 2019)
        let isOtherSearch = cmp.get("v.isOtherSearch");
        if (isProviderSearchDisabled){
            var contactDetails = _setandgetvalues.getContactValue('exploreContactData');
            console.log(JSON.stringify(contactDetails));
            
            if(!$A.util.isEmpty(contactDetails)) {
                var contactToPass = {
                    "contactName": contactDetails.contactName,
                    "contactNumber": contactDetails.contactNumber, 
                    "contactExt": contactDetails.contactExt
                }
                cmp.set("v.contactCard", contactToPass);
                
            }
        }
        //NO-PROVIDER : FIND INDIVISUAL FLOW
        if (isProviderSearchDisabled && isFindIndividualSearch && !$A.util.isUndefinedOrNull(event.getParam("subjectCard"))) {
            let subjectCard = event.getParam("subjectCard");
            if (householdId == subjectCard.memberId) {

                if (event.getParam("mnf") != 'mnf') {

                    //-------------------------DE289160 START-------------------------------------

                    let subjectCardList = cmp.get("v.subjectCard");
                    if ($A.util.isUndefinedOrNull(subjectCardList)) {
                        subjectCardList = [];
                    }

                    let mapDedups = new Map();

                    //Checking duplicate subjects cards
                    if (!$A.util.isUndefinedOrNull(event.getParam("subjectCard"))) {
                        let subjectCard = event.getParam("subjectCard");
                        subjectCard.memberUnique = event.getParam("searchedMember");
						
                        if (subjectCardList.length == 0) {
                            subjectCardList.push(subjectCard);
                        } else {
                            let providerId = event.getParam("providerUniqueId");
                            for (var i = 0; i < subjectCardList.length; i++) {
                                if ($A.util.isUndefinedOrNull(subjectCardList[i].memberUnique)) {
                                    subjectCardList[i].memberUnique = providerId + ';' + subjectCardList[i].memberId + ';' + subjectCardList[i].firstName + ' ' + subjectCardList[i].lastName + ';' + subjectCardList[i].memberDOB;
                                }
                                //Ignore duplicates
                                mapDedups.set(subjectCardList[i].memberUnique, subjectCardList[i]);

                            }

                            if (mapDedups.size > 0 && !mapDedups.has(event.getParam("searchedMember"))) {
                                mapDedups.set(event.getParam("searchedMember"), subjectCard);
                            } else {

                                let toastEvent = $A.get("e.force:showToast");
                                toastEvent.setParams({
                                    "title": "Information!",
                                    "message": "Member was already searched.",
                                    "type": "warning"
                                });
                                toastEvent.fire();
                            }
                        }
                    }

                    //Dedup the array
                    if (mapDedups.size > 0) {
                        subjectCardList = [];
                        for (let card of mapDedups.values()) {

                            subjectCardList.push(card);
                        }
                    }

                    //-------------------------DE289160 END-------------------------------------  
                                   
                    cmp.set("v.memberCardFlag", event.getParam("existingMemberCardFlag"));
					for(var i=0; i<subjectCardList.length; i++){
                        var ssnValue = subjectCardList[i].SSN;
                        var eeIdValue = subjectCardList[i].EEID;
                        subjectCardList[i].maskedSSN = 'xxx-xx-'+ssnValue.substring(5,9);
                        subjectCardList[i].formattedSSN = ssnValue.substring(0,3)+'-'+ssnValue.substring(3,5)+'-'+ssnValue.substring(5,9);
                        subjectCardList[i].maskedEEID = 'xxxxx'+eeIdValue.substring(5,9);
                        subjectCardList[i].row = i;
                    }
                    cmp.set("v.subjectCard", subjectCardList);

                    var uniqueMembersList = cmp.get("v.uniqueMembersList");
                    uniqueMembersList.push(event.getParam("searchedMember"));
                    cmp.set("v.uniqueMembersList", uniqueMembersList);
                } else {
                    cmp.set("v.mnf", event.getParam("mnf"));
                    if (event.getParam("mnf")) {
                        var mnfDetailslst = cmp.get('v.mnfDetailslst');
                        mnfDetailslst.push({
                            'mnf': event.getParam("mnf"),
                            'mnfMemberFN': event.getParam("mnfMemberFN"),
                            'mnfMemberLN': event.getParam("mnfMemberLN"),
                            'mnfDOB': event.getParam("mnfDOB"),
                            'mnfState': event.getParam("mnfMemberState"),
                            'mnfPhoneNumber': event.getParam("mnfMemberPhNo")
                        });
                        cmp.set("v.mnfDetailslst", mnfDetailslst);
                    }
                }

            }
            //PROVIDER : FIND INDIVISUAL FLOW
        } else if (!isProviderSearchDisabled && isFindIndividualSearch) { //US2132239 : Member Only - No Provider to Search

            if (isOtherSearch) {

                if (event.getParam("providerUniqueId") == cmp.get("v.providerUniqueId")) {
                    if (event.getParam("mnf") != 'mnf') {

                        let subjectCardList = cmp.get("v.subjectCard");
                        if ($A.util.isUndefinedOrNull(subjectCardList)) {
                            subjectCardList = [];
                        }

                        let mapDedups = new Map();

                        //Checking duplicate subjects cards
                        if (!$A.util.isUndefinedOrNull(event.getParam("subjectCard"))) {
                            let subjectCard = event.getParam("subjectCard");
                            subjectCard.memberUnique = event.getParam("searchedMember");

                            if (subjectCardList.length == 0) {
                                subjectCardList.push(subjectCard);
                            } else {
                                for (var i = 0; i < subjectCardList.length; i++) {
                                    if ($A.util.isUndefinedOrNull(subjectCardList[i].memberUnique)) {
                                        subjectCardList[i].memberUnique = 'Other;' + subjectCardList[i].memberId + ';' + subjectCardList[i].firstName + ';' + subjectCardList[i].lastName + ';' + subjectCardList[i].memberDOB;
                                    }

                                    //Ignore duplicates
                                    mapDedups.set(subjectCardList[i].memberUnique, subjectCardList[i]);

                                }

                                if (mapDedups.size > 0 && !mapDedups.has(event.getParam("searchedMember"))) {
                                    mapDedups.set(event.getParam("searchedMember"), subjectCard);
                                } else {

                                    let toastEvent = $A.get("e.force:showToast");
                                    toastEvent.setParams({
                                        "title": "Information!",
                                        "message": "Member was already searched.",
                                        "type": "warning"
                                    });
                                    toastEvent.fire();
                                }
                            }
                        }

                        //Dedup the array
                        if (mapDedups.size > 0) {
                            subjectCardList = [];
                            for (let card of mapDedups.values()) {

                                subjectCardList.push(card);
                            }
                        }

                        cmp.set("v.memberCardFlag", event.getParam("existingMemberCardFlag"));
						for(var i=0; i<subjectCardList.length; i++){
							var ssnValue = subjectCardList[i].SSN;
							var eeIdValue = subjectCardList[i].EEID;
							subjectCardList[i].maskedSSN = 'xxx-xx-'+ssnValue.substring(5,9);
							subjectCardList[i].formattedSSN = ssnValue.substring(0,3)+'-'+ssnValue.substring(3,5)+'-'+ssnValue.substring(5,9);
							subjectCardList[i].maskedEEID = 'xxxxx'+eeIdValue.substring(5,9);
							subjectCardList[i].row = i;
						}
                        cmp.set("v.subjectCard", subjectCardList);

                    }
                    
                    //DE284683 - FIX (START)
                    let isOtherFlow = cmp.get('v.isOtherSearch');
                    if (!isOtherFlow) {
                    helper.refreshProviderCardHelper(cmp, event);
                    }
                    //DE284683 - FIX (END)

                }
            } else {

                if (event.getParam("providerUniqueId") == cmp.get("v.providerUniqueId")) {
                    if (event.getParam("mnf") != 'mnf') {
                        
                        //-------------------------DE289160 START-------------------------------------

                        let subjectCardList = cmp.get("v.subjectCard");
                        if ($A.util.isUndefinedOrNull(subjectCardList)) {
                            subjectCardList = [];
                        }

                        let mapDedups = new Map();

                        //Checking duplicate subjects cards
                        if (!$A.util.isUndefinedOrNull(event.getParam("subjectCard"))) {
                            let subjectCard = event.getParam("subjectCard");
                            subjectCard.memberUnique = event.getParam("searchedMember");
							
                            if (subjectCardList.length == 0) {
                                subjectCardList.push(subjectCard);
                            } else {
                                let providerId = event.getParam("providerUniqueId");
                                for (var i = 0; i < subjectCardList.length; i++) {
                                    if ($A.util.isUndefinedOrNull(subjectCardList[i].memberUnique)) {
                                        subjectCardList[i].memberUnique = providerId+';' + subjectCardList[i].memberId + ';' + subjectCardList[i].firstName + ' ' + subjectCardList[i].lastName + ';' + subjectCardList[i].memberDOB;
                                    }
                                    //Ignore duplicates
                                    mapDedups.set(subjectCardList[i].memberUnique, subjectCardList[i]);

                                }

                                if (mapDedups.size > 0 && !mapDedups.has(event.getParam("searchedMember"))) {
                                    mapDedups.set(event.getParam("searchedMember"), subjectCard);
                                } else {

                                    let toastEvent = $A.get("e.force:showToast");
                                    toastEvent.setParams({
                                        "title": "Information!",
                                        "message": "Member was already searched.",
                                        "type": "warning"
                                    });
                                    toastEvent.fire();
                                }
                            }
                        }

                        //Dedup the array
                        if (mapDedups.size > 0) {
                            subjectCardList = [];
                            for (let card of mapDedups.values()) {

                                subjectCardList.push(card);
                            }
                        }

                        //-------------------------DE289160 END-------------------------------------

                        cmp.set("v.memberCardFlag", event.getParam("existingMemberCardFlag"));
						for(var i=0; i<subjectCardList.length; i++){
							var ssnValue = subjectCardList[i].SSN;
							var eeIdValue = subjectCardList[i].EEID;
							subjectCardList[i].maskedSSN = 'xxx-xx-'+ssnValue.substring(5,9);
							subjectCardList[i].formattedSSN = ssnValue.substring(0,3)+'-'+ssnValue.substring(3,5)+'-'+ssnValue.substring(5,9);
							subjectCardList[i].maskedEEID = 'xxxxx'+eeIdValue.substring(5,9);
							subjectCardList[i].row = i;
						}
                        cmp.set("v.subjectCard", subjectCardList);

                        var uniqueMembersList = cmp.get("v.uniqueMembersList");
                        uniqueMembersList.push(event.getParam("searchedMember"));
                        cmp.set("v.uniqueMembersList", uniqueMembersList);
                    } else {
                        cmp.set("v.mnf", event.getParam("mnf"));
                        if (event.getParam("mnf")) {
                            var mnfDetailslst = cmp.get('v.mnfDetailslst');
                            mnfDetailslst.push({
                                'mnf': event.getParam("mnf"),
                                'mnfMemberFN': event.getParam("mnfMemberFN"),
                                'mnfMemberLN': event.getParam("mnfMemberLN"),
                                'mnfDOB': event.getParam("mnfDOB"),
                                'mnfState': event.getParam("mnfMemberState"),
                                'mnfPhoneNumber': event.getParam("mnfMemberPhNo")
                            });
                            cmp.set("v.mnfDetailslst", mnfDetailslst);
                        }
                    }
                   
                    //DE284683 - FIX (START)
                    let isOtherFlow = cmp.get('v.isOtherSearch');
                    if (!isOtherFlow) {
                    helper.refreshProviderCardHelper(cmp, event);
                }
                    //DE284683 - FIX (END)
                }
            }


            //PROVIDER : NORMAL FLOW
        } else if (!isProviderSearchDisabled && !isFindIndividualSearch) { //US2132239 : Member Only - No Provider to Search

            if (event.getParam("providerUniqueId") == cmp.get("v.providerUniqueId")) {
                if (event.getParam("mnf") != 'mnf') {
                    var subjectCardList = cmp.get("v.subjectCard");
                    for (var i = 0; i < subjectCardList.length; i++) {
                        if (subjectCardList[i] == undefined) {
                            subjectCardList = [];
                            break;
                        }
                    }

                    var subjectard = event.getParam("subjectCard");

                    if (subjectard != null) {
                        //US2132239 - De-dup subjects cards in Other Flow
                        if (cmp.get('v.isOtherSearch')) {
                            let tabUniqueId = cmp.get("v.memberUniqueId");
                            if (tabUniqueId == event.getParam("searchedMember")) {
                                let MapDedups = new Map();
                                let subjectCardUniqueIdFromEvent = subjectard.memberId + subjectard.memberDOB + subjectard.firstName;
                                if (subjectCardList.length != 0) {
                                    for (var i = 0; i < subjectCardList.length; i++) {
                                        let arrayUnique = subjectCardList[i].memberId + subjectCardList[i].memberDOB + subjectCardList[i].firstName;
                                        MapDedups.set(arrayUnique, subjectCardList[i]);
                                        if (!MapDedups.has(subjectCardUniqueIdFromEvent)) {
                                            MapDedups.set(subjectCardUniqueIdFromEvent, subjectard);
                                        } else {
                                            let toastEvent = $A.get("e.force:showToast");
                                            toastEvent.setParams({
                                                "title": "Information!",
                                                "message": "Member was already searched.",
                                                "type": "warning"
                                            });
                                            toastEvent.fire();
                                        }
                                    }

                                    subjectCardList = [];

                                    if (MapDedups.size > 0) {
                                        for (let card of MapDedups.values()) {
                                            subjectCardList.push(card);
                                        }
                                    }
									
									for(var i=0; i<subjectCardList.length; i++){
										var ssnValue = subjectCardList[i].SSN;
										var eeIdValue = subjectCardList[i].EEID;
										subjectCardList[i].maskedSSN = 'xxx-xx-'+ssnValue.substring(5,9);
										subjectCardList[i].formattedSSN = ssnValue.substring(0,3)+'-'+ssnValue.substring(3,5)+'-'+ssnValue.substring(5,9);
										subjectCardList[i].maskedEEID = 'xxxxx'+eeIdValue.substring(5,9);
										subjectCardList[i].row = i;
									}
                                    cmp.set("v.subjectCard", subjectCardList);
                                    
                                }else{//Nikhil
                                    subjectCardList = [];
                                    subjectCardList.push(subjectard);
                                    
                                    for(var i=0; i<subjectCardList.length; i++){
                                        var ssnValue = subjectCardList[i].SSN;
                                        var eeIdValue = subjectCardList[i].EEID;
                                        subjectCardList[i].maskedSSN = 'xxx-xx-'+ssnValue.substring(5,9);
                                        subjectCardList[i].formattedSSN = ssnValue.substring(0,3)+'-'+ssnValue.substring(3,5)+'-'+ssnValue.substring(5,9);
                                        subjectCardList[i].maskedEEID = 'xxxxx'+eeIdValue.substring(5,9);
                                        subjectCardList[i].row = i;
                                    }
                                    cmp.set("v.subjectCard", subjectCardList);
                                    cmp.set("v.memberCardFlag", true);
                                }//Nikhil
                            }

                        } else {

                            let MapDedups = new Map();
                            let subjectCardUniqueIdFromEvent = subjectard.memberId + subjectard.memberDOB + subjectard.firstName;
                            if (subjectCardList.length != 0) {
                                for (var i = 0; i < subjectCardList.length; i++) {
                                    let arrayUnique = subjectCardList[i].memberId + subjectCardList[i].memberDOB + subjectCardList[i].firstName;
                                    MapDedups.set(arrayUnique, subjectCardList[i]);
                                }

                                if (MapDedups.has(subjectCardUniqueIdFromEvent)) {
                                    let toastEvent = $A.get("e.force:showToast");
                                    toastEvent.setParams({
                                        "title": "Information!",
                                        "message": "Member was already searched.",
                                        "type": "warning"
                                    });
                                    toastEvent.fire();
                                } else {
                                    MapDedups.set(subjectCardUniqueIdFromEvent, subjectard);
                                }

                                subjectCardList = [];

                                if (MapDedups.size > 0) {
                                    for (let card of MapDedups.values()) {
                                        subjectCardList.push(card);
                                    }
                                }
								
								for(var i=0; i<subjectCardList.length; i++){
									var ssnValue = subjectCardList[i].SSN;
									var eeIdValue = subjectCardList[i].EEID;
									subjectCardList[i].maskedSSN = 'xxx-xx-'+ssnValue.substring(5,9);
									subjectCardList[i].formattedSSN = ssnValue.substring(0,3)+'-'+ssnValue.substring(3,5)+'-'+ssnValue.substring(5,9);
									subjectCardList[i].maskedEEID = 'xxxxx'+eeIdValue.substring(5,9);
									subjectCardList[i].row = i;
								}
                                cmp.set("v.subjectCard", subjectCardList);
                                //DE282755 - FIX
                                cmp.set("v.memberCardFlag", true);
                            }else{
                                subjectCardList = [];
                                subjectCardList.push(subjectard);
                                for(var i=0; i<subjectCardList.length; i++){
                                    var ssnValue = subjectCardList[i].SSN;
                                    var eeIdValue = subjectCardList[i].EEID;
                                    subjectCardList[i].maskedSSN = 'xxx-xx-'+ssnValue.substring(5,9);
                                    subjectCardList[i].formattedSSN = ssnValue.substring(0,3)+'-'+ssnValue.substring(3,5)+'-'+ssnValue.substring(5,9);
                                    subjectCardList[i].maskedEEID = 'xxxxx'+eeIdValue.substring(5,9);
                                    subjectCardList[i].row = i;
                                }
                                cmp.set("v.subjectCard", subjectCardList); 
                                cmp.set("v.memberCardFlag", true);
                            }

                        }
                    }
                    //DE282755 - FIX : Commented
                    //cmp.set("v.memberCardFlag", event.getParam("existingMemberCardFlag"));

                    var uniqueMembersList = cmp.get("v.uniqueMembersList");
                    uniqueMembersList.push(event.getParam("searchedMember"));
                    cmp.set("v.uniqueMembersList", uniqueMembersList);
                } else {

                    cmp.set("v.mnf", event.getParam("mnf"));
                    if (event.getParam("mnf")) {
                        var mnfDetailslst = cmp.get('v.mnfDetailslst');

                        //US2132239 : Member Only - No Provider to Search (22 NOV 2019) - START
                        let MapDedups = new Map();
                        let mnfSubjectCard = {
                            'mnf': event.getParam("mnf"),
                            'mnfMemberFN': event.getParam("mnfMemberFN"),
                            'mnfMemberLN': event.getParam("mnfMemberLN"),
                            'mnfDOB': event.getParam("mnfDOB"),
                            'mnfState': event.getParam("mnfMemberState"),
                            'mnfPhoneNumber': event.getParam("mnfMemberPhNo")
                        }

                        let subjectCardUniqueIdFromEvent = mnfSubjectCard.mnfMemberFN + mnfSubjectCard.mnfMemberLN + mnfSubjectCard.mnfDOB + mnfSubjectCard.mnfState;
                        if (!$A.util.isUndefinedOrNull(mnfDetailslst) && mnfDetailslst.length != 0) {
                            for (var i = 0; i < mnfDetailslst.length; i++) {
                                let arrayUnique = mnfDetailslst[i].mnfMemberFN + mnfDetailslst[i].mnfMemberLN + mnfDetailslst[i].mnfDOB + mnfDetailslst[i].mnfState;
                                MapDedups.set(arrayUnique, mnfDetailslst[i]);
                                if (!MapDedups.has(subjectCardUniqueIdFromEvent)) {
                                    MapDedups.set(subjectCardUniqueIdFromEvent, mnfSubjectCard);

                                } else {

                                    let toastEvent = $A.get("e.force:showToast");
                                    toastEvent.setParams({
                                        "title": "Information!",
                                        "message": "Member was already searched.",
                                        "type": "warning"
                                    });
                                    toastEvent.fire();
                                }
                            }
                        }

                        mnfDetailslst = [];

                        if (MapDedups.size > 0) {
                            for (let card of MapDedups.values()) {
                                mnfDetailslst.push(card);
                            }
                        }
                        //US2132239 : Member Only - No Provider to Search (22 NOV 2019) - END
                        cmp.set("v.mnfDetailslst", mnfDetailslst);
                    }
                }

                //DE284683 - FIX (START)
                let isOtherFlow = cmp.get('v.isOtherSearch');
                if (!isOtherFlow) {
                helper.refreshProviderCardHelper(cmp, event);
                }
                //DE284683 - FIX (END)
               
            }
        }
    },

    refreshProviderCard: function (cmp, event, helper) {
        helper.refreshProviderCardHelper(cmp, event);
    },

    // Fix - DE246060 - Ravindra - 17-07-2019
    onTabClosed : function(cmp, event) {
        var appEvent = $A.get("e.c:SAE_SearchedMembersAE");
        var interactionCard = cmp.get("v.interactionCard");
        appEvent.setParams({
            "searchedMember": null,
            "providerUniqueId": $A.util.isEmpty(interactionCard) ? "No Provider To Search" : interactionCard.taxIdOrNPI,
            //"providerUniqueId": interactionCard.taxIdOrNPI == "264777940" ? "No Provider To Search" : interactionCard.taxIdOrNPI,
            "clearMemberSearchArray": true
        });
        appEvent.fire();
    },

    /*** US2433262 Avish ***/
    closeECAATabs : function(cmp, event) {
        if(event.getParam("closeECAATabFlag")){
            var workspaceAPI = cmp.find("workspace");
            workspaceAPI.getAllTabInfo().then(function(response) {
                if(!$A.util.isEmpty(response)){
                    for(var i = 0; i < response.length; i++){
                        console.log(response[i].pageReference.attributes.componentName);
                        for(var j = 0; j < response[i].subtabs.length; j++){
                            if(response[i].subtabs[j].pageReference.attributes.componentName == "c__ACET_EDMSIframe"){
                                var focusedTabId = response[i].subtabs[j].tabId;
                                workspaceAPI.closeTab({tabId: focusedTabId});
                            }
                        }
                    }
                }
            })
            .catch(function(error) {
                console.log(error);
            });
        }
    },
    /**US2433262 Avish Ends ***/

    init:function(cmp,event,helper){
        //close tab after refreshing tab or logout session
        var interactionOverviewStatus = true;
        try {
            interactionOverviewStatus = _setAndGetInteractionOverviewStatus.getValue();
        } catch (e) {
            helper.closeInteractionOverviewTabs(cmp, event);
        }
        if (!interactionOverviewStatus) {
            helper.closeInteractionOverviewTabs(cmp, event);
        }
        
        var action = cmp.get('c.createAccountContact');

        var pageReference = cmp.get("v.pageReference");
        //US2132239 : Member Only - No Provider to Search
        let householdId = pageReference.state.c__HouseholdUniqueId;
        let providerFlow = pageReference.state.c__providerFlow;
        //US2631703 - Durga- 08th June 2020
        console.log('==VCCD Check'+pageReference.state.c__isVCCD);
        cmp.set("v.isVCCD",pageReference.state.c__isVCCD);
        cmp.set("v.VCCDObjRecordId",pageReference.state.c__VCCDRespId);
        console.log('==VCCD Record Id '+pageReference.state.c__VCCDRespId);
        cmp.set("v.providerFlow", providerFlow);
        cmp.set("v.HouseholdIdForFindIndividualSearch", householdId);
        var noMemberToSearch = pageReference.state.c__noMemberToSearch;
        var providerNotFound = pageReference.state.c__providerNotFound;
        cmp.set("v.noMemberToSearch", noMemberToSearch);
        cmp.set("v.providerNotFound", providerNotFound);
        cmp.set("v.mnf", pageReference.state.c__mnf);
        cmp.set("v.providerUniqueId", pageReference.state.c__providerUniqueId)

        //US2076634 - HIPAA Guidelines Button - Sravan - Start
        helper.getHipaaDetails(cmp, event, helper);
        //US2076634 - HIPAA Guidelines Button - Sravan - End

	 	//US1974270	Pilot - Misdirect Case Creation - Multiple Members Searches Revised - 26/09/2019 - Sarma : Start
        //Putting null check to memberonly search flag & making it true
        var isfindIndividualFlag = pageReference.state.c__findIndividualFlag;
        var isProviderSearchDisabled = pageReference.state.c__isProviderSearchDisabled;
        cmp.set("v.isProviderSearchDisabled", isProviderSearchDisabled);
        if(isfindIndividualFlag != null && isfindIndividualFlag != undefined && isfindIndividualFlag){
            var providerSearchFlag = pageReference.state.c__providerSearchFlag;
            cmp.set("v.isfindIndividualFlag", isfindIndividualFlag);
            cmp.set("v.isProviderSearchDisabled", providerSearchFlag);
            cmp.set("v.memberContactName", pageReference.state.c__memberContactName);
            cmp.set("v.memberContactNumber", pageReference.state.c__memberContactNumber);
        }
        var isProviderSearc = pageReference.state.c__isProviderSearchDisabled;
       /*if(isProviderSearc){
            cmp.set("v.isfindIndividualFlag", true);
        } */
        //US1974270 : End

		//US1909381 - Sarma - 04/09/2019 - Interaction Overview - Other (Third Party) : Start
        let isOtherSearch = pageReference.state.c__isOtherSearch;
        let otherDetails = pageReference.state.c__otherDetails;
        if(otherDetails != null && otherDetails != undefined){
            //US1974270	Pilot - Misdirect Case Creation - Multiple Members Searches Revised - 25/09/2019 - Sarma
            //next 2 lines : Setting contact name during other search flow.
            //US2536668 changes conName
            var contactName = otherDetails.conName;//firstName + ' ' + otherDetails.lastName;
            cmp.set("v.contactName", contactName);
            //US2536668 changes conNumber
            var phone = otherDetails.conNumber;//phoneNumber;
            cmp.set("v.contactNumber",phone);
            //US2536668 removed next two lines
           // otherDetails.firstName = otherDetails.firstName.toUpperCase();
            //otherDetails.lastName = otherDetails.lastName.toUpperCase();

            if (phone != null && !phone.includes("-")) {//US2536668 conNumber
                otherDetails.conNumber = phone.substring(0, 3) + '-' + phone.substring(3, 6) + '-' + phone.substring(6, 10)
            }

        }
        if(isOtherSearch){
           cmp.set("v.isProviderSearch", false);
        }
        //US1974270	Pilot - Misdirect Case Creation - Multiple Members Searches Revised - 25/09/2019 - Sarma
        //adding else part to set contact name during member standalone search.
        else{
            cmp.set("v.contactName", pageReference.state.c__contactName);
            cmp.set("v.contactNumber", pageReference.state.c__contactNumber);
        }
        cmp.set("v.isOtherSearch", isOtherSearch);
        cmp.set("v.otherDetails", otherDetails);
        //US1909381 : END

        var contactCard = {
            "contactName":"",
            "contactNumber":"", 
            "contactExt":""
        };
        cmp.set("v.contactCard", contactCard);
        
        var contactDetails = _setandgetvalues.getContactValue('exploreContactData');
        console.log(JSON.stringify(contactDetails));

        if(!$A.util.isEmpty(contactDetails)) {
            var contactToPass = {
                "contactName": contactDetails.contactName,
                "contactNumber": contactDetails.contactNumber, 
                "contactExt": contactDetails.contactExt
            }
            cmp.set("v.contactCard", contactToPass);
            
        }

        if (providerNotFound && noMemberToSearch) {
            var providerDetails = pageReference.state.c__providerDetails;
            var prvPhone = providerDetails.phone;
            if (prvPhone != null && !prvPhone.includes("-")) {
                providerDetails.phone = prvPhone.substring(0, 3) + '-' + prvPhone.substring(3, 6) + '-' + prvPhone.substring(6, 10)
            }
            var firstName = $A.util.isEmpty(providerDetails.firstName) ? "" : providerDetails.firstName.toUpperCase();
            providerDetails.firstName = firstName;
            var lastName  = $A.util.isEmpty(providerDetails.lastName) ? "" : providerDetails.lastName.toUpperCase();
            providerDetails.lastName = lastName;
            cmp.set("v.interactionCard", providerDetails);
        } else {
            //US1974270	Pilot -Misdirect Case Creation - Multiple Members Searches Revised - 25/09/2019 - Sarma
            //Removing line : Code refactor
            //var contactName = pageReference.state.c__contactName;

            var interactionCard = pageReference.state.c__interactionCard;
            var subjectCard = pageReference.state.c__subjectCard;
            var memberIdVal = pageReference.state.c__memberId;
            var memberDOBVal = pageReference.state.c__memberDOB;
            var memberFNVal = pageReference.state.c__memberFN;
            var memberLNVal = pageReference.state.c__memberLN;
            var memberGrpNVal = pageReference.state.c__memberGrpNo;
            var searchOptionVal = pageReference.state.c__searchOption;
            var mnfVal = pageReference.state.c__mnf;
            cmp.set("v.mnf", mnfVal);
            var mnfMemberFNVal = pageReference.state.c__mnfMemberFN;
            var mnfMemberLNVal = pageReference.state.c__mnfMemberLN;
            var mnfDOB = pageReference.state.c__mnfDOB;
            var mnfPhoneNumberVal = pageReference.state.c__mnfPhoneNumber;
            var mnfStateVal = pageReference.state.c__mnfState;
            var interactionType = pageReference.state.c__intType;

            var interactionID = pageReference.state.c__interactionID;
            //var arrayDOB = (!$A.util.isEmpty(memberDOBVal)) ? memberDOBVal.split('-') : ""; // Thanish - 17th Sept 2019 - checking for null to prevent exceptions.
            //var displayDOB = (!$A.util.isEmpty(arrayDOB)) ? arrayDOB[1] + '/' + arrayDOB[2] + '/' + arrayDOB[0] : ""; // Thanish - 17th Sept 2019 - checking for null to prevent exceptions.
            var displayDOB;
            if(memberDOBVal != undefined && memberDOBVal != null){
                var arrayDOB = memberDOBVal.split('-');
                displayDOB = arrayDOB[1]+'/'+arrayDOB[2]+'/'+arrayDOB[0];
            }

            //US1974270	Pilot - Misdirect Case Creation - Multiple Members Searches Revised - 25/09/2019 - Sarma
            //Removing line : Code refactor
            //cmp.set("v.contactName", contactName);
           // var isProviderSearchDisabled = pageReference.state.c__isProviderSearchDisabled;
            //cmp.set("v.isProviderSearchDisabled", isProviderSearchDisabled);
            if (!isOtherSearch && !isProviderSearchDisabled|| mnfVal) {
                var providerDetails = pageReference.state.c__providerDetails;

                if(isfindIndividualFlag != null && isfindIndividualFlag != undefined){
                    if(cmp.get("v.isProviderSearchDisabled")){
                        providerDetails = null;
                    }
                   /* if(providerDetails != null){
                        providerDetails.contactName = pageReference.state.c__providerContactName;
                    }  */
                }
                if(pageReference.state.c__providerType != undefined && pageReference.state.c__providerType != null){
                    cmp.set("v.providerType", pageReference.state.c__providerType); // US1807554 - Thanish - 19th August 2019.
                }
                //US1909381 - Sarma - 05/09/2019 - Interaction Overview - Other (Third Party) : null check on the provide details obj
                if(providerDetails != null && providerDetails != undefined){
                    var prvPhone = providerDetails.phone;
                     if (prvPhone != null && !prvPhone.includes("-")) {
                    providerDetails.phone = prvPhone.substring(0, 3) + '-' + prvPhone.substring(3, 6) + '-' + prvPhone.substring(6, 10)
                    }
                }
                cmp.set("v.interactionCard", providerDetails);
            } else {
                var prvDetails = [];
                //cmp.set("v.interactionCard", interactionCard);
                cmp.set("v.interactionCard", prvDetails);
            }

            var subjectCardAlerts = pageReference.state.c__subjectCard;
            if(!$A.util.isEmpty(subjectCardAlerts)){
                cmp.set("v.alertMemberId",subjectCardAlerts.memberId);
                cmp.set("v.alertGroupId",subjectCardAlerts.groupNumber);
            }

                //cmp.find("alertsAI").alertsMethod();

            cmp.set("v.providerType", pageReference.state.c__providerType); // US1807554 - Thanish - 19th August 2019.
        }
        /*** Code Added by Avish 07/25/2019 ***/
        if (event.getParam("mnf")) {
            var mnfDetailslst = cmp.get('v.mnfDetailslst');
            mnfDetailslst.push({
                'mnf':mnfVal,
                'mnfDOB': mnfDOB,
                'mnfMemberFN': mnfMemberFNVal,
                'mnfMemberLN': mnfMemberLNVal,
                'mnfState': mnfStateVal,
                'mnfPhoneNumber': mnfPhoneNumberVal
            });
            cmp.set("v.mnfDetailslst", mnfDetailslst);
        }else{
            var mnfData = cmp.get("v.mnfDetailslst");
            if(mnfVal == 'mnf'){
                mnfData.push({
                    'mnf': mnfVal,
                    'mnfDOB': mnfDOB,
                    'mnfMemberFN': mnfMemberFNVal,
                    'mnfMemberLN': mnfMemberLNVal,
                    'mnfState': mnfStateVal,
                    'mnfPhoneNumber': mnfPhoneNumberVal
                });
                cmp.set("v.mnfDetailslst",mnfData);
            }
        }

        var memberCardFlagVal = pageReference.state.c__checkFlagmeberCard;
        cmp.set("v.memberCardFlag", memberCardFlagVal);
        if(cmp.get("v.memberCardFlag") && cmp.get("v.isProviderSearchDisabled")){
            cmp.set("v.contactName",cmp.get("v.contactName"));
            cmp.set("v.contactNumber",cmp.get("v.contactNumber"));
        }

        if (subjectCard != "" && subjectCard != undefined) {
            var subjectCardList = [];
            subjectCardList.push(subjectCard);
            for(var i=0; i<subjectCardList.length; i++){
                var ssnValue = subjectCardList[i].SSN;
                var eeIdValue = subjectCardList[i].EEID;
                subjectCardList[i].maskedSSN = 'xxx-xx-'+ssnValue.substring(5,9);
                subjectCardList[i].formattedSSN = ssnValue.substring(0,3)+'-'+ssnValue.substring(3,5)+'-'+ssnValue.substring(5,9);
                subjectCardList[i].maskedEEID = 'xxxxx'+eeIdValue.substring(5,9);
				subjectCardList[i].row = i;
            }
            cmp.set("v.subjectCard", subjectCardList);
        }
        /*** Code ends here ***/

        //Added by Vinay for checking status to show "--" when value missing
        var statusCode = pageReference.state.c__statusCode;
        cmp.set("v.respStatusCode",statusCode);

        //cmp.set("v.subjectCard", subjectCard);
      /*  var subjectCardList = [];
        subjectCardList.push(subjectCard);
        cmp.set("v.subjectCard", subjectCardList); */
        //
        cmp.set("v.memberId", memberIdVal);
        cmp.set("v.memberDOB", memberDOBVal);
        cmp.set("v.memberDOBToDisplay", displayDOB);
        cmp.set("v.memberFN", memberFNVal);
        cmp.set("v.memberLN", memberLNVal);
        cmp.set("v.memberGrpN", memberGrpNVal);
        cmp.set("v.searchOption", searchOptionVal);
        cmp.set("v.mnf", mnfVal);
		cmp.set("v.mnfMemberFN", mnfMemberFNVal);
        cmp.set("v.mnfMemberLN", mnfMemberLNVal);
        cmp.set("v.mnfPhoneNumber", mnfPhoneNumberVal);
        cmp.set("v.mnfState", mnfStateVal);
        cmp.set("v.interactionID", interactionID);
        //US1719505 Malinda
        var memUniqueId = pageReference.state.c__memberUniqueId;
        cmp.set("v.memberUniqueId", memUniqueId);
        
        if (!$A.util.isEmpty(memUniqueId)) {
            debugger;
            var uniqueMembersList = cmp.get("v.uniqueMembersList");
            console.log(JSON.stringify(uniqueMembersList));
            if(uniqueMembersList.length == 0){
                if(isOtherSearch){
                    if(subjectCard != undefined && subjectCard != ''){
                        memUniqueId = '';
                        memUniqueId = 'Other' + ";" + subjectCard.memberId + ";" + subjectCard.firstName + " " + subjectCard.lastName + ";" + subjectCard.memberDOB;
                        uniqueMembersList.push(memUniqueId);                          
                    }
                }else{
                    uniqueMembersList.push(memUniqueId);
                }
            }else{
                for(var i = 0; i < uniqueMembersList.length;i++){
                    if(isOtherSearch){
                        var alreadySearchedMemberArray = uniqueMembersList[i].split(";");
                          if(subjectCard.memberId != alreadySearchedMemberArray[1] &&
                              ((subjectCard.firstName + " " + subjectCard.lastName != alreadySearchedMemberArray[2])
                              && subjectCard.memberDOB != alreadySearchedMemberArray[3])){
                              memUniqueId = providerUniqueId + ";" + subjectCard.memberId + ";" + subjectCard.firstName + " " + subjectCard.lastName + ";" + subjectCard.memberDOB;
                              uniqueMembersList.push(memUniqueId);
                          }
                    }else{
                        if(uniqueMembersList[i] != memUniqueId){
                            uniqueMembersList.push(memUniqueId);                      
                        }
                    }
                       
                } 
            }
            
            cmp.set("v.uniqueMembersList", uniqueMembersList);
        }


        //US1889740 - Sarma (Date: 1st Aug 2019) - Misdirect Case creation : Code Start
		if(subjectCard != undefined && subjectCard != ''){
            var memberFullName = subjectCard.memberName;
            var memberGrpN = subjectCard.groupNumber;
            cmp.set("v.memberFullName", memberFullName);
            cmp.set("v.memberGrpN", memberGrpN);

        }
		//US1889740 - Sarma (Date: 1st Aug 2019) - Misdirect Case creation : Code end

        var providerMiddleName = '';
        if(cmp.get("v.interactionCard.providerMN") == undefined){
            providerMiddleName = '';
        }else{
            providerMiddleName = cmp.get("v.interactionCard.providerMN");
        }
        //US1889740 - Sarma (Date: 1st Aug 2019) - Misdirect Case creation :Setting contact name for the provider search flow
        if(cmp.get("v.contactName") == undefined){
            var contactName = cmp.get("v.interactionCard.contactName");
            var contactNumber = cmp.get("v.interactionCard.contactNumber");
            cmp.set("v.contactName", contactName);
            cmp.set("v.contactNumber", contactNumber);
        }
        //US1921739  Adding new param to track member interaction. - 18/10/2019 - Sarma
        var originatorType;
        if(cmp.get("v.isProviderSearchDisabled") && !cmp.get("v.providerNotFound")){
            originatorType = 'Member';
        }else if(cmp.get("v.isOtherSearch")){
            originatorType = 'Other';
        }else{
            originatorType = 'Provider';
        } //US1921739 - End

        /** Code Added by Avish on 10162019 for Third party record creation **/
        var isPNF = cmp.get("v.providerNotFound");
        var isOtherFlag = cmp.get("v.isOtherSearch");
        var isNoProviderSearchFlag = cmp.get("v.isProviderSearchDisabled");
        var providerDetails;
        var isMNF = cmp.get("v.mnf") == 'mnf' ? true : false;

        if(isPNF || (!isNoProviderSearchFlag && !isPNF && !isOtherFlag)){
            providerDetails = pageReference.state.c__providerDetails;

            if(isMNF){//US2132239 : Member Only - No Provider to Search
                cmp.set("v.mnf",'mnf');
            }else{
                cmp.set("v.mnf",'');
            }

        }else if(isNoProviderSearchFlag && !isMNF){
            var memberIdVal = pageReference.state.c__memberId;
            providerDetails = {
                "firstName":"",
                "lastName":"",
                "taxIdOrNPI":""
            };
            var dobMemerToAppend = "";
            if (!$A.util.isEmpty(subjectCard.memberDOB)) {
                var dob = subjectCard.memberDOB.split('/');
                dobMemerToAppend = dob[0] + dob[1] + dob[2].substring(2);
            }
            providerDetails.firstName = subjectCard.firstName;
            providerDetails.lastName = subjectCard.lastName;
            providerDetails.taxIdOrNPI = memberIdVal+dobMemerToAppend;
            cmp.set("v.mnf",'');
        }else if(isNoProviderSearchFlag && isMNF){
            var memberIdVal = pageReference.state.c__memberId;
            providerDetails = {
                "firstName":"",
                "lastName":"",
                "taxIdOrNPI":""
            };
            providerDetails.firstName = cmp.get("v.mnfMemberFN");
            providerDetails.lastName = cmp.get("v.mnfMemberLN");
            providerDetails.taxIdOrNPI = memberIdVal;
            cmp.set("v.mnf",'mnf');
        }else if(isOtherFlag){
            providerDetails = {
                "firstName":"",
                "lastName":"",
                "taxIdOrNPI":""
            };
            providerDetails.firstName = otherDetails.conName; //US2587781 - Avish //otherDetails.firstName;
            providerDetails.lastName = ''; 					  //US2587781 - Avish //otherDetails.lastName;
            providerDetails.phone = otherDetails.phoneNumber;
            //providerDetails.taxIdOrNPI = '460841758';
            cmp.set("v.mnf",'mnf');
        }
        //US1970508 - Ravindra - start
        /*action.setParams({
            "providerFN": providerDetails.firstName,
            "providerMN": '',
            "providerLN": providerDetails.lastName,
            "providerNameID": providerDetails.taxIdOrNPI,
            "interactionType": interactionType,
            "interactionIDParam": cmp.get("v.interactionID"),
            "originatorType": originatorType,
            "mnf": cmp.get("v.mnf")
        });*/
        cmp.set("v.interactionType", pageReference.state.c__intType);
        var interactionCard = cmp.get("v.interactionCard");
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
            "providerFN": providerDetails.firstName,
            "providerMN": '',
            "providerLN": providerDetails.lastName,
			"providerPhone": providerDetails.phone,
            "providerNameID": providerNameID,
            "providerId": providerId,
            "interactionType": interactionType,
            "interactionIDParam": cmp.get("v.interactionID"),
            "originatorType": originatorType,
            "noProviderToSearch": cmp.get("v.isProviderSearchDisabled"),
            "providerNotFound": cmp.get("v.providerNotFound"),
            "noMemberToSearch": cmp.get("v.noMemberToSearch"),
            "mnf": cmp.get("v.mnf"),
            "isOtherSearch": cmp.get("v.isOtherSearch"),
            "memberFirstName": memberFirstName,
            "memberLastName": memberLastName,
            "isVCCD" :cmp.get("v.isVCCD"), //US2631703 - Durga- 08th June 2020
            "VCCDRecordId" :cmp.get("v.VCCDObjRecordId") //US2631703 - Durga- 08th June 2020
        });
        //US1970508 - Ravindra - end
        /** Code Ends here **/

		action.setCallback(this, function(response) {
            var state = response.getState(); // get the response state
            var res = response.getReturnValue();
            if(state == 'SUCCESS') {

                var interactionID = res.Id;
                cmp.set("v.interactionRec",res);
                cmp.find("alertsAI").alertsMethod();
                //Get the event using event name
                var appEvent = $A.get("e.c:InteractionEvent");
                if(interactionID != null && interactionID != '' && interactionID != undefined){
                    //Set event attribute value
                    appEvent.setParams({"interactionEventID" : interactionID});
					//Setting interaction ID : Sarma : US1889740
                    cmp.set("v.interactionID",interactionID);
                    if(cmp.get("v.memberContactName") != null && cmp.get("v.memberContactName") != undefined) {
                        _setandgetvalues.setContactValue(interactionID, cmp.get("v.memberContactName"), cmp.get("v.memberContactNumber"));
                    } else if(!$A.util.isUndefinedOrNull(cmp.get("v.contactName"))) {
                        _setandgetvalues.setContactValue(interactionID, cmp.get("v.contactName"), cmp.get("v.contactNumber"));
                    } else {
                        _setandgetvalues.setContactValue(interactionID, providerDetails.contactName, providerDetails.contactNumber); 
                    }
                }else{
                    appEvent.setParams({"interactionEventID" : ''});
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
	navigateToCustomPlace1: function (cmp, event) {
        event.preventDefault();
        alert('Dashboard');
    },
    navigateToCustomPlace2: function (cmp, event) {
        event.preventDefault();
        alert('interaction Overview');
    },

    navigateToSnapshot: function (cmp, event, helper) {
        var selectedCard = event.target.getAttribute("data-Index");
        var selectedCardMemberType = event.target.getAttribute("data-memberType");
        var subjectCard;
        var mnfDetails;
        var memUniqueId;
        var houseHoldUnique;
        var mnf = "";
        var providerUniqueId = cmp.get("v.providerUniqueId");
        if (selectedCardMemberType == "Searched Member") {
            if(!cmp.get("v.isfindIndividualFlag")){
                subjectCard = cmp.get("v.subjectCard")[selectedCard];
                //Kavinda
                memUniqueId = providerUniqueId + subjectCard.memberId + subjectCard.memberDOB + subjectCard.firstName;
                memUniqueId = memUniqueId.concat('_sub');
                // US1914267 - E2E Defects - Sanka
                // DE281466	HouseHold issue with Twins : Adding first name to tab uniqueness - 22/11/2019 - Sarma
                houseHoldUnique = subjectCard.memberId + subjectCard.memberDOB + subjectCard.firstName + '_sub';
            }else{
                subjectCard = cmp.get("v.subjectCard")[selectedCard];
                memUniqueId = providerUniqueId + subjectCard.memberId;
                //memUniqueId = memUniqueId.concat('_sub');
                memUniqueId = providerUniqueId + subjectCard.memberId + subjectCard.memberDOB + subjectCard.firstName + '_sub';
                // US1914267 - E2E Defects - Sanka
                // DE281466	HouseHold issue with Twins : Adding first name to tab uniqueness - 22/11/2019 - Sarma
                houseHoldUnique = subjectCard.memberId + subjectCard.memberDOB + subjectCard.firstName + '_sub';
            }
        } else if (selectedCardMemberType == "Member not found") {
            mnfDetails = cmp.get("v.mnfDetailslst")[selectedCard];
            mnf = "mnf";
            memUniqueId = providerUniqueId + mnfDetails.mnfMemberFN + mnfDetails.mnfMemberLN + mnfDetails.mnfDOB;
            memUniqueId = memUniqueId.concat('_sub');
            // US1914267 - E2E Defects - Sanka
            houseHoldUnique="";
        }
        var workspaceAPI = cmp.find("workspace");
        //US1875495 - Malinda : Contact Name Fix
        var contactName = cmp.get("v.contactName");
        var contactNumber = cmp.get("v.contactNumber");
        //DE282930	House Hold Card issue , Duplicate and Provider card blank - 25/11/2019 - Sarma
        if ($A.util.isEmpty(contactName)) {
            contactName = cmp.get("v.memberContactName")
        }
        if ($A.util.isEmpty(contactNumber)) {
            contactNumber = cmp.get("v.membercontactNumber")
        }
        var matchingTabs = [];

        //Checking for Opened Tabs
        workspaceAPI.getAllTabInfo().then(function (response) {
            if (!$A.util.isEmpty(response)) {
                for (var i = 0; i < response.length; i++) {
                    for (var j = 0; j < response[i].subtabs.length; j++) {
                        if (response[i].subtabs.length > 0) {
                            var tabMemUniqueId = response[i].subtabs[j].pageReference.state.c__memberUniqueId;

                            if (memUniqueId === tabMemUniqueId) {
                                console.log('TAB MATCH!!');
                                matchingTabs.push(response[i].subtabs[j]);
                                break;
                            } else {
                                console.log('NO MATCH!!');
                                //break;
                            }
                        } else {
                            console.log('FIRST SUB TAB');
                        }
                    }
                }
            }
            //Open Tab
            if (matchingTabs.length === 0) {
                console.log('##ML:SUB_OPEN');

                var tabName = '';
                if(cmp.get("v.noMemberToSearch") && cmp.get("v.providerNotFound")){
                    var providerDetails = cmp.get("v.interactionCard");
                    tabName = providerDetails.firstName;
                }else{
                    tabName = cmp.get("v.memberFN");
                }
                //US2570805 - Sravan - Start
                var pageReference = cmp.get("v.pageReference");
                var isVCCD = pageReference.state.c__isVCCD;
                var VCCDQuestionType = pageReference.state.c__VCCDQuestionType;
                //US2570805 - Sravan - Stop
                workspaceAPI.getEnclosingTabId().then(function (enclosingTabId) {
                    workspaceAPI.openSubtab({
                        parentTabId: enclosingTabId,
                        pageReference: {
                            "type": "standard__component",
                            "attributes": {
                                "componentName": "c__SAE_SnapshotOfMemberAndPolicies"
                            },
                            "state": {
                                "c__interactionCard": cmp.get('v.interactionCard'),
                                "c__subjectCard": cmp.get('v.subjectCard'),
                                "c__contactCard": cmp.get("v.contactCard"),
                                "c__contactName": contactName,
                                "c__contactNumber": contactNumber,
                                "c__memberUniqueId": memUniqueId,
                                "c__interactionRecord": cmp.get("v.interactionRec"),
                                "c__searchOption": mnf == "mnf" ? "" : (subjectCard != undefined ? subjectCard.searchOption:''),
                                "c__mnf": mnf,
                                "c__subjectCard": mnf == "mnf" ? mnfDetails : subjectCard,
                                // US1914267 - E2E Defects - Sanka
                                "c__houseHoldUnique": houseHoldUnique,
                                "c__providerNotFound": cmp.get("v.providerNotFound"),
                                "c__noMemberToSearch": cmp.get("v.noMemberToSearch"),
                                "c__isProviderSearchDisabled": cmp.get("v.isProviderSearchDisabled"),
                                //US1909380 : Other Snapshot - Malinda
                                "c__isOtherSearch": cmp.get("v.isOtherSearch"),
                                "c__otherDetails": cmp.get("v.otherDetails"),
                                "c__isfindIndividualFlag" : cmp.get("v.isfindIndividualFlag"),
                                "c__memberContactName" : cmp.get("v.memberContactName"),
                                "c__memberContactNumber" : cmp.get("v.memberContactNumber"),
                                "c__memberCardFlag": cmp.get("v.memberCardFlag"),
                                "c__providerUniqueId":cmp.get("v.providerUniqueId"),
                                "c__interactionType":cmp.get("v.interactionType"),
                                //US2570805 - Sravan - Start
                                "c__isVCCD": isVCCD,
                                "c__VCCDQuestionType":VCCDQuestionType,
                                //US2570805 - Sravan - Stop
                                "c__hipaaEndpointUrl": cmp.get("v.hipaaEndpointUrl")//US2076634 - Sravan - 22/06/2020

                            }
                        },
                        focus: !event.ctrlKey
                    }).then(function (subtabId) {

                        var memberFN = "";
                        if (mnf == 'mnf') {
                            memberFN = mnfDetails.mnfMemberFN;
                        }else if(cmp.get("v.noMemberToSearch") && cmp.get("v.providerNotFound")){
                            var providerDetails = cmp.get("v.interactionCard");
                            memberFN = providerDetails.firstName;
                        }else if(cmp.get("v.isfindIndividualFlag")){
                            memberFN = subjectCard != undefined ? subjectCard.firstName:''
                        }else {
                            memberFN = subjectCard != undefined ? subjectCard.firstName:'';
                        }
                        var tabLabel = "Snapshot";
                        /*if(!$A.util.isEmpty(tabName)){
                            tabLabel = tabName.charAt(0) + tabName.slice(1).toLowerCase();
                        }else*/
						if(memberFN.length > 1){
                        	tabLabel = memberFN.charAt(0).toUpperCase() + memberFN.slice(1).toLowerCase();
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
                        // ******** US1831550 Thanish end ********
                    }).catch(function (error) {
                        console.log(error);
                    });
                });
            } else {
                console.log('##ML:SUB_NOT-OPEN');
                var focusTabId = matchingTabs[0].tabId;
                var tabURL = matchingTabs[0].url;
                //var subTabURL = matchingTabs[0].subtabs[0].url;

                workspaceAPI.openTab({
                    //url: matchingTabs[0].subtabs[0].url
                    url: tabURL
                }).then(function (response) {
                    workspaceAPI.focusTab({
                        tabId: response
                    });
                }).catch(function (error) {
                    console.log(error);
                });
            }
        })
    },
        navigateToDetail:function(component,event,helper){

        var intId = event.currentTarget.getAttribute("data-intId");


        var workspaceAPI = component.find("workspace");
        workspaceAPI.openSubtab({
            pageReference: {
                type: 'standard__recordPage',
                attributes: {
                    actionName: 'view',
                    objectApiName: 'Interaction__c',
                    recordId : intId
                },
            },
            focus: true
        }).then(function(response) {
            workspaceAPI.getTabInfo({
                tabId: response

            }).then(function(tabInfo) {
                /*workspaceAPI.setTabLabel({
                        tabId: tabInfo.tabId,
                        label: 'Detail-'+lastName
                    });
                    workspaceAPI.setTabIcon({
                        tabId: tabInfo.tabId,
                        icon: "standard:people",
                        iconAlt: "Member"
                    });*/
                });
            }).catch(function(error) {
                console.log(error);
            });
    },
    // US1909477 - Thanish (30th July 2019)
    // Purpose - Add misdirect button to page header.
    // Copied from SAE_MisdirectController.js
    openMisdirectComp: function (component, event, helper) {
        helper.openMisDirect(component, event, helper);
    },
    // Thanish - End of Code.

    // US1807421 - Provider Snapshot
    // Sanka Dharmasena - 15.08.2019
    navigateToProviderSnapshot: function (component, event, helper) {
        // US2091974 - Sanka - Case Creation
        let subjectDetails = new Object();
        subjectDetails.subjectType = 'Member';

        let contactName = component.get('v.interactionCard') != null ? component.get('v.interactionCard').contactName : component.get("v.contactName");
        let contactNumber = component.get('v.interactionCard') != null ? component.get('v.interactionCard').contactNumber : component.get("v.contactNumber");

        subjectDetails.contactName = contactName;
        subjectDetails.contactNumber = contactNumber;
        component.set("v.contactName",subjectDetails.contactName);
        component.set("v.contactNumber",subjectDetails.contactNumber);

        if (component.get("v.mnf") == 'mnf') {
            let mnfDetailslst = component.get('v.mnfDetailslst');
            let firstName = mnfDetailslst.length > 0 ? mnfDetailslst[0].mnfMemberFN : '';
            let lastName = mnfDetailslst.length > 0 ? mnfDetailslst[0].mnfMemberLN : '';
            subjectDetails.fullName = firstName + ' ' + lastName;
            subjectDetails.DOB = mnfDetailslst.length > 0 ? mnfDetailslst[0].mnfDOB : '';
            subjectDetails.subjectGroupId = '';
            subjectDetails.subjectId = '';
            //US2099066 - Sravan - Start
            subjectDetails.firstName = firstName;
            subjectDetails.lastName = lastName;
            subjectDetails.stateCode = mnfDetailslst.length > 0 ? mnfDetailslst[0].mnfState : '';
            subjectDetails.phoneNumber = mnfDetailslst.length > 0 ? mnfDetailslst[0].mnfPhoneNumber : '';
            //US2099066 - Sravan - End
        }

        if (!component.get("v.noMemberToSearch") && component.get("v.mnf") != 'mnf') {
            subjectDetails.fullName = component.get("v.memberFullName");
            subjectDetails.DOB = component.get("v.memberDOB");
            subjectDetails.subjectGroupId = component.get("v.memberGrpN");
            subjectDetails.subjectId = component.get("v.memberId");
        }
        var selectedPrvdDetails = component.get("v.interactionCard");
        if (component.get("v.noMemberToSearch")) {
            subjectDetails.subjectType = 'Provider';
            subjectDetails.fullName = selectedPrvdDetails.firstName + " " + selectedPrvdDetails.lastName;
            subjectDetails.DOB = '--';
            subjectDetails.subjectGroupId = '--';
            subjectDetails.subjectId = '--';
        }
        // End

        var workspaceAPI = component.find("workspace");
        var provType = "";

        if (!component.get("v.providerNotFound")) { // DE267648 - Thanish - 10th Oct 2019

        // US1807554 - Thanish - navigation to provider snapshot with provider only search (Temp) - 19th August 2019
        if(component.get("v.noMemberToSearch") && component.get("v.providerNotFound")){
            provType = component.get("v.interactionCard.filterType");
            } else {
            if(component.get("v.isfindIndividualFlag")){
                provType = component.get("v.interactionCard.providerType");
            }else{
                provType = component.get("v.interactionCard.providerType");
            }
        }
        // Thanish end of code

            //DE282132 - Tab Uniqueness
            var tabUniqueKey = selectedPrvdDetails.taxId + selectedPrvdDetails.providerId + selectedPrvdDetails.addressId;
            var foundTab = new Object();
            foundTab.tabId = '';
            foundTab.tabUrl = '';

            workspaceAPI.getAllTabInfo().then(function (response) {
                    for (var i = 0; i < response.length; i++) {
                        var subtabArray = response[i].subtabs;
                        for (var j = 0; j < subtabArray.length; j++) {
                            var item = subtabArray[j];
                            if (item.pageReference.state.c__tabUniqueKey == tabUniqueKey) {
                                foundTab.tabId = subtabArray[j].tabId;
                                foundTab.tabUrl = subtabArray[j].url;
                                break;
                            }
                        }
                    }

                    if ((provType == "Physician" || provType == "P") && foundTab.tabId == '') {
             //US1816853 - Sanka
             var selectedPrvdDetails = component.get("v.interactionCard");
             var tabLabel = "";
             if (!$A.util.isEmpty(selectedPrvdDetails.firstName)) {
                 tabLabel = selectedPrvdDetails.firstName.charAt(0) + selectedPrvdDetails.firstName.slice(1).toLowerCase();
             } else {
                 tabLabel = "Provider Snapshot";
             }
            workspaceAPI.getEnclosingTabId().then(function (enclosingTabId) {
                workspaceAPI.openSubtab({
                    parentTabId: enclosingTabId,
                    pageReference: {
                        "type": "standard__component",
                        "attributes": {
                            "componentName": "c__SAE_ProviderSnapshot"
                        },
                        "state": {
                            "c__mnf": component.get("v.mnf"),
                            "c__providerNotFound": component.get("v.providerNotFound"),
                            "c__noMemberToSearch": component.get("v.noMemberToSearch"),
                            "c__isProviderSearchDisabled": component.get("v.isProviderSearchDisabled"),
                            //US1816853 - Sanka
                            "c__taxId": selectedPrvdDetails.taxId,
                            "c__providerId": selectedPrvdDetails.providerId,
                            "c__addrSequence": selectedPrvdDetails.addressSequenceId,
                            "c__interactionId": component.get("v.interactionRec.Id"), // US2039716 - Thanish - 18th Sept 2019
                                "c__interactionName": component.get("v.interactionRec.Name"), // US2039716 - Thanish - 18th Sept 2019
                                //US1970508 - Ravindra - start
                                "c__interactionRec": component.get("v.interactionRec"),
                                //US1970508 - Ravindra - end
                                // US2091974 - Sanka - Case Creation
                                "c__contactName": component.get("v.contactName"),
                            "c__contactNumber": component.get("v.contactNumber"),
                                "c__subjectDetails": subjectDetails,
                                        "c__addressId": selectedPrvdDetails.addressId, // US1918689 - Thanish - 13th Nov 2019 - passing addressID of physician.
                                        "c__hipaaEndpointUrl": component.get("v.hipaaEndpointUrl"),//US2076634 - Sravan - 22/06/2020
                                        //DE282132 - Sanka
                                        "c__tabUniqueKey": tabUniqueKey
                        }
                    },
                    focus: true
                }).then(function (subtabId) {
                    workspaceAPI.setTabLabel({
                        tabId: subtabId,
                        //US1816853 - Sanka
                        label: tabLabel
                    });
                    workspaceAPI.setTabIcon({
                        tabId: subtabId,
                        icon: "custom:custom38",
                        iconAlt: "Snapshot"
                    });
                }).catch(function (error) {
                    console.log(error);
                });
            });
        }
        // US1807554 - Thanish - 19th August 2019
                    else if ((provType == "Facility" || provType == "O") && foundTab.tabId == '') {
            // US2039716 - Thanish - 18th Sept 2019
            var selectedPrvdDetails = component.get("v.interactionCard");
            var tabLabel = "";
            if (!$A.util.isEmpty(selectedPrvdDetails.firstName)) {
                tabLabel = selectedPrvdDetails.firstName.charAt(0) + selectedPrvdDetails.firstName.slice(1).toLowerCase();
            } else {
                tabLabel = "Provider Snapshot";
            }
            // End of Code - US2039716 - Thanish - 18th Sept 2019
            workspaceAPI.getEnclosingTabId().then(function (enclosingTabId) {
                workspaceAPI.openSubtab({
                    parentTabId: enclosingTabId,
                    pageReference: {
                        "type": "standard__component",
                        "attributes": {
                            "componentName": "c__SAE_ProviderFacilitySnapshot"
                        },
                        "state": {
                            "c__mnf": component.get("v.mnf"),
                            "c__providerNotFound": component.get("v.providerNotFound"),
                            "c__noMemberToSearch": component.get("v.noMemberToSearch"),
                            "c__isProviderSearchDisabled": component.get("v.isProviderSearchDisabled"),
                            //US1816890 - Sanka; Edited by :- US2039716 - Thanish - 18th Sept 2019
                            "c__taxId": selectedPrvdDetails.taxId,
                            "c__providerId": selectedPrvdDetails.providerId,
                            "c__addrSequence": selectedPrvdDetails.addressSequenceId,
                            "c__interactionId": component.get("v.interactionRec.Id"), // US2039716 - Thanish - 18th Sept 2019
                                "c__interactionName": component.get("v.interactionRec.Name"), // US2039716 - Thanish - 18th Sept 2019
                                //US1970508 - Ravindra - start
                                "c__interactionRec": component.get("v.interactionRec"),
                                // US2091974 - Sanka - Case Creation
                                "c__contactName": component.get("v.contactName"),
                            "c__contactNumber": component.get("v.contactNumber"),
                                "c__subjectDetails": subjectDetails,
                                        "c__addressId": selectedPrvdDetails.addressId, // US1918689 - Thanish - 13th Nov 2019 - passing addressID of physician.
                                        "c__hipaaEndpointUrl": component.get("v.hipaaEndpointUrl"),//US2076634 - Sravan - 22/06/2020
                                        //DE282132 - Sanka
                                        "c__tabUniqueKey": tabUniqueKey
                        }
                    },
                    focus: true
                }).then(function (subtabId) {
                    workspaceAPI.setTabLabel({
                        tabId: subtabId,
                        label: tabLabel // US2039716 - Thanish - 18th Sept 2019
                    });
                    workspaceAPI.setTabIcon({
                        tabId: subtabId,
                        icon: "custom:custom38",
                        iconAlt: "Snapshot"
                    });
                }).catch(function (error) {
                    console.log(error);
                });
            });
                    } else {
                        //Open Existing Tab
                        workspaceAPI.openTab({
                                url: foundTab.tabUrl,
                            }).then(function (response) {
                                workspaceAPI.focusTab({
                                    tabId: foundTab.tabId
                                });
                            })
                            .catch(function (error) {
                                console.log(error);
                            });
        }
                })
                .catch(function (error) {
                    console.log(error);
                });
    }
        // DE267648 - Thanish - 10th Oct 2019
        else {
            var selectedPrvdDetails = component.get("v.interactionCard");
            var tabLabel = "";
            if (!$A.util.isEmpty(selectedPrvdDetails.firstName)) {
                tabLabel = selectedPrvdDetails.firstName.charAt(0) + selectedPrvdDetails.firstName.slice(1).toLowerCase();
            } else {
                tabLabel = "Provider Snapshot";
            }

            // DE267648 - Thanish - 14th Oct 2019
            var caseWrapper = {
                "Interaction": component.get("v.interactionRec.Id"),
                "Status": "Open",
                "OriginatorName": selectedPrvdDetails.firstName + " " + selectedPrvdDetails.lastName,
                "OriginatorType": "Provider",
                "OriginatorContactName": subjectDetails.contactName,
                "SubjectName": subjectDetails.fullName,
                "SubjectType": subjectDetails.subjectType,
                "SubjectDOB": subjectDetails.DOB,
                "SubjectId": subjectDetails.subjectId,
                "SubjectGroupId": subjectDetails.subjectGroupId,
                "TaxId": selectedPrvdDetails.taxIdOrNPI,
                //US1970508 - Ravindra - start
                "noProviderToSearch": component.get("v.isProviderSearchDisabled"),
                "providerNotFound": component.get("v.providerNotFound"),
                "noMemberToSearch": component.get("v.noMemberToSearch"),
                "mnf": component.get("v.mnf"),
                "isOtherSearch": component.get("v.isOtherSearch"),
                "SubjectName": subjectDetails.fullName,
                "SubjectType": "Member",
                //US1970508 - Ravindra - end
                //US2099066 - Sravan - Start
                "plFirstName": selectedPrvdDetails.firstName,
                "plLastName": selectedPrvdDetails.lastName,
                "plTaxId": selectedPrvdDetails.taxIdOrNPI,
                "phoneNumber": selectedPrvdDetails.phone,
                "subjectFirstName": subjectDetails.firstName,
                "subjectLastName": subjectDetails.lastName,
                "stateCode": subjectDetails.stateCode,
                "subjectPhoneNumber":subjectDetails.phoneNumber
                //US2099066 - Sravan -End


            };

            // Tab Uniqueness - DE282132 - PNF
            var tabUniqueKey_PNF = selectedPrvdDetails.taxIdOrNPI + selectedPrvdDetails.firstName + selectedPrvdDetails.lastName;
            var foundTab_PNF = new Object();
            foundTab_PNF.tabId = '';
            foundTab_PNF.tabUrl = '';

            workspaceAPI.getAllTabInfo().then(function (response) {
                    for (var i = 0; i < response.length; i++) {
                        var subtabArray = response[i].subtabs;
                        for (var j = 0; j < subtabArray.length; j++) {
                            var item = subtabArray[j];
                            if (item.pageReference.state.c__tabUniqueKey_PNF == tabUniqueKey_PNF) {
                                foundTab_PNF.tabId = subtabArray[j].tabId;
                                foundTab_PNF.tabUrl = subtabArray[j].url;
                                break;
                            }
                        }
                    }

                    if (foundTab_PNF.tabId == '') {
            workspaceAPI.getEnclosingTabId().then(function (enclosingTabId) {
                workspaceAPI.openSubtab({
                    parentTabId: enclosingTabId,
                    pageReference: {
                        "type": "standard__component",
                        "attributes": {
                            "componentName": "c__SAE_ProviderTypeSnapshotCard"
                        },
                        "state": {
                            "c__caseWrapper": caseWrapper,
                            "c__interactionCard":component.get("v.interactionCard"),
                            "c__contactName":component.get("v.contactName"),
                            "c__contactNumber":component.get("v.contactNumber"),
                                        "c__interactionRec": component.get("v.interactionRec"),
                             "c__hipaaEndpointUrl": component.get("v.hipaaEndpointUrl"),//US2076634 - Sravan - 22/06/2020
                                        // DE282132
                                        "c__tabUniqueKey_PNF": tabUniqueKey_PNF
                        }
                    },
                    focus: true
                }).then(function (subtabId) {
                    workspaceAPI.setTabLabel({
                        tabId: subtabId,
                        label: tabLabel
                    });
                    workspaceAPI.setTabIcon({
                        tabId: subtabId,
                        icon: "custom:custom38",
                        iconAlt: "Snapshot"
                    });
                }).catch(function (error) {
                    console.log(error);
                });
            });
                    } else {
                        workspaceAPI.openTab({
                                url: foundTab_PNF.tabUrl,
                            }).then(function (response) {
                                workspaceAPI.focusTab({
                                    tabId: foundTab_PNF.tabId
                                });
                            })
                            .catch(function (error) {
                                console.log(error);
                            });
        }
                })
                .catch(function (error) {
                    console.log(error);
                });
        }
        // End of Code - DE267648 - Thanish - 10th Oct 2019
    },
    //US2076634 - HIPAA Guidelines Button - Sravan
    handleHippaGuideLines : function(component, event, helper) {
        var hipaaEndPointUrl = component.get("v.hipaaEndpointUrl");
        if(!$A.util.isUndefinedOrNull(hipaaEndPointUrl) && !$A.util.isEmpty(hipaaEndPointUrl)){
            window.open(hipaaEndPointUrl, '_blank');
        }
    }

})