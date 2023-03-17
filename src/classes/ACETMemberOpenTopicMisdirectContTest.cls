@isTest
public class ACETMemberOpenTopicMisdirectContTest{
    static testMethod void CreateCase(){
    
    ACETMemberOpenTopicMisdirectController controller=new ACETMemberOpenTopicMisdirectController();
    controller.createCase();
    

    
    Case c=new Case();
    c.Status='Canceled';
    c.Topic__c='Accumulator';
    insert c;
    
    Case c1=new Case();
    c.Status='Canceled';
    insert c1;
    
String str= JSON.Serialize(c);
String str1=JSON.Serialize(c1);
    Boolean res=ACETMemberOpenTopicMisdirectController.createCaseRA(str1,str);    
}
}