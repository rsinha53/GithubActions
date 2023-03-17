({
  /** setContactInfoCardData: function (cmp) {
        var interactionCard = cmp.get("v.interactionCard");
        var contactName = cmp.get("v.contactName");
        var cardDetails = new Object();
        cardDetails.componentName = "Contact Name : ";
        cardDetails.componentHeaderVal = cmp.get("v.contactName");
        cardDetails.componentOrder = 2;
        cardDetails.noOfColumns = "slds-size_4-of-12";
        cardDetails.type = "card";
        cardDetails.cardData = [
            {
                "checked": true,
                "defaultChecked": true,
                "fieldName": "Contact Number",
                "fieldType": "outputText",
                "fieldValue": !$A.util.isUndefinedOrNull(interactionCard.contactNumber) ? interactionCard.contactNumber : '--',
                "showCheckbox": false,
                "isReportable": true //US2820031 - adding isReportable - true
            },
          
        ];
            cardDetails.cardData.push({
            "checked": true,
            "defaultChecked": true,
            "fieldName": "Contact Ext",
            "fieldType": "outputText",
            "fieldValue": !$A.util.isUndefinedOrNull(interactionCard.contactExt) ? interactionCard.contactExt : '--',
            "showCheckbox": false,
            "isReportable": true //US2820031 - adding isReportable - true
            });
        
        cmp.set("v.contactDetails", cardDetails);
            
    },*/
            
    setPNFCardData: function (cmp) {
            var interactionCard = cmp.get("v.interactionCard");
            var Name;
            var contactName = cmp.get("v.contactName");
            var firstName = !$A.util.isUndefinedOrNull(interactionCard.firstName) ? interactionCard.firstName : '';
             var lastName = !$A.util.isUndefinedOrNull(interactionCard.lastName) ? interactionCard.lastName : '';
           
            	Name = firstName + ' ' +lastName;
           
            var cardDetails = new Object();
            cardDetails.componentName = "Provider : ";
            cardDetails.componentHeaderVal = Name;
            cardDetails.componentOrder = 3;
            cardDetails.noOfColumns = "slds-size_4-of-12";
            cardDetails.type = "card";
            cardDetails.caseItemsExtId = !$A.util.isUndefinedOrNull(interactionCard.taxIdOrNPI) ? interactionCard.taxIdOrNPI : '--'; // US3691217 - Thanish - 18th Aug 2021
            cardDetails.cardData = [
            {
                "checked": true,
                "defaultChecked": true,
                "fieldName": "Tax ID (TIN)",
                "fieldType": "outputText",
                "fieldValue": !$A.util.isUndefinedOrNull(interactionCard.taxIdOrNPI) ? interactionCard.taxIdOrNPI : '--',
                "showCheckbox": false,
                "isReportable": true //US2820031 - adding isReportable - true
            },/*{//US3017101
                 "checked": true,
                "defaultChecked": true,
                "fieldName": "Filter Type",
                "fieldType": "outputText",
                "fieldValue": !$A.util.isUndefinedOrNull(interactionCard.filterType) ? interactionCard.filterType : '--',
                "showCheckbox": false,
                "isReportable": true //US2820031 - adding isReportable - true
            },*/
            {
                "checked": true,
                "defaultChecked": true,
                "fieldName": "Phone #",
                "fieldType": "outputText",
                "fieldValue": !$A.util.isEmpty(interactionCard.phone) ? interactionCard.phone : '--',
                "showCheckbox": false,
                "isReportable": true //US2820031 - adding isReportable - true
            },// US2744897: Update Provider Not Found Card Adding Contact Card fiedld to Provider Card
            {
                "checked": true,
                "defaultChecked": true,
                "fieldName": "Contact Name",
                "fieldType": "outputText",
            	"fieldValue": !$A.util.isEmpty(contactName)? contactName: '--',
                "showCheckbox": false,
                "isReportable": true //US2820031 - adding isReportable - true
            },
            {
                "checked": true,
                "defaultChecked": true,
                "fieldName": "Contact Number",
                "fieldType": "outputText",
                "fieldValue": !$A.util.isEmpty(interactionCard.contactNumber) ? interactionCard.contactNumber : '--',
                "showCheckbox": false,
                "isReportable": true //US2820031 - adding isReportable - true
            },
            {
                "checked": true,
                "defaultChecked": true,
                "fieldName": "Contact Ext",
                "fieldType": "outputText",
                "fieldValue": !$A.util.isEmpty(interactionCard.contactExt) ? interactionCard.contactExt : '--',
                "showCheckbox": false,
                "isReportable": true //US2820031 - adding isReportable - true
            }
            
        ];
      	
        cmp.set("v.PNFDetails", cardDetails);
       
    },

	/**setProviderTypeCardData: function (cmp) {
         var pTypeValue = "If  provider is Medical Doctor/Facility:<br/> ";
         pTypeValue += 'Is the provider wanting to become INN, or stating they should be showing as INN? <br/>';
         pTypeValue += '<span class="spaceCls"></span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Yes: Refer to your standard Network Management /  Credentialing process.<br/>';
         pTypeValue += '<span class="spaceCls"></span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;No: Follow your standard research and resolution processes.<br/><br/>';
         pTypeValue += 'If any other provider type:<br/>';
         pTypeValue += 'Access the Misdirect Button and follow standard redirection process.';
      
         var cardDetails = new Object();
         cardDetails.componentName = 'Provider Type';
         cardDetails.componentOrder = 4;
         cardDetails.noOfColumns = "slds-size_10-of-12";
         cardDetails.type = "card";
        cardDetails.cardData = [
            {
                "checked": true,
                "defaultChecked": true,
                "fieldName": "",
                "fieldType": "unescapedHtml",
                "fieldValue":pTypeValue,
                "showCheckbox": false
            },
          
        ];
          
        cmp.set("v.providerTypeCard", cardDetails);
            
    },*/
            
    
	openMisDirect: function (component, event, helper) {
        /**/
        var workspaceAPI = component.find("workspace");
        var interactionCard = component.get("v.interactionRec");
        workspaceAPI.getEnclosingTabId().then(function (enclosingTabId) {
            if (enclosingTabId == false) {
                workspaceAPI.openTab({
                    pageReference: {
                        "type": "standard__component",
                        "attributes": {
                            "componentName": "c__SAE_MisdirectComponent" // c__<comp Name>
                        },
                        "state": {}
                    },
                    focus: true
                }).then(function (response) {
                    workspaceAPI.getTabInfo({
                        tabId: response
                    }).then(function (tabInfo) {
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
                }).catch(function (error) {
                    console.log(error);
                });
            } else {
                workspaceAPI.openSubtab({
                    parentTabId: enclosingTabId,
                    pageReference: {
                        "type": "standard__component",
                        "attributes": {
                            "componentName": "c__SAE_MisdirectComponent" // c__<comp Name>
                        },
                        "state": {
                            "c__originatorName": component.get('v.originatorName'),
                            "c__originatorType": component.get('v.originatorType'),
                            "c__contactName": component.get('v.contactName'),
                            "c__subjectName": component.get('v.subjectName'),
                            "c__subjectType": component.get('v.subjectType'),
                            "c__subjectDOB": component.get('v.subjectDOB'),
                            "c__subjectID": component.get('v.subjectID'),
                            "c__subjectGrpID": component.get('v.subjectGrpID'),
                            "c__interactionID": interactionCard.Id,
                            "c__contactUniqueId": interactionCard.Id,
							"c__focusedTabId": enclosingTabId
                        }
                    }
                }).then(function (subtabId) {

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
                }).catch(function (error) {
                    console.log(error);
                });
            }

        });
    },
})