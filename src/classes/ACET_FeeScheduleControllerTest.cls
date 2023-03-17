@isTest
public class ACET_FeeScheduleControllerTest {

    static testMethod void test_callScheduleService(){
        List<ACET_FeeScheduleController.FSRequest> requestList = new List<ACET_FeeScheduleController.FSRequest>();
        ACET_FeeScheduleController.FSRequest request = new ACET_FeeScheduleController.FSRequest();
        request.startDate='03/08/2021';
        request.endDate='03/08/2021';
        request.pos='11';
        request.cpthcpc='99214';
        request.modifier = '24,25';
        request.dx = 'O0901';
        request.type = 'D';
        request.count = '1';
        request.billedAmount = '200.00';
        request.contractId = '';
        
        request.conPayMeth = '';
        request.rateTblNo = '';
        request.icdVerInd = '';
        request.prodCode = '';
        request.prodOffId = '';
        request.taxId = '';
        request.provId='002946654';
        request.market = '42577';
        request.mktType = '63';
        request.ipa = '';
        request.feeSchedNo = '70646';
        
        request.contractType = '';
        requestList.add(request);
        
        ACET_AutoDocUtil.TableDetails currentTbl = new ACET_AutoDocUtil.TableDetails();
        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.ACET_FeeScheduleServiceResponse_200());
        Test.startTest();
        ACET_FeeScheduleController.callScheduleService(requestList, currentTbl);
        Test.stopTest();
        
    }
    
    static testMethod void test_callScheduleService_Claim(){
        List<ACET_FeeScheduleController.FSRequest> requestList = new List<ACET_FeeScheduleController.FSRequest>();
        ACET_FeeScheduleController.FSRequest request = new ACET_FeeScheduleController.FSRequest();
        request.startDate='03/08/2021';
        request.endDate='03/08/2021';
        request.pos='11';
        request.cpthcpc='99214';
        request.modifier = '24,25';
        request.dx = 'O0901';
        request.type = 'D';
        request.count = '1';
        request.billedAmount = '200.00';
        request.contractId = '';
        requestList.add(request);
        
        ACET_AutoDocUtil.TableDetails currentTbl = new ACET_AutoDocUtil.TableDetails();
        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.ACET_FeeScheduleServiceResponse_200());
        Test.startTest();
        ACET_FeeScheduleController.callScheduleService_Claim(requestList);
        Test.stopTest();        
    }
    
    static testMethod void test_callContractService(){
        
        String provId = '000008677';
        String taxId = '382084239';
        String mktType = '50';
        String mktNbr = '0029523';
        String prdtOffCd = 'C2';
        
        List<ACET_FeeScheduleController.FSRequest> requestList = new List<ACET_FeeScheduleController.FSRequest>();
        ACET_FeeScheduleController.FSRequest request = new ACET_FeeScheduleController.FSRequest();
        request.startDate='03/08/2021';
        request.endDate='03/08/2021';
        request.pos='11';
        request.cpthcpc='99214';
        request.modifier = '24,25';
        request.dx = 'O0901';
        request.type = 'D';
        request.count = '1';
        request.billedAmount = '200.00';
        request.contractId = '';
        requestList.add(request);

        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.ACET_ProviderContractService_200());
        Test.startTest();
        ACET_FeeScheduleController.callContractService(provId, taxId, mktType, mktNbr, prdtOffCd, requestList);
        Test.stopTest();   
    }
    
    static testMethod void test_getPOSCodes(){
        ACET_FeeScheduleController.getPOSCodes();
		ACET_FeeScheduleController.billTypecheck('118');
    }
}