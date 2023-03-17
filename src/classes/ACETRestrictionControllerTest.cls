@isTest
private class ACETRestrictionControllerTest{
    
    static testMethod void GroupRestrictionTestmethod() {
            Test.startTest();
            Pagereference ACETRestrictionpage = page.ACETRestriction;
            ACETRestrictionpage.getparameters().put('blockpage','group');
            Test.setCurrentPage(ACETRestrictionpage);
            
            ACETCallTopicsDataWrapper acetCallTopicDW = new ACETCallTopicsDataWrapper();
            ACETRestrictionController restricCont= new ACETRestrictionController(); 
            restricCont.restrictedMessage='test';
            restricCont.wrapper=acetCallTopicDW;
            Test.stopTest();  
    }
     static testMethod void MemberRestrictionTestmethod() {
            Test.startTest();
            Pagereference ACETRestrictionpage = page.ACETRestriction;
            ACETRestrictionpage.getparameters().put('blockpage','Member');
            Test.setCurrentPage(ACETRestrictionpage);

            ACETRestrictionController restricCont= new ACETRestrictionController(); 
            restricCont.restrictedMessage='test';
            Test.stopTest();  
    }
}