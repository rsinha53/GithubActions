({
    openCAMSUrl: function(component, event, helper) {
        // var accNumMemId = component.get("v.accNum");
        var action = component.get("c.getCAMSUrlStatic");
        // action.setParams({
        //     memberId : accNumMemId
        // });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var resp = response.getReturnValue();
				
                if(resp != null && resp != ''){
                    window.open(resp, '_blank','width=1000, height=800, resizable scrollbars');
                }
            }
            
        });
        $A.enqueueAction(action);
    },
    getDeductiblesAndOOPMax : function(component,event,helper,hsaaccess){
        var wrapper = component.get("v.FIMWrapper");
        console.log('spending FIM : ', wrapper.callerSSN);
        var SSN;
        if(wrapper != undefined && wrapper !=null && wrapper.callerSSN !=null && wrapper.callerSSN.length == 9){
            SSN = wrapper.callerSSN;
        }
        else
            SSN = '';
        var action = component.get("c.fetchFinancialOverviews");
        console.log('spending : ', component.get("v.memberId"));
        console.log('spending : ', component.get("v.firstName"));
        console.log('spending : ', component.get("v.lastName"));
        console.log('spending : ', component.get("v.birthdate"));
        console.log('spending : ', component.get("v.planNumber"));
        console.log('spending SSN: ', SSN);
        action.setParams({
            memberId: component.get("v.memberId"),
            fName: component.get("v.firstName"),
            lName: component.get("v.lastName"),
            planNumber: component.get("v.planNumber"),
            birthdate: component.get("v.birthdate"),
            hsaaccess : hsaaccess,
            ssn: SSN
        });
        action.setCallback(this,function(response){
           var state = response.getState();
            component.set("v.showSpinner", false);
            if (state === "SUCCESS") {
                
                var resp = response.getReturnValue();
                console.log('in success of financials api call'+JSON.stringify(resp));
                console.log('resp.transactionWrapper'+JSON.stringify(resp.transactionWrapper));
                //	deductibles and OOP
                if(null != resp.deductiblesWrapper){
                	component.set("v.financials", resp.deductiblesWrapper);
                }
                //	contributions
                //	var shortName = component.get("v.FinOverviewData.account[0].accountTypeCode");
                if(null!= resp.contributionsWrapper){
                    if(resp.contributionsWrapper.accountBalance != null) {
                        console.log('resp.contributionsWrapper.accountBalance'+JSON.stringify(resp.contributionsWrapper.accountBalance));
                        component.set("v.financialsAccountsData",resp.contributionsWrapper.accountBalance);
                        if(resp.contributionsWrapper.accountBalance.account !=null && resp.contributionsWrapper.accountBalance.account[0] !=null){
                            component.set("v.AccShortName",resp.contributionsWrapper.accountBalance.account[0].accountTypeCode);
                            var accName=resp.contributionsWrapper.accountBalance.account[0].accountTypeCode;
							var accNum=resp.contributionsWrapper.accountBalance.account[0].accountNumberId;
                            
							component.set("v.accNum",accNum);																			   
                            switch(accName) 
                            { 
                                case "HSA": 
                                    component.set("v.selectedAccName","Health Savings Account");
                                    break; 
                                case "HRA": 
                                    component.set("v.selectedAccName","Health Reimbursement Account");
                                    break;
                                case "HRAAP": 
                                    component.set("v.selectedAccName","Split Deductible Health Reimbursement Account");
                                    break; 
                                case "FSA": 
                                    component.set("v.selectedAccName","Flexible Spending Account");
									break; 
                                case "FSA LIM": 
                                    component.set("v.selectedAccName","Flexible Spending Account Limited Medical");
                                    break; 
                                case "FSADC": 
                                    component.set("v.selectedAccName","Flexible Spending Dependent Care");
                                    break; 
                                case "FSALP": 
                                    component.set("v.selectedAccName","Limited Purpose Flexible Spending Account");
                                    break;
                                case "FSAHC": 
                                    component.set("v.selectedAccName"," Health Care Flexible Spending Account");
                                    break; 
                                case "HIA": 
                                    component.set("v.selectedAccName","Health Incentive Account");
                                    break; 
                                case "MRA": 
                                    component.set("v.selectedAccName","Member Reimbursement Account");
                                    break;
                                case "HCSA": 
                                    component.set("v.selectedAccName","Health Care Spending Account");
                                    break;
                                case "RMSA": 
                                    component.set("v.selectedAccName","Retiree Medical Savings Account");
                                    break;
                            } 
                        }
                    } else {
                        component.set('v.spendingAccountsAvlbl', false);
                    }                    
                } else {
                    component.set('v.spendingAccountsAvlbl', false);
                }
                //	transaction details
                if(null != resp.transactionWrapper && null != resp.transactionWrapper.transData) {
                    component.set('v.TransactionsAccountsData',resp.transactionWrapper.transData);
                    console.log('Transactions accounts data'+resp.transactionWrapper.transData);
					var accSysCode=resp.transactionWrapper.transData[0].accountCode;
                    component.set("v.accSysCode",accSysCode);																
                }
                console.log("financials : ", component.get("v.financials"));
            }
        
        });
        $A.enqueueAction(action);
    },
    // Call Security access API: US2923041 - sunil vennam
    checkUserAccess : function(component,event,helper){
        // COmmenting due to Pilot issues which needs resolutioning.
        var action = component.get("c.fetchUserDetails");
        var userId = component.get("v.agentUserId");
        action.setParams({
            userId : userId,
        });
        action.setCallback(this,function(response){
           var state = response.getState();
            var resp;
            if (state === "SUCCESS") {
                resp = response.getReturnValue();
                console.log('Response User Check Service', resp);
                //alert('Response User Check Service'resp);
                //resp = false;
                if(!$A.util.isEmpty(resp) && !$A.util.isUndefined(resp)){
                    component.set("v.agentHSASecurityAccess", resp);
                    //helper.getDeductiblesAndOOPMax(component, event, helper);
                }
            }else{
                console.log('Inside hsa sec check failure');
                resp = false;
                component.set("v.agentHSASecurityAccess", false);
            }
            console.log('hsaaccess'+resp);
            //resp=false;
            helper.getDeductiblesAndOOPMax(component, event, helper,resp);
        });
        $A.enqueueAction(action);
    },
    
    
})