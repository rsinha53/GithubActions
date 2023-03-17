({
    
    // DE267648 - Thanish - 10th Oct 2019
    doInit: function(component, event, helper) {  
    
        var pageReference = component.get("v.pageReference");
        
        //Added by Vinay for Pilot 
        var interactionCard = pageReference.state.c__interactionCard;
        var contactName = pageReference.state.c__contactName;
        var interactionRec = pageReference.state.c__interactionRec;
        //US2076634 - HIPAA Guidelines Button - Sravan - Start
        var hipaaEndPointUrl = pageReference.state.c__hipaaEndpointUrl;
        component.set("v.hipaaEndpointUrl",hipaaEndPointUrl);
        //US2076634 - HIPAA Guidelines Button - Sravan - End
        component.set("v.contactName",contactName);
        component.set("v.interactionCard",interactionCard);
        component.set("v.interactionRec",interactionRec);
        
        var autodockey =  interactionCard.taxIdOrNPI;
        component.set("v.autodocUniqueId",autodockey );
        
        var caseWrapper = pageReference.state.c__caseWrapper;
        //DE315205
        caseWrapper.providerNotFound = true;
        caseWrapper.pnfExternalId = interactionCard.taxIdOrNPI;
        
        //US2699902 - Avish
        caseWrapper.contactNumber = pageReference.state.c__contactNumber;
        caseWrapper.contactExt = pageReference.state.c__contactExt; 
       
        if(! $A.util.isEmpty(caseWrapper)){
            component.set("v.caseWrapper", caseWrapper);
        }

        // US2960236: Add Link to NWM OneSource - Krish
        var oneSourceLink = "http://knowledgecentral.uhc.com/SPA/ProviderCallAdvocateNetworkManagement/index.html#/"
        component.set("v.oneSourceLink", oneSourceLink);

        
        // US2119567 - Thanish - 20th Nov 2019
        //component.set("v.AutodocPageFeature", interactionCard.taxIdOrNPI + interactionCard.phone);
        //component.set("v.AutodocKey", ('PNF' + interactionCard.taxIdOrNPI + interactionCard.phone));
        // setTimeout(function(){
        //     var tabKey = component.get("v.AutodocKey");
        //     window.lgtAutodoc.initAutodoc(tabKey);
        // },1500);
        // End of Code - US2119567 - Thanish - 20th Nov 2019
        // 
        //helper.setContactInfoCardData(component);
        helper.setPNFCardData(component);
        //helper.setProviderTypeCardData(component);
     
        component.find("pnfSpinner").set("v.isTrue", false);
       
        // DE380979 - Thanish - Snapshot duplicate fix
        var snapshotLink = document.getElementById(pageReference.state.c__ioProviderSnapshotLinkId);
        if(!$A.util.isEmpty(snapshotLink)){
            $A.util.removeClass(snapshotLink, "disableLink");
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
	
	navigateToDetail:function(component,event,helper){
        var intId = event.currentTarget.getAttribute("data-intId");
        console.log(intId);
        
        var workspaceAPI = component.find("workspace");
        workspaceAPI.openSubtab({
            pageReference: {
                type: 'standard__recordPage',
                attributes: {
                    actionName: 'view',
                    objectApiName: 'Interaction__c',
                    recordId : intId  
                },
            },
            focus: true
        }).then(function(response) {
            workspaceAPI.getTabInfo({
                tabId: response
                
            }).then(function(tabInfo) {
               
            });
        }).catch(function(error) {
            console.log(error);
        });
    },
    
    openMisdirectComp: function (component, event, helper) {
        helper.openMisDirect(component, event, helper);
    },
    openModal: function(component, event, helper) {    
        component.set("v.isModalOpen", true);
    },
    
    openPreview : function(cmp) {
        cmp.find("pnf").selectAllByDefault();
        cmp.find("pnf1").selectAllByDefault();
        cmp.find("pnf2").selectAllByDefault();
        var selectedString = _autodoc.getAutodoc(cmp.get("v.autodocUniqueId"));
        cmp.set("v.tableDetails_prev",selectedString);
        cmp.set("v.showpreview",true);
    },
    
    handleHippaGuideLines: function (cmp, event, helper) {
        var hipaaCard = new Object();
        hipaaCard.type = 'card';
        hipaaCard.componentName = 'HIPAA Guidelines';
        hipaaCard.noOfColumns = 'slds-size_6-of-12';
        hipaaCard.componentOrder = 1;
        var cardData = [];
        cardData.push(new fieldDetails(true,false,true,'HIPAA Guidelines','Accessed','outputText'));
        hipaaCard.cardData = cardData;        
        _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"),cmp.get("v.autodocUniqueId"), hipaaCard);
        function fieldDetails(c, dc, sc, fn, fv, ft) {
            this.checked = c;
            this.defaultChecked = dc;
            this.showCheckbox = sc;
            this.fieldName = fn;
            this.fieldValue = fv;
            this.fieldType = ft;
        }
        
        var hipaaEndPointUrl = cmp.get("v.hipaaEndpointUrl");
        if (!$A.util.isUndefinedOrNull(hipaaEndPointUrl) && !$A.util.isEmpty(hipaaEndPointUrl)) {
            window.open(hipaaEndPointUrl, '_blank');
        }
        
    },
    
    SaveCase : function(cmp) {
        cmp.find("pnf").selectAllByDefault();
        cmp.find("pnf1").selectAllByDefault();
        cmp.find("pnf2").selectAllByDefault();
        
        var caseWrapper = cmp.get("v.caseWrapper");
        var interactionCard = cmp.get("v.interactionCard");
        
        //DefaultCase item
        var caseItem = new Object();
        caseItem.uniqueKey = !$A.util.isEmpty(interactionCard.taxIdOrNPI) ? interactionCard.taxIdOrNPI : '';
        caseItem.isResolved = true;
        caseItem.topic = 'Provider Not Found';//US3071655 - Sravan
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
    
   // this function automatic call by aura:waiting event  
    showSpinner: function(component, event, helper) {
       // make Spinner attribute true for display loading spinner 
        component.set("v.Spinner", true); 
   },
    
 // this function automatic call by aura:doneWaiting event 
    hideSpinner : function(component,event,helper){
     // make Spinner attribute to false for hide loading spinner    
       component.set("v.Spinner", false);
    },

    // US3648370
    displayPreview: function (cmp, event, helper) {
        var providerType = cmp.find("providerType");
        providerType.openPreview();
    },

    saveCase: function (cmp, event, helper) {
        var providerType = cmp.find("providerType");
        providerType.saveCase();
    }

})