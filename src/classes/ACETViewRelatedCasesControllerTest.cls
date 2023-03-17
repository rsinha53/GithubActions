@istest
public class ACETViewRelatedCasesControllerTest {

 static testMethod void test1() {

  ACETViewRelatedCasesController controller = new ACETViewRelatedCasesController();
  controller.Calltopic = 'Materials Request';
  controller.Pagename = 'testpage';
  controller.ExternalID = 'test123';
  controller.DisplayBtn = false;
 // Contact cont = new Contact();
      RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'Test Contact FN1';
        accountTest.LastName = 'Test Contact LN1';
        accountTest.EID__c = 'TestEID1';
        accountTest.EID__pc = 'TestEID1';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;

    Account accountObj = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact cont = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:accountObj.personcontactid];
        
            
			
 
  Interaction__c interaction = new Interaction__c();
  interaction.Originator__c = cont.Id;
  interaction.Interaction_Type__c = 'Phone Call';
  interaction.Originator_Type__c = 'Member';
  insert interaction;
  controller.Interaction = interaction;

  case c = new
  case ();
  c.status = 'Closed';
  c.ID__c = '35442353700';
  c.Topic__c = 'Materials Request';
  c.Interaction__c = interaction.ID;
  c.Surrogate_Key__c = '12345';
  insert c;



  case c1 = new
  case ();
  c1.status = 'Open';
  c1.parentid = c.id;
  insert c1;
  case cc = [Select CaseNumber,Parent.CaseNumber,Subject_Name__c,CreatedBy.Name,CreatedDate,Topic__c,Status,Originator_Type__c,Interaction_Type__c,Interaction__r.Name,(SELECT Id, Name, ExternalID__c  FROM Work_Items__r ) from Case where id  =: c1.id];
  system.debug('case is '+cc);
  ApexPages.currentPage().getParameters().put('InteractionId', interaction.id);
  //PageReference pageRef = Page.ACETFormsHistory;
  ApexPages.currentPage().getParameters().put('additionalInfo', '{"Zip":null,"UHCBS":null,"surrogatekey":null,"State":null,"SitusState":"CT","ServiceTeam":null,"RiskManagement":null,"RenewalDate":null,"RelationshipType":"Self","Relationship":"Self","RatingMethod":null,"providerType":"HCP","ProductType":"","Product":"Oxford Direct","producerSubject":null,"producerOriginator":null,"producerName":null,"producerId":null,"PolicyNumber":null,"PhoneNumber":null,"OriginatorRelationship":null,"OriginatorDOB":null,"OnshoreIndicatorVerbiage":"No restriction; services allowed onshore and offshore.","OnshoreIndicator":"No","Network":null,"MemberId":"35442353700","LastName":"DAMBROSIO","isMemNotFound":null,"isMember":" false","isGroup":null,"GroupStatus":null,"groupSName":null,"GroupNumber":"1058481","GroupName":"ADVANCED POWER SERVICES LLC","GroupN":null,"Gender":"M","FirstName":"GUY","EndDate":"12/31/9999","EmployerName":null,"EffectiveStartDate":null,"EffectiveDate":"1/1/2017","DOB":"6/7/1981","contactName":"","ConsumerAccountIndicator":null,"BenefitPlanId":"M000000743"}');
  //controller.callTopicDataWrapper = new ACETCallTopicsDataWrapper();

  controller.ViewRelatedCases();

 ACETCallTopicsDataWrapper testis = new ACETCallTopicsDataWrapper();
  //testis.SurrogateKey = '123456';
  // controller.callTopicDataWrapper = new ACETCallTopicsDataWrapper();
ACETCallTopicsDataWrapper acdatawrapper = new ACETCallTopicsDataWrapper();
  acdatawrapper.SurrogateKey = '12345';
  acdatawrapper.AutodocCaseItems = 'test1,test2,test3';
  ACETViewRelatedCasesController acaseobj = new ACETViewRelatedCasesController();
  acaseobj.callTopicDataWrapper = acdatawrapper;
    acaseobj.Calltopic = 'Materials Request';

  acaseobj.ViewRelatedCases();

 }
  static testMethod void testone() {

  ACETViewRelatedCasesController controller = new ACETViewRelatedCasesController();
  controller.Calltopic = 'Materials Request';
  controller.Pagename = 'testpage';
  controller.ExternalID = 'test123';
  controller.DisplayBtn = false;
  /*Contact cont = new Contact();
  cont.FirstName = 'Test';
  cont.LastName = 'Test';
  cont.Tax_ID__c = '123456789';
  insert cont;*/
       RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'Test Contact FN1';
        accountTest.LastName = 'Test Contact LN1';
        accountTest.EID__c = 'TestEID1';
        accountTest.EID__pc = 'TestEID1';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;

    Account accountObj = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact cont = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:accountObj.personcontactid];
        
            
			
  Interaction__c interaction = new Interaction__c();
  interaction.Originator__c = cont.Id;
  interaction.Interaction_Type__c = 'Phone Call';
  interaction.Originator_Type__c = 'Member';
  insert interaction;
  controller.Interaction = interaction;

  case c = new
  case ();
  c.status = 'Closed';
  c.ID__c = '35442353700';
  c.Topic__c = 'Materials Request';
  c.Interaction__c = interaction.ID;
  c.Surrogate_Key__c = '12345';
  insert c;



/*  case c1 = new
  case ();
  c1.status = 'Open';
  c1.parentid = c.id;
  insert c1;
  case cc = [Select CaseNumber,Parent.CaseNumber,Subject_Name__c,CreatedBy.Name,CreatedDate,Topic__c,Status,Originator_Type__c,Interaction_Type__c,Interaction__r.Name,(SELECT Id, Name, ExternalID__c  FROM Work_Items__r ) from Case where id  =: c1.id];
  system.debug('case is '+cc);*/
  ApexPages.currentPage().getParameters().put('InteractionId', interaction.id);
  //PageReference pageRef = Page.ACETFormsHistory;
  ApexPages.currentPage().getParameters().put('additionalInfo', '{"Zip":null,"UHCBS":null,"surrogatekey":null,"State":null,"SitusState":"CT","ServiceTeam":null,"RiskManagement":null,"RenewalDate":null,"RelationshipType":"Self","Relationship":"Self","RatingMethod":null,"providerType":"HCP","ProductType":"","Product":"Oxford Direct","producerSubject":null,"producerOriginator":null,"producerName":null,"producerId":null,"PolicyNumber":null,"PhoneNumber":null,"OriginatorRelationship":null,"OriginatorDOB":null,"OnshoreIndicatorVerbiage":"No restriction; services allowed onshore and offshore.","OnshoreIndicator":"No","Network":null,"MemberId":"35442353700","LastName":"DAMBROSIO","isMemNotFound":null,"isMember":" false","isGroup":null,"GroupStatus":null,"groupSName":null,"GroupNumber":"1058481","GroupName":"ADVANCED POWER SERVICES LLC","GroupN":null,"Gender":"M","FirstName":"GUY","EndDate":"12/31/9999","EmployerName":null,"EffectiveStartDate":null,"EffectiveDate":"1/1/2017","DOB":"6/7/1981","contactName":"","ConsumerAccountIndicator":null,"BenefitPlanId":"M000000743"}');
  //controller.callTopicDataWrapper = new ACETCallTopicsDataWrapper();

  controller.ViewRelatedCases();

 ACETCallTopicsDataWrapper testis = new ACETCallTopicsDataWrapper();
  //testis.SurrogateKey = '123456';
  // controller.callTopicDataWrapper = new ACETCallTopicsDataWrapper();
ACETCallTopicsDataWrapper acdatawrapper = new ACETCallTopicsDataWrapper();
  acdatawrapper.SurrogateKey = '12345';
  acdatawrapper.AutodocCaseItems = 'test1,test2,test3';
  ACETViewRelatedCasesController acaseobj = new ACETViewRelatedCasesController();
  acaseobj.callTopicDataWrapper = acdatawrapper;
    acaseobj.Calltopic = 'Materials Request';

  acaseobj.ViewRelatedCases();

 }

 static testMethod void test2() {
  ACETViewRelatedCasesController controller = new ACETViewRelatedCasesController();
  controller.Calltopic = 'Materials Request';
  controller.DisplayBtn = false;
 /* Contact cont = new Contact();
  cont.FirstName = 'Test';
  cont.LastName = 'Test';
  cont.Tax_ID__c = '123456789';
  insert cont;*/
      RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'Test Contact FN1';
        accountTest.LastName = 'Test Contact LN1';
        accountTest.EID__c = 'TestEID1';
        accountTest.EID__pc = 'TestEID1';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;

    Account accountObj = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact cont = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:accountObj.personcontactid];
        
            
			
  Interaction__c interaction = new Interaction__c();
  interaction.Originator__c = cont.Id;
  interaction.Interaction_Type__c = 'Group/Employer';
  interaction.Originator_Type__c = 'Group/Employer';
  insert interaction;
  controller.Interaction = interaction;

  case c = new
  case ();
  c.status = 'Closed';
  c.ID__c = '35442353700';
  c.Topic__c = 'Materials Request';
  c.Interaction__c = interaction.ID;
  c.Surrogate_Key__c = '12345';
  insert c;



  case c1 = new
  case ();
  c1.status = 'Open';
  c1.parentid = c.id;
  insert c1;

  ApexPages.currentPage().getParameters().put('InteractionId', interaction.id);
  //PageReference pageRef = Page.ACETFormsHistory;
  ApexPages.currentPage().getParameters().put('additionalInfo', '{"Zip":null,"UHCBS":null,"surrogatekey":null,"State":null,"SitusState":"CT","ServiceTeam":null,"RiskManagement":null,"RenewalDate":null,"RelationshipType":"Self","Relationship":"Self","RatingMethod":null,"providerType":"HCP","ProductType":"","Product":"Oxford Direct","producerSubject":null,"producerOriginator":null,"producerName":null,"producerId":null,"PolicyNumber":null,"PhoneNumber":null,"OriginatorRelationship":null,"OriginatorDOB":null,"OnshoreIndicatorVerbiage":"No restriction; services allowed onshore and offshore.","OnshoreIndicator":"No","Network":null,"MemberId":"35442353700","LastName":"DAMBROSIO","isMemNotFound":null,"isMember":" false","isGroup":null,"GroupStatus":null,"groupSName":null,"GroupNumber":"1058481","GroupName":"ADVANCED POWER SERVICES LLC","GroupN":null,"Gender":"M","FirstName":"GUY","EndDate":"12/31/9999","EmployerName":null,"EffectiveStartDate":null,"EffectiveDate":"1/1/2017","DOB":"6/7/1981","contactName":"","ConsumerAccountIndicator":null,"BenefitPlanId":"M000000743"}');
  /*ACETCallTopicsDataWrapper testis = new ACETCallTopicsDataWrapper();
  testis.SurrogateKey = 'null';
  controller.callTopicDataWrapper = new ACETCallTopicsDataWrapper();*/

  ACETCallTopicsDataWrapper acdatawrapper = new ACETCallTopicsDataWrapper();
  acdatawrapper.SurrogateKey = '12345';
  acdatawrapper.AutodocCaseItems = 'test1,test2,test3';
  ACETViewRelatedCasesController acaseobj = new ACETViewRelatedCasesController();
  acaseobj.callTopicDataWrapper = acdatawrapper;
      acaseobj.Calltopic = 'Materials Request';

  acaseobj.ViewRelatedCases();

 }

 static testMethod void test3() {
  ACETViewRelatedCasesController controller = new ACETViewRelatedCasesController();
  controller.Calltopic = 'Materials Request';
  controller.DisplayBtn = false;
 /* Contact cont = new Contact();
  cont.FirstName = 'Test';
  cont.LastName = 'Test';
  cont.Tax_ID__c = '123456789';
  insert cont;*/
      RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'Test Contact FN1';
        accountTest.LastName = 'Test Contact LN1';
        accountTest.EID__c = 'TestEID1';
        accountTest.EID__pc = 'TestEID1';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;

    Account accountObj = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact cont = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:accountObj.personcontactid];
        
            
			
  Interaction__c interaction = new Interaction__c();
  interaction.Originator__c = cont.Id;
  interaction.Interaction_Type__c = 'Phone Call';
  interaction.Originator_Type__c = 'Group/Employer';
  interaction.Group_ID__c = '35442353700';
  insert interaction;
  case c = new
  case ();
  c.status = 'Closed';
  c.ID__c = '35442353700';
  c.Topic__c = 'Materials Request';
  c.Interaction__c = interaction.ID;
  c.Surrogate_Key__c = '12345';
  insert c;



  case c1 = new
  case ();
  c1.status = 'Open';
  c1.parentid = c.id;
  insert c1;

  controller.Interaction = interaction;
  ApexPages.currentPage().getParameters().put('InteractionId', interaction.id);
  //PageReference pageRef = Page.ACETFormsHistory;
  ApexPages.currentPage().getParameters().put('additionalInfo', '{"Zip":null,"UHCBS":null,"surrogatekey":null,"State":null,"SitusState":"CT","ServiceTeam":null,"RiskManagement":null,"RenewalDate":null,"RelationshipType":"Self","Relationship":"Self","RatingMethod":null,"providerType":"HCP","ProductType":"","Product":"Oxford Direct","producerSubject":null,"producerOriginator":null,"producerName":null,"producerId":null,"PolicyNumber":null,"PhoneNumber":null,"OriginatorRelationship":null,"OriginatorDOB":null,"OnshoreIndicatorVerbiage":"No restriction; services allowed onshore and offshore.","OnshoreIndicator":"No","Network":null,"MemberId":"35442353700","LastName":"DAMBROSIO","isMemNotFound":null,"isMember":null,"isGroup":null,"GroupStatus":null,"groupSName":null,"GroupNumber":"1058481","GroupName":"ADVANCED POWER SERVICES LLC","GroupN":null,"Gender":"M","FirstName":"GUY","EndDate":"12/31/9999","EmployerName":null,"EffectiveStartDate":null,"EffectiveDate":"1/1/2017","DOB":"6/7/1981","contactName":"","ConsumerAccountIndicator":null,"BenefitPlanId":"M000000743"}');
 /* controller.callTopicDataWrapper = new ACETCallTopicsDataWrapper();*/

  controller.ViewRelatedCases();
  ACETCallTopicsDataWrapper acdatawrapper = new ACETCallTopicsDataWrapper();
  acdatawrapper.SurrogateKey = '12345';
  acdatawrapper.AutodocCaseItems = 'test1,test2,test3';
  ACETViewRelatedCasesController acaseobj = new ACETViewRelatedCasesController();
  acaseobj.callTopicDataWrapper = acdatawrapper;
      acaseobj.Calltopic = 'Materials Request';

  acaseobj.ViewRelatedCases();

 }

 static testMethod void test4() {
  ACETViewRelatedCasesController controller = new ACETViewRelatedCasesController();
  controller.Calltopic = 'Materials Request';
  controller.DisplayBtn = false;
 /* Contact cont = new Contact();
  cont.FirstName = 'Test';
  cont.LastName = 'Test';
  cont.Tax_ID__c = '123456789';
  insert cont;*/
      RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'Test Contact FN1';
        accountTest.LastName = 'Test Contact LN1';
        accountTest.EID__c = 'TestEID1';
        accountTest.EID__pc = 'TestEID1';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;

    Account accountObj = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact cont = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:accountObj.personcontactid];
        
            
			
  Interaction__c interaction = new Interaction__c();
  interaction.Originator__c = cont.Id;
  interaction.Interaction_Type__c = 'Phone Call';
  interaction.Originator_Type__c = 'Producer';
  insert interaction;

  case c = new
  case ();
  c.status = 'Closed';
  c.ID__c = '35442353700';
  c.Topic__c = 'Materials Request';
  c.Interaction__c = interaction.ID;
  c.Surrogate_Key__c = '12345';
  insert c;



  case c1 = new
  case ();
  c1.status = 'Open';
  c1.parentid = c.id;
  insert c1;

  controller.Interaction = interaction;
  ApexPages.currentPage().getParameters().put('InteractionId', interaction.id);
 /* ACETCallTopicsDataWrapper testis = new ACETCallTopicsDataWrapper();
  testis.SurrogateKey = '1234567';
  */
  ApexPages.currentPage().getParameters().put('additionalInfo', '{"Zip":null,"UHCBS":null,"surrogatekey":null,"State":null,"SitusState":"CT","ServiceTeam":null,"RiskManagement":null,"RenewalDate":null,"RelationshipType":"Self","Relationship":"Self","RatingMethod":null,"providerType":"HCP","ProductType":"","Product":"Oxford Direct","producerSubject":null,"producerOriginator":null,"producerName":null,"producerId":null,"PolicyNumber":null,"PhoneNumber":null,"OriginatorRelationship":null,"OriginatorDOB":null,"OnshoreIndicatorVerbiage":"No restriction; services allowed onshore and offshore.","OnshoreIndicator":"No","Network":null,"MemberId":"35442353700","LastName":"DAMBROSIO","isMemNotFound":null,"isMember":" false","isGroup":null,"GroupStatus":null,"groupSName":null,"GroupNumber":"1058481","GroupName":"ADVANCED POWER SERVICES LLC","GroupN":null,"Gender":"M","FirstName":"GUY","EndDate":"12/31/9999","EmployerName":null,"EffectiveStartDate":null,"EffectiveDate":"1/1/2017","DOB":"6/7/1981","contactName":"","ConsumerAccountIndicator":null,"BenefitPlanId":"M000000743"}');
  //controller.callTopicDataWrapper = new ACETCallTopicsDataWrapper();


  controller.ViewRelatedCases();
  ACETCallTopicsDataWrapper acdatawrapper = new ACETCallTopicsDataWrapper();
  acdatawrapper.SurrogateKey = '12345';
  acdatawrapper.AutodocCaseItems = 'test1,test2,test3';
  ACETViewRelatedCasesController acaseobj = new ACETViewRelatedCasesController();
  acaseobj.callTopicDataWrapper = acdatawrapper;
      acaseobj.Calltopic = 'Materials Request';

  acaseobj.ViewRelatedCases();

 }
 

 static testMethod void test5() {
  ACETViewRelatedCasesController controller = new ACETViewRelatedCasesController();
  controller.Calltopic = 'Materials Request';
  controller.DisplayBtn = false;
 /* Contact cont = new Contact();
  cont.FirstName = 'Test';
  cont.LastName = 'Test';
  cont.Tax_ID__c = '123456789';
  insert cont;*/
      RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'Test Contact FN1';
        accountTest.LastName = 'Test Contact LN1';
        accountTest.EID__c = 'TestEID1';
        accountTest.EID__pc = 'TestEID1';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;

    Account accountObj = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact cont = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:accountObj.personcontactid];
        
            
			
  Interaction__c interaction = new Interaction__c();
  interaction.Originator__c = cont.Id;
  interaction.Interaction_Type__c = 'Phone Call';
  interaction.Originator_Type__c = 'Producer';
  insert interaction;
  controller.Interaction = interaction;
  ApexPages.currentPage().getParameters().put('InteractionId', interaction.id);
  ApexPages.currentPage().getParameters().put('additionalInfo', '{"Zip":null,"UHCBS":null,"surrogatekey":null,"State":null,"SitusState":"CT","ServiceTeam":null,"RiskManagement":null,"RenewalDate":null,"RelationshipType":"Self","Relationship":"Self","RatingMethod":null,"providerType":"HCP","ProductType":"","Product":"Oxford Direct","producerSubject":null,"producerOriginator":null,"producerName":null,"producerId":null,"PolicyNumber":null,"PhoneNumber":null,"OriginatorRelationship":null,"OriginatorDOB":null,"OnshoreIndicatorVerbiage":"No restriction; services allowed onshore and offshore.","OnshoreIndicator":"No","Network":null,"MemberId":"35442353700","LastName":"DAMBROSIO","isMemNotFound":null,"isMember":null,"isGroup":null,"GroupStatus":null,"groupSName":null,"GroupNumber":"1058481","GroupName":"ADVANCED POWER SERVICES LLC","GroupN":null,"Gender":"M","FirstName":"GUY","EndDate":"12/31/9999","EmployerName":null,"EffectiveStartDate":null,"EffectiveDate":"1/1/2017","DOB":"6/7/1981","contactName":"","ConsumerAccountIndicator":null,"BenefitPlanId":"M000000743"}');

  controller.ViewRelatedCases();
  ACETCallTopicsDataWrapper acdatawrapper = new ACETCallTopicsDataWrapper();
  acdatawrapper.SurrogateKey = '12345';
  acdatawrapper.AutodocCaseItems = 'test1,test2,test3';
  ACETViewRelatedCasesController acaseobj = new ACETViewRelatedCasesController();
  acaseobj.callTopicDataWrapper = acdatawrapper;
      acaseobj.Calltopic = 'Materials Request';

  acaseobj.ViewRelatedCases();

 }

 static testMethod void test6() {
  ACETViewRelatedCasesController controller = new ACETViewRelatedCasesController();
  controller.Calltopic = 'Materials Request';
  controller.DisplayBtn = false;
 /* Contact cont = new Contact();
  cont.FirstName = 'Test';
  cont.LastName = 'Test';
  cont.Tax_ID__c = '123456789';
  insert cont;*/
      RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'Test Contact FN1';
        accountTest.LastName = 'Test Contact LN1';
        accountTest.EID__c = 'TestEID1';
        accountTest.EID__pc = 'TestEID1';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;

    Account accountObj = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact cont = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:accountObj.personcontactid];
        
            
			
  Interaction__c interaction = new Interaction__c();
  interaction.Originator__c = cont.Id;
  interaction.Interaction_Type__c = 'Phone Call';
  interaction.Originator_Type__c = 'Producer';
  insert interaction;
  controller.Interaction = interaction;
  ApexPages.currentPage().getParameters().put('InteractionId', interaction.id);
  //PageReference pageRef = Page.ACETFormsHistory;
  ApexPages.currentPage().getParameters().put('additionalInfo', '{"Zip":null,"UHCBS":null,"surrogatekey":null,"State":null,"SitusState":"CT","ServiceTeam":null,"RiskManagement":null,"RenewalDate":null,"RelationshipType":"Self","Relationship":"Self","RatingMethod":null,"providerType":"HCP","ProductType":"","Product":"Oxford Direct","producerSubject":null,"producerOriginator":null,"producerName":null,"producerId":null,"PolicyNumber":null,"PhoneNumber":null,"OriginatorRelationship":null,"OriginatorDOB":null,"OnshoreIndicatorVerbiage":"No restriction; services allowed onshore and offshore.","OnshoreIndicator":"No","Network":null,"MemberId":"35442353700","LastName":"DAMBROSIO","isMemNotFound":null,"isMember":null,"isGroup":"false","GroupStatus":null,"groupSName":null,"GroupNumber":"1058481","GroupName":"ADVANCED POWER SERVICES LLC","GroupN":null,"Gender":"M","FirstName":"GUY","EndDate":"12/31/9999","EmployerName":null,"EffectiveStartDate":null,"EffectiveDate":"1/1/2017","DOB":"6/7/1981","contactName":"","ConsumerAccountIndicator":null,"BenefitPlanId":"M000000743"}');

  controller.ViewRelatedCases();
  ACETCallTopicsDataWrapper acdatawrapper = new ACETCallTopicsDataWrapper();
  acdatawrapper.SurrogateKey = '12345';
  acdatawrapper.AutodocCaseItems = 'test1,test2,test3';
  ACETViewRelatedCasesController acaseobj = new ACETViewRelatedCasesController();
  acaseobj.callTopicDataWrapper = acdatawrapper;
      acaseobj.Calltopic = 'Materials Request';

  acaseobj.ViewRelatedCases();

 }

 static testMethod void test7() {
  ACETViewRelatedCasesController controller = new ACETViewRelatedCasesController();
  controller.Calltopic = 'Materials Request';
  controller.DisplayBtn = false;
 /* Contact cont = new Contact();
  cont.FirstName = 'Test';
  cont.LastName = 'Test';
  cont.Tax_ID__c = '123456789';
  insert cont;*/
      RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'Test Contact FN1';
        accountTest.LastName = 'Test Contact LN1';
        accountTest.EID__c = 'TestEID1';
        accountTest.EID__pc = 'TestEID1';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;

    Account accountObj = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact cont = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:accountObj.personcontactid];
        
            
			
  Interaction__c interaction = new Interaction__c();
  interaction.Originator__c = cont.Id;
  interaction.Interaction_Type__c = 'Phone Call';
  interaction.Originator_Type__c = 'Provider';
  interaction.Group_ID__c = '12345';
  insert interaction;
  case c = new
  case ();
  c.status = 'Closed';
  c.ID__c = '12345';
  c.Topic__c = 'Materials Request';
  c.Interaction__c = interaction.ID;
  c.Surrogate_Key__c = '12345';
  insert c;



  case c1 = new
  case ();
  c1.status = 'Open';
  c1.parentid = c.id;
  insert c1;

  controller.Interaction = interaction;
  ApexPages.currentPage().getParameters().put('InteractionId', interaction.id);
  //PageReference pageRef = Page.ACETFormsHistory;
  ApexPages.currentPage().getParameters().put('additionalInfo', '{"Zip":null,"UHCBS":null,"surrogatekey":"123456","State":null,"SitusState":"CT","ServiceTeam":null,"RiskManagement":null,"RenewalDate":null,"RelationshipType":"Self","Relationship":"Self","RatingMethod":null,"providerType":"HCP","ProductType":"","Product":"Oxford Direct","producerSubject":null,"producerOriginator":null,"producerName":null,"producerId":null,"PolicyNumber":null,"PhoneNumber":null,"OriginatorRelationship":null,"OriginatorDOB":null,"OnshoreIndicatorVerbiage":"No restriction; services allowed onshore and offshore.","OnshoreIndicator":"No","Network":null,"MemberId":"35442353700","LastName":"DAMBROSIO","isMemNotFound":null,"isMember":" false","isGroup":"false","GroupStatus":null,"groupSName":null,"GroupNumber":"1058481","GroupName":"ADVANCED POWER SERVICES LLC","GroupN":null,"Gender":"M","FirstName":"GUY","EndDate":"12/31/9999","EmployerName":null,"EffectiveStartDate":null,"EffectiveDate":"1/1/2017","DOB":"6/7/1981","contactName":"","ConsumerAccountIndicator":null,"BenefitPlanId":"M000000743"}');
 /* ACETCallTopicsDataWrapper testis = new ACETCallTopicsDataWrapper();
  testis.SurrogateKey = '1234567';
  controller.callTopicDataWrapper = new ACETCallTopicsDataWrapper();*/

  controller.ViewRelatedCases();
  ACETCallTopicsDataWrapper acdatawrapper = new ACETCallTopicsDataWrapper();
  acdatawrapper.SurrogateKey = '12345';
  acdatawrapper.AutodocCaseItems = 'test1,test2,test3';
  ACETViewRelatedCasesController acaseobj = new ACETViewRelatedCasesController();
  acaseobj.callTopicDataWrapper = acdatawrapper;
      acaseobj.Calltopic = 'Materials Request';

  acaseobj.ViewRelatedCases();

 }

 static testMethod void test8() {
  ACETViewRelatedCasesController controller = new ACETViewRelatedCasesController();
  controller.Calltopic = 'Materials Request';
  controller.DisplayBtn = false;
  /*Contact cont = new Contact();
  cont.FirstName = 'Test';
  cont.LastName = 'Test';
  cont.Tax_ID__c = '123456789';
  insert cont;*/
      RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'Test Contact FN1';
        accountTest.LastName = 'Test Contact LN1';
        accountTest.EID__c = 'TestEID1';
        accountTest.EID__pc = 'TestEID1';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;

    Account accountObj = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact cont = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:accountObj.personcontactid];
        
            
			
  Interaction__c interaction = new Interaction__c();
  interaction.Originator__c = cont.Id;
  interaction.Interaction_Type__c = 'Phone Call';
  interaction.Originator_Type__c = 'Provider';
  interaction.Group_ID__c = null;
  insert interaction;
  case c = new
  case ();
  c.status = 'Closed';
  c.ID__c = '123456';
  c.Topic__c = 'Materials Request';
  c.Interaction__c = interaction.ID;
  c.Surrogate_Key__c = '12345';
  insert c;



  case c1 = new
  case ();
  c1.status = 'Open';
  c1.parentid = c.id;
  insert c1;

  controller.Interaction = interaction;
  ApexPages.currentPage().getParameters().put('InteractionId', interaction.id);
  //PageReference pageRef = Page.ACETFormsHistory;
  ApexPages.currentPage().getParameters().put('additionalInfo', '{"Zip":null,"UHCBS":null,"surrogatekey":null,"State":null,"SitusState":"CT","ServiceTeam":null,"RiskManagement":null,"RenewalDate":null,"RelationshipType":"Self","Relationship":"Self","RatingMethod":null,"providerType":"HCP","ProductType":"","Product":"Oxford Direct","producerSubject":null,"producerOriginator":null,"producerName":null,"producerId":"123456","PolicyNumber":null,"PhoneNumber":null,"OriginatorRelationship":null,"OriginatorDOB":null,"OnshoreIndicatorVerbiage":"No restriction; services allowed onshore and offshore.","OnshoreIndicator":"No","Network":null,"MemberId":"35442353700","LastName":"DAMBROSIO","isMemNotFound":null,"isMember":" false","isGroup":"false","GroupStatus":null,"groupSName":null,"GroupNumber":"1058481","GroupName":"ADVANCED POWER SERVICES LLC","GroupN":null,"Gender":"M","FirstName":"GUY","EndDate":"12/31/9999","EmployerName":null,"EffectiveStartDate":null,"EffectiveDate":"1/1/2017","DOB":"6/7/1981","contactName":"","ConsumerAccountIndicator":null,"BenefitPlanId":"M000000743"}');
 /* ACETCallTopicsDataWrapper testis = new ACETCallTopicsDataWrapper();
  testis.SurrogateKey = 'null';
  controller.callTopicDataWrapper = new ACETCallTopicsDataWrapper();*/

  controller.ViewRelatedCases();
  ACETCallTopicsDataWrapper acdatawrapper = new ACETCallTopicsDataWrapper();
  acdatawrapper.SurrogateKey = '12345';
  acdatawrapper.AutodocCaseItems = 'test1,test2,test3';
  ACETViewRelatedCasesController acaseobj = new ACETViewRelatedCasesController();
  acaseobj.callTopicDataWrapper = acdatawrapper;
      acaseobj.Calltopic = 'Materials Request';

  acaseobj.ViewRelatedCases();

 }
 static testMethod void test9() {
  ACETViewRelatedCasesController controller = new ACETViewRelatedCasesController();
  controller.Calltopic = 'Materials Request';
  controller.DisplayBtn = false;
  Contact cont = new Contact();
  cont.FirstName = 'Test';
  cont.LastName = 'Test';
  cont.Tax_ID__c = '123456789';
  insert cont;
  Interaction__c interaction = new Interaction__c();
  interaction.Originator__c = cont.Id;
  interaction.Interaction_Type__c = 'Phone Call';
  interaction.Originator_Type__c = 'Provider';
  interaction.Group_ID__c = null;
  insert interaction;
  case c = new
  case ();
  c.status = 'Closed';
  c.ID__c = '35442353700';
  c.Topic__c = 'Materials Request';
  c.Interaction__c = interaction.ID;
  c.Surrogate_Key__c = '12345';
  insert c;



  case c1 = new
  case ();
  c1.status = 'Open';
  c1.parentid = c.id;
  insert c1;

  controller.Interaction = interaction;
  ApexPages.currentPage().getParameters().put('InteractionId', interaction.id);
  //PageReference pageRef = Page.ACETFormsHistory;
  ApexPages.currentPage().getParameters().put('additionalInfo', '{"Zip":null,"UHCBS":null,"surrogatekey":null,"State":null,"SitusState":"CT","ServiceTeam":null,"RiskManagement":null,"RenewalDate":null,"RelationshipType":"Self","Relationship":"Self","RatingMethod":null,"providerType":"HCP","ProductType":"","Product":"Oxford Direct","producerSubject":null,"producerOriginator":null,"producerName":null,"producerId":"123456","PolicyNumber":null,"PhoneNumber":null,"OriginatorRelationship":null,"OriginatorDOB":null,"OnshoreIndicatorVerbiage":"No restriction; services allowed onshore and offshore.","OnshoreIndicator":"No","Network":null,"MemberId":"35442353700","LastName":"DAMBROSIO","isMemNotFound":null,"isMember":" false","isGroup":null,"GroupStatus":null,"groupSName":null,"GroupNumber":"1058481","GroupName":"ADVANCED POWER SERVICES LLC","GroupN":null,"Gender":"M","FirstName":"GUY","EndDate":"12/31/9999","EmployerName":null,"EffectiveStartDate":null,"EffectiveDate":"1/1/2017","DOB":"6/7/1981","contactName":"","ConsumerAccountIndicator":null,"BenefitPlanId":"M000000743"}');
  /*ACETCallTopicsDataWrapper testis = new ACETCallTopicsDataWrapper();
  testis.SurrogateKey = 'null';
  controller.callTopicDataWrapper = new ACETCallTopicsDataWrapper();*/

  controller.ViewRelatedCases();
  ACETCallTopicsDataWrapper acdatawrapper = new ACETCallTopicsDataWrapper();
  acdatawrapper.SurrogateKey = '12345';
  acdatawrapper.AutodocCaseItems = 'test1,test2,test3';
  ACETViewRelatedCasesController acaseobj = new ACETViewRelatedCasesController();
  acaseobj.callTopicDataWrapper = acdatawrapper;
      acaseobj.Calltopic = 'Materials Request';

  acaseobj.ViewRelatedCases();

 }
 static testMethod void test10() {
  ACETViewRelatedCasesController controller = new ACETViewRelatedCasesController();
  controller.Calltopic = 'Materials Request';
  controller.DisplayBtn = false;
 /* Contact cont = new Contact();
  cont.FirstName = 'Test';
  cont.LastName = 'Test';
  cont.Tax_ID__c = '123456789';
  insert cont;*/
      RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        
        Account accountTest = new Account();
        accountTest.FirstName = 'Test Contact FN1';
        accountTest.LastName = 'Test Contact LN1';
        accountTest.EID__c = 'TestEID1';
        accountTest.EID__pc = 'TestEID1';
        accountTest.RecordTypeId = newRecord.Id;
        insert accountTest;

    Account accountObj = [SELECT Id,personcontactid from Account where Id=:accountTest.Id];
        Contact cont = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:accountObj.personcontactid];
        
            
			
  Interaction__c interaction = new Interaction__c();
  interaction.Originator__c = cont.Id;
  interaction.Interaction_Type__c = 'Phone Call';
  interaction.Originator_Type__c = 'Provider';
  interaction.Provider_ID__c = '123456';
  insert interaction;
  case c = new
  case ();
  c.status = 'Closed';
  c.ID__c = '123456';
  c.Topic__c = 'Materials Request';
  c.Interaction__c = interaction.ID;
  c.Surrogate_Key__c = '12345';
  insert c;



  case c1 = new
  case ();
  c1.status = 'Open';
  c1.parentid = c.id;
  c.ID__c = '123456';
  c.Topic__c = 'Materials Request';
  c.Interaction__c = interaction.ID;
  c.Surrogate_Key__c = '12345';
  
  insert c1;

  controller.Interaction = interaction;
  ApexPages.currentPage().getParameters().put('InteractionId', interaction.id);
  //PageReference pageRef = Page.ACETFormsHistory;
  ApexPages.currentPage().getParameters().put('additionalInfo', '{"Zip":null,"UHCBS":null,"surrogatekey":null,"State":null,"SitusState":"CT","ServiceTeam":null,"RiskManagement":null,"RenewalDate":null,"RelationshipType":"Self","Relationship":"Self","RatingMethod":null,"providerType":"HCP","ProductType":"","Product":"Oxford Direct","producerSubject":null,"producerOriginator":null,"producerName":null,"producerId":"123456","PolicyNumber":null,"PhoneNumber":null,"OriginatorRelationship":null,"OriginatorDOB":null,"OnshoreIndicatorVerbiage":"No restriction; services allowed onshore and offshore.","OnshoreIndicator":"No","Network":null,"MemberId":"35442353700","LastName":"DAMBROSIO","isMemNotFound":null,"isMember":null,"isGroup":null,"GroupStatus":null,"groupSName":null,"GroupNumber":"1058481","GroupName":"ADVANCED POWER SERVICES LLC","GroupN":null,"Gender":"M","FirstName":"GUY","EndDate":"12/31/9999","EmployerName":null,"EffectiveStartDate":null,"EffectiveDate":"1/1/2017","DOB":"6/7/1981","contactName":"","ConsumerAccountIndicator":null,"BenefitPlanId":"M000000743"}');
  ACETCallTopicsDataWrapper testis = new ACETCallTopicsDataWrapper();
  testis.SurrogateKey = 'null';
  controller.callTopicDataWrapper = new ACETCallTopicsDataWrapper();

  controller.ViewRelatedCases();
  ACETCallTopicsDataWrapper acdatawrapper = new ACETCallTopicsDataWrapper();
  acdatawrapper.SurrogateKey = '12345';
  acdatawrapper.AutodocCaseItems = 'test1,test2,test3';
  ACETViewRelatedCasesController acaseobj = new ACETViewRelatedCasesController();
  acaseobj.callTopicDataWrapper = acdatawrapper;
      acaseobj.Calltopic = 'Materials Request';

  acaseobj.ViewRelatedCases();

 }


}