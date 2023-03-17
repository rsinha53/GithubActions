public class ACETLGT_ProviderContractResult {
    @Auraenabled public String Product { set; get; }
    @Auraenabled public String Network_ID { set; get; }
    @Auraenabled public String Network_Name { set; get; }
    @Auraenabled public String Network_Status { set; get; }
    @Auraenabled public string Effective { set; get; }
    @Auraenabled public string Cancel { set; get; }
    @Auraenabled public string IPA { set; get; }
    @Auraenabled public String Pricing_Set_ID {get;set;}
    @Auraenabled public String Accepting_New_Patients { set; get; }
    @Auraenabled public String Accepting_Existing_Patients { set; get; }
    @Auraenabled public String ProviderAssignmentType {set; get;}
    @Auraenabled public String ContractHeaderId { set; get; }
    @Auraenabled public String ContractDetailId { set; get; }
    @Auraenabled public String NetworkSchedule { set; get; }
    @Auraenabled public String Contract_Status { set; get; }
    @Auraenabled public boolean isSuccess;
    @Auraenabled public string Message{get;set;}
    @Auraenabled public String NetworkNamePricngSet{get;set;}
    @Auraenabled public String statusCode{get;set;}
    @Auraenabled public String process_Order_Number{get;set;}
    @Auraenabled public String organizationName{get;set;}
    @Auraenabled public String providerAssignmentIndicator{get;set;}
    public ACETLGT_ProviderContractResult(ACETLGT_ProviderContractResult providerContractResult) {
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
	 public ACETLGT_ProviderContractResult() {
        
    }
}