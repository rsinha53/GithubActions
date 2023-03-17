({
    doInit: function (cmp, event, helper) {
    	var interactionOverviewData = _setAndGetSessionValues.getInteractionDetails(cmp.get("v.interactionOverviewTabId"));
        var providerDetails = interactionOverviewData.providerDetails;
        var OtherDetails = interactionOverviewData.flowDetails;
        var memberDetails = interactionOverviewData.membersData;
    },
    
    processHighlightData: function (cmp, event, helper) {
    	var interactionOverviewData = _setAndGetSessionValues.getInteractionDetails(cmp.get("v.interactionOverviewTabId"));
        JSON.parse(JSON.stringify(interactionOverviewData));
        var providerDetails = interactionOverviewData.providerDetails;
        var panelDetails = interactionOverviewData.highlightPanelToDisplay;
        cmp.set("v.providerData",interactionOverviewData.providerDetails);
        var OtherDetails = interactionOverviewData.flowDetails;
        console.log('Other Details'+ JSON.stringify(OtherDetails));
        //US3259469 - Sravan - Start
        if(!$A.util.isUndefinedOrNull(OtherDetails) && !$A.util.isEmpty(OtherDetails)){
            var conStartTime = '';
            var conStartType = '';
            var conEndTime = '';
            var conEndType = '';
            var conTimeZone = '';
            if(OtherDetails.hasOwnProperty('conStartTime')){
                conStartTime = OtherDetails.conStartTime;
            }
            if(OtherDetails.hasOwnProperty('conStartType')){
                conStartType = OtherDetails.conStartType;
            }
            if(OtherDetails.hasOwnProperty('conEndTime')){
                conEndTime = OtherDetails.conEndTime;
            }
            if(OtherDetails.hasOwnProperty('conEndType')){
                conEndType = OtherDetails.conEndType;
            }
            if(OtherDetails.hasOwnProperty('conTimeZone')){
                conTimeZone = OtherDetails.conTimeZone;
            }
            if(!$A.util.isEmpty(conStartTime) && !$A.util.isEmpty(conStartType) && !$A.util.isEmpty(conEndTime) && !$A.util.isEmpty(conEndType) && !$A.util.isEmpty(conTimeZone)){
                var hoursOfOperation = conStartTime+ ' '+conStartType+' to '+conEndTime+' '+conEndType+' '+conTimeZone;
                cmp.set("v.hoursOfOperation",hoursOfOperation);
            }

        }
        //US3259469 - Sravan - End
        var contactNumber;
        if (!$A.util.isUndefinedOrNull(OtherDetails.contactNumber)){
            contactNumber = OtherDetails.contactNumber;
        }else{
            contactNumber = '';
		}
        
        if(!contactNumber.includes("(")){
            contactNumber = '('+contactNumber.substring(0, 3) + ') ' + contactNumber.substring(3, 6) + '-' + contactNumber.substring(6, 10);
        	cmp.set("v.contactNumber",contactNumber);
        }
        cmp.set("v.contactNameFreeze",OtherDetails.contactName);
        cmp.set("v.OtherDetails",OtherDetails);
        JSON.parse(JSON.stringify(OtherDetails));
        var memberDetails = interactionOverviewData.membersData;
        var memberData = {
            "memberName" : "",
            "memberID" : "",
            "policy" : "",
            "groupNumber" : "",
            "DIV" : "",
            "panel" : "",
            "sourceCode": "",
            "noMemberToSearch" : false
        };
        if(memberDetails.length == 0){
            memberData.memberName = '';
            memberData.memberID = '';
            memberData.policy = '';
            memberData.groupNumber = '';
            memberData.DIV = '';
            memberData.panel = '';
            memberData.sourceCode = '';
            memberData.noMemberToSearch = true;
        }else{ 
            if(!$A.util.isUndefinedOrNull(panelDetails)){
                memberData.memberName = panelDetails.memberName;
                memberData.memberID = panelDetails.memberID;
                memberData.policy = panelDetails.policy;
                memberData.groupNumber = panelDetails.groupNumber;
                memberData.DIV = panelDetails.DIV;
                memberData.panel = panelDetails.panel;
                if(!$A.util.isEmpty(panelDetails.sourceCode)){
                    memberData.sourceCode =  panelDetails.sourceCode.includes('CO')? 'CO':panelDetails.sourceCode;
                }
                
                memberData.noMemberToSearch = false;
            }
        }
        
        cmp.set("v.memberData",memberData);
        
        var provdData = cmp.get("v.providerData");
        var providerNumber = provdData.phoneNumber;
        if(!providerNumber.includes("(")){
            provdData.phoneNumber = '('+providerNumber.substring(0, 3) + ') ' + providerNumber.substring(3, 6) + '-' + providerNumber.substring(6, 10);
        }
        cmp.set("v.providerData",provdData);
        JSON.parse(JSON.stringify(interactionOverviewData));
    },
    
    toggleSection: function (component, event, helper) {
        var sectionAuraId = event.target.getAttribute("data-auraId");
        var sectionDiv = component.find(sectionAuraId).getElement();

        var sectionState = sectionDiv.getAttribute('class').search('slds-is-open');

        if (sectionState == -1) {
            sectionDiv.setAttribute('class', 'slds-section slds-is-open');
        } else {
            sectionDiv.setAttribute('class', 'slds-section slds-is-close');
        }
    },
})