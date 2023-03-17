/* Test Class for Members Claim Search UI Controller Class
Developer Name: Prakash Swain
Date: 08/15/2016
Rally UserStories ID:US335825 
*/

@istest
private class ACETMemberClaimSearchControllerTest{

static testMethod void testACETMemberClaimSearchController(){

       
       PageReference pageRef = Page.ACETMembersClaimSearch;
       Test.setCurrentPage(pageRef);
       ApexPages.currentPage().getParameters().put('qp', 'yyyy');
           ApexPages.currentPage().getParameters().put('searchBy', 'referralnumber');
      ACETMemberClaimSearchController Controller  = new ACETMemberClaimSearchController();
       Controller.clear();     
    	Controller.search(); 
       Controller.searchbyaction();
       Controller.cancel();
    Controller.searchBy='ClaimNumber';
    Controller.searchbyaction();
    Controller.searchBy='CaseNumber';
	Controller.searchbyaction();
    Controller.searchBy='AuthorizationNumber';
   Controller.searchbyaction();
    Controller.searchBy='referralnumber';
   Controller.searchbyaction();
    Controller.dateOfService='Day';
    Controller.dateServiceChange();
    Controller.dateOfService='ThisYear';
    Controller.dateServiceChange();
    Controller.dateOfService='LastYear';
    Controller.dateServiceChange();
}
    static testMethod void testACETMemberClaimSearchController1(){

       
       PageReference pageRef = Page.ACETMembersClaimSearch;
       Test.setCurrentPage(pageRef);
       ApexPages.currentPage().getParameters().put('qp', 'yyyy');
       ACETMemberClaimSearchController Controller  = new ACETMemberClaimSearchController();
	   Controller.searchBy = 'ClaimNumber';
       Controller.searchbyaction();
        Controller.dateOfService = 'Day';
       Controller.dateServiceChange();
}
    
    static testMethod void testACETMemberClaimSearchController2(){

       
       PageReference pageRef = Page.ACETMembersClaimSearch;
       Test.setCurrentPage(pageRef);
       ApexPages.currentPage().getParameters().put('qp', 'yyyy');
      ACETMemberClaimSearchController Controller  = new ACETMemberClaimSearchController();
	   Controller.searchBy = 'AuthorizationNumber';
       Controller.searchbyaction();
        Controller.dateOfService = 'ThisYear';
       Controller.dateServiceChange();
}
    static testMethod void testACETMemberClaimSearchController3(){

       
       PageReference pageRef = Page.ACETMembersClaimSearch;
       Test.setCurrentPage(pageRef);
       ApexPages.currentPage().getParameters().put('qp', 'yyyy');
       ACETMemberClaimSearchController Controller  = new ACETMemberClaimSearchController();
	   Controller.searchBy = 'referralnumber';
	   Controller.searchbyaction();
        Controller.dateOfService = 'LastYear';
       Controller.dateServiceChange();
}
    static testMethod void testACETMemberClaimSearchController4(){

       PageReference pageRef = Page.ACETMembersClaimSearch;
       Test.setCurrentPage(pageRef);
       ApexPages.currentPage().getParameters().put('qp', 'yyyy');
       ACETMemberClaimSearchController Controller  = new ACETMemberClaimSearchController();
	   Controller.searchBy = 'CaseNumber';
       Controller.searchbyaction();
        Controller.status = '';
        Controller.taxid = '';
        Controller.ReferralNumber = '';
        Controller.authnumberhide = true;
            
}


}