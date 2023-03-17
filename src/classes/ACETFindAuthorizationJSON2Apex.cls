public class ACETFindAuthorizationJSON2Apex  {

    public class OutPatientsFacilitySummary {
        public ProcedureCode procedureCode{get;set;}
        public String expectedAdmitDate;
        public String expectedDischargeDate;
        public String actualAdmissionDateTime;
        public String actualDischargeDateTime;
        public String facilityProviderOrganizationName;
        public FacilityProviderNetworkStatusType facilityProviderNetworkStatusType;
        public String authId;
        public String primaryServiceReferenceNumber;
        public String globalID;
        public FacilityProviderNetworkStatusType statusType;
        public FacilityProviderNetworkStatusType statusReasonType;
        public FacilityProviderNetworkStatusType serviceSettingType;
        public String preDeterminationInd;
        public String createDateTime;
        public FacilityProviderNetworkStatusType primaryDiagnosisCode;
        public FacilityProviderNetworkStatusType primaryDiagnosisCodeSchemeTypeID;
        public FacilityProviderNetworkStatusType serviceDescUrgencyCode;
        public FacilityProviderNetworkStatusType serviceDetailCategoryCode;
        public String servicingProviderFirstName;
        public String servicingProviderLastName;
        public FacilityProviderNetworkStatusType placeofServiceCode;
        public Member member;
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
        public List<AuthSummaryProviders> authSummaryProviders;
        public Pagination pagination;
        public List<errors> errors;
    }
    
    public class errors {
        public Integer code;    //400
        public String name; 
        public String severity; //INFORMATIONAL
        public String origin;   //eisl
        public String description;  //ERR004-Member not found
    }
    
    public class ServiceDateRange {
        public String startDate;
        public String stopDate;
    }

    public AuthSummaryResponse authSummaryResponse;

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
        public FacilityProviderNetworkStatusType statusType;
        public FacilityProviderNetworkStatusType statusReasonType;
        public FacilityProviderNetworkStatusType serviceSettingType;
        public String preDeterminationInd;
        public String createDateTime;
        public FacilityProviderNetworkStatusType primaryDiagnosisCode;
        public FacilityProviderNetworkStatusType primaryDiagnosisCodeSchemeTypeID;
        public FacilityProviderNetworkStatusType serviceDescUrgencyCode;
        public FacilityProviderNetworkStatusType serviceDetailCategoryCode;
        public String servicingProviderFirstName;
        public String servicingProviderLastName;
        public FacilityProviderNetworkStatusType placeofServiceCode;
        public Member member;
    }

    public class Member {
        public String firstName;
        public String lastName;
        public String birthDate;
        public String subscriberId;
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
        public FacilityProviderNetworkStatusType statusType;
        public FacilityProviderNetworkStatusType statusReasonType;
        public FacilityProviderNetworkStatusType serviceSettingType;
        public String preDeterminationInd;
        public String createDateTime;
        public FacilityProviderNetworkStatusType primaryDiagnosisCode;
        public FacilityProviderNetworkStatusType primaryDiagnosisCodeSchemeTypeID;
        public FacilityProviderNetworkStatusType serviceDescUrgencyCode;
        public FacilityProviderNetworkStatusType serviceDetailCategoryCode;
        public String servicingProviderFirstName;
        public String servicingProviderLastName;
        public FacilityProviderNetworkStatusType placeofServiceCode;
        public Member member;
    }

    public class AuthSummaryProviders {
    }
}