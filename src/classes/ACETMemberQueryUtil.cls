public class ACETMemberQueryUtil {
    
    public static Interaction__c queryInteraction(String interactionId){        
       Interaction__c Interaction = new Interaction__c();
       List<Interaction__c> InteractionList = new List<Interaction__c>();
        if (InteractionId != null && InteractionId !='')
        {
        
        
        InteractionList = [SELECT Id, Name, Interaction_Type__c, Provider_ID__c, Group_ID__c, Originator_Type__c, Originator_Name__c,Contact_Name__c, Caller_Type__c, Highlight_Panel_GroupInfo__c,Originator__c, Originator__r.EID__c, Originator__r.Tax_ID__c, Originator__r.NPI__c, 
            Originator__r.Name,Id__c, Originator__r.LastName, Originator__r.FirstName,Originator__r.Contact_Type__c,Contact_Type__c, Originator__r.AccountId,Originator__r.Account.Name,Originator__r.Birthdate,Originator__r.mailingState,Originator__r.mailingPostalCode,Originator__r.Phone, Third_Party__c, Third_Party__r.Tax_ID__c, Third_Party__r.NPI__c, 
            Third_Party__r.FullName__c, Provider_Address_Id__c , Provider_Address_Type__c, Third_Party__r.LastName__C,Third_Party__r.Producer_Name__C, Third_Party__r.First_Name__c,Third_Party__r.Employer_Name__c, Third_Party__r.Phone_Number__c, Third_Party__r.Email__c
            FROM Interaction__c WHERE Id =:InteractionId];
        }        
        if(InteractionList.size() > 0){
            Interaction = InteractionList[0];
            return Interaction;
        }else{
            return null;
        }
        

    }
    public static Interaction__c queryInteraction(String InteractionType, String OriginatorType,String EmployerName, String LastName, String FirstName, String PhoneNumber,Date dob,String State,String Zip,String GroupNum,String NotFoundFLowName)
    {
        try{
        /*
        Account acc =  new Account();
        if(EmployerName != null && EmployerName != '' ){
            acc.Name = EmployerName;
            insert acc;
        }
        
        Contact con = new Contact();
        if(acc != null){
            con.accountId = acc.id;
        }
        con.FirstName = FirstName;
        con.LastName = LastName;
        con.Phone = PhoneNumber;
        con.Birthdate = dob;
        system.debug('-------MailingState------>'+ state);
        con.MailingState = state;
        con.MailingPostalCode = zip;
        insert con;
        */
        Third_Party__c ManualMember = new Third_Party__c();
        //ManualMember.Tax_ID__c = TaxId;
        //ManualMember.NPI__c = Npi;           
        ManualMember.LastName__C = LastName;
        ManualMember.First_Name__c = FirstName;
        ManualMember.Phone_Number__c = PhoneNumber;
        ManualMember.FullName__c = FirstName + ' ' +LastName;
        ManualMember.Employer_Name__c = EmployerName;
        ManualMember.DOB__c = dob;
        ManualMember.Group_Number__c = GroupNum;
        ManualMember.Mailing_State__c = state;
        ManualMember.Mailing_postalCode__c = zip;
        ManualMember.Flow_Name__c = NotFoundFLowName ;
        insert ManualMember;
        //system.debug('con->'+con);
        
        Interaction__c interaction = new Interaction__c();
        Interaction.Interaction_Type__c = InteractionType;
        Interaction.Originator_Type__c = OriginatorType;
        //Interaction.Contact_Name__c = CallerName; 
        Interaction.Third_party__c = ManualMember.Id;
        Interaction.Contact_Name__c = FirstName +' '+LastName;
        
        /*        
        Interaction__c interaction = new Interaction__c();
        Interaction.Interaction_Type__c = InteractionType;
        Interaction.Originator_Type__c = OriginatorType;
        Interaction.Contact_Name__c = con.FirstName +' '+con.LastName; 
        Interaction.Originator__c = con.Id;
        Interaction.Id__c = GroupNum;
        Interaction.Member_Date_of_Birth__c = con.Birthdate;
        */
        return interaction;
        }
        catch(exception e){
        return null;
        }
        
    }  
     public static Interaction__c queryInteractionMemInFocus(String interactionId,String InteractionType, String OriginatorType,String EmployerName, String LastName, String FirstName, String PhoneNumber,Date dob,String State,String Zip,String GroupNum,String NotFoundFLowName)
    {
        try{
                        
            Interaction__c Interaction = new Interaction__c();
            if (InteractionId != null && InteractionId !='')
            {  
            
            Interaction = [SELECT Id, Name, Interaction_Type__c, Originator_Type__c, Originator_Name__c,Contact_Name__c, Caller_Type__c, Highlight_Panel_GroupInfo__c,Originator__c, Originator__r.EID__c, Originator__r.Tax_ID__c, Originator__r.NPI__c, 
                Originator__r.Name,Id__c, Originator__r.LastName, Originator__r.FirstName, Originator__r.AccountId,Originator__r.Account.Name,Originator__r.Birthdate,Originator__r.mailingState,Originator__r.mailingPostalCode,Originator__r.Phone, Third_Party__c, Third_Party__r.Tax_ID__c, Third_Party__r.NPI__c, 
                Third_Party__r.FullName__c, Third_Party__r.LastName__C, Third_Party__r.First_Name__c,Third_Party__r.Employer_Name__c,Third_Party__r.Producer_Name__C,Third_Party__r.Phone_Number__c, Third_Party__r.Email__c
                FROM Interaction__c WHERE Id =:InteractionId];
            }
            Third_Party__c ManualMember = new Third_Party__c(id = Interaction.Third_party__c);           
            ManualMember.LastName__C = LastName;
            ManualMember.First_Name__c = FirstName;
            ManualMember.Phone_Number__c = PhoneNumber;
            ManualMember.FullName__c = FirstName + ' ' +LastName;
            ManualMember.Employer_Name__c = EmployerName;
            ManualMember.DOB__c = dob;
            ManualMember.Group_Number__c = GroupNum;
            ManualMember.Mailing_State__c = state;
            ManualMember.Mailing_postalCode__c = zip;
            ManualMember.Flow_Name__c = NotFoundFLowName ;
            upsert ManualMember;
            //Interaction.Third_party__c = ManualMember.Id;
            //update Interaction;
            
            return interaction;
        }
        catch(exception e){
            return null;
        }
        
    }      
    public static Contact queryContact(String conId){
        return (Contact)ACETQueryUtil.query(conId, 'Contact');  
    }  
    public static Third_Party__c queryThirdParty(String thirdPartyId){
      return [SELECT id, Name,FullName__c,(SELECT id, name,Other_Originator__c,Third_Party__c FROM Third_Party_Relationships__r) FROM Third_Party__c where id =: thirdPartyId];
    }
    public static Contact queryPersonContact(String conId){
        return [SELECT id,FirstName,LastName,EID__c,Contact_Type__c from contact where id=:conId];    
    }
    //Added for to get PersonAccount RecordTypeId
    public static Id getPersonAccountRecordType(){
    
        RecordType personAccRecordType =  [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        return personAccRecordType.Id;
     }

}