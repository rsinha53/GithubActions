@isTest
public class ACET_AppealTest {
    private static final String CON_TYPE = 'Content-Type';
    private static final String CON_TYPE_JSON = 'application/json';

    @testSetup static void setupCS(){
        Organization_Properties__c orgProps = Organization_Properties__c.getOrgDefaults();
        orgProps.OrganizationName__c = 'QA';
        Upsert orgProps;

        // Token API data
        WebserviceConfigurations__c tokenAPIWSConfig = ACET_WebserviceCalloutFramework_Test.createTokenWSConfigs('LinkServiceTokenAPI');
        OrgSpecificConfigurations__c tokenAPIOrgSpecificConfigs = ACET_WebserviceCalloutFramework_Test.createTokenOrgWSConfigs(tokenAPIWSConfig.Id);

        // Service API data
        WebserviceConfigurations__c wsConfig = ACET_WebserviceCalloutFramework_Test.createWSConfig('LinkAppealSearch', tokenAPIWSConfig.Id);
        OrgSpecificConfigurations__c orgSpecificConfigs = ACET_WebserviceCalloutFramework_Test.createOrgWSConfigs(wsConfig.Id);
        WebserviceConfigurations__c wsConfig2 = ACET_WebserviceCalloutFramework_Test.createWSConfig('LinkAppealDetails', tokenAPIWSConfig.Id);
        OrgSpecificConfigurations__c orgSpecificConfigs2 = ACET_WebserviceCalloutFramework_Test.createOrgWSConfigs(wsConfig2.Id);
    }

    @isTest
    public static void searcAppealsTest(){
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('AppealResponse');
        mock.setStatusCode(200);
        mock.setHeader(CON_TYPE, CON_TYPE_JSON);

        Test.setMock(HttpCalloutMock.class, mock);
        
        ACET_AppealsService.AppealRequest req = new ACET_AppealsService.AppealRequest();
        req.tin = '123456789';
        req.memberId = '123456789';
        req.patientFn = '123456789';
        req.patientLn = '123456789';
        req.appealId = '123456789';
        req.claimNumber = '123456789';
        req.firstSubmDt = '1/1/2012';
        req.lastSubmDt = '1/31/2012';

        Test.startTest();
        ACET_AutoDocUtil.TableDetails tableCNS = ACET_ViewAppealsController.getCNSAppealTable(req);
        ACET_AutoDocUtil.TableDetails tableMNR = ACET_ViewAppealsController.getENIMNRAppealTable(req);
        System.assertNotEquals(tableCNS, null, 'CNS Not null');
        System.assertNotEquals(tableMNR, null, 'MNR Not null');
        Test.stopTest();
    }

    @isTest
    public static void searcAppealsTestFail(){
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('AppealResponse');
        mock.setStatusCode(404);
        mock.setHeader(CON_TYPE, CON_TYPE_JSON);

        Test.setMock(HttpCalloutMock.class, mock);
        
        ACET_AppealsService.AppealRequest req = new ACET_AppealsService.AppealRequest();
        req.tin = '123456789';
        req.memberId = '123456789';
        req.patientFn = '123456789';
        req.patientLn = '123456789';
        req.appealId = '123456789';
        req.claimNumber = '123456789';
        req.firstSubmDt = '1/1/2012';
        req.lastSubmDt = '1/31/2012';

        Test.startTest();
        ACET_AutoDocUtil.TableDetails tableCNS = ACET_ViewAppealsController.getCNSAppealTable(req);
        System.assertNotEquals(tableCNS, null, 'Table Not null');
        Test.stopTest();
    }

    @isTest
    public static void appealDetailsTest(){
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('AppealDetailResponse');
        mock.setStatusCode(200);
        mock.setHeader(CON_TYPE, CON_TYPE_JSON);

        Test.setMock(HttpCalloutMock.class, mock);

        Test.startTest();
        ACET_AppealDetailCtrl.AppealDetailWrapper resp = ACET_AppealDetailCtrl.getAppealInfo('123456789', '123456789');
        System.assertNotEquals(resp, null, 'Error: Not null');
        Test.stopTest();
    }
}