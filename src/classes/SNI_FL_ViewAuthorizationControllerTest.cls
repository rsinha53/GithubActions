@isTest
public class SNI_FL_ViewAuthorizationControllerTest {
	@isTest static void membViewAuthTest(){
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Family').getRecordTypeId();
            List<Account> accList=new List<Account>();
            List<SNI_FL_Care_Team_Member__c> teamlist=new List<SNI_FL_Care_Team_Member__c>();
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
            pa2.PersonBirthdate = date.valueOf(ACETUtility.formatDateFutureDate('6/7/1979'));
            pa2.firstName = 'Community'; 
            pa2.lastName = 'FLViewAuthTestUser1'; 
            pa2.RecordTypeId = personAccRecordTypeId;
            accList.add(pa2);          
            insert accList;
         	
         	SNI_FL_Care_Team_Member__c teamMemb = new SNI_FL_Care_Team_Member__c();
          	teamMemb.SNI_FL_Primary_Caregiver__c = true;
            teamMemb.SNI_FL_Family__c = ac.Id;
            teamMemb.SNI_FL_Member__c = pa.Id;
            teamMemb.SNI_FL_Not_Visible_in_Familylink__c = false;
            teamlist.add(teamMemb);
         
           	SNI_FL_Care_Team_Member__c teamMemb1 = new SNI_FL_Care_Team_Member__c();
          	teamMemb1.SNI_FL_Primary_Caregiver__c = false;
            teamMemb1.SNI_FL_Family__c = ac.Id;
            teamMemb1.SNI_FL_Member__c = pa2.Id;
            teamMemb1.SNI_FL_Not_Visible_in_Familylink__c = false;
            teamlist.add(teamMemb1);
            insert teamlist;
        	
        	SNI_FL_Members_ROI__c roi = new SNI_FL_Members_ROI__c();
            roi.SNI_FL_Account__c = teamMemb.SNI_FL_Member__c;
            roi.SNI_FL_Member__c = teamMemb.Id;
            roi.SNI_FL_ROI_Signed_Date__c = system.today();
            roi.SNI_FL_ROI_Signed_With__c = teamMemb1.Id;
            roi.SNI_FL_Status__c = 'Active';
            roi.SNI_FL_Type__c = 'Electronically';
            insert roi; 
        
        	 PageReference FLViewAuthPage = Page.Family_Link;
             test.setCurrentPage(FLViewAuthPage);
             apexpages.currentpage().getparameters().put('recid', teamMemb.Id);
             apexpages.currentpage().getparameters().put('isctm', 'true');
             SNI_FL_ViewAuthorizationController viewROIctm = new SNI_FL_ViewAuthorizationController();
             SNI_FL_ViewAuthorizationController.getCommunityInfo();
        
        	 PageReference FLViewAuthPageROI = Page.Family_Link;
             test.setCurrentPage(FLViewAuthPageROI);
             apexpages.currentpage().getparameters().put('recid', roi.Id);
             apexpages.currentpage().getparameters().put('isctm', 'false');
             SNI_FL_ViewAuthorizationController viewROI = new SNI_FL_ViewAuthorizationController();

    }
}