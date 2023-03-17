/*
 * @Desc: US2154799 - Deserialize Find Authentication Response
 * @Date: 23-12-2019
 * @Dev: Malinda
*/
public class ACET_FindAuthorizationJSON2Apex {

    public class OutPatientsFacilitySummary {
		public ProcedureCode procedureCode;
		public ServiceDateRange serviceDateRange;
		public String procedureUnitCount;
		public FacilityProviderNetworkStatusType procedureUnitOfMeasureType;
		public FacilityProviderNetworkStatusType servicingProviderNetworkStatusType;
		public String authId;
		public String primaryServiceReferenceNumber;
		public String globalID;
		//public FacilityProviderNetworkStatusType statusType;
		public StatusType statusType; //US2291037
		public FacilityProviderNetworkStatusType statusReasonType;
		public FacilityProviderNetworkStatusType serviceSettingType;
		public String preDeterminationInd;
		public String createDateTime;
		public FacilityProviderNetworkStatusType primaryDiagnosisCode;
		public FacilityProviderNetworkStatusType primaryDiagnosisCodeSchemeTypeID;
		public FacilityProviderNetworkStatusType serviceDescUrgencyCode;
		public FacilityProviderNetworkStatusType serviceDetailCategoryCode;
		public FacilityProviderNetworkStatusType placeOfServiceCode;
		public Member member;
		//---------------------
		public String actualAdmitDateTime;
		public String actualDischargeDateTime;
		public String servicingProviderFirstName;
		public String servicingProviderLastName;
		public String facilityProviderOrganizationName;
		public FacilityProviderNetworkStatusType facilityProviderNetworkStatusType;
        //US2308090 - 23 JAN 2020
		public String expectedAdmitDate;
		public String expectedDischargeDate;
	}

	public class Pagination {
		public String pageSize;
		public String totalCount;
		public String startRecord;
		public String moreRecords;
	}

	public class FacilityProviderNetworkStatusType {
		public String code;
		public String description;
	}

	public class AuthSummaryResponse {
		public List<InPatientsSummary> inPatientsSummary;
		public List<OutPatientsSummary> outPatientsSummary;
		public List<OutPatientsFacilitySummary> outPatientsFacilitySummary;
		public List<OutPatientsFacilitySummary> authSummaryProviders;
		public Pagination pagination;
	}

	public class ServiceDateRange {
		public String startDate;
		public String stopDate;
	}

	public class ProcedureCode {
		public String code;
		public String codeDesc;
		public String typeCode;
		public String typeCodeDesc;
	}

	public class InPatientsSummary {
		public String expectedAdmitDate;
		public String expectedDischargeDate;
		public String actualAdmissionDateTime;
		public String actualDischargeDateTime;
		public String facilityProviderOrganizationName;
		public FacilityProviderNetworkStatusType facilityProviderNetworkStatusType;
		public String lengthOfStay;
		public String authId;
		public String primaryServiceReferenceNumber;
		public String globalID;
		//public FacilityProviderNetworkStatusType statusType;
		public StatusType statusType; //US2291037
		public FacilityProviderNetworkStatusType statusReasonType;
		public FacilityProviderNetworkStatusType serviceSettingType;
		public String preDeterminationInd;
		public String createDateTime;
		public FacilityProviderNetworkStatusType primaryDiagnosisCode;
		public FacilityProviderNetworkStatusType primaryDiagnosisCodeSchemeTypeID;
		public String diagnosisOtherText;
		public FacilityProviderNetworkStatusType serviceDescUrgencyCode;
		public FacilityProviderNetworkStatusType serviceDetailCategoryCode;
		public FacilityProviderNetworkStatusType placeOfServiceCode;
		public Member member;
		//----------------------------
		public String servicingProviderFirstName;
		public String servicingProviderLastName;
		

	}

	public AuthSummaryResponse authSummaryResponse;

	public class Member {
		public String firstName;
		public String lastName;
		public String birthDate;
		public String subscriberId;
	}

	//US2291037	 Pilot Minot Changes - Add Status on Authorization Results - Sarma - 29-01-2010
	public class StatusType {       
		public String code;
		public String description;
	}

	public class OutPatientsSummary {
		public ProcedureCode procedureCode;
		public ServiceDateRange serviceDateRange;
		public String procedureUnitCount;
		public FacilityProviderNetworkStatusType procedureUnitOfMeasureType;
		public FacilityProviderNetworkStatusType servicingProviderNetworkStatusType;
		public String authId;
		public String primaryServiceReferenceNumber;
		public String globalID;
		//public FacilityProviderNetworkStatusType statusType;
		public StatusType statusType; //US2291037
		public FacilityProviderNetworkStatusType statusReasonType;
		public FacilityProviderNetworkStatusType serviceSettingType;
		public String preDeterminationInd;
		public String createDateTime;
		public FacilityProviderNetworkStatusType primaryDiagnosisCode;
		public FacilityProviderNetworkStatusType primaryDiagnosisCodeSchemeTypeID;
		public FacilityProviderNetworkStatusType serviceDescUrgencyCode;
		public FacilityProviderNetworkStatusType serviceDetailCategoryCode;
		public FacilityProviderNetworkStatusType placeOfServiceCode;
		public Member member;
		//---------------------------------------
		public String servicingProviderFirstName;
		public String servicingProviderLastName;
	}

	
	public static ACET_FindAuthorizationJSON2Apex parse(String json) {
		return (ACET_FindAuthorizationJSON2Apex) System.JSON.deserialize(json, ACET_FindAuthorizationJSON2Apex.class);
	}

}