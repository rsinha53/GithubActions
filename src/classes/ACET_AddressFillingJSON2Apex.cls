public class ACET_AddressFillingJSON2Apex {

	public class ClaimMailingAddress {
		public String city;
		public String state;
		public String street1;
		public String street2;
		public String zip;
		public String zip4;
	}

	public ClaimMailingAddress claimMailingAddress;
	public String platform;
	public String originalEffectiveDate;
	public String retirementDate;

	
	public static ACET_AddressFillingJSON2Apex parse(String json) {
		return (ACET_AddressFillingJSON2Apex) System.JSON.deserialize(json, ACET_AddressFillingJSON2Apex.class);
	}
}