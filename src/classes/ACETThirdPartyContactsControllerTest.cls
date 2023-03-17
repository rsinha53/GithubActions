/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class ACETThirdPartyContactsControllerTest {
    static Contact testSubject;
    static Interaction__c interaction;
    static testMethod void getThirdPartyListPositive() {
        
        
    }
    static testMethod void updatehighlightPanelStrPositive() {
        
        
    }
    static testMethod void addNewThirdPartyPositive() { 
        setupdata();
        //ACETHighlightsPanelAdditionalInfo additional = new ACETHighlightsPanelAdditionalInfo ();
        
        ACETThirdPartyContactsController cntrl = new ACETThirdPartyContactsController();
        cntrl.additionalInfo = new ACETHighlightsPanelAdditionalInfo();
        cntrl.SourceOriginator = 'Nikki';
        cntrl.SubjectId = testSubject.Id;
        System.debug('testSubject.Id-->'+testSubject.Id);
        cntrl.interaction = interaction;
        cntrl.getThirdPartyList();
        cntrl.TPOriginator.third_party__r.first_name__c = 'Nikki';
        cntrl.TPOriginator.third_party__r.LastName__c = 'Reed';
        cntrl.TPOriginator.third_party__r.Phone_Number__c = '1212121212';

        cntrl.addNewThirdParty();
        //String selectedId = testSubject.Id;
        String selectedId = cntrl.TPOriginatorList[0].third_party__c;
        System.debug('TPOriginatorList-->'+cntrl.TPOriginatorList[0].third_party__c);
        System.debug('selectedId-->'+selectedId);
        PageReference ACETPDPage = Page.ACETMemberDetail;
        
        ACETPDPage.getParameters().put('selectedRow',selectedId);
        test.setCurrentPage(ACETPDPage);
        cntrl.additionalInfo = new ACETHighlightsPanelAdditionalInfo();
        cntrl.updatehighlightPanelStr();
        ACETPDPage.getParameters().put('updatedTOP',selectedId);        
        cntrl.updateInteraction();
        ACETPDPage.getParameters().put('selectedEditRow',selectedId);
        cntrl.updateThirdParty();
        cntrl.updateUI();
        cntrl.populateEditPopup();
        
    }
    static testMethod void updateThirdPartyNegative() {
        ACETThirdPartyContactsController cntrl = new ACETThirdPartyContactsController();
        cntrl.TPOriginatorList = Null;
        
    }
    static testMethod void populateEditPopupPositive() {
        
        
    }      
    static void  setupdata(){
        Account testAccount  = ACETTestDataUtility.createAccount('TestAccount');
        testSubject = ACETTestDataUtility.createContact(testAccount.Id,'Nikki','Reed');
        insert testSubject;
        
        interaction = new Interaction__c();
        interaction.Originator__c = testSubject.Id;
        interaction.Interaction_Type__c = 'Phone Call';
        interaction.Originator_Type__c = 'Member';
        insert interaction;

    }  
}