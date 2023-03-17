public class ACETLGT_HSASummaryWebservice extends ACETWebservice
{
    public ACETLGT_HSASummaryResult hsaSummaryresult { get; set;} 
    private String address,homenumber ,homenumberType,worknumber, worknumberType,mobileNumber, mobileNumberType  ;
    
    public override void GetEndpoint()
    {
        GetEndpointDetail('HSASummary');
    }
    public ACETLGT_HSASummaryWebservice() {
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
    
    public ACETLGT_HSASummaryResult parseSuccessAdapterResponse(String ResponseBody)
    {
        hsaSummaryresult = new ACETLGT_HSASummaryResult(); 
        hsaSummaryresult.hsaAccounts= new  list<ACETLGT_HSASummaryResult.HSAAccountsWrapper>();
        hsaSummaryresult.accHolderList= new  list<ACETLGT_HSASummaryResult.hsaBankAuthentication>();
        
        ACETLGT_HSASummaryJSON2Apex.individuals summaryDetails; 
        ACETLGT_HSASummaryJSON2Apex ACTHSAJSON2Apex = (ACETLGT_HSASummaryJSON2Apex)JSON.deserialize(ResponseBody, ACETLGT_HSASummaryJSON2Apex .class);
        system.debug('ACTHSAJSON2Apex :-------------------------' +ACTHSAJSON2Apex);
        summaryDetails = ACTHSAJSON2Apex.hsaSummaryResponse.individuals;
        system.debug('@@@SummaryDetails'+summaryDetails );
        
        HSASummaryMapping(summaryDetails );
        return hsaSummaryresult ;
    } 
    
      private void HSASummaryMapping(ACETLGT_HSASummaryJSON2Apex.individuals  summaryDetails )
      {
        try{
        system.debug('@@@@response for HSA Summary ======='+summaryDetails );
        if(summaryDetails != null)
        {
            ACETLGT_HSASummaryResult.hsaBankAuthentication accHolder = new ACETLGT_HSASummaryResult.hsaBankAuthentication();
            ACETLGT_HSASummaryResult.HSAAccountsWrapper account = new ACETLGT_HSASummaryResult.HSAAccountsWrapper();
            
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
                for(ACETLGT_HSASummaryJSON2Apex.telephone ph:summaryDetails.telephone)
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
            accHolder.dob= (summaryDetails.birthDate!= null)?cleanDate(String.ValueOf(AcetUtility.format(Date.valueOf(summaryDetails.birthDate)))):'';
            system.debug('@@@accholder'+accHolder);
            hsaSummaryresult.accHolderList.add(accHolder);
            
            if(summaryDetails.accountDetails != null){
                for(ACETLGT_HSASummaryJSON2Apex.AccountDetails acc:summaryDetails.accountDetails){
                    account = new ACETLGT_HSASummaryResult.HSAAccountsWrapper();
                    account.hsaId = (acc.Id != null)?acc.Id:'';
                    account.HSAAccountNoMasked = (acc.accountId != null)?'XXXXX'+acc.accountId.substring(acc.accountId.length()-4):'';
                    account.HSAAccountNo = (acc.accountId!= null)?acc.accountId:'';
                    account.AccCode= (acc.accountType != null)?acc.accountType:'';
                    account.AccName= (acc.accountName != null)?acc.accountName:'';
                    account.cummulativeBalance= (acc.totalBalance != null)?(acc.totalBalance.contains('.')?(acc.totalBalance.substringAfter('.').length() == 1?(acc.totalBalance+'0'):acc.totalBalance):(acc.totalBalance+'.00')):'0.00';
            		account.investedBalance= (acc.investedBalance != null)?(acc.investedBalance.contains('.')?(acc.investedBalance.substringAfter('.').length() == 1?acc.investedBalance+'0':acc.investedBalance):acc.investedBalance+'.00'):'0.00';
                    account.availableBalance= (acc.availableBalance != null)?(acc.availableBalance.contains('.')?(acc.availableBalance.substringAfter('.').length() == 1?acc.availableBalance+'0':acc.availableBalance):acc.availableBalance+'.00'):'0.00';
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
  


  //Changes Made ACETWSCalloutResult - ACETWSCalloutResultValues 
  public ACETWSCalloutResult GetHsaSummary(String ssn){
        ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult(); 
        hsaSummaryresult = new ACETLGT_HSASummaryResult();
        try{
            GetEndpoint();
            system.debug('$$$URL'+baseurl + '   ' + relativeurl);
            GetRequestBody(ssn);
            HttpResponse Response = Send(OAuthConfig);
            system.debug('Response----->'+Response);
            
            //response.setStatusCode(200);
            //String respBody = '{"hsaSummaryResponse":{"individuals":{"firstName":"LUCY","lastName":"BAUM","birthDate":"1978-01-01","genderCode":"","socialSecurityNumber":"975946092","postalAddress":{"typeCode":"M","streetLine1":"2525 Lake Park Blvd","streetLine2":"","city":"Salt Lake City","countryCode":"","postalCode":"84120-0000","stateCode":"UT"},"telephone":[{"phoneType":"H","phoneNumber":"8019824539"}],"electronicAddress":{"emailAddress":"rajeswari_sundaram@optum.com","emailType":"EML"},"accountDetails":[{"Id":"NHw5MDQzMzE0MjZ8bnVsbHxPUFR8SFNBfG51bGx8bnVsbA==","accountId":"904331426","accountCode":"4","accountName":"Health Savings Account","accountType":"HSA","totalBalance":"15088","investedBalance":"0.00","availableBalance":"15088.0","employerGroup":{"employerGroupId":"RCTESTI","employerGroupName":"RAQUEL TEST8"}}]}}}';
            String respBody = response.getBody();
            oACETWSCalloutResult.statusCode = Response.getStatusCode();

            if (Response.getStatusCode() == 200){
                oACETWSCalloutResult.Success = true;
                oACETWSCalloutResult.Message = '';
                oACETWSCalloutResult.Response = parseSuccessAdapterResponse(respBody);
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
                }  
        }
        catch(Exception ex){
            system.debug(LoggingLevel.INFO, 'Exception in HSA Summary Response. Details: ' + ex.getStackTraceString()); 
            oACETWSCalloutResult.Success = false;
            oACETWSCalloutResult.Message = ex.getMessage();
            oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;
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