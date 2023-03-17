({
    
    createFamilyPersonAccount : function(cmp, event,helper) {
        var action = cmp.get("c.getSaveHouseHoldData");
        var workspaceAPI = cmp.find("workspace");
        var memberData = event.getParam('arguments');
        var householdInfo = memberData.householdWrapperComponent;
        var dateDob = memberData.dateDob;
        var memberId = memberData.memberId;
        var advisorName = memberData.advisorName;
        var sniEligible = memberData.sniEligible;
        var policyIdVal = memberData.policyId;
        var policyIdOriginal = memberData.policyIdOriginal;
        var assignTo = memberData.assignTo;
        console.log('window.location.pathname........*******'+window.location.pathname);
        console.log('assignTo........*******'+assignTo);
        cmp.set("v.householdWrapper", householdInfo);
        action.setParams({
            "houseHoldData": householdInfo,
            "dob": dateDob,
            "memberId":memberId,
            "advFullName":advisorName,
            "sniEligibleStatus":sniEligible,
            "policyId":policyIdVal,
            "policyIdOrignal":policyIdOriginal,
            "assignTo":assignTo
        });
        
        action.setCallback(this, function (response) {
            console.log(response.getError());
            var state = response.getState(); // get the response state
            var result = response.getReturnValue();
            console.log('result');
            console.log(result);
            if (state == 'SUCCESS' && result) {
                
                var IdsPersonFamilyAccount = result.split('@');
                console.log('IdsPersonFamilyAccount------------'+IdsPersonFamilyAccount[1]);
                console.log('Hello'+IdsPersonFamilyAccount[0]+'---'+IdsPersonFamilyAccount[1]);
                console.log(document.location.pathname.indexOf("/lightning/"));
                if(document.location.pathname.indexOf("/lightning/") != 0){
                    var navEvt = $A.get("e.force:navigateToSObject");
                    navEvt.setParams({
                        "recordId": IdsPersonFamilyAccount[1],
                        //"slideDevName": "related"
                    });
                    navEvt.fire();
                }else{
                    workspaceAPI.openTab({
                        url: '/lightning/r/Account/'+IdsPersonFamilyAccount[0]+'/view',
                        focus: true
                        
                    }).then(function(response) {
                        var setEvent = cmp.getEvent("setShowSpinner");// US2021959 :Code Added By Chandan-Start 
                        setEvent.fire();// US2021959 :Code Added By Chandan 
                        workspaceAPI.openSubtab({
                            parentTabId: response,
                            url: '/lightning/r/Account/'+IdsPersonFamilyAccount[1]+'/view',
                            focus: true
                        });
                    }).catch(function(error) {
                        
                    });
                }
            }
            else{ // data nulll
                cmp.set('v.showServiceErrors', true);
                if (cmp.get("v.showHideMemAdvSearch") == true && cmp.get("v.displayMNFFlag") == true) {
                    cmp.set("v.mnf", 'mnf');
                    cmp.set("v.checkFlagmeberCard",false); //Added By Avish on 07/25/2019
                }
                cmp.set('v.serviceMessage', 'This member is not SNI Eligible.');
                helper.fireToast('This member is not SNI Eligible.');
                var setEvent = cmp.getEvent("setShowSpinner");// US2021959 :Code Added By Chandan-Start 
                setEvent.fire();// US2021959 :Code Added By Chandan 
            }
        }); 
        $A.enqueueAction(action);
    }
    
})