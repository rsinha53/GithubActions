({
    autoDocLink: function (component, event, helper,fieldName,fieldValue) {
        //Added by Mani -- Start 12/02/2020
        var cardDetails = new Object();
         var currentIndexOfOpenedTabs = component.get("v.currentIndexOfOpenedTabs");
        var maxAutoDocComponents = component.get("v.maxAutoDocComponents");
         var claimNo=component.get("v.claimNo");
        cardDetails.componentName = "Related Information: "+claimNo;
        // US3653575
        cardDetails.reportingHeader = 'Related Information';
        cardDetails.caseItemsExtId = claimNo;

        cardDetails.componentOrder = 5 + (maxAutoDocComponents*currentIndexOfOpenedTabs);
        cardDetails.noOfColumns = "slds-size_1-of-2";
        cardDetails.type = "card";
        cardDetails.uniqueKey= component.get("v.claimNo");
        cardDetails.allChecked = false;
        var cardData = [];
        cardDetails.cardData = [
            {
                "checked": true,
                "disableCheckbox": true,
                "fieldName": fieldName,
                "fieldType": "outputText",
            "fieldValue": fieldValue,
            "isReportable": true
        }];
         component.set("v.cardDetails",cardDetails);
        _autodoc.setAutodoc(component.get("v.autodocUniqueId"),component.get("v.autodocUniqueCmpID"), cardDetails);

    },

    setAutoDoc: function (component, event, helper, fieldName, fieldValue) {
        var cardDetails = component.get("v.cardDetails");
        var index = cardDetails.cardData.findIndex(function(data){
            return data.fieldName == fieldName;
        });
        if(index == -1){
            cardDetails.cardData.push({
                "checked": true,
                "disableCheckbox": true,
                "fieldName": fieldName,
                "fieldType": "outputText",
                "fieldValue": fieldValue,
                "isReportable": true
            });
        }
             _autodoc.setAutodoc(component.get("v.autodocUniqueId"),component.get("v.autodocUniqueCmpID"), cardDetails);

        },
    getCardDetails: function(component, event, helper) {
        var getcardDetails = _autodoc.getAutodocComponent(component.get("v.autodocUniqueId"),component.get("v.autodocUniqueCmpID"),'Related Information');
        console.log("getcardDetails"+getcardDetails);
        console.log("getcardDetails"+JSON.stringify(getcardDetails));
        if(!$A.util.isEmpty(getcardDetails)){
            component.set("v.cardDetails",getcardDetails);
        }

    },
    //Added by Mani -- End

    //Related Info Redesign - Create Dropdown
    createDropDownList: function (cmp, event, helper) {
        var topicList = [];
        // US3474365: Claim Detail Page - Related Information Card - Redesign - Krish - 14th July 2021
        topicList.push(new topicObject('Authorizations', false, 'This will list authorizations on file for the member.', 'Authorizations', 'Authorizations was selected.'));
        topicList.push(new topicObject('Benefit Details', false, 'This will list the benefits available on the date(s) of service.', 'Benefit Details', 'Benefit Details was selected.'));
        topicList.push(new topicObject('Claim Level Diagnosis Details', false, 'This will list the diagnosis code(s) and identify which were present on admission.', 'Claim Level Diagnosis Details', 'Claim Level Diagnosis Details was selected.'));
        topicList.push(new topicObject('Coordination of Benefits', false, 'This will list the member’s COB information.', 'Coordination of Benefits', 'Coordination of Benefits was selected.'));
        topicList.push(new topicObject('External IDs', false, 'This will list External IDs related to this claim (ORS, PIQ, PEGA, Purged ORS, MACESS, etc.)', 'External IDs', 'External IDs was selected.'));
        topicList.push(new topicObject('Fee Schedule', false, 'This will load a fee schedule lookup component.', 'Fee Schedule', 'Fee Schedule was selected.'));
        topicList.push(new topicObject('Financials', false, 'This will list the financial accumulation at the time of claim processing.', 'Financials','Financials was selected.'));
        topicList.push(new topicObject('In/Outpatient Details', false, 'This will load billed claim level additional details.', 'In/Outpatient Details', 'In/Outpatient Details was selected.'));
        topicList.push(new topicObject('OON Reimbursement', false, 'This will load plan level OON member reimbursement information.', 'OON Reimbursement','OON Reimbursement was selected.'));
        topicList.push(new topicObject('Referrals', false, 'This will list referrals on file for the same date(s) of service.', 'Referrals', 'Referrals was selected.'));
        topicList.push(new topicObject('Timely Filing', false, 'This will list the contracted timely filing for the provider.', 'Timely Filing', 'Timely Filing was selected.'));

        cmp.set('v.topicList', topicList);

        function topicObject(name, isSelected, helpText, fieldName, autoDocText) {
            this.name = name;
            this.isSelected = isSelected;
            this.helpText = helpText;
            this.autoDocText = autoDocText;
            this.fieldName = fieldName;
        }
    },

    // US3474282 - Thanish - 15th Jul 2021
    autodocOpenedTopic: function (cmp, event, helper, topicObj) {
        helper.getCardDetails(cmp, event, helper);
        if ($A.util.isEmpty(cmp.get("v.cardDetails"))) {
            helper.autoDocLink(cmp, event, helper, topicObj.fieldName, topicObj.autoDocText);
        } else {
            helper.setAutoDoc(cmp, event, helper, topicObj.fieldName, topicObj.autoDocText);
        }
    },

    })