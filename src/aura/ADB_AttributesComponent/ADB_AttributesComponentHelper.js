({
    setAttributes: function(component,event,helper){
        var val = component.get("v.TransactionsAccountsData");
        if(val != null || val != undefined){
            var accShortName = component.get("v.AccShortName");
            helper.updateAtttributes(component,event,helper,accShortName);
        }
    },
    // Binod
    updateAtttributes : function(component,event,helper,accShortName){
        console.log('Attributes Selected Account : '+accShortName);
        var tranAccData = component.get("v.TransactionsAccountsData"); //contains the json string
        var tList=[];
        tranAccData.forEach(function(act){
            if(act.accountType == accShortName || (act.accountType == 'HRA' && accShortName == 'HRAAP')||(act.accountType == 'FSA' && accShortName == 'FSA LIM')|| (act.accountType == 'FSA DC' && accShortName == 'FSADC') || (act.accountType == 'FSA' && accShortName == 'FSAHC') || (act.accountType == 'FSA' && accShortName == 'FSALP')){
                component.set("v.spendingCardType",act.spendingCardType);
                component.set("v.coordinatedPayment",act.coordinatedPayment);
                component.set("v.preFunded",act.preFunded);
                component.set("v.allowCoordPayOver",act.allowCoordPayOver);
                component.set("v.disableOverrideFromPortal",act.disableOverrideFromPortal);
                component.set("v.carryoverIndicator",act.carryoverIndicator);
                component.set("v.acctPlanYearGracePeriodExpirationDate",act.acctPlanYearGracePeriodExpirationDate);
            }
        });
    }
})