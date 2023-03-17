@isTest
public with sharing class ACET_KLControllerTest {
    @isTest static void getKLData()
    {
        KL_Data__c kl=new KL_Data__c();
        kl.Name='123';
        kl.Code_Type__c='CPT';
        kl.Code_Description__c='ProcedureCode';
        insert kl;
        ACET_KLController.getKLData('123','ProcedureCode');
        ACET_KLController.getKLData('123','DiagnosisCode');
    }
}