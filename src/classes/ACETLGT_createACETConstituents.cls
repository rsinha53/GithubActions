public class ACETLGT_createACETConstituents {
    public static Contact Subject;
    public static List<Contact> FamilyMembers ;
    //public static ACETMemberDetail MemberDetail;
    public static String FamilyInfoStr;
    public static List<Contact> FamilyInfo;
	@AuraEnabled 
    public static Account createAccount(String FirstName,String LastName,String DOB,String EID,String SRKKeyChain, String interactionId){
		Set<string> srkKeyChainSet = new Set<string>();

        system.debug('========EID---------:::'+EID);
        system.debug('========SRKKeyChain---------:::'+SRKKeyChain);
        if(SRKKeyChain != null && SRKKeyChain.indexOf(',') != -1){
            for(String srk:SRKKeyChain.split(',')){
                srkKeyChainSet.add(srk);
            }
        }else{
            srkKeyChainSet.add(SRKKeyChain);
        }
        System.debug('======SURROGATEKEYS========'+srkKeyChainSet);
        ACETOILIndividual acetOilData = new ACETOILIndividual();
        acetOilData.FirstName = String.isBlank(FirstName) ? FirstName : FirstName; //MemberDetail.FirstName; //
        acetOilData.LastName = String.isBlank(LastName) ? LastName : LastName; // MemberDetail.LastName;   //
        //String indiIdentifier = ApexPages.currentPage().getParameters().get('individualIdentifier');
        acetOilData.EId = EID;
        if(DOB != null)
        acetOilData.Birthdate= Date.valueOf(formatDatewithslash(DOB));
        //acetOilData.Phone = Phone;
        //acetOilData.suffix = MemberDetail.Suffix;
        //acetOilData.middleInitial = MemberDetail.MiddleInitial;
        acetOilData.SurrogateKeys = srkKeyChainSet;
		ACETConstituent acetcon = new ACETConstituent(); 
        Map<String, List<Case>> ACETSRKCaseMap = acetcon.MergeNSplitCases(acetOilData); //SRK Code
        Subject = acetcon.GetConstitentContact(acetOilData);
        //Subject = acetcon.Subject;   
        system.debug(LoggingLevel.INFO, 'Subject inside controller '+Subject);
        
        //save member and member family to contact
        //createMemberAndFamilyMembers( FirstName, LastName, DOB, EID, SRKKeyChain, interactionId);
        if(interactionId != null && interactionId != ''){
            Interaction__c Interaction = ACETMemberQueryUtil.queryInteraction(interactionId);
            if(Interaction != null){
                
                acetcon.ReparentCases(Interaction.Id, ACETSRKCaseMap); //SRK code
            }
            	
        }
        
        Account ACETAccount;
        if(Subject.id != null)
            ACETAccount = [SELECT id FROM Account WHERE id =: [SELECT AccountId FROM CONTACT WHERE id =:Subject.id LIMIT 1].AccountId ];
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
    public static Account createMemberAndFamilyMembers(ACETLGT_MemberSearchCoveragesResult.FamilyMember fm, String EID,Map<String,String>  relationshipmap){
      try{
        //String Id = ApexPages.currentPage().getParameters().get('Id');
        //String indiIdentifier = ApexPages.currentPage().getParameters().get('individualIdentifier');
        //system.debug(LoggingLevel.INFO, 'Id >>>>>>>>> '+Id);
        //String firstName = ApexPages.currentPage().getParameters().get('firstName');
        //String lastName = ApexPages.currentPage().getParameters().get('lastName');
        //Added for populating date of birth for subject : starts
        //String dob = ApexPages.currentPage().getParameters().get('subjectdob');
        system.debug('========1========>>'+fm.EID +'-===-'+ EID);
          // Map<String,String>  relationshipmap = ACETUtility.getHouseholdRelationshipMap();
          if(fm.EID != EID){
        	Account acc = new Account();
        	//acc.name = String.isBlank(fm.FirstName) ? fm.LastName : fm.FirstName + ' ' + fm.LastName;
        	acc.Eid__c = fm.EID;
            acc.FirstName = fm.FirstName;
            acc.LastName  = fm.LastName;
            acc.SRK_KeyChain__c=fm.ESRK;
            acc.SRK_KeyChain__pc=fm.ESRK;
            acc.EID__c=fm.EID;
            acc.EID__pc = fm.EID;
	    if(fm!=null && fm.Relationship!=null)
              acc.Relationship__pc = relationshipmap.get(fm.Relationship);
            if(fm.DOB != null && formatDatewithslash(fm.DOB) != null)
            	acc.PersonBirthdate = Date.valueOf(formatDatewithslash(fm.DOB)) ;
            acc.RecordTypeId = ACETMemberQueryUtil.getPersonAccountRecordType();
			system.debug('========2========>>');
            try{
                Database.upsert(acc, Account.Fields.EID__c,false);
                system.debug('========3========>>');
            }catch(Exception e){
                system.debug(LoggingLevel.INFO, e.getMessage() +' :: '+e.getStackTraceString());
                
            }
          system.debug('========4========>>');
          Contact con = new Contact();
          con.FirstName = fm.FirstName;
          con.LastName = fm.LastName;
          //con.FirstName = fm.FirstName + ' ' + fm.MiddleInitial;
          //con.LastName = fm.LastName + ' ' + fm.suffix;
          con.EID__c = fm.EID;
          system.debug('before date concersion '+fm.dob);
          con.birthdate = Date.parse(fm.dob);
          system.debug('after date concersion '+con.birthdate);
          con.accountid =  acc.id;
          system.debug(LoggingLevel.INFO, 'con.accountId :: '+con.accountId);
          //Con.Phone = phone;   
          system.debug('========5========>>'+ con);    
        system.debug('FamilyMembers before upsert >> '+FamilyMembers);
        try{
            Database.upsert(con, Contact.Fields.EID__c,false);
        }catch(Exception e){
            system.debug(LoggingLevel.INFO, e.getMessage() +' :: '+e.getStackTraceString());
        }
        return acc;     
        }else{
            system.debug('========6========>>'); 
            List<Account> accRecList = [SELECT id,PersonContactId FROM Account WHERE EID__c =: fm.EID LIMIT 1];
            if(accRecList != null && accRecList.size() > 0){
                List<Contact> Conlist =  [SELECT id FROM CONTACT Where AccountId =:accRecList.get(0).id LIMIT 1];
                if( Conlist.size() == 0){
                      Contact con = new Contact();
              		  con.FirstName = fm.FirstName;
                      con.LastName = fm.LastName;
                      //con.FirstName = fm.FirstName + ' ' + fm.MiddleInitial;
                      //con.LastName = fm.LastName + ' ' + fm.suffix;
                      con.EID__c = fm.EID;
                      system.debug('before date concersion '+fm.dob);
                      con.birthdate = Date.parse(fm.dob);
                      system.debug('after date concersion '+con.birthdate);
                      con.accountid =  accRecList.get(0).id;
                      system.debug(LoggingLevel.INFO, 'con.accountId :: '+con.accountId);
                      //Con.Phone = phone;   
                          
                    system.debug('FamilyMembers before upsert >> '+FamilyMembers);
                    try{
                        Database.upsert(con, Contact.Fields.EID__c,false);
                        system.debug('--------con---'+con.Id);
                    }catch(Exception e){
                        system.debug(LoggingLevel.INFO, e.getMessage() +' :: '+e.getStackTraceString());
                    }
                }
                return accRecList.get(0);
            }else{
                system.debug('--------acc---');
                /**Account acc = new Account();
                acc.name = String.isBlank(fm.FirstName) ? fm.LastName : fm.FirstName + ' ' + fm.LastName;
                acc.Eid__c = fm.EID;**/
                Account acc = new Account();
                //acc.name = String.isBlank(fm.FirstName) ? fm.LastName : fm.FirstName + ' ' + fm.LastName;
                acc.Eid__c = fm.EID;
                acc.FirstName = fm.FirstName;
                acc.LastName  = fm.LastName;
                acc.SRK_KeyChain__c=fm.ESRK;
                acc.SRK_KeyChain__pc=fm.ESRK;
                acc.EID__c=fm.EID;
                acc.EID__pc = fm.EID;
		if(fm!=null && fm.Relationship!=null)
             	 acc.Relationship__pc = relationshipmap.get(fm.Relationship);
                if(fm.DOB != null && formatDatewithslash(fm.DOB) != null)
                    acc.PersonBirthdate = Date.valueOf(formatDatewithslash(fm.DOB)) ;
                acc.RecordTypeId = ACETMemberQueryUtil.getPersonAccountRecordType();
              
    
    
    
            try{
                Database.upsert(acc, Account.Fields.EID__c,false);
                system.debug('--------acc---'+acc.Id);
            }catch(Exception e){
                system.debug(LoggingLevel.INFO, e.getMessage() +' :: '+e.getStackTraceString());
                
            }
              Contact con = new Contact();
              con.FirstName = fm.FirstName;
              con.LastName = fm.LastName;
              //con.FirstName = fm.FirstName + ' ' + fm.MiddleInitial;
              //con.LastName = fm.LastName + ' ' + fm.suffix;
              con.EID__c = fm.EID;
              system.debug('before date concersion '+fm.dob);
              con.birthdate = Date.parse(fm.dob);
              system.debug('after date concersion '+con.birthdate);
              con.accountid =  acc.id;
              system.debug(LoggingLevel.INFO, 'con.accountId :: '+con.accountId);
              //Con.Phone = phone;   
                  
            system.debug('FamilyMembers before upsert >> '+FamilyMembers);
            try{
                Database.upsert(con, Contact.Fields.EID__c,false);
                system.debug('--------con---'+con.Id);
            }catch(Exception e){
                system.debug(LoggingLevel.INFO, e.getMessage() +' :: '+e.getStackTraceString());
            }
                return acc;
        }
        }
      }
      catch(Exception e){
            system.debug(LoggingLevel.INFO, e.getMessage() +' :: '+e.getStackTraceString()); 
            return null;
      }
      
    }
}