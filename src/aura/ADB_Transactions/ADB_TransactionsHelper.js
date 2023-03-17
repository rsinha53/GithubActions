({
    setTransactionData: function(component,event,helper){
        var val = component.get("v.TransactionsAccountsData");

        if(val != null || val != undefined){
            
            var accShortName = component.get("v.AccShortName");
        	helper.updateTransactions(component,event,helper,accShortName);
            
        }
        
    },
    
    
	updateTransactions : function(component,event,helper,accShortName){
	
        console.log('Transaction Selected Account : '+accShortName);
        
        var tranAccData = component.get("v.TransactionsAccountsData"); //contains the json string
        var tList=[];
           
            tranAccData.forEach(function(act){
                if(act.accountType == "HSA"){
                    component.set("v.accFirstName",act.firstName);
                    component.set("v.accLastName",act.lastName);
                    component.set("v.accSSN",act.ssn);
                    component.set("v.accNum",act.accountNumber);
                    component.set("v.accInvBal",act.investedBalance);
                    
                }
                if(act.accountType == accShortName || (act.accountType == 'HRA' && accShortName == 'HRAAP')|| (act.accountType == 'FSA DC' && accShortName == 'FSADC') || (act.accountType == 'FSA' && accShortName == 'FSAHC') || (act.accountType == 'FSA' && accShortName == 'FSALP')){
                    if(act.transList.length != null){
                        tList = act.transList;
                    }
                }
            });
        
        component.set("v.transActData",tList);
	},
    
})