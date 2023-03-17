({
    getHSADetails: function(component, event, helper) {
        component.set("v.accountList", event.getParam("accountList"));
		component.set("v.Syntheticid",component.get("v.accountList[0].syntheticId"));
        component.set("v.rowIndex", event.getParam("index"));
        var indexvalue = component.get("v.rowIndex");
        component.set("v.accountType", event.getParam("accountType"));
        component.set("v.investmentPlan", component.get("v.accountList[0].nonNotionalAccountDetails[0].invstCurrPlanName"));
        component.set("v.investmentThreshold", component.get("v.accountList[0].nonNotionalAccountDetails[0].invstCurrThresholdAmt"));
        component.set("v.mutualFundBalance", component.get("v.accountList[0].nonNotionalAccountDetails[0].invstTotalBalance"));
        component.set("v.mutualFundStatus", component.get("v.accountList[0].nonNotionalAccountDetail[0].invstCurrStatusDesc"));
        component.set("v.hsbaBalance", component.get("v.accountList[0].nonNotionalAccountDetails[0].invstHSBATotalBalance"));
        component.set("v.hsbaStatus", component.get("v.accountList[0].nonNotionalAccountDetails[0].invstHSBAStatusDesc"));
        component.set("v.hsbaCashBalance", component.get("v.accountList[0].nonNotionalAccountDetails[0].invstHSBACashBalance"));
        component.set("v.bettermentBalance", component.get("v.accountList[0].nonNotionalAccountDetails[0].invstBMTTotalBalance"));
        component.set("v.bStatus", component.get("v.accountList[0].nonNotionalAccountDetails[0].invstBMTStatusDesc"));
        component.set("v.mutualFundStatus", component.get("v.accountList[0].nonNotionalAccountDetails[0].invstCurrStatusDesc"));
        var invstBalance = ((component.get("v.mutualFundBalance")) + (component.get("v.hsbaBalance")) + (component.get("v.bettermentBalance")));
        component.set("v.investmentBalance", invstBalance);
		//US3254502 Autodoc Investments - Investments Details Helper
        helper.autodocInvestments(component, event, helper);
    },
	//Added by Prasad-US3083550: Integration: Field mapping-View Investments for HSA Account
    investmentSummery :function(component, event, helper) {
                  var action = component.get("c.investmentSummery");
                 component.set("v.Spinner", true);
                    action.setParams({
                    "syntheticId": component.get("v.Syntheticid")
                });
          action.setCallback(this, function(response) {
               var state = response.getState(); //Checking response status
               var responseValue = JSON.parse(JSON.stringify(response.getReturnValue()));
               if ((responseValue != null) && (component.isValid()) && (state === "SUCCESS")) {
              if(responseValue != null && !($A.util.isUndefinedOrNull(responseValue.result)) && !((Object.keys(responseValue.result).length)==0) 
                     && !($A.util.isUndefinedOrNull(responseValue.result.data)) && !((Object.keys(responseValue.result.data).length) == 0)) {
                 component.set("v.Spinner", false);
                 component.set("v.investments", responseValue.result.data);
                 //US3254502 Autodoc Investments - Sweep Details Helper
                 helper.autodocInvestmentSweep(component, event, helper);
                  } 
            }
              else if ((responseValue == null) || (state === "ERROR")) {
               component.set("v.Spinner", false);
               component.set("v.APIResponse", true);
            }
            else if (state === "INCOMPLETE") {
                component.set("v.Spinner", false);
            }
        });
      $A.enqueueAction(action);
     },
    //US3254502 Autodoc Investments 
    autodocInvestmentSweep :function(component, event, helper) {
        var sweepData = component.get("v.investments");
        var sweepDataList = [];
        var details={status:sweepData.sweepStatus
                     ,threshold:sweepData.sweepAmount
                     ,account:sweepData.sweepAccount
                    };
        sweepDataList.push(details);
        var action = component.get('c.getautoDocInvestmentSweep');
        action.setParams({
            "sweepDataList": sweepDataList
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var responseValue = JSON.stringify(response.getReturnValue());
            if ((state === "SUCCESS")){
                component.set("v.investmentSweepDetails" ,response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    //US3254502 Autodoc Investments
    autodocInvestments :function(component, event, helper) {
        var dataList = [];
        var investDetail={title:'Investments',balance:component.get("v.investmentBalance"),status:component.get("v.investmentStatus"),
                          plan:component.get("v.investmentPlan"),cashBalance:'',investThreshold:component.get("v.investmentThreshold")};
        var mutualfndsDetail={title:'Mutual Funds',balance:component.get("v.mutualFundBalance"),status:component.get("v.mutualFundStatus"),
                              plan:'',cashBalance:'',investThreshold:''};
        var hsbaDetail={title:'HSBA',balance:component.get("v.hsbaBalance"),status:component.get("v.hsbaStatus"),
                        plan:'',cashBalance:component.get("v.hsbaCashBalance"),investThreshold:''};
        var betterDetail={title:'Betterment',balance:component.get("v.bettermentBalance"),status:component.get("v.bStatus"),
                          plan:'',cashBalance:'',investThreshold:''};
        dataList.push(investDetail);
        dataList.push(mutualfndsDetail);
        dataList.push(hsbaDetail);
        dataList.push(betterDetail);
        var action = component.get('c.getautoDocInvestment');
        action.setParams({
            "dataList": dataList
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var responseValue = JSON.stringify(response.getReturnValue());
            if ((state === "SUCCESS")){
                component.set("v.investmentDetails" ,response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    } 
})