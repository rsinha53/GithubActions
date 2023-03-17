@isTest
public class SNIFamStatusControllerTest {

 @isTest static void SNIFamStatusControllerMethod() {
     account accFam = new account();
     string recTypeId = [select id from recordtype where name= 'Family'].id;
     accFam.recordtypeid = recTypeId;
     accFam.Name = 'FamilymemberTest11';
     insert accFam;
     boolean b = SNIFamStatusController.getAtccountDtl(accFam.id);
     boolean b1 = SNIFamStatusController.getAccountProgramAssociation(accFam.id);
     accFam.Family_Story__c = 'sample Family story';
     accFam.Program_Associations_RichText__c = 'sample Program Associations';
     update accFam;
     boolean b2 = SNIFamStatusController.getAtccountDtl(accFam.id);
     boolean b3 = SNIFamStatusController.getAccountProgramAssociation(accFam.id);
   //  select Onshore_Restriction__c,UHG_Restriction__c from Family_Overview__c where Account__c =: accId
     Family_Overview__c famOverV = new Family_Overview__c();
     famOverV.Onshore_Restriction__c = 'Yes';
     famOverV.UHG_Restriction__c = 'Yes';
     famOverV.Account__c = accFam.id;
     insert famOverV;
     boolean b4 = SNIFamStatusController.getRestrictionData(accFam.id); 
	 string tt = SNIFamStatusController.getAccountFamilyOverview(accFam.id);  //added by ravi

 }       
}