({
	onInit : function(component, event, helper) {
     	
        var  selectedSvcLineAddInfoCard = component.get("v.selectedSvcLineAddInfoCard");
        console.log("selectedSvcLineAddInfoCard in ACET_ServiceLinAdditionalInfo : "+ JSON.stringify(selectedSvcLineAddInfoCard));
		var currentIndexOfOpenedTabs = component.get("v.currentIndexOfOpenedTabs");
        var maxAutoDocComponents = component.get("v.maxAutoDocComponents");
        selectedSvcLineAddInfoCard.componentOrder = selectedSvcLineAddInfoCard.componentOrder + (maxAutoDocComponents*currentIndexOfOpenedTabs);
        component.set("v.selectedSvcLineAddInfoCard",selectedSvcLineAddInfoCard);
        //helper.createAddInfoData(component);

	},
    selectAll :function(component, event, helper) {
        component.find("addInfoAutoCard").selectAllByDefault();
    },

    setLinkAutodoc:function(component, event, helper) {
        if(component.get("v.autoDocLink")){
                        component.set("v.autoDocLink",false);
         var cardDetails = component.get("v.selectedSvcLineAddInfoCard");
                        cardDetails.cardData.push({
                            "checked": true,
                            "disableCheckbox": false,
                            "showCheckbox": false,
                            "fieldName": '',
                            "fieldType": "outputText",
                            "fieldValue":cardDetails.cardData[1].urlLabel+" was selected.",
                            "hideField": true,
                            "isReportable": true
                        });

                    _autodoc.setAutodoc(component.get("v.autodocUniqueId"),component.get("v.autodocUniqueIdCmp"), cardDetails);

        }}
})