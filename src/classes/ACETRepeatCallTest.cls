@istest
public class ACETRepeatCallTest{

    static testMethod void testRepeatCallButton(){
//  try{
        Case testButtonCase = new Case();
        testButtonCase.Repeat_Call__c = null;
        insert testButtonCase;
        String caseId = testButtonCase.Id;
        ACETRepeatCall.incrementRepeatCall(caseId);
        ACETRepeatCall.incrementRepeatCall(caseId);
//    }
//    catch(exception e){
//    }
    }
}