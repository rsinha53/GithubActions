public without sharing class ADBCommitmentsUIWrapper {
    
    @AuraEnabled
    public List<Commitments> commitments;
    @AuraEnabled
    public Boolean tweleveMonthDataAvailable;
	@AuraEnabled public String systemErrorMsg;										  
    
    public class Commitments{
        @AuraEnabled
        public String type;
        @AuraEnabled
        public String create_Date;
        @AuraEnabled
        public String commitment;
        @AuraEnabled
        public String due_Date;
    }
}