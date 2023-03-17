public class ACETIPAMarketAssociationResponseWrapper {
    	public class MktIpaDetails {
		public String capitationPayMethodCd {get;set;} 
		public String capitationModelCd {get;set;} 
		public String memberArea {get;set;} 
		public String memberTable {get;set;} 
		public String provArea {get;set;} 
		public String delMedMgtInd {get;set;} 
		public String provTableNbr {get;set;} 
		public String mktFundTableNbr {get;set;} 
		public String verNumber {get;set;} 
		public String dofrSchedId {get;set;} 
		public String dofrDelgSchedId {get;set;} 
		public String effectiveDate {get;set;} 
		public String cancelDate {get;set;} 
	}
	
	public class MemberNetworkDetails {
		public String memberNetworkTypeCd {get;set;} 
		public String effectiveDate {get;set;} 
		public String cancelDate {get;set;} 
	}
	
	public Metadata metadata {get;set;} 
	public List<SvcResponse> svcResponse {get;set;} 
	public ServiceFault serviceFault {get;set;} 

	
	
	public class Address {
		public String id {get;set;} 
		public String line1 {get;set;} 
		public String cityName {get;set;} 
		public String countyName {get;set;} 
		public String stateCode {get;set;} 
		public String postalPrefixCode {get;set;} 
		public String postalSuffixCode {get;set;} 
	}
	
	public class ServiceFault {
		public Object faultType {get;set;} 
		public Object faultCode {get;set;} 
		public Object message {get;set;} 
	}
	
	public class Phone {
		public String id {get;set;} 
		public String areaCode {get;set;} 
		public String number_Z {get;set;} // in json: number
	}
	
	public class MarketIpa {
		public String mktIPAName {get;set;} 
		public String pcpInd {get;set;} 
		public String portalFlag {get;set;} 
		public String memberNtwkCode {get;set;} 
		public String ipaType {get;set;} 
		public String acoNetworkId {get;set;} 
		public String acoNetworkDesc {get;set;} 
		public String utilizationManagementDelegateIndicator {get;set;} 
		public String financialRiskDelegateIndicator {get;set;} 
		public String claimAdminDelegateIndicator {get;set;} 
		public String providerCredentialDelegateIndicator {get;set;} 
		public String delegateEntityPayerId {get;set;} 
		public String payerId {get;set;} 
		public String effectiveDate {get;set;} 
		public String cancelDate {get;set;} 
		public Phone phone {get;set;} 
		public Address address {get;set;} 
	}
	
	public class Metadata {
		public String versionNumber {get;set;} 
		public String releaseType {get;set;} 
		public String releaseDate {get;set;} 
		public String supportContact {get;set;} 
		public Integer offset {get;set;} 
		public Integer psize {get;set;} 
		public Integer total {get;set;} 
		public String elasticTime {get;set;} 
		public String elapsedTime {get;set;} 
	}
	
	public class SvcResponse {
		public String marketNumber {get;set;} 
		public String marketTypeCode {get;set;} 
		public String ipaNumber {get;set;} 
		public MarketIpa marketIpa {get;set;} 
		public List<MktIpaDetails> mktIpaDetails {get;set;} 
		public List<MemberNetworkDetails> memberNetworkDetails {get;set;} 
	}
    public static ACETIPAMarketAssociationResponseWrapper parse(String json) {
		return (ACETIPAMarketAssociationResponseWrapper) System.JSON.deserialize(json, ACETIPAMarketAssociationResponseWrapper.class);
	}
}