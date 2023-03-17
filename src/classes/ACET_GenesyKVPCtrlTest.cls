@isTest
public class ACET_GenesyKVPCtrlTest {
	
    static testMethod void testGenesysData(){
        
        PageReference PageRef = Page.ACET_GenesysKVPListener;
        Test.setCurrentPage(PageRef);
        ApexPages.currentPage().getParameters().put('Ani__c','123');
        ApexPages.currentPage().getParameters().put('ClaimId__c','456');
        ApexPages.currentPage().getParameters().put('ClaimsDOSMD__c','789');
        ApexPages.currentPage().getParameters().put('MemberId__c','123');
        ApexPages.currentPage().getParameters().put('MSID__c','456');
        ApexPages.currentPage().getParameters().put('NPI__c','789');
        ApexPages.currentPage().getParameters().put('ProductType__c','123');
        ApexPages.currentPage().getParameters().put('QuestionType__c','456');
        ApexPages.currentPage().getParameters().put('TaxId__c','789');
        ApexPages.currentPage().getParameters().put('Ucid__c','012');
        ApexPages.currentPage().getParameters().put('SubjectDOB__c','345');
        ApexPages.currentPage().getParameters().put('TFN__c','678');
        
        ACET_GenesysKVPCntrl objController = new ACET_GenesysKVPCntrl();
        
        System.assertNotEquals(null,objController.getGenesysData() );
        
    }
    
}