@isTest
public  class ACETLicensingAndCredentialingContlrTest 
{ 
    private static Account accountRec {get;set;} // = new Account();
    private static Contact contactRec {get;set;} //= new Contact();
     private static Interaction__c inter{get;set;} //= new interaction();
    
    
    static testMethod void LicensingAndCredentialingTestsave()
    { 
        createData(); 
        system.debug('interaction'+inter); 
        PageReference ACETLicensingAndCredentialing = Page.ACETLicensingAndCredentialing;
        Test.setCurrentPage(ACETLicensingAndCredentialing);
        apexpages.currentpage().getparameters().put('InteractionId', inter.id);
        Test.startTest();
        
        ACETLicensingAndCredentialingController licenseCredential = new ACETLicensingAndCredentialingController();
        //licenseCredential.getLicensingAndCredentialingCallTypes();
        ACETHighlightsPanelAdditionalInfo addInfo = new ACETHighlightsPanelAdditionalInfo();
        addInfo.producerId = '001234';
        ACETCallTopicsDataWrapper acetCallTopicDW = new ACETCallTopicsDataWrapper();
        acetCallTopicDW.AdditionalInfo = addInfo ;
        acetCallTopicDW.comments= 'Test' ;
        acetCallTopicDW.autodoc= 'Test' ;
        acetCallTopicDW.SubjectType= 'Test' ;
        acetCallTopicDW.createCase();
        acetCallTopicDW.saveCase();
        
        Test.stopTest();
        system.AssertNotEquals(acetCallTopicDW.caseObj.id,null);
    }
  
    public static void createData(){
      RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'Test';
        accountTest.LastName = 'Contact';
        accountTest.EID__c = 'PIN';
        accountTest.EID__pc = 'PIN';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;

    accountRec = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        contactRec = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:accountRec.personcontactid]; 
        
        inter = new Interaction__c();
        inter.Originator__c = contactRec.id;
        inter.Interaction_Type__c = 'Phone Call';            
        inter.Originator_Type__c = 'Producer';            
        insert inter;
    }
}