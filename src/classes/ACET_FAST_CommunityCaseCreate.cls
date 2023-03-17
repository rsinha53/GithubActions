public without sharing  class ACET_FAST_CommunityCaseCreate {
    
    @AuraEnabled
    public static String recordSave(case caseVal, PIR_Detail__c pirVal, string providerName){
        string recId;
 
        QueueSObject queueID = [Select Queue.Id, Queue.Name, Queue.Type from QueueSObject WHERE Queue.Type ='Queue' AND Queue.Name ='PIR Community Intake' Limit 1];
        caseVal.OwnerId = queueID.Queue.Id;

        system.debug('providerName--'+providerName);
        System.debug('check line of business'+pirVal.Line_of_Business__c);
        try{
            Id accId =ACET_FAST_CommunityCaseCreate.getAccountId(providerName,caseVal.PC_Provider_TIN__c)<>null?ACET_FAST_CommunityCaseCreate.getAccountId(providerName,caseVal.PC_Provider_TIN__c):null;
            if(accId<>null){
                caseVal.AccountId=accId;
            }
            Insert caseVal;
            recId = caseVal.Id;
            Case caseRec = [select id, CaseNumber from case where id = : caseVal.Id];
            System.debug('Case Number-->'+ caseRec.CaseNumber);
            pirVal.Case__c =recId;
            Insert pirVal; 
            return caseRec.CaseNumber;
        
        }catch(Exception ex)
        {
             throw new AuraHandledException(' Something went wrong: '+ ex.getMessage()); 
        }
    }
    
    Public static Id getAccountId(String providerName,string taxId){
        
        string recordTypeID = ACET_Fast_ProviderContactCtrl.getRecordTypeIdbyDevName('Account','PersonAccount');  
        map<string, account> uniquenameAccountMap = new map<string, account>();
        
        for(Account acc : [SELECT id,Tax_Id__c,RecordTypeId,FirstName,LastName,EID__c FROM Account WHERE RecordTypeId =: recordTypeID AND EID__c LIKE :'%' + taxId LIMIT 1000]){
            uniquenameAccountMap.put((acc.LastName + '-' + acc.Tax_Id__c),acc);
        }
        
        string providerVal = providerName+ '-' + taxId;
        system.debug('providerVal -> ' + providerVal);
        if(!uniquenameAccountMap.containsKey(providerVal)){
            Account accountRec=new Account();
            accountRec.RecordTypeId = recordTypeID;
            accountRec.LastName = providerName;
            accountRec.Tax_Id__c = taxId;
            
            return null;
        } else {
            return uniquenameAccountMap.get(providerVal).Id;
        }
    }
    
    
    
}