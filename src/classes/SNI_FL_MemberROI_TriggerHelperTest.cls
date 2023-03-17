@isTest
public class SNI_FL_MemberROI_TriggerHelperTest {
    @isTest static void SNI_FL_MemberROI_TriggerHelperTestMethod(){
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Family').getRecordTypeId();
        List<Account> accList=new List<Account>();
        Set<String> sampleSet = new Set<String>();
        Set<Id> sampleSet2 = new Set<Id>();
        List<SNI_FL_Care_Team_Member__c> teamlist=new List<SNI_FL_Care_Team_Member__c>();
        List<SNI_FL_Care_Team_Member__c> teamlist2=new List<SNI_FL_Care_Team_Member__c>();
        Map<Id,SNI_FL_Members_ROI__c> oldMap = new Map<Id,SNI_FL_Members_ROI__c>();
        list<SNI_FL_Members_ROI__c> lstRoiMem = new list<SNI_FL_Members_ROI__c>();
        list<SNI_FL_Members_ROI__c> lstRoiMem2 = new list<SNI_FL_Members_ROI__c>();
        Account ac = new Account();
        ac.Member_ID__c = '453543145';
        ac.Policy_ID__c = '0070145';
        ac.Name =   'FLTestAcc145';
        ac.RecordTypeId = recordTypeId;
        accList.add(ac);
        
        Id personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
        Account pa =new account();
        pa.PersonBirthdate = date.valueOf(ACETUtility.formatDateFutureDate('6/17/1979'));
        pa.firstName = 'Community'; 
        pa.lastName = 'FLCreteamTestUser'; 
        pa.RecordTypeId = personAccRecordTypeId;
        accList.add(pa);       
        
        Account pa2 =new account();
        pa2.PersonBirthdate = date.valueOf(ACETUtility.formatDateFutureDate('6/7/1979'));
        pa2.firstName = 'Community'; 
        pa2.lastName = 'FLCreteamTestUser1'; 
        pa2.RecordTypeId = personAccRecordTypeId;
        accList.add(pa2);       
        insert accList;
        
        SNI_FL_Care_Team_Member__c teamMemb = new SNI_FL_Care_Team_Member__c();
        teamMemb.SNI_FL_Primary_Caregiver__c = true;
        teamMemb.SNI_FL_Family__c = ac.Id;
        teamMemb.SNI_FL_Member__c = pa.Id;
        teamMemb.SNI_FL_Not_Visible_in_Familylink__c = false;
        teamMemb.SNI_FL_Authorized__c =true;
        teamlist.add(teamMemb);
        
        SNI_FL_Care_Team_Member__c teamMemb1 = new SNI_FL_Care_Team_Member__c();
        teamMemb1.SNI_FL_Primary_Caregiver__c = false;
        teamMemb1.SNI_FL_Family__c = ac.Id;
        teamMemb1.SNI_FL_Member__c = pa.Id;
        teamMemb1.SNI_FL_Not_Visible_in_Familylink__c = false;
        teamMemb1.SNI_FL_Authorized__c =true;
        teamlist.add(teamMemb1);
        insert teamlist;
        
        SNI_FL_Care_Team_Member__c teamMemb2 = new SNI_FL_Care_Team_Member__c();
        
        teamMemb1.SNI_FL_Member__c = teamlist[0].Id;
        teamMemb1.SNI_FL_Primary_Caregiver__c = false;
        teamMemb1.SNI_FL_Family__c = ac.Id;
        teamMemb1.SNI_FL_Member__c = pa.Id;
        teamMemb1.SNI_FL_Authorized__c =true;
        teamlist2.add(teamMemb2);
        
        SNI_FL_Care_Team_Member__c teamMemb3 = new SNI_FL_Care_Team_Member__c();
        teamMemb1.SNI_FL_Primary_Caregiver__c = false;
        teamMemb1.SNI_FL_Family__c = ac.Id;
        teamMemb1.SNI_FL_Member__c = pa.Id;
        teamMemb1.SNI_FL_Member__c = teamlist[0].Id;
        teamMemb1.SNI_FL_Authorized__c =true;
        teamlist2.add(teamMemb3);
        insert teamlist2;
        for(SNI_FL_Care_Team_Member__c a : teamlist){
            sampleSet.add(a.Id);
            sampleSet2.add(a.Id);
        }
        SNI_FL_MemberROI_TriggerHelper.changeCareTeamRecStatus(sampleSet);
        Test.startTest();
        SNI_FL_MemberROI_TriggerHelper.SendEmailtoROI(sampleSet2,'flCareTeamtest@testorg.com');
        Test.stopTest();
        ID businessAccountType = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Family').getRecordTypeId();
        Account acc1 = new Account();
        acc1.Name = 'CaseManagementAcct_ACDC';
        acc1.Phone = '123456789';
        acc1.Type = 'Prospect';
        acc1.EID__c = '!123abc_ACDC';
        acc1.RecordTypeId = businessAccountType;
        insert acc1;
        
        ID personAccountType =  Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
        Account acc2 = new Account();
        acc2.FirstName ='Firstperson_ACDC';
        acc2.LastName = 'LastName_ACDC';
        acc2.RecordTypeId = personAccountType;
        insert acc2;
        Account acc3 = new Account();
        acc3.FirstName ='Secondperson_ACDC';
        acc3.LastName = 'SecondName_ACDC';
        acc3.RecordTypeId = personAccountType;
        insert acc3;
        SNI_FL_Care_Team_Member__c careTeamRecord1 = new SNI_FL_Care_Team_Member__c();
        careTeamRecord1.SNI_FL_Family__c = acc1.id;
        careTeamRecord1.SNI_FL_Member__c = acc2.id;
        careTeamRecord1.SNI_FL_Status__c	= 'Registered';
        insert careTeamRecord1;
        SNI_FL_Care_Team_Member__c careTeamRecord2 = new SNI_FL_Care_Team_Member__c();
        careTeamRecord2.SNI_FL_Family__c = acc1.id;
        careTeamRecord2.SNI_FL_Member__c = acc3.id;
        careTeamRecord2.SNI_FL_Status__c	= 'Registered';
        insert careTeamRecord2;
        
        SNI_FL_Members_ROI__c memberROI1 = new SNI_FL_Members_ROI__c();
        memberROI1.SNI_FL_Member__c = careTeamRecord1.id;
        memberROI1.SNI_FL_ROI_Signed_With__c =careTeamRecord2.id;
        memberROI1.SNI_FL_Status__c = 'InActive';
        memberROI1.SNI_FL_Account__c = acc2.id;
        memberROI1.SNI_FL_ROI_Signed_Date__c = system.today()+1;
        memberROI1.Is_Revoked__c = True;
        lstRoiMem.add(memberROI1);
        
        SNI_FL_Members_ROI__c memberROI2 = new SNI_FL_Members_ROI__c();
        memberROI2.SNI_FL_Member__c = careTeamRecord2.id;
        memberROI2.SNI_FL_ROI_Signed_With__c =careTeamRecord1.id;
        memberROI2.SNI_FL_Status__c = 'Active';
        memberROI2.SNI_FL_Account__c = acc1.id;
        memberROI2.SNI_FL_ROI_Signed_Date__c = system.today();
        memberROI2.Is_Revoked__c = False;
        lstRoiMem.add(memberROI2);
        insert lstRoiMem;
        
        SNI_FL_Members_ROI__c memberROI3 = new SNI_FL_Members_ROI__c();
        memberROI3.SNI_FL_Member__c = careTeamRecord2.id;
        memberROI3.SNI_FL_ROI_Signed_With__c =careTeamRecord1.id;
        memberROI3.SNI_FL_Status__c = 'Pending';
        memberROI3.SNI_FL_Account__c = acc1.id;
        memberROI3.SNI_FL_ROI_Signed_Date__c = system.today();
        memberROI3.Is_Revoked__c = False;
        insert memberROI3;
        
        memberROI3.Exp_Date__c = system.today();
        memberROI3.SNI_FL_Status__c = 'Active';
        update memberROI3;
        
        SNI_FL_Members_ROI__c memberROI4 = new SNI_FL_Members_ROI__c();
        memberROI4.SNI_FL_Member__c = careTeamRecord2.id;
        memberROI4.SNI_FL_ROI_Signed_With__c =careTeamRecord1.id;
        memberROI4.SNI_FL_Status__c = 'InActive';
        memberROI4.SNI_FL_Account__c = acc1.id;
        memberROI4.SNI_FL_ROI_Signed_Date__c = system.today() -4 ;
        memberROI4.Is_Revoked__c = False;
        insert memberROI4;
        
        memberROI4.SNI_FL_ROI_Signed_Date__c = system.today();
        memberROI4.SNI_FL_Status__c = 'Pending';
        update memberROI4;
        
        oldMap.put(memberROI1.Id,memberROI1);
        oldMap.put(memberROI2.Id,memberROI2);
        
        SNI_FL_MemberROI_TriggerHelper.addAuthorizedMemberToCaseTeam(lstRoiMem);
        SNI_FL_MemberROI_TriggerHelper.updateExpirationDate(lstRoiMem,oldMap);
        SNI_FL_MemberROI_TriggerHelper.checkROIStatus(lstRoiMem,oldMap);
        
    }
    
}