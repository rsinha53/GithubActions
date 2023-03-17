({
    doInit: function(cmp,event, helper){
        cmp.set('v.selectedRadioOption', '');
        cmp.set('v.selectedRadioOption2', '');
    },
    openPreview: function (cmp,event, helper) {
        
        helper.createPreview(cmp);
        var selectedString = _autodoc.getAutodoc(cmp.get("v.autodocUniqueId"));
        cmp.set("v.tableDetails_prev",selectedString);
        cmp.set("v.showpreview",true);
    },
    SaveCase: function(cmp,event, helper){
        
        if(!helper.fireProviderTypeValidations(cmp)){
            return;
        }
        helper.createPreview(cmp);
        var caseWrapper = cmp.get("v.caseWrapper");
        var interactionCard = cmp.get("v.interactionCard");
        
        //DefaultCase item
        var caseItem = new Object();
        caseItem.uniqueKey = !$A.util.isEmpty(interactionCard.taxIdOrNPI) ? interactionCard.taxIdOrNPI : '';
        caseItem.isResolved = true;
        caseItem.topic = 'Provider Not Found';//DE391078 - Sravan
        var caseItemList = [];
        caseItemList.push(caseItem);
        caseWrapper.caseItems = caseItemList;
        
        var selectedString = _autodoc.getAutodoc(cmp.get("v.autodocUniqueId"));
        var jsString = JSON.stringify(selectedString);
        caseWrapper.pnfExternalId =  !$A.util.isEmpty(interactionCard.taxIdOrNPI) ? interactionCard.taxIdOrNPI : '';
        caseWrapper.savedAutodoc = jsString;
        cmp.set("v.caseWrapper", caseWrapper);
        cmp.set("v.isModalOpen", true);
    },
    handleOneSourceLink: function (cmp, event, helper) {
        var nwmCard = new Object();
        nwmCard.type = 'card';
        nwmCard.componentName = 'Network Management (NWM) ';
        nwmCard.noOfColumns = 'slds-size_6-of-12';
        nwmCard.componentOrder = 1;
        var cardData = [];
        cardData.push(new fieldDetails(true,false,true,'Network Management (NWM) ','Accessed','outputText', true));
        nwmCard.cardData = cardData;        
        _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"),cmp.get("v.autodocUniqueId"), nwmCard);
        function fieldDetails(c, dc, sc, fn, fv, ft, ir) {
            this.checked = c;
            this.defaultChecked = dc;
            this.showCheckbox = sc;
            this.fieldName = fn;
            this.fieldValue = fv;
            this.fieldType = ft;
            this.isReportable = ir; 
        }
    },
    togglePopup : function(cmp, event) {
        let showPopup = event.currentTarget.getAttribute("data-popupId");
        cmp.find(showPopup).toggleVisibility();
    },
    handleKeyup : function(cmp) {
        var inputCmp = cmp.find("commentsBoxId");
        var value = inputCmp.get("v.value");
        var max = 2000;
        var remaining = max - value.length;
        cmp.set('v.charsRemaining', remaining);
        var errorMessage = 'Error!  You have reached the maximum character limit.  Add additional comments in Case Details as a new case comment.';
        if (value.length >= 2000) {
            inputCmp.setCustomValidity(errorMessage);
            inputCmp.reportValidity();
        } else {
            inputCmp.setCustomValidity('');
            inputCmp.reportValidity();
        }
    },
    handleRadioChange: function (cmp, event, helper) {
        let changedValue = event.getParam("value");
        console.log(event.getSource().get("v.name"));
        if(event.getSource().get("v.name") == 'radioGroup1'){
            cmp.set('v.selectedRadioOption2', '');
        }else{
            helper.fireProviderTypeValidations(cmp);
        }
        console.log(cmp.get('v.selectedRadioOption2'));
    },
})