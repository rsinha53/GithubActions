({
   dateFormat : function(component, event, helper) {
        var openedDate = component.get("v.accountList[0].nonNotionalAccountDetails[0].acctOpenedDate");
        var terminationDate = component.get("v.accountList[0].nonNotionalAccountDetails[0].acctTerminationDate");
       console.log("Check termination date ------------------++++ "+terminationDate); 
       var planyear = component.get("v.accountList[0].notionalAccountDetails[0].acctPlanYearEffectiveDate");
        var enddate = component.get("v.accountList[0].notionalAccountDetails[0].acctPlanYearExpirationDate");
        var acctopendate = component.get("v.accountList[0].notionalAccountDetails[0].acctOpenedDate");
        var acctclosedate = component.get("v.accountList[0].notionalAccountDetails[0].acctTerminationDate");
        var finalservicedate = component.get("v.accountList[0].notionalAccountDetails[0].acctPlanYearFinalServiceDate");
        var graceperiod = component.get("v.accountList[0].notionalAccountDetails[0].acctPlanYearGracePeriodExpirationDate");
		var finalFillingDate = component.get("v.accountList[0].notionalAccountDetails[0].acctPlanYearGracePeriodExpirationDate");
        //component.set("v.acctOpendate",$A.localizationService.formatDate(acctopendate, "MM/dd/YYYY"));
        //component.set("v.acctCloseddate",$A.localizationService.formatDate(acctclosedate, "MM/dd/YYYY"));
        //component.set("v.finalDate",$A.localizationService.formatDate(finalservicedate, "MM/dd/YYYY"));
        //component.set("v.gracePeriodDate",$A.localizationService.formatDate(graceperiod, "MM/dd/YYYY"));
        component.set("v.planYear",$A.localizationService.formatDate(planyear, "MM/dd/YYYY"));
        component.set("v.endDate",$A.localizationService.formatDate(enddate, "MM/dd/YYYY"));
        var debitoffer = component.get("v.accountList[0].notionalAccountDetails[0].debitCardFl");
        var allowrecurringclaim = component.get("v.accountList[0].notionalAccountDetails[0].allowRecurringClaims");
        if(debitoffer == true){
            component.set("v.debitOffer","Yes");
        }
            else if(debitoffer == false) {
                component.set("v.debitOffer","No");
            }
        if(allowrecurringclaim == true){
            component.set("v.allowRecurringclaim","Yes");
        }
            else if(allowrecurringclaim == false) {
                component.set("v.allowRecurringclaim","No");
            }
			
	var tDate = $A.localizationService.formatDate(terminationDate, "yyyy");
        var oDate = $A.localizationService.formatDate(openedDate, "yyyy");
        var ooDate = $A.localizationService.formatDate(acctopendate, "yyyy");
        var cDate = $A.localizationService.formatDate(acctclosedate, "yyyy");
        var fDate = $A.localizationService.formatDate(finalservicedate, "yyyy");
        var gDate = $A.localizationService.formatDate(graceperiod, "yyyy");	
        var ffDate = $A.localizationService.formatDate(finalFillingDate, "yyyy");
        var eDate = $A.localizationService.formatDate(enddate, "yyyy");
        if(terminationDate != null && terminationDate != "undefined" && tDate != 9999){
        component.set("v.hsaterminationdDate",$A.localizationService.formatDate(terminationDate, "MM/dd/YYYY"));                    
        }  
        else if(terminationDate != null && terminationDate != "undefined" && tDate == 9999) {
        component.set("v.hsaterminationdDate", terminationDate);    
        }        
        if(openedDate != null && openedDate != "undefined" && oDate != 9999){
        component.set("v.hsaopenedDate",$A.localizationService.formatDate(openedDate, "MM/dd/YYYY"));                    
        }
        else if(openedDate != null && openedDate != "undefined" && oDate == 9999) {
        component.set("v.hsaopenedDate", openedDate);    
        }
        if(acctopendate != null && acctopendate != "undefined" && ooDate != 9999){
        component.set("v.acctOpendate",$A.localizationService.formatDate(acctopendate, "MM/dd/YYYY"));                    
        }
        else if(acctopendate != null && acctopendate != "undefined" && ooDate == 9999) {
        component.set("v.acctOpendate", acctopendate);    
        }
        if(acctclosedate != null && acctclosedate != "undefined" && cDate != 9999){
        component.set("v.acctCloseddate",$A.localizationService.formatDate(acctclosedate, "MM/dd/YYYY"));                    
        }
        else if(acctclosedate != null && acctclosedate != "undefined" && cDate == 9999) {
        component.set("v.acctCloseddate", $A.localizationService.formatDate(acctclosedate, "YYYY/dd/MM"));    
        }
        if(finalservicedate != null && finalservicedate != "undefined" && fDate != 9999){
        component.set("v.finalDate",$A.localizationService.formatDate(finalservicedate, "MM/dd/YYYY"));                    
        }
        else if(finalservicedate != null && finalservicedate != "undefined" && fDate == 9999) {
        component.set("v.finalDate", finalservicedate);    
        }
        if(graceperiod != null && graceperiod != "undefined" && gDate != 9999){
        component.set("v.gracePeriodDate",$A.localizationService.formatDate(graceperiod, "MM/dd/YYYY"));                    
        }
        else if(graceperiod != null && graceperiod != "undefined" && gDate == 9999) {
        component.set("v.gracePeriodDate", $A.localizationService.formatDate(graceperiod, "YYYY/dd/MM"));   
        }
		if(finalFillingDate != null && finalFillingDate != "undefined" && ffDate != 9999){
        component.set("v.finalFillingDate",$A.localizationService.formatDate(finalFillingDate, "MM/dd/YYYY"));                    
        }
        else if(finalFillingDate != null && finalFillingDate != "undefined" && ffDate == 9999) {
        component.set("v.finalFillingDate", $A.localizationService.formatDate(finalFillingDate, "YYYY/dd/MM"));   
        }
        var tcDate = component.get("v.accountList[0].tcDate");
        if(tcDate != null || !typeof tcDate === "undefined" || !tcDate ===""){
            component.set("v.tcDate",$A.localizationService.formatDate(tcDate, "MM/dd/YYYY"));
        }
     //Added by Iresh US3232253: Field mapping-Notional Accounts - Runout Period
        if(graceperiod != null &&  graceperiod != "undefined" && gDate != 9999){
            if(enddate != null && enddate != "undefined" && eDate != 9999 ){
                var gracePeriodDay = new Date(graceperiod);
                var endDateDay = new Date(enddate);
                var differenceInTime = gracePeriodDay.getTime() - endDateDay.getTime();
                var differenceInDays = differenceInTime / (1000 * 3600 * 24);
                component.set("v.runoutPeriod",differenceInDays+" days");
            }
        }
    },
	// Added by Prasad-US3243926: Autodoc Non-Notional Account Details
    setAutodocCardData: function (cmp, event, helper) {
          var autodocCmp = _autodoc.getAutodocComponent(cmp.get("v.autodocUniqueId"), cmp.get("v.autodocUniqueIdCmp"), "Member Details");
             if(!$A.util.isEmpty(autodocCmp)){
             cmp.set("v.cardDetails", autodocCmp);
             } 
            var cardDetails = new Object();
            cardDetails.componentName = "Account Information";
            cardDetails.componentOrder = 3;
            cardDetails.noOfColumns = "slds-size_1-of-4";
            cardDetails.type = "card";
            cardDetails.allChecked = false;
            cardDetails.cardData = [
                {
                    "checked": false,
                    "disableCheckbox": false,
                    "defaultChecked": false,
                    "fieldName": "Account Type",
                    "fieldType":"outputText",
                    "fieldValue": cmp.get("v.accountList[0].accountType"),
                    "showCheckbox": true,
                    "isReportable":true
                },
                {
                    "checked": false,
                    "disableCheckbox": false,
                    "defaultChecked": false,
                    "fieldName": "Account Number",
                    "fieldType": "outputText",
                    "fieldValue":cmp.get("v.accountList[0].accountId"),
                    "showCheckbox": true,
                    "isReportable":true
                },
                {
                    "checked": false,
                    "disableCheckbox": false,
                    "defaultChecked": false,
                    "fieldName": "Account Status",
                    "fieldType": "outputText",
                    "fieldValue": cmp.get("v.accountList[0].nonNotionalAccountDetails[0].accountStatus"),
                    "showCheckbox": true,
                    "isReportable":true
                },
                {
                    "checked": false,
                    "disableCheckbox": false,
                    "defaultChecked": false,
                    "fieldName": "T&C Accepted Date",
                    "fieldType": "outputText",
                    "fieldValue":cmp.get("v.tcDate") ,
                    "showCheckbox": true,
                    "isReportable":true
                },
                {
                    "checked": false,
                    "disableCheckbox": false,
                    "defaultChecked": false,
                    "fieldName": "Account Opened Date",
                    "fieldType": "outputText",
                    "fieldValue":cmp.get("v.hsaopenedDate"),
                    "showCheckbox": true,
                    "isReportable":true
                },
                {
                    "checked": false,
                    "disableCheckbox": false,
                    "defaultChecked": false,
                    "fieldName": "Account Termination Date",
                    "fieldType": "outputText",
                    "fieldValue":cmp.get("v.hsaterminationdDate"),
                    "showCheckbox": true,
                    "isReportable":true
                }
            ];
            cmp.set("v.cardDetails", cardDetails);
    },
     setCardData: function (cmp, event, helper) {
        var availableBalance = cmp.get("v.accountList[0].nonNotionalAccountDetails[0].availableBalance");
        var avlbal= '$'+availableBalance;
        var calculatedTotal =  cmp.get("v.accountList[0].calculatedTotal");
        var investmentTotal = cmp.get("v.accountList[0].investmentTotal");
        if(investmentTotal!=null){
        var invstbal= '$'+investmentTotal;
        }
        var calctbal= '$'+calculatedTotal;
       var interest = cmp.get("v.accountList[0].interestRate");
         if(interest!=null && interest !="undefined"){
        var interestRate = interest+'%';
         }
          var autodocCmp = _autodoc.getAutodocComponent(cmp.get("v.autodocUniqueId"), cmp.get("v.autodocUniqueIdCmp"), "balanceDetails");
             if(!$A.util.isEmpty(autodocCmp)){
             cmp.set("v.balanceInformation", autodocCmp);
             } 
            var cardDetails = new Object();
            cardDetails.componentName = "Balance Information";
            cardDetails.componentOrder = 3;
            cardDetails.noOfColumns = "slds-size_1-of-4";
            cardDetails.type = "card";
            cardDetails.allChecked = false;
            cardDetails.cardData = [
                {
                    "checked": false,
                    "disableCheckbox": false,
                    "defaultChecked": false,
                    "fieldName": "Available Balance",
                    "fieldType": "outputText",
                    "fieldValue":avlbal,
                    "showCheckbox": true,
                    "isReportable":true
                },
                {
                    "checked": false,
                    "disableCheckbox": false,
                    "defaultChecked": false,
                    "fieldName": "Investment Total",
                    "fieldType": "outputText",
                    "fieldValue":invstbal,
                    "showCheckbox": true,
                    "isReportable":true
                },
                {
                    "checked": false,
                    "disableCheckbox": false,
                    "defaultChecked": false,
                    "fieldName": "Total Balance",
                    "fieldType": "outputText",
                    "fieldValue":calctbal ,
                    "showCheckbox": true,
                    "isReportable":true
                },
                {
                    "checked": false,
                    "disableCheckbox": false,
                    "defaultChecked": false,
                    "fieldName": "Interest Rate",
                    "fieldType": "outputText",
                    "fieldValue": interestRate,
                    "showCheckbox": true,
                    "isReportable":true
                }
            ];
            cmp.set("v.balanceInformation", cardDetails);
    },
    setemployerCardData: function (cmp, event, helper) {
        
          var autodocCmp = _autodoc.getAutodocComponent(cmp.get("v.autodocUniqueId"), cmp.get("v.autodocUniqueIdCmp"), "employerDetails");
             if(!$A.util.isEmpty(autodocCmp)){
             cmp.set("v.employerInformation", autodocCmp);
             } 
            var cardDetails = new Object();
            cardDetails.componentName = "Employer/Group Information";
            cardDetails.componentOrder = 3;
            cardDetails.noOfColumns = "slds-size_1-of-4";
            cardDetails.type = "card";
            cardDetails.allChecked = false;
            cardDetails.cardData = [
                {
                    "checked": false,
                    "disableCheckbox": false,
                    "defaultChecked": false,
                    "fieldName": "Employee Group Name",
                    "fieldType": "outputText",
                    "fieldValue":cmp.get("v.accountList[0].employerGroupName"),
                    "showCheckbox": true,
                    "isReportable":true
                },
                {
                    "checked": false,
                    "disableCheckbox": false,
                    "defaultChecked": false,
                    "fieldName": "Group ID",
                    "fieldType": "outputText",
                    "fieldValue": cmp.get("v.accountList[0].employerId"),
                    "showCheckbox": true,
                    "isReportable":true
                }
            ];
            cmp.set("v.employerInformation", cardDetails);
    },
    accountinfoNotional: function (cmp, event, helper) {
        
          var autodocCmp = _autodoc.getAutodocComponent(cmp.get("v.autodocUniqueId"), cmp.get("v.autodocUniqueIdCmp"), "Member Details");
             if(!$A.util.isEmpty(autodocCmp)){
             cmp.set("v.accountInfoNotional", autodocCmp);
             } 
            var cardDetails = new Object();
            cardDetails.componentName = "Account Information";
            cardDetails.componentOrder = 3;
            cardDetails.noOfColumns = "slds-size_1-of-4";
            cardDetails.type = "card";
            cardDetails.allChecked = false;
            cardDetails.cardData = [
                {
                    "checked": false,
                    "disableCheckbox": false,
                    "defaultChecked": false,
                    "fieldName": "Account Type",
                    "fieldType":"outputText",
                    "fieldValue": cmp.get("v.accountList[0].accountType"),
                    "showCheckbox": true,
                    "isReportable":true
                },
                {
                    "checked": false,
                    "disableCheckbox": false,
                    "defaultChecked": false,
                    "fieldName": "Account Number",
                    "fieldType": "outputText",
                    "fieldValue":cmp.get("v.accountList[0].accountId"),
                    "showCheckbox": true,
                    "isReportable":true
                },
                {
                    "checked": false,
                    "disableCheckbox": false,
                    "defaultChecked": false,
                    "fieldName": "Account Status",
                    "fieldType": "outputText",
                    "fieldValue": cmp.get("v.accountList[0].notionalAccountDetails[0].accountStatus"),
                    "showCheckbox": true,
                    "isReportable":true
                },
                {
                    "checked": false,
                    "disableCheckbox": false,
                    "defaultChecked": false,
                    "fieldName": "T&C Accepted Date",
                    "fieldType": "outputText",
                    "fieldValue":cmp.get("v.tcDate") ,
                    "showCheckbox": true,
                    "isReportable":true
                },
                {
                    "checked": false,
                    "disableCheckbox": false,
                    "defaultChecked": false,
                    "fieldName": "Account Opened Date",
                    "fieldType": "outputText",
                    "fieldValue":cmp.get("v.acctOpendate"),
                    "showCheckbox": true,
                    "isReportable":true
                },
                
                {
                    "checked": false,
                    "disableCheckbox": false,
                    "defaultChecked": false,
                    "fieldName": "Account Closed Date",
                    "fieldType": "outputText",
                    "fieldValue":cmp.get("v.acctCloseddate"),
                    "showCheckbox": true,
                    "isReportable":true
                }
            ];
            cmp.set("v.accountInfoNotional", cardDetails);
    },
     productinfoNotional: function (cmp, event, helper) {
        var dt1 = cmp.get("v.planYear");
        var dt2= cmp.get("v.endDate");
         var dt= dt1 + '-' + dt2;
          var autodocCmp = _autodoc.getAutodocComponent(cmp.get("v.autodocUniqueId"), cmp.get("v.autodocUniqueIdCmp"), "Member Details");
             if(!$A.util.isEmpty(autodocCmp)){
             cmp.set("v.productInfoNotional", autodocCmp);
             } 
            var cardDetails = new Object();
            cardDetails.componentName = "Product Information";
            cardDetails.componentOrder = 3;
            cardDetails.noOfColumns = "slds-size_1-of-4";
            cardDetails.type = "card";
            cardDetails.allChecked = false;
            cardDetails.cardData = [
                {
                    "checked": false,
                    "disableCheckbox": false,
                    "defaultChecked": false,
                    "fieldName": "Plan Year",
                    "fieldType":"outputText",
                    "fieldValue": dt,
                    "showCheckbox": true,
                    "isReportable":true
                },
                {
                    "checked": false,
                    "disableCheckbox": false,
                    "defaultChecked": false,
                    "fieldName": "Final Service Date / Grace Period ends on",
                    "fieldType": "outputText",
                    "fieldValue":cmp.get("v.finalDate"),
                    "showCheckbox": true,
                    "isReportable":true
                },
                {
                    "checked": false,
                    "disableCheckbox": false,
                    "defaultChecked": false,
                    "fieldName": "Final Filing Date",
                    "fieldType": "outputText",
                    "fieldValue": cmp.get("v.finalFillingDate"),
                    "showCheckbox": true,
                    "isReportable":true
                },
                {
                    "checked": false,
                    "disableCheckbox": false,
                    "defaultChecked": false,
                    "fieldName": "Allow Recurring Claims",
                    "fieldType": "outputText",
                    "fieldValue":cmp.get("v.allowRecurringclaim") ,
                    "showCheckbox": true,
                    "isReportable":true
                },
                {
                    "checked": false,
                    "disableCheckbox": false,
                    "defaultChecked": false,
                    "fieldName": "Runout Period",
                    "fieldType": "outputText",
                    "fieldValue":cmp.get("v.runoutPeriod"),
                    "showCheckbox": true,
                    "isReportable":true
                }
            ];
            cmp.set("v.productInfoNotional", cardDetails);
    },
    //US3243924 Autodoc Notional Account Details
    balanceinfoNotional: function (cmp, event, helper) {
        var autodocCmp = _autodoc.getAutodocComponent(cmp.get("v.autodocUniqueId"), cmp.get("v.autodocUniqueIdCmp"), "Member Details");
             if(!$A.util.isEmpty(autodocCmp)){
             cmp.set("v.balanceInfNotional", autodocCmp);
             } 
        	 var empContributionYTD = cmp.get("v.accountList[0].notionalAccountDetails[0].ytdPayrollDeduction");
             	if(empContributionYTD!=null && empContributionYTD !="undefined"){
        	 var employeeContributionYTD = '$' +empContributionYTD;
         	 }
        	 var elecAmount = cmp.get("v.accountList[0].notionalAccountDetails[0].annualElection");
             	if(elecAmount!=null && elecAmount !="undefined"){
        	 var electionAmount = '$' +elecAmount;
         	 }
            var cardDetails = new Object();
            cardDetails.componentName = "Balance Information";
            cardDetails.componentOrder = 3;
            cardDetails.noOfColumns = "slds-size_1-of-4";
            cardDetails.type = "card";
            cardDetails.allChecked = false;
            cardDetails.cardData = [
                {
                    "checked": false,
                    "disableCheckbox": false,
                    "defaultChecked": false,
                    "fieldName": "Available Balance",
                    "fieldType":"outputText",
                    "fieldValue": '$' + cmp.get("v.accountList[0].notionalAccountDetails[0].availableBalance"),
                    "showCheckbox": true,
                    "isReportable":true
                },
                {
                    "checked": false,
                    "disableCheckbox": false,
                    "defaultChecked": false,
                    "fieldName": "Employee Contribution YTD",
                    "fieldType": "outputText",
                    "fieldValue": employeeContributionYTD,
                    "showCheckbox": true,
                    "isReportable":true
                },
                {
                    "checked": false,
                    "disableCheckbox": false,
                    "defaultChecked": false,
                    "fieldName": "Election Amount",
                    "fieldType": "outputText",
                    "fieldValue": electionAmount,
                    "showCheckbox": true,
                    "isReportable":true
                },
                {
                    "checked": false,
                    "disableCheckbox": false,
                    "defaultChecked": false,
                    "fieldName": "Rollover Amount*",
                    "fieldType": "outputText",
                    "fieldValue":'' ,
                    "showCheckbox": true,
                    "isReportable":true
                }
            ];
            cmp.set("v.balanceInfNotional", cardDetails);
    },
    //US3243924 Autodoc Notional Account Details
    debitinfoNotional: function (cmp, event, helper) {
        var autodocCmp = _autodoc.getAutodocComponent(cmp.get("v.autodocUniqueId"), cmp.get("v.autodocUniqueIdCmp"), "Member Details");
             if(!$A.util.isEmpty(autodocCmp)){
             cmp.set("v.debitInfNotional", autodocCmp);
             } 
            var cardDetails = new Object();
            cardDetails.componentName = "Debit Card Information";
            cardDetails.componentOrder = 3;
            cardDetails.noOfColumns = "slds-size_1-of-4";
            cardDetails.type = "card";
            cardDetails.allChecked = false;
            cardDetails.cardData = [
                {
                    "checked": false,
                    "disableCheckbox": false,
                    "defaultChecked": false,
                    "fieldName": "Debit Card Offered",
                    "fieldType":"outputText",
                    "fieldValue": cmp.get("v.debitOffer"),
                    "showCheckbox": true,
                    "isReportable":true
                },
                {
                    "checked": false,
                    "disableCheckbox": false,
                    "defaultChecked": false,
                    "fieldName": "Debit Card Status*",
                    "fieldType": "outputText",
                    "fieldValue":' ',
                    "showCheckbox": true,
                    "isReportable":true
                }
            ];
            cmp.set("v.debitInfNotional", cardDetails);
    },
     //US3243924 Autodoc Notional Account Details
    employerinfoNotional: function (cmp, event, helper) {
        var autodocCmp = _autodoc.getAutodocComponent(cmp.get("v.autodocUniqueId"), cmp.get("v.autodocUniqueIdCmp"), "Member Details");
             if(!$A.util.isEmpty(autodocCmp)){
             cmp.set("v.employerInfoNotional", autodocCmp);
             } 
            var cardDetails = new Object();
            cardDetails.componentName = "Employer/Group Information";
            cardDetails.componentOrder = 3;
            cardDetails.noOfColumns = "slds-size_1-of-4";
            cardDetails.type = "card";
            cardDetails.allChecked = false;
            cardDetails.cardData = [
                {
                    "checked": false,
                    "disableCheckbox": false,
                    "defaultChecked": false,
                    "fieldName": "Employer Group Name",
                    "fieldType":"outputText",
                    "fieldValue": cmp.get("v.accountList[0].employerGroupName"),
                    "showCheckbox": true,
                    "isReportable":true
                },
                {
                    "checked": false,
                    "disableCheckbox": false,
                    "defaultChecked": false,
                    "fieldName": "Employer ID",
                    "fieldType": "outputText",
                    "fieldValue": cmp.get("v.accountList[0].employerId"),
                    "showCheckbox": true,
                    "isReportable":true
                },
                {
                    "checked": false,
                    "disableCheckbox": false,
                    "defaultChecked": false,
                    "fieldName": "Employment Status",
                    "fieldType": "outputText",
                    "fieldValue": cmp.get("v.accountList[0].employStatusDesc"),
                    "showCheckbox": true,
                    "isReportable":true
                }
            ];
            cmp.set("v.employerInfoNotional", cardDetails);
    },
    getProviderData: function (cmp, event ,helper) {
        var dataList = cmp.get("v.accountList");
        var action = cmp.get('c.setCredentialData');
        // Added by Manohar for freeze issue
        cmp.set("v.Syntheticid", cmp.get("v.accountList[0].syntheticId"));
        cmp.set("v.accountStatus",cmp.get("v.accountList[0].notionalAccountDetails[0].accountStatus"));
        cmp.set("v.planEffectiveDate",cmp.get("v.accountList[0].notionalAccountDetails[0].acctPlanYearEffectiveDate"));
        cmp.set("v.checkType", cmp.get("v.accountList[0].accountType"));
        var transDetails = [];
        var details={submittedClaims:dataList[0].notionalAccountDetails[0].submittedClaims
                     ,pendingClaims:dataList[0].notionalAccountDetails[0].pendingClaims
                     ,deniedClaims :dataList[0].notionalAccountDetails[0].deniedClaims
                     ,paidClaims:dataList[0].notionalAccountDetails[0].paidClaims
                    };
        transDetails.push(details);
        action.setParams({
            "credDetails": transDetails
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var responseValue = JSON.parse(JSON.stringify(response.getReturnValue())); 
                cmp.set("v.claimInfoNotional",responseValue );
                
            } else if (state === "INCOMPLETE") {
                // do something
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
            
        });
        $A.enqueueAction(action);
    },
   alertHistory:function(cmp, event, helper){
      var faro= cmp.get("v.faroId");
      var orgname= cmp.get("v.orgInfo.IsSandbox");
      var accountNumber =  cmp.get("v.accountList[0].accountId");
        if(orgname!=undefined && orgname==true){
           var devftps = $A.get("$Label.c.OPTUM_DevFTPSHis");  
        }
        else{
          var devftps = $A.get("$Label.c.OPTUM_PrdFTPSHis");   
        }
     var urlEvent = $A.get("e.force:navigateToURL");
      var urlVar= ''+devftps+''+ faro + '&accountNo=' + accountNumber;
      urlEvent.setParams({
          'url' : urlVar
     });
      urlEvent.fire();
},
    taxDocs:function(cmp, event, helper){
      var faro= cmp.get("v.faroId");
      var orgname= cmp.get("v.orgInfo.IsSandbox");
      var accountNumber =  cmp.get("v.accountList[0].accountId");
        if(orgname!=undefined && orgname==true){
           var devftps = $A.get("$Label.c.OPTUM_DevTaxDocs");  
        }
        else{
          var devftps = $A.get("$Label.c.OPTUM_PrdTaxDocs");   
        }
      var urlEvent = $A.get("e.force:navigateToURL");
      var urlVar= ''+devftps+''+ faro + '&accountNo=' + accountNumber;
      urlEvent.setParams({
          'url' : urlVar
     });
      urlEvent.fire();
   },
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