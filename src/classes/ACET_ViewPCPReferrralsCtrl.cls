public without sharing class ACET_ViewPCPReferrralsCtrl {

    @AuraEnabled
    public static ACET_SAECalloutResult getPolicyInfo(ACET_ViewPCPReferralsService.ACET_ViewPCPReferralsRequest inputRequest){
        system.debug('==inputRequest is='+inputRequest);
        ACET_SAECalloutResult calloutResult = new ACET_SAECalloutResult();
        try{
            ACET_ViewPCPReferralsService service = new ACET_ViewPCPReferralsService();
            ACET_SAECalloutResult viewPCPReferralscalloutResult =service.getPolicesInfo(inputRequest);
            System.debug('@@ ACET_ViewPCPRefeeralsCtrl: getPolicyInfo: viewPCPReferralscalloutResult: ' + viewPCPReferralscalloutResult);
            calloutResult.isSuccess = viewPCPReferralscalloutResult.isSuccess;
            calloutResult.message = String.isNotBlank(viewPCPReferralscalloutResult.Message) ? viewPCPReferralscalloutResult.Message : '';
            //calloutResult.response = viewPCPReferralscalloutResult.Response;
            calloutResult.statusCode = viewPCPReferralscalloutResult.statusCode;
            List<uiViewPCPResponseWrapper> lstuiViewPCPResponse = new List<uiViewPCPResponseWrapper>();
            if(viewPCPReferralscalloutResult.statusCode == 200){
                ACET_ViewPCPReferralsResponse responseData = ACET_ViewPCPReferralsResponse.parse(JSON.serialize(viewPCPReferralscalloutResult.Response));
                if(responseData != null && responseData.referralStatusResponse != null && !responseData.referralStatusResponse.isEmpty()){
                    for(ACET_ViewPCPReferralsResponse.referralStatusResponseWrapper each: responseData.referralStatusResponse){
                        uiViewPCPResponseWrapper referral = new uiViewPCPResponseWrapper();
                        referral.referralId = string.isNotBlank(each.referralId) ? each.referralId : '';
                        referral.intakeORApporvalDate = string.isNotBlank(each.startDate) ? (each.startDate.substring(5,7)+'/'+each.startDate.substring(8,10)+'/'+each.startDate.substring(0,4)) : '';
                        referral.LastUpdated = string.isNotBlank(each.endDate) ? (each.endDate.substring(5,7)+'/'+each.endDate.substring(8,10)+'/'+each.endDate.substring(0,4)) : '';
                        referral.serviceDates = (string.isNotBlank(referral.intakeORApporvalDate) || string.isNotBlank(referral.LastUpdated)) ?
                            (referral.intakeORApporvalDate + ' - '  +(referral.LastUpdated)) : '';
                         referral.dxCodes =  (string.isNotBlank(each.firstDiagnosisCode) ? each.firstDiagnosisCode : '') +
                             ((string.isNotBlank(each.firstDiagnosisCode) || string.isNotBlank(each.secondDiagnosisCode)) ? ', ' : '') +
                             (string.isNotBlank(each.secondDiagnosisCode) ? each.secondDiagnosisCode : '');
                        referral.referByProvider = (string.isNotBlank(each.referringProvider) ? each.referringProvider : '') + '/'+
                            (string.isNotBlank(each.referringProviderTin) ? each.referringProviderTin : '');
                        referral.referredToProvider = (string.isNotBlank(each.referredToProvider) ? each.referredToProvider : '') + '/'+
                             (string.isNotBlank(each.referredToProviderTin) ? each.referredToProviderTin : '');
                        referral.allowed = string.isNotBlank(each.numberOfVisits) ? each.numberOfVisits : '';
                        referral.remaining = string.isNotBlank(each.remainingVisits) ? each.remainingVisits : '';

                        // US2917434, US3208169
                        referral.searchParamsByProvider = getSearchParams(each.referringProviderTin, each.referringProvider);
                        referral.searchParamsToProvider = getSearchParams(each.referredToProviderTin, each.referredToProvider);

                    	lstuiViewPCPResponse.add(referral);
                    }
                }
                //if(!lstuiViewPCPResponse.isEmpty())
                calloutResult.response = lstuiViewPCPResponse;
            }
        }
        catch(Exception e){
            system.debug(e.getStackTraceString());
            calloutResult.MessageSeverity = ApexPages.Severity.ERROR;
            calloutResult.isSuccess = false;
            calloutResult.Message = 'Web Service or External System is temporarily unavailable.';
            calloutResult.statusCode=999;
        }
        return calloutResult;
    }
    
    private static SearchParams getSearchParams(String tin, String provName){
        SearchParams searchParams = new SearchParams();
        try {
            if(String.isNotBlank(provName)){
                List<String> splitNames = provName.split(' ');
                searchParams.lName = splitNames.get(0).removeEnd(',');
                searchParams.fName = splitNames.get(1);
            }
            if(String.isNotBlank(tin)){
                searchParams.provTin = tin;
            }
        } catch (Exception e) {
            System.debug(e.getMessage());
        }

        return searchParams;
    }

    public class uiViewPCPResponseWrapper{
        @AuraEnabled public String referralId;	
        @AuraEnabled public String serviceDates;	
        @AuraEnabled public String dxCodes;
        @AuraEnabled public String referByProvider;	
        @AuraEnabled public String referredToProvider;	
        @AuraEnabled public String allowed;	
        @AuraEnabled public String remaining;	
        @AuraEnabled public String intakeORApporvalDate;	
        @AuraEnabled public String LastUpdated;	
        // US2917434
        @AuraEnabled public SearchParams searchParamsByProvider;
        @AuraEnabled public SearchParams searchParamsToProvider;
    }

    public class SearchParams{
        // US2917434
        @AuraEnabled public String lName;
        @AuraEnabled public String fName;
        @AuraEnabled public String provTin;

        public SearchParams(){
            this.lName = '';
            this.fName = '';
            this.provTin = '';
        }
    }

    @AuraEnabled
    public static List<SAE_Referral_Entry_Reason__mdt> getSAEReferralEntryReasonCodes(string sourceCode){
         return [SELECT Id, DeveloperName, MasterLabel, Label, Source_Code__c, Order__c ,QualifiedApiName, Field_Option__c, Picklist_UI_Value__c, Note__c
            FROM SAE_Referral_Entry_Reason__mdt where Source_Code__c= :sourceCode order by Order__c asc];
    }

    @AuraEnabled
    public static List<ACET_ReferralDisplayMessages__mdt> getACETReferralDisplayMessages(string sourceCode, string isExchangePlanorPcpOnFile, string reason){
        String strReason = (String.isNotBlank(reason)? '%'+reason+'%': '');
        System.debug(' Reason ' + strReason);
        List<ACET_ReferralDisplayMessages__mdt> lstData = new List<ACET_ReferralDisplayMessages__mdt>();
        if(String.isNotBlank(reason)) {
            lstData = [SELECT Id, DeveloperName, MasterLabel, Label, End_Date__c,
                            End_Date_Notes__c ,IsPcpOnFile_Exchange_Policy__c, No_of_Visits__c,
                            No_of_Visits_Notes__c, Source_Code__c, Error_Message__c
                        FROM ACET_ReferralDisplayMessages__mdt where Source_Code__c= :sourceCode AND IsPcpOnFile_Exchange_Policy__c = :isExchangePlanorPcpOnFile AND Selected_Reason_For_Referral__c LIKE :strReason ];
        } else {
            lstData = [SELECT Id, DeveloperName, MasterLabel, Label, End_Date__c,
                            End_Date_Notes__c ,IsPcpOnFile_Exchange_Policy__c, No_of_Visits__c,
                            No_of_Visits_Notes__c, Source_Code__c, Error_Message__c
                        FROM ACET_ReferralDisplayMessages__mdt where Source_Code__c= :sourceCode AND IsPcpOnFile_Exchange_Policy__c = :isExchangePlanorPcpOnFile];
        }
        return lstData;
    }
	@AuraEnabled
    public static ACET_AutoDocUtil.TableDetails getclaimProviderLookupResults(String taxId, String npi, String providerId, String providerType, String speciality, String lastNameOrFacility,
        String firstName, String state, String zipCode, String radius, String acceptNewPatients, String prefferedLab, String inactiveProvs,
        String freestandingFac, String cosmosDiv, String cosmosPanelNum, String tciTableNum, String lineofBusiness, String memType,
        Integer start, Integer count, Boolean filtered, String benefitLevel, String marketSite, String entityType, String sharedArrangement,
                                                                         String obligorID, String productCode, String marketType, Boolean isDetailOpened, String sourceCode) {
                                                                             
    ACET_AutoDocUtil.TableDetails lookupTable = new ACET_AutoDocUtil.TableDetails();
    lookupTable = ACET_ProviderLookupController.getProviderLookupResults(taxId,npi , providerId, providerType,speciality,lastNameOrFacility,firstName,state,zipCode,radius,acceptNewPatients,
                                                                        prefferedLab,inactiveProvs,freestandingFac,cosmosDiv,cosmosPanelNum,tciTableNum,lineofBusiness,memType,
                                                                        start,count,filtered,benefitLevel,marketSite,entityType,sharedArrangement,
                                                                        obligorID,productCode,marketType,isDetailOpened,sourceCode,null);                                                                         
    return lookupTable;
    
    
    }																																																										


}