({
	doInit: function (cmp, event, helper) {
        
			
			if(!cmp.get("v.isMemberInfocus")){
				cmp.set("v.cardDetails", helper.getDefaultCard(cmp));
			    helper.setCardData(cmp);
			} else{
				helper.loadCardDetails(cmp);
			}
       
    },
	toggleSection: function (cmp, event, helper) {
        var sectionAuraId = event.target.getAttribute("data-auraId");
        var sectionDiv = cmp.find(sectionAuraId).getElement();
        
        var sectionState = sectionDiv.getAttribute('class').search('slds-is-open');
        
        if (sectionState == -1) {
            sectionDiv.setAttribute('class', 'slds-section slds-is-open');
			
			if(!cmp.get("v.isMemberInfocus")){
				cmp.set("v.cardDetails", helper.getDefaultCard(cmp));
			} else{
				helper.loadCardDetails(cmp);
			}
        } else {
            sectionDiv.setAttribute('class', 'slds-section slds-is-close');
        }
	},
})