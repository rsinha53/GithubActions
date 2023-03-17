@isTest(seeAllData=true)
public class ACETVCCDBridgeControllerTest {
    public testmethod static void testVCCDBridgeController(){
        
        //User objUser = [Select id,Name,FederationIdentifier from User where FederationIdentifier = 'skuma603'];
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u2 = new User(Alias = 'newUser', Email='newuser@testorg.com',
                           EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                           LocaleSidKey='en_US', ProfileId = p.Id,
                           TimeZoneSidKey='America/Los_Angeles', UserName='newsureshuser@testorg.com', FederationIdentifier='skuma60312');
        System.runAs(u2){
            System.debug('u2::'+u2);     
            Test.startTest();
            VCCD_Response__c vccdrespobj = new VCCD_Response__c();
            vccdrespobj.SubjectDOB__c = system.today();
            vccdrespobj.DOB__c = system.today();
            vccdrespobj.isActive__c = true;
            vccdrespobj.MSID__c ='skuma60312';
            vccdrespobj.QuestionType__c ='testtopic';
            insert vccdrespobj;
            ACETVCCDBridgeController.getVCCDData();
            ACETVCCDBridgeController.updateCurrentRecordToInactive(string.valueOf(vccdrespobj.id));
            ACETVCCDBridgeController.getUserDetails();
            Test.stopTest();
        }   
    }

    
    public testmethod static void ACETLGT_VCCDBridgeControllertest(){
        
        //User objUser = [Select id,Name,FederationIdentifier from User where FederationIdentifier = 'skuma603'];
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u3 = new User(Alias = 'newUser', Email='newuser@testorg.com',
                           EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                           LocaleSidKey='en_US', ProfileId = p.Id,
                           TimeZoneSidKey='America/Los_Angeles', UserName='newsureshuser1@testorg.com', FederationIdentifier='skuma6031');
        System.runAs(u3){
            SYSTEM.debug('u3::'+u3);
            Test.startTest();
            VCCD_Response__c vccdrespobj = new VCCD_Response__c();
            vccdrespobj.SubjectDOB__c = system.today();
            vccdrespobj.DOB__c = system.today();
            vccdrespobj.isActive__c = true;
            vccdrespobj.MSID__c ='skuma6031';
            vccdrespobj.QuestionType__c ='testtopic';
            insert vccdrespobj;
            Call_Topic_Access__c calltopic = new Call_Topic_Access__c();
            calltopic.Name = 'testtopic';
            insert calltopic;
            ACETLGT_VCCDBridgeController.getVCCDData();
            ACETLGT_VCCDBridgeController.updateCurrentRecordToInactive(vccdrespobj);
            ACETLGT_VCCDBridgeController.getUserDetails();
            Test.stopTest();
        }
        
    } 
}