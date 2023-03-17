@isTest
public class ETSBE_ProducerDetailController_Test {
    
    Public static testmethod void detailmethod(){
        Test.startTest();
        
        ETSBE_SolarisMockupResponse brokerResponse = new ETSBE_SolarisMockupResponse(200,
                                                 'Success',
                                                 '{"response":{"serviceAttributes":{"applicationIdentifier":"ACET","requestIdentifier":"","producerGroupAssociation":"","pageNumber":1,"recordsPerPage":20,"requestEffectiveDate":"04-16-2020","totalNumberOfRecords":10,"responseCode":200,"responseDescription":"Success"},"getProducerResponse":{"producerID":"011457","producerCompanyName":"","producerIndividualName":{"firstName":"ROBERTA","middleInitial":"W","lastName":"CZARNECKI"},"producerSSN":"045620713","producerTIN":"","producerType":"I","producerContact":"DOUGLAS FINANCIAL SERVICES INC","producerEffectiveStartDate":"04/10/1995","producerEffectiveEndDate":"12/31/9999","producerAddress":{"addressTypeCode":"M","producerStreetLine1":"500 E MAIN ST STE 316","producerStreetLine2":"","producerCity":"BRANFORD","producerState":"CT","producerZipCode":"06405","producerZipCodeSuffix":"2937","producerPhoneNumber":"2034887200"},"producerStatus":"Active","legacyProducers":[{"legacyProducerSystem":"PUL","legacyProducerID":"BN3182"}],"customerDetails":[{"customerNumber":"0280340","customerName":"NICHOLAS MONICK JR. EXCAVATING","adminSystem":"PR"},{"customerNumber":"04Y7677","customerName":"AGEMY FINANCIAL STRATEGIES INC","adminSystem":"PR"},{"customerNumber":"1259580","customerName":"BALLARDS DIESEL SERVICE LLC","adminSystem":"CR"},{"customerNumber":"1259793","customerName":"SC BALLARD LLC","adminSystem":"CR"},{"customerNumber":"1265277","customerName":"LJ NEW HAVEN LLC","adminSystem":"CR"},{"customerNumber":"1266582","customerName":"AGEMY FINANCIAL STRATEGIES INC","adminSystem":"CR"},{"customerNumber":"1269111","customerName":"HI TECH PACKAGING INC","adminSystem":"CR"},{"customerNumber":"1272778","customerName":"CONTINUUM CARE HOLDINGS LLC","adminSystem":"CR"},{"customerNumber":"1277876","customerName":"PARENT & PARENT LLP","adminSystem":"CR"},{"customerNumber":"1278851","customerName":"JMA ENTERPRISES INC","adminSystem":"CR"}]}}}',
                                                 null);
        Test.setMock(HttpCalloutMock.class, brokerResponse);
        ETSBE_ProducerDetailController.getProducerDetail('011457');
        ETSBE_GetBrokerSearchJSON2Apex testJson2Apex = new ETSBE_GetBrokerSearchJSON2Apex();
        testJson2Apex.response = new ETSBE_GetBrokerSearchJSON2Apex.BrokerResponse();
        testJson2Apex.response.serviceAttributes = new ETSBE_GetBrokerSearchJSON2Apex.ServiceAttributes();
        testJson2Apex.response.serviceAttributes.applicationIdentifier = 'test';
        testJson2Apex.response.serviceAttributes.requestIdentifier = 'test';
        testJson2Apex.response.serviceAttributes.requestedDate = 'test';
        testJson2Apex.response.serviceAttributes.producerGroupAssociation = 'test';
        testJson2Apex.response.serviceAttributes.producerAndGroupFlag = 'test';
        testJson2Apex.response.serviceAttributes.pageNumber = 1;
        testJson2Apex.response.serviceAttributes.recordsPerPage = 1;
        testJson2Apex.response.serviceAttributes.totalNumberOfRecords = 1;
        testJson2Apex.response.serviceAttributes.responseCode = 1;
        testJson2Apex.response.serviceAttributes.responseDescription = 'test';
        Test.stopTest();
    }
}