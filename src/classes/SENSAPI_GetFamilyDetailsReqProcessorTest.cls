/*------------------------------------------------------------
Author:        Pratikshya Satapathy
Description:   Test class for League_GetFamilyDetailsRequestProcessor  

Test Class:   SENSAPI_GetFamilyDetailsReqProcessorTest
History
Date            Author              Comments
-------------------------------------------------------------
08-16-2022      Pratikshya Satapathy	Created
10-04-2022      Tushar Kaore      		Modified
------------------------------------------------------------*/
@isTest
private class SENSAPI_GetFamilyDetailsReqProcessorTest {
    
    private static final String memberId = '00453543543'; 
    
    /**
     * Test data setup
     */ 
    @testSetup static void setup() {
        List<SNI_FL_Members_ROI__c> lstRoiMem = new List<SNI_FL_Members_ROI__c>(); 
        
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Family').getRecordTypeId();
        Account ac = new Account();
        ac.Member_ID__c = memberId;
        ac.Policy_ID__c = '0070145';
        ac.Name =   'SampleTEstFLAcc1';
        ac.RecordTypeId = recordTypeId;
        insert ac;
        
        Id personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
        Account pa =new account();
        pa.PersonBirthdate = date.valueOf(ACETUtility.formatDateFutureDate('6/17/1979'));
        pa.firstName = 'paLastSample1'; 
        pa.lastName = 'paFirstSample1'; 
        pa.RecordTypeId = personAccRecordTypeId;
        insert pa;
        
        Account pa1 =new account();
        pa1.PersonBirthdate = date.valueOf(ACETUtility.formatDateFutureDate('6/17/1979'));
        pa1.firstName = 'testfname'; 
        pa1.lastName = 'testlname'; 
        pa1.RecordTypeId = personAccRecordTypeId;
        insert pa1;
        
        account pa2 = [select id,personcontactid from account where id =: pa.id];
        List<AccountContactRelation> acrList = new List<AccountContactRelation>();
        map<id, AccountContactRelation> triggerOldMap = new map<id, AccountContactRelation>();
        AccountContactRelation acr = new AccountContactRelation();
        acr.ContactId = pa2.personcontactid;            
        acr.Accountid = ac.id;
        acr.Relationship__c = 'Child/Other';
        acr.Complex_Indicator__c = 'Referral';
        insert acr;
        
        List<SNI_FL_Care_Team_Member__c> careteamMemList = new List<SNI_FL_Care_Team_Member__c>(); 
        SNI_FL_Care_Team_Member__c careteamMem = new SNI_FL_Care_Team_Member__c();
        careteamMem.SNI_FL_Member__c = pa.id;
        careteamMem.SNI_FL_Not_Visible_in_Familylink__c = false;
        careteamMem.SNI_FL_Family__c = ac.Id; 
        careteamMem.SNI_FL_Primary_Caregiver__c = true;
        careteamMemList.add(careteamMem);
        
        
        SNI_FL_Care_Team_Member__c careteamMem1 = new SNI_FL_Care_Team_Member__c();
        careteamMem1.SNI_FL_Member__c = pa1.id;
        careteamMem1.SNI_FL_Not_Visible_in_Familylink__c = false;
        careteamMem1.SNI_FL_Family__c = ac.Id; 
        careteamMem1.SNI_FL_Primary_Caregiver__c = true; 
        careteamMemList.add(careteamMem1);
        insert careteamMemList;
        
        SNI_FL_Members_ROI__c memberROI = new SNI_FL_Members_ROI__c();
        memberROI.SNI_FL_Member__c = careteamMem.id;
        memberROI.SNI_FL_ROI_Signed_With__c =careteamMem1.id;
        memberROI.SNI_FL_Status__c = 'Active';
        memberROI.SNI_FL_Account__c = pa.id;
        memberROI.SNI_FL_ROI_Signed_Date__c = system.today();
        lstRoiMem.add(memberROI);
        insert lstRoiMem;
        
        Member_Information__c memberInformation = new Member_Information__c();
        memberInformation.Gender__c = 'Male';
        memberInformation.Account__c = pa.Id;
        insert memberInformation;
        
        
        Family_Overview__c familyOverview = new Family_Overview__c();
        familyOverview.Account__c = ac.Id;
        insert familyOverview;
        
    }
    
    //Testing success scearnio with existing subscriber id
    @istest private static void processRequestSuccess(){
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        RestContext.request = req;
        RestContext.response= res;
        
        Map<String,Object> requestMap = new Map<String,Object>();
        requestMap.put('subscriberId', memberId);
        requestMap.put('dateofbirth', date.valueOf(ACETUtility.formatDateFutureDate('6/17/1979')));
        requestMap.put('email', 'manuTestEmail@gmail.com');
        
        SENSAPI_GetFamilyDetailsReqProcessor processor = new SENSAPI_GetFamilyDetailsReqProcessor();
        processor.process(JSON.serialize(requestMap));
    }
    
    //Testing failure scearnio with non-existing subscriber id 
    @istest private static void processRequestInvalidSubId(){
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        RestContext.request = req;
        RestContext.response= res;
        
        Map<String,Object> requestMap = new Map<String,Object>();
        requestMap.put('subscriberId', 'noexisting');
        requestMap.put('dateofbirth', date.valueOf(ACETUtility.formatDateFutureDate('6/17/1979')));
        requestMap.put('email', 'manuTestEmail@gmail.com');
        
        SENSAPI_GetFamilyDetailsReqProcessor processor = new SENSAPI_GetFamilyDetailsReqProcessor();
        processor.process(JSON.serialize(requestMap));
    }
    
    
    //Testing error scearnio without subscriber id 
    @istest private static void withoutSubId(){
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        RestContext.request = req;
        RestContext.response= res;
        
        Map<String,Object> requestMap = new Map<String,Object>();
        requestMap.put('subscriberId', '');
        
        SENSAPI_GetFamilyDetailsReqProcessor processor = new SENSAPI_GetFamilyDetailsReqProcessor();
        processor.process(JSON.serialize(requestMap));
    }

    //Testing success scearnio when ACRs doesnt exist 
    @istest private static void processRequestSuccess1(){
        List<SNI_FL_Care_Team_Member__c> CTM = [SELECT Id FROM SNI_FL_Care_Team_Member__c];
        delete CTM;
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        RestContext.request = req;
        RestContext.response= res;
        
        Map<String,Object> requestMap = new Map<String,Object>();
        requestMap.put('subscriberId', memberId);
        requestMap.put('dateofbirth', date.valueOf(ACETUtility.formatDateFutureDate('6/17/1979')));
        requestMap.put('email', 'manuTest121Email@gmail.com');
        
        SENSAPI_GetFamilyDetailsReqProcessor processor = new SENSAPI_GetFamilyDetailsReqProcessor();
        processor.process(JSON.serialize(requestMap));
    }
    @istest private static void initProcessorException(){
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        RestContext.request = req;
        RestContext.response= res;
        String reqst = '{"subscriberId": "","memberSensId": "0017600000NQBEeAAP", "email": "manuTest121Email@gmail.com}';
        
        SENSAPI_GetFamilyDetailsReqProcessor processor = new SENSAPI_GetFamilyDetailsReqProcessor();
        processor.process(reqst);
        processor.getAccountIdUserMap();
    }
    @istest private static void userAlreadyExistTest(){
        
        Account acc = [SELECT Id,firstName,LastName,personContactId FROM Account WHERE isPersonAccount = true LIMIT 1];
        system.debug('inside here***');
        Profile flp = [Select Id from Profile where name = 'Care Advisor Connect Community User' LIMIT 1];   
        User comUser = New User();
        string randomNumber = string.valueOf(Math.round((Math.random() * (900000) + 100000)));
        comUser.UserName = 'dereksheperd@greyanatomy.com';
        comUser.FirstName = acc.FirstName;
        comUser.LastName = acc.LastName;
        comUser.Alias = String.isNotBlank(acc.LastName) && acc.LastName.length()>3? acc.LastName.substring(0,3):'';                         
        comUser.email = randomNumber + comUser.UserName;
        comUser.ContactId = acc.personContactId;
        comUser.CommunityNickName = 'FLUser'+string.valueOf(math.random()).substring(0,6);
        comUser.ProfileID = flp.id;
        comUser.TimeZoneSidKey = 'America/Mexico_City';
        comUser.LocaleSidKey = 'en_US';
        comUser.EmailEncodingKey = 'UTF-8';
        comUser.LanguageLocaleKey = 'en_US';
        comUser.alias = 'guest'+ string.valueOf(math.random()).substring(0,2);
        comuser.Suppress_Email_Reset_Time__c= system.now().addMinutes(60).addMinutes(1);
		insert comuser;
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        RestContext.request = req;
        RestContext.response= res;
        
        Map<String,Object> requestMap = new Map<String,Object>();
        requestMap.put('subscriberId', memberId);
        requestMap.put('dateofbirth', date.valueOf(ACETUtility.formatDateFutureDate('6/17/1979')));
        requestMap.put('email', 'manuTest121Email@gmail.com');
        
        SENSAPI_GetFamilyDetailsReqProcessor processor = new SENSAPI_GetFamilyDetailsReqProcessor();
        processor.process(JSON.serialize(requestMap));
    }
}