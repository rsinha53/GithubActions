({ // edited by Dimpy to get the transaction from API userstory: US2881441
         getTransaction:function(component, event, helper, index) {
             var sysntheticId = component.get("v.Syntheticid");
             var accountStatus = component.get("v.accountStatus");
             var id = component.get("v.accountList[0].syntheticId");
             var fetchedStatus = component.get("v.accountList[0].nonNotionalAccountDetails[0].accountStatus");
             if((sysntheticId!=id) && (!accountStatus!=fetchedStatus))
            {
             component.set("v.Spinner", true);
            component.set("v.Syntheticid", component.get("v.accountList[0].syntheticId"));
            component.set("v.accountStatus",component.get("v.accountList[0].nonNotionalAccountDetails[0].accountStatus"));
       
             var action = component.get("c.searchtranactions");
             var selectedAccountNumberytenticId = component.get("v.accountList[0].syntheticId");
			 var employeralias = component.get("v.accountList[0].employerAlias");
             action.setParams({
                 "syntheticId": selectedAccountNumberytenticId,
				 "employerAlias": employeralias
             });
             action.setCallback(this, function(response) {
                 var state = response.getState(); //Checking response status
                 var responseValue = JSON.parse(JSON.stringify(response.getReturnValue()));
                 if ((state === "SUCCESS")&& (component.isValid())){
                     component.set("v.Spinner", false);
                     if(responseValue != null && !($A.util.isUndefinedOrNull(responseValue.result)) && !((Object.keys(responseValue.result).length)==0) && !($A.util.isUndefinedOrNull(responseValue.result.data)) && !((Object.keys(responseValue.result.data).length) == 0) && !($A.util.isUndefinedOrNull(responseValue.result.data.transactions)) && ((responseValue.result.data.transactions).length>0)) {
                        component.set("v.showTable", true);
						 component.set("v.Flag", false);
                         component.set("v.transactions", responseValue.result.data.transactions);
                         helper.paginationData(component, event, helper);
                  
				  }
                     else {
			              component.set("v.transactions", "");
		                  component.set("v.showTable", false);
		                  component.set("v.Flag", true);
		                  component.set("v.PaginationList", "");
                         
				  }
				 } 
		   else if ((responseValue == null) || (state === "ERROR")) {
			    component.set("v.APIResponse", true);
                component.set("v.Spinner", false);
				component.set("v.transactions", "");
                component.set("v.showTable", false);
				component.set("v.PaginationList", "");
				
            }
            else if (state === "INCOMPLETE") {
				component.set("v.Spinner", false);
				component.set("v.transactions", "");
                component.set("v.showTable", false);
				component.set("v.PaginationList", "");
            }
             });
             $A.enqueueAction(action);
        }
         },
    autoDocTransactions: function(component, event, helper){
        var autoDocTabData = component.get("v.PaginationList");
        var acc = component.get("v.transactions");
        if(acc!= null){
            var totalResults = acc.length;
        }
        var action = component.get('c.getautoDocTableDataTransactionsForHSA');
        action.setParams({
            "transactionData": component.get("v.PaginationList"),
            "totalResults": totalResults,
            "pageSize": 25,
            "endPage": component.get("v.endPage"),
            "startPage": component.get("v.startPage")
          });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var responseValue = JSON.stringify(response.getReturnValue());
           if ((state === "SUCCESS")){
               	component.set("v.autoDocTransactionData" ,response.getReturnValue());
            }
           
        });
        $A.enqueueAction(action);
    },
    paginationData: function(component, event, helper){
        var pageSize = component.get("v.pageSize");
        var trans = component.get("v.transactions");
        if(trans!= null){
            var totalResults = trans.length;
        }
        // get size of all the records and then hold into an attribute "totalRecords"
        component.set("v.totalResults", totalResults);
        // (set start as 1)  DE472075 - Preprod: Pagination help text populated incorrectly for HSA transactions
        component.set("v.startPage",1);
        component.set("v.endPage",pageSize-1);
        var dataTrans= component.get("v.transactions");
        var PaginationList = [];
        if(dataTrans != null){
			helper.formatData(component, event, helper,dataTrans );
            dataTrans= component.get("v.transValue");
            for(var i=0; i< pageSize; i++){
              if(component.get("v.transactions").length> i)
               PaginationList.push(dataTrans[i]);    
            }
            component.set('v.PaginationList', PaginationList);
            component.set('v.isSending',false);
			helper.autoDocTransactions(component, event, helper);
            
            
        } 
        
    },
    next : function(component, event ,helper){
        var trans = component.get("v.transactions");
        var end = component.get("v.endPage");
        var start = component.get("v.startPage");
        var pageSize = 25;
        var PaginationList = [];
        var counter = 0;
		helper.formatData(component, event, helper,trans );
        trans= component.get("v.transValue");
        for(var i=end+1; i<end+pageSize+1; i++){
            if(trans.length > i){
                PaginationList.push(trans[i]);
            }
            counter ++ ;
        }
        start = start + counter;
        end = end + counter;
        component.set("v.startPage",start);
        component.set("v.endPage",end);
        component.set('v.PaginationList', PaginationList);
        helper.autoDocTransactions(component, event, helper);
    },
    previous : function(component, event, helper){
        var trans = component.get("v.transactions");
        var end = component.get("v.endPage");
        var start = component.get("v.startPage");
        var pageSize = 25;
        var PaginationList = [];
        var counter = 0;
		helper.formatData(component, event, helper,trans );
        trans= component.get("v.transValue");
        for(var i= start-pageSize-1; i < start-1 ; i++){
            if(i > -1){
                PaginationList.push(trans[i]);
                counter ++;
            }else{
                start++;
            }
        }
        start = start - counter;
        end = end - counter;
        component.set("v.startPage",start);
        component.set("v.endPage",end);
        component.set('v.PaginationList', PaginationList);
        helper.autoDocTransactions(component, event, helper);
    },
	formatData: function(component, event, helper, dataTrans ){
        for(var row = 0; row < dataTrans.length; row++){
            var mem=[];
            if(typeof memo!== "undefined"){
             mem=dataTrans[row].memo+':';
            }
            var desp=mem+dataTrans[row].description;
            dataTrans[row].descriptionMemo=desp;
            var transdate = dataTrans[row].tranDate;
            dataTrans[row].transactionDate =$A.localizationService.formatDate(transdate, "MM/dd/YYYY")
            var amts =dataTrans[row].amount;
            var myString = amts.toString();
            var amt = myString.replace(/-/g, "");
            dataTrans[row].convertAmount = parseFloat(amt);
            if(dataTrans[row].amount>0){
                
                dataTrans[row].debitOrCreditType = "CR";
            }
            else if(dataTrans[row].amount <0){
                dataTrans[row].debitOrCreditType = "DB";
            }
        } 
        component.set("v.transValue",dataTrans);
    }
    
})