@istest
private class ECMRoutingConfigUtilityTest{
   
     @testsetup static void createTestQueues(){
          //create Test queue  
          Group  testQueue = new Group(Type = 'Queue' , Name= 'ECMTestQueue');
          insert testQueue ;
      
          QueuesObject q1 = new QueueSObject(QueueID = testQueue.id, SobjectType = 'Case');
          insert q1; 
          
          
         Profile prof = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
         User ecmTestUser = new User(
             ProfileId = prof.Id,
             LastName = 'last',
             Email = 'ecmTest@optum.com',
             Username = 'ecmTest@optum.com.acet',
             CompanyName = 'UHG',
             Alias = 'alias',
             TimeZoneSidKey = 'America/Los_Angeles',
             EmailEncodingKey = 'UTF-8',
             LanguageLocaleKey = 'en_US',
             LocaleSidKey = 'en_US'
         );
         insert ecmTestUser ;
        
         UserRole uRole = new UserRole(Name='Oxford');
         insert uROle;
    }
    
    
    static testMethod void validateQueueName (){ 
        TTS_Access__c ttsAccess1 = new TTS_Access__c();
        ttsAccess1.TTSAccessExternalID__c = '12345';
        ttsAccess1.Topic__c = 'View Claims';
        UserRole ur = [select id, Name, PortalType from UserRole where PortalType = 'None' limit 1];
        TTS_Access__c ttsAccess2 = new TTS_Access__c();
        ttsAccess2.TTSAccessExternalID__c = '12346';
        ttsAccess2.Topic__c = 'Pharmacy Inquiry';
        ttsAccess2.Limit_To_Profiles__c = 'System Administrator';
        ttsAccess2.Limit_To_Roles__c = ur.Name;
        TTS_Access__c ttsAccess3 = new TTS_Access__c();
        ttsAccess3.TTSAccessExternalID__c = '12347';
        ttsAccess3.Topic__c = 'View Claims';
        ttsAccess3.Type__c = 'Claims Inquiry';
        ttsAccess3.Limit_To_Profiles__c = 'System Administrator';
        ttsAccess3.Limit_To_Roles__c = ur.Name;
        TTS_Access__c ttsAccess4 = new TTS_Access__c();
        ttsAccess4.TTSAccessExternalID__c = '12348';
        ttsAccess4.Topic__c = 'View Claims';
        ttsAccess4.Type__c = 'Accumulator Inquiry';
        ttsAccess4.SubType__c = '1st Level Appeal';
        ttsAccess4.Limit_To_Profiles__c = 'System Administrator';
        ttsAccess4.Limit_To_Roles__c = ur.Name;
        insert new list<TTS_Access__c>{ttsAccess1,ttsAccess2,ttsAccess3,ttsAccess4};
      Test.startTest();
       
       QueueSobject qs = [Select Id, SobjectType, Queue.Name from QueueSobject where SobjectType = 'Case' limit 1];
      //create routing config 
      Routing_Configuration__c newConfig1 = new Routing_Configuration__c(Queue_Name__c = qs.Queue.Name ,  Topic1__c='View Claims', SortOrder__C=1,
                               ProfileName__c= 'System Administrator',  RoleName__c= ur.Name,TTS_ExternalID__c='12345' ,TTS_Access__c=ttsAccess1.id );
      Routing_Configuration__c newConfig = new Routing_Configuration__c(Queue_Name__c = qs.Queue.Name ,  Topic1__c='View Claims', SortOrder__C=1,
                               ProfileName__c= 'System Administrator;ACET Member',  RoleName__c= ur.Name,TTS_ExternalID__c='12346' ,TTS_Access__c=ttsAccess2.id );
         Routing_Configuration__c newConfig3 = new Routing_Configuration__c(Queue_Name__c = qs.Queue.Name ,  Topic1__c='View Claims', SortOrder__C=1,
                               ProfileName__c= 'System Administrator',  RoleName__c= ur.Name,TTS_ExternalID__c='12347' ,TTS_Access__c=ttsAccess2.id );
        Routing_Configuration__c newConfig4 = new Routing_Configuration__c(Queue_Name__c = qs.Queue.Name ,  Topic1__c='View Claims', SortOrder__C=1,
                               ProfileName__c= 'System Administrator',CurrentQueue__c='Test', Type__c='Accumulator Inquiry', RoleName__c= ur.Name,TTS_ExternalID__c='12348' ,TTS_Access__c=ttsAccess2.id );
        try
          { 
              insert new List<Routing_Configuration__c>{newConfig1,newConfig,newConfig3,newConfig4} ;    
          }  
          catch(DMlException e)
          {
             
          }
      List<Routing_Configuration__c> newConfigData = [Select Name From Routing_Configuration__c ];
      //System.assert(newConfigData.size() == 0);
      
      Routing_Configuration__c newConfig2 = new Routing_Configuration__c(Queue_Name__c = 'ECMTestQueue' ,  Topic1__c='View Claims', SortOrder__C=1);      
      newConfig2 .ProfileName__c= 'System Administrator;';
      newConfig2.RoleName__c= 'Oxford;';
           
     
     
      try{ 
          insert newConfig2 ;   
      }  
      catch(DMlException e)
      {
          
      }       
      newConfigData = [Select Name From Routing_Configuration__c ];
      System.assert(newConfigData.size()> 0);
     
      Test.stopTest();
   }
   
}