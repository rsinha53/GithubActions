/*****************************************************************************************************
ACET_FAST_PIRDetail_TriggerHandlerTest
Testing Class Name:  ACET_FAST_PIRDetail_TriggerHandler
Author: Raj Gupta
Date: 02/10/2021
Description: This is test class and used to get test coverage for ACET_FAST_PIRDetail_TriggerHandler. 
Initial: Raj Gupta
******************************************************************************************************/
@isTest(SeeAllData=false)
public with sharing class ACET_FAST_PIRDetail_TriggerHandlerTest {
    
    public static testMethod void testhandleAfterInsert(){
        try{
            case caseRec = ACET_Fast_TestDataFactory.getCaseRecord('Reactive_Resolution','Open');
            insert caseRec;
            
            PIR_Detail__c pirRec = new PIR_Detail__c();
            pirRec = ACET_Fast_TestDataFactory.getPIRRec(caseRec.Id);
            insert pirRec;
            
            pirRec.Reason_for_Submission_Delay__c ='Split Case';
            update pirRec;
            
        }
        catch(Exception ex)
        {
            System.debug('Error: '+ex.getMessage());
        } 
    }
    
    
    
}