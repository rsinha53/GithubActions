//US2887998
public class ACET_ORSReadIssueWrapper{
		public class ResponseHeader {
		public String serviceCallStatus {get;set;}
		public String externalId {get;set;}
		public String serviceName {get;set;}
		public String serviceVersion {get;set;}
		public String logLevel {get;set;}
		public String installation {get;set;}
		public String hostedAppEnvironment {get;set;}
		public InternalUse internalUse {get;set;}

		public ResponseHeader(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'serviceCallStatus') {
							serviceCallStatus = parser.getText();
						} else if (text == 'externalId') {
							externalId = parser.getText();
						} else if (text == 'serviceName') {
							serviceName = parser.getText();
						} else if (text == 'serviceVersion') {
							serviceVersion = parser.getText();
						} else if (text == 'logLevel') {
							logLevel = parser.getText();
						} else if (text == 'installation') {
							installation = parser.getText();
						} else if (text == 'hostedAppEnvironment') {
							hostedAppEnvironment = parser.getText();
						} else if (text == 'internalUse') {
							internalUse = new InternalUse(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'ResponseHeader consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}

	public class Issue {
		public String issueId {get;set;}
		public String updateDate {get;set;}
		public String updateTime {get;set;}
		public String priority {get;set;}
		public String repeatIndicator {get;set;}
		public String contactMethodCode {get;set;}
		public String originatorTypeCode {get;set;}
		public String directionCode {get;set;}
		public String status {get;set;}
		public String surveyCode {get;set;}
		public String callHistoryFlag {get;set;}
		public String callbackPromisedDate {get;set;}
		public String followupDate {get;set;}
		public String businessSegmentName {get;set;}
		public String routeConditionCode {get;set;}
		public String hipaaIndicator {get;set;}
		public String reasonCode {get;set;}
		public String reasonType {get;set;}
		public String reasonCategory {get;set;}
		public String reasonHcnasType {get;set;}
		public String subReasonText {get;set;}
		public String complaintCategoryText {get;set;}
		public String launchCategoryText {get;set;}
		public String launchReasonText {get;set;}
		public String grievanceCategoryText {get;set;}
		public String grievanceReasonText {get;set;}
		public String grievanceReasonCode {get;set;}
		public String grievanceReceiptDate {get;set;}
		public String grievanceDispositionText {get;set;}
		public String dispositionNotificationDate {get;set;}
		public String campaignCode {get;set;}
		public String campaignReportText {get;set;}
		public String pssActionTaken {get;set;}
		public String callAttemptDetailText {get;set;}
		public String callProgramName {get;set;}
		public String pharmacyClassText {get;set;}
		public String pharmacyClaimNumber {get;set;}
		public String pharmacyName {get;set;}
		public String pharmacyId {get;set;}
		public String assignedPssId {get;set;}
		public String callMeetsExpectationIndicator {get;set;}
		public String callExceedsExpectationIndicator {get;set;}
		public String disposition {get;set;}
		public String checkNumber {get;set;}
		public String seriesDesignator {get;set;}
		public String caseNumber {get;set;}
		public String payer {get;set;}
		public Member member {get;set;}
		public Claim claim {get;set;}
		public Originator originator {get;set;}
		public Provider provider {get;set;}
		public Other other {get;set;}
		public EmployerInfo employerInfo {get;set;}
		public ServiceRequest serviceRequest {get;set;}
		public String priorityDescription {get;set;}
		public String contactMethodDescription {get;set;}
		public String originatorTypeDescription {get;set;}
		public String statusDescription {get;set;}
		public String callRequired {get;set;}
		public String contactReasonDescription {get;set;}
		public List<DetailComments> detailComments {get;set;}
		public String followupStatusCode {get;set;}
		public String followupStatusDescription {get;set;}
		public String followupPurposeCode {get;set;}
		public String originatedDate {get;set;}
		public List<Owners> owners {get;set;}
		public String message {get;set;}
		public String messageMail {get;set;}
		public String designeeId {get;set;}
		public String reopenFlag {get;set;}
		public String networkCloseReason {get;set;}
		public String reasonDescription {get;set;}
		public String linkExists {get;set;}

		public Issue(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'issueId') {
							issueId = parser.getText();
						} else if (text == 'updateDate') {
							updateDate = parser.getText();
						} else if (text == 'updateTime') {
							updateTime = parser.getText();
						} else if (text == 'priority') {
							priority = parser.getText();
						} else if (text == 'repeatIndicator') {
							repeatIndicator = parser.getText();
						} else if (text == 'contactMethodCode') {
							contactMethodCode = parser.getText();
						} else if (text == 'originatorTypeCode') {
							originatorTypeCode = parser.getText();
						} else if (text == 'directionCode') {
							directionCode = parser.getText();
						} else if (text == 'status') {
							status = parser.getText();
						} else if (text == 'surveyCode') {
							surveyCode = parser.getText();
						} else if (text == 'callHistoryFlag') {
							callHistoryFlag = parser.getText();
						} else if (text == 'callbackPromisedDate') {
							callbackPromisedDate = parser.getText();
						} else if (text == 'followupDate') {
							followupDate = parser.getText();
						} else if (text == 'businessSegmentName') {
							businessSegmentName = parser.getText();
						} else if (text == 'routeConditionCode') {
							routeConditionCode = parser.getText();
						} else if (text == 'hipaaIndicator') {
							hipaaIndicator = parser.getText();
						} else if (text == 'reasonCode') {
							reasonCode = parser.getText();
						} else if (text == 'reasonType') {
							reasonType = parser.getText();
						} else if (text == 'reasonCategory') {
							reasonCategory = parser.getText();
						} else if (text == 'reasonHcnasType') {
							reasonHcnasType = parser.getText();
						} else if (text == 'subReasonText') {
							subReasonText = parser.getText();
						} else if (text == 'complaintCategoryText') {
							complaintCategoryText = parser.getText();
						} else if (text == 'launchCategoryText') {
							launchCategoryText = parser.getText();
						} else if (text == 'launchReasonText') {
							launchReasonText = parser.getText();
						} else if (text == 'grievanceCategoryText') {
							grievanceCategoryText = parser.getText();
						} else if (text == 'grievanceReasonText') {
							grievanceReasonText = parser.getText();
						} else if (text == 'grievanceReasonCode') {
							grievanceReasonCode = parser.getText();
						} else if (text == 'grievanceReceiptDate') {
							grievanceReceiptDate = parser.getText();
						} else if (text == 'grievanceDispositionText') {
							grievanceDispositionText = parser.getText();
						} else if (text == 'dispositionNotificationDate') {
							dispositionNotificationDate = parser.getText();
						} else if (text == 'campaignCode') {
							campaignCode = parser.getText();
						} else if (text == 'campaignReportText') {
							campaignReportText = parser.getText();
						} else if (text == 'pssActionTaken') {
							pssActionTaken = parser.getText();
						} else if (text == 'callAttemptDetailText') {
							callAttemptDetailText = parser.getText();
						} else if (text == 'callProgramName') {
							callProgramName = parser.getText();
						} else if (text == 'pharmacyClassText') {
							pharmacyClassText = parser.getText();
						} else if (text == 'pharmacyClaimNumber') {
							pharmacyClaimNumber = parser.getText();
						} else if (text == 'pharmacyName') {
							pharmacyName = parser.getText();
						} else if (text == 'pharmacyId') {
							pharmacyId = parser.getText();
						} else if (text == 'assignedPssId') {
							assignedPssId = parser.getText();
						} else if (text == 'callMeetsExpectationIndicator') {
							callMeetsExpectationIndicator = parser.getText();
						} else if (text == 'callExceedsExpectationIndicator') {
							callExceedsExpectationIndicator = parser.getText();
						} else if (text == 'disposition') {
							disposition = parser.getText();
						} else if (text == 'checkNumber') {
							checkNumber = parser.getText();
						} else if (text == 'seriesDesignator') {
							seriesDesignator = parser.getText();
						} else if (text == 'caseNumber') {
							caseNumber = parser.getText();
						} else if (text == 'payer') {
							payer = parser.getText();
						} else if (text == 'member') {
							member = new Member(parser);
						} else if (text == 'claim') {
							claim = new Claim(parser);
						} else if (text == 'originator') {
							originator = new Originator(parser);
						} else if (text == 'provider') {
							provider = new Provider(parser);
						} else if (text == 'other') {
							other = new Other(parser);
						} else if (text == 'employerInfo') {
							employerInfo = new EmployerInfo(parser);
						} else if (text == 'serviceRequest') {
							serviceRequest = new ServiceRequest(parser);
						} else if (text == 'priorityDescription') {
							priorityDescription = parser.getText();
						} else if (text == 'contactMethodDescription') {
							contactMethodDescription = parser.getText();
						} else if (text == 'originatorTypeDescription') {
							originatorTypeDescription = parser.getText();
						} else if (text == 'statusDescription') {
							statusDescription = parser.getText();
						} else if (text == 'callRequired') {
							callRequired = parser.getText();
						} else if (text == 'contactReasonDescription') {
							contactReasonDescription = parser.getText();
						} else if (text == 'detailComments') {
							detailComments = arrayOfDetailComments(parser);
						} else if (text == 'followupStatusCode') {
							followupStatusCode = parser.getText();
						} else if (text == 'followupStatusDescription') {
							followupStatusDescription = parser.getText();
						} else if (text == 'followupPurposeCode') {
							followupPurposeCode = parser.getText();
						} else if (text == 'originatedDate') {
							originatedDate = parser.getText();
						} else if (text == 'owners') {
							owners = arrayOfOwners(parser);
						} else if (text == 'message') {
							message = parser.getText();
						} else if (text == 'messageMail') {
							messageMail = parser.getText();
						} else if (text == 'designeeId') {
							designeeId = parser.getText();
						} else if (text == 'reopenFlag') {
							reopenFlag = parser.getText();
						} else if (text == 'networkCloseReason') {
							networkCloseReason = parser.getText();
						} else if (text == 'reasonDescription') {
							reasonDescription = parser.getText();
						} else if (text == 'linkExists') {
							linkExists = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Issue consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}

	public class InternalUse {
		public String uid {get;set;}
		public String serviceName {get;set;}
		public String serviceVersion {get;set;}
		public String originalConsumer {get;set;}
		public String originalServiceName {get;set;}
		public String originalServiceVersion {get;set;}
		public Integer logSequence {get;set;}
		public String uidGeneratedBy {get;set;}

		public InternalUse(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'uid') {
							uid = parser.getText();
						} else if (text == 'serviceName') {
							serviceName = parser.getText();
						} else if (text == 'serviceVersion') {
							serviceVersion = parser.getText();
						} else if (text == 'originalConsumer') {
							originalConsumer = parser.getText();
						} else if (text == 'originalServiceName') {
							originalServiceName = parser.getText();
						} else if (text == 'originalServiceVersion') {
							originalServiceVersion = parser.getText();
						} else if (text == 'logSequence') {
							logSequence = parser.getIntegerValue();
						} else if (text == 'uidGeneratedBy') {
							uidGeneratedBy = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'InternalUse consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}

	public class DayPhone {
		public String areaCode {get;set;}
		public String number_Z {get;set;} // in json: number
		public String extension {get;set;}

		public DayPhone(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'areaCode') {
							areaCode = parser.getText();
						} else if (text == 'number') {
							number_Z = parser.getText();
						} else if (text == 'extension') {
							extension = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'DayPhone consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}

	public class CallerAddress {
		public String street1 {get;set;}
		public String city {get;set;}
		public String state {get;set;}
		public String zip {get;set;}
		public String zip4 {get;set;}

		public CallerAddress(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'street1') {
							street1 = parser.getText();
						} else if (text == 'city') {
							city = parser.getText();
						} else if (text == 'state') {
							state = parser.getText();
						} else if (text == 'zip') {
							zip = parser.getText();
						} else if (text == 'zip4') {
							zip4 = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'CallerAddress consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}

	public class ServiceRequest {
		public String srProductType {get;set;}
		public String srType {get;set;}
		public String srSubType {get;set;}
		public String resolutionCode {get;set;}
		public String clientId {get;set;}
		public String subCodeId {get;set;}
		public String productId {get;set;}
		public String diamondProviderLocationId {get;set;}
		public String diamondProviderLocationName {get;set;}
		public String originatorLocationId {get;set;}
		public String claimAdjustmentRequiredIndicator {get;set;}
		public String addressUpdateRequiredIndicator {get;set;}
		public String wbxUpdateRequiredIndicator {get;set;}
		public String bulkCheckIndicator {get;set;}
		public String memberPhoneNumber {get;set;}
		public String memberAreaCode {get;set;}
		public String memberCity {get;set;}
		public String memberStreet1 {get;set;}
		public String memberStreet2 {get;set;}
		public String parentGroupName {get;set;}
		public String pcpFirstName {get;set;}
		public String pcpLastName {get;set;}
		public String pcpProviderID {get;set;}
		public String hippaEligibleFlag {get;set;}
		public String providerFirstName {get;set;}
		public String providerLastName {get;set;}
		public String providerPhoneNumber {get;set;}
		public String providerAreaCode {get;set;}
		public String providerCounty {get;set;}
		public String checkPayee {get;set;}
		public String checkStockNumber {get;set;}
		public String commonProviderId {get;set;}
		public String originalProviderId {get;set;}
		public String providerStreet1 {get;set;}
		public String providerStreet2 {get;set;}
		public String providerCity {get;set;}
		public String policyNumber {get;set;}
		public String dayExtensionNew {get;set;}
		public String documentControlNumber {get;set;}
		public String closeOfficeNumber {get;set;}
		public String closeDepartmentCode {get;set;}
		public String closeTeamCode {get;set;}
		public String lastUpdateOpid {get;set;}

		public ServiceRequest(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'srProductType') {
							srProductType = parser.getText();
						} else if (text == 'srType') {
							srType = parser.getText();
						} else if (text == 'srSubType') {
							srSubType = parser.getText();
						} else if (text == 'resolutionCode') {
							resolutionCode = parser.getText();
						} else if (text == 'clientId') {
							clientId = parser.getText();
						} else if (text == 'subCodeId') {
							subCodeId = parser.getText();
						} else if (text == 'productId') {
							productId = parser.getText();
						} else if (text == 'diamondProviderLocationId') {
							diamondProviderLocationId = parser.getText();
						} else if (text == 'diamondProviderLocationName') {
							diamondProviderLocationName = parser.getText();
						} else if (text == 'originatorLocationId') {
							originatorLocationId = parser.getText();
						} else if (text == 'claimAdjustmentRequiredIndicator') {
							claimAdjustmentRequiredIndicator = parser.getText();
						} else if (text == 'addressUpdateRequiredIndicator') {
							addressUpdateRequiredIndicator = parser.getText();
						} else if (text == 'wbxUpdateRequiredIndicator') {
							wbxUpdateRequiredIndicator = parser.getText();
						} else if (text == 'bulkCheckIndicator') {
							bulkCheckIndicator = parser.getText();
						} else if (text == 'memberPhoneNumber') {
							memberPhoneNumber = parser.getText();
						} else if (text == 'memberAreaCode') {
							memberAreaCode = parser.getText();
						} else if (text == 'memberCity') {
							memberCity = parser.getText();
						} else if (text == 'memberStreet1') {
							memberStreet1 = parser.getText();
						} else if (text == 'memberStreet2') {
							memberStreet2 = parser.getText();
						} else if (text == 'parentGroupName') {
							parentGroupName = parser.getText();
						} else if (text == 'pcpFirstName') {
							pcpFirstName = parser.getText();
						} else if (text == 'pcpLastName') {
							pcpLastName = parser.getText();
						} else if (text == 'pcpProviderID') {
							pcpProviderID = parser.getText();
						} else if (text == 'hippaEligibleFlag') {
							hippaEligibleFlag = parser.getText();
						} else if (text == 'providerFirstName') {
							providerFirstName = parser.getText();
						} else if (text == 'providerLastName') {
							providerLastName = parser.getText();
						} else if (text == 'providerPhoneNumber') {
							providerPhoneNumber = parser.getText();
						} else if (text == 'providerAreaCode') {
							providerAreaCode = parser.getText();
						} else if (text == 'providerCounty') {
							providerCounty = parser.getText();
						} else if (text == 'checkPayee') {
							checkPayee = parser.getText();
						} else if (text == 'checkStockNumber') {
							checkStockNumber = parser.getText();
						} else if (text == 'commonProviderId') {
							commonProviderId = parser.getText();
						} else if (text == 'originalProviderId') {
							originalProviderId = parser.getText();
						} else if (text == 'providerStreet1') {
							providerStreet1 = parser.getText();
						} else if (text == 'providerStreet2') {
							providerStreet2 = parser.getText();
						} else if (text == 'providerCity') {
							providerCity = parser.getText();
						} else if (text == 'policyNumber') {
							policyNumber = parser.getText();
						} else if (text == 'dayExtensionNew') {
							dayExtensionNew = parser.getText();
						} else if (text == 'documentControlNumber') {
							documentControlNumber = parser.getText();
						} else if (text == 'closeOfficeNumber') {
							closeOfficeNumber = parser.getText();
						} else if (text == 'closeDepartmentCode') {
							closeDepartmentCode = parser.getText();
						} else if (text == 'closeTeamCode') {
							closeTeamCode = parser.getText();
						} else if (text == 'lastUpdateOpid') {
							lastUpdateOpid = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'ServiceRequest consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}

	public class Provider {
		public String productCode {get;set;}
		public String panelNumber {get;set;}
		public String contractNumber {get;set;}
		public String ipa {get;set;}
		public String marketSegmentName {get;set;}
		public String serviceMarket {get;set;}
		public String serviceZip {get;set;}
		public String providerSourceSystem {get;set;}
		public String providerValidatedFlag {get;set;}
		public String pcpValidatedFlag {get;set;}
		public String stateIssuedID {get;set;}
		public String languageCode {get;set;}
		public String originalEffectiveDate {get;set;}
		public String statusCode {get;set;}
		public String emailIndicator {get;set;}
		public String otherIpa {get;set;}
		public Pcp pcp {get;set;}
		public Pcp provider {get;set;}

		public Provider(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'productCode') {
							productCode = parser.getText();
						} else if (text == 'panelNumber') {
							panelNumber = parser.getText();
						} else if (text == 'contractNumber') {
							contractNumber = parser.getText();
						} else if (text == 'ipa') {
							ipa = parser.getText();
						} else if (text == 'marketSegmentName') {
							marketSegmentName = parser.getText();
						} else if (text == 'serviceMarket') {
							serviceMarket = parser.getText();
						} else if (text == 'serviceZip') {
							serviceZip = parser.getText();
						} else if (text == 'providerSourceSystem') {
							providerSourceSystem = parser.getText();
						} else if (text == 'providerValidatedFlag') {
							providerValidatedFlag = parser.getText();
						} else if (text == 'pcpValidatedFlag') {
							pcpValidatedFlag = parser.getText();
						} else if (text == 'stateIssuedID') {
							stateIssuedID = parser.getText();
						} else if (text == 'languageCode') {
							languageCode = parser.getText();
						} else if (text == 'originalEffectiveDate') {
							originalEffectiveDate = parser.getText();
						} else if (text == 'statusCode') {
							statusCode = parser.getText();
						} else if (text == 'emailIndicator') {
							emailIndicator = parser.getText();
						} else if (text == 'otherIpa') {
							otherIpa = parser.getText();
						} else if (text == 'pcp') {
							pcp = new Pcp(parser);
						} else if (text == 'provider') {
							provider = new Pcp(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Provider consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}

	public class Owners {
		public String officeId {get;set;}
		public String associateId {get;set;}
		public String departmentCode {get;set;}
		public String teamCode {get;set;}
		public DependentName associateName {get;set;}
		public String officeName {get;set;}
		public String departmentName {get;set;}
		public String teamName {get;set;}
		public String type_z {get;set;} // in json: type
		public String headerNumber {get;set;}

		public Owners(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'officeId') {
							officeId = parser.getText();
						} else if (text == 'associateId') {
							associateId = parser.getText();
						} else if (text == 'departmentCode') {
							departmentCode = parser.getText();
						} else if (text == 'teamCode') {
							teamCode = parser.getText();
						} else if (text == 'associateName') {
							associateName = new DependentName(parser);
						} else if (text == 'officeName') {
							officeName = parser.getText();
						} else if (text == 'departmentName') {
							departmentName = parser.getText();
						} else if (text == 'teamName') {
							teamName = parser.getText();
						} else if (text == 'type') {
							type_z = parser.getText();
						} else if (text == 'headerNumber') {
							headerNumber = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Owners consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}

	public class EmployerInfo {
		public String employerNumber {get;set;}
		public String employerName {get;set;}
		public String employerState {get;set;}

		public EmployerInfo(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'employerNumber') {
							employerNumber = parser.getText();
						} else if (text == 'employerName') {
							employerName = parser.getText();
						} else if (text == 'employerState') {
							employerState = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'EmployerInfo consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}

	public ResponseHeader responseHeader {get;set;}
	public Issue issue {get;set;}

	public ACET_ORSReadIssueWrapper(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'responseHeader') {
						responseHeader = new ResponseHeader(parser);
					} else if (text == 'issue') {
						issue = new Issue(parser);
					} else {
						System.debug(LoggingLevel.WARN, 'ACET_ORSReadIssueWrapper consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}

	public class DependentName {
		public String firstName {get;set;}
		public String lastName {get;set;}

		public DependentName(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'firstName') {
							firstName = parser.getText();
						} else if (text == 'lastName') {
							lastName = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'DependentName consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}

	public class Originator {
		public String dialedId {get;set;}
		public String autoId {get;set;}
		public String icrCallLocationId {get;set;}
		public String icrCallLocationDay {get;set;}
		public String originatorMpin {get;set;}
		public String originatorTin {get;set;}
		public String originatorTinSuffix {get;set;}
		public CallerAddress callerAddress {get;set;}
		public DependentName callerName {get;set;}
		public DayPhone dayPhone {get;set;}
		public DayPhone eveningPhone {get;set;}

		public Originator(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'dialedId') {
							dialedId = parser.getText();
						} else if (text == 'autoId') {
							autoId = parser.getText();
						} else if (text == 'icrCallLocationId') {
							icrCallLocationId = parser.getText();
						} else if (text == 'icrCallLocationDay') {
							icrCallLocationDay = parser.getText();
						} else if (text == 'originatorMpin') {
							originatorMpin = parser.getText();
						} else if (text == 'originatorTin') {
							originatorTin = parser.getText();
						} else if (text == 'originatorTinSuffix') {
							originatorTinSuffix = parser.getText();
						} else if (text == 'callerAddress') {
							callerAddress = new CallerAddress(parser);
						} else if (text == 'callerName') {
							callerName = new DependentName(parser);
						} else if (text == 'dayPhone') {
							dayPhone = new DayPhone(parser);
						} else if (text == 'eveningPhone') {
							eveningPhone = new DayPhone(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Originator consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}

	public class DetailComments {
		public String headerNumber {get;set;}
		public String commentNumber {get;set;}
		public String commentType {get;set;} // in json: type
		public String commentDate {get;set;}
		public String commentTime {get;set;}
        public String commentText {get;set;}
		public String userId {get;set;}

		public DetailComments(JSONParser parser) {
            system.debug('==parser is '+parser);
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'headerNumber') {
							headerNumber = parser.getText();
						} else if (text == 'commentNumber') {
							commentNumber = parser.getText();
						} else if (text == 'type') {
							commentType = parser.getText();
						} else if (text == 'date') {
							commentDate = parser.getText();
						} else if (text == 'time') {
							commentTime = parser.getText();
						} else if (text == 'text') {
                            commentText = parser.getText();
						} else if (text == 'userId') {
							userId = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'DetailComments consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}

	public class Pcp {
		public String firstInitial {get;set;}
		public String lastName {get;set;}
		public String mpin {get;set;}
		public String mpinSequenceNumber {get;set;}
		public String taxPrefix {get;set;}
		public String taxId {get;set;}
		public String taxSuffix {get;set;}
		public String state {get;set;}
		public String zip {get;set;}

		public Pcp(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'firstInitial') {
							firstInitial = parser.getText();
						} else if (text == 'lastName') {
							lastName = parser.getText();
						} else if (text == 'mpin') {
							mpin = parser.getText();
						} else if (text == 'mpinSequenceNumber') {
							mpinSequenceNumber = parser.getText();
						} else if (text == 'taxPrefix') {
							taxPrefix = parser.getText();
						} else if (text == 'taxId') {
							taxId = parser.getText();
						} else if (text == 'taxSuffix') {
							taxSuffix = parser.getText();
						} else if (text == 'state') {
							state = parser.getText();
						} else if (text == 'zip') {
							zip = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Pcp consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}

	public class Member {
		public String zipCode {get;set;}
		public DependentName dependentName {get;set;}
		public String dependentNumber {get;set;}
		public DependentName memberName {get;set;}
		public String memberNumber {get;set;}
		public String groupName {get;set;}
		public String groupNumber {get;set;}
		public String relationshipCode {get;set;}
		public String relationship {get;set;}
		public String relationshipSequenceNumber {get;set;}
		public String customerNumber {get;set;}
		public String product {get;set;}
		public String market {get;set;}
		public String legalEntity {get;set;}
		public String policy {get;set;}
		public String planVariationCode {get;set;}
		public String reportingCode {get;set;}
		public String alternateId {get;set;}
		public String eligibilitySourceSystem {get;set;}
		public String division {get;set;}
		public String masterGroupNumber {get;set;}
		public String faxNumber {get;set;}
		public String email {get;set;}
		public String logonId {get;set;}
		public String site {get;set;}
		public String leadPlanCode {get;set;}
		public String personalIdentificationNumber {get;set;}
		public String primaryPolicyNumber {get;set;}
		public String sharedArrangementId {get;set;}
		public String obligorId {get;set;}
		public String eligibilityValidatedFlag {get;set;}
		public String otherSubscriberId {get;set;}
		public String statusCode {get;set;}
		public String medicareId {get;set;}
		public String medicaidId {get;set;}
		public String premiumWithholdCode {get;set;}
		public String coverageIndicator {get;set;}
		public String totalNonCoverageCount {get;set;}
		public String subsidyOverrideIndicator {get;set;}
		public String optOutIndicator {get;set;}
		public String enrollmentSourceCode {get;set;}
		public String secondaryDrugInsuranceIndicator {get;set;}
		public String lisPctCode {get;set;}
		public String copayEffectiveDate {get;set;}
		public String ssaPaymentCode {get;set;}
		public String logoIndicator {get;set;}
		public String fontIndicator {get;set;}
		public String stateCode {get;set;}
		public String countryCode {get;set;}
		public String genderCode {get;set;}
		public String verbalLanguageName {get;set;}
		public String writtenLanguageName {get;set;}
		public String emailIndicator {get;set;}
		public String raceEthnicityCode {get;set;}
		public String dateOfBirth {get;set;}
		public String age {get;set;}
		public String originalEffectiveDate {get;set;}
		public String assignedCsrName {get;set;}
		public String dateOfDeath {get;set;}
		public String medicareStatusCode {get;set;}
		public String dlEligIndicator {get;set;}
		public String pcpOverrideIndicator {get;set;}
		public String planCode {get;set;}
		public String benefitPackageCode {get;set;}
		public String regionCode {get;set;}
		public String ipaCode {get;set;}
		public String panelCode {get;set;}
		public String riderCodeIndicator {get;set;}
		public List<String> riderCodes {get;set;}
		public String meetingTypeName {get;set;}
		public String meetingDate {get;set;}
		public String ambulanceIndicator {get;set;}
		public String chiropracticServiceQuoted {get;set;}
		public String cosmeticServiceQuoted {get;set;}
		public String cataractSurgeryBenefitsQuoted {get;set;}
		public String deductibleServiceQuoted {get;set;}
		public String diabeticEducationServiceQuoted {get;set;}
		public String diabeticMonitorAndSuppliesServiceQuoted {get;set;}
		public String diagnosticAndRadiologyServiceQuoted {get;set;}
		public String diagnosticLaboratoryServiceQuoted {get;set;}
		public String durableMedicalEquipmentServiceQuoted {get;set;}
		public String emergencyAndUrgentCareServiceQuoted {get;set;}
		public String familyPlanningServiceQuoted {get;set;}
		public String hearingExamServiceQuoted {get;set;}
		public String homeHealthServiceQuoted {get;set;}
		public String immunizationsServiceQuoted {get;set;}
		public String inpatientHospitalAndMedicalServiceQuoted {get;set;}
		public String inpatientMentalHealthServiceQuoted {get;set;}
		public String medicareCoveredDentalServiceQuoted {get;set;}
		public String nonRadiologyAndTherapeuticServiceQuoted {get;set;}
		public String orthoticsAndProstheticsServiceQuoted {get;set;}
		public String maxOutOfPocketQuoted {get;set;}
		public String outpatientSurgeryAndObservationServiceQuoted {get;set;}
		public String outpatientMentalHealthServiceQuoted {get;set;}
		public String outpatientRehabilitationServiceQuoted {get;set;}
		public String passportIndicator {get;set;}
		public String pcpOfficeVisitServiceQuoted {get;set;}
		public String preventiveScreeningServiceQuoted {get;set;}
		public String csrProgramServiceQuoted {get;set;}
		public String renalDialysisServiceQuoted {get;set;}
		public String skilledNursingServiceQuoted {get;set;}
		public String transplantServiceQuoted {get;set;}
		public String specialistOfficeVisitServiceQuoted {get;set;}
		public String oonBenefitServiceQuoted {get;set;}
		public String visionBenefitServiceQuoted {get;set;}
		public String bloodServiceQuoted {get;set;}
		public String podiatryBenefitsServiceQuoted {get;set;}
		public String alternativeAndHolisticMedicineServiceQuoted {get;set;}
		public String careManagementProgramServiceQuoted {get;set;}
		public String custodialCareServiceQuoted {get;set;}
		public String valueAddedServiceServiceQuoted {get;set;}
		public String dentalServiceQuoted {get;set;}
		public String healthyLivingProgramsServiceQuoted {get;set;}
		public String hearingServiceQuoted {get;set;}
		public String gymMembershipServiceQuoted {get;set;}
		public String otcSuppliesServiceQuoted {get;set;}
		public String transportationServiceQuoted {get;set;}
		public String riderBenefitsServiceQuoted {get;set;}
		public String memberMeetingsServiceQuoted {get;set;}
		public String brandDrugsServiceQuoted {get;set;}
		public String genericDrugsServiceQuoted {get;set;}
		public String mailOrderServiceQuoted {get;set;}
		public String maxLimitationsServiceQuoted {get;set;}
		public String partBDrugsServiceQuoted {get;set;}
		public String pharmacyLocatorServiceQuoted {get;set;}
		public String preferredFormularyServiceQuoted {get;set;}
		public String unfundedProgramsServiceQuoted {get;set;}
		public String trueOopServiceQuoted {get;set;}
		public String clientCode {get;set;}
		public String networkPrefixCode {get;set;}
		public String memberVerifiedIndicator {get;set;}
		public String facetPlanCode {get;set;}
		public String otherProduct {get;set;}
		public String otherGroupNumber {get;set;}
		public String infNum {get;set;}

		public Member(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'zipCode') {
							zipCode = parser.getText();
						} else if (text == 'dependentName') {
							dependentName = new DependentName(parser);
						} else if (text == 'dependentNumber') {
							dependentNumber = parser.getText();
						} else if (text == 'memberName') {
							memberName = new DependentName(parser);
						} else if (text == 'memberNumber') {
							memberNumber = parser.getText();
						} else if (text == 'groupName') {
							groupName = parser.getText();
						} else if (text == 'groupNumber') {
							groupNumber = parser.getText();
						} else if (text == 'relationshipCode') {
							relationshipCode = parser.getText();
						} else if (text == 'relationship') {
							relationship = parser.getText();
						} else if (text == 'relationshipSequenceNumber') {
							relationshipSequenceNumber = parser.getText();
						} else if (text == 'customerNumber') {
							customerNumber = parser.getText();
						} else if (text == 'product') {
							product = parser.getText();
						} else if (text == 'market') {
							market = parser.getText();
						} else if (text == 'legalEntity') {
							legalEntity = parser.getText();
						} else if (text == 'policy') {
							policy = parser.getText();
						} else if (text == 'planVariationCode') {
							planVariationCode = parser.getText();
						} else if (text == 'reportingCode') {
							reportingCode = parser.getText();
						} else if (text == 'alternateId') {
							alternateId = parser.getText();
						} else if (text == 'eligibilitySourceSystem') {
							eligibilitySourceSystem = parser.getText();
						} else if (text == 'division') {
							division = parser.getText();
						} else if (text == 'masterGroupNumber') {
							masterGroupNumber = parser.getText();
						} else if (text == 'faxNumber') {
							faxNumber = parser.getText();
						} else if (text == 'email') {
							email = parser.getText();
						} else if (text == 'logonId') {
							logonId = parser.getText();
						} else if (text == 'site') {
							site = parser.getText();
						} else if (text == 'leadPlanCode') {
							leadPlanCode = parser.getText();
						} else if (text == 'personalIdentificationNumber') {
							personalIdentificationNumber = parser.getText();
						} else if (text == 'primaryPolicyNumber') {
							primaryPolicyNumber = parser.getText();
						} else if (text == 'sharedArrangementId') {
							sharedArrangementId = parser.getText();
						} else if (text == 'obligorId') {
							obligorId = parser.getText();
						} else if (text == 'eligibilityValidatedFlag') {
							eligibilityValidatedFlag = parser.getText();
						} else if (text == 'otherSubscriberId') {
							otherSubscriberId = parser.getText();
						} else if (text == 'statusCode') {
							statusCode = parser.getText();
						} else if (text == 'medicareId') {
							medicareId = parser.getText();
						} else if (text == 'medicaidId') {
							medicaidId = parser.getText();
						} else if (text == 'premiumWithholdCode') {
							premiumWithholdCode = parser.getText();
						} else if (text == 'coverageIndicator') {
							coverageIndicator = parser.getText();
						} else if (text == 'totalNonCoverageCount') {
							totalNonCoverageCount = parser.getText();
						} else if (text == 'subsidyOverrideIndicator') {
							subsidyOverrideIndicator = parser.getText();
						} else if (text == 'optOutIndicator') {
							optOutIndicator = parser.getText();
						} else if (text == 'enrollmentSourceCode') {
							enrollmentSourceCode = parser.getText();
						} else if (text == 'secondaryDrugInsuranceIndicator') {
							secondaryDrugInsuranceIndicator = parser.getText();
						} else if (text == 'lisPctCode') {
							lisPctCode = parser.getText();
						} else if (text == 'copayEffectiveDate') {
							copayEffectiveDate = parser.getText();
						} else if (text == 'ssaPaymentCode') {
							ssaPaymentCode = parser.getText();
						} else if (text == 'logoIndicator') {
							logoIndicator = parser.getText();
						} else if (text == 'fontIndicator') {
							fontIndicator = parser.getText();
						} else if (text == 'stateCode') {
							stateCode = parser.getText();
						} else if (text == 'countryCode') {
							countryCode = parser.getText();
						} else if (text == 'genderCode') {
							genderCode = parser.getText();
						} else if (text == 'verbalLanguageName') {
							verbalLanguageName = parser.getText();
						} else if (text == 'writtenLanguageName') {
							writtenLanguageName = parser.getText();
						} else if (text == 'emailIndicator') {
							emailIndicator = parser.getText();
						} else if (text == 'raceEthnicityCode') {
							raceEthnicityCode = parser.getText();
						} else if (text == 'dateOfBirth') {
							dateOfBirth = parser.getText();
						} else if (text == 'age') {
							age = parser.getText();
						} else if (text == 'originalEffectiveDate') {
							originalEffectiveDate = parser.getText();
						} else if (text == 'assignedCsrName') {
							assignedCsrName = parser.getText();
						} else if (text == 'dateOfDeath') {
							dateOfDeath = parser.getText();
						} else if (text == 'medicareStatusCode') {
							medicareStatusCode = parser.getText();
						} else if (text == 'dlEligIndicator') {
							dlEligIndicator = parser.getText();
						} else if (text == 'pcpOverrideIndicator') {
							pcpOverrideIndicator = parser.getText();
						} else if (text == 'planCode') {
							planCode = parser.getText();
						} else if (text == 'benefitPackageCode') {
							benefitPackageCode = parser.getText();
						} else if (text == 'regionCode') {
							regionCode = parser.getText();
						} else if (text == 'ipaCode') {
							ipaCode = parser.getText();
						} else if (text == 'panelCode') {
							panelCode = parser.getText();
						} else if (text == 'riderCodeIndicator') {
							riderCodeIndicator = parser.getText();
						} else if (text == 'riderCodes') {
							riderCodes = arrayOfString(parser);
						} else if (text == 'meetingTypeName') {
							meetingTypeName = parser.getText();
						} else if (text == 'meetingDate') {
							meetingDate = parser.getText();
						} else if (text == 'ambulanceIndicator') {
							ambulanceIndicator = parser.getText();
						} else if (text == 'chiropracticServiceQuoted') {
							chiropracticServiceQuoted = parser.getText();
						} else if (text == 'cosmeticServiceQuoted') {
							cosmeticServiceQuoted = parser.getText();
						} else if (text == 'cataractSurgeryBenefitsQuoted') {
							cataractSurgeryBenefitsQuoted = parser.getText();
						} else if (text == 'deductibleServiceQuoted') {
							deductibleServiceQuoted = parser.getText();
						} else if (text == 'diabeticEducationServiceQuoted') {
							diabeticEducationServiceQuoted = parser.getText();
						} else if (text == 'diabeticMonitorAndSuppliesServiceQuoted') {
							diabeticMonitorAndSuppliesServiceQuoted = parser.getText();
						} else if (text == 'diagnosticAndRadiologyServiceQuoted') {
							diagnosticAndRadiologyServiceQuoted = parser.getText();
						} else if (text == 'diagnosticLaboratoryServiceQuoted') {
							diagnosticLaboratoryServiceQuoted = parser.getText();
						} else if (text == 'durableMedicalEquipmentServiceQuoted') {
							durableMedicalEquipmentServiceQuoted = parser.getText();
						} else if (text == 'emergencyAndUrgentCareServiceQuoted') {
							emergencyAndUrgentCareServiceQuoted = parser.getText();
						} else if (text == 'familyPlanningServiceQuoted') {
							familyPlanningServiceQuoted = parser.getText();
						} else if (text == 'hearingExamServiceQuoted') {
							hearingExamServiceQuoted = parser.getText();
						} else if (text == 'homeHealthServiceQuoted') {
							homeHealthServiceQuoted = parser.getText();
						} else if (text == 'immunizationsServiceQuoted') {
							immunizationsServiceQuoted = parser.getText();
						} else if (text == 'inpatientHospitalAndMedicalServiceQuoted') {
							inpatientHospitalAndMedicalServiceQuoted = parser.getText();
						} else if (text == 'inpatientMentalHealthServiceQuoted') {
							inpatientMentalHealthServiceQuoted = parser.getText();
						} else if (text == 'medicareCoveredDentalServiceQuoted') {
							medicareCoveredDentalServiceQuoted = parser.getText();
						} else if (text == 'nonRadiologyAndTherapeuticServiceQuoted') {
							nonRadiologyAndTherapeuticServiceQuoted = parser.getText();
						} else if (text == 'orthoticsAndProstheticsServiceQuoted') {
							orthoticsAndProstheticsServiceQuoted = parser.getText();
						} else if (text == 'maxOutOfPocketQuoted') {
							maxOutOfPocketQuoted = parser.getText();
						} else if (text == 'outpatientSurgeryAndObservationServiceQuoted') {
							outpatientSurgeryAndObservationServiceQuoted = parser.getText();
						} else if (text == 'outpatientMentalHealthServiceQuoted') {
							outpatientMentalHealthServiceQuoted = parser.getText();
						} else if (text == 'outpatientRehabilitationServiceQuoted') {
							outpatientRehabilitationServiceQuoted = parser.getText();
						} else if (text == 'passportIndicator') {
							passportIndicator = parser.getText();
						} else if (text == 'pcpOfficeVisitServiceQuoted') {
							pcpOfficeVisitServiceQuoted = parser.getText();
						} else if (text == 'preventiveScreeningServiceQuoted') {
							preventiveScreeningServiceQuoted = parser.getText();
						} else if (text == 'csrProgramServiceQuoted') {
							csrProgramServiceQuoted = parser.getText();
						} else if (text == 'renalDialysisServiceQuoted') {
							renalDialysisServiceQuoted = parser.getText();
						} else if (text == 'skilledNursingServiceQuoted') {
							skilledNursingServiceQuoted = parser.getText();
						} else if (text == 'transplantServiceQuoted') {
							transplantServiceQuoted = parser.getText();
						} else if (text == 'specialistOfficeVisitServiceQuoted') {
							specialistOfficeVisitServiceQuoted = parser.getText();
						} else if (text == 'oonBenefitServiceQuoted') {
							oonBenefitServiceQuoted = parser.getText();
						} else if (text == 'visionBenefitServiceQuoted') {
							visionBenefitServiceQuoted = parser.getText();
						} else if (text == 'bloodServiceQuoted') {
							bloodServiceQuoted = parser.getText();
						} else if (text == 'podiatryBenefitsServiceQuoted') {
							podiatryBenefitsServiceQuoted = parser.getText();
						} else if (text == 'alternativeAndHolisticMedicineServiceQuoted') {
							alternativeAndHolisticMedicineServiceQuoted = parser.getText();
						} else if (text == 'careManagementProgramServiceQuoted') {
							careManagementProgramServiceQuoted = parser.getText();
						} else if (text == 'custodialCareServiceQuoted') {
							custodialCareServiceQuoted = parser.getText();
						} else if (text == 'valueAddedServiceServiceQuoted') {
							valueAddedServiceServiceQuoted = parser.getText();
						} else if (text == 'dentalServiceQuoted') {
							dentalServiceQuoted = parser.getText();
						} else if (text == 'healthyLivingProgramsServiceQuoted') {
							healthyLivingProgramsServiceQuoted = parser.getText();
						} else if (text == 'hearingServiceQuoted') {
							hearingServiceQuoted = parser.getText();
						} else if (text == 'gymMembershipServiceQuoted') {
							gymMembershipServiceQuoted = parser.getText();
						} else if (text == 'otcSuppliesServiceQuoted') {
							otcSuppliesServiceQuoted = parser.getText();
						} else if (text == 'transportationServiceQuoted') {
							transportationServiceQuoted = parser.getText();
						} else if (text == 'riderBenefitsServiceQuoted') {
							riderBenefitsServiceQuoted = parser.getText();
						} else if (text == 'memberMeetingsServiceQuoted') {
							memberMeetingsServiceQuoted = parser.getText();
						} else if (text == 'brandDrugsServiceQuoted') {
							brandDrugsServiceQuoted = parser.getText();
						} else if (text == 'genericDrugsServiceQuoted') {
							genericDrugsServiceQuoted = parser.getText();
						} else if (text == 'mailOrderServiceQuoted') {
							mailOrderServiceQuoted = parser.getText();
						} else if (text == 'maxLimitationsServiceQuoted') {
							maxLimitationsServiceQuoted = parser.getText();
						} else if (text == 'partBDrugsServiceQuoted') {
							partBDrugsServiceQuoted = parser.getText();
						} else if (text == 'pharmacyLocatorServiceQuoted') {
							pharmacyLocatorServiceQuoted = parser.getText();
						} else if (text == 'preferredFormularyServiceQuoted') {
							preferredFormularyServiceQuoted = parser.getText();
						} else if (text == 'unfundedProgramsServiceQuoted') {
							unfundedProgramsServiceQuoted = parser.getText();
						} else if (text == 'trueOopServiceQuoted') {
							trueOopServiceQuoted = parser.getText();
						} else if (text == 'clientCode') {
							clientCode = parser.getText();
						} else if (text == 'networkPrefixCode') {
							networkPrefixCode = parser.getText();
						} else if (text == 'memberVerifiedIndicator') {
							memberVerifiedIndicator = parser.getText();
						} else if (text == 'facetPlanCode') {
							facetPlanCode = parser.getText();
						} else if (text == 'otherProduct') {
							otherProduct = parser.getText();
						} else if (text == 'otherGroupNumber') {
							otherGroupNumber = parser.getText();
						} else if (text == 'infNum') {
							infNum = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Member consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}

	public class Claim {
		public String totalAmount {get;set;}
		public String authorization {get;set;}
		public String claimNumber {get;set;}
		public String invoiceNumber {get;set;}
		public String serviceDate {get;set;}
		public String filmNumber {get;set;}
		public String filmSystem {get;set;}
		public String filmOffice {get;set;}
		public String payLocationNumber {get;set;}
		public String engineCode {get;set;}
		public String claimApp {get;set;}
		public String claimAppSsn {get;set;}
		public String claimOffice {get;set;}
		public String claimOfficeName {get;set;}
		public String fundingArrangement {get;set;}

		public Claim(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'totalAmount') {
							totalAmount = parser.getText();
						} else if (text == 'authorization') {
							authorization = parser.getText();
						} else if (text == 'claimNumber') {
							claimNumber = parser.getText();
						} else if (text == 'invoiceNumber') {
							invoiceNumber = parser.getText();
						} else if (text == 'serviceDate') {
							serviceDate = parser.getText();
						} else if (text == 'filmNumber') {
							filmNumber = parser.getText();
						} else if (text == 'filmSystem') {
							filmSystem = parser.getText();
						} else if (text == 'filmOffice') {
							filmOffice = parser.getText();
						} else if (text == 'payLocationNumber') {
							payLocationNumber = parser.getText();
						} else if (text == 'engineCode') {
							engineCode = parser.getText();
						} else if (text == 'claimApp') {
							claimApp = parser.getText();
						} else if (text == 'claimAppSsn') {
							claimAppSsn = parser.getText();
						} else if (text == 'claimOffice') {
							claimOffice = parser.getText();
						} else if (text == 'claimOfficeName') {
							claimOfficeName = parser.getText();
						} else if (text == 'fundingArrangement') {
							fundingArrangement = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Claim consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}

	public class Other {
		public String incompleteFlag {get;set;}
		public String qaCategory {get;set;}
		public String qaCodeType {get;set;}
		public String qaSource {get;set;}
		public String qitType {get;set;}
		public String company {get;set;}
		public String lineType {get;set;}
		public String insuranceCompany {get;set;}
		public String complState {get;set;}

		public Other(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'incompleteFlag') {
							incompleteFlag = parser.getText();
						} else if (text == 'qaCategory') {
							qaCategory = parser.getText();
						} else if (text == 'qaCodeType') {
							qaCodeType = parser.getText();
						} else if (text == 'qaSource') {
							qaSource = parser.getText();
						} else if (text == 'qitType') {
							qitType = parser.getText();
						} else if (text == 'company') {
							company = parser.getText();
						} else if (text == 'lineType') {
							lineType = parser.getText();
						} else if (text == 'insuranceCompany') {
							insuranceCompany = parser.getText();
						} else if (text == 'complState') {
							complState = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Other consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}

	public static ACET_ORSReadIssueWrapper parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new ACET_ORSReadIssueWrapper(parser);
	}

	public static void consumeObject(System.JSONParser parser) {
		Integer depth = 0;
		do {
			System.JSONToken curr = parser.getCurrentToken();
			if (curr == System.JSONToken.START_OBJECT ||
				curr == System.JSONToken.START_ARRAY) {
				depth++;
			} else if (curr == System.JSONToken.END_OBJECT ||
				curr == System.JSONToken.END_ARRAY) {
				depth--;
			}
		} while (depth > 0 && parser.nextToken() != null);
	}

    private static List<DetailComments> arrayOfDetailComments(System.JSONParser p) {
        List<DetailComments> res = new List<DetailComments>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new DetailComments(p));
        }
        return res;
    }

    private static List<String> arrayOfString(System.JSONParser p) {
        List<String> res = new List<String>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(p.getText());
        }
        return res;
    }

    private static List<Owners> arrayOfOwners(System.JSONParser p) {
        List<Owners> res = new List<Owners>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Owners(p));
        }
        return res;
    }
}