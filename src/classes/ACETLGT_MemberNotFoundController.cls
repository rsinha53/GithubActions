public class ACETLGT_MemberNotFoundController {
    public class custException extends Exception {}
        
        @AuraEnabled
    public static Interaction__c createInteraction(String InteractionType, String OriginatorType,String EmployerName, String LastName, String FirstName, String PhoneNumber,Date dob,String State,String Zip,String GroupNum,String NotFoundFLowName){
        
        string strphone = PhoneNumber;
        if(!string.isEmpty(strphone)){
          strphone = strphone.substring(0, 3) + '-' + strphone.substring(3, 6) + '-' + strphone.substring(6);
        }
        
        Third_Party__c ManualMember = new Third_Party__c();
        ManualMember.LastName__C = LastName;
        ManualMember.First_Name__c = FirstName;
        ManualMember.Phone_Number__c = strphone;
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
        insert interaction;        
        return interaction;    
            
    }
    
    
    @AuraEnabled 
    public static user getUser(){
     // query current user information  
      User oUser = [select id,Name,Agent_Type__c,Profile_Name__c,Role_Name__c FROM User Where id =: userInfo.getUserId()];
        system.debug('oUser:: '+oUser);
        return oUser;
    }


}