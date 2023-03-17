@isTest
public class TestDataFactory{
    //Test Data//
    public static Contact createContact(){
        Contact con = new Contact();
        con.FirstName = 'TestFname';
        con.lastname = 'TestLName';
        con.Tax_ID__c = '123456';
        con.NPI__c = '123457';
        //con.EID__c = ''+randomWithLimit(4000);
        insert con;
        
        return con;
    }
    Public static List<Account> CreateBulkPersonAccount(){
    RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
    list<account> acclist = new list<account>();
            for(Integer i=0; i< 10 ; i++){
        Account accountTest = new Account();
        accountTest.FirstName = 'TestFirst1'+i;
        accountTest.LastName = 'TestLast';
        accountTest.EID__c = '12345'+i;
        accountTest.EID__pc = '12345'+i;
        accountTest.RecordTypeId = newRecord.Id;
        acclist.add(accountTest);
        }
        insert acclist;
        return acclist;
    }
    Public static Account CreatePersonAccount(){
    RecordType newRecord = [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
    
        Account accountTest1 = new Account();
        accountTest1.FirstName = 'TestFirst';
        accountTest1.LastName = 'TestLast';
        accountTest1.EID__c = '12345';
        accountTest1.EID__pc = '12345';
        accountTest1.RecordTypeId = newRecord.Id;
        
        insert accountTest1;
        return accountTest1;
    }
    public static List<Contact> createBulkContact(){
    List<Contact> lstContact = new List<Contact>();
    for(Integer i=0; i< 10 ; i++){
      Contact objCon = new Contact();
      objCon.FirstName = 'TestName'+i;
      objCon.lastname = 'TestLName'+i;
      objCon.Tax_ID__c = '123456';
      objCon.NPI__c = '123457';
      //objCon.RecordType.Name = 'Member';
      lstContact.add(objCon);
    }
      insert lstContact;
      return lstContact;
    }
    public static List<Account> createBulkAccounts(){
    List<Account> lstAcc = new List<Account>();
    for(Integer i=0; i< 10 ; i++){
      Account objAcc = new Account();
      //objAcc.FirstName = 'TestName'+i;
      objAcc.name = 'TestLName'+i;
      //objCon.Tax_ID__c = '123456';
      //objCon.NPI__c = '123457';
      //objCon.RecordType.Name = 'Member';
      lstAcc.add(objAcc );
    }
      insert lstAcc;
      return lstAcc;
    }
    public static Contact createContactwithEID(){
        Contact con = new Contact();
        con.FirstName = 'Test Fname';
        con.lastname = 'Test LName';
        con.Tax_ID__c = '123456';
        con.NPI__c = '123457';
        con.EID__c = ''+randomWithLimit(4000);
        insert con;
        
        return con;
    }
    public static Interaction__c createInteraction () {
        String JSONStr = '{"UHCBS":"","GroupN":"Test Group Name","GroupStatus":"Active","ServiceTeam":"NY Large","EffectiveStartDate":"3/1/2016","RiskManagement":"Rating Method","RatingMethod":"Support","RenewalDate":"3/1/2016","RelationshipType":"Mother","groupSName":"Test GroupName"}';
        Interaction__c inte = new Interaction__c();
        inte.Originator__c = createContact().id;
        inte.Originator_Type__c = 'Member';
        inte.Highlight_Panel_GroupInfo__c = JSONStr;
        insert inte;
        
        return inte;
    }
    public static Interaction__c createInteractionNoContact () {
        String JSONStr = '{"UHCBS":"","GroupN":"Test Group Name","GroupStatus":"Active","ServiceTeam":"NY Large","EffectiveStartDate":"3/1/2016","RiskManagement":"Rating Method","RatingMethod":"Support","RenewalDate":"3/1/2016","RelationshipType":"Mother","groupSName":"Test GroupName"}';
        Interaction__c inte = new Interaction__c();
        inte.Originator_Type__c = 'Member';
        inte.Highlight_Panel_GroupInfo__c = JSONStr;
        insert inte;
        
        return inte;
    }    
    public static List<Interaction__c> createBulkInteraction () {
       List<Interaction__c> lstInteraction = new List<Interaction__c>();
         for(Integer i=0; i< 15; i++){
        String JSONStr = '{"UHCBS":"","GroupN":"Test Group Name","GroupStatus":"Active","ServiceTeam":"NY Large","EffectiveStartDate":"3/1/2016","RiskManagement":"Rating Method","RatingMethod":"Support","RenewalDate":"3/1/2016","RelationshipType":"Mother","groupSName":"Test GroupName"}';
        Interaction__c inte = new Interaction__c();
        inte.Originator__c = createContact().id;
        inte.Originator_Type__c = 'Member';
        inte.Highlight_Panel_GroupInfo__c = JSONStr;
        lstInteraction.add(inte);
        }
        //insert inte;
        insert lstInteraction;
        return lstInteraction;
    }
    public static string createACETHighlightsPanelAdditionalInfo(){
        ACETHighlightsPanelAdditionalInfo jsonReq = new ACETHighlightsPanelAdditionalInfo();
        jsonReq.Relationship='Test';   
        jsonReq.SitusState='Test';
        jsonReq.DOB='09/28/2016';
        jsonReq.EndDate='09/28/2016';
        jsonReq.EffectiveDate='09/28/2016';
        jsonReq.PolicyNumber='12345';
        jsonReq.GroupName='Test';
        jsonReq.Product='Test';
        jsonReq.ProductType='Test';
        jsonReq.Network='Test';
        jsonReq.ConsumerAccountIndicator='Test';
        
        String additionalInfoStr  = JSON.serialize(jsonReq);
        return additionalInfoStr;
    }
     public static ISL_Webservice_Config__c CreateISLWebserviceCS(String name,String value) {
        ISL_Webservice_Config__c cs = new ISL_Webservice_Config__c();
        cs.name = name;
        cs.value__c = value;
        return cs;
    }
    public static User getUser(String profile){
        Profile p = [SELECT Id FROM Profile WHERE Name=:profile]; 
      User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='America/Los_Angeles', UserName= profile.deleteWhitespace()+'@testorg.com');
      
      return u;     
    }
    
    public static Integer randomWithLimit(Integer upperLimit){
        Integer rand = Math.round(Math.random()*1000);
        return Math.mod(rand, upperLimit);
    }
  public static List<Case> createCases(Integer numCase) {
        List<Case> caseList = new List<Case>();
        for(Integer iCnt =0; icnt<numCase; iCnt++){
            Case cas = new Case();
            caseList.add(cas);
        }

        return caseList;
    }
    
     public static Case createCase(){
        Case cas = new Case();
        cas.Status = 'Open';
        insert cas;
       
        return cas;
    }
     Public static Account CreateAccount(){
    
        Account accountTest1 = new Account();
        accountTest1.FirstName = 'TestFirst';
        accountTest1.LastName = 'TestLast';
        accountTest1.EID__c = '12345';
        accountTest1.EID__pc = '12345';
        
        insert accountTest1;
        return accountTest1;
    }
    
    public static Case createCaseandCaseItem() {
        Case cas = new Case();
        cas.Status = 'Open';
        insert cas;
        Case_Item__c caseItem = new Case_Item__c();
        caseItem.Resolved__c = false;
        caseItem.case__c = cas.id;
        insert caseItem;
        return cas;
    }
    
    Public static Member_Information__c CreateMemberInformation(Account acc) {
    	Member_Information__c mi = new Member_Information__c();
        mi.Name = acc.Name + ' Member Information';
        mi.Account__c = acc.id;
        insert mi;
        return mi;
    }
    
}