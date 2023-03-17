public class CACHSIDmemSupport {
    
    @AuraEnabled
    public static Boolean HSIDmemUrls() {
            User u = [select Id , AccountId, profile.name from User where Id = :UserInfo.getUserId()];             
            Account acc = [Select ID, PersonContactID    from Account where ID= :u.AccountId];            
            List<AccountContactRelation> lsacr = [ SELECT Member_ID__c, account.alternate_id__c  FROM AccountContactRelation WHERE  ContactID  = :acc.PersonContactID];			
			Boolean isMember = false;
			if (!lsacr.isEmpty() && lsacr.size() > 0) {
                for(AccountContactRelation acr : lsacr) {
                    if (acr.Member_ID__c != null) {
                        isMember = true;
                    }                
                   
                }
            }
			return isMember;
    }
    
    @AuraEnabled
    public static Boolean getCustMetaData(){
        FeatureFlagConfig__mdt fetConf = [select Id,MasterLabel,isEnabled__c from FeatureFlagConfig__mdt where MasterLabel = 'OpenHSIDurls'];
        return fetConf.isEnabled__c;
    }

}