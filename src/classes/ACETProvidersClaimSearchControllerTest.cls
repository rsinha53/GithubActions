/* Test Class for Providers Claim Search UI Controller Class
Developer Name: Prakash Swain
Date: 08/16/2016
UserStories ID:US357155 
*/

@istest
private class ACETProvidersClaimSearchControllerTest{

static testMethod void testACETProvidersClaimSearchController(){

       
       PageReference pageRef = Page.ACETProvidersClaimSearch;
       Test.setCurrentPage(pageRef);
       ApexPages.currentPage().getParameters().put('qp', 'yyyy');
      ACETProviderClaimSearchController Controller  = new ACETProviderClaimSearchController();

       Controller.clear();
       Controller.search();
       Controller.searchbyaction();
       Controller.dateServiceChange();
       Controller.cancel();
}
    
    static testMethod void testACETProvidersClaimSearchControllertwo(){

       
       PageReference pageRef = Page.ACETProvidersClaimSearch;
       Test.setCurrentPage(pageRef);
       ApexPages.currentPage().getParameters().put('qp', 'yyyy');
      ACETProviderClaimSearchController Controller  = new ACETProviderClaimSearchController();
       Controller.searchBy = 'ClaimNumber';
       Controller.status = 'test';
       Controller.taxid ='12345';
       Controller.ReferralNumber ='12345';
       Controller.clear();
       Controller.search();
       Controller.searchbyaction();
       Controller.dateServiceChange();
       Controller.cancel();
}

}