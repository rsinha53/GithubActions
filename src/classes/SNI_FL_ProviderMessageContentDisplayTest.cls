@isTest(SEEALLDATA = TRUE)
public class SNI_FL_ProviderMessageContentDisplayTest {
    private static final String TSTPROGRAM = 'Complex Care';
    private static final String PROVIDERAFF = 'TestHospital-Complex Care-Adult';
    private static final String FECPROFILE = 'Center for Health Navigation';
    private static final String TSTEMAIL = 'agent1@optum.acet.com';
    private static final String TESTEMAIL = 'agent2_acdc_@optum.acet.com';
    private static final String TIMEZONE = 'America/New_York';
    private static final String EMAILENCODE = 'ISO-8859-1';
    private static final String ACCTEAM = 'Account Team Member';
    private static final String TSTMSG = 'Related provider affliation record not recieved';
    private static final String FNAME = 'Test FName';
    private static final String LNAME = 'Test LName';
    private static final String YAHOOMAIL = 'test@yahoo.com';
    private static final String RELATEDTO = 'Related To';
    private static final String TESTUSERMAIL = 'test@user.com';
    private static final String NODATA = 'There is no data for the inputs in DB to retirve';
    private static final String UNAME = 'agent1_acdc_@optum.acet.com';
    private static final String PFEMPTY = 'provider affliation record are empty';
    
    private static final String USERNAME = 'agent11_acdc_@optum.acet.com';
    
    @isTest 
    static void SNI_FL_ProviderMessageContentDisplayTestMethod(){
        string userId = UserInfo.getUserId();
        Id pgrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider_Group').getRecordTypeId();
        Id providerUserRecordId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider_User').getRecordTypeId();
        
        //Provider group acccount
        Account pg = new Account();
        pg.RecordTypeId= pgrecordTypeId;
        pg.Name = 'TestHospital';
        insert pg;
        
        Account ac= new Account(
            RecordTypeID=providerUserRecordId ,
            FirstName=FNAME,
            LastName=LNAME,
            Provider_Group__c=pg.id,
            PersonMailingStreet='flowerStreet',
            PersonMailingPostalCode='12345',
            PersonMailingCity='SFO',
            PersonEmail=YAHOOMAIL,
            PersonHomePhone='1234567',
            PersonMobilePhone='12345678'
        );
        insert ac;
        
        Case c = new Case(Subject='Test Case', Status = 'New');
        insert c;

        FeedItem f = new FeedItem(ParentId=c.Id, Body='Test Post');
        insert f;
        String feedID = f.id;
        
        List<FeedComment> fcList = new List<FeedComment>();
        FeedComment fc = new FeedComment(CommentBody='Test Comment',FeedItemId = f.Id);
        fcList.add(fc);
        
        SNI_FL_Message__c FLmsg = new SNI_FL_Message__c();
        FLmsg.Member_Id__c = ac.id;
        FLmsg.Program__c = String.ValueOf(ac.id);
        FLmsg.Feed_Id__c = f.id;
        FLmsg.ProviderUser_List__c = userId;
        insert FLmsg;
        
        Id loggedUserid = UserInfo.getUserId();
        SNI_FL_Message_Status__c msgStatus = new SNI_FL_Message_Status__c();
        msgStatus.SNI_FL_Message__c = FLmsg.id;
        msgStatus.Agent__c = loggedUserid;
        insert msgStatus;
        
        SNI_FL_Message_Provider_Team__c msgProv = new SNI_FL_Message_Provider_Team__c();
        msgProv.Provider_Team__c = ac.id;
        msgProv.SNI_FL_Message__c = FLmsg.id;
        insert msgProv;
        
        // Creating and Inserting PersonAccount
        Id personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
        Account pa =new account();
        pa.PersonBirthdate = date.valueOf(ACETUtility.formatDateFutureDate('6/17/1979'));
        pa.firstName = 'paLastSample1'; 
        pa.lastName = 'paFirstSample1'; 
        pa.RecordTypeId = personAccRecordTypeId;
        insert pa;
            
        account pa1 = [select id,personcontactid from account where id =: pa.id];
        
        AccountContactRelation acr = new AccountContactRelation();
        acr.AccountId = ac.id;
        acr.ContactId = pa1.personcontactid;
        insert acr;
        
        List<DirectMessage> dmLst = [SELECT ID,subject,name FROM DirectMessage];
        /*dm.subject = 'test';
        dm.name = 'test';
        insert dm;*/
        
        List<DirectMessageFeed> dmsgLst = [SELECT ID FROM DirectMessageFeed WHERE ParentId =: dmLst[0].id];
        List<DirectMessageMember> lstDirectMessageMember = [SELECT Id,DirectMessageId,MemberId FROM DirectMessageMember WHERE DirectMessageId =: dmLst[0].id];
        system.debug('lstDirectMessageMember size is '+lstDirectMessageMember.size());
        SNI_FLDirectMessageWrapper.SNI_FLUserDetails userDetails = new SNI_FLDirectMessageWrapper.SNI_FLUserDetails('a','b','c','d','e');
        SNI_FL_ProviderMessageContentDisplay.getDirectMessageWrapper(dmsgLst[0].id,userId);
        SNI_FL_ProviderMessageContentDisplay.getContentDocumentData(fcList);
        SNI_FL_ProviderMessageContentDisplay.getContentDistribution(fcList);
        SNI_FL_ProviderMessageContentDisplay.getCommentsForFeed(dmsgLst,'System Administrator');
        SNI_FLDirectMessageWrapper.SNI_FLUserDetails userDetails1 = new SNI_FLDirectMessageWrapper.SNI_FLUserDetails('a','b','c','d','e');
    }
}