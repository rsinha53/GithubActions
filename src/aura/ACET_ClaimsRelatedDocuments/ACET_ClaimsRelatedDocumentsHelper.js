({
    autoDocLink: function (component, event, helper,fieldName,fieldValue) {
        var cardDetails = new Object();
        var currentIndexOfOpenedTabs = component.get("v.currentIndexOfOpenedTabs");
        var maxAutoDocComponents = component.get("v.maxAutoDocComponents");
         var claimNo=component.get("v.claimNo");
         cardDetails.reportingHeader = "Claim Related Documents";
         cardDetails.caseItemsExtId = claimNo;
        cardDetails.componentName = "Claim Related Documents: "+claimNo;
        cardDetails.componentOrder = 9 + (maxAutoDocComponents*currentIndexOfOpenedTabs);
        cardDetails.noOfColumns = "slds-size_1-of-1";
        cardDetails.type = "card";
        cardDetails.allChecked = false;
        var cardData = [];
        cardDetails.cardData = [
            {
                "checked": true,
                "disableCheckbox": true,
                "fieldName": fieldName,
                "fieldType": "outputText",
                "fieldValue": fieldValue,
                "isReportable":true
            }
        ];
         component.set("v.cardDetails",cardDetails);
        _autodoc.setAutodoc(component.get("v.autodocUniqueId"),component.get("v.autodocUniqueIdCmp"), cardDetails);

    },
    autoDocLink1: function (component, event, helper,fieldName,fieldValue) {
        var cardDetails = component.get("v.cardDetails");
        var index = cardDetails.cardData.findIndex(function(data){
            return data.fieldName == fieldName;
        });
        //if(index == -1){}
            cardDetails.cardData.push({
                "checked": true,
                "disableCheckbox": true,
                "fieldName": fieldName,
                "fieldType": "outputText",
                "fieldValue": fieldValue,
                "isReportable":true
            });
        
             _autodoc.setAutodoc(component.get("v.autodocUniqueId"),component.get("v.autodocUniqueIdCmp"), cardDetails);

        }
    })