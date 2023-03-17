({
    onInit : function(component, event, helper) {
        var  selectedSvcLineDtlCard = component.get("v.selectedSvcLineDtlCard");
        console.log("selectedSvcLineDtlCard in ACET_ClaimServiceLineDetailController : "+ JSON.stringify(selectedSvcLineDtlCard));
        var currentIndexOfOpenedTabs = component.get("v.currentIndexOfOpenedTabs");
        var maxAutoDocComponents = component.get("v.maxAutoDocComponents");
        selectedSvcLineDtlCard.componentOrder = selectedSvcLineDtlCard.componentOrder + (maxAutoDocComponents*currentIndexOfOpenedTabs);
        if(! component.get("v.isIntrest")){
            var version = component.get("v.version");
            selectedSvcLineDtlCard.componentName='V'+version+' '+selectedSvcLineDtlCard.componentName;
        }
        component.set("v.selectedSvcLineDtlCard",selectedSvcLineDtlCard);
        helper.showSpinner(component, event, helper);
        helper.createAddInfoData(component, event, helper);
    },
    closeServiceLine : function(component, event, helper){
        var compEvent = component.getEvent("closeServiceLineEvent");
        compEvent.setParams({
            "componentUniqueid": component.get("v.componentUniqueid"),
            "rowIndex":component.get("v.rowIndex")
        });
        compEvent.fire();
    },
    //Added by Mani -- Start 12/02/2020
    getGroupName : function (component, event, helper) {
       /* var cardAutoDocData = component.get("v.cardAutoDocData");
        var eventData = event.getParam("eventData");
        console.log("sopEndPointUrl test"+eventData.fieldName);
        console.log("sopEndPointUrl test"+eventData.fieldValue);
        var sopEndPointUrl = eventData.fieldValue;
        if(!$A.util.isUndefinedOrNull(sopEndPointUrl) && !$A.util.isEmpty(sopEndPointUrl)){
           // window.open('https://'+sopEndPointUrl, '_blank');
        }*/
        
		var cardDetails = component.get("v.cardAutoDocData");
        
        var eventData = event.getParam("eventData");
        cardDetails.cardData.push({
        	"checked": true,
                "disableCheckbox": true,
                "fieldName": "",
                "fieldType": "SingleLineUrl",
                "fieldValue": eventData.urlLabel+" was selected." ,
            "hideField": true,
                            "isReportable": true
        });
        /*cardDetails.componentName = "Line Detail";
        cardDetails.componentOrder = 14;
        cardDetails.noOfColumns = "slds-size_1-of-3";
        cardDetails.type = "card";
        cardDetails.allChecked = false;
        var cardData = [];
        cardDetails.cardData = [
            {
                "checked": true,
                "disableCheckbox": true,
                "fieldName": "SOP",
                "fieldType": "outputText",
                "fieldValue": component.get("v.SOPName")+" was selected."
            }
        ];*/
        _autodoc.setAutodoc(component.get("v.autodocUniqueId"), component.get("v.autodocUniqueIdCmp"), cardDetails);
    },
    //Added by Mani -- End
    selectAll :function(component, event, helper) {
        component.find("svcDtloAutoCard").selectAllByDefault();
    }
})