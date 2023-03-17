@isTest
public class SAE_MisdirectControllerTest {
    static testMethod void misdirectCtrlMethod1(){
        User providerUser = TestDataFactory.getUser('Provider Service');
        System.runAs(providerUser) {
            test.startTest();
            SAE_MisdirectController.getMisdirectReasonValues();
            
            Interaction__c inter = new Interaction__c();
            insert inter;
            
            case c = new case();
            c.status = 'Open';
            c.Subject_Name__c = 'Test Subject';
            c.Subject_Type__c = 'Member';
            c.Subject_Group_ID__c = 'Sgrp00011';
            c.ID__c  = 'S00011';
            c.Interaction__c = inter.id;
            c.DOB__c = '12/12/2012';
            c.Originator_name__c = 'Provider'; 
            Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('SAE Provider').getRecordTypeId();
            c.RecordTypeId = recordTypeId;
            c.Caller__c = 'VinayTest';
            insert c;
            
            //SAE_MisdirectController.createCase('Dental Vendor', 'comments',inter.id,'testOriginator','Provider', 'Vinay','MisdirectCtrl','Member','Subject','Sub00011','sgrp00011');
            SAETTSCaseWrapper caseWrapper = new SAETTSCaseWrapper();
            caseWrapper.Status = 'Open';
            caseWrapper.Interaction = inter.Id;
             VCCD_Response__c vcr= new VCCD_Response__c(ani__c = '1234567890',MSID__c = 'test123');//US2631703 - Durga- 08th June 2020
        	insert vcr; //US2631703 - Durga- 08th June 2020
            //US2903847
            ACET_ExplorePageCtrl.FlowDetails fd = new ACET_ExplorePageCtrl.FlowDetails();
            fd.contactExt = '123';
            fd.contactName = 'cfn cln';
            fd.contactNumber = '1234567890';
            fd.interactionType = 'Email';
            fd.isGenesys = false;
            fd.IVRInfo = null;
            fd.GeneysysQuestionType = '';
            String returnId = SAE_MisdirectController.createCase(JSON.serialize(caseWrapper),'casecomment',true,vcr.id,fd); //US2631703 - Durga- 08th June 2020
            SAE_MisdirectController.CreateORSRecord(JSON.serialize(caseWrapper), c.id);
             SAE_MisdirectController.getCaseDetails(c.id);
            //SAE_MisdirectController.addCaseComment(c.id,'');
             SAETTSCaseWrapper caseWrapperVCCD = new SAETTSCaseWrapper();//US2631703 - Durga- 08th June 2020
            caseWrapperVCCD.Status = 'Open';//US2631703 - Durga- 08th June 2020
            caseWrapperVCCD.originatorName = 'Test Test';
            caseWrapperVCCD.noProviderToSearch = false;
            caseWrapperVCCD.providerNotFound = false;
            caseWrapperVCCD.noMemberToSearch = false;
            caseWrapperVCCD.isOtherSearch = true;
            String returnId2 = SAE_MisdirectController.createCase(JSON.serialize(caseWrapperVCCD),'casecomment',true,vcr.id,fd); //US2631703 - Durga- 08th June 2020
            test.stopTest();
        }
    }
}