public with sharing class OPTUM_MemberSearchService {
PUblic static String certName = System.Label.OPTUM_CertificateName;

    @AuraEnabled
    public static OPTUM_MemberSearchReponse searchMemberWithSSN(String ssn) {
        OPTUM_MemberSearchReponse responseWrapper ;
        HttpResponse response;
        String body = '{"ssn" : "' + ssn + '",' + '"dob":"1992-02-27",' + '"filterDetails" : false }';
        ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework('OptumMemberSearchEndpoint', body,null);
        wsCallOutFW.certificateName = OPTUM_MemberSearchService.certName;
        response = wsCallOutFW.getResponse();
        if(response.getStatusCode() == 200 || response.getStatusCode() == 502) {
            responseWrapper = OPTUM_MemberSearchReponse.parse(response.getBody());
        }else {
            responseWrapper.responseCode = String.valueOf(response.getStatusCode());
            responseWrapper.responseMsg = response.getStatus();
        }
        return responseWrapper;
    }

    //Method:GET transactions for HSA Account.
    @AuraEnabled
    public static OPTUM_AccountTransactionsResponse searchtranactions(String syntheticId,String employerAlias) {
	    OPTUM_AccountTransactionsResponse responseWrapper ;
        HttpResponse response;
        ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework('OptumTransactionsEndPoint', '',null);
        if(employerAlias!=null){
          wsCallOutFW.endpointExtraPath= '/' + syntheticId + '/transactions/search?type=RECENT&employerAlias=' + employerAlias + '';
        }else{
            wsCallOutFW.endpointExtraPath= '/' + syntheticId + '/transactions/search?type=RECENT';
        }
		wsCallOutFW.certificateName = OPTUM_MemberSearchService.certName;
        response = wsCallOutFW.getResponse();
        if(response.getStatusCode() == 200) {
            responseWrapper = OPTUM_AccountTransactionsResponse.parse(response.getBody());
               
        } else {
            responseWrapper.responseCode = String.valueOf(response.getStatusCode());
            responseWrapper.responseMsg = response.getStatus();
        }
        return responseWrapper; 
      }
    //Get transactions for Notional Account.
    @AuraEnabled
    public static OPTUM_AccountActivityReponse getTransactions(String syntheticId, Integer nonExpiringPlan, String acctPlanYearEffectiveDate, String acctPlanYearExpirationDate, String acctOpenedDate, String employerAlias) {
        OPTUM_AccountActivityReponse responseWrapper ;
        HttpResponse response;
        ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework('OptumAccountActivityEndpoint', '',null);
        wsCallOutFW.endpointExtraPath= '/' + syntheticId + '/notionaltransactions?nonExpiringPlan=' + 2 + '&acctPlanYearEffectiveDate=' + acctPlanYearEffectiveDate + '&acctPlanYearExpirationDate=' + acctPlanYearExpirationDate + '&acctOpenedDate=' + acctOpenedDate + '&employerAlias=' + employerAlias + '';
    	wsCallOutFW.certificateName = OPTUM_MemberSearchService.certName;
        response = wsCallOutFW.getResponse();
        if(response.getStatusCode() == 200) {
            responseWrapper = OPTUM_AccountActivityReponse.parse(response.getBody());
       } else {
            responseWrapper.responseCode = String.valueOf(response.getStatusCode());
            responseWrapper.responseMsg = response.getStatus();
        }
        return responseWrapper; 
    }
    //Get the External Accounts based on Syntheticid from Accountdetails
    @AuraEnabled
    public static OPTUM_ExternalAccountsResponse externalaccounts(String syntheticId) {
        OPTUM_ExternalAccountsResponse responseWrapper ;
        HttpResponse response;
        ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework('OptumExternalAccountEndpoint', '',null);
        wsCallOutFW.endpointExtraPath= '/' + syntheticId + '/externalaccounts';
		wsCallOutFW.certificateName = OPTUM_MemberSearchService.certName;
        response = wsCallOutFW.getResponse();
        if(response.getStatusCode() == 200) {
            responseWrapper = OPTUM_ExternalAccountsResponse.parse(response.getBody());
        } else {
            responseWrapper.responseCode = String.valueOf(response.getStatusCode());
            responseWrapper.responseMsg = response.getStatus();
        }
        return responseWrapper; 
		
    }
    //for view alert history in FTPS
    @AuraEnabled
    public static Organization getorg() {
        // query to get Organization
        Organization org = [SELECT id, IsSandbox FROM Organization limit 1];
        return org;
    }
    //Api call for Manual Alert
    @AuraEnabled
    public static Optum_ManualAlertUser getManualAlerts(String ssn) {
	Optum_ManualAlertUser responseWrapper = new Optum_ManualAlertUser();
        HttpResponse response;
        String body = '{ "ssn":"' + ssn + '"}';
        ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework('OptumManualAlert', body,null);
        response = wsCallOutFW.getResponse();
        if(response.getStatusCode() == 200) {
            responseWrapper = Optum_ManualAlertUser.parse(response.getBody());
        } else {
            responseWrapper.responseCode = String.valueOf(response.getStatusCode());
            responseWrapper.responseMsg = response.getStatus();
        }
        return responseWrapper;  
       
    }
   //Added by Prasad-US2881456: View All Cards		   
    @AuraEnabled
    public static OPTUM_DebitCardsResponse getDebitCards(String FAROID, String syntheticId, String accountAlias, String accountId, Integer accountCode, String employerId) {
        OPTUM_DebitCardsResponse responseWrapper = new OPTUM_DebitCardsResponse();
        HttpResponse response;
        String body = '{"syntheticId" : "' + syntheticId + '",' + '"accountAlias":"' + accountAlias + '",' + '"accountCode" :' + accountCode + ', ' + '"accountId" : "' + accountId + '",' + '"employerId" : "' + employerId + '" }';
        ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework('OptumDebitCardsEndpoint', body,null);
        wsCallOutFW.certificateName = OPTUM_MemberSearchService.certName;
        wsCallOutFW.faroID = FAROID;
        response = wsCallOutFW.getResponse();
        if(response.getStatusCode() == 200) {
            responseWrapper = OPTUM_DebitCardsResponse.parse(response.getBody());
        } else {
            responseWrapper.responseCode = String.valueOf(response.getStatusCode());
            responseWrapper.responseMsg = response.getStatus();
        }
        return responseWrapper;  
    }
    //Update Demographics details.
    @AuraEnabled
    public static OPTUM_DemographicsUpdateResponse updateDemographics(String faroId, String emailId, String mAddessLine1, String mAddessLine2, String mAddressCity, String mAddressState, String pMobile, String pWork, String pHome, String phonePreferred, String wBrandId, String zip, String zipPlus4) {
    String mAddLine2 = mAddessLine2;
        if (mAddessLine2 == null) {
            mAddLine2 = '';
        }
        String userId = [select FederationIdentifier FROM User Where id =: UserInfo.getUserId()].FederationIdentifier;
        String body = ' {' +
            '                "brandCode": "' + wBrandId + '",' +
            '                "emailAddress": "' + emailId + '",' +
            '                "addressLine1": "' + mAddessLine1 + '",' +
            '                "addressLine2": "' + mAddLine2 + '",' +
            '                "city": "' + mAddressCity + '",' +
            '                "state": "' + mAddressState + '",' +
            '                "zip": "' + zip + '",' +
            '                "zipPlus4": "' + zipPlus4 + '",' +
            '                "homePhone": "' + pHome + '",' +
            '                "workPhone": "' + pWork + '",' +
            '                "mobilePhone": "' + pMobile + '",' +
            '                "preferredPhoneType": "' + phonePreferred + '"' +
            '                }';
       OPTUM_DemographicsUpdateResponse responseWrapper = new OPTUM_DemographicsUpdateResponse();
       HttpResponse response;
       ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework('OptumUpdateDemographicsEndPoint', body,null);
       wsCallOutFW.certificateName = OPTUM_MemberSearchService.certName;
       wsCallOutFW.faroID = faroId;
       wsCallOutFW.userID = userId ;
        response = wsCallOutFW.getResponse();
        if(response.getStatusCode() == 200) {
            responseWrapper = OPTUM_DemographicsUpdateResponse.parse(response.getBody());
        } else {
            responseWrapper.responseCode = String.valueOf(response.getStatusCode());
            responseWrapper.responseMsg = response.getStatus();
        }
        return responseWrapper; 
    }
	//Added by Prasad-US3052741: Notification Preference
       @AuraEnabled
    public static OPTUM_NotificationsResponse notifications(String syntheticId,String FAROID) {
       OPTUM_NotificationsResponse responseWrapper = new OPTUM_NotificationsResponse();
       HttpResponse response;
       ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework('OptumNotificationPreferenceEndPoint', '',null);
	   wsCallOutFW.endpointExtraPath= '/' + syntheticId + '/statementpreferences';
       wsCallOutFW.certificateName = OPTUM_MemberSearchService.certName;
       wsCallOutFW.faroID = FAROID;
       response = wsCallOutFW.getResponse();
       if(response.getStatusCode() == 200) {
            responseWrapper = OPTUM_NotificationsResponse.parse(response.getBody());
        } else {
            responseWrapper.responseCode = String.valueOf(response.getStatusCode());
            responseWrapper.responseMsg = response.getStatus();
        }
        return responseWrapper; 
    }
	
	//Advance search
	 @AuraEnabled
    public static String memberWithAdvanceSearch(String ssn, String dob, String accountNumber, String email, String firstName, String lastName) {
        String body;
        String parenthesis = '}';
        if (!String.IsBlank(accountNumber)) {
            body = ' {' +
                '                "accountNumber": "'+accountNumber+'"' +
                parenthesis;
        } else if (!String.IsBlank(email)) {
            body = ' {' +
                '                "emailAddress":  "'+email+'"' +
                parenthesis;
        } else if (!String.IsBlank(ssn) && !String.IsBlank(lastName)) {
            body = ' {' +
                '                "lastName": "'+lastName+'",' +
                '                "last4Ssn": "'+ssn+'"' +
                '                ' +
                parenthesis;
        } else if (!String.IsBlank(firstName) && !String.IsBlank(lastName) && !String.IsBlank(dob)) {
            body = ' {' +
                '                "lastName": "'+lastName+'",' +
                '                "firstName": "'+firstName+'",' +
                '                "dateOfBirth": "'+dob+'"' +
                parenthesis;
        }
       String responseString ;
       HttpResponse response;
       ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework('OptumAdvanceMemberSearchEndPoint',body,null);
       wsCallOutFW.certificateName = OPTUM_MemberSearchService.certName;
       response = wsCallOutFW.getResponse();
       if(response.getStatusCode() == 200 || response.getStatusCode() == 502) {
        responseString = response.getBody();
        } 
         return responseString;
    }
	//Added by Prasad-US3083550: Integration: Field mapping-View Investments for HSA Account
     @AuraEnabled
    public static OPTUM_InvestmentsSummeryResponse investmentSummery(String syntheticId) {
        OPTUM_InvestmentsSummeryResponse responseWrapper ;
        HttpResponse response;
        ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework('OptumInvestmentsEndpoint', '',null);
        wsCallOutFW.endpointExtraPath= '/' + syntheticId + '/investments';
		wsCallOutFW.certificateName = OPTUM_MemberSearchService.certName;
        response = wsCallOutFW.getResponse();
        if(response.getStatusCode() == 200) {
           responseWrapper = OPTUM_InvestmentsSummeryResponse.parse(response.getBody());
        } else {
            responseWrapper.responseCode = String.valueOf(response.getStatusCode());
            responseWrapper.responseMsg = response.getStatus();
        }
        return responseWrapper; 
    }
	//Show additional claim details.
    @AuraEnabled
    public static OPTUM_ClaimsAdditionalDetails showAddClaimsDetails(String faroId, String accountId, String claimNumber, String syntheticId) {
         String body = ' {' +
                    '                "id": "'+accountId+'",' +
                    '                "claimNumber": "'+claimNumber+'",' +
                    '                "syntheticId": "'+syntheticId+'"' +               
                    '                }';
         OPTUM_ClaimsAdditionalDetails responseWrapper = new OPTUM_ClaimsAdditionalDetails();
         HttpResponse response;
         ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework('OptumRMIandAdmitNotesEndpoint', body,null);
         wsCallOutFW.certificateName = OPTUM_MemberSearchService.certName;
         wsCallOutFW.faroID = FAROID;
         response = wsCallOutFW.getResponse();
         if(response.getStatusCode() == 200 || response.getStatusCode() == 404) {
            responseWrapper = OPTUM_ClaimsAdditionalDetails.parse(response.getBody());
        } else {
            responseWrapper.responseCode = String.valueOf(response.getStatusCode());
            responseWrapper.responseMsg = response.getStatus();
        }
        return responseWrapper; 
        }
  
        //US3243924 Autodoc Notional Account Details
    @AuraEnabled
    public static ACET_AutoDocUtil.TableDetails setCredentialData(List <NotionalAccountDetails> credDetails) {
        system.debug('@@entered'+ credDetails );
       ACET_AutoDocUtil.TableDetails affTable = new ACET_AutoDocUtil.TableDetails();
        affTable.type = 'table';
        affTable.componentOrder = 3;
        affTable.componentName = 'Claim Information';
		affTable.showComponentName= false;
        affTable.autodocHeaderName = 'Claim Information';
        affTable.tableHeaders = new List < String > {
            'Submitted Claims Amount',
            'Pending Claims Amount',
            'Denied Claims Amount',
			'Total Claims Amount Paid YTD'
        };
        List < ACET_AutoDocUtil.TableRow > tableRows = new List < ACET_AutoDocUtil.TableRow > ();
        if (credDetails != null) {
            for (integer i = 0; i < credDetails.size(); i++) {
                ACET_AutoDocUtil.TableRow tableRow = new ACET_AutoDocUtil.TableRow();
                tableRow.checked = false;
                tableRow.uniqueKey = credDetails[i].submittedClaims;
                List < ACET_AutoDocUtil.RowColumnData > rowColumns = new List < ACET_AutoDocUtil.RowColumnData > ();
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', '$'+ credDetails[i].submittedClaims,true));
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', credDetails[i].pendingClaims != '' ? '$'+ credDetails[i].pendingClaims : '--',true));
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', credDetails[i].deniedClaims != '' ? '$'+ credDetails[i].deniedClaims : '--',true));
				rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', credDetails[i].paidClaims != '' ? '$'+ credDetails[i].paidClaims : '--',true));
                tableRow.rowColumnData = rowColumns;
                tableRows.add(tableRow);
            }
            affTable.tableBody = tableRows;
        }
        return affTable;
    }

            //US3254499 Autodoc External Accounts
    @AuraEnabled
    public static ACET_AutoDocUtil.TableDetails getautoDocExternalAccounts(List <NotionalAccount> credDetails) {
        system.debug('credDetails' + credDetails);
        ACET_AutoDocUtil.TableDetails affTable = new ACET_AutoDocUtil.TableDetails();
        affTable.type = 'table';
        affTable.componentOrder = 3;
        affTable.componentName = 'External Accounts';
        affTable.showComponentName= false;
        affTable.autodocHeaderName = 'External Accounts';
        affTable.tableHeaders = new List < String > {
            'Nickname',
                'Bank Name',
                'Bank Routing No.',
                'Account No.',
                'Account Type',
                'Status',
                'Added On',
                'Verified On',
                'Has Scheduled Transaction?'
                };
                    system.debug(affTable.tableHeaders.size());
        List < ACET_AutoDocUtil.TableRow > tableRows = new List < ACET_AutoDocUtil.TableRow > ();
        if (credDetails != null) {
            for (integer i = 0; i < credDetails.size(); i++) {
                ACET_AutoDocUtil.TableRow tableRow = new ACET_AutoDocUtil.TableRow();
                tableRow.checked = false;
                tableRow.uniqueKey = credDetails[i].nickname;
                List < ACET_AutoDocUtil.RowColumnData > rowColumns = new List < ACET_AutoDocUtil.RowColumnData > ();
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', credDetails[i].nickname,true));
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', credDetails[i].bankName != '' ? credDetails[i].bankName : '--',true));
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', credDetails[i].bankRoutingNumber != '' ? credDetails[i].bankRoutingNumber : '--',true));
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', credDetails[i].bankAccountNumber != '' ? credDetails[i].bankAccountNumber : '--',true));
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', credDetails[i].bankAccountType != '' ? credDetails[i].bankAccountType : '--',true));
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', credDetails[i].bankAccountStatus != '' ? credDetails[i].bankAccountStatus : '--',true));
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', credDetails[i].cmpdateAdded != '' ? credDetails[i].cmpdateAdded : '--',true));
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', credDetails[i].cmpdateVerified != '' ? credDetails[i].cmpdateVerified : '--',true));
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', credDetails[i].hasScheduledTransactions != '' ? credDetails[i].hasScheduledTransactions : '--',true));
                tableRow.rowColumnData = rowColumns;
                tableRows.add(tableRow);
            }
            affTable.tableBody = tableRows;
            system.debug(affTable.tableBody.size());
        }
        system.debug('affTable ' + affTable);
        return affTable;
    }
	//US3254502 Autodoc Investments
    @AuraEnabled
    public static ACET_AutoDocUtil.TableDetails getautoDocInvestmentSweep(List <InvestSweepDetails> sweepDataList) {
        ACET_AutoDocUtil.TableDetails affTable = new ACET_AutoDocUtil.TableDetails();
        affTable.type = 'table';
        affTable.componentOrder = 3;
        affTable.componentName = 'Investment Sweep Details';
        affTable.showComponentName= false;
        affTable.autodocHeaderName = 'Investment Sweep Details';
        affTable.tableHeaders = new List < String > {
            'Sweep Status',
                'Sweep Threshold',
                'Sweep Account'
                };
                    List < ACET_AutoDocUtil.TableRow > tableRows = new List < ACET_AutoDocUtil.TableRow > ();
        if (sweepDataList != null) {
            for (integer i = 0; i < sweepDataList.size(); i++) {
                ACET_AutoDocUtil.TableRow tableRow = new ACET_AutoDocUtil.TableRow();
                tableRow.checked = false;
                tableRow.uniqueKey = sweepDataList[i].threshold;
                List < ACET_AutoDocUtil.RowColumnData > rowColumns = new List < ACET_AutoDocUtil.RowColumnData > ();
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', sweepDataList[i].status != '' ? sweepDataList[i].status : '',true));
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', '$'+ sweepDataList[i].threshold,true));
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', sweepDataList[i].account != '' ? sweepDataList[i].account : '',true));
                tableRow.rowColumnData = rowColumns;
                tableRows.add(tableRow);
            }
            affTable.tableBody = tableRows;
        }
        return affTable;
    }
    
    //US3254502 Autodoc Investments
    @AuraEnabled
    public static ACET_AutoDocUtil.TableDetails getautoDocInvestment(List <InvestDetails> dataList) {
        ACET_AutoDocUtil.TableDetails affTable = new ACET_AutoDocUtil.TableDetails();
        affTable.type = 'table';
        affTable.componentOrder = 4;
        affTable.componentName = 'Investment Details';
        affTable.showComponentName= false;
        affTable.autodocHeaderName = 'Investment Details';
        affTable.tableHeaders = new List < String > {
            ' ',
                'Balance',
                'Status',
                'Plan',
                'Cash Balance',
                'Investment Threshold'
                };
                    List < ACET_AutoDocUtil.TableRow > tableRows = new List < ACET_AutoDocUtil.TableRow > ();
        if (dataList != null) {
            for (integer i = 0; i < dataList.size(); i++) {
                ACET_AutoDocUtil.TableRow tableRow = new ACET_AutoDocUtil.TableRow();
                tableRow.checked = false;
                tableRow.uniqueKey = dataList[i].title;
                List < ACET_AutoDocUtil.RowColumnData > rowColumns = new List < ACET_AutoDocUtil.RowColumnData > ();
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', dataList[i].title,true));
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', dataList[i].balance != '' ? '$'+ dataList[i].balance : '',true));
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', dataList[i].status != '' ? dataList[i].status : '',true));
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', dataList[i].plan != '' ? dataList[i].plan : '',true));
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', dataList[i].cashBalance != '' ? '$'+ dataList[i].cashBalance : '',true));
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', dataList[i].investThreshold != '' ? '$'+ dataList[i].investThreshold : '',true));
                tableRow.rowColumnData = rowColumns;
                tableRows.add(tableRow);
            }
            affTable.tableBody = tableRows;
        }
        return affTable;
    }
     //for current year Auto doc contributions
	 @AuraEnabled
    public static ACET_AutoDocUtil.TableDetails getautoDocContributions(List <Contribution> contDetails) {
	    string contributions='Contributions';
		string openBraces='(For';
        ACET_AutoDocUtil.TableDetails affTable = new ACET_AutoDocUtil.TableDetails();
        affTable.type = 'table';
        affTable.componentOrder = 3;
        affTable.componentName = contDetails[0].currentYear +' '+contributions;
        affTable.showComponentName= false;
        affTable.autodocHeaderName = contDetails[0].currentYear +' '+contributions;
        affTable.tableHeaders = new List < String > {
                'Filing Status',
                'Limit',
                'Total Contribution',
                'Employee Contribution',
                'Employer Contribution',
                'Rollover*'
                };
        List < ACET_AutoDocUtil.TableRow > tableRows = new List < ACET_AutoDocUtil.TableRow > ();
        if (contDetails != null) {
            for (integer i = 0; i < contDetails.size(); i++) {
                ACET_AutoDocUtil.TableRow tableRow = new ACET_AutoDocUtil.TableRow();
                tableRow.checked = false;
			    string filingStatus ;
                if(contDetails[i].cyFilingStatus == '1'){
                    filingStatus='Individual';
                }else{
                    filingStatus='Family'; 
                }     
                if(i == 1){
                    filingStatus = '';
                    contDetails[i].cyContributionLimit = '';
                    contDetails[i].totalContribution = '';
                    contDetails[i].cyEmployeeContribution = contDetails[i].pyEmployeeContributionForCy;
                    contDetails[i].cyEmployerContribution = contDetails[i].pyEmployerContributionForCy;
                    contDetails[i].rollOver = '';
                  }

                tableRow.uniqueKey = contDetails[i].cyFilingStatus;
                List < ACET_AutoDocUtil.RowColumnData > rowColumns = new List < ACET_AutoDocUtil.RowColumnData > ();
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText',filingStatus,true));
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', contDetails[i].cyContributionLimit != '' ? '$'+contDetails[i].cyContributionLimit : '',true));
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', contDetails[i].totalContribution != '' ? '$'+contDetails[i].totalContribution : '',true));
                if(i == 1){
                 rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', contDetails[i].cyEmployeeContribution != ''? '$'+ contDetails[i].cyEmployeeContribution + ' '+openBraces+' ' + contDetails[i].previousYear + ' made in ' + contDetails[i].currentYear + ')' : '',true));
				 rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', contDetails[i].cyEmployerContribution != '' ?'$'+ contDetails[i].cyEmployerContribution + ' '+openBraces+' ' + contDetails[i].previousYear + ' made in ' + contDetails[i].currentYear + ')' : '',true));
                }
                if(i == 0){
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', contDetails[i].cyEmployeeContribution != ''? '$'+ contDetails[i].cyEmployeeContribution + ' '+openBraces+' ' + contDetails[i].currentYear + ')' : '',true));
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', contDetails[i].cyEmployerContribution != '' ?'$'+ contDetails[i].cyEmployerContribution + ' '+openBraces+' ' + contDetails[i].currentYear + ')' : '',true));
                }
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', contDetails[i].rollOver != '' ? contDetails[i].rollOver : '',true));
                tableRow.rowColumnData = rowColumns;
                tableRows.add(tableRow);
            }
            affTable.tableBody = tableRows;
       }
        return affTable;
    }
    //for previous year auto doc contributions
	 @AuraEnabled
    public static ACET_AutoDocUtil.TableDetails getautoDocContpreviousyear(List <ContributionForPy> contDetailsForPy) {
	    string contributions='Contributions';
		string openBraces='(For';
        ACET_AutoDocUtil.TableDetails affTable = new ACET_AutoDocUtil.TableDetails();
        affTable.type = 'table';
        affTable.componentOrder = 2;
        affTable.componentName = contDetailsForPy[0].previousYear +' '+contributions;
        affTable.showComponentName= false;
        affTable.autodocHeaderName = contDetailsForPy[0].previousYear +' '+contributions;
        affTable.tableHeaders = new List < String > {
                'Filing Status',
                'Limit',
                'Total Contribution',
                'Employee Contribution',
                'Employer Contribution',
                'Rollover*'
               };
        List < ACET_AutoDocUtil.TableRow > tableRows = new List < ACET_AutoDocUtil.TableRow > ();
        if (contDetailsForPy != null) {
            for (integer i = 0; i < contDetailsForPy.size(); i++) {
                ACET_AutoDocUtil.TableRow tableRow = new ACET_AutoDocUtil.TableRow();
                tableRow.checked = false;
			    string filingStatus ;
                if(contDetailsForPy[i].pyFilingStatus == '1'){
                    filingStatus='Individual';
                }else{
                    filingStatus='Family'; 
                }     
                
                tableRow.uniqueKey = contDetailsForPy[i].pyFilingStatus;
                List < ACET_AutoDocUtil.RowColumnData > rowColumns = new List < ACET_AutoDocUtil.RowColumnData > ();
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText',filingStatus,true));
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', contDetailsForPy[i].pyContributionLimit != '' ? '$'+contDetailsForPy[i].pyContributionLimit : '',true));
                if(contDetailsForPy[i].totalPrevious == null){
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', contDetailsForPy[i].totalPrevious != '' ?'$'+ 0 : '',true));
                }
                if(contDetailsForPy[i].totalPrevious != null){
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', contDetailsForPy[i].totalPrevious != '' ?'$'+ contDetailsForPy[i].totalPrevious : '',true));
                }
                if(contDetailsForPy[i].pyEmployeeContribution == null){
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', contDetailsForPy[i].pyEmployeeContribution != '' ?'$'+ 0 +' '+openBraces+' '  + contDetailsForPy[i].previousYear + ')' : '',true));
                }
                 if(contDetailsForPy[i].pyEmployeeContribution != null){
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', contDetailsForPy[i].pyEmployeeContribution != '' ?'$'+ contDetailsForPy[i].pyEmployeeContribution +' '+openBraces+' '  + contDetailsForPy[i].previousYear + ')' : '',true));
                }
                if(contDetailsForPy[i].pyEmployeeContribution == null){
                    rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', contDetailsForPy[i].pyEmployerContribution != '' ? '$'+ 0 + ' '+openBraces+' ' + contDetailsForPy[i].previousYear + ')' : '',true));
                }
                if(contDetailsForPy[i].pyEmployeeContribution != null){
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', contDetailsForPy[i].pyEmployerContribution != '' ? '$'+contDetailsForPy[i].pyEmployerContribution + ' '+openBraces+' ' + contDetailsForPy[i].previousYear + ')' : '',true));
                }
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', contDetailsForPy[i].rollOver != '' ? contDetailsForPy[i].rollOver : '',true));
                tableRow.rowColumnData = rowColumns;
                tableRows.add(tableRow);
            }
            affTable.tableBody = tableRows;
        }
        return affTable;
    }
	 //for notifications
	@AuraEnabled
    public static ACET_AutoDocUtil.TableDetails getautoDocNotifications(List <NotificationList> notiDetails) {
        ACET_AutoDocUtil.TableDetails affTable = new ACET_AutoDocUtil.TableDetails();
        affTable.type = 'table';
        affTable.componentOrder = 3;
        affTable.componentName = 'Notifications';
        affTable.showComponentName= false;
        affTable.autodocHeaderName = 'Notifications';
        affTable.tableHeaders = new List < String > {
                'Documents',
                'Preference'
                };
        List < ACET_AutoDocUtil.TableRow > tableRows = new List < ACET_AutoDocUtil.TableRow > ();
        if (notiDetails != null) {
            for (integer i = 0; i < notiDetails.size(); i++) {
                ACET_AutoDocUtil.TableRow tableRow = new ACET_AutoDocUtil.TableRow();
                tableRow.checked = false;
               tableRow.uniqueKey = notiDetails[i].documents;
                List < ACET_AutoDocUtil.RowColumnData > rowColumns = new List < ACET_AutoDocUtil.RowColumnData > ();
  			    rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', notiDetails[i].documents != '' ? notiDetails[i].documents  : '',true));
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', notiDetails[i].preference != ''?  notiDetails[i].preference : '',true));
	             tableRow.rowColumnData = rowColumns;
                tableRows.add(tableRow);
            }
            affTable.tableBody = tableRows;
             system.debug(affTable.tableBody.size());
       }
        return affTable;
    }
	 //for denial history
	 @AuraEnabled
    public static ACET_AutoDocUtil.TableDetails getAutoDocDenialHis(List <DenialHistory> denialHis) {
        ACET_AutoDocUtil.TableDetails affTable = new ACET_AutoDocUtil.TableDetails();
        affTable.type = 'table';
        affTable.componentOrder = 4;
        affTable.componentName = 'Denial History';
        affTable.showComponentName= false;
        affTable.autodocHeaderName = 'Denial History';
        affTable.tableHeaders = new List < String > {
                'Date',
                'Denial Reason',
                'Denied By*',
                'Amount',
                'Status*'
                };
        List < ACET_AutoDocUtil.TableRow > tableRows = new List < ACET_AutoDocUtil.TableRow > ();
        if (denialHis != null) {
            for (integer i = 0; i < denialHis.size(); i++) {
                ACET_AutoDocUtil.TableRow tableRow = new ACET_AutoDocUtil.TableRow();
                tableRow.checked = false;
	            tableRow.uniqueKey = denialHis[i].denialStatusDate;
                List < ACET_AutoDocUtil.RowColumnData > rowColumns = new List < ACET_AutoDocUtil.RowColumnData > ();
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText',denialHis[i].denialStatusDate,true));
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', denialHis[i].reasonForDenial != '' ? denialHis[i].reasonForDenial : '',true));
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', denialHis[i].denialBy != '' ? denialHis[i].denialBy : '',true));
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', denialHis[i].deniedClaimAmount != '' ? '$'+denialHis[i].deniedClaimAmount : '',true));
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', denialHis[i].status != '' ? denialHis[i].status : '',true));
               tableRow.rowColumnData = rowColumns;
                tableRows.add(tableRow);
            }
            affTable.tableBody = tableRows;
        }
        return affTable;
    }
     //for rmi notes
	 @AuraEnabled
    public static ACET_AutoDocUtil.TableDetails getAutoDocRmiNotes(List <RmiNotes> rmiNotesList) {
       ACET_AutoDocUtil.TableDetails affTable = new ACET_AutoDocUtil.TableDetails();
        affTable.type = 'table';
        affTable.componentOrder = 4;
        affTable.componentName = 'Request for More Information History';
        affTable.showComponentName= false;
        affTable.autodocHeaderName = 'Request for More Information History';
        affTable.tableHeaders = new List < String > {
                'Date/ Time',
                'Reason ',
                'RMI Amount',
                'Submitted By',
                'Status',
				'Note'
                };
        List < ACET_AutoDocUtil.TableRow > tableRows = new List < ACET_AutoDocUtil.TableRow > ();
        if (rmiNotesList != null) {
            for (integer i = 0; i < rmiNotesList.size(); i++) {
                ACET_AutoDocUtil.TableRow tableRow = new ACET_AutoDocUtil.TableRow();
                tableRow.checked = false;
	            tableRow.uniqueKey = rmiNotesList[i].actionTs;
                List < ACET_AutoDocUtil.RowColumnData > rowColumns = new List < ACET_AutoDocUtil.RowColumnData > ();
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText',rmiNotesList[i].actionTs,true));
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', rmiNotesList[i].reason != '' ? rmiNotesList[i].reason : '',true));
				if(rmiNotesList[i].actionAmount != null){
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', rmiNotesList[i].actionAmount != '' ? '$'+rmiNotesList[i].actionAmount : '',true));
				}
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', rmiNotesList[i].user != '' ? rmiNotesList[i].user : '',true));
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', rmiNotesList[i].status != '' ? rmiNotesList[i].status : '',true));
				rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', rmiNotesList[i].rmiNote != '' ? rmiNotesList[i].rmiNote : '',true));
               tableRow.rowColumnData = rowColumns;
                tableRows.add(tableRow);
            }
            affTable.tableBody = tableRows;
        }
        return affTable;
    }
	
	 //for admin notes
	 @AuraEnabled
    public static ACET_AutoDocUtil.TableDetails getAutoDocAdminNotes(List <AdminNotesDetails> adminNotesList) {
        ACET_AutoDocUtil.TableDetails affTable = new ACET_AutoDocUtil.TableDetails();
        affTable.type = 'table';
        affTable.componentOrder = 3;
        affTable.componentName = 'Administrative Notes';
        affTable.showComponentName= false;
        affTable.autodocHeaderName = 'Administrative Notes';
        affTable.tableHeaders = new List < String > {
                'Date/ Time',
                'Administrator ',
                'Note'
                };
        List < ACET_AutoDocUtil.TableRow > tableRows = new List < ACET_AutoDocUtil.TableRow > ();
        if (adminNotesList != null) {
            for (integer i = 0; i < adminNotesList.size(); i++) {
               ACET_AutoDocUtil.TableRow tableRow = new ACET_AutoDocUtil.TableRow();
                tableRow.checked = false;
	            tableRow.uniqueKey = adminNotesList[i].noteTs;
                List < ACET_AutoDocUtil.RowColumnData > rowColumns = new List < ACET_AutoDocUtil.RowColumnData > ();
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText',adminNotesList[i].noteTs,true));
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', adminNotesList[i].user != '' ? adminNotesList[i].user : '',true));
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', adminNotesList[i].adminNote != '' ? adminNotesList[i].adminNote : '',true));
               tableRow.rowColumnData = rowColumns;
                tableRows.add(tableRow);
            }
            affTable.tableBody = tableRows;
        }
        return affTable;
    }
    //US3241994 Autodoc Demographics
    @AuraEnabled
    public static ACET_AutoDocUtil.TableDetails getAutoDocDemographicsPhone(List <DemographicPhoneValues> credDetails) {
        system.debug('credDetails' + credDetails);
         String preffed;
         String phone = 'Phone Number';
        ACET_AutoDocUtil.TableDetails affTable = new ACET_AutoDocUtil.TableDetails();
        affTable.type = 'table';
        affTable.componentOrder = 3;
        affTable.componentName = phone;
        affTable.showComponentName= false;
        affTable.autodocHeaderName = phone;
        affTable.tableHeaders = new List < String > {
            phone,
                'Ext*',
                'Type'
                };
        List < ACET_AutoDocUtil.TableRow > tableRows = new List < ACET_AutoDocUtil.TableRow > ();
        if (credDetails != null) {
            for (integer i = 0; i < credDetails.size(); i++) {
                preffed = '';
              ACET_AutoDocUtil.TableRow tableRow = new ACET_AutoDocUtil.TableRow();
                tableRow.checked = false;
                tableRow.uniqueKey = credDetails[i].ptype;
                List < ACET_AutoDocUtil.RowColumnData > rowColumns = new List < ACET_AutoDocUtil.RowColumnData > ();
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', credDetails[i].pwork,true));
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', credDetails[i].extension != '' ? credDetails[i].extension : '',true));
                if(credDetails[i].priIndi == null){
                    rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', credDetails[i].ptype != '' ? credDetails[i].ptype : '',true));
                }else if(credDetails[i].priIndi != null){
                    rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', credDetails[i].ptype != '' ? credDetails[i].ptype + ' ' + credDetails[i].priIndi : '',true));
                }
                tableRow.rowColumnData = rowColumns;
                tableRows.add(tableRow);
            }
            affTable.tableBody = tableRows;
            system.debug(affTable.tableBody.size());
        }
        system.debug('affTable ' + affTable);
        return affTable;
    }

    //US3254524 Autodoc Account Activity
    @AuraEnabled
    public static ACET_AutoDocUtil.TableDetails getautoDocTabDataTransactions(List <NotionalAccountActivity> credDetails, string totalResults, string pageSize, string endPage, string startPage) {
        ACET_AutoDocUtil.TableDetails affTable = new ACET_AutoDocUtil.TableDetails();
        affTable.type = 'table';
        affTable.componentOrder = 3;
        affTable.componentName = 'Account Activity';
		affTable.showComponentName= false;
        affTable.autodocHeaderName = 'Account Activity';
        affTable.tableHeaders = new List < String > {
            'Date',
            'Amount',
            'Type',
            'Check Number',
            'Contribution Comments'
        };
        List < ACET_AutoDocUtil.TableRow > tableRows = new List < ACET_AutoDocUtil.TableRow > ();
        if (credDetails != null) {
            for (integer i = 0; i < credDetails.size(); i++) {
                ACET_AutoDocUtil.TableRow tableRow = new ACET_AutoDocUtil.TableRow();
                tableRow.checked = false;
                tableRow.uniqueKey= String.valueof(Integer.valueof((Math.random() * 10000)));
                List < ACET_AutoDocUtil.RowColumnData > rowColumns = new List < ACET_AutoDocUtil.RowColumnData > ();
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', credDetails[i].paymentDate,true));
				if (credDetails[i].paymentAmount != null){
                    rowColumns.add(ACET_AutoDocUtil.setRowColumnData('Currency', credDetails[i].paymentAmount != '' ? credDetails[i].paymentAmount : '--',true));
                }else{
                    rowColumns.add(ACET_AutoDocUtil.setRowColumnData('Currency', credDetails[i].paymentAmount != '' ? '0.00' : '--',true));
                }
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', credDetails[i].Type != '' ? credDetails[i].Type : '--',true));
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', credDetails[i].paymentCheckNum != '' ? credDetails[i].paymentCheckNum : '--',true));
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', credDetails[i].contributionComments != '' ? credDetails[i].contributionComments : '--',true));
                tableRow.rowColumnData = rowColumns;
                tableRows.add(tableRow);
            }
            affTable.tableBody = tableRows;
                       
            // Setting Pagination
           Integer startNo = (Integer.valueOf(startPage));
           Integer endNo = (Integer.valueOf(endPage));
           Integer totalRecords = Integer.valueOf(totalResults);
           Integer noOfPages = (Integer) Math.ceil((Decimal) totalRecords / 25);           
            // Pagination
            Integer resultsSize = credDetails != null ? credDetails.size() : 0;
            ACET_AutoDocUtil.PaginationInfo p_info = ACET_AutoDocUtil.processPaginationData(startNo, resultsSize, totalRecords, 25);
            affTable.startNumber = (startNo < 0) ? 0 : startNo;
            affTable.endNumber = p_info.endNo;
            affTable.recordCount = p_info.recordCount;
            affTable.noOfPages = p_info.pageSize;            
        }
        return affTable;       
    }
    //US3242040: Autodoc Debit Cards
    /*	 @AuraEnabled
        public static ACET_AutoDocUtil.TableDetails getAutoDocDebitCard(List <DebitCard> debCard) {
            ACET_AutoDocUtil.TableDetails affTable = new ACET_AutoDocUtil.TableDetails();
            affTable.type = 'table';
            affTable.componentOrder = 4;
            affTable.componentName = 'Debit Card';
            affTable.showComponentName= false;
            affTable.autodocHeaderName = 'Debit Card';
            affTable.tableHeaders = new List < String > {
                    'Last 4 Card Digits',
                    'Embossed Name',
                    'Card Type',
                    'Card Status',
                    'Card Order Status*',
                    'Order Date',
                    'Mailed Date*',
                    'Expiration Date'
                    };
            List < ACET_AutoDocUtil.TableRow > tableRows = new List < ACET_AutoDocUtil.TableRow > ();
            if (debCard != null) {
                for (integer i = 0; i < debCard.size(); i++) {
                    ACET_AutoDocUtil.TableRow tableRow = new ACET_AutoDocUtil.TableRow();
                    tableRow.checked = false;
    	            tableRow.uniqueKey= String.valueof(Integer.valueof((Math.random() * 10000)));
                    List < ACET_AutoDocUtil.RowColumnData > rowColumns = new List < ACET_AutoDocUtil.RowColumnData > ();
                    rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText',debCard[i].cardDigits,true));
                    rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', debCard[i].embossedName != '' ? debCard[i].embossedName : '',true));
                    rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', debCard[i].cardType != '' ? debCard[i].cardType : '',true));
                    rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', debCard[i].status != '' ? debCard[i].status : '',true));
                    rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', debCard[i].orderStatus != '' ? debCard[i].orderStatus : '',true));
                    rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', debCard[i].requestDate != '' ? debCard[i].requestDate : '',true));
                    rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', debCard[i].mailedDate != '' ? debCard[i].mailedDate : '',true));
                    rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', debCard[i].expirationDate != '' ? debCard[i].expirationDate : '',true));
                    tableRow.rowColumnData = rowColumns;
                    tableRows.add(tableRow);
                }
                affTable.tableBody = tableRows;
            }
            return affTable;
        } */
		
		//for Transaction AutoDoc
     @AuraEnabled
    public static ACET_AutoDocUtil.TableDetails getautoDocTableDataTransactionsForHSA(List <Transactions> transactionData, string totalResults, string pageSize, string endPage, string startPage) {
        ACET_AutoDocUtil.TableDetails affTable = new ACET_AutoDocUtil.TableDetails();
        affTable.type = 'table';
        affTable.componentOrder = 3;
        affTable.componentName = 'Transactions';
		affTable.showComponentName= false;
        affTable.autodocHeaderName = 'Transactions';
        affTable.tableHeaders = new List < String > {
            'Transaction Date',
            'Amount',
            'Running Balance*',
            'Type',
            'Status',
            'Description',
            'Check Number',
            'Transaction Code'
        };
        List < ACET_AutoDocUtil.TableRow > tableRows = new List < ACET_AutoDocUtil.TableRow > ();
        if (transactionData != null) {
            for (integer i = 0; i < transactionData.size(); i++) {
                ACET_AutoDocUtil.TableRow tableRow = new ACET_AutoDocUtil.TableRow();
                tableRow.checked = false;
                tableRow.uniqueKey = String.valueof(Integer.valueof((Math.random() * 10000)));
                List < ACET_AutoDocUtil.RowColumnData > rowColumns = new List < ACET_AutoDocUtil.RowColumnData > ();
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', transactionData[i].transactionDate,true));
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('Currency', transactionData[i].convertAmount != '' ? transactionData[i].convertAmount : ' ',true));
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', transactionData[i].runningBalance != '' ? transactionData[i].runningBalance : '',true));
              	rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', transactionData[i].debitOrCreditType != '' ? transactionData[i].debitOrCreditType : '',true));
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', transactionData[i].type != '' ? transactionData[i].type :'',true));
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', transactionData[i].descriptionMemo != '' ? transactionData[i].descriptionMemo : '',true));
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', transactionData[i].documentNumber != '' ? transactionData[i].documentNumber : '',true));
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', transactionData[i].transactionCode != '' ? transactionData[i].transactionCode : '',true));
                tableRow.rowColumnData = rowColumns;
                tableRows.add(tableRow);
            }
            affTable.tableBody = tableRows;
           // Setting Pagination
            Integer startNo = (Integer.valueOf(startPage));
            Integer endNo = (Integer.valueOf(endPage));
            Integer totalRecords = Integer.valueOf(totalResults);
            Integer noOfPages = (Integer) Math.ceil((Decimal) totalRecords / 25);
            // Pagination
            Integer resultsSize = transactionData != null ? transactionData.size() : 0;
            ACET_AutoDocUtil.PaginationInfo p_info = ACET_AutoDocUtil.processPaginationData(startNo, resultsSize, totalRecords, 25);
            affTable.startNumber = (startNo < 0) ? 0 : startNo;
            affTable.endNumber = p_info.endNo;
            affTable.recordCount = p_info.recordCount;
            affTable.noOfPages = p_info.pageSize;
            
        }
       return affTable;
       
    }
		
      // for Transactions
      public class Transactions
    {
        @AuraEnabled public String transactionDate{get;set;}
        @AuraEnabled public String convertAmount{get;set;}
        @AuraEnabled public String runningBalance{get;set;}
        @AuraEnabled public String debitOrCreditType{get;set;}
        @AuraEnabled public String type{get;set;}
        @AuraEnabled public String descriptionMemo{get;set;}
        @AuraEnabled public String documentNumber{get;set;}
        @AuraEnabled public String transactionCode{get;set;}
	}

    // for Debit Card
 /*   public class DebitCard
    {
        @AuraEnabled public String cardDigits{get;set;}
        @AuraEnabled public String embossedName{get;set;}
        @AuraEnabled public String cardType{get;set;}
        @AuraEnabled public String status{get;set;}
        @AuraEnabled public String orderStatus{get;set;}
        @AuraEnabled public String requestDate{get;set;}
        @AuraEnabled public String mailedDate{get;set;}
        @AuraEnabled public String expirationDate{get;set;}

    } */
	//for Notification
	 public class NotificationList
    {
        @AuraEnabled public String documents{get;set;}
        @AuraEnabled public String preference{get;set;}
		
     }
	 //for Admin notes
	 public class AdminNotesDetails
    {
        @AuraEnabled public String noteTs{get;set;}
        @AuraEnabled public String user{get;set;}
		@AuraEnabled public String adminNote{get;set;}
		
      }
	
	//for rmi notes
	 public class RmiNotes
    {
        @AuraEnabled public String actionTs{get;set;}
        @AuraEnabled public String reason{get;set;}
		@AuraEnabled public String actionAmount{get;set;}
		@AuraEnabled public String user{get;set;}
		@AuraEnabled public String status {get;set;}
		@AuraEnabled public String rmiNote {get;set;}
		
      }
	
    //for denial history
     public class DenialHistory
    {
        @AuraEnabled public String denialStatusDate{get;set;}
        @AuraEnabled public String reasonForDenial{get;set;}
		@AuraEnabled public String denialBy{get;set;}
		@AuraEnabled public String deniedClaimAmount{get;set;}
		@AuraEnabled public String status {get;set;}
		
      }
   
    //for contribution
	 public class Contribution
    {
        @AuraEnabled public String cyFilingStatus{get;set;}
        @AuraEnabled public String cyContributionLimit{get;set;}
		@AuraEnabled public String totalContribution{get;set;}
		@AuraEnabled public String cyEmployeeContribution{get;set;}
		@AuraEnabled public String cyEmployerContribution {get;set;}
		@AuraEnabled public String pyEmployeeContributionForCy {get;set;}
		@AuraEnabled public String pyEmployerContributionForCy {get;set;}
        @AuraEnabled public String currentYear {get;set;}
        @AuraEnabled public String previousYear {get;set;}
        @AuraEnabled public String rollOver {get;set;}
       
		}
     //for previous year contribution
	 public class ContributionForPy
    {
        @AuraEnabled public String pyFilingStatus{get;set;}
        @AuraEnabled public String pyContributionLimit{get;set;}
        @AuraEnabled public String totalPrevious{get;set;}
        @AuraEnabled public String pyEmployeeContribution{get;set;}
        @AuraEnabled public String pyEmployerContribution{get;set;}
        @AuraEnabled public String previousYear {get;set;}
        @AuraEnabled public String rollOver {get;set;}
    }
    public class NotionalAccount
    {
        @AuraEnabled public String nickname{get;set;}
        @AuraEnabled public String bankName{get;set;}
        @AuraEnabled public String bankRoutingNumber{get;set;}
        @AuraEnabled public String bankAccountNumber{get;set;}
        @AuraEnabled public String bankAccountType{get;set;}
        @AuraEnabled public String bankAccountStatus{get;set;}
        @AuraEnabled public String cmpdateAdded{get;set;}
        @AuraEnabled public String cmpdateVerified{get;set;}
        @AuraEnabled public String hasScheduledTransactions{get;set;}
        @AuraEnabled public String paymentDate{get;set;}
        @AuraEnabled public String paymentAmount{get;set;}
        @AuraEnabled public String contributionComments{get;set;}
        @AuraEnabled public String Type{get;set;}
        @AuraEnabled public String paymentCheckNum{get;set;}
    }
    public class NotionalAccountDetails
    {
     @AuraEnabled public String submittedClaims {get;set;}
        @AuraEnabled public String pendingClaims {get;set;}
        @AuraEnabled public String deniedClaims {get;set;}
        @AuraEnabled public String paidClaims {get;set;}
        
          }
	//US3254502 Autodoc Investments
    public class InvestSweepDetails
    {
     @AuraEnabled public String status {get;set;}
        @AuraEnabled public String threshold {get;set;}
        @AuraEnabled public String account {get;set;}
       }
    //US3254502 Autodoc Investments
    public class InvestDetails
    {
     @AuraEnabled public String balance {get;set;}
        @AuraEnabled public String status {get;set;}
        @AuraEnabled public String plan {get;set;}
         @AuraEnabled public String cashBalance {get;set;}
        @AuraEnabled public String investThreshold {get;set;}
        @AuraEnabled public String title {get;set;}
       }
       //US3241994 Autodoc Demographics
    public class DemographicPhoneValues
    {
     @AuraEnabled public String pwork {get;set;}
        @AuraEnabled public String extension {get;set;}
         @AuraEnabled public String ptype {get;set;}
        @AuraEnabled public String priIndi {get;set;}
        }
        //US3254524 Autodoc Account Activity
    public class NotionalAccountActivity
    {
        @AuraEnabled public String paymentDate{get;set;}
        @AuraEnabled public String paymentAmount{get;set;}
        @AuraEnabled public String contributionComments{get;set;}
        @AuraEnabled public String Type{get;set;}
        @AuraEnabled public String paymentCheckNum{get;set;}
	}
    public class MemberSearchServiceException extends Exception {}
}