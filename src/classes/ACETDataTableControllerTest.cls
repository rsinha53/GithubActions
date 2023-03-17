@isTest
private class ACETDataTableControllerTest {
  static testMethod void test(){    
        MockHttpCalloutResponseGenerator.MockHttpResponse OILResponse =  new MockHttpCalloutResponseGenerator.MockHttpResponse(200, 'OK', ACETTestDataUtility.GetMemberSearchJSON());
        OILResponse.TokenExpired = false;        
        MockHttpCalloutResponseGenerator MockHttpRes = new MockHttpCalloutResponseGenerator(null, OILResponse);
        Test.setMock(HttpCalloutMock.class, MockHttpRes); 
        
        ACETFindMemberWebService FindMemberService = new ACETFindMemberWebService();
        FindMemberService.init('123456', '', '', '', '', '');
        
        ACETDataTableWrapper wrapper = new ACETDataTableWrapper('ACETFindMemberWebService', FindMemberService);
        wrapper.getStrColumns();
        wrapper.Columns.add(new ACETDataTableWrapper.DataColumn('col1','col1'));
         
        ACETDataTableController.queryPaginatedData('ACETFindMemberWebService', JSON.serialize(FindMemberService), 1, 1,1);
  }    
}