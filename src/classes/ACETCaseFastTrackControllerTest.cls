@istest
private class ACETCaseFastTrackControllerTest {
    static testMethod void testController(){
        Third_Party__c thirdparty  = new Third_Party__c ();
        thirdparty.Flow_Name__c = 'ProviderNotFoundFlow';
        insert thirdparty ;
        Interaction__c interaction = new Interaction__c();
        interaction.Third_Party__c =thirdparty.id;
         interaction.Originator_Type__c ='Other';
       
        
        Interaction__c interaction1 = new Interaction__c();
        interaction1.Third_Party__c =thirdparty.id;
         interaction1.Originator_Type__c ='Provider';
       
        insert interaction;
         insert interaction1;
        Case c = new Case();
        c.Interaction__c = interaction.Id;
     
        insert c;
         Case c1 = new Case();
        c1.Interaction__c = interaction1.Id;
     c1.AutoDoc__c   = '<div class="highlights-panel-collapsible">tes<div class="highlights-panel-collapsible"><table width="100%" cellspacing="10"><label class="outputLabelPanel">Phone Number</label><table width="100%" cellspacing="10"><label class="outputLabelPanel">Phone Number</label><label class="outputLabelPanel">1<label class="outputLabelPanel">2Phone Number<label class="outputLabelPanel">3Phone Number</span>';
        insert c1;
         
        ContentVersion contentVersion = new ContentVersion(
  Title = 'Penguins',
  PathOnClient = 'Penguins.jpg',
  VersionData = Blob.valueOf('Test Content'),
  IsMajorVersion = true
);
insert contentVersion;    
List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];

//create ContentDocumentLink  record 
ContentDocumentLink cdl = New ContentDocumentLink();
cdl.LinkedEntityId = c1.id;
cdl.ContentDocumentId = documents[0].Id;
cdl.shareType = 'V';
insert cdl;
    List<ContentDocumentLink> contdoc = new List<ContentDocumentLink>(); 
        contdoc.add(cdl);
        
                
        
        Test.startTest();
        system.currentPageReference().getParameters().put('caseId', c.Id);
        system.currentPageReference().getParameters().put('messagecode', 'MNO51');

        ACETCaseFastTrackController stub = new ACETCaseFastTrackController();
         stub.getHpAdditionInfoStr();
         stub.messageClass();
        system.currentPageReference().getParameters().put('caseId', c1.Id);
        ACETCaseFastTrackController stub1 = new ACETCaseFastTrackController();
         stub1.getHpAdditionInfoStr();
        
      //  update interaction;
    //   stub.getHpAdditionInfoStr();
        
        try{
            ACETCaseFastTrackController.findMember(''); 
        }catch(Exception ex){}
        
        try{
            ACETCaseFastTrackController.findGroup('');  
        }catch(Exception ex){}
        
        try{
            ACETCaseFastTrackController.findProvider('','',''); 
        }catch(Exception ex){}
        
        try{
            ACETCaseFastTrackController.findProducer('');   
        }catch(Exception ex){}
        Test.stopTest();
    }    
    static testMethod void testControllerone(){
        Third_Party__c thirdparty  = new Third_Party__c ();
        thirdparty.Flow_Name__c = 'GroupNotFoundFlow';
        insert thirdparty ;
        Interaction__c interaction = new Interaction__c();
        interaction.Third_Party__c =thirdparty.id;
         interaction.Originator_Type__c ='Other';
       
        
        Interaction__c interaction1 = new Interaction__c();
        interaction1.Third_Party__c =thirdparty.id;
         interaction1.Originator_Type__c ='Provider';
       
        insert interaction;
         insert interaction1;
        Case c = new Case();
        c.Interaction__c = interaction.Id;
     
        insert c;
         Case c1 = new Case();
        c1.Interaction__c = interaction1.Id;
     c1.AutoDoc__c   = '<div class="highlights-panel-collapsible">tes<div class="highlights-panel-collapsible"><table width="100%" cellspacing="10"><label class="outputLabelPanel">Phone Number</label><table width="100%" cellspacing="10"><label class="outputLabelPanel">Phone Number</label><label class="outputLabelPanel">1<label class="outputLabelPanel">2Phone Number<label class="outputLabelPanel">3Phone Number</span>';
        insert c1;
         
        ContentVersion contentVersion = new ContentVersion(
  Title = 'Penguins',
  PathOnClient = 'Penguins.jpg',
  VersionData = Blob.valueOf('Test Content'),
  IsMajorVersion = true
);
insert contentVersion;    
List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];

//create ContentDocumentLink  record 
ContentDocumentLink cdl = New ContentDocumentLink();
cdl.LinkedEntityId = c1.id;
cdl.ContentDocumentId = documents[0].Id;
cdl.shareType = 'V';
insert cdl;
        
   List<ContentDocumentLink> attachAutoDoc = [select ContentDocumentId,LinkedEntityId from ContentDocumentLink where LinkedEntityId=:cdl.id];
                
        
        Test.startTest();
        system.currentPageReference().getParameters().put('caseId', c.Id);
        system.currentPageReference().getParameters().put('messagecode', 'MNO51');

        ACETCaseFastTrackController stub = new ACETCaseFastTrackController();
         stub.getHpAdditionInfoStr();
         stub.messageClass();
        system.currentPageReference().getParameters().put('caseId', c1.Id);
        ACETCaseFastTrackController stub1 = new ACETCaseFastTrackController();
         stub1.getHpAdditionInfoStr();
        
      //  update interaction;
    //   stub.getHpAdditionInfoStr();
        
        try{
            ACETCaseFastTrackController.findMember(''); 
        }catch(Exception ex){}
        
        try{
            ACETCaseFastTrackController.findGroup('');  
        }catch(Exception ex){}
        
        try{
            ACETCaseFastTrackController.findProvider('','',''); 
        }catch(Exception ex){}
        
        try{
            ACETCaseFastTrackController.findProducer('');   
        }catch(Exception ex){}
        Test.stopTest();
    }  
    static testMethod void testControllertwo(){
        Third_Party__c thirdparty  = new Third_Party__c ();
        thirdparty.Flow_Name__c = 'ProducerNotFoundFlow';
        insert thirdparty ;
        Interaction__c interaction = new Interaction__c();
        interaction.Third_Party__c =thirdparty.id;
         interaction.Originator_Type__c ='Other';
       
        
        Interaction__c interaction1 = new Interaction__c();
        interaction1.Third_Party__c =thirdparty.id;
         interaction1.Originator_Type__c ='Provider';
       
        insert interaction;
         insert interaction1;
        Case c = new Case();
        c.Interaction__c = interaction.Id;
     
        insert c;
         Case c1 = new Case();
        c1.Interaction__c = interaction1.Id;
     c1.AutoDoc__c   = '<div class="highlights-panel-collapsible">tes<div class="highlights-panel-collapsible"><table width="100%" cellspacing="10"><label class="outputLabelPanel">Phone Number</label><table width="100%" cellspacing="10"><label class="outputLabelPanel">Phone Number</label><label class="outputLabelPanel">1<label class="outputLabelPanel">2Phone Number<label class="outputLabelPanel">3Phone Number</span>';
        insert c1;
         
        ContentVersion contentVersion = new ContentVersion(
  Title = 'Penguins',
  PathOnClient = 'Penguins.jpg',
  VersionData = Blob.valueOf('Test Content'),
  IsMajorVersion = true
);
insert contentVersion;    
List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];

//create ContentDocumentLink  record 
ContentDocumentLink cdl = New ContentDocumentLink();
cdl.LinkedEntityId = c1.id;
cdl.ContentDocumentId = documents[0].Id;
cdl.shareType = 'V';
insert cdl;
        
   List<ContentDocumentLink> attachAutoDoc = [select ContentDocumentId,LinkedEntityId from ContentDocumentLink where LinkedEntityId=:cdl.id];
                
        
        Test.startTest();
        system.currentPageReference().getParameters().put('caseId', c.Id);
        system.currentPageReference().getParameters().put('messagecode', 'MNO51');

        ACETCaseFastTrackController stub = new ACETCaseFastTrackController();
         stub.getHpAdditionInfoStr();
         stub.messageClass();
        system.currentPageReference().getParameters().put('caseId', c1.Id);
        ACETCaseFastTrackController stub1 = new ACETCaseFastTrackController();
         stub1.getHpAdditionInfoStr();
        
      //  update interaction;
    //   stub.getHpAdditionInfoStr();
        ACETFindProducerAPI AFPA = new ACETFindProducerAPI();
        AFPA.GetRequestBody();
        try{
            ACETCaseFastTrackController.findMember(''); 
        }catch(Exception ex){}
        
        try{
            ACETCaseFastTrackController.findGroup('');  
        }catch(Exception ex){}
        
        try{
            ACETCaseFastTrackController.findProvider('','',''); 
        }catch(Exception ex){}
        
        try{
            ACETCaseFastTrackController.findProducer('');   
        }catch(Exception ex){}
        Test.stopTest();
    }   
}