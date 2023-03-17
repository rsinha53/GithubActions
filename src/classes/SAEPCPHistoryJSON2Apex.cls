public class SAEPCPHistoryJSON2Apex{
	public coverageHistoryResponseList[] coverageHistoryResponseList;
	public providerHistoryResponseList[] providerHistoryResponseList;
	public class coverageHistoryResponseList {
		public String coverageStartDate;	//01-01-2020
		public String coverageEndDate;	//-
		public String employerGrpNumber;	//HCFA55
		public String employerGrpName;	//AARP MCA PLAN 2 SH20
		public String plan;	//X9B
	}
	public class providerHistoryResponseList {
		public String coverageStartDate;	//01-01-2013
		public String coverageEndDate;	//Present
		public String providerGrpNumber;	//20588
		public String providerGrpName;	//NORTH DIRECT
		public String pcpNumber;	//0096
		public String pcpName;	//BIRNBAUM, BERNARD J
	}
	public static SAEPCPHistoryJSON2Apex parse(String json){
		return (SAEPCPHistoryJSON2Apex) System.JSON.deserialize(json, SAEPCPHistoryJSON2Apex.class);
	}	
}