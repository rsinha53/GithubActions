public class ACET_ProperUseDTO{
    
	@AuraEnabled public properUse ProperUse {get;set;}
    
	public class properUse {
		@AuraEnabled public definedObligations[] DefinedObligations{get;set;}
		@AuraEnabled public controlGroup ControlGroup{get;set;}
	}
	public class definedObligations {
		@AuraEnabled public String ObligationSource{get;set;}	//DGTS
		@AuraEnabled public obligationRecords[] ObligationRecords{get;set;}
	}
	public class obligationRecords {
		@AuraEnabled public String ObligationID{get;set;}	//DGTS0103FIZA
		@AuraEnabled public cls_DataUseObligations DataUseObligations{get;set;}
		@AuraEnabled public cls_AdditionalInformation AdditionalInformation{get;set;}
		@AuraEnabled public cls_RecordIdentifiers RecordIdentifiers{get;set;}
	}
	public class cls_DataUseObligations {
		@AuraEnabled public String Level0{get;set;}	//PM
		@AuraEnabled public String Level1{get;set;}	//PM
		@AuraEnabled public String Level2{get;set;}	//PM
		@AuraEnabled public String Level3{get;set;}	//PM
		@AuraEnabled public String Level4{get;set;}	//PM
        @AuraEnabled public String Level5{get;set;}	//PM
        @AuraEnabled public String Level6{get;set;}	//PM
        @AuraEnabled public String Level7{get;set;}	//PM
	}
	public class cls_AdditionalInformation {
		@AuraEnabled public String CustomerName{get;set;}	//City of Rawlins
	}
	public class cls_RecordIdentifiers {
		@AuraEnabled public String cMDM_EID{get;set;}	//entities/WFBG9wT
        @AuraEnabled public List<String> PolicyNumbers{get;set;}
		@AuraEnabled public List<String> GroupNumbers{get;set;}
		@AuraEnabled public List<String> DivisionNumbers{get;set;}
	}
	public class controlGroup {
		@AuraEnabled public String GroupName{get;set;}	//ACET_DRTS_PRD
		@AuraEnabled public String ControlLevel{get;set;}	//Volume
		@AuraEnabled public cls_Volume Volume{get;set;}
		@AuraEnabled public cls_AttachedDatasets[] AttachedDatasets{get;set;}
		@AuraEnabled public cls_Business Business{get;set;}
		//public cls_AllowedDURs AllowedDURs;
		@AuraEnabled public cls_AllowedUses[] AllowedUses{get;set;}
		@AuraEnabled public cls_AllowedJustifications[] AllowedJustifications{get;set;}
		//public cls_ObligationIDs[] ObligationIDs;
	}
	public class cls_Volume {
		@AuraEnabled public String ID{get;set;}	//DRTSVOL00000006
		@AuraEnabled public String Name{get;set;}	//ACT
		@AuraEnabled public String Description{get;set;}	//ACET - Adaptive Constituent Experience Technology
		@AuraEnabled public String PublishedOn{get;set;}	//2020/05/21
	}
	public class cls_AttachedDatasets {
		@AuraEnabled public String ID{get;set;}	//DRTSDST00000040
		@AuraEnabled public String Name{get;set;}	//ACET
		@AuraEnabled public String Description{get;set;}	//Adaptive Constituent Experience Technology
		@AuraEnabled public String DataClassification{get;set;}	//Protected
		@AuraEnabled public String PublishedOn{get;set;}	//2020/05/21
	}
	public class cls_Business {
		@AuraEnabled public cls_Markets[] Markets{get;set;}

	}
	public class cls_Markets {
		@AuraEnabled public Integer MarketID{get;set;}	//2
		@AuraEnabled public String MarketName{get;set;}	//UnitedHealthcare (UHC)
		@AuraEnabled public String MappedGLCode{get;set;}	//300
		@AuraEnabled public cls_BusinessSegments[] BusinessSegments{get;set;}
	}
	public class cls_BusinessSegments {
		@AuraEnabled public Integer BusinessSegmentID{get;set;}	//5
		@AuraEnabled public String BusinessSegmentName{get;set;}	//Community and State (C&S)
		@AuraEnabled public String MappedGLCode{get;set;}	//650
		//public cls_LineOfBusinesses LineOfBusinesses;
	}
	/*public class cls_LineOfBusinesses {
	}

	public class cls_AllowedDURs {
	}
	*/
	public class cls_AllowedUses {
		@AuraEnabled public Integer DataUseID{get;set;}	//3
		@AuraEnabled public String DataUseName{get;set;} //Data Exploration
	}
	public class cls_AllowedJustifications {
		@AuraEnabled public Integer JustificationID{get;set;}	//3
		@AuraEnabled public String JustificationName{get;set;}	//Operations
	}
    /*
	public class cls_ObligationIDs {
		public String a;	//D
		public String b;	//G
		public String c;	//T
		public String d;	//S
		public String e;	//0
		public String f;	//1
		public String g;	//0
		public String h;	//3
		public String i;	//F
		public String j;	//I
		public String k;	//Z
		public String l;	//A
	}
	*/
}