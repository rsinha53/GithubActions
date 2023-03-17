({
    fetchLoyaltyDetails : function(component,event,helper){
        var action = component.get("c.getLoyaltyDetails");
        var memberId = component.get("v.decodedMemberId");
        var memberPolicy = component.get("v.policy");
        var todaysdt = new Date();
        var asofDate = todaysdt.getFullYear()+'-'+(todaysdt.getMonth()+1)+'-'+todaysdt.getDate();
        action.setParams({ memberId : memberId,
                          policyNumber : memberPolicy,
                          asofDate : asofDate});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var resmap = response.getReturnValue();
                var topsOrigCoverageEffectiveDate = resmap['topsOrigCoverageEffectiveDate'];
                var cesCustomerName = resmap['cesCustomerName'];
                component.set('v.employerName',cesCustomerName);
                console.log('***Original Effectiv Date'+topsOrigCoverageEffectiveDate);
                if(topsOrigCoverageEffectiveDate != null && topsOrigCoverageEffectiveDate != ''){
                    var timeDiffInMs = new Date().getTime() - new Date(topsOrigCoverageEffectiveDate).getTime();
                    var daysDiff = timeDiffInMs/(1000*3600*24);
                    var yearsDiff = parseInt(daysDiff/365);
                    component.set('v.loyaltyYearCount',yearsDiff);
                    component.set('v.loyaltyDetailsFetched',true);
                }
                helper.fireEmpEvent(component, event, helper);
            }
            component.set('v.showSpinner',false);
        });
        $A.enqueueAction(action); 
    },

    fireEmpEvent : function(component, event,helper) {  
        var cmpEvent = component.getEvent("empEvent"); 
        cmpEvent.setParams({
            "employerName" : component.get("v.employerName")
        }); 
        cmpEvent.fire();
    }
})