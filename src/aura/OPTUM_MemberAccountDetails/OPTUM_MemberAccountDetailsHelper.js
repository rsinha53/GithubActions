({
    //Fetch Account details
    getAccountDetails: function(component, event, helper) {
        var accType = component.get("v.accountType");
        var listVal = component.get("v.accountList");
        var rowIndex = component.get('v.rowIndex');
        var accountListDetail=[];
        for (var i = 0; i < listVal.length; i++) {
            if(i==rowIndex){
                accountListDetail.push(listVal[i]);
            }
            
        }
        component.set("v.accountList",accountListDetail);
    },
    
    injectComponent: function (name, target) {
        $A.createComponent(name, {
        }, function (contentComponent, status, error) {
            if (status === "SUCCESS") {
                target.set('v.body', contentComponent);
            } else {
                throw new Error(error);
            }
        });
    },
    
    fireEvent : function(component, event, helper) {
        var appEvent = $A.get("e.c:OPTUM_AccountRefreshEvent");
        appEvent.setParams({"accountList": component.get("v.accountList"),
                            "index":component.get("v.rowIndex"),"accountType":component.get("v.accountType"),"faroId":component.get("v.memberDetails.member.faroId"),"autodocUniqueId":component.get("v.autodocUniqueId"),"autodocUniqueIdCmp":component.get("v.autodocUniqueIdCmp")});
        appEvent.fire();
        
        
    },
    
    fireSwitchTabEvent : function(component, event, helper) {
        var appEvent = $A.get("e.c:OPTUM_SwitchTabEvent");
        appEvent.setParams({"Switched":true
                           });                                               
        appEvent.fire(); 
        
        
    }
    
})