@isTest
public class ACETMedicalLossRatioControllerTest{
     public static testmethod void ACETLGT_showConfettiTestmethod() {
         user userinfo = TestDataFactory.getUser('ECM Back Office Agent');
                     ACETLGT_Confetti__c confi = new ACETLGT_Confetti__c();
         confi.Header_Message__c = 'CONGRATULATIONS!!!';
           confi.Milestone__c = 125.2;
         confi.Profile_List__c ='ECM Back Office Agent';
         confi.UserId__c = userinfo.id;
         insert confi;
         list<string> redidlist = new list<string>();
         redidlist.add(confi.id);
       //  ACETLGT_showConfetti.getsObjectCountClassic(redidlist);
        
    }
    
    public static testmethod void ACETMedicalLossRatioPage() {
            PageReference ACETMedicalLossRatio = Page.ACETMedicalLossRatio;
            Interaction__c interactionId = TestDataFactory.createInteraction();
      RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
          
          Account accountTest = new Account();
          accountTest.FirstName = 'Test';
          accountTest.LastName = 'Contact';
          accountTest.EID__c = 'PIN';
          accountTest.EID__pc = 'PIN';
          accountTest.RecordTypeId = newRecord.Id;
          insert accountTest;
  
      Account acc = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
          Contact cont = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:acc.personcontactid];            ACETMedicalLossRatio.getParameters().put('interactionId', InteractionId.Id);
            ACETMedicalLossRatio.getParameters().put('contactId',cont.Id);
            ACETMedicalLossRatio.getParameters().put('callTopic','MedicalLossRatio');            
            ACETMedicalLossRatio.getParameters().put('SRK','test');
            Test.setCurrentPage(ACETMedicalLossRatio);  
            Apexpages.StandardController ACETMedicalLossCtrl = new Apexpages.standardController(InteractionId);           
            ACETMedicalLossRatioController ACETMedicalLossContr = new ACETMedicalLossRatioController();
            ACETMedicalLossContr.interaction = interactionId;
            ACETMedicalLossContr.Subject = cont; 
            ACETMedicalLossContr.swivelATNE_URL= 'test'; 
            ACETMedicalLossContr.swivelORBIT_URL= 'test'; 
     }  
 }