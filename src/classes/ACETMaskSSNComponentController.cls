public with sharing class ACETMaskSSNComponentController{

    public string SSNUnMaskValue{get;set;}
    public string maskedSSN{get;set;}
    public string constituentEID{get;set;}
    public string constituentType{get;set;}
    public boolean copySSN{get;set;}
    public boolean showFieldLabel{get;set;}
    public string catagoryValue{get;set;}
   
    public ACETMaskSSNComponentController(){
        showFieldLabel = false;
    }

    // Created by harish on US747972
    public void getInserteventlog(){
      string ssnvalue =  Apexpages.currentPage().getParameters().get('ssn');
      system.debug('SSN Value==='+ssnvalue);
     try{
        PHI_Access_Log__c PHILog = new PHI_Access_Log__c();
        PHILog.Access_Location__c = constituentType;
        PHILog.Type__c = catagoryValue; //'SSN';
        PHILog.EID__c = constituentEID;
        PHILog.SSN__c = ssnvalue; //SSNUnMaskValue;
        //US1056408 Checkmarx code
        if(PHI_Access_Log__c.SObjectType.getDescribe().isCreateable()){
			insert PHILog;
		}
     }
     catch(DMLException e){
      system.debug('Issue wheile inserting PHI'+e);
     }
    }

}