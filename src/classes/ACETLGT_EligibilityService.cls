public class ACETLGT_EligibilityService extends ACETWebService{
    
    Public ACETLGT_EligibilityService(){
                if(!Test.isRunningTest()){
        super('Stargate');
        }   
    }
       public override void getEndpoint(){
        GetEndpointDetail('EligibilityService');
    }
     Public class Eligibilitywrap{
        @AuraEnabled
        Public string sniEligibility{get;set;}
        @AuraEnabled
        Public string serviceGroup{get;set;}
        @AuraEnabled
        Public string accountTypes{get;set;}
        @AuraEnabled
        Public String hassnipermission{get;set;}
    }
    public void getRequestBody(String memberId,String policyId,String firstName,String lastName,String dob){
        RequestBody = '{"memberId":"'+memberId.substring(0,9)+'00","policyId":"'+policyId+'","firstName":"'+firstName+'","lastName":"'+lastName+'","dob":"'+dob+'"}';         
    } 
    public ACETWSCalloutResult getEligibility(String memberId,String policyId,String firstName,String lastName,String dob){
        ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();
      
        try{
            getEndpoint();
            GetRequestBody(memberId, policyId,firstName,lastName,formatDate(dob));
            HttpResponse response = Send(OAuthConfig); 
            if(response!=null){                
                calloutResult.statusCode=response.getStatusCode();
                if(response.getStatusCode() == 200){
                    if(response.getBody() != null){
            List<PermissionSetAssignment> psas = [ select Id from PermissionSetAssignment where AssigneeId= :UserInfo.getUserId() and PermissionSet.Name = 'SNI_UI_Access'];

                        //replace date with date2 as date is a preserved keyword
                        String responseBody = response.getBody().contains('\"date\":')?response.getBody().replace('\"date\":', '\"date2\":'):response.getBody();
                        //replace desc with desc2 as desc is a preserved keyword
                        responseBody = response.getBody().contains('\"desc\":')?responseBody.replace('\"desc\":', '\"desc2\":'):response.getBody();
                        system.debug('responseBody-->'+responseBody);
                       Eligibilitywrap er = new Eligibilitywrap();
                        String sniEligibility ;
                        if(responseBody.contains('"localMarket":[],')){
                            responseBody = responseBody.replace('"localMarket":[],','');
                        }
                        ACETLGT_EligibilityServiceJSON2APEX  jSON2Apex = (ACETLGT_EligibilityServiceJSON2APEX)JSON.deserialize(responseBody, ACETLGT_EligibilityServiceJSON2APEX.class);
                        List<ACETLGT_EligibilityServiceJSON2APEX.data> lstdata = jSON2Apex!=null?jSON2Apex.result!=null?jSON2Apex.result.data:null:null;
                        for(ACETLGT_EligibilityServiceJSON2APEX.data data : lstdata){
                            er.sniEligibility =  data.sniEligibility;
                            er.serviceGroup = data.serviceGroup;
                            if(data.accountTypes != null){
                            er.accountTypes = string.join(data.accountTypes,',');
                            }
                            if(psas.size() > 0){
                            er.hassnipermission = 'true';   
                              }
                       }
                        calloutResult.Success = true;
                        calloutResult.Message = '';
                        calloutResult.Response = er;                      
                    }
                    
                }else{                
                    //currently servce returns 500 if no records found
                    //calloutResult.MessageSeverity = ApexPages.Severity.INFO;
                    calloutResult.Success = false;                
                    calloutResult.Response = new ACETLGT_MemberSearchCoveragesResult();
                    calloutResult.Message = ACETWebserviceHelper.getErrorMessageFromCode(response.getStatusCode());
                    system.debug(calloutResult);    
                }
            }
            else{//when response is null
                calloutResult.Success = false;
                calloutResult.Message = 'Web Service or External System is temporarily unavailable.';
                calloutResult.statusCode=999;
            }
        }catch(Exception e){
            system.debug(e.getStacktraceString());
            calloutResult.Success = false;
            calloutResult.Message = 'Web Service or External System is temporarily unavailable.';
            calloutResult.statusCode=999;
            
        }
        
        return calloutResult;    
    }
     public String formatDate(String dateString) {
    try {
      if (String.isBlank(dateString)) return null;
      List < String > dateParts = dateString.split('/');
      if (dateParts.size() == 3) {
        String mm = dateParts[0];
        String dd = dateParts[1];
        String yyyy = dateParts[2];
      
        mm = mm.contains('0') && mm.indexOf('0') == 0 ? mm.replace('0', '') : mm;
        dd = dd.contains('0') && dd.indexOf('0') == 0 ? dd.replace('0', '') : dd;
        
        return yyyy + '-' + mm + '-' + dd;
      } else {
        return dateString;
      }
    } catch(Exception e) {
      System.debug('Exception occured=' + e);
      return null;
    }
  }
}