@isTest
public class ACETTerminateMemberControllerTest{
    public static testmethod void ACETTerminateSubscriber() {
        
            PageReference ACETTerminate = Page.ACETTerminateMember;
            Interaction__c interactionId = TestDataFactory.createInteraction();
            Contact cont = TestDataFactory.createContact();
            ACETTerminate .getParameters().put('InteractionId', InteractionId.Id);
            ACETTerminate .getParameters().put('SRK', 'testing');
            ACETTerminate .getParameters().put('Id','0058999712107');
            ACETTerminate .getParameters().put('groupId','0123456');
            ACETTerminate .getParameters().put('coverageGroupNumber', '123456789'); 
            ACETTerminate .getParameters().put('coverageEffectiveDate', '07/05/2017'); 
            ACETTerminate .getParameters().put('coverageSRK', '123456789');
            Test.setCurrentPage(ACETTerminate);  
            test.starttest();     
            Apexpages.StandardController ACETPDStdCtrl = new Apexpages.standardController(InteractionId);
            ACETTerminateMemberController ACETTerminateContr = new ACETTerminateMemberController();
            ACETTerminateContr.comments ='test';
            ACETTerminateContr.getMemberData();
            ACETCallTopicsDataWrapper acetCallTopicDW = new ACETCallTopicsDataWrapper();
            acetCallTopicDW.saveCase();
            
            List<ACETCallTopicsDataWrapper> wrapperList = new List<ACETCallTopicsDataWrapper>();
            ACETHighlightsPanelAdditionalInfo AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
            AdditionalInfo.DOB = '12/27/2009';
            AdditionalInfo.SitusState = '12/27/2009';
            AdditionalInfo.EffectiveDate = '12/27/2009';
            AdditionalInfo.EndDate = '12/27/2009';
            AdditionalInfo.groupName  = 'Test';
            AdditionalInfo.Network    = 'Test';
            AdditionalInfo.OriginatorRelationship  = 'Test';
            AdditionalInfo.PolicyNumber  = 'UHC1234';
            AdditionalInfo.Product  = 'Product Test';
            AdditionalInfo.productType  = 'Care Service';
            AdditionalInfo.Relationship  = 'Primary';
            string jsonString = '{"ACETHighlightsPanelAdditionalInfo":[{"DOB":"12/27/2009","SitusState":"2011-10-04T16:58:54.858Z"}]}';
            ACETTerminateContr.AdditionalInfo = AdditionalInfo;
            ACETTerminateContr.Subject= cont;
            ACETTerminateContr.hpAdditionInfoStr = 'test';
            list<Alert__c> lstProvider = new list<Alert__c>();
            list<Alert__c> lstMember = new list<Alert__c>();
            Alert__c alerts = new Alert__c();
            alerts.Alert_Title__c = 'Test Alert1';
            alerts.Alert_Title__c = 'Test Alert2';
            lstMember.add(alerts);
            lstProvider.add(alerts);
            ACETTerminateContr.lstProviderAlert = lstProvider;
            ACETTerminateContr.lstMemAlert= lstMember;
            ACETTerminateContr.GetMembershipCallback();
            test.stoptest();
            system.AssertNotEquals(acetCallTopicDW.caseObj.id,null);
           
        
    
}

}