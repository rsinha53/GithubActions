({
    showMemberSpinner: function (component) {
        var spinner = component.find("caseHistory-spinner");
        $A.util.removeClass(spinner, "slds-hide");
        $A.util.addClass(spinner, "slds-show");
    },//US1888880 - Malinda : Spinner-hide method
    hideMemberSpinner: function (component) {
        var spinner = component.find("caseHistory-spinner");
        $A.util.removeClass(spinner, "slds-show");
        $A.util.addClass(spinner, "slds-hide");
        //return null;
    },
  
    getMemberCaseHistory: function (cmp,event,xRefId,memberID){
        var action = cmp.get("c.getRelatedCasesHistory");
        
        action.setParams({
            "taxMemberID": memberID,
            "xRefIdIndividual": xRefId,
            "toggleOnOff": cmp.get('v.isToggleOn'),
            "flowType": 'Member'
           
        });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state == 'SUCCESS') {
                var caselst = [];
                console.log(JSON.stringify(response.getReturnValue()));
                caselst = response.getReturnValue();
                cmp.set("v.caseHistoryList", caselst);
                var appEvent = $A.get("e.c:SAE_CaseToggleHistory");
                appEvent.setParams({"caseHistoryList" : cmp.get("v.caseHistoryList"), "memberTabId" : cmp.get("v.memberTabId")});
                appEvent.fire();                
            }
        });
        $A.enqueueAction(action);
    }
})