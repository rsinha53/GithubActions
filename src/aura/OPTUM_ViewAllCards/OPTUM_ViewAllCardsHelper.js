({
	debitcards: function(component, event, helper) {
        var action = component.get("c.getDebitCards");
        component.set("v.Spinner", true);
        component.set("v.Flag", false);
        action.setParams({
            "FAROID": component.get("v.memberDetails.member.faroId"),
            "syntheticId": component.get("v.Syntheticid"),
            "accountAlias": component.get("v.accountAlias"),
            "accountId": component.get("v.accountId"),
            "accountCode": component.get("v.accountCode"),
            "employerId": component.get("v.employerId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var responseValue = JSON.parse(JSON.stringify(response.getReturnValue()));
            if ((state === "SUCCESS") && (component.isValid()) ) {
				 if(responseValue != null && !($A.util.isUndefinedOrNull(responseValue.result)) && !((Object.keys(responseValue.result).length)==0) && !($A.util.isUndefinedOrNull(responseValue.result.data)) && !((Object.keys(responseValue.result.data).length) == 0) && !($A.util.isUndefinedOrNull(responseValue.result.data.debitCards)) && ((responseValue.result.data.debitCards).length>0)) {
                   component.set("v.Spinner", false);
				   component.set("v.showTable", true);
			    component.set("v.Flag", true);
                component.set("v.cardsdata", responseValue.result.data.debitCards);
                console.log("DebitcardResponse",JSON.stringify(responseValue.result.data.debitCards));
                var cardsData = component.get("v.cardsdata");
                for (var row = 0; row < cardsData.length; row++){
                    if(cardsData[row].requestDate != undefined){
                    var ordereddate = cardsData[row].requestDate;
                    cardsData[row].requestDate = $A.localizationService.formatDate(ordereddate, "MM/dd/YYYY");   
                    }
				 }}
			    else {
                component.set("v.Flag", true);
                component.set("v.Spinner", false);
				component.set("v.showTable", false);
              }}
            else if ((responseValue == null) || (state === "ERROR")) {
                component.set("v.APIResponse", true);
				component.set("v.showTable", false);
                component.set("v.Spinner", false);
            
            }
            else if (state === "INCOMPLETE") {
                component.set("v.Spinner", false);
				component.set("v.showTable", false);
            }
            //helper.autoDocData(component, event, helper);
        });
        $A.enqueueAction(action);
    },
      getData: function(component, event, helper) {
        var accountDetail = Object.values(component.get("v.memberDetails.accountDetails"));
        var selectedvalue = component.find('Account').get('v.value');
        const check = (element) => element === selectedvalue;
        var index = component.get("v.options").findIndex(check);
          for (var i = 0; i < accountDetail.length; i++) {
               if (accountDetail[i].hasOwnProperty("notionalAccountDetails")){
                   var sPY = " ";
                   var ePY =  " ";
                    if(accountDetail[i].notionalAccountDetails[0].acctPlanYearEffectiveDate != null){
                    sPY = $A.localizationService.formatDate(accountDetail[i].notionalAccountDetails[0].acctPlanYearEffectiveDate, "MM/dd/YYYY");
                    }          
                    if(accountDetail[i].notionalAccountDetails[0].acctPlanYearExpirationDate != null){
                    ePY = $A.localizationService.formatDate(accountDetail[i].notionalAccountDetails[0].acctPlanYearExpirationDate, "MM/dd/YYYY");
                    }
                    if(selectedvalue== (accountDetail[i].accountType + " " + accountDetail[i].accountId + " (" + sPY + "-" + ePY + ")")){
       
             var notionalFilteredList =component.get("v.notionalFilteredList");
        component.set("v.Syntheticid", notionalFilteredList[0].syntheticId);
        component.set("v.accountAlias", notionalFilteredList[0].accountAlias);
        component.set("v.accountId", notionalFilteredList[0].accountId);
        component.set("v.accountCode", notionalFilteredList[0].accountCode);
        component.set("v.employerId", notionalFilteredList[0].employerId);
           
                    }
               }
              if(selectedvalue==(accountDetail[i].accountType + " " + accountDetail[i].accountId)){
               component.set("v.Syntheticid", accountDetail[i].syntheticId);
        component.set("v.accountAlias", accountDetail[i].accountAlias);
        component.set("v.accountId", accountDetail[i].accountId);
        component.set("v.accountCode", accountDetail[i].accountCode);
        component.set("v.employerId", accountDetail[i].employerId); 
              }
          }
    },
    accountPicklist:function(component, event, helper){
        //US3703234: Member with No Accounts
        var ssnMemberDetails = component.get("v.memberDetails.accountDetails");
        if(ssnMemberDetails != null && !($A.util.isUndefinedOrNull(ssnMemberDetails)) 
           && !((Object.keys(ssnMemberDetails).length)==0)) {
            var accountDetail = Object.values(component.get("v.memberDetails.accountDetails"));
            console.log("accountDetail"+accountDetail);
            var accDetails = true;
            component.set('v.memAccDetails', accDetails);
        }
        else{
            var accDetails = false;
            component.set('v.memAccDetails', accDetails);
        }
        var notionalaccountDetails = [];
        var nonnotionalaccountDetails = [];
        var hsaAccountDetails = [];
        var notionalList = [];
        if (accountDetail != null) {
            for (var i = 0; i < accountDetail.length; i++) {
                if (accountDetail[i].hasOwnProperty("notionalAccountDetails")){
                   
                    notionalaccountDetails.push(accountDetail[i]);
                    var sPY = " ";
                    var ePY =  " ";
                    if(accountDetail[i].notionalAccountDetails[0].acctPlanYearEffectiveDate != null){
                    sPY = $A.localizationService.formatDate(accountDetail[i].notionalAccountDetails[0].acctPlanYearEffectiveDate, "MM/dd/YYYY");
                    }          
                    if(accountDetail[i].notionalAccountDetails[0].acctPlanYearExpirationDate != null){
                    ePY = $A.localizationService.formatDate(accountDetail[i].notionalAccountDetails[0].acctPlanYearExpirationDate, "MM/dd/YYYY");
                    }
                    notionalList.push(accountDetail[i].accountType + " " + accountDetail[i].accountId + " (" + sPY + "-" + ePY + ")");
                 
                    
                }
               if(accountDetail[i].hasOwnProperty("nonNotionalAccountDetails")){
                   notionalList.push(accountDetail[i].accountType + " " + accountDetail[i].accountId);
                    nonnotionalaccountDetails.push(accountDetail[i]);
                } 
                component.set("v.options",notionalList);
                component.set("v.notionalFilteredList",notionalaccountDetails); 
                component.set("v.nonnotionalFilteredList",nonnotionalaccountDetails);
            }
		  if (nonnotionalaccountDetails != null && nonnotionalaccountDetails.length > 0) {
            component.set("v.Syntheticid", nonnotionalaccountDetails[0].syntheticId);
            component.set("v.accountAlias", nonnotionalaccountDetails[0].accountAlias);
            component.set("v.accountId", nonnotionalaccountDetails[0].accountId);
            component.set("v.accountCode", nonnotionalaccountDetails[0].accountCode);
            component.set("v.employerId", nonnotionalaccountDetails[0].employerId);
        }
           if (notionalaccountDetails != null && notionalaccountDetails.length > 0) {
            component.set("v.Syntheticid", notionalaccountDetails[0].syntheticId);
            component.set("v.accountAlias", notionalaccountDetails[0].accountAlias);
            component.set("v.accountId", notionalaccountDetails[0].accountId);
            component.set("v.accountCode", notionalaccountDetails[0].accountCode);
            component.set("v.employerId", notionalaccountDetails[0].employerId);
             }
        }
    },
    sortData : function(component,event,helper,fieldName,sortDirection){
        var data = component.get("v.cardsdata");
        //function to return the value stored in the field
        var key = function(a) { return a[fieldName]; }
        var reverse = sortDirection == 'asc' ? 1: -1;
          // to handel number/currency type fields 
        if(fieldName == 'convertAmount' ){ 
            data.sort(function(a,b){
                var a = key(a) ? key(a) : '';
                var b = key(b) ? key(b) : '';
                return reverse * ((a>b) - (b>a));
            }); 
            
        } else if(fieldName == 'orderDate'){
             for(var row = 0; row < data.length; row++){
                var ordereddate = data[row].requestData;
                data[row].orderDate =$A.localizationService.formatDate(ordereddate, "YYYY-MM-DD");
               // dateData.push(data[row].transactionDate);
            }
             let parser = (v) => v;
            parser = (v) => (v && new Date(v));
           data = data.sort((a,b) => {
           let a1 = parser(a[fieldName]), b1 = parser(b[fieldName]);
           let r1 = a1 < b1, r2 = a1 === b1;
           return r2? 0: r1? -reverse: reverse;
  });
       
           
        }
        else {// to handel text type fields 
            data.sort(function(a,b){ 
                var a = key(a) ? key(a).toLowerCase() : '';//To handle null values , uppercase records during sorting
                var b = key(b) ? key(b).toLowerCase() : '';
                return reverse * ((a>b) - (b>a));
            });    
        }
         component.set("v.cardsdata",data);
    },
    //US3242040: Autodoc Debit Cards
  /*  autoDocData: function(component, event, helper){
        var autoDocTabData = component.get("v.cardsdata");
        console.log("autoDocTabData DATAAAAA ",JSON.stringify(autoDocTabData));
        var action = component.get('c.getAutoDocDebitCard');
        action.setParams({
            "debCard": component.get("v.cardsdata")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var responseValue = JSON.stringify(response.getReturnValue());
            if ((state === "SUCCESS")){
                component.set("v.debitCards" ,response.getReturnValue());
                console.log("autoDocExternalAccounts ---" + responseValue);
            }
        });
        $A.enqueueAction(action);
    } */
   
})