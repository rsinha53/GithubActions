public class ACETProviderContractResult {
    public String Product { set; get; }
    public String Network_ID { set; get; }
    public String Network_Name { set; get; }
    public String Network_Status { set; get; }
    public string Effective { set; get; }
    public string Cancel { set; get; }
    public string IPA { set; get; }
    public String Pricing_Set_ID {get;set;}
    public string Capitation { set; get; }
    public String Accepting_New_Patients { set; get; }
    public String Accepting_Existing_Patients { set; get; }
    public String AgreementStatusCode {set; get;}
    public String ProviderAssignmentType {set; get;}
    public Boolean isActive { set; get; }
    public String ContractHeaderId { set; get; }
    public String ContractDetailId { set; get; }
    public String NetworkSchedule { set; get; }
    public String BenefitPlanId { set; get; }
    public String Contract_Status { set; get; }
    public String claimType {get;set;}
   // public String Network_statusCode{ set; get; }
    public boolean isSuccess;
    public string Message{get;set;}
    public apexPages.Severity MessageSeverity{get;set;} 
    public string messageSeverityStr{get;set;}
    public ACETOILError[] errors;
    public String NetworkNamePricngSet{get;set;}
    public String statusCode{get;set;}
	public String process_Order_Number{get;set;}
    public String organizationName{get;set;}
    public String providerAssignmentIndicator{get;set;}
    Public String GUID {get;set;} //manually generated
    Public ACETProviderContractResult(){
    GUID = ACETGUIDUtil.newGuid();
    }
    public ACETProviderContractResult(ACETProviderContractResult providerContractResult) {
        this.Accepting_New_Patients= providerContractResult.Accepting_New_Patients;
        this.ContractDetailId = providerContractResult.ContractDetailId ;
        this.ContractHeaderId = providerContractResult.ContractHeaderId;
        this.NetworkNamePricngSet = providerContractResult.NetworkNamePricngSet;
        this.Network_ID = providerContractResult.Network_ID;
        this.Network_Name = providerContractResult.Network_Name;
        this.Network_Status = providerContractResult.Network_Status;
        this.Pricing_Set_ID = providerContractResult.Pricing_Set_ID ;
        this.ProviderAssignmentType = providerContractResult.ProviderAssignmentType;
        this.organizationName = providerContractResult.organizationName;
        this.process_Order_Number = providerContractResult.process_Order_Number;
        this.providerAssignmentIndicator = providerContractResult.providerAssignmentIndicator;
    }
}