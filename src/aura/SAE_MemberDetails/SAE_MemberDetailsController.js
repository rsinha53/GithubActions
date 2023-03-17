({
	doInit : function(component, event, helper) {
        helper.setEmptyCardData(component); // DE436023 - Thanish - 12th May 2021
	},
    // US2253388 - Member Subject Card/Member Snapshot - Integrate EEID-Durga
    handleExtentCoverage: function(component,event,helper){
        var extendCoverage = component.get("v.extendedCoverage");
        if(!$A.util.isUndefinedOrNull(extendCoverage) && !$A.util.isUndefinedOrNull(extendCoverage.resultWrapper)
           && !$A.util.isUndefinedOrNull(extendCoverage.resultWrapper.policyRes)
           && !$A.util.isUndefinedOrNull(extendCoverage.resultWrapper.policyRes.EEID) && !$A.util.isUndefinedOrNull(component.get("v.subjectCard")) ){
            component.set("v.subjectCard.EEID",extendCoverage.resultWrapper.policyRes.EEID);
            var eeIdValue = extendCoverage.resultWrapper.policyRes.EEID;
            var maskeeidvalue = '';
            if(eeIdValue.length >4){
                for(var x= 0; x < (eeIdValue.length - 4) ;x++ ){
                    maskeeidvalue = maskeeidvalue +'x';
                }
                maskeeidvalue =  maskeeidvalue+eeIdValue.substring(eeIdValue.length - 4,eeIdValue.length);
            }
            else{
                maskeeidvalue = eeIdValue;
            }

            // DE387727 - Thanish - 23rd Nov 2020
            var cardDetatils = component.get("v.cardDetails");
            if(!$A.util.isUndefinedOrNull(cardDetatils) && !$A.util.isUndefinedOrNull(cardDetatils.cardData)){
                for(var each in cardDetatils.cardData){
                    if(cardDetatils.cardData[each].fieldName == 'EEID'){
                        cardDetatils.cardData[each].fieldValue = maskeeidvalue;
                        cardDetatils.cardData[each].unmaskedValue = extendCoverage.resultWrapper.policyRes.EEID;
                    }
                }
                component.set("v.cardDetatils",cardDetatils);
            }
            var refreshpatientmethod = component.get('c.refreshPatientDetails');
            $A.enqueueAction(refreshpatientmethod);
            component.set("v.subjectCard.maskedEEID",maskeeidvalue);
        }
        //US2784325 - TECH: Case Details - Caller ANI/Provider Add'l Elements Mapped to ORS - Durga
        if(!$A.util.isUndefinedOrNull(extendCoverage) && !$A.util.isUndefinedOrNull(extendCoverage.resultWrapper)
           && !$A.util.isUndefinedOrNull(extendCoverage.resultWrapper.policyRes)
           && !$A.util.isUndefinedOrNull(extendCoverage.resultWrapper.policyRes.pcptaxId) && !$A.util.isUndefinedOrNull(component.get("v.caseWrapper")) ){
            var caseWrapper = component.get("v.caseWrapper");
            caseWrapper.pcpTaxId = extendCoverage.resultWrapper.policyRes.pcptaxId != 'N/A' ? extendCoverage.resultWrapper.policyRes.pcptaxId : '';
            component.set("v.caseWrapper",caseWrapper);
        }
	},

    handleSelect: function (component, event,helper) {
        // This will contain the string of the "value" attribute of the selected
        // lightning:menuItem
        
        var selectedMenuItemValue = event.getParam("value");
        //alert("Menu item selected with value: " + selectedMenuItemValue);
        if(selectedMenuItemValue =='CopySSN'){
            //component.set("v.mask", true);
            var textforcopy = component.find("unMaskedSSN").get('v.value');
            helper.copyTextHelper(component,event,textforcopy);
        }else if(selectedMenuItemValue =='CopyEEID'){
            var textforcopy = component.find("unMaskedEEID").get('v.value');
            helper.copyTextHelper(component,event,textforcopy);
        }else if(selectedMenuItemValue =='UnMaskSSN'){
            //alert('UnMask');
            var unMask = component.find("formattedSSN");
            $A.util.removeClass(unMask, "slds-hide");
            var mask = component.find("maskedSSN");
            $A.util.addClass(mask, "slds-hide");
        }
        else if(selectedMenuItemValue =='UnMaskEEID'){
            //alert('UnMask');
            var unMask = component.find("unMaskedEEID");
            $A.util.removeClass(unMask, "slds-hide");
            var mask = component.find("maskedEEID");
            $A.util.addClass(mask, "slds-hide");
        }
    },

	//US2137922: Added by Ravindra
    refreshPatientDetails: function (component, event, helper) {
        
        var policySelectedIndex = component.get("v.policySelectedIndex");
        var memberCardData = component.get("v.memberCardData");
        
        if (!$A.util.isEmpty(memberCardData) && memberCardData.CoverageLines.length > 0) {
			component.set("v.pcpAssignment", memberCardData.CoverageLines[policySelectedIndex].pcpAssignment);
            component.set("v.patientInfo", memberCardData.CoverageLines[policySelectedIndex].patientInfo);
            component.set("v.transactionId", memberCardData.CoverageLines[policySelectedIndex].transactionId);
            component.set("v.policyMemberId",memberCardData.CoverageLines[policySelectedIndex].patientInfo.MemberId);
            // DE356374 - Thanish - 13th Aug 2020
            var croppedProvName = memberCardData.CoverageLines[policySelectedIndex].pcpAssignment.providerPCP;
            croppedProvName = croppedProvName.trim();
            if(!$A.util.isEmpty(croppedProvName) && croppedProvName.length > 20){
                component.set("v.croppedProvName", croppedProvName.substring(0, 20));
            }

            var caseWrapper = component.get("v.caseWrapper");
            var patieninfo = memberCardData.CoverageLines[policySelectedIndex].patientInfo;
            caseWrapper.SubjectAge = patieninfo.Age;
            caseWrapper.memStreet1 = patieninfo.AddressLine1;
            caseWrapper.memStreet2 = patieninfo.AddressLine2;
            caseWrapper.memZip = patieninfo.Zip;

            var pcpAssignment = memberCardData.CoverageLines[policySelectedIndex].pcpAssignment;

            if(!$A.util.isEmpty(pcpAssignment))
            {
                caseWrapper.pcpFirstName = pcpAssignment.FirstName;
                caseWrapper.pcpLastName = pcpAssignment.LastName;
                caseWrapper.pcpState = pcpAssignment.State;
                caseWrapper.pcpStreet1 = pcpAssignment.Street1;
                caseWrapper.pcpStreet2 = pcpAssignment.Street2;
                caseWrapper.pcpZip  = pcpAssignment.Zip;
            }

            // Policy Switching
            var xrefChange = component.getEvent("xrefChange");
            xrefChange.setParams({
            "xRefId": patieninfo.xRefId,
            "xRefIdOrs": patieninfo.xRefIdORS,
            "memberId": patieninfo.MemberId
            });
            xrefChange.fire();

            component.set("v.caseWrapper",caseWrapper);
		
		// US2808743 - Thanish - 3rd Sep 2020 - New Autodoc Framework
		// Moved inside - DE416171
		helper.setAutodocCardData(component);
		var memberDetails = component.find("memberDetails");
		memberDetails.autodocByDefault();
        }

        
    },

    // US2418691 - Thanish - 29th Jul 2020
    handleAutodocEvent: function (cmp, event, helper) {
        var eventData = event.getParam("eventData");
        if(eventData.fieldName == "PCP History"){
            helper.showPCPHistory(cmp);
            var cardDetails = cmp.get("v.cardDetails");
            if(cardDetails.cardData.length = 14){
                cardDetails.cardData.push({
                    "checked": true,
                    "defaultChecked": false,
                    "fieldName": "PCP History",
                    "fieldType": "outputText",
                    "fieldValue": "Accessed",
                    "showCheckbox": false,
                    "hideField": true,
                    "isReportable":true
                });
                cmp.set("v.cardDetails", cardDetails);
            }
        }
        // US2917371 - Thanish - 7th Dec 2020
        else if(eventData.fieldName == "Provider"){
            var pcpInfo = cmp.get("v.extendedCoverage.resultWrapper.policyRes.primaryCareProvider");
            if(!$A.util.isEmpty(pcpInfo)){
                var searchObject = new Object();
                searchObject.taxId = ($A.util.isEmpty(pcpInfo.taxId) || pcpInfo.taxId=="N/A") ? "" : pcpInfo.taxId;
                searchObject.npi = ($A.util.isEmpty(pcpInfo.providerNpi) || pcpInfo.providerNpi=="N/A") ? "" : pcpInfo.providerNpi;
                // searchObject.firstName = ($A.util.isEmpty(pcpInfo.pcpFirstName) || pcpInfo.pcpFirstName=="N/A") ? "" : pcpInfo.pcpFirstName;
                // searchObject.lastName = ($A.util.isEmpty(pcpInfo.pcpLastName) || pcpInfo.pcpLastName=="N/A") ? "" : pcpInfo.pcpLastName;
                searchObject.filterType = 'P';
                var headerClick = cmp.getEvent("headerClick");
                headerClick.setParams({
                    "data": searchObject
                });
                headerClick.fire();
            }
        }
    },

    // US2418691 - Thanish - 29th Jul 2020
    togglePopup : function(cmp, event) {
        let showPopup = event.currentTarget.getAttribute("data-popupId");
        let text = event.currentTarget.getAttribute("data-text");

        if(text.length > 20){
            cmp.find(showPopup).toggleVisibility();
    }
    },
})