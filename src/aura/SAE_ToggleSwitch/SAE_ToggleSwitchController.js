({
    changeToggle : function(cmp, event, helper) {
        debugger;      
        cmp.set('v.isToggleOn', !cmp.get('v.isToggleOn'));
        var spinnerEvent = $A.get("e.c:SAE_CaseHistorySpinnerEvent");
        spinnerEvent.setParams({
            "isSpinner": true
        });
        spinnerEvent.fire();
        helper.getMemberCaseHistory(cmp,event,cmp.get("v.xRefId"),cmp.get("v.memberID"));
    },
  
    getUniqueTabID : function(cmp, event, helper) {        
    	cmp.set('v.memberTabIdTemp',event.getParam("memberTabId"));
		
    },

    changeToggleFilter : function(cmp,event,helper){
        cmp.set('v.isToggleOn', !cmp.get('v.isToggleOn'));
        var spinnerEvent = $A.get("e.c:SAE_CaseHistorySpinnerEvent");
        spinnerEvent.setParams({
            "isSpinner": true
        });
        spinnerEvent.fire();
        helper.getMemberCaseHistory(cmp,event,cmp.get("v.xRefId"),cmp.get("v.memberID"));
    }
})