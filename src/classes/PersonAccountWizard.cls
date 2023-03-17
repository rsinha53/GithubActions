public class PersonAccountWizard {
    
    @AuraEnabled
    public static Map<String,String> getPicklist () {
        Map<String,String> options = new Map<String,String>();
        Schema.DescribeFieldResult fieldResult = AccountContactRelation.Relationship__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry f : ple){
            options.put(f.getValue(), f.getLabel());
        }
        return options;
    }
    
    @AuraEnabled
    public static String personAccountSave(String accData, string fname,String lname, String dbirth, String em, String mid, String pid){
        system.debug('check'+ accData);
        system.debug('firstame' +fname);
        //adding zeros to the memberID
        if (mid.length() < 11) {
            Integer zeroToAdd = 11 - mid.length();
            for (Integer i=0; i<zeroToAdd; i++) {
                mid = '0'+mid;
            }
        }
        //adding zeros to policy ID
        pid = PolicyNumberutil.validatePolicyNumber(pid);
        
        Id personAccountRecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Individual').getRecordTypeId();        
        List<Account> personAccounts = new  List<Account>();
        List<personWrapper> peronWrapperList =(List<personWrapper>)JSON.deserialize(accData, List<personWrapper>.class);
        //FamilyWrapper familyWrapper =(FamilyWrapper)JSON.deserialize(familyAccData,FamilyWrapper.class);
        system.debug(peronWrapperList);
        List<id> prsnLists = new List<id>();
        Set<String> unqPersons = new Set<String>();
        for(personWrapper pa : peronWrapperList){  
            if(String.isNotBlank(pa.firstname) && !unqPersons.contains(pa.firstname+pa.lastname+pa.DOB)){
                system.debug(pa);
                Account newPersonAccount = new Account();
                newPersonAccount.FirstName = pa.firstname;
                newPersonAccount.LastName = pa.lastname;
                newPersonAccount.PersonBirthdate = Date.valueOf(pa.DOB);
                newPersonAccount.Relationship__pc = pa.relationship; 
                newPersonAccount.RecordTypeId = personAccountRecordTypeId;
                newPersonAccount.Member_ID__c = mid;
                newPersonAccount.Policy_ID__c = pid; 
                personAccounts.add(newPersonAccount);
                unqPersons.add(pa.firstname+pa.lastname+pa.DOB);
            }
        }
        insert personAccounts;
        
        for(integer i=0; i<personAccounts.size();i++){
            prsnLists.add(personAccounts[i].id);
        }
        
        /*Account newPersonAccount = new Account();
newPersonAccount.FirstName = fname;
newPersonAccount.LastName = lname;
newPersonAccount.RecordTypeId = personAccountRecordTypeId;
newPersonAccount.Relationship__pc = 'Subscriber/Recipient';
newPersonAccount.PersonBirthdate = Date.valueOf(dbirth);
newPersonAccount.PersonEmail = em;
insert newPersonAccount;*/
        
        //prsnLists.add(newPersonAccount.id);
        System.debug('prsnLists'+prsnLists);
        Id familyAccountRecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Family').getRecordTypeId(); 
        Account acc = new Account();
        acc.Name = fname + ' ' +lname;
        // acc.PersonBirthdate = Date.valueOf(dbirth);
        acc.Member_ID__c = mid;
        acc.Policy_ID__c = pid; 
        acc.RecordTypeId= familyAccountRecordTypeId;
        acc.UHG_Restriction__c   = 'No';
        acc.Onshore_Restriction__c = 'No'; 
        system.debug('acc'+ acc);
        insert acc;
        
        
        List<AccountContactRelation> acrList = new List<AccountContactRelation>();
        List<Account> pcList = [SELECT id,personContactId from Account WHERE id=:prsnLists];
        for(integer i=0;i<personAccounts.size();i++){ 
            AccountContactRelation acr = new AccountContactRelation();
            acr.AccountId = acc.Id;
            if(pcList[i].PersonContactId!=null) {
                acr.ContactId = pcList[i].PersonContactId;    
            }
            acr.Member_ID__c = mid;
            acr.Policy_ID__c = pid;
            acr.Relationship__c = personAccounts[i].Relationship__pc;
            acrList.add(acr);
        }
        /*AccountContactRelation acr = new AccountContactRelation();
acr.AccountId = acc.Id;
acr.ContactId =  [SELECT id,personContactId from Account WHERE id=:personAccounts.id].PersonContactId;
acr.Relationship__c =personAccounts.Relationship__pc;
acrList.add(acr);*/
        System.debug('acr'+acrList);
        
        insert acrList;
        
        //inserting Family Overview
        Family_Overview__c famover = new Family_Overview__c(); // added by Ravi
        famover.Name = lname+' Family Overview';
        famover.Account__c = acc.id;
        famover.Exception__c = 'No';
        famover.Designation_Changed_Date__c = Date.today();
        famover.Last_Active_Date__c  = Date.today();
        famover.UHG_Restriction__c   = 'No';
        famover.Onshore_Restriction__c = 'No'; 
        famover.Manual_Referral__c = true;
        insert famover;
        system.debug('family overview--'+ famover);
        
        //Inserting Family Story Guide
        Family_Story_Guide__c fsg = new Family_Story_Guide__c();
        fsg.Account__c = acc.Id;
        fsg.Status__c = 'Not Offered';
        insert fsg;
        
        //Inserting member Information
        Map<Id,List<String>> polDetail = new Map<Id,List<String>>();
        ACETSNIMemberInformation.createMemberInformation(personAccounts, pid,'insert',polDetail,false);
        
        return acc.id;
    }
    public class PersonWrapper{
        @AuraEnabled public  String firstname;
        @AuraEnabled public  String lastname;
        @AuraEnabled public  String DOB;
        @AuraEnabled public  String relationship;
        
    }
    
    /* public class FamilyWrapper{
@AuraEnabled public  String firstName;
@AuraEnabled public  String lastName;
@AuraEnabled public  String dateOfBirth;
@AuraEnabled public  String email;
@AuraEnabled public  String memberId;
@AuraEnabled public  String policyId;

}*/
    
}