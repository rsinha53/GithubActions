/*
Name : OPTUM_AccountActivityReponse
Created By : Sanjay Pandey)
Created Date : Sep 23rd, 2020
Description : US2881438: Reponse class for Account Activty tab
*/
public class OPTUM_AccountActivityReponse {
    @AuraEnabled
    public String responseCode;
    @AuraEnabled
    public String responseMsg;
    @AuraEnabled
    public cls_meta meta;
    @AuraEnabled
    public cls_result result;
    @AuraEnabled
    public cls_status status;

    class Cls_meta {}
    class Cls_result {
        @AuraEnabled
        public cls_resultMeta resultMeta;
        @AuraEnabled
        public cls_data data;
    }
    class Cls_resultMeta {}
    class Cls_data {
        @AuraEnabled
        public cls_accountDetails[] accountDetails;
    }
    class Cls_accountDetails {
        @AuraEnabled
        public String syntheticId; //MnwwMDA2NzY5MTMzfDAwMDAyMjk0NTJ8T1BUfE1lZGljYWxGbGV4fDkxNzY0NXxudWxs
        @AuraEnabled
        public cls_claimsTransactions[] claimsTransactions;
        @AuraEnabled
        public cls_paymentTransactions[] paymentTransactions;
        @AuraEnabled
        public cls_accountContributions[] accountContributions;
    }
    class Cls_claimsTransactions {
        
	@AuraEnabled
        public String claimNumber; //OPTB22222200918W0000301
        @AuraEnabled
        public String claimStatus; //Status_Pending
        @AuraEnabled
        public Double submittedClaimAmount;
        @AuraEnabled
        public Double deniedClaimAmount;
        @AuraEnabled
        public Double pendingClaimAmount;
        @AuraEnabled
        public Double paidClaimAmount;
        @AuraEnabled
        public String claimDateofServiceEffectiveDate;
        @AuraEnabled
        public Double approvedClaimAmount;
        @AuraEnabled
        public String receiptStatus;
		@AuraEnabled
        public String claimDescription;
        @AuraEnabled
        public String claimIncurredFor;
        @AuraEnabled
        public String claimPostDate;
        @AuraEnabled
        public String repaymentStatus;
        @AuraEnabled
        public Double repaymentAmount;
        @AuraEnabled
        public String repaymentEftFlag;
        @AuraEnabled
        public String reasonForDenial;
        @AuraEnabled
        public String denialStatusDate;
        @AuraEnabled
        public String receiptUploadFlag;
        @AuraEnabled
        public String claimSource;

    }
    class Cls_paymentTransactions {
        @AuraEnabled
        public String paymentDate;
		@AuraEnabled
        public String cmpDate;
        @AuraEnabled
        public String paytype;
        @AuraEnabled
        public Double paymentAmount;
        @AuraEnabled
        public String paymentCheckNum;
        @AuraEnabled
        public String debitOrCreditType;
        @AuraEnabled
        public String provider;
    }
    class Cls_accountContributions {
        @AuraEnabled
        public String contributionDate; //2020-08-21
		@AuraEnabled
        public String cmpcontDate;
        @AuraEnabled
        public String conttype;
        @AuraEnabled
        public String contributionComments; //Scheduled Payroll Deduction
        @AuraEnabled
        public String fundsIn; //117.60
        @AuraEnabled
        public String fundsOut;
        @AuraEnabled
        public String contributionPlanYear; //2020-12-31
    }
   
    class Cls_status {
        @AuraEnabled
        public cls_messages[] messages;
    }
    class Cls_messages {
        @AuraEnabled
        public String code; //0000
        @AuraEnabled
        public String name; //Success
        @AuraEnabled
        public String severity; //INFO
        @AuraEnabled
        public String description; //Request Successfully Processed
    }
    public static OPTUM_AccountActivityReponse parse(String json) {
        return (OPTUM_AccountActivityReponse) System.JSON.deserialize(json, OPTUM_AccountActivityReponse.class);
    }
}