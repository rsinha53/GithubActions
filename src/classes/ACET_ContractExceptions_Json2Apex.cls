public class ACET_ContractExceptions_Json2Apex {
    public class FacilityDetail0002Response {
        public MedNecData medNecData;
    }
    
    public List<FacilityDetail0002Response> FacilityDetail0002Response;
    public Metadata metadata;
    
    public class MedNecData {
        public String cancelDate;
        public String effectiveDate;
        public List<MedNecClauseData> medNecClauseData;
        public String medicalNecessityIndicator;
    }
    
    public class Metadata {
        public Integer offset;
        public Integer psize;
        public Integer total;
        public String elapsedTime;
        public String elasticTime;
        public String elapsedPODMTime;
        public String elapsedHealthAtScaleTime;
        public String healthAtScaleResponseStatusCode;
        public String healthAtScaleTimeResponseStatusMessage;
        public String versionNumber;
        public String releaseType;
        public String releaseDate;
        public String supportContact;
    }
    
    public class MedNecClauseData {
        public String clauseCode;
        public String clinicalDescription;
        public String provision;
        public String standardModifiedIndicator;
    }
    
    
    public static ACET_ContractExceptions_Json2Apex parse(String json) {
        return (ACET_ContractExceptions_Json2Apex) System.JSON.deserialize(json, ACET_ContractExceptions_Json2Apex.class);
    }
}