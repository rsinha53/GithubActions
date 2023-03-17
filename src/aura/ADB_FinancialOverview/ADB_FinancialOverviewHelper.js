({
    assignAccountName : function(component, event, helper){
        var accName = component.get("v.AccShortName");
        //alert(accName)
        console.log('assign long name'+accName);
        switch(accName) 
        { 
            case "HSA": 
                component.set("v.selectedAccName","Health Savings Account");
                
                break; 
            case "HRA": 
                component.set("v.selectedAccName","Health Reimbursement Account");
                break; 
            case "FSA": 
                component.set("v.selectedAccName","Flexible Spending Account");
                
                break; 
            case "HIA": 
                component.set("v.selectedAccName","Health Incentive Account");
                
                break; 
            case "MRA": 
                component.set("v.selectedAccName","Member Reimbursement Account");
                
                break; 
            case "FSA LIM": 
                component.set("v.selectedAccName","Flexible Spending Account Limited Medical");
                
                break; 
            case "FSADC": 
                component.set("v.selectedAccName","Dependent Care Flexible Spending Account");
                
                break;
            case "FSALP": 
                component.set("v.selectedAccName","Limited Purpose Flexible Spending Account");
                
                break;
            case "FSAHC": 
                component.set("v.selectedAccName","Healthcare Flexible Spending Account");
                
                break;
            case "RMSA": 
                component.set("v.selectedAccName","Retiree Medical Savings Account");
                
                break;
            case "HRAAP": 
                component.set("v.selectedAccName","Split Deductible Health Reimbursement Account");
                
                break;
            case "HCSA": 
                component.set("v.selectedAccName","Health Care Spending Account");
                
                break;
                
        } 
    }
})