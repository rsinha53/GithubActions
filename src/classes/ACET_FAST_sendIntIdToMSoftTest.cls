/*****************************************************************************************************
ACET_FAST_sendIntIdToMSoftTest
Testing Class Name:  ACET_FAST_sendIntIdToMSoft
Author: Shaik Mohammad Yaseen
Date: 07/02/2021
Description: This is test class and used to get test coverage for ACET_FAST_sendIntIdToMSoft. 
Initial: Shaik Mohammad Yaseen
******************************************************************************************************/
@isTest(SeeAllData=false)
public class ACET_FAST_sendIntIdToMSoftTest {
    public static testMethod void createThirdPartyRec(){
        try{ 
            Interaction__c interRec = new Interaction__c();
            interRec.Interaction_Type__c = 'Email';
            insert interRec;
            
            List<case> caseRec = new List<case>();
            case caseRe = ACET_Fast_TestDataFactory.getCaseRecord('Reactive_Resolution','New');        
            caseRe.PC_Provider_TIN__c ='111111111';
            caseRe.Origin ='Impact System';
            caseRe.Interaction__c = interRec.id;
            caseRec.add(caseRe);
            insert caseRec;
            ACET_FAST_sendIntIdToMSoft.sendCaseToImpact(caseRec);
            
        }
        catch(exception ex){
            system.debug('error is ==>'+ex.getMessage());
        }
        
    }
}