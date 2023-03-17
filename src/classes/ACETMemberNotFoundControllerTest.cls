@isTest(SeeAllData=false)
public class ACETMemberNotFoundControllerTest{

static testMethod void ACETMemberNotFoundMethod() {
    
        PageReference ACETNotFoundPage = Page.ACETMemberNotFoundForm;
        ACETNotFoundPage.getParameters().put('DOB', '1/1/2017');
        ACETNotFoundPage.getParameters().put('InteractionId','');
        ACETMemberNotFoundController nf = new ACETMemberNotFoundController();
        nf.dateOfBirth = System.today();
        //nf.RedirectFromMemberNotFound();
    }
    
    static testMethod void ACETMemberNotFoundMethodFlow() {
    
        PageReference ACETNotFoundPage = Page.ACETMemberNotFoundForm;
        Interaction__c inte = TestDataFactory.createInteraction();
        ACETNotFoundPage.getParameters().put('InteractionId',inte.id);
        ACETMemberNotFoundController nf = new ACETMemberNotFoundController();
        nf.EmployerName = 'Test';
        nf.GroupNumber = 'Test';
        nf.LastName = 'Test';
        nf.FirstName = 'Test';
        nf.memberId = '12312312300';
        nf.zipcode = '11111';
        nf.State = 'CT';
        nf.PhoneNumber = '111-111-1111';
        nf.RedirectFromMemberNotFound();
    }
     
}