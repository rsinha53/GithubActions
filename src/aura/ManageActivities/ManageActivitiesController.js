({
	doInit: function(component, event, helper) {
        
        let state = component.get("v.pageReference").state;
        var memberId = state.c__memberId;
        var acctId = state.c__acctId;
        
        if(memberId){
            window.open($A.get("$Label.c.LeaguePortal")+'?familyId='+ state.c__memberId,'_blank');
            helper.closeTab(component, event, helper);
        }else{
            helper.getAccountDetailsHelper(component, event, helper, acctId);
        }
		
    }
})