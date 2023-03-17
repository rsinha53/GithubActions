@isTest(SeeAllData=false)
private class ACETProviderNotFoundControllerTest {
    
    static testMethod void ACETProviderNotFoundControllerTest1() {
        Test.startTest();
        
        PageReference ACETPNFPage = Page.ACETProviderNotFoundForm;
        
        ACETPNFPage.getParameters().put('IT', 'Phone Call');
        ACETPNFPage.getParameters().put('CN', 'ContactName');
        ACETPNFPage.getParameters().put('TID', '123456789');
        ACETPNFPage.getParameters().put('NPI', '1234567890');
        ACETPNFPage.getParameters().put('LN', 'LastName');
        ACETPNFPage.getParameters().put('FN', 'FirstName');
        ACETPNFPage.getParameters().put('Phone', '9876543210');
        
        test.setCurrentPage(ACETPNFPage);    
        
        ACETProviderNotFoundController testClassInstance= new ACETProviderNotFoundController();
        testClassInstance.InteractionType = 'Phone Call';
        testClassInstance.ContactName = 'ContactName';
        testClassInstance.TaxID       = '123456789';
        testClassInstance.Npi         = '1234567890';
        testClassInstance.LastName    = 'LastName';
        testClassInstance.firstName   = 'FirstName';
        testClassInstance.phoneNumber = '9876543210';
        PageReference pageRef = testClassInstance.RedirectFromProviderNotFound();
        
        Test.stopTest();
    }
    
    static testMethod void ACETProviderNotFoundControllerTest2() {    
        ACETProviderNotFoundController testClassInstance= new ACETProviderNotFoundController();
        testClassInstance.InteractionType = 'Chat';
        testClassInstance.ContactName = 'ContactName';
        testClassInstance.TaxID       = '987654321';
        testClassInstance.Npi         = '0987654321';
        testClassInstance.LastName    = 'LastName';
        testClassInstance.firstName   = 'FirstName';
        testClassInstance.phoneNumber = '9876543210';
        Test.startTest();
        PageReference pageRef = testClassInstance.RedirectFromProviderNotFound();
        Test.stopTest();
    }
    
    static testMethod void ACETProviderNotFoundControllerTest3() {    
        ACETProviderNotFoundController testClassInstance= new ACETProviderNotFoundController();
        testClassInstance.InteractionType = 'ABC';
        testClassInstance.ContactName = 'ContactName';
        testClassInstance.TaxID       = '987654321';
        testClassInstance.Npi         = '0987654321';
        testClassInstance.LastName    = 'LastName';
        testClassInstance.firstName   = 'FirstName';
        testClassInstance.phoneNumber = '9876543210';
        Test.startTest();
        PageReference pageRef = testClassInstance.RedirectFromProviderNotFound();
        Test.stopTest();
    }
}