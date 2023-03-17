public class ACETFindHCOAffJSON2Apex {
    public class Speciality {
     //   public String statusCode { get; set; }
     //   public String effectiveDate { get; set; }
     //   public String cancelDate { get; set; }
        public String primarySpecialtyIndicator { get; set; }
     //   public String typeCode { get; set; }
        public String typeDescription { get; set; }
    }

    public class findMedicalHealthcareOrganizationAffiliationsResponse {
        public List<MedicalHealthcareOrganizationAffiliations> medicalHealthcareOrganizationAffiliations { get; set; }
        public ACETOILPagination pagination {get;set;}
        public ACETOILError[] errors {get;set;}
    }

    public findMedicalHealthcareOrganizationAffiliationsResponse findMedicalHealthcareOrganizationAffiliationsResponse { get; set; }
    
    public class Hcp {
     //   public String statusCode { get; set; }
        public String id { get; set; }
     //   public String effectiveDate { get; set; }
    //    public String cancelDate { get; set; }
        public String firstName { get; set; }
        public String lastName { get; set; }
        public String middleName { get; set; }
    }

    public class MedicalHealthcareOrganizationAffiliations {
     //   public Key key { get; set; }
        public Hcp hcp { get; set; }
        public Affiliation affiliation { get; set; }
        public List<Speciality> speciality { get; set; }
    }

   /* public class FindMedicalHealthcareOrganizationAffiliationsResult {
        public FindMedicalHealthcareOrganizationAffiliationsResponseType findMedicalHealthcareOrganizationAffiliationsResponseType { get; set; }
    } */

/*    public class Key {
        public String healthcareOrganizationId { get; set; }
        public String healthcareProfessionalId { get; set; }
    }   */

    public class Affiliation {
      //  public String statusCode { get; set; }
        public String effectiveDate { get; set; }
      //  public String cancelDate { get; set; }
      //  public String admittingPrivilegeTypeCode { get; set; }
     //   public String admittingPrivilegeTypeDescription { get; set; }
    }
}