@isTest
public class ACETSNIescGrpAutocompleteBoxCtrlTest {
  @isTest static void ACETSNIescGrpAutocompleteBoxCtrlTestMethod() {
      Boolean boolVar =  ACETSNIescGrpAutocompleteBoxCtrl.checkUserEditPermission();
      ACETSNIescGrpAutocompleteBoxCtrl.fetchEscGroups( 'test', new List<string>{'test'});
     list<recordtype> lstRecdType = [select id from recordtype where developername = 'ECM'];
      case caseObj = new case();
      if(lstRecdType != null && lstRecdType.size()>0){
          caseObj.recordtypeid = lstRecdType[0].id;
          caseObj.Case_Name__c = 'Test321';
          caseObj.SENS_Topic__c = 'Behavioral';
          caseObj.Priority = 'Standard';
          caseObj.SENS_Topic__c = 'Claims';
         // caseObj.Type__c = 'Issue Resolved';
          insert caseObj;
      }
      if(caseObj.id != null){
        Schema.DescribeFieldResult fieldResult = case.Escalated_Group__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
          ACETSNIescGrpAutocompleteBoxCtrl.saveEscalationGrps( caseObj.id, new list<string>{  ple[0].getLabel()});
        List<String> lstStr =  ACETSNIescGrpAutocompleteBoxCtrl.fetchExistingEscGroups(caseObj.id);
      }
      else{
          
      }
  }
}