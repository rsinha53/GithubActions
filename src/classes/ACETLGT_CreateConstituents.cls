public class ACETLGT_CreateConstituents {
    public static Contact ACETContact;
    public static Map<Id, Case> OrphanCases;
    public static boolean EidStatus;
    public static String oldContactID;
    public static boolean srkStatus;
    public Contact Subject { 
        get { return ACETContact; } 
        set { ACETContact = value; } 
    }
	@AuraEnabled 
    public static Account createAccount(String FirstName,String LastName,String DOB,String EID,String SRKKeyChain){
        EID = String.isBlank(EID) ? EID : String.escapeSingleQuotes(EID); //US3636286 : Checkmarx Fix
        SRKKeyChain = String.isBlank(SRKKeyChain) ? SRKKeyChain : String.escapeSingleQuotes(SRKKeyChain); //US3636286 : Checkmarx Fix
        Id PersonAccrecTypeId = getPersonAccountRecordType();
        Account ACETAccount = new Account();
        system.debug('---EID-->'+ EID);
        system.debug('---SRKKeyChain-->'+ SRKKeyChain);
        List<Account> ACETAccountList = [SELECT id,Name,FirstName,LastName,SRK_KeyChain__c,SRK_KeyChain__pc,EID__c,EID__pc,PersonBirthdate,RecordTypeId FROM Account WHERE EID__c =: EID ];
        system.debug('---ACCOUNTLIST-->'+ ACETAccountList);
        if( ACETAccountList.isEmpty() && SRKKeyChain != null && SRKKeyChain != ''){
            Boolean accountfirst = true;
            String accountQuery = 'Select Id,Name,EID__c,SRK_KeyChain__c from Account';
            if(SRKKeyChain.indexOf(',') != -1){
                for(String sk : SRKKeyChain.split(',')){
                        if(!accountfirst){
                            accountQuery = accountQuery + ' OR';
                        } else {
                            accountQuery = accountQuery + ' WHERE';
                        }
                    accountQuery = accountQuery + ' Account.SRK_KeyChain__c LIKE \'%' + sk + '%\'';
                    accountQuery = accountQuery + ' or EID__c= \''+ EID+'\'';
                    accountfirst = false;
                }
            }else{
                accountQuery = accountQuery + ' WHERE Account.SRK_KeyChain__c LIKE \'%' + SRKKeyChain + '%\'';
                accountQuery = accountQuery + ' or EID__c= \''+ EID+'\'';
            }
            List<Account> ACETAccountListMatchingSRK = Database.query(accountQuery);
            if( ACETAccountListMatchingSRK.isEmpty()){
                ACETAccount = new Account( 
                    	//Name = FirstName + ' '+ LastName,
                        FirstName = FirstName,
                        LastName  = LastName,
                        SRK_KeyChain__c=SRKKeyChain,
                        SRK_KeyChain__pc=SRKKeyChain,
                        EID__c=EID,
                        EID__pc = EID,
                        PersonBirthdate = formatDatewithslash(DOB) != null ? Date.valueOf(formatDatewithslash(DOB)): null,
                        RecordTypeId = PersonAccrecTypeId
                        );
                if(ACETAccount != null && ACETAccount.Name != null && ACETAccount.EID__c != null){
                    Database.upsert(ACETAccount, Account.Fields.EID__c);
                    ACETAccount.FirstName = FirstName;
                    ACETAccount.LastName  = LastName;
                    ACETAccount.SRK_KeyChain__pc=SRKKeyChain;
                    ACETAccount.PersonBirthdate = formatDatewithslash(DOB) != null ? Date.valueOf(formatDatewithslash(DOB)): null;
                    ACETAccount.RecordTypeId = PersonAccrecTypeId;
                    Update ACETAccount;
                }
                    
            }else{
               ACETAccount = new Account(//id= ACETAccountListMatchingSRK.get(0).id,
                                     	FirstName = FirstName,
                                        LastName  = LastName,
                                        //Name = FirstName + ' '+ LastName,
                                        SRK_KeyChain__c=SRKKeyChain,
                                        SRK_KeyChain__pc=SRKKeyChain,
                                        EID__c=EID,
                                        EID__pc = EID,
                                        PersonBirthdate = formatDatewithslash(DOB) != null ? Date.valueOf(formatDatewithslash(DOB)): null,
                                      	RecordTypeId = PersonAccrecTypeId
                                     );
                if(ACETAccount != null && ACETAccount.LastName != null && ACETAccount.EID__c != null){
                    Database.upsert(ACETAccount, Account.Fields.EID__c);
                    ACETAccount.FirstName = FirstName;
                    ACETAccount.LastName  = LastName;
                    ACETAccount.SRK_KeyChain__pc=SRKKeyChain;
                    ACETAccount.PersonBirthdate = formatDatewithslash(DOB) != null ? Date.valueOf(formatDatewithslash(DOB)): null;
                    ACETAccount.RecordTypeId = PersonAccrecTypeId;
                    Update ACETAccount;
                }
                    
            }
        }else if(ACETAccountList != null && !ACETAccountList.isEmpty() ){
            ACETAccount.Id = ACETAccountList.get(0).Id;
            //ACETAccount.Name = FirstName + ' '+ LastName;
            //ACETAccount.FirstName = FirstName;
            //ACETAccount.LastName  = LastName;
            //Name = FirstName + ' '+ LastName,
            if(SRKKeyChain != null && SRKKeyChain != '')
            	ACETAccount.SRK_KeyChain__c=SRKKeyChain;
            //ACETAccount.SRK_KeyChain__pc=SRKKeyChain;
            ACETAccount.EID__c=EID;
            //ACETAccount.EID__pc = EID;
            //ACETAccount.PersonBirthdate = formatDatewithslash(DOB) != null ? Date.valueOf(formatDatewithslash(DOB)): null;           	
            if(ACETAccount != null && ACETAccount.EID__c != null){
                Database.upsert(ACETAccount, Account.Fields.EID__c);  
                Account ACETContact = getPersonAccounts(ACETAccount.EID__c);
                if(ACETContact != null){
                    ACETContact.FirstName = FirstName;
                    ACETContact.LastName  = LastName;
                    if(SRKKeyChain != null && SRKKeyChain != '')
                    	ACETContact.SRK_KeyChain__pc=SRKKeyChain;
                    ACETContact.EID__pc = EID;
                    //ACETContact.EID__c = EID;
                    ACETContact.PersonBirthdate = formatDatewithslash(DOB) != null ? Date.valueOf(formatDatewithslash(DOB)): null;
                    ACETContact.RecordTypeId = PersonAccrecTypeId;
                    if(ACETContact != null && ACETContact.LastName != null && ACETContact.EID__pc != null){
                        Database.update(ACETContact) ;
                    }
                }
                    
            }
            
        }else{
            
            ACETAccount = new Account(
                                     	FirstName = FirstName,
                                        LastName  = LastName,
                                        //Name = FirstName + ' '+ LastName,
                                        SRK_KeyChain__c=SRKKeyChain,
                                        SRK_KeyChain__pc=SRKKeyChain,
                                        EID__c=EID,
                                        EID__pc = EID,
                                        PersonBirthdate = formatDatewithslash(DOB) != null ? Date.valueOf(formatDatewithslash(DOB)): null,
                                      	RecordTypeId = PersonAccrecTypeId
                                     );
            if(ACETAccount != null && ACETAccount.LastName != null && ACETAccount.EID__c != null){
            	Database.upsert(ACETAccount, Account.Fields.EID__c);
            }
            
        }
        return ACETAccount;
    }
    public static String formatDatewithslash(String dateString) {
        if (String.isBlank(dateString)) {
            return null;
        }
        
        List<String> dateParts = dateString.split('/');
        if (dateParts.size() == 3)  {
            String mm = dateParts[0];
            String dd = dateParts[1];
            String yyyy = dateParts[2]; 
            
            mm = mm.contains('0') && mm.indexOf('0') == 0 ? mm.replace('0','0') : mm ; 
            dd = dd.contains('0') && dd.indexOf('0') == 0 ? dd.replace('0','0') : dd; 
            
            return  yyyy +'-'+mm +'-' +dd;
        } else  { 
            return dateString;
        }
    }
    @AuraEnabled 
    public static Contact getContacts(string AccId){
        List<Contact> ACETContactList = [SELECT FirstName,LastName,id FROM Contact WHERE AccountId =:AccId ];
        if(ACETContactList != null && ACETContactList.size() > 0)
        	return ACETContactList.get(0);
        else
            return null;
    }
    @AuraEnabled 
    public static Account getPersonAccounts(string eid){
        List<Account> ACETPAList = [SELECT FirstName,LastName,id,EID__c FROM Account WHERE EID__pc =: eid ];
        if(ACETPAList != null && ACETPAList.size() > 0)
        	return ACETPAList.get(0);
        else
            return null;
    }
    public static Id getPersonAccountRecordType(){
    
        RecordType personAccRecordType =  [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        return personAccRecordType.Id;
    }
    
    @AuraEnabled
    public static Map<String, List<Case>> MergeNSplitCases(String FirstName,String LastName,String DOB,String EID,List<String> SRKKeyChain) {
        EID = String.isBlank(EID) ? EID : String.escapeSingleQuotes(EID); //US3636286 : Checkmarx Fix
        Contact ACETContact;
        Boolean EidStatus;
        Boolean srkStatus;
        Id oldContactID;
        Map<String, List<Case>> ACETSRKCaseMap = MatchMDMnACETSurrogateKeys( FirstName, LastName, DOB, EID, SRKKeyChain);
        
        //Create or Update Account
        String AccountName = String.isBlank(FirstName) ? LastName : FirstName + ' ' + LastName;
        
        if(String.isBlank(AccountName))
            AccountName = String.isBlank(FirstName) ? LastName : FirstName + ' ' + LastName;
        List<Account> accList = [select Id,Name,EID__c,SRK_KeyChain__c  from Account where Id =: ACETContact.AccountId];
        Account ACETAccount;
        if(accList.size() > 0){
            ACETAccount = accList.get(0);
            ACETAccount.Id = accList.get(0).Id;
            ACETAccount.name = AccountName;
            ACETAccount.SRK_KeyChain__c=ACETContact.SRK_KeyChain__c;
            ACETAccount.EID__c=ACETContact.EID__c;
            System.debug('It came here for old account@@@='+ACETAccount);
            Database.upsert(ACETAccount, Account.Fields.EID__c); 
        } 
        else{
            
            Boolean accountfirst = true;
            String accountQuery = 'Select Id,Name,EID__c,SRK_KeyChain__c from Account';
            for(String sk : SRKKeyChain){
                if(!accountfirst){
                    accountQuery = accountQuery + ' OR';
                } else {
                    accountQuery = accountQuery + ' WHERE';
                }
            sk = String.isBlank(sk) ? sk : String.escapeSingleQuotes(sk); //US3636286 : Checkmarx Fix
            accountQuery = accountQuery + ' Account.SRK_KeyChain__c LIKE \'%' + sk + '%\'';
            accountQuery = accountQuery + ' or EID__c= \''+ EId+'\'';
            accountfirst = false;
          }
            System.debug('accountQuery='+accountQuery);
            
            List<Account> acetACCs=Database.query(accountQuery);
            //String keychainLike='%'+ ACETContact.SRK_KeyChain__c+'%';
            //List<Account> acetACCs=[Select Id,Name,EID__c,SRK_KeyChain__c from Account where SRK_KeyChain__c like :keychainLike or EID__c=:MDMMember.EId] ;
            if(acetACCs!=null && acetACCs.size()>0){
                 ACETAccount=acetACCs.get(0);
                 ACETAccount.Name=AccountName;
                 ACETAccount.EID__c=ACETContact.EID__c;
                 ACETAccount.SRK_KeyChain__c=ACETContact.SRK_KeyChain__c;
                 System.debug('It came here for old account***='+ACETAccount);
                 Database.update(ACETAccount, Account.Fields.EID__c);//Database.update(ACETAccount);
               }
            else{
            ACETAccount = new Account(Id=ACETContact.AccountId, Name = AccountName,EID__c = ACETContact.EID__c,
                                      SRK_KeyChain__c=ACETContact.SRK_KeyChain__c);
            Database.upsert(ACETAccount, Account.Fields.EID__c);
            }

        }
        
        system.debug('---------ACETContact----->'+ACETContact.Birthdate);
        //Create or Update Contact
        ACETContact.AccountId = ACETAccount.Id;  
        //upsert ACETContact;
        if(EidStatus || srkStatus){
            Database.upsert(ACETContact,Contact.Fields.EID__c);//Database.upsert(ACETContact,Contact.Fields.SRK_KeyChain__c);
        }
        //Orphan cases
        //update OrphanCases.values();//orphaning the cases whose surrogate key not coming
        if(oldContactID!=null){
            List<Interaction__c> intList=new list<Interaction__c>();
            for(Interaction__c intec :[SELECT Id,Originator__c from Interaction__c where Originator__c=:oldContactID]){
                intec.Originator__c=ACETContact.id;
                intList.add(intec);
            }
            if(intList!=null && intList.size()>0){
                update intList;
        	}
             //delOldContact();//Commented as getting error.
             
        }
        
        
        /*if(oldContactID!=null){
            System.debug('oldContactID='+oldContactID);
            delOldContact();
        }*/
        return ACETSRKCaseMap;
    } 
    //Find Surrogate Keys which are present in both in OIL Response and ACET
    private static Map<String, List<Case>> GetACETSurrogateKeys(Set<String> SurrogateKeys, Map<Id, Contact> ACETContacts) {
        Map<String, List<Case>> ACETSRKCaseMap = new Map<String, List<Case>>();
        List<Case> listCaseToAdd = new List<Case>();

        //Find out Contacts and Surrogate Keys from Salesforce using Surrogate Keys in response
        for(Case oCase :[SELECT Id, CaseNumber, Interaction__c, Surrogate_Key__c,ContactID, Contact.Id, Contact.FirstName, Contact.LastName, 
                Contact.AccountId, Contact.LastModifiedDate,Contact.SRK_KeyChain__c,Contact.EID__c FROM Case WHERE Surrogate_Key__c IN :SurrogateKeys
                ORDER BY Contact.LastModifiedDate DESC, Surrogate_Key__c]) {
            system.debug(LoggingLevel.INFO, 'oCase: ' + oCase);
            
            if (!String.isBlank(oCase.Contact.Id)) {
                if (!ACETContacts.containsKey(oCase.Contact.Id)) {
                    ACETContacts.put(oCase.Contact.Id, 
                        new Contact(Id=oCase.Contact.Id, FirstName=oCase.Contact.FirstName, LastName=oCase.Contact.LastName, 
                            AccountId=oCase.Contact.AccountId,SRK_KeyChain__c=oCase.Contact.SRK_KeyChain__c,EID__c=oCase.Contact.EID__c));
                }
            }
            listCaseToAdd.add(oCase);
            ACETSRKCaseMap.put(oCase.Surrogate_Key__c, listCaseToAdd);
        }
        system.debug(LoggingLevel.INFO, 'ACETContacts: ' + ACETContacts);
        system.debug(LoggingLevel.INFO, 'ACETSRKCaseMap: ' + ACETSRKCaseMap);
        
        return ACETSRKCaseMap;    
    }
    
    //Find Surrogate Keys which are in ACET but not in response using Contact related to Surrogate keys
    private static Map<String, List<Case>> GetACETSurrogateKeysNotInResponse(Set<String> SurrogateKeys, Map<Id, Contact> ACETContacts) {
        Map<String, List<Case>> ACETSRKsNotInResponse = new Map<String, List<Case>>();
        
        List<Case> listCaseToAdd = new List<Case>();
        //Find Surrogate Keys which are in ACET but not in response using Contact related to Surrogate keys
        for(Case oCase :[SELECT Id, CaseNumber, Interaction__c, Surrogate_Key__c, ContactID,Contact.Id, Contact.FirstName, Contact.LastName, 
            Contact.AccountId,Contact.SRK_KeyChain__c,Contact.EID__c  FROM Case WHERE ContactID IN :ACETContacts.keySet()]) {
            system.debug(LoggingLevel.INFO, 'oCase: ' + oCase); 
            if (!SurrogateKeys.contains(oCase.Surrogate_Key__c)) {
                listCaseToAdd.add(oCase);
                ACETSRKsNotInResponse.put(oCase.Surrogate_Key__c, listCaseToAdd);
            }    
        }
        system.debug(LoggingLevel.INFO, 'ACET SRK Not In Response: ' + ACETSRKsNotInResponse);
        return ACETSRKsNotInResponse;    
    }
    
    public static Map<String, List<Case>> MatchMDMnACETSurrogateKeys(String FirstName,String LastName,String DOB,String EID,List<String> SRKKeyChain) {
        Set<String> SurrogateKeyschain = new Set<String>();
        //system.debug(LoggingLevel.INFO, 'MDMMember: ' + MDMMember);
        Map<Id, Contact> ACETContacts = new Map<Id, Contact>();
        Map<String, List<Case>> ACETSRKCaseMap = GetACETSurrogateKeys(SurrogateKeyschain, ACETContacts);
        
        Boolean contactfirst = true;
        String contactQuery = 'Select id,FirstName,LastName,AccountId,LastModifiedDate,SRK_KeyChain__c,EID__c from Contact ';
        for(String sk : SRKKeyChain){
             if(!contactfirst){
                    contactQuery = contactQuery + ' OR';
             } else {
                    contactQuery = contactQuery + ' WHERE';
             }
             sk = String.isBlank(sk) ? sk : String.escapeSingleQuotes(sk); //US3636286 : Checkmarx Fix
             contactQuery = contactQuery + ' Contact.SRK_KeyChain__c LIKE \'%' + sk + '%\'';
             contactfirst = false;
        }
        System.debug('ContactQuery='+contactQuery);
        
        if (ACETContacts.size() == 0) {//if contacts related to cases for surroage keys in response are not there
            //or in othere words No Member found in ACET for surroage keys in response
             //Getting contacts for the existing Surrogate key
            //System.debug('New ACET Contact@@@: ' + ACETContact);
            System.debug('Cases are not there for MDMMember.SurrogateKeys******='+SRKKeyChain);
                      
            
            
            List<Contact> checkContacts=Database.query(contactQuery);
            //String k
            //String srkKeyChainLike = '%'+getSrkChain(MDMMember)+'%';
            //List<Contact> checkContacts = new List<Contact>([Select id,FirstName,LastName,AccountId,LastModifiedDate,SRK_KeyChain__c,EID__c 
             //                                                from Contact  WHERE SRK_KeyChain__c like :srkKeyChainLike]);
            System.debug('checkContacts='+checkContacts);
            //List<Contact> checkContacts=[Select id from Contact where SRK_KeyChain__c like ('%' + MDMMember.SurrogateKeys + '%')];
            if(checkContacts!=null && checkContacts.size()>0){
                ACETContact = GetConstitentContact(FirstName, LastName, DOB, EID, SRKKeyChain,checkContacts[0]);
                ACETContacts.put(ACETContact.id,ACETContact);
            }
            else{
                ACETContact = GetConstitentContact(FirstName, LastName, DOB, EID, SRKKeyChain);
            }
            system.debug(LoggingLevel.INFO, 'New ACET Contact: ' + ACETContact);
        } 
        else {
                       
            //Find contact to be created or updated
            if (ACETContacts.values().get(0) == null) {
               //String srkKeyChainLike = '%'+getSrkChain(MDMMember)+'%';
                System.debug('Creating new contact as contact relared to case is null****:'+ACETContact);
                //List<Contact> checkContacts = new List<Contact>([Select id,FirstName,LastName,AccountId,LastModifiedDate,SRK_KeyChain__c,EID__c 
                //                                             from Contact  WHERE SRK_KeyChain__c like :srkKeyChainLike]);
                List<Contact> checkContacts=Database.query(contactQuery);
                if(checkContacts!=null && checkContacts.size()>0){
                ACETContact = GetConstitentContact(FirstName, LastName, DOB, EID, SRKKeyChain,checkContacts[0]);
                }
                else{
                ACETContact = GetConstitentContact(FirstName, LastName, DOB, EID, SRKKeyChain);
                }
            }
            else {
                ACETContact = GetConstitentContact(FirstName, LastName, DOB, EID, SRKKeyChain, ACETContacts.values().get(0));
            }
            system.debug(LoggingLevel.INFO, 'Update ACET Contact: ' + ACETContact);
        }
        //Find Surrogate Keys which are in ACET but not in response using Contact related to Surrogate keys
            system.debug(LoggingLevel.INFO, 'Going to orphaning the case having contacts:' + ACETContacts.size());
            Map<String, List<Case>> ACETSRKNotInResponse = GetACETSurrogateKeysNotInResponse(SurrogateKeyschain, ACETContacts);
            System.debug('ACETSRKNotInResponse='+ACETSRKNotInResponse.size());
            //Get cases to be orphanded which are associated to surrogate keys which are in ACET but not in response
            if (ACETSRKNotInResponse.size() > 0) {
                for(String str: ACETSRKNotInResponse.KeySet()){
                    for (Case OrphanCase : ACETSRKNotInResponse.get(str)) {
                        OrphanCase.ContactId = null;
                        OrphanCase.AccountId = null;
                        OrphanCase.Last_Orphaned__c = System.now();
                        OrphanCases.put(OrphanCase.Id, OrphanCase);
                    }
                }
            }
        
        return ACETSRKCaseMap;
    }
    public static Contact GetConstitentContact(String FirstName,String LastName,String DOB,String EID,List<String> SRKKeyChain) {
        System.debug('It came here to create new contact###');
        List<Contact> checkEidContacts= new List<Contact>();
        Contact ACETMember = new Contact();
        System.debug('MDMMember.EId='+EId);
        checkEidContacts=[Select id,AccountId from Contact where EID__c=:EId];//Checking if that eid is present in any old contact
        System.debug('checkEidContacts='+checkEidContacts);
        if(checkEidContacts!=null && checkEidContacts.size()>0){
         ACETMember= checkEidContacts.get(0);  
         EidStatus=true;//Existing Contact is there for this EID
        }
        ACETMember.FirstName = FirstName;
        ACETMember.LastName = LastName;
        //ACETMember.FirstName = MDMMember.FirstName + ' ' + MDMMember.middleInitial;
        //ACETMember.LastName = MDMMember.LastName + ' ' + MDMMember.suffix;
        ACETMember.Birthdate = Date.valueOf(DOB);
        ACETMember.EID__c = EId;
        //ACETMember.Phone = MDMMember.Phone;
        ACETMember.SRK_KeyChain__c=getSrkChain(FirstName, LastName, DOB, EID, SRKKeyChain); 
        return ACETMember;
    }
    Public static String getSrkChain(String FirstName,String LastName,String DOB,String EID,List<String> SurrogateKeys){
       String srkKeyChain='';
        if(SurrogateKeys!=null && SurrogateKeys.size()>0){
            List<String> SurrogateKeyList=new List<String>();
            
            SurrogateKeyList.addAll(SurrogateKeys);
            SurrogateKeyList.sort();
            for(String srk:SurrogateKeyList){
                srkKeyChain=srkKeyChain+','+srk;
            }
             srkKeyChain=srkKeyChain.substring(1);
        }
        System.debug('srkKeyChain='+srkKeyChain);
        return srkKeyChain;
    }
    //Update Contact
    private static Contact GetConstitentContact(String FirstName,String LastName,String DOB,String EID,List<String> surrogatekeys, Contact ACETMember) {
      //String oldSrk;
        System.debug('It came here with the old contact'+ACETMember);
        String srkKeyChain= '';//getSrkChain(MDMMember);
        EidStatus=true;//By Default i am making eid status =true
        srkStatus=false;//By Default i am making srk status =false
        
        //String accountid=ACETMember.accountId;
        System.debug('EID FROM Existing contact='+ACETMember.EID__c);
        System.debug('EID From service='+EId);
        if(ACETMember.EID__c!=EId){
            EidStatus=false; //if it is not equal then i am making eid status =false
            System.debug('Surrogate key from Existing contact='+ACETMember.SRK_KeyChain__c);
            System.debug('Surrogate key from oil service='+srkKeyChain);
            /*if(ACETMember.SRK_KeyChain__c.contains(srkKeyChain) || srkKeyChain.contains(ACETMember.SRK_KeyChain__c)){
              oldSrk=ACETMember.SRK_KeyChain__c;
              
             }*/
            for(String sk:surrogatekeys){
                if(ACETMember != null && ACETMember.SRK_KeyChain__c != null && ACETMember.SRK_KeyChain__c != '' && ACETMember.SRK_KeyChain__c.contains(sk)){
                    srkStatus=true;
                    break;
                }
                    
            }
            if(!srkStatus){
              oldContactID=ACETMember.id;
              ACETMember=new Contact();
            }
        }

        //ACETMember.accountId=accountid;//As we are updating to same account
        ACETMember.FirstName = FirstName; // + ' ' + MDMMember.middleInitial
        ACETMember.LastName = LastName ;// + ' ' + MDMMember.suffix
        ACETMember.Birthdate = Date.valueOf(DOB);
        ACETMember.EID__c = EId;
        
        ACETMember.SRK_KeyChain__c=SRKKeyChain;
        return ACETMember;
    }
    
    public List<Case> ReparentCases(Id InteractionId, Map<String, List<Case>> ACETSRKCaseMap) {
        //Reparent cases
        Map<Id, Case> mapReparentCases = new Map<Id, Case>();
        for(String str: ACETSRKCaseMap.KeySet()){
            for (Case ReparentCase : ACETSRKCaseMap.get(str)) {
                if(String.isBlank(ReparentCase.ContactId)){
                    ReparentCase.Interaction__c = InteractionId; 
                }
                if(ReparentCase.ContactId != ACETContact.Id){
                    ReparentCase.ContactId = ACETContact.Id;
                    ReparentCase.AccountId = ACETContact.AccountId;    
                    ReparentCase.Last_Re_Parented__c = System.now();        
                    mapReparentCases.put(ReparentCase.Id, ReparentCase);
                }
            } 
        }
        if(mapReparentCases.values() != null && mapReparentCases.values().size() > 0)
            update mapReparentCases.values();  
        return mapReparentCases.values();
    }
}