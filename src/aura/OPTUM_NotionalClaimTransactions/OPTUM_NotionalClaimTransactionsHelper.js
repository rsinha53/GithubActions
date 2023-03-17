({
    fetchTransactions: function(component, event, helper) {
		let today = new Date();
        let uniqueString = today.getTime();
        component.set('v.autodocUniqueId', uniqueString);
        component.set('v.autodocUniqueIdCmp', uniqueString);
        var action = component.get("c.getTransactions");
        var filteredData = false;
        component.set("v.Spinner", true);
        component.set("v.Flag", false);
        component.set("v.data", null);
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
            if ((responseValue != null) && (component.isValid()) && (state === "SUCCESS")) {
                component.set("v.Spinner", false);
                component.set("v.Flag", true);
               if (responseValue.result.data.accountDetails == undefined) {
                    component.set("v.APIResponse", true);
                    component.set("v.Flag", false);
                } else if (responseValue.result.data.accountDetails != undefined) {
                    console.log("Response of View Claims",JSON.stringify(responseValue.result.data.accountDetails[0].claimsTransactions));
                    component.set("v.data", responseValue.result.data.accountDetails[0].claimsTransactions);
                    //US3819975
                    component.set("v.listNotFound", false);
                    if((component.get("v.data")) == '' ||(component.get("v.data")) == null){
                        component.set("v.listNotFound", true);
                    }
                    component.set("v.APIResponse", false);
                }
				var cStatusList = [];
                var cStatusListFinal = ["Select a value"];
                var rStatusListFinal = ["Select a value"];
                var rStatusList = [];
                const cStatusSet = new Set();
                const rStatusSet = new Set();
                var claimsData = component.get("v.data");
				if (claimsData != undefined) {
                for (var row = 0; row < claimsData.length; row++) {
                    var claimDate = claimsData[row].claimDateofServiceEffectiveDate;
                    claimsData[row].claimDateofServiceEffectiveDate = $A.localizationService.formatDate(claimDate, "MM/dd/YYYY");
                    cStatusSet.add(claimsData[row].claimStatus);
                    rStatusSet.add(claimsData[row].receiptStatus);
                }
				}
                cStatusList = Array.from(cStatusSet);
                rStatusList = Array.from(rStatusSet);
                for (const item of cStatusSet) {
                    cStatusListFinal.push(item);
                }
                for (const item of rStatusSet) {
                    rStatusListFinal.push(item);
                }
                component.set("v.claimStatusList", cStatusListFinal);
                component.set("v.receiptStatusList", rStatusListFinal);
                helper.paginationData(component, event, helper, filteredData);
            }
			else if ((responseValue == null) || (state === "ERROR")) {
            component.set("v.APIResponse", true);
            component.set("v.Spinner", false);
            //US3819975
            if(component.get("v.memAccDetails") == false){
                component.set("v.APIResponse", false); 
            }
            //US3819975
            if(component.get("v.noNotionalFound") == true){
                component.set("v.APIResponse", false); 
            }
            }
            else if (state === "INCOMPLETE") {
            component.set("v.Spinner", false);
            }
        });
        $A.enqueueAction(action);
    },
    fetchData: function(component, event, helper) {
        var selectedvalue = (component.find('Account').get('v.value'));
        const check = (element) => element === selectedvalue;
        var index = component.get("v.options").findIndex(check);
        var childComponent = component.find("childCmp");
        childComponent.messageMethod();
		// Added by Dimpy DE386495 Prod-11-12: Claims Tab is blank with no message or claims table
        var notionalFilteredList =component.get("v.notionalFilteredList");
        component.set("v.Syntheticid", notionalFilteredList[index].syntheticId);
        component.set("v.acctPlanYearEffectiveDate", notionalFilteredList[index].notionalAccountDetails[0].acctPlanYearEffectiveDate);
        component.set("v.acctPlanYearExpirationDate", notionalFilteredList[index].notionalAccountDetails[0].acctPlanYearExpirationDate);
        component.set("v.acctOpenedDate", notionalFilteredList[index].notionalAccountDetails[0].acctOpenedDate);
        component.set("v.employerAlias", notionalFilteredList[index].employerAlias);
		component.set("v.ShowSelectedClaim", false);
		component.set("v.accountId", notionalFilteredList[index].accountId);

    },
    initialiseData: function(component, event, helper) {
       // Added by Dimpy DE386495 Prod-11-12: Claims Tab is blank with no message or claims table
	   //US3703234: Member with No Accounts
        var ssnMemberDetails = component.get("v.memberDetails.accountDetails");
        if(ssnMemberDetails != null && !($A.util.isUndefinedOrNull(ssnMemberDetails)) 
           && !((Object.keys(ssnMemberDetails).length)==0)) {
            var accountDetail = Object.values(component.get("v.memberDetails.accountDetails"));
            console.log("accountDetail"+accountDetail);
            var accDetails = true;
            component.set('v.memAccDetails', accDetails);
             //US3819975
            if(accountDetail[0].hasOwnProperty("notionalAccountDetails")){
                     component.set("v.noNotionalFound", false);
                 }        	
        }
        else{
            var accDetails = false;
            component.set('v.memAccDetails', accDetails);
        }
 		component.set("v.faroId", component.get("v.memberDetails.member.faroId"));
        var notionalaccountDetails = [];
        var notionalList = [];
        if (accountDetail != null) {
            for (var i = 0; i < accountDetail.length; i++) {
                if (accountDetail[i].hasOwnProperty("notionalAccountDetails")) {
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
            }
            component.set("v.options", notionalList);
            component.set("v.notionalFilteredList",notionalaccountDetails);
        }
        if (notionalaccountDetails != null && notionalaccountDetails.length > 0) {
            component.set("v.Syntheticid", notionalaccountDetails[0].syntheticId);
            component.set("v.acctPlanYearEffectiveDate", notionalaccountDetails[0].notionalAccountDetails[0].acctPlanYearEffectiveDate);
            component.set("v.acctPlanYearExpirationDate", notionalaccountDetails[0].notionalAccountDetails[0].acctPlanYearExpirationDate);
            component.set("v.acctOpenedDate", notionalaccountDetails[0].notionalAccountDetails[0].acctOpenedDate);
            component.set("v.employerAlias", notionalaccountDetails[0].employerAlias);
			component.set("v.accountId", notionalaccountDetails[0].accountId);
        }
    },
  paginationData: function(component, event, helper, fData) {
        var pageSize = component.get("v.pageSize");
        if (fData == false) {
            var dataValue = component.get("v.data");
        } else if (fData == true) {
            var dataValue = component.get("v.filLists");
        }
        if (dataValue != null) {
            var totalResult = dataValue.length;
            component.set("v.totalResults", totalResult);
        }
        component.set("v.startPage", 0);
        component.set("v.endPage", pageSize - 1);
        var Pagination = component.get("v.dataValue");
        var ClaimList = [];
		component.set('v.ClaimLists', ClaimList);
        component.set("v.ShowSelectedClaim", false);
        if (dataValue != null) {
            var totResults = component.get("v.totalResults");
            for (var i = 0; i < pageSize; i++) {
                if (totResults > i)
                    ClaimList.push(dataValue[i]);
            }
            component.set("v.ClaimLists", ClaimList);
            component.set('v.isSending', false);
        }
    },
    next: function(component, event, helper) {
		component.set("v.ShowSelectedClaim", false);
        var fData = component.get("v.filteredData");
        if (fData == false) {
            var dataValue = component.get("v.data");
        } else if (fData == true) {
            var dataValue = component.get("v.filLists");
        }
        var end = component.get("v.endPage");
        var start = component.get("v.startPage");
        var pageSize = component.get("v.pageSize");
        var ClaimList = [];
		component.set('v.ClaimLists', ClaimList);
        var counter = 0;
        for (var i = end + 1; i < end + pageSize + 1; i++) {
            if (dataValue.length > i) {
                ClaimList.push(dataValue[i]);
            }
            counter++;
        }
        start = start + counter;
        end = end + counter;
        component.set("v.startPage", start);
        component.set("v.endPage", end);
        component.set('v.ClaimLists', ClaimList);
    },
    previous: function(component, event, helper) {
		component.set("v.ShowSelectedClaim", false);
        var fData = component.get("v.filteredData");
        if (fData == false) {
            var dataValue = component.get("v.data");
        } else if (fData == true) {
            var dataValue = component.get("v.filLists");
        }
        var end = component.get("v.endPage");
        var start = component.get("v.startPage");
        var pageSize = component.get("v.pageSize");
        var ClaimList = [];
		component.set('v.ClaimLists', ClaimList);
        var counter = 0;
        for (var i = start - pageSize; i < start; i++) {
            if (i > -1) {
                ClaimList.push(dataValue[i]);
                counter++;
            } else {
                start++;
            }
        }
        start = start - counter;
        end = end - counter;
        component.set("v.startPage", start);
        component.set("v.endPage", end);
        component.set('v.ClaimLists', ClaimList);
    },
                //sorting
    sortData: function(component, event, helper, fieldName, sortDirection) {
        var fData = component.get("v.filteredData");
        if (fData == false) {
            var data = component.get("v.data");
        } else if (fData == true) {
            var data = component.get("v.filLists");
        }
        //function to return the value stored in the field
        var key = function(a) {
            return a[fieldName];
        }
        var reverse = sortDirection == 'asc' ? 1 : -1;
        // to handel number/currency type fields 
        if (fieldName == 'submittedClaimAmount' || 'deniedClaimAmount' || 'pendingClaimAmount' || 'paidClaimAmount' || 'approvedClaimAmount') {
            data.sort(function(a, b) {
                var a = key(a) ? key(a) : '';
                var b = key(b) ? key(b) : '';
                return reverse * ((a > b) - (b > a));
            });
        } else { // to handel text type fields 
            data.sort(function(a, b) {
                var a = key(a) ? key(a).toLowerCase() : ''; //To handle null values , uppercase records during sorting
                var b = key(b) ? key(b).toLowerCase() : '';
                return reverse * ((a > b) - (b > a));
            });
        }
        component.set("v.ClaimLists", data);
        component.set("v.ShowSelectedClaim", false);
        helper.paginationData(component, event, helper, fData);
    },

    fireEventToViewClaims: function(component, event, helper, selectedRows) {
       if (selectedRows.length > 0) {
		    var setRows = [];
			setRows.push(selectedRows[0]);
            var data = component.get("v.data");
            var selectedClaimNumber = selectedRows[0].claimNumber;
			component.set("v.selectedClaim", selectedClaimNumber);
            var appEvent = $A.get("e.c:OPTUM_SelectedClaimRowEvent");
			var addClaimEvent = $A.get("e.c:OPTUM_AddClaimDetailsEvent");
            var index = data.findIndex(item => item.claimNumber === selectedClaimNumber);
            var claim;
            for (var i = 0; i < data.length; i++) {

                if (i == index) {
                    claim = data[i];
                }

            }
            component.set("v.ShowSelectedClaim", true);
			component.set("v.checkNext", false);
			component.set("v.selectedData", claim);
            appEvent.setParams({
                "data": claim,

            });
            appEvent.fire();
			addClaimEvent.setParams({
                "flag": component.get("v.checkNext"),

            });
            addClaimEvent.fire();
                }},
                    filterData: function(component, event, helper) {
        var dataValue = component.get("v.data");
        var startDate = event.getParam("Start_Date");
        var endDate = event.getParam("End_Date");
        var minAmountVal = event.getParam("minAmountVal");
        var maxAmountVal = event.getParam("maxAmountVal");
        var rStatus = event.getParam("receiptStatus");
        var status = event.getParam("status");
        var fStartDate = $A.localizationService.formatDate(startDate, "MM/dd/YYYY");
        var fEndDate = $A.localizationService.formatDate(endDate, "MM/dd/YYYY");
        const formatttedstartDate = new Date(fStartDate);    
                                const formatttedendDate = new Date(fEndDate);
        var allData = [];
        var threeDataOne = [];
        var threeDataTwo = [];
        var threeDataThree = [];
        var threeDataFour = [];
        if ((startDate != null && endDate != null) && (startDate != "" && endDate != "") && (minAmountVal != "" && maxAmountVal != "") && (minAmountVal != null && maxAmountVal != null) && (status != "Select a value") && (rStatus != "Select a value")) {
            for (var row = 0; row < dataValue.length; row++) {
            var feDate = dataValue[row].claimDateofServiceEffectiveDate;
                                                const claimDate = new Date(feDate);    
            if((dataValue[row].claimDateofServiceEffectiveDate >= fStartDate) && (claimDate <= formatttedendDate) && (dataValue[row].submittedClaimAmount >= minAmountVal) && (dataValue[row].submittedClaimAmount <= maxAmountVal) && (dataValue[row].claimStatus == status) && (dataValue[row].receiptStatus == rStatus)) {
            allData.push(dataValue[row]);    
            }
            }
            component.set('v.ClaimLists', allData);
            var claimData = component.get("v.ClaimLists");
            if (claimData != null) {
                component.set("v.totalResults", claimData.length);
            }
        } else if ((startDate != null && endDate != null) && (startDate != "" && endDate != "") && (minAmountVal != "" && maxAmountVal != "") && (minAmountVal != null && maxAmountVal != null) && (status != "Select a value")) {
            for (var row = 0; row < dataValue.length; row++) {
            var feDate = dataValue[row].claimDateofServiceEffectiveDate;
            const claimDate = new Date(feDate);     
            if((dataValue[row].claimDateofServiceEffectiveDate >= fStartDate) && (claimDate <= formatttedendDate) && (dataValue[row].submittedClaimAmount >= minAmountVal) && (dataValue[row].submittedClaimAmount <= maxAmountVal) && (dataValue[row].claimStatus == status)) {
            threeDataOne.push(dataValue[row]);    
            }
            }
            component.set('v.ClaimLists', threeDataOne);
            var claimData = component.get("v.ClaimLists");
            if (claimData != null) {
                component.set("v.totalResults", claimData.length);
            }
        } else if ((startDate != null && endDate != null) && (startDate != "" && endDate != "") && (status != "Select a value") && (rStatus != "Select a value")) {
            for (var row = 0; row < dataValue.length; row++) {
            var feDate = dataValue[row].claimDateofServiceEffectiveDate;
            const claimDate = new Date(feDate);    
            if((dataValue[row].claimDateofServiceEffectiveDate >= fStartDate) && (claimDate <= formatttedendDate) && (dataValue[row].claimStatus == status) && (dataValue[row].receiptStatus == rStatus)) {
            threeDataTwo.push(dataValue[row]);    
            }
            }
            component.set('v.ClaimLists', threeDataTwo);
            var claimData = component.get("v.ClaimLists");
            if (claimData != null) {
                component.set("v.totalResults", claimData.length);
            }
        } else if ((startDate != null && endDate != null) && (startDate != "" && endDate != "") && (minAmountVal != "" && maxAmountVal != "") && (minAmountVal != null && maxAmountVal != null) && (rStatus != "Select a value")) {
            for (var row = 0; row < dataValue.length; row++) {
            var feDate = dataValue[row].claimDateofServiceEffectiveDate;
            const claimDate = new Date(feDate);    
            if((dataValue[row].claimDateofServiceEffectiveDate >= fStartDate) && (claimDate <= formatttedendDate) && (dataValue[row].submittedClaimAmount >= minAmountVal) && (dataValue[row].submittedClaimAmount <= maxAmountVal) && (dataValue[row].receiptStatus == rStatus)) {
            threeDataThree.push(dataValue[row]);    
            }
            }
            component.set('v.ClaimLists', threeDataThree);
            var claimData = component.get("v.ClaimLists");
            if (claimData != null) {
                component.set("v.totalResults", claimData.length);
            }
        } else if ((minAmountVal != "" && maxAmountVal != "") && (minAmountVal != null && maxAmountVal != null) && (rStatus != "Select a value") && (status != "Select a value")) {
            for (var row = 0; row < dataValue.length; row++) {
                if ((dataValue[row].submittedClaimAmount >= minAmountVal) && (dataValue[row].submittedClaimAmount <= maxAmountVal) && (dataValue[row].receiptStatus == rStatus) && (dataValue[row].claimStatus == status)) {
                    threeDataFour.push(dataValue[row]);
                }
            }
            component.set('v.ClaimLists', threeDataFour);
            var claimData = component.get("v.ClaimLists");
            if (claimData != null) {
                component.set("v.totalResults", claimData.length);
            }
        } else if ((minAmountVal != "" && maxAmountVal != "") && (minAmountVal != null && maxAmountVal != null) && (status != "Select a value")) {
            for (var row = 0; row < dataValue.length; row++) {
                if ((dataValue[row].submittedClaimAmount >= minAmountVal) && (dataValue[row].submittedClaimAmount <= maxAmountVal) && (dataValue[row].claimStatus == status)) {
                    threeDataFour.push(dataValue[row]);
                }
            }
            component.set('v.ClaimLists', threeDataFour);
           var claimData = component.get("v.ClaimLists");
            if (claimData != null) {
                component.set("v.totalResults", claimData.length);
            }
        } else if ((minAmountVal != "" && maxAmountVal != "") && (minAmountVal != null && maxAmountVal != null) && (rStatus != "Select a value")) {
            for (var row = 0; row < dataValue.length; row++) {
                if ((dataValue[row].submittedClaimAmount >= minAmountVal) && (dataValue[row].submittedClaimAmount <= maxAmountVal) && (dataValue[row].receiptStatus == rStatus)) {
                    threeDataFour.push(dataValue[row]);
                }
            }
            component.set('v.ClaimLists', threeDataFour);
            var claimData = component.get("v.ClaimLists");
            if (claimData != null) {
                component.set("v.totalResults", claimData.length);
            }
        } else if ((startDate != null && endDate != null) && (startDate != "" && endDate != "") && (minAmountVal != "" && maxAmountVal != "") && (minAmountVal != null && maxAmountVal != null)) {
            for (var row = 0; row < dataValue.length; row++) {
            var feDate = dataValue[row].claimDateofServiceEffectiveDate;
            const claimDate = new Date(feDate);    
            if((claimDate >= formatttedstartDate) && (claimDate <= formatttedendDate) && (dataValue[row].submittedClaimAmount >= minAmountVal) && (dataValue[row].submittedClaimAmount <= maxAmountVal)) {
            threeDataOne.push(dataValue[row]);    
            }
            }
            component.set('v.ClaimLists', threeDataOne);
            var claimData = component.get("v.ClaimLists");
            if (claimData != null) {
                component.set("v.totalResults", claimData.length);
            }
        } else if ((rStatus != "Select a value") && (status != "Select a value")) {
            for (var row = 0; row < dataValue.length; row++) {
                if ((dataValue[row].receiptStatus == rStatus) && (dataValue[row].claimStatus == status)) {
                    threeDataFour.push(dataValue[row]);
                }
            }
            component.set('v.ClaimLists', threeDataFour);
            var claimData = component.get("v.ClaimLists");
            if (claimData != null) {
                component.set("v.totalResults", claimData.length);
            }
        } else if ((startDate != null && endDate != null) && (startDate != "" && endDate != "") && (status != "Select a value")) {
            for (var row = 0; row < dataValue.length; row++) {
            var feDate = dataValue[row].claimDateofServiceEffectiveDate;
            const claimDate = new Date(feDate);    
            if((dataValue[row].claimDateofServiceEffectiveDate >= fStartDate) && (claimDate <= formatttedendDate) && (dataValue[row].claimStatus == status)) {
            threeDataOne.push(dataValue[row]);    
            }
            }
            component.set('v.ClaimLists', threeDataOne);
            var claimData = component.get("v.ClaimLists");
            if (claimData != null) {
                component.set("v.totalResults", claimData.length);
            }
        } else if ((startDate != null && endDate != null) && (startDate != "" && endDate != "") && (rStatus != "Select a value")) {
            for (var row = 0; row < dataValue.length; row++) {
            var feDate = dataValue[row].claimDateofServiceEffectiveDate;
            const claimDate = new Date(feDate);    
            if((dataValue[row].claimDateofServiceEffectiveDate >= fStartDate) && (claimDate <= formatttedendDate) && (dataValue[row].receiptStatus == rStatus)) {
            threeDataOne.push(dataValue[row]);    
            }
            }
            component.set('v.ClaimLists', threeDataOne);
            var claimData = component.get("v.ClaimLists");
            if (claimData != null) {
                component.set("v.totalResults", claimData.length);
            }
        } else if ((startDate != null && endDate != null) && (startDate != "" && endDate != "")) {
            for (var row = 0; row < dataValue.length; row++) {
            var feDate = dataValue[row].claimDateofServiceEffectiveDate;
            const claimDate = new Date(feDate);
            if((formatttedstartDate <= claimDate) && (formatttedendDate >= claimDate)) {
            threeDataOne.push(dataValue[row]);    
            }
            }
            component.set('v.ClaimLists', threeDataOne);
            var claimData = component.get("v.ClaimLists");
            if (claimData != null) {
                component.set("v.totalResults", claimData.length);
            }
        } else if ((minAmountVal != "" && maxAmountVal != "") && (minAmountVal != null && maxAmountVal != null)) {
            for (var row = 0; row < dataValue.length; row++) {
                if ((dataValue[row].submittedClaimAmount >= minAmountVal) && (dataValue[row].submittedClaimAmount <= maxAmountVal)) {
                    threeDataOne.push(dataValue[row]);
                }
            }
            component.set('v.ClaimLists', threeDataOne);
            var claimData = component.get("v.ClaimLists");
            if (claimData != null) {
                component.set("v.totalResults", claimData.length);
            }
        } else if (status != "Select a value") {
            for (var row = 0; row < dataValue.length; row++) {
                if (dataValue[row].claimStatus == status) {
                    threeDataFour.push(dataValue[row]);
                }
            }
            component.set('v.ClaimLists', threeDataFour);
            var claimData = component.get("v.ClaimLists");
            if (claimData != null) {
                component.set("v.totalResults", claimData.length);
            }
        } else if (rStatus != "Select a value") {
            for (var row = 0; row < dataValue.length; row++) {
                if (dataValue[row].receiptStatus == rStatus) {
                    threeDataFour.push(dataValue[row]);
                }
            }
            component.set('v.ClaimLists', threeDataFour);
            var claimData = component.get("v.ClaimLists");
            if (claimData != null) {
                component.set("v.totalResults", claimData.length);
            }
        }
        component.set("v.filteredData", true);
        var filData = component.get("v.ClaimLists");
        component.set("v.filLists", filData);
        var fData = true;
        helper.paginationData(component, event, helper, fData);
        if(((startDate == null && endDate == null) || (startDate == "" &&  endDate == "")) && ((minAmountVal == "" &&  maxAmountVal == "") || (minAmountVal == null &&  maxAmountVal == null)) && (status == "Select a value") && (rStatus == "Select a value")) {
        var fData = false;
        component.set("v.filteredData", false);                            
        helper.paginationData(component, event, helper, fData);
        }
        component.set("v.ShowSelectedClaim", false);
    },

})