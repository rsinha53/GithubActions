@isTest
public class TrialCustomerPortalHomePageTest {
    static testmethod void TrialCustomerPortalHomePageControllerTest() { 
        Account acc = new Account(Name = 'TestAcc');
        insert acc;
        Contact con = new Contact(AccountId = acc.Id,LastName = 'Test');
        insert con;
        Profile portalProfile = [SELECT Id FROM Profile Where Name = 'Care Advisor Connect Provider User' Limit 1];
        User usr;
        Id usrId = userinfo.getUserId();
        system.runAs(new user(id=usrId)){
            usr = new User(
                 Username = System.now().millisecond() + 'test12345@test.com',
                 ContactId = con.Id,
                 ProfileId = portalProfile.Id,
                 Alias = 'test123',
                 Email = 'test12345@test.com',
                 EmailEncodingKey = 'UTF-8',
                 LastName = 'McTesty',
                 CommunityNickname = 'test12345',
                 TimeZoneSidKey = 'America/Los_Angeles',
                 LocaleSidKey = 'en_US',
                 LanguageLocaleKey = 'en_US'
             );
             insert usr;
        }
        Case cas = new Case(Subject = 'Test', Status = 'Open',ContactId = con.Id,OwnerId = usrId);
        insert cas;
         system.runAs(usr){
             Solution sol = new Solution(SolutionName = 'Test',ispublished = true);
             insert sol;
             Asset ast = new Asset(Name = 'Product',SerialNumber='45333',
                                   InstallDate=system.today(),UsageEndDate=system.today()+30,
                                   Status = 'Active',ContactId = con.Id);
             insert ast;
             
             TrialCustomerPortalHomePageController portalCont = new TrialCustomerPortalHomePageController();
             portalCont.sortField1 = 'Name';
             portalCont.SortProducts();
             portalCont.previousSortField1 = 'Name';
             portalCont.SortProducts();
             portalCont.sortField2 = 'Subject';
             portalCont.SortCases();
			 portalCont.previousSortField2 = 'Subject';
			 portalCont.SortCases();
			 portalCont.sortField3 = 'SolutionName';
             portalCont.SortSolutions();
			 portalCont.previousSortField3 = 'SolutionName';
			 portalCont.SortSolutions();
			 portalCont.sortField4 = 'Title';
             portalCont.previousSortField4 = 'Title';
             superSort.sortList(new List<Case>{cas},'OwnerId','asc');
         }
     } 
}