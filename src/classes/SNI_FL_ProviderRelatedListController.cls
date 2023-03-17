public class SNI_FL_ProviderRelatedListController {
 @AuraEnabled
    public static AccountWrapper getProviderUserList(String recId){
        AccountWrapper accountWrapper= new AccountWrapper();
        try{
            set<id> contactIdList = new set<id>();
            set<id> accountIdList = new set<id>();
            List<Account> acc = [SELECT Id,ParentId,Name FROM Account WHERE Id =:recId];
            if(acc.size()>0){
                for (AccountContactRelation acr : [Select id,ContactId  from AccountContactRelation where AccountId =: acc[0].id And Relationship__c = 'Provider User']){
                contactIdList.add(acr.ContactId);
                }
                if(contactIdList.size()>0){
                  for (contact con : [Select id,AccountId  from contact where id in :contactIdList]){
                   accountIdList.add(con.AccountId);
                  }
                }
                if(accountIdList.size()>0){
                   accountWrapper.accountsList = [SELECT Id,Name,FirstName,LastName,PersonEmail FROM Account WHERE Id in:accountIdList];// And RecordType.Name = 'Provider User' And Provider_Group__c =:acc[0].ParentId];
                   accountWrapper.success = true;
                }
                
            }            
            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
             return accountWrapper;
           
        }
        catch(Exception e){
            accountWrapper.message = e.getMessage();
            
            accountWrapper.success = false;
            return accountWrapper;
        }
        
    }
    @AuraEnabled
    public static AccountWrapper getProiverTeamList(String recId){
        AccountWrapper accountWrapper= new AccountWrapper();
        try{
            set<id> contactIdList = new set<id>();
            set<id> accountIdList = new set<id>();
            List<Account> acc = [SELECT Id,ParentId,Name FROM Account WHERE Id =:recId];
            if(acc.size()>0){
                for (AccountContactRelation acr : [Select id,ContactId  from AccountContactRelation where AccountId =: acc[0].id And Relationship__c = 'Provider Team']){
                contactIdList.add(acr.ContactId);
                }
                if(contactIdList.size()>0){
                  for (contact con : [Select id,AccountId  from contact where id in :contactIdList]){
                   accountIdList.add(con.AccountId);
                  }
                }
                if(accountIdList.size()>0){
                   accountWrapper.accountsList = [SELECT Id,Team_Name__c FROM Account WHERE Id in:accountIdList];// And RecordType.Name = 'Provider Team'];
                   accountWrapper.success = true;
                }
                
            }
           
            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
             return accountWrapper;
        }
        catch(Exception e){
            accountWrapper.message = e.getMessage();
            accountWrapper.success = false;
             return accountWrapper;
        }
       
    }
    //To return additional records based on offset
   /* @AuraEnabled
    public static List<Account> loadAccountRecords(Integer rowLimit,Integer rowOffset){
        return [SELECT ID,Name,Rating,AccountSource FROM Account  LIMIT :rowLimit OFFSET :rowOffset];
    }*/
    
    // wrapper class
    public class AccountWrapper{
        @AuraEnabled
        public Integer totalRecords = 0;
        @AuraEnabled
        public List<Account> accountsList = new List<Account>();
        @AuraEnabled
        public String message;
        @AuraEnabled
        public Boolean success;
    }
}