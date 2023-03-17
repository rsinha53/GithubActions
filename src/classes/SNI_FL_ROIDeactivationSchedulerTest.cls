@isTest
public class SNI_FL_ROIDeactivationSchedulerTest {
    
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
            roi.SNI_FL_ROI_Signed_Date__c = system.today()-365;
            roi.Exp_Date__c=system.today();
            roi.SNI_FL_ROI_Signed_With__c = teamMemb1.Id;
            roi.SNI_FL_Status__c = 'Active';
            roi.SNI_FL_Type__c = 'Electronically';
        	roiLst.add(roi);
        	SNI_FL_Members_ROI__c roi1 = new SNI_FL_Members_ROI__c();
            roi1.SNI_FL_Account__c = teamMemb.SNI_FL_Member__c;
            roi1.SNI_FL_Member__c = teamMemb1.Id;
            roi1.SNI_FL_ROI_Signed_Date__c = system.today()-365;
            roi1.SNI_FL_ROI_Signed_With__c = teamMemb.Id;
            roi1.SNI_FL_Status__c = 'InActive';
            roi1.SNI_FL_Type__c = 'Electronically';
            roiLst.add(roi1);
            insert roiLst; 
    }
    public static testMethod void deActivateROITest1() {
        test.startTest();
        SNI_FL_ROIDeactivationScheduler ROIDeactivationScheduler = new SNI_FL_ROIDeactivationScheduler();
	    String dayCronExpr = '0 0 0 * * ? *'; 
	    System.schedule('SNI FL Deactivate Expired ROI Daily Job Test', dayCronExpr, ROIDeactivationScheduler);
        test.stopTest();
    }

}