/**
 * @name         	:  ACET_CPM_RootCauseControllerTest
 * @description  	:  This is test class for ACET_CPM_RootCauseController
 * @author       	:  Ganesh Medisetti
 * @createddate  	:  13/05/2021
 * @Apex Class Name	:  ACET_CPM_RootCauseController
 **/
@isTest
public class ACET_CPM_RootCauseControllerTest {
    static testMethod void validateFetchRootCauseData() {
        Project_Details__c obj = new Project_Details__c();
        //Project_Details__c fetchRootCauseData(String recordId)
        Account acc = new Account();
        acc.Name='TESTING';
        insert acc;
        obj = ACET_CPM_RootCauseController.fetchRootCauseData(acc.id);
    }
    
    static testMethod void validateSaveRootCauseData() {
        Map<String,String> mapvalues = new Map<String,String>();
        mapvalues.put('Description','TEST');
        Account acc = new Account();
        acc.Name='TESTING';
        insert acc;
        //void saveRootCauseData(Id recordId, Map<String,String> keyValuePairs){
        ACET_CPM_RootCauseController.saveRootCauseData(acc.Id, mapvalues);
    }
}