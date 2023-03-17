public class SAEClaimSearchResult {
    
    @AuraEnabled public List<ClaimSearchResult> claimResultLst {get;set;}


    public class ClaimSearchResult implements Comparable {
        @AuraEnabled public String claimNumber {get;set;}
        @AuraEnabled public String taxID {get;set;}
        @AuraEnabled public String providerID {get;set;}
        @AuraEnabled public String providerName {get;set;}
        @AuraEnabled public String DOSStart {get;set;}
        @AuraEnabled public String DOSEnd {get;set;}
        @AuraEnabled public String charged {get;set;}
        @AuraEnabled public String status {get;set;}
        @AuraEnabled public String paperlessInd {get;set;}
        @AuraEnabled public String receivedDate {get;set;}
        @AuraEnabled public String initialDueDate {get;set;}
        @AuraEnabled public String processDate {get;set;}
        @AuraEnabled public String totalDeductibleAmt {get;set;}// Bharath Added:10/5/2020
        @AuraEnabled public String totalCoinsuranceAmt {get;set;}// Bharath Added:10/5/2020
		@AuraEnabled public String claimtype {get;set;}// Tilak Added:10/12/2020
		@AuraEnabled public String billTyp {get;set;} // Raviteja Added:10/05/2021 Team Blinkers
        @AuraEnabled public String drgNbr {get;set;}
        @AuraEnabled public String billMpin {get;set;}
        @AuraEnabled public String billServicepin {get;set;}
        @AuraEnabled public date mydate = date.today();
        @AuraEnabled public String startDateCompare =mydate.month()+'/'+mydate.day()+'/'+mydate.year();
        //@AuraEnabled public String startDateCompare ='10/14/2020';// Tilak Added:10/12/2020
        public Integer compareTo(Object compareTo) {
            ClaimSearchResult compareToclm = (ClaimSearchResult)compareTo;
            /*if(startDateCompare == compareToclm.DOSStart) return 0;
            if (startDateCompare > compareToclm.DOSStart) return 1;
         	return -1;*/
            if(startDateCompare == compareToclm.DOSStart) {
                return 0;
            }
            else if (startDateCompare > compareToclm.DOSStart) {
                return 1;
            }
            else if (startDateCompare < compareToclm.DOSStart) {
                return -1;
            }
            else {
         	return -1;
        }
        }


        //Added by Ketki for claim status on claim detail page

        //@AuraEnabled public String processedDt {get;set;}
        //@AuraEnabled public String claimStatus {get;set;}
        @AuraEnabled public String networkStatus {get;set;}
        @AuraEnabled public String totalChargedAmt {get;set;}
        //total denied amount on claim status
        @AuraEnabled public String totalDeniedAmount {get;set;}
        @AuraEnabled public String totalAllowdAmt {get;set;}
        @AuraEnabled public String deductibleAmt {get;set;}
        @AuraEnabled public String totalCopayAmt {get;set;}
        @AuraEnabled public String totalCoinsAmt {get;set;}
        @AuraEnabled public String totalPaidAmt {get;set;}
        @AuraEnabled public String provNotCovAmt {get;set;}
        @AuraEnabled public String provWriteOffAmt {get;set;}
        @AuraEnabled public String totalPtntRespAmt {get;set;}
        @AuraEnabled public String claimBenefitlevel{get;set;}
        @AuraEnabled public String chkInfo{get;set;} // Added by Mani 11/24/2020 US1866504
        @AuraEnabled public String ptntLn{get;set;}
        @AuraEnabled public String ptntFn{get;set;}
        @AuraEnabled public String platform {get;set;}
        @AuraEnabled public String referralId {get;set;}
        @AuraEnabled public String ptntDob {get;set;}
        @AuraEnabled public String sbmtMembrId {get;set;} 	//ketki -3/28 getting member id in focus
        @AuraEnabled public String policyNbr {get;set;} //ketki -3/28 getting policy number from claim response
        @AuraEnabled public String adjTaxID {get;set;}
         @AuraEnabled public String adjservicingMpin {get;set;}
        @AuraEnabled public String adjProviderID {get;set;}
        @AuraEnabled public String adjProviderName {get;set;}
        @AuraEnabled public String TopsAdditionalInfo {get;set;}
        @AuraEnabled public String contractId {get;set;}
        @AuraEnabled public String caeClmNbr {get;set;} //US3457078
        @AuraEnabled public String resubmCaeClmNbr {get;set;} //US3457078
        @AuraEnabled public String chwyIcn {get;set;} //US3457078
		@AuraEnabled public String ptntAcctNbr {get;set;} //US3477116
        @AuraEnabled public String tin {get;set;} //US3477116
        @AuraEnabled public String tinPrfx {get;set;} //US3477116
        @AuraEnabled public String tinSufx {get;set;} //US3477116
        @AuraEnabled public List<cls_claimCodes> claimCodes;

    }

    public class cls_claimCodes {
        @AuraEnabled public String type;
		@AuraEnabled public String code;
		@AuraEnabled public String description;
	}

}