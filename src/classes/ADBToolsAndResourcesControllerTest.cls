@isTest
public class ADBToolsAndResourcesControllerTest {
    
      @testSetup static void setup() {
        
        // create test data for custom setting
        List<ACETOrgNameToSwivelEndpointMap__c> endpointUrlList = new List<ACETOrgNameToSwivelEndpointMap__c>{
            new ACETOrgNameToSwivelEndpointMap__c(name='ADBAvayaCallbackUrl', Swivel_Endpoint__c='http://avaya.mhars2.optum.com/'),
                new ACETOrgNameToSwivelEndpointMap__c(name='ADBMyEviveUrl', Swivel_Endpoint__c='https://myevive.com/'),
                new ACETOrgNameToSwivelEndpointMap__c(name='ADBICUEPolicyAdminUrl', Swivel_Endpoint__c='https://icue.uhc.com/icue/policyAdmin.uhg'),
                new ACETOrgNameToSwivelEndpointMap__c(name='ADBMyHealthDirectUrl',Swivel_Endpoint__c='https://optumcs.myhealthdirect.com/Login/Logon'),
                new ACETOrgNameToSwivelEndpointMap__c(name='ADBRallyCostEstimatorUrl',Swivel_Endpoint__c='https://www.hcestimator.com/ctuiwebapp/ct/signin/sitemindersso'),
                new ACETOrgNameToSwivelEndpointMap__c(name='ADBHealthCenterUrl', Swivel_Endpoint__c='https://www.personalhealthmessagecenter.com/'),
                new ACETOrgNameToSwivelEndpointMap__c(name='ADBThirdPartyReferralPortalUrl', Swivel_Endpoint__c='https://tpreferrals.uhg.com/index.aspx?ReturnUrl=%2freferrals%2foverview.aspx'),
                new ACETOrgNameToSwivelEndpointMap__c(name='ADBMyUHCSupervisor', Swivel_Endpoint__c='https://www.myuhc.com/suaction.do')
                };
                    
                    insert endpointUrlList;  
    
    }

    @isTest static void getAvayaCallbackUrl(){
        ADBToolsAndResourcesController.getAvayaCallbackUrl();
    }
    
    @isTest static void getEviveUrl(){
        ADBToolsAndResourcesController.getEviveUrl();
    }
    
    @isTest static void getInitiateEngagementIntakeUrl(){
        test.startTest();
        String subscriberId='234234',userId='skollur6';
        ADBToolsAndResourcesController.getInitiateEngagementIntakeUrl(subscriberId,userId);
        test.stopTest();
    }
    
    @isTest static void getICUEHomeUrl(){
        test.startTest();
        String cdbXrefId='2352533',userId='skollur6';
        ADBToolsAndResourcesController.getICUEHomeUrl(cdbXrefId,userId);
        test.stopTest();
    }
    
    @isTest static void getICUEPolicyAdminUrl(){
        test.startTest();
        String cdbXrefId='234234',userId='skollur6';
        ADBToolsAndResourcesController.getICUEPolicyAdminUrl(cdbXrefId,userId);
        test.stopTest();
    }
    
    @isTest static void getMyHealthDirectLoginUrl(){
        test.startTest();
        String userId='skollur6';
        ADBToolsAndResourcesController.getMyHealthDirectUrl(userId);
        test.stopTest();
    }
    
    @isTest static void getRallyCostEstimatorUrl(){
        ADBToolsAndResourcesController.getRallyCostEstimatorUrl();
    }
    
    @isTest static void getHealthMessageCenterUrl(){
        ADBToolsAndResourcesController.getHealthMessageCenterUrl();
    }
    
    @isTest static void getThirdPartReferralUrl(){
        ADBToolsAndResourcesController.getThirdPartReferralUrl();
    }
    
    
    @isTest static void getMyUhcSupervisorUrl(){
        ADBToolsAndResourcesController.getMyUhcSupervisorUrl();
    }
    
    
    @isTest static void getMyRallyImpersonationLoginUrl(){
    	String baseURL = '';
        String memberId = '123456789';
        String userId = 'stest2';
        String firstname = 'sam';
        String lastname = 'antha';
        String memberDob = '09-09-1993';
        String policy = '0056789';
        baseURL = ADBToolsAndResourcesController.getRallyImpersonationUrl(memberId, userId, firstname, lastname, memberDob, policy);
    }

    @isTest static void getCastLightUrl(){
    	String baseURL = '';
        String userId = 'stest2';
        String subscriberId = '123456789';
        String firstname = 'sam';
        String lastname = 'antha';
        String memberDob = '09-09-1993';
        String clientName = 'pepsico';
        baseURL = ADBToolsAndResourcesController.getCastLightUrl(userId, subscriberId, firstname, lastname, memberDob, clientName);
    }

    @isTest static void getCastLightMetadata(){
        test.startTest();
        String policy = '0191690';
        ADBToolsAndResourcesController.getCastLightMetadata(policy);
        test.stopTest();
    }
    
}