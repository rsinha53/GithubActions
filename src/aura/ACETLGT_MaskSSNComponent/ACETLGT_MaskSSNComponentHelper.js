({
    insertEventLog : function(component,event,helper) {
        
        var constituentType = component.get("v.Type");
        var category = component.get("v.Category");
        var memId = component.get("v.memberId");
        var SSNValue = component.get("v.SSNValue");
        
        console.log('~~~~'+constituentType+memId+category+SSNValue);
        var action = component.get("c.insertEventLog");
        action.setParams({
            "constituentType": constituentType,
            "category": category,
            "memId": memId,
            "SSNValue": SSNValue
        });
        
        action.setCallback(this, function(a) {
            var result = a.getReturnValue();
            console.log(result);
        });
        $A.enqueueAction(action);
    },
    getmaskedSSN: function(component, helper, SSN) {
        var maskSSN = 'XXX-XX-'+SSN.substr(SSN.length-4,SSN.length);
        component.set("v.MaskedSSN",maskSSN);
    },
})