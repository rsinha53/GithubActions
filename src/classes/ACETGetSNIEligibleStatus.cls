public class ACETGetSNIEligibleStatus {

@AuraEnabled
  public static string FetchSniEligibleStatus(string pAccId){
      string errorMsg = '';
       if(pAccId != null && pAccId != ''){
           string conId = [select id, PersonContactId from Account where id =: pAccId].PersonContactId;
           list<AccountContactRelation> lstAccConRel = [select AccountId from AccountContactRelation where ContactId =: conId];  
            if(lstAccConRel != null && ! lstAccConRel.isEmpty()){
                list<Account> lstAcc =  [select id,Special_Needs_Status__c from Account where Id =: lstAccConRel[0].AccountId];    
                if(lstAcc!= null && ! lstAcc.isEmpty() && lstAcc[0].Special_Needs_Status__c == 'not eligible'){
                  // return true;
                  errorMsg = ACETUtility.getErrorMessage('SNIStatusChange');
                }
            }
        }
        return errorMsg;
    }
    
}