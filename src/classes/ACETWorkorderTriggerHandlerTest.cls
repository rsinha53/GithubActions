@isTest
public class ACETWorkorderTriggerHandlerTest {

    @isTest
    public static void updateViolationFieldTest(){
        test.startTest();
        list<workorder> lstWo = new list<workorder>();
        workorder wo = new workorder();
        wo.Status_Detail__c	 = 'Prior Authorization Received';
        wo.Host_System_Date_and_Time__c = datetime.now();
        wo.Violation__c = false;
        lstWo.add(wo);
        insert lstWo;
        wo.Violation__c = true;
        update lstWo;
        test.stopTest();
       
    }
}