global without sharing class ADBORSCommitmentsUIWrapper{
    @AuraEnabled
    public List<ADBORSCommitmentsWrapper> commitments;
    
    @AuraEnabled
    public Boolean tweleveMonthDataAvailable;
	@AuraEnabled public String systemErrorMsg;
}