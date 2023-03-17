@istest
private class ACETLGT_SubjectDetailControllerTest{
    static testMethod void ACETLGT_SubjectDetailControllerTest1(){
          Contact cont = new Contact();
          cont.FirstName = 'Test';
          cont.LastName = 'Test';
          cont.Tax_ID__c = '123456789';
          insert cont;
          
          Interaction__c interaction = new Interaction__c();
          interaction.Originator__c = cont.Id;
          interaction.Interaction_Type__c = 'Phone Call';
          interaction.Originator_Type__c = 'Member';
          insert interaction;
          
           Interaction__c interaction1 = new Interaction__c();
          interaction1.Originator__c = cont.Id;
          interaction1.Interaction_Type__c = 'Phone Call';
          interaction1.Originator_Type__c = 'Broker';
          insert interaction1;
          
           Interaction__c interaction2 = new Interaction__c();
          interaction2.Originator__c = cont.Id;
          interaction2.Interaction_Type__c = 'Phone Call';
          interaction2.Originator_Type__c = 'Producer';
          insert interaction2;
          
           Interaction__c interaction3 = new Interaction__c();
          interaction3.Originator__c = cont.Id;
          interaction3.Interaction_Type__c = 'Phone Call';
          interaction3.Originator_Type__c = 'Provider';
          insert interaction3;
         
        
          case c = new  case ();
          c.status = 'Closed';
          c.ID__c = '35442353700';
          c.Topic__c = 'Materials Request';
          c.Interaction__c = interaction.ID;
          c.Surrogate_Key__c = '12345';        
          insert c;
          
          case c1 = new  case ();
          c1.status = 'Closed';
          c1.ID__c = '35442353700';
          c1.Topic__c = 'Materials Request';
          c1.Interaction__c = interaction1.ID;
          c1.Surrogate_Key__c = '12345';          
          insert c1;
          
          case c2 = new  case ();
          c2.status = 'Closed';
          c2.ID__c = '35442353700';
          c2.Topic__c = 'Materials Request';
          c2.Interaction__c = interaction2.ID;
          c2.Surrogate_Key__c = '12345';        
          insert c2;
          
          case c3 = new  case ();
          c3.status = 'Closed';
          c3.ID__c = '35442353700';
          c3.Topic__c = 'Materials Request';
          c3.Interaction__c = interaction3.ID;
          c3.Surrogate_Key__c = '12345';        
          insert c3;
          
          ACETLGT_SubjectDetailController.getrecorddata(c.id); 
          ACETLGT_SubjectDetailController.getrecorddata(c1.id); 
          ACETLGT_SubjectDetailController.getrecorddata(c2.id); 
          ACETLGT_SubjectDetailController.getrecorddata(c3.id); 
    }
 }