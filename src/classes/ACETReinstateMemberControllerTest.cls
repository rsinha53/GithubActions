@isTest
public class ACETReinstateMemberControllerTest {
    public static testmethod void ACETReinstatePage() {

            PageReference ACETReinstate = Page.ACETReinstateMember;
            Interaction__c interactionId = TestDataFactory.createInteraction();
            Contact cont = TestDataFactory.createContact();
            ACETReinstate.getParameters().put('InteractionId', InteractionId.Id);
            ACETReinstate.getParameters().put('SRK', 'test');
            ACETReinstate.getParameters().put('Id','0058999712107');
            ACETReinstate.getParameters().put('groupId','123456789'); 
            ACETReinstate.getParameters().put('coverageGroupNumber', '123456789'); 
            ACETReinstate.getParameters().put('coverageEffectiveDate', '07/05/2017'); 
            ACETReinstate.getParameters().put('coverageSRK', '123456789');           
            Test.setCurrentPage(ACETReinstate);  
            test.starttest();     
            Apexpages.StandardController ACETPDStdCtrl = new Apexpages.standardController(InteractionId);
            
            ACETReinstateMemberController ACETReinstateContr = new ACETReinstateMemberController();
            ACETReinstateContr.getMemberData();
            ACETReinstateContr.toggleExceptionChk();
            ACETReinstateContr.GetMembershipCallback();
            ACETCallTopicsDataWrapper acetCallTopicDW = new ACETCallTopicsDataWrapper();
            acetCallTopicDW.saveCase();
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
            ACETReinstateContr.AdditionalInfo = AdditionalInfo;
            ACETReinstateContr.hpAdditionInfoStr = 'test';
            list<Alert__c> alerts = new list<Alert__c>();
            ACETReinstateContr.lstProviderAlert = alerts;
            ACETReinstateContr.Subject = cont;
            ACETReinstateContr.memberID = 00123455;
            ACETReinstateContr.comments= 'test comments';
            ACETReinstateContr.AutoDoc='test doc';
            test.stoptest();
            system.AssertNotEquals(acetCallTopicDW.caseObj.id,null);
           
    }
}