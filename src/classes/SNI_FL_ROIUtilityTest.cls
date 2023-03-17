@isTest
public class SNI_FL_ROIUtilityTest {
    @testSetup public static void testSetupROIUtilityData(){
            Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Family').getRecordTypeId();
            List<Account> accList=new List<Account>();
            List<SNI_FL_Care_Team_Member__c> teamlist=new List<SNI_FL_Care_Team_Member__c>();
        	List<SNI_FL_Members_ROI__c> roiLst = new List<SNI_FL_Members_ROI__c>();
            Account ac = new Account();
            ac.Member_ID__c = '123543987';
            ac.Policy_ID__c = '1230987';
            ac.Name = 'FLTestAcc123';
            ac.RecordTypeId = recordTypeId;
            accList.add(ac);
            
            Id personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
            Account pa =new account();
            pa.PersonBirthdate = date.valueOf(ACETUtility.formatDateFutureDate('6/17/1979'));
            pa.firstName = 'Community'; 
            pa.lastName = 'FLViewAuthTestUser'; 
            pa.RecordTypeId = personAccRecordTypeId;
            accList.add(pa);       
        
        	Account pa2 =new account();
            pa2.PersonBirthdate = date.valueOf(ACETUtility.formatDateFutureDate('6/7/1977'));
            pa2.firstName = 'Community'; 
            pa2.lastName = 'FLViewAuthTestUser1'; 
            pa2.RecordTypeId = personAccRecordTypeId;
            accList.add(pa2);
        
        	Account pa3 =new account();
            pa3.PersonBirthdate = date.valueOf(ACETUtility.formatDateFutureDate('6/7/1997'));
            pa3.firstName = 'Community'; 
            pa3.lastName = 'FLViewAuthTestUser2'; 
            pa3.RecordTypeId = personAccRecordTypeId;
            accList.add(pa3);          
            
            insert accList;
         	
         	SNI_FL_Care_Team_Member__c teamMemb = new SNI_FL_Care_Team_Member__c();
          	teamMemb.SNI_FL_Primary_Caregiver__c = true;
            teamMemb.SNI_FL_Family__c = ac.Id;
            teamMemb.SNI_FL_Member__c = pa.Id;
            teamMemb.SNI_FL_Not_Visible_in_Familylink__c = false;
        	teamMemb.SNI_FL_Status__c = 'Invited';
            teamlist.add(teamMemb);
         
           	SNI_FL_Care_Team_Member__c teamMemb1 = new SNI_FL_Care_Team_Member__c();
          	teamMemb1.SNI_FL_Primary_Caregiver__c = false;
            teamMemb1.SNI_FL_Family__c = ac.Id;
            teamMemb1.SNI_FL_Member__c = pa2.Id;
            teamMemb1.SNI_FL_Not_Visible_in_Familylink__c = false;
        	teamMemb1.SNI_FL_Status__c = 'Invited';
            teamlist.add(teamMemb1);
        
        	SNI_FL_Care_Team_Member__c teamMemb2 = new SNI_FL_Care_Team_Member__c();
          	teamMemb2.SNI_FL_Primary_Caregiver__c = false;
            teamMemb2.SNI_FL_Family__c = ac.Id;
            teamMemb2.SNI_FL_Member__c = pa3.Id;
            teamMemb2.SNI_FL_Not_Visible_in_Familylink__c = false;
        	teamMemb2.SNI_FL_Status__c = 'Added';
        	teamlist.add(teamMemb2);
            insert teamlist;
        	
        	SNI_FL_Members_ROI__c roi = new SNI_FL_Members_ROI__c();
            roi.SNI_FL_Account__c = teamMemb.SNI_FL_Member__c;
            roi.SNI_FL_Member__c = teamMemb.Id;
            roi.SNI_FL_ROI_Signed_Date__c = system.today();
            roi.SNI_FL_ROI_Signed_With__c = teamMemb1.Id;
            roi.SNI_FL_Status__c = 'Active';
            roi.SNI_FL_Type__c = 'Electronically';
        	roiLst.add(roi);
        	SNI_FL_Members_ROI__c roi1 = new SNI_FL_Members_ROI__c();
            roi1.SNI_FL_Account__c = teamMemb.SNI_FL_Member__c;
            roi1.SNI_FL_Member__c = teamMemb1.Id;
            roi1.SNI_FL_ROI_Signed_Date__c = system.today();
            roi1.SNI_FL_ROI_Signed_With__c = teamMemb.Id;
            roi1.SNI_FL_Status__c = 'InActive';
            roi1.SNI_FL_Type__c = 'Electronically';
            roiLst.add(roi1);
            insert roiLst; 
        
    }
    @isTest
    public static void getSignROIMemTest(){
        List<String> ctmLst = new List<String>();
        String famId = [Select id from account where Policy_ID__c = '1230987' LIMIT 1].Id ;
        for(SNI_FL_Care_Team_Member__c ctm : [SELECT Id from SNI_FL_Care_Team_Member__c where SNI_FL_Family__c =: famId])
        {
            ctmLst.add(ctm.Id);
        }
        Test.startTest();
		 SNI_FL_ROIUtility.getSignROIMembers(ctmLst,famId,false);        
        Test.stopTest();
        
    }
     @isTest
    public static void getSignROINgtvMemTest(){
        List<String> ctmLst = new List<String>();
        String famId = [Select id from account where Policy_ID__c = '1230987' LIMIT 1].Id ;
        for(SNI_FL_Care_Team_Member__c ctm : [SELECT Id from SNI_FL_Care_Team_Member__c where SNI_FL_Family__c =: famId])
        {
            ctmLst.add(ctm.Id);
        }
        Test.startTest();
		 SNI_FL_ROIUtility.getSignROIMembers(ctmLst,famId,true); 
        Test.stopTest();
        
    }
    @isTest
    public static void getSignROIMemSc2Test(){
        List<String> ctmLst = new List<String>();
        String famId = [Select id from account where Policy_ID__c = '1230987' LIMIT 1].Id ;
        List<SNI_FL_Care_Team_Member__c> ctm  =[SELECT Id from SNI_FL_Care_Team_Member__c where SNI_FL_Family__c =: famId];
        ctmLst.add(ctm[0].Id);
        Test.startTest();
		 SNI_FL_ROIUtility.getSignROIMembers(ctmLst,famId,false); 
        Test.stopTest();
        
    }
    @isTest
    public static void getROIMembersTest(){
      List<String> ctmLst = new List<String>();
        String famId = [Select id from account where Policy_ID__c = '1230987' LIMIT 1].Id ;
        for(SNI_FL_Care_Team_Member__c ctm : [SELECT Id from SNI_FL_Care_Team_Member__c where SNI_FL_Family__c =: famId])
        {
            ctmLst.add(ctm.Id);
        }
        Test.startTest();
		 SNI_FL_ROIUtility.getROIMembers(ctmLst,famId,false); 
        Test.stopTest();  
    } 
    @isTest
    public static void signAuthUpdateTest(){
        String famId = [Select id from account where Policy_ID__c = '1230987' LIMIT 1].Id ;
        List<SNI_FL_Care_Team_Member__c> ctmLst = [SELECT Id from SNI_FL_Care_Team_Member__c where SNI_FL_Family__c =: famId];
        String signedWith =JSON.serialize(ctmLst);
        String ctmId = String.valueOf(ctmLst[0].Id);
        Test.startTest();
		 SNI_FL_ROIUtility.signAuthUpdate(ctmId,signedWith); 
         SNI_FL_ROIUtility.checkRedirectInvitetoAuth(famId);
         SNI_FL_ROIUtility.inviteAuthUpdate(ctmId,signedWith);
        Test.stopTest();  

    }
    @isTest
    public static void ROImembersTest(){
      Date PersonBirthdate = date.valueOf(ACETUtility.formatDateFutureDate('6/17/1979'));
      List<account> personAcc = [select id from account where PersonBirthdate =: PersonBirthdate LIMIT 1];
      List<SNI_FL_Care_Team_Member__c> ctmLst = [SELECT Id from SNI_FL_Care_Team_Member__c where SNI_FL_Member__c =: personAcc[0].Id LIMIT 1];
      List<SNI_FL_Members_ROI__c> roiLst = [SELECT Id from SNI_FL_Members_ROI__c where SNI_FL_Member__c =: ctmLst[0].Id]; 
      String roiRec = string.valueOf(roiLst[0].Id);
        Test.startTest();
		 SNI_FL_ROIUtility.ROImembers(roiRec,False); 
        Test.stopTest();  
        
    }
    @isTest
    public static void ROImembersNgtvTest(){
      Date PersonBirthdate = date.valueOf(ACETUtility.formatDateFutureDate('6/17/1979'));
      List<account> personAcc = [select id from account where PersonBirthdate =: PersonBirthdate LIMIT 1];
      List<SNI_FL_Care_Team_Member__c> ctmLst = [SELECT Id from SNI_FL_Care_Team_Member__c where SNI_FL_Member__c =: personAcc[0].Id LIMIT 1];
      List<SNI_FL_Members_ROI__c> roiLst = [SELECT Id from SNI_FL_Members_ROI__c where SNI_FL_Member__c =: ctmLst[0].Id]; 
      String roiRec = string.valueOf(ctmLst[0].Id);
        Test.startTest();
		 SNI_FL_ROIUtility.ROImembers(roiRec,true); 
        Test.stopTest();  
    }
    @isTest
    public static void deactivateROItest(){
      Date PersonBirthdate = date.valueOf(ACETUtility.formatDateFutureDate('6/17/1979'));
      List<account> personAcc = [select id from account where PersonBirthdate =: PersonBirthdate LIMIT 1];
      List<SNI_FL_Care_Team_Member__c> ctmLst = [SELECT Id from SNI_FL_Care_Team_Member__c where SNI_FL_Member__c =: personAcc[0].Id LIMIT 1];
      List<SNI_FL_Members_ROI__c> roiLst = [SELECT Id,Exp_Date__c,SNI_FL_Member__c from SNI_FL_Members_ROI__c where SNI_FL_Member__c =: ctmLst[0].Id]; 
      List<SNI_FL_Members_ROI__c> updroiLst = new List<SNI_FL_Members_ROI__c>();
        for(SNI_FL_Members_ROI__c roi:roiLst){
            roi.Exp_Date__c =system.today()-1; 
            updroiLst.add(roi);
        }
        update updroiLst;
        Test.startTest();
		 SNI_FL_ROIUtility.deActivateROI(updroiLst); 
        Test.stopTest();  
    }
    @isTest
    public static void communityUserResendTest(){
        String famId = [Select id from account where Policy_ID__c = '1230987' LIMIT 1].Id ;
        List<SNI_FL_Care_Team_Member__c> ctm  =[SELECT Id from SNI_FL_Care_Team_Member__c where SNI_FL_Family__c =: famId];
        Test.startTest();
		 SNI_FL_ROIUtility.createCommunityUserinResend(ctm[0].Id,'test@testoptum.com'); 
        Test.stopTest();
    }
    @isTest
    public static void getROIMembersMapTest(){
        Id famId = [Select Id from account where Policy_ID__c = '1230987' LIMIT 1].Id ;
        List<SNI_FL_Care_Team_Member__c> ctm  =[SELECT Id from SNI_FL_Care_Team_Member__c where SNI_FL_Family__c =: famId];
        List<Id> ctIdList = new List<Id>();
        for(SNI_FL_Care_Team_Member__c ct : ctm){
            ctIdList.add(ct.Id);
        }
        Test.startTest();
		 SNI_FL_ROIUtility.getROIMembersMap(ctIdList,famId); 
        Test.stopTest();
    }
     @isTest
    public static void ROIPendingInviteTest(){
        List<String> ctmLst = new List<String>();
        String famId = [Select id from account where Policy_ID__c = '1230987' LIMIT 1].Id ;
        for(SNI_FL_Care_Team_Member__c ctm : [SELECT Id from SNI_FL_Care_Team_Member__c where SNI_FL_Family__c =: famId])
        {
            ctmLst.add(ctm.Id);
        }
        Test.startTest();
		 SNI_FL_ROIUtility.getROIMembers(ctmLst,famId,true); 
        Test.stopTest();  
    }
    @isTest
    public static void createCommunityUserTest(){
        String famId = [Select id from account where Policy_ID__c = '1230987' LIMIT 1].Id ;
        List<SNI_FL_Care_Team_Member__c> ctm  =[SELECT Id,Email__c,SNI_FL_Member__r.FirstName,SNI_FL_Member__r.LastName from SNI_FL_Care_Team_Member__c where SNI_FL_Family__c =: famId];        
        Test.startTest();
		 SNI_FL_ROIUtility.createCommunityUser(ctm[0].Id); 
        Test.stopTest();  
    }
}