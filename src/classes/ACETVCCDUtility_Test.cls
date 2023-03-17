@istest
public class ACETVCCDUtility_Test {
    static testMethod void utilityTest() { 
        ACETVCCDInteractionInfo wrp = new ACETVCCDInteractionInfo();
        wrp.idStr = 'test';
        wrp.callTopic = 'test';
        wrp.MemberDOB = '06/05/2022';
        wrp.dob = '06/05/2022';
        wrp.callerANI = 'test';
        wrp.phone = '12345';
        wrp.TFN = 'test';
        wrp.CallerType = 'test';
        wrp.QuestionType = 'test';
        wrp.CallerID = 'test';
        wrp.TaxID = 'test';
        wrp.npi = 'test';
        wrp.memberId = 'test';
        wrp.ClaimID = 'test';
        wrp.producerId = 'test';
        wrp.groupId = 'test';
        wrp.AuthorizationNumber = 'test';
        wrp.ReferralNumber = 'test';
        
        Interaction__c intr = new Interaction__c();
        insert intr; 
        test.startTest();
            ApexPages.currentPage().getParameters().put('vccdParams',json.serialize(wrp));
            ACETVCCDUtility.populateVCCDInfo(intr);
            ACETVCCDUtility.populateVCCDInfo(intr,json.serialize(wrp));
        test.stopTest();
    }
}