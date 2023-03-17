@isTest
public class ACETFindFulfillmentHistoryJSON2ApexTest{




    static testMethod void testParse() {



        ACETFindFulfillmentHistoryJSON2Apex acetJson = new ACETFindFulfillmentHistoryJSON2Apex();
        
        ACETFindFulfillmentHistoryJSON2Apex.FindFulfillmentHistoryResult findhis= new ACETFindFulfillmentHistoryJSON2Apex.FindFulfillmentHistoryResult();
        
        acetJson.findFulfillmentHistoryResult= findhis;

        String json = '{findFulfillmentHistoryResult:{findFulfillmentHistoryResponse:{searchParameter: Test,searchResultSet:[{responseRequestHeader:{requestTrailer: Test},responseCurrentEventLog: Test,responseRequestDetail:{responseTransactionalRequestDetail:{responseRecipient:[{mailToAddress: mailto@gmail.com}],responseTemplate: Test},}, responseRequestHistory:[]}]  }}}';








        //ACETFindFulfillmentHistoryJSON2Apex r = ACETFindFulfillmentHistoryJSON2Apex.parse(json);

        //System.assert(r != null);




        /*json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';

        ACETFindFulfillmentHistoryJSON2Apex.RequestTrailer objRqTrailer = new ACETFindFulfillmentHistoryJSON2Apex.RequestTrailer(System.JSON.createParser(json));

        System.assert(objRqTrailer != null);

        //System.assert(objRqTrailer.requestItemCount == null);




        json = '{"TestAMissingObject": { "TestAMissingArray": [ { "TestAMissingProperty": "Some Value" } ] } }';

        ACETFindFulfillmentHistoryJSON2Apex.ResponseRequestHistory objResRqHistory = new ACETFindFulfillmentHistoryJSON2Apex.ResponseRequestHistory(System.JSON.createParser(json));

        System.assert(objResRqHistory != null);*/

    

    }

}