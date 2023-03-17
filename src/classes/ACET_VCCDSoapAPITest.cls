@isTest
public class ACET_VCCDSoapAPITest {

     @testSetup static void setup() {
        Profile profAdmin = SAETestDataFactory.loadProfile(SAEConstants.SAE_PROFILE_SYSADMIN_NAME);
        User userObj = new User();
         userObj.Alias = SAEConstants.SAE_USER_SYSADMIN_ALIAS;
         userObj.Email = SAEConstants.SAE_USER_SYSADMIN_EMAIL;
         userObj.EmailEncodingKey = SAEConstants.SAE_USER_EMAILENCODINGKEY;
         userObj.LastName = SAEConstants.SAE_USER_SYSADMIN_LASTNAME;
         userObj.LanguageLocaleKey = SAEConstants.SAE_USER_LANGLOCALEKEY;
         userObj.LocaleSidKey = SAEConstants.SAE_USER_LOCALESIDKEY;
         userObj.ProfileId = profAdmin.Id;
         userObj.TimeZoneSidKey = SAEConstants.SAE_USER_TIMEZONESIDKEY;
         userObj.UserName = SAEConstants.SAE_USER_ADMIN_USERNAME;
         userObj.FederationIdentifier = 'xxxx121xxxx';
         INSERT userObj;
     }


    @isTest
    static void testProcessVCCDInbound(){
        //With full data
        ACET_VCCDSoapAPI.ACET_VCCDRequest request = new ACET_VCCDSoapAPI.ACET_VCCDRequest();
        request.ani = '1234567890';
        request.subjectDOB = '1990-01-01';
        request.questionType= 'Test';
        request.productType= 'Test';
        request.claimId = '1234567890';
        request.ucid = 'Test';
        request.claimsDOSMD = 'DOS';
        request.taxId = '1234567890';
        request.NPI = '1234567890';
        request.MSID = 'xxxx121xxxx';
        request.TFN = '1234567890';
        request.memberId = '1234567890';
        request.callerType = 'CL';
		//US3070821-Added values for  OPTUM_VCCDBridgeController Code coverage-Prasad
        request.faroId = '1234567890';
        request.SSN = 'xxxxx2087';
        request.skill = 'Test';
        request.payer = 'Test';
        request.accountNumber = '7894561230';
        request.callReason = 'Test';
        request.callerId = 'Test';
        request.employer = 'Test';

        ACET_VCCDSoapAPI.ProcessVCCDInbound(request);

        User objUser = [Select id, Alias, Email, UserName from User where UserName =:SAEConstants.SAE_USER_ADMIN_USERNAME ];

        VCCD_Response__c objVccdResponse = [SELECT Id,ownerId,Ani__c, ClaimId__c, ClaimsDOSMD__c, MemberId__c, MSID__c, NPI__c, ProductType__c, QuestionType__c, SubjectDOB__c,
                                            		TaxId__c, TFN__c, Ucid__c,isActive__c FROM VCCD_Response__c LIMIT 1];

        System.runAs(objUser) {
            ACET_VCCDBridgeCtrl.getVCCDData();
            ACET_VCCDBridgeCtrl.updateCurrentRecordToInactive(objVccdResponse);
            ACET_VCCDBridgeCtrl.getUserDetails();
			//US3070821-Added below methods for  OPTUM_VCCDBridgeController Code coverage-Prasad
            OPTUM_VCCDBridgeController.getVCCDData();
            OPTUM_VCCDBridgeController.updateCurrentRecordToInactive(objVccdResponse);
            OPTUM_VCCDBridgeController.getUserDetails();
        }
        System.assertNotEquals(null, ACET_StateDropDownComboBox.getStateDetails());
    }

    @isTest
    static void testWithNoData(){
        //With no data
        ACET_VCCDSoapAPI.ProcessVCCDInbound(null);
    }


    @isTest
    static void testWithoutMsid(){
        //Without msid
        ACET_VCCDSoapAPI.ACET_VCCDRequest request = new ACET_VCCDSoapAPI.ACET_VCCDRequest();
        request.ani = '1234567890';
        request.subjectDOB = '1990-01-01';
        request.questionType= 'Test';
        request.productType= 'Test';
        request.claimId = '1234567890';
        request.ucid = 'Test';
        request.claimsDOSMD = 'DOS';
        request.taxId = '1234567890';
        request.NPI = '1234567890';
        request.MSID = '';
        request.TFN = '1234567890';
        request.memberId = '1234567890';
		//US3070821-Added below values for  OPTUM_VCCDBridgeController Code coverage-Prasad
        request.faroId = '1234567890';
        request.SSN = 'xxxxx2087';
        request.skill = 'Test';
        request.payer = 'Test';
        request.accountNumber = '7894561230';
        request.callReason = 'Test';
        request.callerId = 'Test';
        request.employer = 'Test';

        ACET_VCCDSoapAPI.ProcessVCCDInbound(request);

    }

    @isTest
    static void testCatch(){
        //To cause an exception
        ACET_VCCDSoapAPI.ACET_VCCDRequest request = new ACET_VCCDSoapAPI.ACET_VCCDRequest();
        request.ani = '1234567890';
        request.subjectDOB = '01/01/1980';
        request.questionType= 'Test';
        request.productType= 'Test';
        request.claimId = '1234567890';
        request.ucid = 'Test';
        request.claimsDOSMD = 'DOS';
        request.taxId = '1234567890';
        request.NPI = '1234567890';
        request.MSID = 'Test';
        request.TFN = '1234567890';
        request.memberId = '1234567890';
		//US3070821-Added below values for  OPTUM_VCCDBridgeController Code coverage-Prasad
        request.faroId = '1234567890';
        request.SSN = 'xxxxx2087';
        request.skill = 'Test';
        request.payer = 'Test';
        request.accountNumber = '7894561230';
        request.callReason = 'Test';
        request.callerId = 'Test';
        request.employer = 'Test';
        try{
            ACET_VCCDSoapAPI.ProcessVCCDInbound(request);
        }
        catch(Exception ex){

        }

    }
}