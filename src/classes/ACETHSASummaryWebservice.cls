public class ACETHSASummaryWebservice extends ACETWebservice
{
    public ACETHSASummaryResult hsaSummaryresult { get; set;} 
    private String address,homenumber ,homenumberType,worknumber, worknumberType,mobileNumber, mobileNumberType  ;
    
    public override void GetEndpoint()
    {
        GetEndpointDetail('HSASummary');
    }
    public ACETHSASummaryWebservice() {
        super('Stargate');
    }
    private void GetRequestBody(String ssn)
    {
       
        RequestBody = '{"hsaSummaryRequest": {'+
                            '"searchIdentifiers": [{'+
                                    '"searchId":"'+ssn+'",'+
                                    '"typeCode": "ssn"'+
                             '}]}}';

        System.debug('Request Body Json'+RequestBody);                       
    }
    
    public ACETHSASummaryResult parseSuccessAdapterResponse(String ResponseBody)
    {
        hsaSummaryresult = new ACETHSASummaryResult(); 
        hsaSummaryresult.hsaAccounts= new  list<ACETHSASummaryResult.HSAAccountsWrapper>();
        hsaSummaryresult.accHolderList= new  list<ACETHSASummaryResult.hsaBankAuthentication>();
        
        ACETHSASummaryJSON2Apex.individuals summaryDetails; 
        ACETHSASummaryJSON2Apex ACTHSAJSON2Apex = (ACETHSASummaryJSON2Apex)JSON.deserialize(ResponseBody, ACETHSASummaryJSON2Apex .class);
        system.debug('ACTHSAJSON2Apex :-------------------------' +ACTHSAJSON2Apex);
        summaryDetails = ACTHSAJSON2Apex.hsaSummaryResponse.individuals;
        system.debug('@@@SummaryDetails'+summaryDetails );
        
        HSASummaryMapping(summaryDetails );
        return hsaSummaryresult ;
    } 
    
      private void HSASummaryMapping(ACETHSASummaryJSON2Apex.individuals  summaryDetails )
      {
        try{
        system.debug('@@@@response for HSA Summary ======='+summaryDetails );
        if(summaryDetails != null)
        {
            ACETHSASummaryResult.hsaBankAuthentication accHolder = new ACETHSASummaryResult.hsaBankAuthentication();
            ACETHSASummaryResult.HSAAccountsWrapper account = new ACETHSASummaryResult.HSAAccountsWrapper();
            
            accHolder.accountHoldersName = ((summaryDetails.firstName != null)?summaryDetails.firstName:'')+' '+((summaryDetails.lastName != null)?summaryDetails.lastName:'');
            accHolder.ssn= summaryDetails.socialSecurityNumber;
            address = '';
            if(summaryDetails.postalAddress != null){
                address = address + ((summaryDetails.postalAddress.streetLine1 != Null && summaryDetails.postalAddress.streetLine1 != '')?summaryDetails.postalAddress.streetLine1:'');                    
                address = address + ((summaryDetails.postalAddress.streetLine2 != Null && summaryDetails.postalAddress.streetLine2 != '')?', '+summaryDetails.postalAddress.streetLine2 :'');
                address = address + ((summaryDetails.postalAddress.city != Null && summaryDetails.postalAddress.city != '')?', '+summaryDetails.postalAddress.city :'');
                address = address + ((summaryDetails.postalAddress.stateCode!= Null && summaryDetails.postalAddress.stateCode!= '')?', '+summaryDetails.postalAddress.stateCode:'');            
                address = address + ((summaryDetails.postalAddress.postalCode!= Null && summaryDetails.postalAddress.postalCode!= '')?', '+summaryDetails.postalAddress.postalCode:'');
                address = address.removeStart(',');  
                
                system.debug('@@@address'+address);
                accHolder.address= address;
            
            }
            //accHolder.phone= (summaryDetails.telephone != null && summaryDetails.telephone[0].phoneNumber != null)?summaryDetails.telephone[0].phoneNumber.substring(0,3)+'-'+summaryDetails.telephone[0].phoneNumber.substring(3,6)+'-'+summaryDetails.telephone[0].phoneNumber.substring(6,10):'';
            if(summaryDetails.telephone!= null){
                for(ACETHSASummaryJSON2Apex.telephone ph:summaryDetails.telephone)
                {
                    if(ph.phoneType != null && ph.phoneType == 'H' && ph.phoneNumber != null){
                       homenumber =  ph.phoneNumber ;
                       homeNumberType =  'Home' ; 
                    }else if(ph.phoneType != null && ph.phoneType == 'W' && ph.phoneNumber != null){
                       worknumber =  ph.phoneNumber ;
                       workNumberType = 'Work' ; 
                    } else if(ph.phoneType != null && ph.phoneType == 'M' && ph.phoneNumber != null){
                       mobilenumber =  ph.phoneNumber ;
                       mobileNumberType = 'Mobile' ; 
                    }     
                }
                if(!String.isEmpty(homeNumber))
                {
                    accHolder.phone = homeNumber.substring(0,3)+'-'+homeNumber.substring(3,6)+'-'+homeNumber.substring(6,10);
                    accHolder.phoneType = homeNumberType;
                }
                else if(!String.isEmpty(mobileNumber))
                {
                    accHolder.phone = mobileNumber.substring(0,3)+'-'+mobileNumber.substring(3,6)+'-'+mobileNumber.substring(6,10);
                    accHolder.phoneType = mobileNumberType;
                }
                else if(!String.isEmpty(worknumber))
                {
                    accHolder.phone = worknumber.substring(0,3)+'-'+worknumber.substring(3,6)+'-'+worknumber.substring(6,10);
                    accHolder.phoneType = workNumberType ;
                }

            }
            accHolder.dob= (summaryDetails.birthDate!= null)?cleanDate(String.ValueOf((ACETUtility.format(Date.valueOf(summaryDetails.birthDate))))):'';
            system.debug('@@@accholder'+accHolder);
            hsaSummaryresult.accHolderList.add(accHolder);
            
            if(summaryDetails.accountDetails != null){
                for(ACETHSASummaryJSON2Apex.AccountDetails acc:summaryDetails.accountDetails){
                    account = new ACETHSASummaryResult.HSAAccountsWrapper();
                    account.hsaId = (acc.Id != null)?acc.Id:'';
                    account.HSAAccountNoMasked = (acc.accountId != null)?'XXXXX'+acc.accountId.substring(acc.accountId.length()-4):'';
                    account.HSAAccountNo = (acc.accountId!= null)?acc.accountId:'';
                    account.AccCode= (acc.accountType != null)?acc.accountType:'';
                    account.AccName= (acc.accountName != null)?acc.accountName:'';
                    account.cummulativeBalance= (acc.totalBalance != null)?acc.totalBalance:'$0.0';
                    account.investedBalance= (acc.accountName != null)?acc.investedBalance:'$0.0';
                    account.availableBalance= (acc.accountName != null)?acc.availableBalance:'$0.0';
                    account.administeredBy= 'OPTUM BANK';
                    account.groupId = (acc.employerGroup != null && acc.employerGroup.employerGroupId != null)?acc.employerGroup.employerGroupId:'';
                    account.groupName = (acc.employerGroup != null && acc.employerGroup.employerGroupName != null)?acc.employerGroup.employerGroupName:'';
                    hsaSummaryresult.hsaAccounts.add(account);
                }
           }
            system.debug('@@@ Summary final'+hsaSummaryresult);
        }
                
        } catch(Exception ex){
                  system.debug(LoggingLevel.INFO, 'Issues in HSA Summary' + ex);                 
                }
           
      }
  
  public ACETWSCalloutResult GetHsaSummary(String ssn){
        ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult(); 
        hsaSummaryresult = new ACETHSASummaryResult();
        try{
            GetEndpoint();
            system.debug('$$$URL'+baseurl + '   ' + relativeurl);
            GetRequestBody(ssn);
            HttpResponse Response = Send(OAuthConfig);
            //Response.setStatusCode(401);
            system.debug('Response----->'+Response);
            oACETWSCalloutResult.statusCode=response!=null?response.getStatusCode():null;
            if (Response.getStatusCode() == 200){
                oACETWSCalloutResult.Success = true;
                oACETWSCalloutResult.Message = '';
                oACETWSCalloutResult.Response = parseSuccessAdapterResponse(Response.getBody());
            }else if (Response.getStatusCode() == 404){
                oACETWSCalloutResult.Success = true;
                oACETWSCalloutResult.Message = '';
                oACETWSCalloutResult.Response = hsaSummaryResult;
            }else
            {
                    //oACETWSCalloutResult = ParseFailureResponse(Response);
                    oACETWSCalloutResult.Success = false;
                    oACETWSCalloutResult.Message = label.ACETWebServiceUnavailableErrorMessage;
                    oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;
                    oACETWSCalloutResult.statusCode=response!=null?response.getStatusCode():null;
                }  
        }
        catch(Exception ex){
            system.debug(LoggingLevel.INFO, 'Exception in HSA Summary Response. Details: ' + ex.getStackTraceString()); 
            oACETWSCalloutResult.Success = false;
            oACETWSCalloutResult.Message = ex.getMessage();
            oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;
            oACETWSCalloutResult.statusCode=999;
        }
        return oACETWSCalloutResult;
    }
    
    public String cleanDate(String theDate){
        String [] s = theDate.split('/');
        String newDate= '';
        String newMonth= '';
        String newDay= '';
        if(s[0].length() == 1){
            newMonth = '0'+s[0];
        }else{
            newMonth = s[0];
        }
        if(s[1].length() == 1){
            newDay = '0'+s[1];
        }else{
            newDay = s[1];
        }
        newDate = newMonth+'/'+newDay+'/'+s[2];
        return newDate;
    }
}