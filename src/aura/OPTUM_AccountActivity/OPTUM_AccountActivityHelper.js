({
    fetchTransactions: function(component, event, helper, sid) {
        //Added by Dimpy- US3024913: For maintaining Sorting constant when swicthing between tabs
        var sysntheticId = component.get("v.Syntheticid");
        var accountStatus = component.get("v.accountStatus");
        component.set("v.accountList", event.getParam("accountList"));
        if(sysntheticId!==component.get("v.accountList[0].syntheticId") && (accountStatus!==component.get("v.accountList[0].notionalAccountDetails[0].accountStatus")));
        {
            var action = component.get("c.getTransactions");
            component.set("v.accountList", event.getParam("accountList"));
            component.set("v.rowIndex", event.getParam("index"));
            component.set("v.accountType", event.getParam("accountType"));
            component.set("v.Syntheticid", component.get("v.accountList[0].syntheticId"));
            component.set("v.nonExpiringPlan", component.get("v.accountList[0].nonExpiringPlan"));
            component.set("v.acctPlanYearEffectiveDate", component.get("v.accountList[0].notionalAccountDetails[0].acctPlanYearEffectiveDate"));
            component.set("v.acctPlanYearExpirationDate", component.get("v.accountList[0].notionalAccountDetails[0].acctPlanYearExpirationDate"));
            component.set("v.acctOpenedDate", component.get("v.accountList[0].notionalAccountDetails[0].acctOpenedDate"));
            component.set("v.employerAlias", component.get("v.accountList[0].employerAlias"));
            component.set("v.accountStatus",component.get("v.accountList[0].notionalAccountDetails[0].accountStatus"));
            component.set("v.Spinner", true);
            component.set("v.Flag", false);
            action.setParams({
                "syntheticId": component.get("v.Syntheticid"),
                "nonExpiringPlan": component.get("v.nonExpiringPlan"),
                "acctPlanYearEffectiveDate": component.get("v.acctPlanYearEffectiveDate"),
                "acctPlanYearExpirationDate": component.get("v.acctPlanYearExpirationDate"),
                "acctOpenedDate": component.get("v.acctOpenedDate"),
                "employerAlias": component.get("v.employerAlias")
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                var responseValue = JSON.parse(JSON.stringify(response.getReturnValue()));
                console.log("responseValue " + responseValue);
                if ((state === "SUCCESS")&& (component.isValid())){
                    if(responseValue != null && !($A.util.isUndefinedOrNull(responseValue.result)) && !((Object.keys(responseValue.result).length)==0) && !($A.util.isUndefinedOrNull(responseValue.result.data)) && !((Object.keys(responseValue.result.data).length) == 0) && !($A.util.isUndefinedOrNull(responseValue.result.data.accountDetails)) && ((responseValue.result.data.accountDetails).length>0)) {
                        component.set("v.Spinner", false);
                        component.set("v.Flag", true);
                        component.set("v.accountdetails", responseValue.result.data.accountDetails);
                        
                        var accountdt =component.get("v.accountdetails");
                        if(typeof  accountdt!=="undefined"){
                            for (var i = 0; i < accountdt.length; i++) {
                                component.set("v.paymentTransactions", accountdt[i].paymentTransactions);
                                component.set("v.accountContributions", accountdt[i].accountContributions);
                                component.set("v.APIResponse", false);
                            }
                        } 
                        var paytrans = component.get("v.paymentTransactions");
                        var transcontb = component.get("v.accountContributions");  
                        var transDetails = [];
                        if(paytrans!=null && typeof paytrans!== "undefined") {
                            for (var i = 0; i < paytrans.length; i++) {
                                if(paytrans[i].paymentDate!=null){
                                    paytrans[i].paytype ="DB";
                                } 
                                var paymdate = paytrans[i].paymentDate;
                                if(typeof paymdate!== "undefined"){
                                    paytrans[i].cmpDate =$A.localizationService.formatDate(paymdate, "MM/dd/YYYY");
                                }  
                                
                                var details={paymentDate:paytrans[i].cmpDate,paymentAmount:paytrans[i].paymentAmount, paymentCheckNum :paytrans[i].paymentCheckNum,Type:paytrans[i].paytype};
                                transDetails.push(details);
                                
                            } 
                        }
                        if(transcontb!=null && typeof transcontb!== "undefined"){
                            for (var i = 0; i < transcontb.length; i++) {
                                if(transcontb[i].fundsIn!=null){
                                    transcontb[i].conttype ="CR";
                                }  
                                var adddate = transcontb[i].contributionDate;
                                if(typeof adddate!== "undefined"){
                                    transcontb[i].cmpcontDate =$A.localizationService.formatDate(adddate, "MM/dd/YYYY");
                                }  
                                var details={paymentDate:transcontb[i].cmpcontDate,paymentAmount:transcontb[i].fundsIn,contributionComments:transcontb[i].contributionComments,Type:transcontb[i].conttype};
                                transDetails.push(details);
                            }
                            
                        } 
                        if(transDetails!=null){
                            component.set("v.data" ,transDetails);
                            helper.paginationData(component, event, helper);
                            
                        }  
                    }
                }
                else if ((responseValue == null) || (state === "ERROR")) {
                    component.set("v.APIResponse", true);
                    component.set("v.Spinner", false);
                }
                    else if (state === "INCOMPLETE") {
                        component.set("v.Spinner", false);
                        component.set("v.APIResponse", false);
                    }
                
            });
            $A.enqueueAction(action);
        }
        
    },
    //US3254524 Autodoc Account Activity
    autoDocData: function(component, event, helper){
        var autoDocTabData = component.get("v.PaginationList");
        var acc = component.get("v.data");
        if(acc!= null){
            var totalResults = acc.length;
        }
        var action = component.get('c.getautoDocTabDataTransactions');
        action.setParams({
            "credDetails": component.get("v.PaginationList"),
            "totalResults": totalResults,
            "pageSize": 25,
            "endPage": component.get("v.endPage"),
            "startPage": component.get("v.startPage")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var responseValue = JSON.stringify(response.getReturnValue());
            if ((state === "SUCCESS")){
                component.set("v.autoDocData" ,response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    paginationData: function(component, event, helper){
        var pageSize = component.get("v.pageSize");
        var acc = component.get("v.data");
        if(acc!= null){
            var totalResults = acc.length;
        }
        // get size of all the records and then hold into an attribute "totalRecords"
        component.set("v.totalResults", totalResults);
        component.set("v.startPage",1);
        var spage = component.get("v.startPage");
        component.set("v.endPage",pageSize-1);
        var epage = component.get("v.endPage");
        component.set('v.isSending',false);
        var dataAcc= component.get("v.data");
        var PaginationList = [];
        if(dataAcc != null){
            for(var i=0; i< pageSize; i++){
                if(component.get("v.data").length> i)
                    PaginationList.push(dataAcc[i]);    
            }
            component.set('v.PaginationList', PaginationList);
            component.set('v.isSending',false);
            helper.autoDocData(component, event, helper);            
        } 
    },
    next : function(component, event ,helper){
        var acc = component.get("v.data");
        var end = component.get("v.endPage");
        var start = component.get("v.startPage");
        var pageSize = 25;
        var PaginationList = [];
        var counter = 0;
        for(var i=end+1; i<end+pageSize+1; i++){
            if(acc.length > i){
                PaginationList.push(acc[i]);
            }
            counter ++ ;
        }
        start = start + counter;
        end = end + counter;
        component.set("v.startPage",start);
        component.set("v.endPage",end);                
        component.set('v.PaginationList', PaginationList);
        helper.autoDocData(component, event, helper);
    },
    previous : function(component, event, helper){
        var acc = component.get("v.data");
        var end = component.get("v.endPage");
        var start = component.get("v.startPage");
        var pageSize = 25;
        var PaginationList = [];
        var counter = 0;
        for(var i= start-pageSize-1; i < start-1 ; i++){
            if(i > -1){
                PaginationList.push(acc[i]);
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
        helper.autoDocData(component, event, helper);
    }
    
})