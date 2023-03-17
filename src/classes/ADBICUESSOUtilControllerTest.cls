/** Created by Sai Kolluru on 07/02/2020 **/
@isTest
public class ADBICUESSOUtilControllerTest {
	@testSetup static void setup() {
        
        // create test data for custom setting
        List<ISL_Webservice_Config__c> tokenUrl = new List<ISL_Webservice_Config__c>{
            new ISL_Webservice_Config__c(name='dev_ADBRiptideICUEUrl', value__c='https://gateway-stage.optum.com/api/test/cdm/riptide/icue-sso/v2/icue')
               };
                    insert tokenUrl;  
    }
    
    @isTest static void testgetCallerPopupDetails (){
        String todoLink='DECISION_SUPPORT';
        String subscriberId = '0064645';
        String cdbXrefId = '';
        String firstName = 'LISA';
        String lastName = 'VALADEZ';
        String userId='skollur6';
        String dob = '1963-12-30';
        String programICUESSOURL ='';
        String disposition = 'TellMeMore';
        String nbaParentId = '0234234';
		ADBICUESSOUtilController.generateRedirectUrl( todoLink, subscriberId, cdbXrefId, firstName,  lastName, userId, dob, programICUESSOURL, disposition, nbaParentId);
    }
    
      @isTest static void testgetCallerPopupDetailsTwo (){
        String todoLink='DECISION_SUPPORT';
        String subscriberId = '0064645';
        String cdbXrefId = '';
        String firstName = 'LISA';
        String lastName = 'VALADEZ';
        String userId='skollur6';
        String dob = '1963-12-30';
        String programICUESSOURL ='test';
        String disposition = 'TellMeMore';
        String nbaParentId = '0234234';
		ADBICUESSOUtilController.generateRedirectUrl( todoLink, subscriberId, cdbXrefId, firstName,  lastName, userId, dob, programICUESSOURL, disposition, nbaParentId);
    }
	@isTest static void testgetCallerPopupDetailsThree (){
        String todoLink='LAUNCH_NEW_PROG_DOC';
        String subscriberId = '0064645';
        String cdbXrefId = '';
        String firstName = 'LISA';
        String lastName = 'VALADEZ';
        String userId='skollur6';
        String dob = '1963-12-30';
        String programICUESSOURL ='';
        String disposition = 'TellMeMore';
        String nbaParentId = '0234234';
		ADBICUESSOUtilController.generateRedirectUrl( todoLink, subscriberId, cdbXrefId, firstName,  lastName, userId, dob, programICUESSOURL, disposition, nbaParentId);
    }													  
}