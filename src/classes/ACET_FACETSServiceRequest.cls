public class ACET_FACETSServiceRequest {

	public class Tasks {
		public String seqNo {get;set;} {seqNo = '0';}
		public String customerId {get;set;} {customerId = '';}
		public CodeDesc customerType {get;set;} {customerType = new CodeDesc();}
		public CodeDesc subjectType {get;set;} {subjectType = new CodeDesc();}
		public String compliantIndicator {get;set;} {compliantIndicator = '';}
		public CodeDesc inputInd {get;set;} {inputInd = new CodeDesc();}
		public CodeDesc categoryCode {get;set;} {categoryCode = new CodeDesc();}
		public CodeDesc proofOfClosureCode {get;set;} {proofOfClosureCode = new CodeDesc();}
		public CodeDesc priorityCode {get;set;} {priorityCode = new CodeDesc();}
		public CodeDesc statusReasonCode {get;set;} {statusReasonCode = new CodeDesc();}
		public CodeDesc subjectCode {get;set;} {subjectCode = new CodeDesc();}
		public String nextReviewInterval {get;set;} {nextReviewInterval = '';}
		public CodeDesc statusCode {get;set;} {statusCode = new CodeDesc();}
		public String summaryText {get;set;} {summaryText = '';}
		public CodeDesc noteType {get;set;} {noteType = new CodeDesc();}
		public String noteText {get;set;} {noteText = '';}
		public String pageType {get;set;} {pageType = '';}
		public String providerId {get;set;} {providerId = '';}
		public String subscriberId {get;set;} {subscriberId = '';}
		public String familyLinkId {get;set;} { familyLinkId = '';}
        public String primaryUserId {get;set;} { primaryUserId = '';}
	}
	
	public CustomerServiceRecord customerServiceRecord {get;set;} {customerServiceRecord = new CustomerServiceRecord();}

	
	
	public class ContactInfo {
		public String contactType {get;set;} {contactType = '';}
		public String address1 {get;set;} {address1 = '';}
		public String address2 {get;set;} {address2 = '';}
		public String address3 {get;set;} {address3 = '';}
		public String city {get;set;} {city = '';}
		public String state {get;set;} {state = '';}
		public String zip {get;set;} {zip = '';}
		public String county {get;set;} {county = '';}
		public String countryCode {get;set;} {countryCode = '';}
		public String phone {get;set;} {phone = '';}
		public String phoneExt {get;set;} {phoneExt = '';}
		public String fax {get;set;} {fax = '';}
		public String faxExt {get;set;} {faxExt = '';}
		public String emailAddress {get;set;} {emailAddress = '';}

		
	}
	
	public class CallerType {
		public String code {get;set;} {code = '';}
	}
	
	public class CustomerServiceRecord {
		public CallerType callerType {get;set;} {callerType = new CallerType();}
		public CallerType inquiryMethod {get;set;} {inquiryMethod = new CallerType();}
		public CallerType satisfactionLevel {get;set;} {satisfactionLevel = new CallerType();}
		public String disclaimerInd {get;set;} {disclaimerInd = '';}
		public String callerResponse {get;set;} {callerResponse = '';}
		public CallerName callerName {get;set;} {callerName = new CallerName();}
		public String languageCode {get;set;} {languageCode = '';}
		public String relationship {get;set;} {relationship = '';}
		public String idNumber {get;set;} {idNumber = '';}
		public ContactInfo contactInfo {get;set;} {contactInfo = new ContactInfo();}
		public List<Tasks> tasks {get;set;} {tasks = new List<Tasks>();}
	}
	
	public class CallerName {
		public String firstName {get;set;} {firstName = '';}
		public String lastName {get;set;} {lastName = '';}
		public String title {get;set;} {title = '';}
		public String middleInit {get;set;} {middleInit = '';}
	}
	
	public class CodeDesc {
		public String code {get;set;} {code = '';}
		public String description {get;set;} {description = '';}
	}
    
    public ACET_FACETSServiceRequest(CustomerServiceRecord objCustomerServiceRecord) {
        this.customerServiceRecord = objCustomerServiceRecord;
    }

}