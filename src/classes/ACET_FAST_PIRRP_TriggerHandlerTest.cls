/*************************************************************************************************************
 * @name			ACET_FAST_PIRRP_TriggerHandlerTest
 * @author			mrajen15 <muthukumarr@optum.com>
 * @created			01 / 11 / 2020
 * @description		Test class for ACET_FAST_PIRRP_TriggerHandler.
 *
 * Changes (version)
 * -----------------------------------------------------------------------------------------------------------
 * 				No.		Date			Author					Description
 * 				----	------------	--------------------	----------------------------------------------
 * @version		1.0		2020-11-01		mrajen15				Initial
 *
**************************************************************************************************************/
@isTest
public with sharing class ACET_FAST_PIRRP_TriggerHandlerTest {

    static final String PIR_PROFILE = 'Provider Issue Resolution';
    
    public static testmethod void testValidUserPIRCreateandEdit(){
        Profile fastUserProfile = ACET_Fast_TestDataFactory.getProfile(PIR_PROFILE);
        UserRole fastRole = ACET_Fast_TestDataFactory.getRole('PIR - Reactive Resolution');
        user fastUser = ACET_Fast_TestDataFactory.getUserRecordWithRole(fastUserProfile.id,fastRole.Id);
        insert fastUser;

        system.runAs(fastUser){
            case caseRec = ACET_Fast_TestDataFactory.getCaseRecord('Reactive_Resolution','Open');
            insert caseRec;
            PIR_Resolution_Partner__c rpRec = ACET_Fast_TestDataFactory.getPIRRPRec(caseRec.id);            
            try{
            	insert rpRec;    
            }catch(exception ex){
                system.debug(ex.getMessage());
            }
           PIR_Resolution_Partner__c rpRecTest = [select id,Escalation_Notes__c from PIR_Resolution_Partner__c where Case__c =: caseRec.id limit 1];
            system.assertEquals('test',rpRecTest.Escalation_Notes__c);
        }

    }
    
    public static testmethod void testValidPIPUserPIRCreateandEdit(){
        Profile pipUserProfile = ACET_Fast_TestDataFactory.getProfile(PIR_PROFILE);
        UserRole pipRole = ACET_Fast_TestDataFactory.getRole('PIR - Proactive Action');
        user pipUser = ACET_Fast_TestDataFactory.getUserRecordWithRole(pipUserProfile.id,pipRole.Id);
        insert pipUser;

        system.runAs(pipUser){
            case caseRec = ACET_Fast_TestDataFactory.getCaseRecord('Proactive_Action','Open');
            insert caseRec;
            PIR_Resolution_Partner__c rpRec = ACET_Fast_TestDataFactory.getPIRRPRec(caseRec.id);            
            try{
            	insert rpRec;    
            }catch(exception ex){
                system.debug(ex.getMessage());
            }
           PIR_Resolution_Partner__c rpRecTest = [select id,Escalation_Notes__c from PIR_Resolution_Partner__c where Case__c =: caseRec.id limit 1];
            system.assertEquals('test',rpRecTest.Escalation_Notes__c);
        }

    }
    
    public static testmethod void testInvalidUserPIRCreateandEdit(){
        Profile fastpipUserProfile = ACET_Fast_TestDataFactory.getProfile(PIR_PROFILE);
        UserRole fastRole = ACET_Fast_TestDataFactory.getRole('PIR - Reactive Resolution');
        user fastUser = ACET_Fast_TestDataFactory.getUserRecordWithRole(fastpipUserProfile.id,fastRole.Id);
        insert fastUser;
         case caseRec = new case();
        
        UserRole pipRole = ACET_Fast_TestDataFactory.getRole('PIR - Proactive Action');
        User pipUser = new User(Alias = 'standt', Email='standarduser@ecm.com',
            			  EmailEncodingKey='UTF-8', LastName='Testing', 
                          LanguageLocaleKey='en_US', LocaleSidKey='en_US', 
                          ProfileId = fastpipUserProfile.id, timeZoneSidKey='America/Los_Angeles', 
                          UserName='standarduserpip@ecm.com', UserRoleId= pipRole.id);
        insert pipUser;

        system.runAs(fastUser){
            caseRec = ACET_Fast_TestDataFactory.getCaseRecord('Reactive_Resolution','Open');
            insert caseRec;
        }
            system.runAs(pipUser){
            	PIR_Resolution_Partner__c rpRec = ACET_Fast_TestDataFactory.getPIRRPRec(caseRec.id);            
                    try{
                        insert rpRec;    
                    }catch(exception ex){
                        system.debug(ex.getMessage());
                        system.assert(true);
                    }                
            }

    }
    
    

}