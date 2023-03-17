public class SAEClaimSummaryJSON2Apex{
	public List<cls_claims> claims;
	public class cls_claims {
		public String claimNumber;	//18B249416902
		public String claimStatus;	//Paid/Finalized
		public cls_memberInfo memberInfo;
		public cls_provInfo provInfo;
		public cls_claimSummary claimSummary;
	}
	public class cls_memberInfo {
		public String subscriberId;	//0115262018
		public String policyNbr;	//IAQHP
		public String ptntFn;	//NOLAN
		public String ptntLn;	//JOTHAM
		public String ptntDob;	//08/13/2014
	}
	public class cls_provInfo {
		public cls_submitted submitted;
		public cls_adjudicated adjudicated;
	}
	public class cls_submitted {
		public String tin;	//420982971
		public String billProvNm;	//DUBUQUE ENT HEAD NECK SURGERY PC
        public String billingMpin;
	}
	public class cls_adjudicated {
		public String tin;	//420982971
		public String billProvNm;	//DUBUQUE ENT
        public String billingMpin;
		public String tinPrfx;//US3477116
		public String tinSufx;//US3477116
        public String servicingMpin;
	}
	public class cls_claimSummary {
        public String paperlessInd;
		public String receivedDt;	//02/07/2018
		public String processedDt;	//03/22/2019
		public String processedTm;	//15.49.55
		public String firstSrvcDt;	//01/26/2018
		public String lastSrvcDt;	//01/26/2018
		public String ptntAcctNbr;	//115962
		public String networkStatus;	//I
        public String claimType;	//Hospital venkat added
		public String billTyp;	// Raviteja added May 10 2021 Team Blinkers
        public String drgNbr;
		public String statusEfctDt;	//03/22/2019
		public String totalChargedAmt;	//615.00
		public String provWriteOffAmt;	//360.33
        public String totalPtntRespAmt;
		public String ptntNoCovAmt;	//0.00
		public String provNotCovAmt;	//0.00
		public String totalAllowdAmt;	//254.67
		public String deductibleAmt;	//0.00
		public String totalCopayAmt;	//0.00
		public String totalCoinsAmt;	//0.00
		public String totalPaidAmt;	//254.67
        public String sbmtMembrId;	//ketki -3/28 getting member id in focus
        public String platform;
        public String caeClmNbr; //US3457078
		//public String referralId;
        public String chwyIcn; //US3457078
        public String resubmCaeClmNbr; //US3457078
		public List<cls_chkInfo> chkInfo;
		public List<cls_claimCodes> claimCodes;
        public List<TopsAdditionalInfo> topsAdditionalInfo;
		public List<CosmosAdditionalInfo> cosmosAdditionalInfo;
	}
	public class cls_chkInfo {
		public String chkSrsDesg;	//CSP1
		public String chkEftInd;	//E
		public String chkNbr;	//2018030310900056
        public String paymentIssueDt;// Added by Mani 11/24/2020 US1866504
	}
	public class cls_claimCodes {
        public String type;
		public String code;
		public String description;
	}
    public class TopsAdditionalInfo {
		public String filmOfficeNumber;
		public String filmLocatorNumber;
		public String filmLocatorDate;
        public String contractId;
    }
	public class cosmosAdditionalInfo {
		public String referralId;
    }
	public static SAEClaimSummaryJSON2Apex parse(String json){
		return (SAEClaimSummaryJSON2Apex) System.JSON.deserialize(json, SAEClaimSummaryJSON2Apex.class);
	}
}