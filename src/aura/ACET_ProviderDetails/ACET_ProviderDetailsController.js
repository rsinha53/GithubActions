({
    openPreview : function(cmp) {
        var selectedString = _autodoc.getAutodoc(cmp.get("v.autodocUniqueId"));
        cmp.set("v.tableDetails_prev",selectedString);
        cmp.set("v.showpreview",true);
    },

    SaveCase : function(cmp) {
        var caseWrapper = cmp.get("v.caseWrapper");
        var selectedString = _autodoc.getAutodoc(cmp.get("v.autodocUniqueId"));
		var jsString = JSON.stringify(selectedString);
        caseWrapper.savedAutodoc = jsString;
        //DefaultCase item
        var caseItem = new Object();
        caseItem.uniqueKey = caseWrapper.plTaxId;
        caseItem.isResolved = true;
        caseItem.topic = 'Provider Details';//US3071655 - Sravan
        var caseItemList = new Array();
        caseItemList.push(caseItem);
        caseWrapper.caseItems = caseItemList;

        cmp.set("v.caseWrapper", caseWrapper);
        cmp.set("v.isModalOpen", true);
    },

    provDataChange: function(cmp) {
        var childComponent = cmp.find("providerDetails");
        childComponent.autodocByDefault();
    },

    goToLink: function(cmp) {
        
    },

    // DE376017 - Thanish - 16th Oct 2020
    openTTSPopup  : function(cmp, event, helper){
        if(event.getParam("autodocKey") == cmp.get("v.autodocUniqueId")){
            if(event.getParam("linkClicked")){
                var cardDetails = new Object();
                cardDetails.componentName = "Network Management Request";
                cardDetails.componentOrder = 2;
                cardDetails.noOfColumns = "slds-size_6-of-12";
                cardDetails.type = "card";
                cardDetails.allChecked = false;
                cardDetails.cardData = [
                    {
                        "checked": true,
                        "disableCheckbox": true,
                        "defaultChecked": true,
                        "fieldName": "Provider Call Advocate Network Management/Credentialing/Demographic SOP Link",
                        "fieldType": "outputText",
                        "fieldValue": "Accessed",
                        "showCheckbox": true,
                        "isReportable":true
                    }
                ];
                _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"), cmp.get("v.autodocUniqueId"), cardDetails);
            }
            cmp.set("v.isModalOpen", event.getParam("openPopup"));
        }
    },

    // US3516065: Enable Route Button: Provider Snapshot - Krish - 8th June 2021
    addComments: function(cmp){
        var showAddCommentsCard = cmp.get('v.showAddCommentsCard');
        if(!showAddCommentsCard){
            cmp.set('v.showAddCommentsCard', true);
            cmp.set("v.disableCommentButton", true);
        }
    },

    disableButtonsChange: function(cmp){
        var disableButtons = cmp.get('v.disableButtons');
        if(disableButtons){
            cmp.set('v.showAddCommentsCard', false);
            cmp.set('v.commentsValue', "");
            cmp.set("v.disableCommentButton", false);
        }
    },
    togglePopup : function(cmp, event) {
        let showPopup = event.currentTarget.getAttribute("data-popupId");
        cmp.find(showPopup).toggleVisibility();
    },
    handleKeyup : function(cmp) {
        var inputCmp = cmp.find("commentsBoxId");
        var value = inputCmp.get("v.value");
        var errorMessage = 'Error!� You have reached the maximum character limit.� Add additional comments in Case Details as a new case comment.';
        if (value.length >= 2000) {
            inputCmp.setCustomValidity(errorMessage);
            inputCmp.reportValidity();
        } else {
            inputCmp.setCustomValidity('');
            inputCmp.reportValidity();
        }
    },
})