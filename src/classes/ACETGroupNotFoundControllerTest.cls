@isTest(SeeAllData=false)
public class ACETGroupNotFoundControllerTest{

static testMethod void ACETGroupNotFoundMethod() {
    
        PageReference ACETNotFoundPage = Page.ACETGroupNotFoundForm;
        ACETNotFoundPage.getParameters().put('DOB', '1/1/2017');
        ACETNotFoundPage.getParameters().put('InteractionId','');
        ACETGroupNotFoundController nf = new ACETGroupNotFoundController();
        nf.dateOfBirth = System.today();
      
    }
    
    static testMethod void ACETGroupNotFoundMethodFlow() {
    
        PageReference ACETNotFoundPage = Page.ACETGroupNotFoundForm;
        Interaction__c inte = TestDataFactory.createInteraction();
        ACETNotFoundPage.getParameters().put('InteractionId',inte.id);
        ACETGroupNotFoundController nf = new ACETGroupNotFoundController();
        nf.EmployerName = 'Test';
        nf.GroupNumber = 'Test';
        nf.LastName = 'Test';
        nf.FirstName = 'Test';
        nf.groupNumber = '12312312300';
        nf.zipcode = '11111';
        nf.State = 'CT';
        nf.PhoneNumber = '111-111-1111';
        nf.ContactName ='Test';
        nf.RedirectFromGroupNotFound();
    }

     
}