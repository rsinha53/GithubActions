@isTest
public class ACETFindFulfillmentHistoryJSON2ApexTest2{




    static testMethod void testParse() 
{

        ACETFindFulfillmentHistoryJSON2Apex.SearchParameter AFFJ2A4 = new ACETFindFulfillmentHistoryJSON2Apex.SearchParameter();

        AFFJ2A4.searchSourceID='test';

        AFFJ2A4.documentID='test';

    List<ACETFindFulfillmentHistoryJSON2Apex.SearchResultSet> SRS1= new List<ACETFindFulfillmentHistoryJSON2Apex.SearchResultSet>();

    ACETFindFulfillmentHistoryJSON2Apex.SearchResultSet SRS= new ACETFindFulfillmentHistoryJSON2Apex.SearchResultSet();

    ACETFindFulfillmentHistoryJSON2Apex.ResponseRequestHeader RRH= new ACETFindFulfillmentHistoryJSON2Apex.ResponseRequestHeader();

    //ResponseRequestHeader 

        RRH.requestID='test';

        RRH.sourceIDName='test';

        RRH.destinationIDName='test';

        RRH.requestDate='test';

        RRH.businessSegmentName='test';

        RRH.marketSegmentName='test';

        RRH.fulfillmentTypeBusName='test';

        RRH.requestCategory='test';

        RRH.dataFormat='test';

        RRH.requestorRefNo='test';

        RRH.supplierRefNo='test';

    ACETFindFulfillmentHistoryJSON2Apex.RequestTrailer RQT = new ACETFindFulfillmentHistoryJSON2Apex.RequestTrailer();

        RQT.requestItemCount=10;

        RRH.requestTrailer=RQT;

        SRS.responseRequestHeader=RRH;

    ACETFindFulfillmentHistoryJSON2Apex.ResponseCurrentEventLog RCEL= new ACETFindFulfillmentHistoryJSON2Apex.ResponseCurrentEventLog();

        RCEL.processorName='test';

        RCEL.eventTypeBusName='test';

        RCEL.receivedDate='test';

        RCEL.dispatchedDate='test';

        RCEL.statusCode='test';

        SRS.responseCurrentEventLog=RCEL;

    ACETFindFulfillmentHistoryJSON2Apex.ResponseRequestDetail RRD= new ACETFindFulfillmentHistoryJSON2Apex.ResponseRequestDetail();

    ACETFindFulfillmentHistoryJSON2Apex.ResponseTransactionalRequestDetail  RTRD = new ACETFindFulfillmentHistoryJSON2Apex.ResponseTransactionalRequestDetail();

    List<ACETFindFulfillmentHistoryJSON2Apex.ResponseRecipient> RR1 =new List<ACETFindFulfillmentHistoryJSON2Apex.ResponseRecipient>();

    ACETFindFulfillmentHistoryJSON2Apex.ResponseRecipient RR =new ACETFindFulfillmentHistoryJSON2Apex.ResponseRecipient();




        RR.recipientId='test';

        RR.identifierQualifierCodeDescr='test';

        RR.deliveryMethod1='test';

        RR.constituentTypeDescr='test';

    ACETFindFulfillmentHistoryJSON2Apex.Person PER = new ACETFindFulfillmentHistoryJSON2Apex.Person();

        PER.prefix='test';

        PER.firstName='test';

        PER.middleName='test';

        PER.lastName='test';

        PER.suffix='test';

        RR.person=PER;

    ACETFindFulfillmentHistoryJSON2Apex.MailToAddress MA =new ACETFindFulfillmentHistoryJSON2Apex.MailToAddress();

        MA.Address1='test';

        MA.Address2='test';

        MA.Address3='test';

        MA.City='test';

        MA.State='test';

        MA.Zip='test';

        RR.MailToAddress=MA;

        RR.ReturnToAddress=MA;

        RR.faxNumber='test';

        RR.emailAddress='test';

    ACETFindFulfillmentHistoryJSON2Apex.ResponseTemplate RT = new ACETFindFulfillmentHistoryJSON2Apex.ResponseTemplate();

        RT.templateID='test';

        RT.templateName='test';

        RR1.add(RR);

        RTRD.responseRecipient =RR1;

        RTRD.responseTemplate=RT; 

        RRD.responseTransactionalRequestDetail=RTRD;

        SRS.responseRequestDetail=RRD;

    List<ACETFindFulfillmentHistoryJSON2Apex.ResponseRequestHistory> RRHT1= new List<ACETFindFulfillmentHistoryJSON2Apex.ResponseRequestHistory>();

    ACETFindFulfillmentHistoryJSON2Apex.ResponseRequestHistory RRHT= new ACETFindFulfillmentHistoryJSON2Apex.ResponseRequestHistory();




        RRHT.processorName='test';

        RRHT.eventTypeBusName='test';

        RRHT.receivedDate='test';

        RRHT.dispatchedDate='test';

        RRHT.recipientId='test';

        RRHT.deliveryMethodCd='test';

        RRHT.statusCode='test';

        RRHT.successCount='test';

        RRHT.exceptionCount='test';

        RRHT.documentID='test';

        RRHT.documentType='test';

        RRHT.repositoryName='test';

        RRHT1.add(RRHT);

        SRS.responseRequestHistory=RRHT1; 

        SRS1.ADD(SRS);

    ACETFindFulfillmentHistoryJSON2Apex.FindFulfillmentHistoryResponse AFFJ2A3 = new ACETFindFulfillmentHistoryJSON2Apex.FindFulfillmentHistoryResponse();

        AFFJ2A3.searchParameter=AFFJ2A4;

        AFFJ2A3.searchResultSet=SRS1;

    ACETFindFulfillmentHistoryJSON2Apex.FindFulfillmentHistoryResult AFFJ2A2 = new ACETFindFulfillmentHistoryJSON2Apex.FindFulfillmentHistoryResult();

        AFFJ2A2.findFulfillmentHistoryResponse=AFFJ2A3;

    

    }

}