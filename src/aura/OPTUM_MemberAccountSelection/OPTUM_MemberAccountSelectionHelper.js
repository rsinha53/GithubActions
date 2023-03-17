({

    updatedAccountList: function (component, event, helper, accountDetails) {
        for (var row = 0; row < accountDetails.length; row++) {
            if (accountDetails[row].hasOwnProperty("nonNotionalAccountDetails")) {
                accountDetails[row].investmentTotal = (accountDetails[row].nonNotionalAccountDetails[0].invstTotalBalance) + (accountDetails[row].nonNotionalAccountDetails[0].invstBMTTotalBalance);//schwab left
                accountDetails[row].calculatedTotal = (accountDetails[row].nonNotionalAccountDetails[0].availableBalance) + accountDetails[row].investmentTotal;
                if (accountDetails[row].nonNotionalAccountDetails[0].accountStatus == "A") {
                    accountDetails[row].nonNotionalAccountDetails[0].accountStatus = "Active";
                } else if (accountDetails[row].nonNotionalAccountDetails[0].accountStatus == "C") {
                    accountDetails[row].nonNotionalAccountDetails[0].accountStatus = "Closed";
                }
                else if (accountDetails[row].nonNotionalAccountDetails[0].accountStatus == "I") {
                    accountDetails[row].nonNotionalAccountDetails[0].accountStatus = "Inactive";
                }

            } else {

                if (accountDetails[row].hasOwnProperty("notionalAccountDetails")) {
                    if (accountDetails[row].notionalAccountDetails[0].accountStatus == "A") {
                        accountDetails[row].notionalAccountDetails[0].accountStatus = "Active";
                    } else if (accountDetails[row].notionalAccountDetails[0].accountStatus == "C") {
                        accountDetails[row].notionalAccountDetails[0].accountStatus = "Closed";
                    }
                    else if (accountDetails[row].notionalAccountDetails[0].accountStatus == "I") {
                        accountDetails[row].notionalAccountDetails[0].accountStatus = "Inactive";
                    }

                }
            }
        }

        component.set("v.accountDetails", accountDetails);

    },


    sortData: function (component, event, helper, accountDetails) {

        let status = {
            'Active': 1,
            'Closed': 2,
            'Inactive': 3,

        };
        var sortedWithStatus = accountDetails.sort((a, b) => status[a.accountStatus] - status[b.accountStatus]);
        component.set("v.sortedList", sortedWithStatus);
    },

    changeBackgroundofSelected: function (component, event, helper, selectedAccountNumber) {
        var dataList = component.get("v.data");
        var indexSelected = dataList.findIndex(item => item.accountId === selectedAccountNumber);

        for (var i = 0; i < dataList.length; i++) {
            if (i == indexSelected) {
                dataList[i].customCssClass = "greenRow";
            } else {
                dataList[i].customCssClass = "redRow";
            }
        }
        let dataTableGlobalStyle = document.createElement('style');
        dataTableGlobalStyle.innerHTML = `
        .redRow{
            background-color:#ff8080;   
        }
        .greenRow{
            background-color:#99ff99;
        }                                        
        
        .boldText{
            font-weight:bold !important;
        }
        `;
        document.head.appendChild(dataTableGlobalStyle);
        component.set("v.data", dataList);
    },


    fireEventToUpdateAccount: function (component, event, helper, selectedRows) {
        console.log("Selected Account" + JSON.stringify(selectedRows));
        if (selectedRows.length > 0) {

            var accountsDetail = component.get("v.accountDetails");
            var selectedAccount = selectedRows[0].selectedAccount;
            var selectedAccountNumber = selectedRows[0].accountId;
			var selectedAccountStatus = selectedRows[0].accountType;
			var selectedYear = selectedRows[0].planYear;
            var cmpEvent = component.getEvent('Event');

            if (selectedAccount == "HSA") {
				//Added by Dimpy- US3024913: For maintaining Sorting constant when swicthing between tabs
				//Edited by Dimpy US3225273 Tech Story: Unique Combination for Selection of Account
                var index = accountsDetail.findIndex(item => item.accountId === selectedAccountNumber && item.accountType === selectedAccountStatus && item.nonNotionalAccountDetails[0].acctPlanYearEffectiveDate === selectedYear);
                cmpEvent.setParams({
                    "accountList": accountsDetail,
                    "index": index, "accountType": "HSA"
                });
                cmpEvent.fire();
            } else {
                if (selectedAccount == "Notional") {
					//Added by Dimpy- US3024913: For maintaining Sorting constant when swicthing between tabs
                   var index = accountsDetail.findIndex(item => item.accountId === selectedAccountNumber && item.accountType === selectedAccountStatus && item.notionalAccountDetails[0].acctPlanYearEffectiveDate === selectedYear);
                   cmpEvent.setParams({
                        "accountList": accountsDetail,
                        "index": index, "accountType": "Notional"
                    });
                    cmpEvent.fire();
                }
            }
        }
        component.set("v.ShowSelectedAccount", true);
    },

    callManualAlertApi: function (component, event, helper) {
        var action = component.get('c.getManualAlerts');
        var ssn = component.get("v.memberDetails.member.ssn");
        console.log("ssn"+ssn.replace("-",""));
        ssn = ssn.replace("-","");
        action.setParams({
            "ssn": ssn,
        });
        action.setCallback(this, function (response) {
            var state = response.getState(); // get the response state
            if (state == 'SUCCESS') {
			if (response.getReturnValue().result != null) {
                if(!(Object.keys(response.getReturnValue().result.data).length) == 0){ 
                var responseValue = JSON.parse(JSON.stringify(response.getReturnValue().result.data.accountsInfos));
                var alertDetails = [];
                if (responseValue != undefined && responseValue != null) {
                        for (var i = 0; i < responseValue.length; i++) {
                            if (responseValue[i].activeNotes != null) {
                                var details = { notes: responseValue[i].activeNotes, number: responseValue[i].accountNumber };
                                alertDetails.push(details);
                            }
                        }
                        component.set("v.notesNumber", alertDetails);
                    }
                }
                else {
                    console.log("Unknown error");
                }
            }

			 else {
                    console.log("Unknown error");
                }
			}		
            else if (state === "INCOMPLETE") {
                alert("I am INCOMPLETE")
            }
            else if (state === "ERROR") {
                component.set("v.Spinner", false);

                console.log("Unknown error");

            }
        });
        $A.enqueueAction(action);
    },

    pushData: function (component, event, helper) {
        var dataValue = component.get("v.accountDetails");

        var currentData = [];
        var data = {};

        for (var acct = 0; acct < dataValue.length; acct++) {
            if (dataValue[acct].hasOwnProperty("nonNotionalAccountDetails")) {
                currentData.push({ accountType: dataValue[acct].accountType, accountId: dataValue[acct].accountId, accountStatus: dataValue[acct].nonNotionalAccountDetails[0].accountStatus, availableBalance: dataValue[acct].nonNotionalAccountDetails[0].availableBalance, investmentTotal: dataValue[acct].investmentTotal, calculatedTotal: dataValue[acct].calculatedTotal, selectedAccount: "HSA", customCssClass: "redRow" , planYear: dataValue[acct].nonNotionalAccountDetails[0].acctPlanYearEffectiveDate})

            } else {
                if (dataValue[acct].hasOwnProperty("notionalAccountDetails")) {
                    currentData.push({ accountType: dataValue[acct].accountType, accountId: dataValue[acct].accountId, accountStatus: dataValue[acct].notionalAccountDetails[0].accountStatus, availableBalance: dataValue[acct].notionalAccountDetails[0].availableBalance, selectedAccount: "Notional", customCssClass: "redRow" , planYear: dataValue[acct].notionalAccountDetails[0].acctPlanYearEffectiveDate})

                }
            }

        }
        helper.sortData(component, event, helper, currentData);
    },
		 //added by Srikanya:US3019167 to get org name
         getorgInfo: function (component, event, helper) {
           var action = component.get("c.getorg");
           action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                component.set("v.orgInfo", storeResponse);
            }
        });
        $A.enqueueAction(action);
    },
	
})