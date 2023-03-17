({
    checkingdate:function(component, event, helper) {
        console.log("Checking Data" + JSON.stringify(component.get("v.accountList")));
        // console.log("account" + JSON.stringify(component.get("v.accountList")));
        helper.dateFormat(component , event ,helper);
        helper.getorgInfo(component, event, helper);
        
    },
	updateData: function(component, event, helper) {
		//DE432638 Autodoc selection stays in memory
		component.set("v.autodocUniqueId",event.getParam("autodocUniqueId"));
        component.set("v.autodocUniqueIdCmp",event.getParam("autodocUniqueIdCmp"));
		
       // setTimeout(() => { console.log("World!"); }, 2000);
        component.set("v.accountList",event.getParam("accountList"));
       component.set("v.rowIndex",event.getParam("index"));
        component.set("v.accountType", event.getParam("accountType"));
        component.set("v.faroId", event.getParam("faroId"));
        console.log("Inside updateData Account Detail" + JSON.stringify(component.get("v.accountList")));
        helper.dateFormat(component , event ,helper);
		 var accType = component.get("v.accountType");
       // Added by Manohar for freeze issue
        if(accType == 'HSA'){
		helper.setAutodocCardData(component , event ,helper);
        helper.setCardData(component , event ,helper);
        helper.setemployerCardData(component , event ,helper);
		}
        if(accType == 'Notional'){ 
        var sysntheticId = component.get("v.Syntheticid");
        var accountStatus = component.get("v.accountStatus");
        var planEffectiveDate = component.get("v.planEffectiveDate");
        var checkType = component.get("v.checkType");
        var accListSynthID = component.get("v.accountList[0].syntheticId");
        var accListaccStatus = component.get("v.accountList[0].notionalAccountDetails[0].accountStatus")
        var accListplanEffectiveDate = component.get("v.accountList[0].notionalAccountDetails[0].acctPlanYearEffectiveDate")
        var accListAccountType = component.get("v.accountList[0].accountType")
        if((sysntheticId !== accListSynthID && accountStatus !== accListaccStatus && planEffectiveDate !== accListplanEffectiveDate) || checkType !== accListAccountType)
        {
        helper.getProviderData(component, event ,helper);
        //US3243924 Autodoc Notional Account Details
        helper.accountinfoNotional(component , event ,helper);
        helper.productinfoNotional(component , event ,helper);
        helper.balanceinfoNotional(component , event ,helper);
        helper.debitinfoNotional(component , event ,helper);
        helper.employerinfoNotional(component , event ,helper);
            }
        }
    },
    viewAlert: function (cmp, event, helper) {
		helper.alertHistory(cmp,event,helper);    
  	},
    viewTaxDocs: function (cmp, event, helper) {
		helper.taxDocs(cmp,event,helper);    
  	},
     
})