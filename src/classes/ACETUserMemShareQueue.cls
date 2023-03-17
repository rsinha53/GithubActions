public class ACETUserMemShareQueue implements Queueable {
    set<id> contactIds = new set<id>();
    set<id> provAffset = new set<id>();
    set<id> userIdset = new set<id>();
    map<Id,Id> contactusrIDs = new map<Id,Id>();
    map<Id,list<Id>> acrMap = new map<Id,list<Id>>();
    Id recordIDpa = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Provider Affiliation').getRecordTypeId(); 
    list<Member_Affiliation__Share>memaffshr = new list<Member_Affiliation__Share>();
    public ACETUserMemShareQueue(map<Id,Id> contactusrIDs, set<id> contactIds, set<id> userIdset) {
        this.contactusrIDs = contactusrIDs;
        this.contactIds = contactIds;
        this.userIdset = userIdset;
    }
    public void execute(System.QueueableContext qc) {
        for (AccountContactRelation ProvideraffACR : [Select id,AccountId,Account.RecordTypeId,ContactId,Relationship__c  from AccountContactRelation where ContactId in :contactIds and Relationship__c ='Provider User']){
            if(ProvideraffACR.Account.RecordTypeId ==recordIDpa){
                if(acrMap.size() > 0 && acrMap.containskey(ProvideraffACR.AccountId)){ 
                    list<Id> acrtemp = acrMap.get(ProvideraffACR.AccountId);
                    acrtemp.add(ProvideraffACR.contactId);
                    acrMap.put(ProvideraffACR.AccountId, acrtemp);
                }else{
                    list<Id> acrtempadd = new list<Id>();
                    acrtempadd.add(ProvideraffACR.contactId);
                    acrMap.put(ProvideraffACR.AccountId, acrtempadd);
                }
                provAffset.add(ProvideraffACR.AccountId);
            }
        } 
        if(provAffset.size()>0){    
            for(Member_Affiliation__c memA:[select Id, Name, Provider_Affiliation__c from Member_Affiliation__c where Provider_Affiliation__c in :provAffset]){
                if(acrMap.containskey(memA.Provider_Affiliation__c)){
                    for(Id contactide :acrMap.get(memA.Provider_Affiliation__c)){
                        Member_Affiliation__Share ms = new Member_Affiliation__Share();
                        ms.ParentId = memA.Id;
                        ms.UserOrGroupId = contactusrIDs.get(contactide);
                        ms.AccessLevel = 'Read';
                        ms.RowCause = Schema.Member_Affiliation__Share.RowCause.Manual;
                        memaffshr.add(ms);
                    }
                }
            }
            if(memaffshr.size()>0){
                insert memaffshr;
            }
        }
    }
}