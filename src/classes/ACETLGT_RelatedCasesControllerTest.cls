@istest
public class ACETLGT_RelatedCasesControllerTest {

 static testMethod void test1() {


 Test.startTest();
 // Contact cont = new Contact();
      RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account' limit 10];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'Test Contact FN1';
        accountTest.LastName = 'Test Contact LN1';
        accountTest.EID__c = 'TestEID1';
        accountTest.EID__pc = 'TestEID1';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;

    Account accountObj = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact cont = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:accountObj.personcontactid];
        
   List<String> ExternalIDs= new list<String> { '123' , '456' , '555'};         
          
 
  Interaction__c interaction = new Interaction__c();
  interaction.Originator__c = cont.Id;
  interaction.Interaction_Type__c = 'Phone Call';
  interaction.Originator_Type__c = 'Member';
  insert interaction;
 

  case c = new  case ();
  c.status = 'Closed';  
  c.ID__c = '35442353700';
  c.Topic__c = 'Materials Request';
  c.Interaction__c = interaction.ID;
  c.Surrogate_Key__c = '12345';
 // c.Originator_Type__c = 'Member';
  insert c;
  
  case cc = new  case ();
  cc.status = 'Closed';  
  cc.ID__c = '35442353700';
  cc.Topic__c = 'Materials Request';
  cc.Interaction__c = interaction.ID;
  cc.Surrogate_Key__c = '12345';
 // c.Originator_Type__c = 'Member';
  insert cc;
  
    case ccc = new  case ();
  ccc.status = 'Closed';  
  ccc.ID__c = '35442353700';
  ccc.Topic__c = 'Materials Request';
  ccc.Interaction__c = interaction.ID;
  ccc.Surrogate_Key__c = '12345';
 // c.Originator_Type__c = 'Member';
  insert ccc;
  
  case c1 = new  case ();
  c1.status = 'Open'; 
  c1.parentid = c.id;
  insert c1;
  
  case c2 = new  case ();
  c2.status = 'Closed';
  c2.parentid = cc.id;
  insert c2;
  
  case c3 = new  case ();
  c3.status = 'Open';
  c3.parentid = ccc.id;
  insert c3;
  
  Case_Item__c cseitem = new Case_Item__c();
  cseitem.Case__c=c1.id;
  //cseitem.Name= 'test'
  cseitem.ExternalID__c='123';
  insert cseitem;
  
   Case_Item__c cseitem2 = new Case_Item__c();
  cseitem2.Case__c=c2.id;
  //cseitem2.Name= 'test'
  cseitem2.ExternalID__c='456';
  cseitem2.Resolved__c=true;
  cseitem2.Resolved_Reason__c='Completed';
  insert cseitem2;
  
     Case_Item__c cseitem3 = new Case_Item__c();
  cseitem3.Case__c=c3.id;
  //cseitem2.Name= 'test'
  cseitem3.ExternalID__c='456';
  cseitem3.Resolved__c=true;
  cseitem3.Resolved_Reason__c='Completed';
  insert cseitem3;
   
  case cce = [Select CaseNumber,Parent.CaseNumber,Subject_Name__c,CreatedBy.Name,CreatedDate,Topic__c,Status,Originator_Type__c,ParentID,IsClosed,Parent.IsClosed,Interaction_Type__c,Interaction__r.Name,(SELECT Id, Name, ExternalID__c  FROM Work_Items__r ) from Case where id  =: c1.id];
  system.debug('case is '+cce);
  string highlightPanel_String='{"Zip":null,"UHCBS":null,"surrogatekey":null,"State":null,"SitusState":"CT","ServiceTeam":null,"RiskManagement":null,"RenewalDate":null,"RelationshipType":"Self","Relationship":"Self","RatingMethod":null,"providerType":"HCP","ProductType":"","Product":"Oxford Direct","producerSubject":null,"producerOriginator":null,"producerName":null,"producerId":null,"PolicyNumber":null,"PhoneNumber":null,"OriginatorRelationship":null,"OriginatorDOB":null,"OnshoreIndicatorVerbiage":"No restriction; services allowed onshore and offshore.","OnshoreIndicator":"No","Network":null,"MemberId":"35442353700","LastName":"DAMBROSIO","isMemNotFound":null,"isMember":" false","isGroup":null,"GroupStatus":null,"groupSName":null,"GroupNumber":"1058481","GroupName":"ADVANCED POWER SERVICES LLC","GroupN":null,"Gender":"M","FirstName":"GUY","EndDate":"12/31/9999","EmployerName":null,"EffectiveStartDate":null,"EffectiveDate":"1/1/2017","DOB":"6/7/1981","contactName":"","ConsumerAccountIndicator":null,"BenefitPlanId":"M000000743"}';
 ACETLGT_RelatedCasesController  relcse = new ACETLGT_RelatedCasesController ();
 ACETLGT_RelatedCasesController.getRelatedCases(interaction.id , 'Phone Call', 'Materials Request',ExternalIDs,'12345',highlightPanel_String);
 ACETLGT_RelatedCasesController.getProfileUser();
	Test.stopTest();
 ACETLGT_RelatedCasesController.getParentCaseInfo(c.id);				 
 }
  static testMethod void testone() {
   RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account' limit 10];
          Test.startTest();

        Account accountTest = new Account();
        accountTest.FirstName = 'Test Contact FN1';
        accountTest.LastName = 'Test Contact LN1';
        accountTest.EID__c = 'TestEID1';
        accountTest.EID__pc = 'TestEID1';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;

    Account accountObj = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
   Contact cont = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:accountObj.personcontactid];
  List<String> ExternalIDs= new list<String> { '123' , '456' , '555'};           
  Interaction__c interaction = new Interaction__c();
  interaction.Originator__c = cont.Id;
  interaction.Interaction_Type__c = 'Phone Call';
  interaction.Originator_Type__c = 'Member';
  insert interaction;
  

  case c = new  case ();
  c.status = 'Closed';
  c.ID__c = '35442353700';
  c.Topic__c = 'Materials Request';
  c.Interaction__c = interaction.ID;
  c.Surrogate_Key__c = '12345';
  insert c;
    Test.stopTest();

   string highlightPanel_String='{"Zip":null,"UHCBS":null,"surrogatekey":null,"State":null,"SitusState":"CT","ServiceTeam":null,"RiskManagement":null,"RenewalDate":null,"RelationshipType":"Self","Relationship":"Self","RatingMethod":null,"providerType":"HCP","ProductType":"","Product":"Oxford Direct","producerSubject":null,"producerOriginator":null,"producerName":null,"producerId":null,"PolicyNumber":null,"PhoneNumber":null,"OriginatorRelationship":null,"OriginatorDOB":null,"OnshoreIndicatorVerbiage":"No restriction; services allowed onshore and offshore.","OnshoreIndicator":"No","Network":null,"MemberId":"35442353700","LastName":"DAMBROSIO","isMemNotFound":null,"isMember":" false","isGroup":null,"GroupStatus":null,"groupSName":null,"GroupNumber":"1058481","GroupName":"ADVANCED POWER SERVICES LLC","GroupN":null,"Gender":"M","FirstName":"GUY","EndDate":"12/31/9999","EmployerName":null,"EffectiveStartDate":null,"EffectiveDate":"1/1/2017","DOB":"6/7/1981","contactName":"","ConsumerAccountIndicator":null,"BenefitPlanId":"M000000743"}';
 ACETLGT_RelatedCasesController  relcse = new ACETLGT_RelatedCasesController ();  
 ACETLGT_RelatedCasesController.getRelatedCases(interaction.id , 'Phone Call', 'Materials Request',ExternalIDs,'12345',highlightPanel_String);
 ACETLGT_RelatedCasesController.getProfileUser();
 ACETLGT_RelatedCasesController.getParentCaseInfo(c.id);

 }
 }