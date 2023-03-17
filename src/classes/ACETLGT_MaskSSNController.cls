public class ACETLGT_MaskSSNController {
	
    @AuraEnabled
    public static PHI_Access_Log__c insertEventLog(String constituentType, String category, String memId, String SSNValue){
        string coverages;
        PHI_Access_Log__c  PHIlog = new PHI_Access_Log__c ();  
        PHIlog.Access_Location__c  = constituentType;
        PHIlog.Type__c  = category;
        PHIlog.EID__c  = memId;
        PHIlog.SSN__c  = SSNValue;
        insert PHIlog;
        return PHIlog;
    }
}