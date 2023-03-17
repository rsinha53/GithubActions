@istest(seeAllData=true)
private class ECMEntitlementAssignmentUtilityTest{
     static testMethod void testwrapper(){
         EntitlementWrapper ew = new EntitlementWrapper();
         ew.entitlementId = 'entid123';
         ew.entitlementName='wntname';
         ew.externalId='ententid';
         ew.ttsId='ttsid';
    }
      static testMethod void createTestData(){
          //create Test Profile
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
    
   static testMethod void validateEntAssignmentData (){ 
      Test.startTest();
       List<EntitlementAssignment__c > newEntAssign;
      //create Accout
      Account uhg = new Account(name='UHG');
      insert uhg;
      
      //create Entitlement
      Entitlement twoDaysEntitlement = new Entitlement (Name='2 Business Days', AccountId= uhg.id  );
      insert  twoDaysEntitlement ;
        
        TTS_Access__c tts = new TTS_Access__c(
        Topic__c = 'Appeal'
        );
        insert tts;
        
          
      //create entitlement assignment 
      EntitlementAssignment__c entAssign = new EntitlementAssignment__c(
          TTS_Access__c = tts.Id,
          EntitlementName__c= twoDaysEntitlement .id ,  
          SortOrder__c=2986,
          ProfileName__c= 'TestProfile',
          RoleName__c= 'Test Role',
          Topic1__c = 'ACC'
             
      );
     
      try{ 
          insert entAssign ;    
      }  
      catch(DMlException e){
          newEntAssign = [Select Name From EntitlementAssignment__c ];
          System.assert(newEntAssign.size() == 0);         
      }

      
      entAssign.ProfileName__c= 'System Administrator';
      entAssign.RoleName__c= 'Oxford';
       
           
      try{ 
          insert entAssign;   
      }  
      catch(DMlException e)
      {
          
      }       
      newEntAssign = [Select Name From EntitlementAssignment__c];
      System.assert(newEntAssign .size()> 0);
     
      Test.stopTest();
   }
    
     static testMethod void validateEntAssignmentDataone (){ 
      Test.startTest();
       List<EntitlementAssignment__c > newEntAssign;
      //create Accout
      Account uhg = new Account(name='UHG');
      insert uhg;
      
      //create Entitlement
      Entitlement twoDaysEntitlement = new Entitlement (Name='2 Business Days', AccountId= uhg.id  );
      insert  twoDaysEntitlement ;
          
      //create entitlement assignment 
      EntitlementAssignment__c entAssign = new EntitlementAssignment__c(
          EntitlementName__c= twoDaysEntitlement .id ,  
          SortOrder__c=2986,
          ProfileName__c= 'TestProfile',
          RoleName__c= 'Test Role'
             
      );
     
      try{ 
          insert entAssign ;    
      }  
      catch(DMlException e){
          newEntAssign = [Select Name From EntitlementAssignment__c ];
          System.assert(newEntAssign.size() == 0);         
      }
      entAssign.ProfileName__c= 'System Administrator';
      entAssign.RoleName__c= 'Oxford';
       
       
      try{ 
          insert entAssign;   
      }  
      catch(DMlException e)
      {
          system.debug('Excetion DML==>'+e);
      }       
      newEntAssign = [Select Name From EntitlementAssignment__c];
      System.assert(newEntAssign .size()> 0);
     
      Test.stopTest();
   }  
       
    static testMethod void validateEntAssignmentDatatwo (){ 
      Test.startTest();
       List<EntitlementAssignment__c > newEntAssign;
      //create Accout
      Account uhg = new Account(name='UHG');
      insert uhg;
      
      //create Entitlement
      Entitlement twoDaysEntitlement = new Entitlement (Name='2 Business Days', AccountId= uhg.id  );
      insert  twoDaysEntitlement ;
          
      //create entitlement assignment 
     
        list<TTS_Access__c> ttalst = new list<TTS_Access__c>();
     TTS_Access__c tta = new TTS_Access__c();
      tta.TTSAccessExternalID__c ='test12345';
        tta.Limit_To_Profiles__c='System Administrator';
        tta.Limit_To_Roles__c='System Administrator';
        tta.topic__c='View Claims';
        tta.type__c='Billing';
      try{ 
          insert tta;
           
          ttalst.add(tta);
      }  
      catch(DMlException e){
          system.debug('in 155 test class' +e.getMessage());
          newEntAssign = [Select Name,TTS_ExternalID__c  From EntitlementAssignment__c ];
          System.assert(newEntAssign.size() == 0);         
      }
         EntitlementAssignment__c entAssign = new EntitlementAssignment__c(
          EntitlementName__c= twoDaysEntitlement.id ,  
	       Topic1__c = 'View Claims',
           Type__c = 'Billing', 
          SortOrder__c=2986,
          ProfileName__c= 'TestProfile',
          RoleName__c= 'Test Role',
          TTS_ExternalID__c ='test12345',
          TTS_Access__c = tta.id
      );

      
      //entAssign.ProfileName__c= 'System Administrator';
      //entAssign.RoleName__c= 'Oxford';
       
           
      try{ 
          insert entAssign;   
      }  
      catch(DMlException e)
      {
         system.debug('in catch 178 '+e.getMessage()); 
      }       
      newEntAssign = [Select Name,TTS_ExternalID__c From EntitlementAssignment__c];
    
system.debug('size==>'+newEntAssign .size());
        ECMEntitlementAssignmentUtility.validateData(newEntAssign);
      Test.stopTest();
        
        
   }

/*   static testMethod void ttsconditioncheck(){
            test.startTest();
       
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
       
        
    //     UserRole uRole = new UserRole(Name='Oxford');
     //     insert uROle;
       
       System.runAs ( new User(Id = UserInfo.getUserId()) ) {
    insert ecmTestUser ;
}
       
      Account uhg = new Account(name='UHG');
      insert uhg;
      
        Entitlement twoDaysEntitlement = new Entitlement (Name='2 Business Days', AccountId= uhg.id  );
      insert  twoDaysEntitlement ;
               
       
        TTS_Access__c tts = new TTS_Access__c(
        Topic__c = 'Appeal'
        );
        insert tts;
        
          
      //create entitlement assignment 
      EntitlementAssignment__c entAssign = new EntitlementAssignment__c(
          TTS_Access__c = tts.Id,
          EntitlementName__c= twoDaysEntitlement .id ,  
          SortOrder__c=2986,
          ProfileName__c= 'TestProfile',
          RoleName__c= 'Test Role',
          Topic1__c = 'ACC'
             
      );
       insert entAssign;
            test.stopTest();
        } */
}