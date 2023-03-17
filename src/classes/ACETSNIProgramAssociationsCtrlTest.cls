@isTest
public class ACETSNIProgramAssociationsCtrlTest {
  static testmethod void progAssociationCtrlTestMethod() {
      Boolean boolVar =  ACETSNIProgramAssociationsCtrl.checkUserEditPermission();
      ACETSNIProgramAssociationsCtrl.fetchProgAssociations('test', new List<string>{'test'});
      Member_Information__c memInfo = new Member_Information__c();
      memInfo.name = 'test';
      insert memInfo;
      if(memInfo.id != null){
        Schema.DescribeFieldResult fieldResult = Member_Information__c.Program_Associations__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        ACETSNIProgramAssociationsCtrl.saveProgAssociations(memInfo.id, new list<string>{ple[0].getLabel()});
        List<String> lstStr =  ACETSNIProgramAssociationsCtrl.fetchExistProgAssociations(memInfo.id);
      }
  }
}