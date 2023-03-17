@IsTest(SeeAllData=true)
public class ProviderHomeTabTest {
    private static final String PROFILENAME = 'System Administrator';
    private static final String TESTUSERNAME = 'test_userr@optum.com';
    private static final String TIMEZONE = 'America/New_York';
    private static final String EMAILENCODINGKEY = 'ISO-8859-1';
    private static final String TESTEMAIL = 'familyLink@optum.com';
    private static final String TSTEMAIL = 'agent1@optum.acet.com';
    private static final String TESTMAIL = 'agent2_acdc_@optum.acet.com';
    private static final String TESTALIAS= 'GDS';
    private static final String TESTLOCALKEYS = 'en_US';
    private static final String TESTFIRSTNAME = 'FirstName';
    private static final String TESTLASTNAME = 'LastName';
    private static final String TESTFILENAME = 'test File';
    private static final String TESTPATHONCLIENT = 'testing.txt';
    private static final String TESTFILETITLE = 'Testing Files';
    private static final String ACCOUNTNAME = 'Test Account';
    private static final String EMAIL ='standarduser@testorg.com';
    private static final String TIMEZONESIDKEY = 'America/Los_Angeles';
    private static final String ASSERTMSG = 'There is no data for the inputs in DB to retirve';
    private static final String DODYSSEY = 'Diagnostic Odyssey';
    static testMethod void providerHomeTabTest() {         
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider_Affiliation').getRecordTypeId();
        Account ac = new Account();
        ac.Member_ID__c = '453543543';
        ac.Policy_ID__c = '0070145';
        ac.Name =   'SampleTEstFLAcc1';
        ac.RecordTypeId = recordTypeId;
        insert ac;
        List<program__c> programList=new List<program__c>();
        Program__c pgm = new Program__c();
        pgm.Program__c = 'Complex Care';
        programList.add(pgm);
        insert programList;
         Id personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
        Account pa =new account();
        pa.PersonBirthdate = date.valueOf(ACETUtility.formatDateFutureDate('6/17/1979'));
        pa.firstName = 'paLastSample1'; 
        pa.lastName = 'paFirstSample1'; 
        pa.RecordTypeId = personAccRecordTypeId;
        insert pa;
        account pa2 = [select id,personcontactid from account where id =: pa.id];
        Profile p = [SELECT Id FROM Profile WHERE Name='Care Advisor Connect Community User']; 
        User u;
        system.runAs(new user(Id = userinfo.getUserId())){
            u = new User(Alias = 'standt', Email='standarduser@testorg.com.acet', 
                              EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', ProfileId = p.Id, 
                              TimeZoneSidKey='America/Los_Angeles', UserName='standarduser45454@testorg.com');
            u.ContactId = pa2.personcontactid;
            insert u;
        }

        Member_Affiliation__c mm = new Member_Affiliation__c();
        mm.Member__c = ac.id;
        mm.Provider__c = u.Accountid;
        mm.Provider_Affiliation__c = ac.id;
        mm.Program__c = programList[0].id;
        mm.Enrollment_Date__c = system.today();
        mm.Status__c = true;
        insert mm;
        Datetime yesterday = Datetime.now().addDays(-20);
        //Test.setCreatedDate(mm.Id, yesterday);  
        Member_Affiliation__c mm1 = new Member_Affiliation__c();
        mm1.Member__c = ac.id;
        mm1.Provider__c = u.Accountid;
        mm1.Provider_Affiliation__c = ac.id;
        mm1.Program__c = programList[0].id;
        mm1.Enrollment_Date__c = system.today();
        mm1.Status__c = true;
        insert mm1;
        ContentVersion cv = new ContentVersion();
        cv.Title = 'Test Document';
        cv.PathOnClient = 'TestDocument.pdf';
        cv.VersionData = Blob.valueOf('Test Content');
        cv.IsMajorVersion = true;
        Insert cv;
        
        //Get Content Documents
        Id conDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cv.Id].ContentDocumentId;
        
        //Create ContentDocumentLink 
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = mm.Id;
        cdl.ContentDocumentId = conDocId;
        cdl.shareType = 'V';
        Insert cdl;
        system.debug('pppp'+mm.Program_Offered__c);

        System.runAs(new user(Id = userinfo.getUserId())){
        SNI_FL_Message__c FLmsg = new SNI_FL_Message__c();
        FLmsg.Member_Id__c = ac.id;
        FLmsg.Program__c = String.ValueOf(ac.id);
        insert FLmsg;
        Id loggedUserid = UserInfo.getUserId();
        SNI_FL_Message_Status__c msgStatus = new SNI_FL_Message_Status__c();
        msgStatus.SNI_FL_Message__c = FLmsg.id;
        msgStatus.Agent__c = loggedUserid;
        insert msgStatus;
		//SELECT Id, Family_ID__c, Feed_Id__c, Member_Id__c, Program__c FROM SNI_FL_Message__c             
        Date myDate = Date.newInstance( 2020, 10, 30 );
		Time myTime = Time.newInstance( 3, 3, 3, 0 );
		DateTime objDT = DateTime.newInstance( myDate, myTime );
        //SNI_FL_DirectMessageTestDataFactory.createDirectMessagesTestData(1,new list<id>{loggedUserid});
        ProviderHomeTab.MessageWrap msgWrap = new ProviderHomeTab.MessageWrap('test',objDT,'testF','testL','System Administrator','Test',ac.id);
        Providerhometab.LastNDays = Date.Today().addDays(-Integer.ValueOf(14));
        Providerhometab.memberdata(ac.id);
            
        Providerhometab.membersdata pp= new Providerhometab.membersdata();
        pp.membername = 'Test';
        pp.doclastmodifiedbyname = 'Test';
        pp.doctitle= 'Test';
        pp.lastmodifieddt= 'Test';
        pp.docdayname= 'Test';

        system.debug('lst of mssgs:' + [SELECT Id, (SELECT id FROM SNI_FL_Message_Statuses__r WHERE Agent__c=:loggedUserid),Feed_Id__c,Member_Id__c FROM SNI_FL_Message__c WHERE Program__c =: ac.id AND Member_Id__c =: ac.id ]);
        }
    }
}