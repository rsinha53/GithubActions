@isTest
public class ACETLGT_ChangeCaseOwnerControllerTest {
    @TestSetup
    public static void testSetup(){
        ACET_ChageCaseOwner__c custSetting = new ACET_ChageCaseOwner__c();
        custSetting.Name = 'System Administrator';
        custSetting.Profile_Role_Available__c = 'System Administrator, ACET Motion';
        custSetting.Queue_API_name_contains__c = 'Motion';
        custSetting.Status_Update__c = 'Routed';
        custSetting.SetupOwnerId = userinfo.getProfileId();
        Insert custSetting;
        
    }
    
    @isTest
    public static void testFetchRecord(){
        user u = [Select Id from user where ProfileId=:userinfo.getProfileId() AND IsActive=true LIMIT 1];
        ACET_ChageCaseOwner__c custSett = [Select Id from ACET_ChageCaseOwner__c];
        System.runAs(u) {
            ACETLGT_ChangeCaseOwnerController.fetchLookUpValues('motion', 'queue');
            ACETLGT_ChangeCaseOwnerController.fetchLookUpValues('motion', 'user');
        }
    }
    
    @isTest
    public static void testUpdateCase(){
        case testcase 	= TestDataFactory.createCase(); 
        user u = [SELECT Id, Name From User Where profileId=:userinfo.getProfileId() AND IsActive=true Limit 1];
        ACET_ChageCaseOwner__c custSett = [Select Id from ACET_ChageCaseOwner__c];
        ACETLGT_ChangeCaseOwnerController.updateCaseOwner(testcase.Id, u, 'user');
        ACETLGT_ChangeCaseOwnerController obj = new ACETLGT_ChangeCaseOwnerController(new ApexPages.StandardController( testcase ));
    }
}