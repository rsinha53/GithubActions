@IsTest
public class ACETLGT_ThirdPartyContactsTest {
    public testmethod static void test(){
        ACETLGT_ThirdPartyContactsController atpc = new ACETLGT_ThirdPartyContactsController();
        Interaction__c inc = new Interaction__c();
        insert inc;
        ACETLGT_ThirdPartyContactsController.setInteractions(inc.Id,null);
        ACETLGT_ThirdPartyContactsController.queryThirdParties('');
        ACETLGT_ThirdPartyContactsController.addNewThirdParty('', '', '', '', '', null,inc.Id, null);
        Third_Party__c tp = new Third_Party__c();
        insert tp;
        ACETLGT_ThirdPartyContactsController.addNewThirdParty('', '', '', '', '', null,inc.Id, tp.id);
    }
}