@isTest
public class  ACETProducerNotFoundControllerTest{
    
    static testMethod void ACETProducerNotFoundMethod(){
        PageReference ACETNotFoundPage = Page.ACETProducerNotFoundForm;
        ACETProducerNotFoundController pnf = new ACETProducerNotFoundController();
        pnf.producerName = 'Producer Name';
        pnf.contactName = 'Contact Name';
        pnf.State = 'CT';
        pnf.PhoneNumber = '123-123-1234';
        pnf.RedirectFromProducerNotFound();
    }    
    static testMethod void ACETProducerNotFoundExceptionMethod(){
        PageReference ACETNotFoundPage = Page.ACETProducerNotFoundForm;
        ACETProducerNotFoundController pnf = new ACETProducerNotFoundController();
        pnf.Interaction = null;
     //   pnf.producerName = 'Producer Name';
    //    pnf.contactName = 'Contact Name';
    //    pnf.State = 'CT';
    //    pnf.PhoneNumber = '123-123-1234';
        pnf.RedirectFromProducerNotFound();
    }    
}