({
    updateAutoDoc : function(component, event, helper) {
        var cardDetails = component.get("v.cardDetails");
        if(!$A.util.isUndefinedOrNull(cardDetails) && !$A.util.isEmpty(cardDetails)){
            var existingCardData = [];
            var latestCardData = [];
            var finalCardData = [];
            if(!$A.util.isUndefinedOrNull(cardDetails.cardData) && !$A.util.isEmpty(cardDetails.cardData)){
                existingCardData = cardDetails.cardData;
                if(component.get("v.postAcuteCareValue") == 'Yes' || component.get("v.postAcuteCareValue") == 'No'){
                    latestCardData.push({
                        "checked": true,
                        "disableCheckbox": false,
                        "defaultChecked": false,
                        "fieldName": "Is this for Post Acute Care Services ?",
                        "fieldType": "outputText",
                        "fieldValue": component.get("v.postAcuteCareValue"),
                        "showCheckbox": false,
                        "hideField": true,
                        "isReportable":false // US3742854
                        },
                        {
                            "checked": true,
                            "disableCheckbox": false,
                            "defaultChecked": false,
                            "fieldName": " ",
                            "fieldType": "emptySpace",
                            "fieldValue": " ",
                            "showCheckbox": false,
                            "isReportable":false // US3742854
                        
                        });
                    console.log('Latest Card Data'+ JSON.stringify(latestCardData));
                    console.log('Existing Card Data'+ JSON.stringify(existingCardData));
                    finalCardData = latestCardData.concat(existingCardData);
                    cardDetails.cardData = finalCardData;
                    component.set("v.cardDetails",cardDetails);
                    _autodoc.setAutodoc(component.get("v.autodocUniqueId"),component.get("v.autodocUniqueIdCmp"), cardDetails);
                    console.log('Post Acute Care Services'+ JSON.stringify(cardDetails));
                }

            }

        }


    },
    
    handleNaviHealthLink: function(cmp, event, helper){
       
            var cardDetails = cmp.get("v.cardDetails");
            if($A.util.isEmpty(cardDetails)){
                var cardDetails = new Object();
                cardDetails.componentName = "Date of Service and Place of Service";
                cardDetails.componentOrder = 4;
                cardDetails.noOfColumns = "slds-size_6-of-12";
                cardDetails.type = "card";
                cardDetails.cardData = [{
                    "checked": true,
                    "defaultChecked": false,
                    "fieldName": "Access the Navi Health Delegation Tool",
                    "fieldType": "outputText",
                    "fieldValue": "Accessed",
                    "showCheckbox": false,
                    "hideField": true,
                    "isReportable": true
                }];
              
                _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"), cmp.get("v.autodocUniqueIdCmp"), cardDetails);
            }else{
                var isPresent = false;
                for (var data in cardDetails.cardData) {
                    
                    if (cardDetails.cardData[data].fieldName === "Access the Navi Health Delegation Tool"  &&
                        cardDetails.cardData[data].fieldValue === "Accessed") {
                        isPresent = true;
                        console.log("Already Autodoced");
                    }
                }
                if (!isPresent && !$A.util.isEmpty(cardDetails)) {
                    cardDetails.cardData.push({
                        "checked": true,
                        "defaultChecked": false,
                        "fieldName": "Access the Navi Health Delegation Tool",
                        "fieldType": "outputText",
                        "fieldValue": "Accessed",
                        "showCheckbox": false,
                        "hideField": true,
                        "isReportable": true
                    });
                    
                }
                _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"), cmp.get("v.autodocUniqueIdCmp"), cardDetails);
            }
       
    }
})