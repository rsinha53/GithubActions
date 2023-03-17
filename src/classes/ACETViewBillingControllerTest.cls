@isTest
public  class ACETViewBillingControllerTest 
{   
   static testMethod void viewBillingTestsave()
  {  
        Test.startTest();
        RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'Test';
        accountTest.LastName = 'Contact';
        accountTest.EID__c = 'PIN';
        accountTest.EID__pc = 'PIN';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;

    Account acc = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact contactRec = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:acc.personcontactid];
        
        String JSONStr = '{"UHCBS":"","GroupN":"Test Group Name","GroupStatus":"Active","ServiceTeam":"NY Large","EffectiveStartDate":"3/1/2016","RiskManagement":"Rating Method","RatingMethod":"","RenewalDate":"3/1/2016","RelationshipType":"Mother","groupSName":"Test GroupName"}';        
        Interaction__c interaction = new Interaction__c();
        interaction.Highlight_Panel_GroupInfo__c=JSONStr;
        insert interaction;
        ApexPages.currentPage().getParameters().put('InteractionId',interaction.id);
        ApexPages.currentPage().getParameters().put('ContactId',contactRec.id);
        ApexPages.currentPage().getParameters().put('groupId','1234567');
        
         
           ACETOrgInstanceURLToOrgNameMap__c orgInstance = new ACETOrgInstanceURLToOrgNameMap__c();
          orgInstance = ACETTestDataUtility.createOrgInstanceToOrgNameData('salesforce','dev');
          insert orgInstance ; 
        
        ACETOrgNameToSwivelEndpointMap__c SwivelEndpoint = new ACETOrgNameToSwivelEndpointMap__c();
        SwivelEndpoint.name ='dev_OBPPViewBilling';
        SwivelEndpoint.Swivel_Endpoint__c = 'test';
        insert SwivelEndpoint;
        
        ACETOrgNameToSwivelEndpointMap__c SwivelEndpoint1 = new ACETOrgNameToSwivelEndpointMap__c();
        SwivelEndpoint1.name ='qa_OBPPViewBilling';
        SwivelEndpoint1.Swivel_Endpoint__c = 'test';
        insert SwivelEndpoint1;
        
        ACETOrgNameToSwivelEndpointMap__c SwivelEndpoint2 = new ACETOrgNameToSwivelEndpointMap__c();
        SwivelEndpoint2.name ='d1_OBPPViewBilling';
        SwivelEndpoint2.Swivel_Endpoint__c = 'test';
        insert SwivelEndpoint2;
        
        ACETOrgNameToSwivelEndpointMap__c swivel3 = new ACETOrgNameToSwivelEndpointMap__c();
        swivel3.Name = 'prd_OBPPViewBilling';
        swivel3.Swivel_Endpoint__c = 'test';
        insert swivel3;
            
        ACETWrapEncryptionKey__c encryptKey = new ACETWrapEncryptionKey__c();
        encryptKey.name ='d1_OBPPEncryptionKey';
        encryptKey.Algorithm_Name__c = 'AES256';
        encryptKey.Key__c= 'tbC2KA36qE1psxs9mozyfOmy7GdrI3I9';
        insert encryptKey ;
        
        
        ACETWrapEncryptionKey__c encryptKey1 = new ACETWrapEncryptionKey__c();
        encryptKey1.name ='qa_OBPPEncryptionKey';
        encryptKey1.Algorithm_Name__c = 'AES256';
        encryptKey1.Key__c= 'tbC2KA36qE1psxs9mozyfOmy7GdrI3I9';
        insert encryptKey1;
        
        ACETWrapEncryptionKey__c dev1key = new ACETWrapEncryptionKey__c();
        dev1key.Name = 'dev_OBPPEncryptionKey';
        dev1key.Algorithm_Name__c = 'AES256';
        dev1key.Key__c = 'tbC2KA36qE1psxs9mozyfOmy7GdrI3I9';
        insert dev1key;
        
        ACETWrapEncryptionKey__c prdkey = new ACETWrapEncryptionKey__c();
        prdkey.Name = 'prd_OBPPEncryptionKey';
        prdkey.Algorithm_Name__c = 'AES256';
        prdkey.Key__c = 'tbC2KA36qE1psxs9mozyfOmy7GdrI3I9';
        insert prdkey;
            
      
        ACETViewBillingController viewBillingController = new ACETViewBillingController();    
        viewBillingController.groupId ='1234567';   
        viewBillingController.Subject =contactRec;
        viewBillingController.interactionId=interaction.Id;
        viewBillingController.contactid=contactRec.Id;
        ACETCallTopicsDataWrapper acetCallTopicDW = new ACETCallTopicsDataWrapper();
        acetCallTopicDW.saveCase();
    
    Test.stopTest();
  }
   
   static testMethod void viewBillingTestsaveClose()
  {  
      User thisUser = [Select Id From User Where Id =:UserInfo.getUserId()];
        User u;
         System.runAs(thisUser){
       u = TestDataFactory.getUser('Research User');
      RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
          
        Account accountTest = new Account();
        accountTest.FirstName = 'Test';
        accountTest.LastName = 'Contact';
        accountTest.EID__c = 'PIN';
        accountTest.EID__pc = 'PIN';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;

    Account acc = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact contactRec = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:acc.personcontactid];
         }
      System.RunAs(u){     
        Test.startTest();
          
            Interaction__c interaction = new Interaction__c();
            insert interaction;
            ApexPages.currentPage().getParameters().put('InteractionId',interaction.id);
            ApexPages.currentPage().getParameters().put('additionalInfo',TestDataFactory.createACETHighlightsPanelAdditionalInfo());
            
           ACETOrgInstanceURLToOrgNameMap__c orgInstance = new ACETOrgInstanceURLToOrgNameMap__c();
          orgInstance = ACETTestDataUtility.createOrgInstanceToOrgNameData('salesforce','dev');
          insert orgInstance ;    
            
        ACETOrgNameToSwivelEndpointMap__c SwivelEndpoint = new ACETOrgNameToSwivelEndpointMap__c();
        SwivelEndpoint.name ='dev_OBPPViewBilling';
        SwivelEndpoint.Swivel_Endpoint__c = 'test';
        insert SwivelEndpoint;
        
        ACETOrgNameToSwivelEndpointMap__c SwivelEndpoint1 = new ACETOrgNameToSwivelEndpointMap__c();
        SwivelEndpoint1.name ='qa_OBPPViewBilling';
        SwivelEndpoint1.Swivel_Endpoint__c = 'test';
        insert SwivelEndpoint1;
        
        ACETOrgNameToSwivelEndpointMap__c SwivelEndpoint2 = new ACETOrgNameToSwivelEndpointMap__c();
        SwivelEndpoint2.name ='d1_OBPPViewBilling';
        SwivelEndpoint2.Swivel_Endpoint__c = 'test';
        insert SwivelEndpoint2;
        
        ACETOrgNameToSwivelEndpointMap__c swivel3 = new ACETOrgNameToSwivelEndpointMap__c();
        swivel3.Name = 'prd_OBPPViewBilling';
        swivel3.Swivel_Endpoint__c = 'test';
        insert swivel3;
        
        ACETWrapEncryptionKey__c encryptKey = new ACETWrapEncryptionKey__c();
        encryptKey.name ='d1_OBPPEncryptionKey';
        encryptKey.Algorithm_Name__c = 'AES256';
        encryptKey.Key__c= 'tbC2KA36qE1psxs9mozyfOmy7GdrI3I9';
        insert encryptKey ;
        
        
        ACETWrapEncryptionKey__c encryptKey1 = new ACETWrapEncryptionKey__c();
        encryptKey1.name ='qa_OBPPEncryptionKey';
        encryptKey1.Algorithm_Name__c = 'AES256';
        encryptKey1.Key__c= 'tbC2KA36qE1psxs9mozyfOmy7GdrI3I9';
        insert encryptKey1;
        
        ACETWrapEncryptionKey__c dev1key = new ACETWrapEncryptionKey__c();
        dev1key.Name = 'dev_OBPPEncryptionKey';
        dev1key.Algorithm_Name__c = 'AES256';
        dev1key.Key__c = 'tbC2KA36qE1psxs9mozyfOmy7GdrI3I9';
        insert dev1key;
        
        ACETWrapEncryptionKey__c prdkey = new ACETWrapEncryptionKey__c();
        prdkey.Name = 'prd_OBPPEncryptionKey';
        prdkey.Algorithm_Name__c = 'AES256';
        prdkey.Key__c = 'tbC2KA36qE1psxs9mozyfOmy7GdrI3I9';
        insert prdkey;
            
      
            ACETViewBillingController viewBillingController = new ACETViewBillingController();
            ACETCallTopicsDataWrapper acetCallTopicDW = new ACETCallTopicsDataWrapper();
           
            
        Test.stopTest();
      }
   }

   static testMethod void testSwivelToBRMS(){
      ACETOrgInstanceURLToOrgNameMap__c orgInstance = new ACETOrgInstanceURLToOrgNameMap__c();
      orgInstance = ACETTestDataUtility.createOrgInstanceToOrgNameData('salesforce','dev');
      insert orgInstance ;
      
        ACETOrgNameToSwivelEndpointMap__c SwivelEndpoint = new ACETOrgNameToSwivelEndpointMap__c();
        SwivelEndpoint.name ='dev_OBPPViewBilling';
        SwivelEndpoint.Swivel_Endpoint__c = 'test';
        insert SwivelEndpoint;
        
        ACETOrgNameToSwivelEndpointMap__c SwivelEndpoint1 = new ACETOrgNameToSwivelEndpointMap__c();
        SwivelEndpoint1.name ='qa_OBPPViewBilling';
        SwivelEndpoint1.Swivel_Endpoint__c = 'test';
        insert SwivelEndpoint1;
        
        ACETOrgNameToSwivelEndpointMap__c SwivelEndpoint2 = new ACETOrgNameToSwivelEndpointMap__c();
        SwivelEndpoint2.name ='d1_OBPPViewBilling';
        SwivelEndpoint2.Swivel_Endpoint__c = 'test';
        insert SwivelEndpoint2;
        
        ACETOrgNameToSwivelEndpointMap__c swivel3 = new ACETOrgNameToSwivelEndpointMap__c();
        swivel3.Name = 'prd_OBPPViewBilling';
        swivel3.Swivel_Endpoint__c = 'test';
        insert swivel3;
        
        ACETWrapEncryptionKey__c encryptKey = new ACETWrapEncryptionKey__c();
        encryptKey.name ='d1_OBPPEncryptionKey';
        encryptKey.Algorithm_Name__c = 'AES256';
        encryptKey.Key__c= 'tbC2KA36qE1psxs9mozyfOmy7GdrI3I9';
        insert encryptKey ;
        
        
        ACETWrapEncryptionKey__c encryptKey1 = new ACETWrapEncryptionKey__c();
        encryptKey1.name ='qa_OBPPEncryptionKey';
        encryptKey1.Algorithm_Name__c = 'AES256';
        encryptKey1.Key__c= 'tbC2KA36qE1psxs9mozyfOmy7GdrI3I9';
        insert encryptKey1;
        
        ACETWrapEncryptionKey__c dev1key = new ACETWrapEncryptionKey__c();
        dev1key.Name = 'dev_OBPPEncryptionKey';
        dev1key.Algorithm_Name__c = 'AES256';
        dev1key.Key__c = 'tbC2KA36qE1psxs9mozyfOmy7GdrI3I9';
        insert dev1key;
        
        ACETWrapEncryptionKey__c prdkey = new ACETWrapEncryptionKey__c();
        prdkey.Name = 'prd_OBPPEncryptionKey';
        prdkey.Algorithm_Name__c = 'AES256';
        prdkey.Key__c = 'tbC2KA36qE1psxs9mozyfOmy7GdrI3I9';
        insert prdkey;
            
      ACETOrgNameToSwivelEndpointMap__c swivelEndPointurl = new ACETOrgNameToSwivelEndpointMap__c();
      swivelEndPointurl = ACETTestDataUtility.createORGNameToSwivelData('dev_BRMS','https://brms-dev2.uhc.com/ouaf/loginPage.jsp');
      insert swivelEndPointurl ;
      
      ACETUtility.GetOrgName();
      ACETUtility.GetSwivelEndpointByOrgName('dev','BRMS');
     // ACETUtility.GetSwivelEndpointByOrgName('dev','OBPPViewBilling');
      Interaction__c interaction = new Interaction__c();
      insert interaction;
      ApexPages.currentPage().getParameters().put('InteractionId',interaction.id);
      
      ACETViewBillingController viewBillingController = new ACETViewBillingController();
         

      viewBillingController.fetchBRMSSysURL();
  }
  
  }