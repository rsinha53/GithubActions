@isTest(SeeAllData=false)
public class ACET_ClaimServiceLineDetailsCtrlTest {
    
     @testSetup static void setup()
     {
         Tool_Tip__c tip = new Tool_Tip__c();
         tip.SOP_or_Document_Link__c = 'Documentlink.com';
         tip.SOP_or_Document_Name__c = 'DocumentName';
         tip.Tip__c = 'Test Tip';
         tip.Tool_Tip_Type__c = 'Claim';
         tip.Value__c = 'P1';
         insert tip;
         
       }
    
    static testMethod void getTopics() {
        
        List<String> rcodes = new List<String>();
        rcodes.add('P1');
        rcodes.add('P2');
        
        List<Tool_Tip__c> tips = ACET_ClaimServiceLineDetailsController.getToolTips(rcodes);
        
        system.assertEquals(tips[0].Tip__c, 'Test Tip');
        
    }   

}