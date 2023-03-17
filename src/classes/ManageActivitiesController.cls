/*------------------------------------------------------------
Author:        Harshini Thotakura
Description:   Controller class for Aura Component Manage Activities 
History
Date           Author               Comments
-------------------------------------------------------------
28-11-2022     Harshini Thotakura   Created 
------------------------------------------------------------*/
public class ManageActivitiesController {
    
    @AuraEnabled 
    public static Object getAccountDetails(String acctId) {
        Map<String,String> resultMap = new Map<String,String>();
        try{
            Account acct = [SELECT Id, RecordType.Name FROM Account WHERE Id=:acctId];
            if(acct.RecordType.Name == 'Individual'){
                List<AccountContactRelation> acrList = [SELECT Id, Account.Member_Id__c FROM AccountContactRelation WHERE Contact.AccountId=:acctId];
                if(!acrList.isEmpty()){
                    resultMap.put('memberId', acrList[0].Account.Member_Id__c);
                }
            }
        }catch(exception ex){
            throw new AuraHandledException(ex.getMessage() + '\n' + ex.getStackTraceString());
        }
        return resultMap;
    }
    
}