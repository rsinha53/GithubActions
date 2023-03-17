@isTest(SeeAllData=false)
private class ACETProviderContractResultTest{
    
    static testMethod void ACETProviderContractResultMethod1() 
    {
        ACETProviderContractResult ACETPCRxt1 = new ACETProviderContractResult();
        ACETPCRxt1.Product = 'test';
        ACETPCRxt1.Network_ID = 'test'; 
        ACETPCRxt1.Network_Name  = 'test';
        ACETPCRxt1.Network_Status  = 'test';
        ACETPCRxt1.Effective  = 'test';
        ACETPCRxt1.Cancel  = 'test';
        ACETPCRxt1.IPA  = 'test';
        ACETPCRxt1.Capitation  = 'test';
        ACETPCRxt1.Accepting_New_Patients  = 'test';
        ACETPCRxt1.AgreementStatusCode = 'test';
        ACETPCRxt1.isActive  = true;
        ACETPCRxt1.GUID  = 'test';
        ACETPCRxt1.Pricing_Set_ID='';
        ACETPCRxt1.Accepting_Existing_Patients='';
        ACETPCRxt1.ProviderAssignmentType='';
        ACETPCRxt1.ContractHeaderId='';
        ACETPCRxt1.ContractDetailId='';
        ACETPCRxt1.NetworkSchedule='';
        ACETPCRxt1.BenefitPlanId='';
        ACETPCRxt1.Contract_Status='';
        ACETPCRxt1.claimType='';
   // public String Network_statusCode{ set; get; }
    	ACETPCRxt1.isSuccess = true;
    	ACETPCRxt1.Message= 'Response successful';
        ACETPCRxt1.NetworkNamePricngSet='';
        ACETPCRxt1.statusCode='';
        ACETPCRxt1.process_Order_Number='';
        ACETPCRxt1.organizationName='';
        ACETPCRxt1.providerAssignmentIndicator='';
        ACETPCRxt1.GUID='';
        ACETPCRxt1.messageSeverityStr='';
        ACETProviderContractResult apcr = new ACETProviderContractResult(ACETPCRxt1);
        
    }    
}