public without sharing class ACETConstituent {
    protected Contact ACETContact;
    protected Map<Id, Case> OrphanCases;
    private boolean EidStatus;
    private String oldContactID;
    private boolean srkStatus;
    private Id PersonAccrecTypeId; 
    public boolean  srkerrormessage {get;set;}
    public Contact Subject { 
        get { return ACETContact; } 
        set { ACETContact = value; } 
    }
    
    public ACETConstituent() {
        OrphanCases = new Map<Id, Case>();
        EidStatus=false;
        srkStatus=false;
        PersonAccrecTypeId= ACETMemberQueryUtil.getPersonAccountRecordType();
    }    
    
    //Find Surrogate Keys which are present in both in OIL Response and ACET
    private Map<String, List<Case>> GetACETSurrogateKeys(ACETOILIndividual MDMMember, Map<Id, Contact> ACETContacts) {
        system.debug('surrogatekeys::' + MDMMember);
        Map<String, List<Case>> ACETSRKCaseMap = new Map<String, List<Case>>();
        List<Case> listCaseToAdd = new List<Case>();

        //Find out Contacts and Surrogate Keys from Salesforce using Surrogate Keys in response
        for(Case oCase :[SELECT Id, CaseNumber,RecordType.Name,Case_Type__c, Interaction__c, Surrogate_Key__c,ContactID, Contact.Id, Contact.FirstName, Contact.LastName, 
                Contact.AccountId, Contact.LastModifiedDate,Contact.SRK_KeyChain__c,Contact.EID__c FROM Case WHERE Surrogate_Key__c IN :MDMMember.SurrogateKeys
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
        system.debug(LoggingLevel.INFO, 'ACETSRKCaseMap : ' + ACETSRKCaseMap);
        
        return ACETSRKCaseMap;    
    }
    
    //Find Surrogate Keys which are in ACET but not in response using Contact related to Surrogate keys
    private Map<String, List<Case>> GetACETSurrogateKeysNotInResponse(ACETOILIndividual MDMMember, Map<Id, Contact> ACETContacts) {
        Map<String, List<Case>> ACETSRKsNotInResponse = new Map<String, List<Case>>();
        
        List<Case> listCaseToAdd = new List<Case>();
        //Find Surrogate Keys which are in ACET but not in response using Contact related to Surrogate keys
        for(Case oCase :[SELECT Id, CaseNumber, Interaction__c,RecordType.Name,Case_Type__c, Surrogate_Key__c, ContactID,Contact.Id, Contact.FirstName, Contact.LastName, 
            Contact.AccountId,Contact.SRK_KeyChain__c,Contact.EID__c  FROM Case WHERE ContactID IN :ACETContacts.keySet()]) {
            system.debug(LoggingLevel.INFO, 'oCase: ' + oCase); 
            if (!MDMMember.SurrogateKeys.contains(oCase.Surrogate_Key__c)) {
                listCaseToAdd.add(oCase);
                ACETSRKsNotInResponse.put(oCase.Surrogate_Key__c, listCaseToAdd);
            }    
        }
        system.debug(LoggingLevel.INFO, 'ACET SRK Not In Response: ' + ACETSRKsNotInResponse);
        return ACETSRKsNotInResponse;    
    }
    
    public Map<String, List<Case>> MatchMDMnACETSurrogateKeys(ACETOILIndividual MDMMember) {
        system.debug(LoggingLevel.INFO, 'MDMMember: ' + MDMMember);
        Map<Id, Contact> ACETContacts = new Map<Id, Contact>();
        Map<String, List<Case>> ACETSRKCaseMap = GetACETSurrogateKeys(MDMMember, ACETContacts);
        
        Boolean contactfirst = true;
        String contactQuery = 'Select id,FirstName,LastName,AccountId,LastModifiedDate,SRK_KeyChain__c,EID__c from Contact ';
            for(String sk : MDMMember.SurrogateKeys){
                  if(!contactfirst){
                    if(sk != null && sk != ''){
                    system.debug('------SK----->'+ sk);
                   contactQuery = contactQuery + ' OR';
                     contactQuery = contactQuery + ' Contact.SRK_KeyChain__c =\''+ String.valueOf(sk)+'\'';

             }

                  } else {
                if(sk != null && sk != ''){
                    system.debug('------SK----->'+ sk);
                    contactQuery = contactQuery + ' WHERE';
                     contactQuery = contactQuery + ' Contact.SRK_KeyChain__c =\''+ String.valueOf(sk)+'\'';
                                                                      contactfirst = false;

                 }
                   }
                  //          contactfirst = false;

         
        }
       ContactQuery = ContactQuery + ' LIMIT 50';

        System.debug('ContactQuery='+contactQuery);
        
        if (ACETContacts.size() == 0) {//if contacts related to cases for surroage keys in response are not there
            //or in othere words No Member found in ACET for surroage keys in response
             //Getting contacts for the existing Surrogate key
            System.debug('New ACET Contact@@@: ' + ACETContact);
            System.debug('Cases are not there for MDMMember.SurrogateKeys******='+MDMMember.SurrogateKeys);
                      
            
            
            List<Contact> checkContacts=Database.query(contactQuery);
            //String k
            //String srkKeyChainLike = '%'+getSrkChain(MDMMember)+'%';
            //List<Contact> checkContacts = new List<Contact>([Select id,FirstName,LastName,AccountId,LastModifiedDate,SRK_KeyChain__c,EID__c 
             //                                                from Contact  WHERE SRK_KeyChain__c like :srkKeyChainLike]);
            System.debug('checkContacts='+checkContacts);
            //List<Contact> checkContacts=[Select id from Contact where SRK_KeyChain__c like ('%' + MDMMember.SurrogateKeys + '%')];
            if(checkContacts!=null && checkContacts.size()>0){
                ACETContact = GetConstitentContact(MDMMember,checkContacts[0]);
                ACETContacts.put(ACETContact.id,ACETContact);
            }
            else{
                ACETContact = GetConstitentContact(MDMMember);
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
                ACETContact = GetConstitentContact(MDMMember,checkContacts[0]);
                }
                else{
                ACETContact = GetConstitentContact(MDMMember);
                }
            }
            else {
                ACETContact = GetConstitentContact(MDMMember, ACETContacts.values().get(0));
            }
            system.debug(LoggingLevel.INFO, 'Update ACET Contact: ' + ACETContact);
        }
        //Find Surrogate Keys which are in ACET but not in response using Contact related to Surrogate keys
            system.debug(LoggingLevel.INFO, 'Going to orphaning the case having contacts:' + ACETContacts.size());
            Map<String, List<Case>> ACETSRKNotInResponse = GetACETSurrogateKeysNotInResponse(MDMMember, ACETContacts);
            System.debug('ACETSRKNotInResponse='+ACETSRKNotInResponse.size());
            //Get cases to be orphanded which are associated to surrogate keys which are in ACET but not in response
            if (ACETSRKNotInResponse.size() > 0) {
                for(String str: ACETSRKNotInResponse.KeySet()){
                    for (Case OrphanCase : ACETSRKNotInResponse.get(str)) {
                        //US3130723 
                        if(OrphanCase.RecordType.Name !='Case Overview' && OrphanCase.RecordType.Name !='Support Request'&&OrphanCase.Case_Type__c!='Support Request'&&OrphanCase.Case_Type__c !='Opportunity'&&OrphanCase.Case_Type__c !='Care Plan'&&OrphanCase.Case_Type__c !='Proactive Alert'){
                        OrphanCase.ContactId = null;
                        OrphanCase.AccountId = null;
                        OrphanCase.Last_Orphaned__c = System.now();
                        OrphanCases.put(OrphanCase.Id, OrphanCase);
                        }
                    }
                }
            }
        
        return ACETSRKCaseMap;
    }
    
    //New Contact
    public Contact GetConstitentContact(ACETOILIndividual MDMMember) {
        System.debug('It came here to create new contact###');
        List<Contact> checkEidContacts= new List<Contact>();
        Contact ACETMember = new Contact();
        System.debug('MDMMember.EId='+MDMMember.EId);
        checkEidContacts=[Select id,AccountId from Contact where EID__c=:MDMMember.EId];//Checking if that eid is present in any old contact
        System.debug('checkEidContacts='+checkEidContacts);
        if(checkEidContacts!=null && checkEidContacts.size()>0){
         ACETMember= checkEidContacts.get(0);  
         EidStatus=true;//Existing Contact is there for this EID
        }
        ACETMember.FirstName = MDMMember.FirstName;
        ACETMember.LastName = MDMMember.LastName;
        //ACETMember.FirstName = MDMMember.FirstName + ' ' + MDMMember.middleInitial;
        //ACETMember.LastName = MDMMember.LastName + ' ' + MDMMember.suffix;
        ACETMember.Birthdate = MDMMember.BirthDate;
        ACETMember.EID__c = MDMMember.EId;
        ACETMember.Phone = MDMMember.Phone;
        ACETMember.SRK_KeyChain__c=getSrkChain(MDMMember); 
        return ACETMember;
    }
    
    //Update Contact
    private Contact GetConstitentContact(ACETOILIndividual MDMMember, Contact ACETMember) {
      //String oldSrk;
        System.debug('It came here with the old contact'+ACETMember);
        String srkKeyChain= getSrkChain(MDMMember);
        EidStatus=true;//By Default i am making eid status =true
        srkStatus=false;//By Default i am making srk status =false
        
        //String accountid=ACETMember.accountId;
        System.debug('EID FROM Existing contact='+ACETMember.EID__c);
        System.debug('EID From service='+MDMMember.EId);
        if(ACETMember.EID__c!=MDMMember.EId){
            EidStatus=false; //if it is not equal then i am making eid status =false
            System.debug('Surrogate key from Existing contact='+ACETMember.SRK_KeyChain__c);
            System.debug('Surrogate key from oil service='+srkKeyChain);
            /*if(ACETMember.SRK_KeyChain__c.contains(srkKeyChain) || srkKeyChain.contains(ACETMember.SRK_KeyChain__c)){
              oldSrk=ACETMember.SRK_KeyChain__c;
              
             }*/
            for(String sk:MDMMember.SurrogateKeys){
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
        ACETMember.FirstName = MDMMember.FirstName; // + ' ' + MDMMember.middleInitial
        ACETMember.LastName = MDMMember.LastName ;// + ' ' + MDMMember.suffix
        ACETMember.Birthdate = MDMMember.BirthDate;
        ACETMember.EID__c = MDMMember.EId;
        ACETMember.Phone = MDMMember.Phone;
        ACETMember.SRK_KeyChain__c=srkKeyChain;
        return ACETMember;
    }
    
    public void delOldContact(){
        Contact ct=[Select id from Contact where id=:oldContactID];
        delete ct;
    }
      // To form srkchain
    Public String getSrkChain(ACETOILIndividual MDMMember){
       String srkKeyChain='';
        if(MDMMember.SurrogateKeys!=null && MDMMember.SurrogateKeys.size()>0){
            List<String> SurrogateKeyList=new List<String>();
            
            SurrogateKeyList.addAll(MDMMember.SurrogateKeys);
            SurrogateKeyList.sort();
            for(String srk:SurrogateKeyList){
                srkKeyChain=srkKeyChain+','+srk;
            }
             srkKeyChain=srkKeyChain.substring(1);
        }
        System.debug('srkKeyChain='+srkKeyChain);
        return srkKeyChain;
    }
    
    public Map<String, List<Case>> MergeNSplitCases(ACETOILIndividual MDMMember) {
        //MDMMember.EId='12345678';
        //MDMMember.SurrogateKeys=new set<String>{'699999999'};
        
        Map<String, List<Case>> ACETSRKCaseMap = MatchMDMnACETSurrogateKeys(MDMMember);
        
        //Create or Update Account 
        String AccountName = String.isBlank(ACETContact.FirstName) ? ACETContact.LastName : ACETContact.FirstName + ' ' + ACETContact.LastName;
        system.debug('--------MDMMember------>'+MDMMember + '---------ACETContact----->'+ACETContact);
        if(String.isBlank(AccountName))
        AccountName = String.isBlank(MDMMember.FirstName) ? MDMMember.LastName : MDMMember.FirstName + ' ' + MDMMember.LastName;
        List<Account> accList = [select Id,FirstName,LastName,EID__c,SRK_KeyChain__c  from Account where Id =: ACETContact.AccountId];
        Account ACETAccount;
        if(accList.size() > 0){
            ACETAccount = accList.get(0);
            ACETAccount.FirstName= MDMMember.FirstName;
            ACETAccount.LastName = MDMMember.LastName;
            ACETAccount.SRK_KeyChain__c=ACETContact.SRK_KeyChain__c;
            ACETAccount.SRK_KeyChain__pc=ACETContact.SRK_KeyChain__c;
            ACETAccount.EID__c=ACETContact.EID__c;
            ACETAccount.EID__pc = ACETContact.EID__c;
            ACETAccount.PersonBirthdate = ACETContact.Birthdate;
            System.debug('It came here for old account@@@='+ACETAccount);
            if(ACETAccount.SRK_KeyChain__c != null){
           update ACETAccount; //Database.update(ACETAccount, Account.Fields.EID__c); 
           }else{
        srkerrormessage = true;
           }
        } 
        else{
            
            Boolean accountfirst = true;
            String accountQuery = 'Select Id,FirstName,LastName,EID__c,SRK_KeyChain__c from Account';
            for(String sk : MDMMember.SurrogateKeys){
                if(!accountfirst){
                    accountQuery = accountQuery + ' OR';
                } else {
                    accountQuery = accountQuery + ' WHERE';
                }
            accountQuery = accountQuery + ' Account.SRK_KeyChain__c LIKE \'%' + sk + '%\'';
            accountQuery = accountQuery + ' or EID__c= \''+ MDMMember.EId+'\'';
            accountfirst = false;
          }
            System.debug('accountQuery='+accountQuery);
            
            List<Account> acetACCs=Database.query(accountQuery);
            //String keychainLike='%'+ ACETContact.SRK_KeyChain__c+'%';
            //List<Account> acetACCs=[Select Id,Name,EID__c,SRK_KeyChain__c from Account where SRK_KeyChain__c like :keychainLike or EID__c=:MDMMember.EId] ;
            if(acetACCs!=null && acetACCs.size()>0){
                    ACETAccount=acetACCs.get(0);
                    ACETAccount.FirstName= MDMMember.FirstName;
                    ACETAccount.LastName = MDMMember.LastName;
                    ACETAccount.SRK_KeyChain__c=ACETContact.SRK_KeyChain__c;
                    ACETAccount.SRK_KeyChain__pc=ACETContact.SRK_KeyChain__c;
                    ACETAccount.EID__c=ACETContact.EID__c;
                    ACETAccount.EID__pc = ACETContact.EID__c;
                    ACETAccount.PersonBirthdate = ACETContact.Birthdate;
                   System.debug('It came here for old account***='+ACETAccount);
                               if(ACETAccount.SRK_KeyChain__c != null){

                   update ACETAccount;  //Database.update(ACETAccount, Account.Fields.EID__c);
                   }else{
                srkerrormessage = true;
                   }
               }
            else{
                ACETAccount = new Account(
                Id=ACETContact.AccountId, 
                FirstName = MDMMember.FirstName,
                LastName  = MDMMember.LastName,
                SRK_KeyChain__c=ACETContact.SRK_KeyChain__c,
                SRK_KeyChain__pc=ACETContact.SRK_KeyChain__c,
                EID__c=ACETContact.EID__c,
                EID__pc = ACETContact.EID__c,
                PersonBirthdate = ACETContact.Birthdate,
                RecordTypeId = PersonAccrecTypeId
                );
                            if(ACETAccount.SRK_KeyChain__c != null){

                Database.upsert(ACETAccount, Account.Fields.EID__c);
                }else{
         srkerrormessage = true;
                   }
            }

        }
        
        
        //Orphan cases
        update OrphanCases.values();//orphaning the cases whose surrogate key not coming
        if(oldContactID!=null){
           List<Interaction__c> intList=new list<Interaction__c>();
             for(Interaction__c intec :[SELECT Id,Originator__c from Interaction__c where Originator__c=:oldContactID]){
                 intec.Originator__c=ACETContact.id;
                 intList.add(intec);
             }
            if(intList!=null && intList.size()>0)
               update intList;
             //delOldContact();//Commented as getting error.
             
        }
        
        
        /*if(oldContactID!=null){
            System.debug('oldContactID='+oldContactID);
            delOldContact();
        }*/
        return ACETSRKCaseMap;
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
    
    /*public void MergeNSplitCases(ACETOILIndividual MDMMember, Id CurrentInteractionId) {
        Map<String, List<Case>> ACETSRKCaseMap = MatchMDMnACETSurrogateKeys(MDMMember);
        
        //Create or Update Account
        String AccountName = String.isBlank(ACETContact.FirstName) ? ACETContact.LastName : ACETContact.FirstName + ' ' + ACETContact.LastName;
        Account ACETAccount = new Account(Id=ACETContact.AccountId, Name = 'AccountName');
        upsert ACETAccount;
        
        //Create or Update Contact
        ACETContact.AccountId = ACETAccount.Id;  
        upsert ACETContact;
        
        //Orphan cases
        update OrphanCases.values();
        
        //Reparent cases
        Map<Id, Case> ReparentCases = new Map<Id, Case>();
        for(String str: ACETSRKCaseMap.KeySet()){
            for (Case ReparentCase : ACETSRKCaseMap.get(str)) {
                if(String.isBlank(ReparentCase.ContactId)){
                    ReparentCase.Interaction__c = CurrentInteractionId; 
                }
                ReparentCase.ContactId = ACETContact.Id;
                ReparentCase.AccountId = ACETAccount.Id;            
                ReparentCases.put(ReparentCase.Id, ReparentCase);
            } 
        }
        
        update ReparentCases.values();  
    }*/
}