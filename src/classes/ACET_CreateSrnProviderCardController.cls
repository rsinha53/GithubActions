public class ACET_CreateSrnProviderCardController {

    @AuraEnabled
    public static ACET_ProviderStatusCtrl.ACET_MAndRProviderStatusWrapper getMAndRProviderStatus(String providerId, String taxId, String addressId, String cosDiv, String cosPanNum, String coverageStartDate, String coverageEndDate,string provDiv){//US3574032
        ACET_ProviderStatusCtrl.ACET_MAndRProviderStatusWrapper wrapper = new ACET_ProviderStatusCtrl.ACET_MAndRProviderStatusWrapper();
        // US3244384 Integration for Member Div to Provider Div Mapping - Sarma - 01/03/2021
        wrapper = ACET_ProviderStatusCtrl.getMAndRProviderStatus(providerId,taxId,addressId,cosDiv,cosPanNum,coverageStartDate,coverageEndDate,provDiv);//US3574032
        return wrapper;
    }

    @AuraEnabled
    public static ACET_ProviderStatusCtrl.ACET_NetworkKeyStatusWrapper getNetworkKeyStatus(String subscriberId, String policyNumber, String sourceCode, String coverageLevel){
       
        ACET_ProviderStatusCtrl.ACET_NetworkKeyStatusWrapper networkKeyWrapper = new ACET_ProviderStatusCtrl.ACET_NetworkKeyStatusWrapper();
        networkKeyWrapper = ACET_ProviderStatusCtrl.getNetworkKeyStatus(subscriberId,policyNumber,sourceCode,coverageLevel);
        // networkKeyWrapper.success = true;
        // networkKeyWrapper.callENIContracts = true;
        // networkKeyWrapper.networkKey = 'T';
        return networkKeyWrapper;
    }
    @AuraEnabled
    public static ACET_ProviderStatusCtrl.ACET_EAndIProviderStatusWrapper getEAndIProviderStatus(String providerId, String taxId, String addressSeq, String marketType, String marketSite, String insTypeCode,String networkKey){
       
        ACET_ProviderStatusCtrl.ACET_EAndIProviderStatusWrapper wrapper = new ACET_ProviderStatusCtrl.ACET_EAndIProviderStatusWrapper();

        wrapper = ACET_ProviderStatusCtrl.getEAndIProviderStatus(providerId,taxId,addressSeq,marketType,marketSite,insTypeCode,networkKey);

        return wrapper;
    }
// US3507490	Mapping for Contract Org Type and Amendment - Sarma - 20th May 2021
    @AuraEnabled
    public static ReturnResponse getProviderData(String providerId, String taxId, String adrseq) {

        ReturnResponse returnResponse = new ReturnResponse();
        List<ACET_CreateAuthRequest.ProviderContractAmendment> providerContractAmendmentList = new List<ACET_CreateAuthRequest.ProviderContractAmendment>();
        ACET_CreateAuthRequest.ProviderContractAmendments providerContractAmendments = new ACET_CreateAuthRequest.ProviderContractAmendments();
        try {
            String urlDetail = '?app-nm=acet&active-ind=ACTIVE&start=0&count=50&prov-id=' + providerId + '&tax-id-nbr=' + taxId + '&adr-seq=' + adrseq + '&attribute-set=Detail_0001';
            SAE_ProviderCardCtrl.ProviderDetails reqParamsDetail = new SAE_ProviderCardCtrl.ProviderDetails();
            reqParamsDetail.IsSnapshot = true;
            reqParamsDetail.SnapshotParameters = urlDetail;
            Map < String, Object > provDataDetail = SAE_ProviderCardCtrl.getProviderSearchResponse(reqParamsDetail, false);
            system.debug('@@@ Provide Detail Response Body :: ' + provDataDetail );
            ACET_ProviderDetailResponse detailResponse = new ACET_ProviderDetailResponse();
            if (provDataDetail.get('statusCode') == 200) {
                String jsonString = provDataDetail.get('providerResponseJSON').toString();
                detailResponse = ACET_ProviderDetailResponse.parse(jsonString);

                if(detailResponse != null && detailResponse.svcResponse != null){
                    if(detailResponse.svcResponse.physicianFacilityInformation != null && detailResponse.svcResponse.physicianFacilityInformation.unetContract != null){

                        for(ACET_ProviderDetailResponse.UnetContract contractObj : detailResponse.svcResponse.physicianFacilityInformation.unetContract){
                            if(contractObj.medicalNecessityAgreement != null){
                                for(ACET_ProviderDetailResponse.MedicalNecessityAgreement agreement : contractObj.medicalNecessityAgreement){
                                    if(!(String.isBlank(agreement.documentId) && String.isBlank(agreement.effectiveDate) && String.isBlank(agreement.cancelDate) && String.isBlank(agreement.medicalNecessityIndicator) && String.isBlank(agreement.documentIdTypeCode))){
                                        ACET_CreateAuthRequest.ProviderContractAmendment amendment = new ACET_CreateAuthRequest.ProviderContractAmendment();
                                        amendment.contractDocumentID = agreement.documentId;
                                        amendment.startDate = agreement.effectiveDate;
                                        amendment.endDate = agreement.cancelDate;
                                        amendment.medicalNecessityTypeID = agreement.medicalNecessityIndicator;
                                        amendment.providerContractAmendmentType = agreement.documentIdTypeCode;
                                        providerContractAmendmentList.add(amendment);
                                        system.debug('@@@ amendment :: ' + amendment );
                                    }
                                }
                            }
                        }
                        providerContractAmendments.providerContractAmendment = providerContractAmendmentList;

                    }
                }

                returnResponse.StatusCode = 200;
                returnResponse.isSuccess = true;
                returnResponse.providerContractAmendments = providerContractAmendments;
                system.debug('@@@ returnResponse.providerContractAmendments :: ' + returnResponse.providerContractAmendments );
            }
        } catch (Exception e) {
            system.debug('@@@ Exception:: ' + e.getMessage());
            returnResponse.StatusCode = 999;
            returnResponse.StatusMessage = e.getMessage();
            returnResponse.isSuccess = false;
        }

        return returnResponse;
    }

    public class ReturnResponse
    {
        @AuraEnabled public Boolean isSuccess{get;set;}
        @AuraEnabled public Integer statusCode{get;set;}
        @AuraEnabled public String statusMessage{get;set;}
        @AuraEnabled public ACET_CreateAuthRequest.ProviderContractAmendments providerContractAmendments{get;set;}

    }
}