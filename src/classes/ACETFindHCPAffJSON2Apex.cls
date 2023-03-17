public class ACETFindHCPAffJSON2Apex {

  /*  public class findMedicalHealthcareProfessionalAffiliationsResponse {
        public MedicalHealthcareOrganization MedicalHealthcareOrganization { get; set; }
    } */

    public findMedicalHealthcareProfessionalAffiliationsResponse findMedicalHealthcareProfessionalAffiliationsResponse { get; set; }

    public class MedicalHealthcareOrganization {
    //    public Key key { get; set; }
        public Hco hco { get; set; }
        public Affiliation affiliation { get; set; }
    }

    public class Hco {
      //  public String statusCode { get; set; }        
     //   public String effectiveDate { get; set; }
     //   public String cancelDate { get; set; }
        public String name { get; set; }
        public String id { get; set; }
    }

    public class findMedicalHealthcareProfessionalAffiliationsResponse {
 
        public List<MedicalHealthcareOrganization> medicalHealthcareOrganization { get; set; }
        public ACETOILPagination pagination {get;set;}
        public ACETOILError[] errors { get; set; }
    }

/*    public class Key {
        public String healthcareProfessionalId { get; set; }
        public String healthcareOrganizationId { get; set; }
    }   */

    public class Affiliation {
      //  public String statusCode { get; set; }
        public String effectiveDate { get; set; }
      //  public String cancelDate { get; set; }
     //   public String admittingPrivilegeTypeCode { get; set; }
     //   public String admittingPrivilegeTypeDescription { get; set; }
    }
}