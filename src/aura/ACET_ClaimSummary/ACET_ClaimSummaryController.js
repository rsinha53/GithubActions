({
    //KJ multiple tabs autodoc component order begin
    doInit: function(cmp, event, helper) {
        var selectedClaimDetailCard = cmp.get("v.selectedClaimDetailCard");
        var currentIndexOfOpenedTabs = cmp.get("v.currentIndexOfOpenedTabs");
        var maxAutoDocComponents = cmp.get("v.maxAutoDocComponents");
        var cardData=selectedClaimDetailCard.cardData;
        console.log("policyDetails123456"+JSON.stringify(cmp.get("v.PolicyDetailData")));
        console.log("platform123456"+JSON.stringify(cmp.get("v.platform")));
        console.log("firstSrvcDt@@@"+JSON.stringify(cmp.get("v.firstSrvcDt")));
        let billProviderId = cardData.find(x => x.fieldName === 'Billing Tax ID').fieldValue;
        let adjtaxid = cardData.find(x => x.fieldName === 'Adjudicated Tax ID').fieldValue;
		let adjuProviderId = cardData.find(x => x.fieldName === 'AdjTaxID').fieldValue;
        let bId = cardData.find(x => x.fieldName === 'Billing  Provider ID').fieldValue;
		let aId = cardData.find(x => x.fieldName === 'Adjudicated Provider ID').fieldValue;
		let billProviderName = cardData.find(x => x.fieldName === 'Billing Provider / Status').fieldValue;
		let adjuProviderName = cardData.find(x => x.fieldName === 'Adjudicated Provider / Status').fieldValue;

        switch(cmp.get("v.platform")) {
            case 'COSMOS':
                helper.showSpinner(cmp);
                helper.getMAndRProviderStatus(cmp,helper,billProviderId,bId,'Billing Provider / Status');
                helper.getMAndRProviderStatus(cmp,helper,adjuProviderId,aId,'Adjudicated Provider / Status');
                break;
            case 'UNET':
                helper.showSpinner(cmp);
                helper.getEAndIProviderStatus(cmp,helper,billProviderId,bId,'Billing Provider / Status');
                helper.getEAndIProviderStatus(cmp,helper,adjuProviderId,aId,'Adjudicated Provider / Status');
                break;
            case 'FACETS - CSP':
                helper.getProviderStatus(cmp,'--','Billing Provider / Status');
                helper.getProviderStatus(cmp,'--','Adjudicated Provider / Status');
                break;
        }
        if(bId!=aId){
         var toastEvent = $A.get("e.force:showToast");
           toastEvent.setParams({
           title : 'Warning',
            message:'Warning! This claim has been adjudicated to a different provider than originally billed.',
            duration:'20000',
            key: 'info_alt',
            type: 'warning',
           mode: "dismissible"
        });
        toastEvent.fire();
        }
        selectedClaimDetailCard.componentOrder = selectedClaimDetailCard.componentOrder + (maxAutoDocComponents*currentIndexOfOpenedTabs);
        cmp.set("v.selectedClaimDetailCard",selectedClaimDetailCard);
    },
    //KJ multiple tabs autodoc component order end
    //KJ open provider Lookup from Claim Summary
	handleAutodocEvent: function (cmp, event, helper) {
        var cardDetails = cmp.get("v.selectedClaimDetailCard");
        var eventData = event.getParam("eventData");
        if(eventData.fieldName == "Billing Provider / Status"){
            var providerLink = eventData.fieldValue.split("/");
            var providerName = providerLink[0];
            var taxId = cardDetails.cardData.find(x => x.fieldName === 'Billing Tax ID').fieldValue;
            var providerId = cardDetails.cardData.find(x => x.fieldName === 'Billing  Provider ID').fieldValue;
            if((providerName != '--' && providerName != null) && (taxId != '--' && taxId != null) && (providerId != '--' && providerId != null)){
                helper.getProviderData(cmp, event, helper, taxId, providerId);
                console.log("**callout**");
            }else{
                helper.showToast(cmp,event,helper);
                cmp.set("v.autoCheck",true);
                console.log("**No callout**");
            }
        }else if(eventData.fieldName == "Adjudicated Provider / Status"){
            var providerLink = eventData.fieldValue.split("/");
            var providerName = providerLink[0];
            var taxId = cardDetails.cardData.find(x => x.fieldName === 'Adjudicated Tax ID').fieldValue;
            var providerId = cardDetails.cardData.find(x => x.fieldName === 'Adjudicated Provider ID').fieldValue;
            if((providerName != '--' && providerName != null) && (taxId != '--' && taxId != null) && (providerId != '--' && providerId != null)){
                helper.getProviderData(cmp, event, helper, taxId, providerId);
                console.log("**callout**");
            }else{
                helper.showToast(cmp,event,helper);
                cmp.set("v.autoCheck",true);
                console.log("**No callout**");
            } 
        }else if(eventData.fieldName == "Keyed Claim #"){
            console.log("Keyed Claim # eventData: "+eventData);

            var cnfEvent = cmp.getEvent("CNFEvent");
            cnfEvent.setParams({
                "claimNumber" : eventData.fieldValue,
                "fieldName" : eventData.fieldName
            });
            cnfEvent.fire();

            //helper.callGetClaimsDetails(cmp, event, helper);


        }else if(eventData.fieldName == "Original Claim #"){
            console.log("Original Claim # eventData: "+eventData);
            var cnfEvent = cmp.getEvent("CNFEvent");
            cnfEvent.setParams({
                "claimNumber" : eventData.fieldValue,
                "fieldName" : eventData.fieldName
            });
            cnfEvent.fire();

            //helper.callGetClaimsDetails(cmp, event, helper);

        }

    },
    onTabClosed: function (cmp, event,helper) {

        let tabFromEvent = event.getParam("tabId");
        if( !$A.util.isUndefinedOrNull(tabFromEvent) && cmp.get('v.provAlreadyOpened') ){
            let openedSubTabId = cmp.get('v.openedSubTabId');
            if(tabFromEvent === openedSubTabId ){
                cmp.set('v.openedSubTabId','');
                cmp.set('v.provAlreadyOpened',false);

            }
        }
     }
    //KJ open provider Lookup from Claim Summary End
})