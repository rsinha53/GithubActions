@isTest
public class ACETDynamicCallTypesControllerTest{
    public static testMethod void ACETDynamicCallTypesContr() {
       Test.StartTest();
       
       Swivel_Topic__c swivelTopic =new Swivel_Topic__c();
       swivelTopic.Account_Type__c='test'; 
       swivelTopic.Call_Type__c='test'; 
       swivelTopic.Active__c=true; 
       swivelTopic.Swivel_Topic__c='Life Inquiry'; 
       insert swivelTopic;
       
       List<String> picklistcalltypes=new List<String> {'test','test1','test3'};
       List<String> Accountcalltypes=new List<String> {'test','test1','test3'};
       ACETDynamicCallTypesDisplayController Calltypes= new ACETDynamicCallTypesDisplayController();
       Calltypes.selectedPicklistCallType ='test';
       Calltypes.attrCallTop='Life Inquiry'; 
       Calltypes.attrLabel='test'; 
       Calltypes.selectedCallType =picklistcalltypes;
       Calltypes.selectedAccountType =Accountcalltypes;
       Calltypes.getDynamicPickListCallTypes();
       Calltypes.getDynamicCallTypes();
       Calltypes.getDynamicCallTypess();
       Calltypes.getAccountType();
       Test.StopTest();
    }  
 }