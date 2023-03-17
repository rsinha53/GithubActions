public class ACET_OONReimbursementController {

    @AuraEnabled
    public static OONReimbursementWrapper getBenefitId(string transactionId) {
        OONReimbursementWrapper returnWrapper = new OONReimbursementWrapper();
        ACET_BenefitDetailsHelper.SearchBenefitWrapper searchedResults = ACET_BenefitDetailsHelper.searchBenefit(transactionId, 'out');
        returnWrapper.statusCode = searchedResults.statusCode;
        for(ACET_BenefitDetailsHelper.BenefitResponse benefit : searchedResults.benefitList){
            if(benefit.categoryName.equalsIgnoreCase('Out-of-Network Reimbursement') || benefit.categoryName.equalsIgnoreCase('Out-of-Network Reimbursement Programs')){
                returnWrapper.benefitId = benefit.benefitId;
                break;
            }
        }
        return returnWrapper;
    }

    @AuraEnabled
    public static OONReimbursementWrapper getENIReimbursement(string transactionId, string benefitCode) {
        OONReimbursementWrapper returnWrapper = new OONReimbursementWrapper();
        ACET_BenefitDetailsHelper.BenefitLanguageDetails languageResults = ACET_BenefitDetailsHelper.getBenefitLanguage(transactionId, benefitCode);
        returnWrapper.statusCode = languageResults.statusCode;
        returnWrapper.benefitId = benefitCode;
        if(languageResults.benefit.size() > 0){
            returnWrapper.benefitDetails = languageResults.benefit[0].benefitDetails;
        }
        return returnWrapper;
    }

    public class OONReimbursementWrapper {
        @AuraEnabled public String benefitId;
        @AuraEnabled public String benefitDetails;
        @AuraEnabled public Integer statusCode;

        public OONReimbursementWrapper(){
            this.benefitId=''; this.benefitDetails=''; this.statusCode=200;
        }
    }
}