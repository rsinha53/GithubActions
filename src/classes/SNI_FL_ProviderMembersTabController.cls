public without sharing class SNI_FL_ProviderMembersTabController {
	public class MembersReturnWrapper {
        @AuraEnabled
        public List<MemberDetailWrapper> memberDetails{get;set;}
        @AuraEnabled
        public Boolean ErrorOccured {get;set;}
        @AuraEnabled
        public String ErrorMessage {get;set;}
        @AuraEnabled
        public String DebugMessage {get;set;}
        @AuraEnabled
        public String progPopulation {get;set;}
    }
    
    public class MemberDetailWrapper implements Comparable {
        @AuraEnabled
        public String memberName {get;set;}
        @AuraEnabled
        public Id memberId{get;set;}
        @AuraEnabled
        public String subscriberId {get; set;}
        @AuraEnabled
        public String memberStatus {get; set;}
        @AuraEnabled
        public String enrollmentDate {get; set;}
        @AuraEnabled
        public String inactiveDate {get; set;}
        @AuraEnabled
        public Boolean isActive {get; set;}
        @AuraEnabled
        public String isActiveCSS {get; set;}
        @AuraEnabled
        public Date dateOfBirth {get; set;}
         @AuraEnabled
        public String programName {get; set;}
        @AuraEnabled
        public String providerGroup {get; set;}
       // @AuraEnabled
       // public list<ContentVersion> memDocumentList {get;set;}
       
        public Integer compareTo(Object compareTo) {
            MemberDetailWrapper mdw = (MemberDetailWrapper) compareTo;
            if (memberName == mdw.MemberName) return 0;
            if (memberName > mdw.MemberName) return 1;
            return -1;
        } 
    }
    
   public class MemberDocumentsWrapper {
        @AuraEnabled
        public String docId {get;set;}
        @AuraEnabled
        public String tittle {get;set;}
         @AuraEnabled
        public String fileType {get;set;}
         @AuraEnabled
        public Datetime lastModifiedDate {get;set;}
     }
  
    
    //TODO: add error handling functionality in JS
    //see SNI_FL_RxMedsHelper.js fetchRxMeds
	@AuraEnabled
    Public Static MembersReturnWrapper getMemberDetails(string providerProgram){
        List<MemberDetailWrapper> memberDetailsList = new List<MemberDetailWrapper>();
        Boolean ErrorOccured = false;
        String ErrorMessage = null;
        String DebugMessage = null;
        
        MembersReturnWrapper memberWrapperReturn = new MembersReturnWrapper();
        
        if (providerProgram != NULL) {
            try {
                
                List<Member_Affiliation__c> memAffList = new List<Member_Affiliation__c>();
                
                Account providerAff = [select Id, Population__c, Program__r.Program__c from account where Id = :providerProgram];
                memberWrapperReturn.progPopulation = providerAff.Program__r.Program__c + ' - ' + providerAff.Population__c;
                memAffList = [SELECT ID, Name, Member__c, Member__r.Name, Member_ID__c,
                              Program__c, Program__r.Program__c, Provider_Group__c, Provider_Group__r.Name, Provider__c, Provider_Affiliation__c,Provider_Affiliation__r.Name,
                              Subscriber_Id__c, Enrollment_Date__c, Inactive_Date__c, Status__c,Date_Of_Birth__c  , Population__c
                              FROM Member_Affiliation__c where (provider_affiliation__c = : providerProgram)];
                
                
                
                
                //populate the member data
                for (Member_Affiliation__c memAff : memAffList) {
                    MemberDetailWrapper mdw = new MemberDetailWrapper();
                    mdw.memberName = memAff.Member__r.Name;
                    mdw.memberId = memAff.ID;
                    mdw.subscriberId = memAff.Member_ID__c;
                    mdw.memberStatus = memAff.Status__c ? 'Active' : 'Inactive';
                    string EntrollmentDate= memAff.Enrollment_Date__c.month()+ '/' +  memAff.Enrollment_Date__c.day() + '/' +  memAff.Enrollment_Date__c.year();
                    mdw.enrollmentDate = EntrollmentDate;
                    mdw.dateOfBirth = memAff.Date_Of_Birth__c;
                    string inactiveDateFormat = '';
                    if(memAff.Inactive_Date__c != null){
                        inactiveDateFormat = memAff.Inactive_Date__c.month()+ '/' +  memAff.Inactive_Date__c.day() + '/' +  memAff.Inactive_Date__c.year();
                    }
                    mdw.inactiveDate = inactiveDateFormat;
                    mdw.isActive = memAff.Status__c;
                    mdw.isActiveCSS = memAff.Status__c ? 'divboxActive' : 'divboxInactive';
                    mdw.programName = memAff.Program__r.Program__c;
                    mdw.providerGroup = memAff.Provider_Group__r.Name;
                    memberDetailsList.add(mdw);
                }
                
                memberDetailsList.sort();
                
                
            }
            catch(Exception e){
                AcetUtility.CreateAndRedirectToError('FamilyLink','SNI_FL_ProviderMembersTabController',e);
                ErrorOccured = true;
                ErrorMessage = e.getMessage();
            }
        }
        
        memberWrapperReturn.memberDetails = memberDetailsList;
        
        memberWrapperReturn.ErrorOccured = ErrorOccured;
        memberWrapperReturn.ErrorMessage = ErrorMessage;
        memberWrapperReturn.DebugMessage = DebugMessage;
        
        return memberWrapperReturn;
    }
    
}