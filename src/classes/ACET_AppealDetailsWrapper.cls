public class ACET_AppealDetailsWrapper {
	
	public class Claims {
		public String claimNumber {get;set;} 
		public String chargedAmt {get;set;} 
		public String paidAmt {get;set;} 
		public String ptntRespAmt {get;set;} 
		public String createdDt {get;set;} 
		public String modifyDt {get;set;} 
	}
	
	public class Comments {
		public String type {get;set;} 
		public String description {get;set;} 
		public String date_Z {get;set;} // in json: date
	}
	
	public String appealId {get;set;} 
	public String appealPlatform {get;set;} 
	public ProviderInformation providerInformation {get;set;} 
	public PatientInfo patientInfo {get;set;} 
	public String dateSubmitted {get;set;} 
	public String dateClosed {get;set;} 
	public String outcome {get;set;} 
	public String ceuReceivedDt {get;set;} 
	public String dueDt {get;set;} 
	public String receivedFrom {get;set;} 
	public String receivedFromDesc {get;set;} 
	public String status {get;set;} 
	public String issueTypeId {get;set;} 
	public String appealType {get;set;} 
	public String appealTypeDesc {get;set;} 
	public String acknowledgementLetterReq {get;set;} 
	public String memberReleaseReceived {get;set;} 
	public String financialLiability {get;set;} 
	public String financialLiabilityDesc {get;set;} 
	public String portalAttachment {get;set;} 
	public String funding {get;set;} 
	public String fundingDesc {get;set;} 
	public String stateSpecificFormRev {get;set;} 
	public String grantedDays {get;set;} 
	public String followUp {get;set;} 
	public String preOrPostService {get;set;} 
	public String preOrPostServiceDesc {get;set;} 
	public ImpactedItems impactedItems {get;set;} 
	public List<Comments> comments {get;set;} 
	public List<Attachments> attachments {get;set;} 
	public List<Claims> claims {get;set;} 
	
	public class PatientInfo {
		public String patientFn {get;set;} 
		public String patientLn {get;set;} 
		public String relationshipCd {get;set;} 
	}
	
	public class Mpin {
		public String mpinValue {get;set;} 
		public String mpinType {get;set;} 
	}
	
	public class ProviderInformation {
		public String taxId {get;set;} 
		public List<Mpin> mpin {get;set;} 
	}
	
	public class ImpactedItems {
		public String initialClaimDenial {get;set;} 
		public String initialSRNDenial {get;set;} 
		public String overturnedAmt {get;set;} 
	}
	
	public class Attachments {
		public Integer attachmentId {get;set;} 
		public String attachmentDescription {get;set;} 
		public Integer caseAttachmentId {get;set;} 
		public String active {get;set;} 
		public String createdDt {get;set;} 
		public String createdBy {get;set;} 
		public String mailedDt {get;set;} 
		public String recipientType {get;set;} 
	}
}