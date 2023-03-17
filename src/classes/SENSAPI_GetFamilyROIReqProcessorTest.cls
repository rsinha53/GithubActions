@isTest
private class SENSAPI_GetFamilyROIReqProcessorTest {
    
    private static final String memberId = '00878787897'; 
    
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
        pa1.firstName = 'paLastSample1'; 
        pa1.lastName = 'paFirstSample1'; 
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
        memberROI.SNI_FL_Status__c = 'InActive';
        memberROI.Is_Revoked__c = true;
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
    
    /**
     * Testing success scearnio with existing subscriber id
     */ 
    @istest private static void processRequestSuccess(){
        
      
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        RestContext.request = req;
        RestContext.response= res;
        
        Map<String,Object> requestMap = new Map<String,Object>();
        requestMap.put('subscriberId', memberId);
        
        SENSAPI_GetFamilyROIReqProcessor processor = new SENSAPI_GetFamilyROIReqProcessor();
        processor.process(JSON.serialize(requestMap));
       
        system.assert(RestContext.response.statusCode  == 200, 'Error processing success request');
    }
    
    /**
     * Testing failure scearnio with non-existing subscriber id
     */ 
    @istest private static void processRequestInvalidSubId(){
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        RestContext.request = req;
        RestContext.response= res;
        
        Map<String,Object> requestMap = new Map<String,Object>();
        requestMap.put('subscriberId', 'noexisting');
        
        SENSAPI_GetFamilyROIReqProcessor processor = new SENSAPI_GetFamilyROIReqProcessor();
        processor.process(JSON.serialize(requestMap));
        
        system.assert(RestContext.response.statusCode  == 400, 'Error processing bad request');
    }
    
    /**
     * Testing error scearnio without subscriber id
     */ 
    @istest private static void withoutSubId(){
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        RestContext.request = req;
        RestContext.response= res;
        
        Map<String,Object> requestMap = new Map<String,Object>();
        requestMap.put('subscriberId', '');
        
        SENSAPI_GetFamilyROIReqProcessor processor = new SENSAPI_GetFamilyROIReqProcessor();
        processor.process(JSON.serialize(requestMap));
        
        system.assert(RestContext.response.statusCode  == 400, 'Error processing request validation');
    }
    
    
}