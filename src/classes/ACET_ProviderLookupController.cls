public with sharing class ACET_ProviderLookupController {
    public class SearchResultWrapper {
        @Auraenabled
        public string service;
        public SearchResultWrapper(String service) {
            this.service = service;
        }
    }

    public class PolicyDetails {
        @AuraEnabled public String marketType {get;set;}
        @AuraEnabled public String marketSite {get;set;}
        @AuraEnabled public String insTypeCode {get;set;}
        @AuraEnabled public String cosmosDiv {get;set;}
        @AuraEnabled public String cosmosPanelNbr {get;set;}
        @AuraEnabled public String coverageStartDate {get;set;}
        @AuraEnabled public String coverageEndDate{get;set;}
        @AuraEnabled public String firstSrvcDt{get;set;}
    }

    @AuraEnabled
    public static ACET_ProviderStatusCtrl.ACET_MAndRProviderStatusWrapper getMAndRProviderStatus(String providerId, String taxId, String addressId, PolicyDetails pd,String provDiv){
        string contractNum = '';
        ACET_ProviderStatusCtrl.ACET_MAndRProviderStatusWrapper providerWrapper = ACET_ProviderStatusCtrl.getMAndRProviderStatus(providerId,taxId,addressId,'','',pd.coverageStartDate,pd.coverageEndDate,provDiv);
        if(providerWrapper.contractResponse != null){
            for(ACET_MAndRContractsResponse.Medicareandretirement p : providerWrapper.contractResponse.medicareandretirement){
                if(((p.cos_canc_date >= pd.firstSrvcDt && p.cos_eff_dt <= pd.firstSrvcDt)) && (p.cos_div == pd.cosmosDiv ) && (p.cos_panel_num == pd.cosmosPanelNbr)){
                    contractNum = p.cos_contract_num;
                    break;
                }
            }
        }
        providerWrapper.contractNum = contractNum;
        return providerWrapper;
    }
     @AuraEnabled
    public static ACET_ProviderStatusCtrl.ACET_NetworkKeyStatusWrapper getNetworkKeyStatus(String subscriberId, String policyNumber, String sourceCode, String coverageLevel, String coverageStartDate, Boolean isTermedPolicy){ // US3308070 - Thanish - 2nd Mar 2021
      return ACET_ProviderStatusCtrl.getNetworkKeyStatus(subscriberId,policyNumber,sourceCode,coverageLevel,coverageStartDate,isTermedPolicy);
      }
    @AuraEnabled
       public static ACET_ProviderStatusCtrl.ACET_EAndIProviderStatusWrapper getEAndIProviderStatusNew(String providerId, String taxId, String addressSeq, PolicyDetails pd, String networkKey,String ipaValue){
       return ACET_ProviderStatusCtrl.getEAndIProviderStatusNew(providerId,taxId,addressSeq,pd.marketType,pd.marketSite,pd.insTypeCode,networkKey,ipaValue);
       }
    @AuraEnabled
    public static SearchResultWrapper getLookupData(String taxId, String npi, String providerId, String providerType, String speciality, String lastNameOrFacility,
        String firstName, String state, String zipCode, String radius, String acceptNewPatients, String prefferedLab, String inactiveProvs,
        String freestandingFac, String cosmosDiv, String cosmosPanelNum, String tciTableNum, String lineofBusiness, String memType,
        Integer start, Integer count, Boolean filtered, String benefitLevel, String marketSite, String entityType, String sharedArrangement,
        String obligorID, String productCode, String marketType) {
        String service;
        ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();

        ACET_ProviderLookupService lookupService = new ACET_ProviderLookupService();

        lookupService.init(taxId, npi, providerId, providerType, speciality, lastNameOrFacility,
            firstName, state, zipCode, radius, acceptNewPatients, prefferedLab, inactiveProvs,
            freestandingFac, cosmosDiv, cosmosPanelNum, tciTableNum, lineofBusiness, memType, start, count, filtered, benefitLevel, marketSite, entityType, sharedArrangement, obligorID, productCode, marketType);

        service = JSON.serialize(lookupService).replace('\'', '&#x27;');
        service = service.replace('&#x27;', '\'');

        return new SearchResultWrapper(JSON.serialize(service));
    }

    // changed Signature - Sanka
    public static ACETWSCalloutResult getLookupResults(String taxId,
        String npi,
        String providerId,
        String providerType,
        String speciality,
        String lastNameOrFacility,
        String firstName,
        String state,
        String zipCode,
        String radius,
        String acceptNewPatients,
        String prefferedLab,
        String inactiveProvs,
        String freestandingFac,
        String cosmosDiv,
        String cosmosPanelNum,
        String tciTableNum,
        String lineofBusiness,
        String memType,
        Integer start,
        Integer count,
        Boolean filtered,
        String benefitLevel,
        String marketSite,
        String entityType,
        String sharedArrangement,
        String obligorID,
        String productCode,
        String marketType) {
        ACET_ProviderLookupService lookupService = new ACET_ProviderLookupService();
        lookupService.init(taxId, npi, providerId, providerType, speciality, lastNameOrFacility,
            firstName, state, zipCode, radius, acceptNewPatients, prefferedLab, inactiveProvs,
            freestandingFac, cosmosDiv, cosmosPanelNum, tciTableNum, lineofBusiness, memType, 1, 50, filtered, benefitLevel, marketSite, entityType, sharedArrangement, obligorID, productCode, marketType);


        ACETWSCalloutResult results = lookupService.queryPaginatedData(start, 50, 0);
        // List<ACET_ProviderLookupService.ProviderLookupResultsWrapper> returnWrapper = (List<ACET_ProviderLookupService.ProviderLookupResultsWrapper>) results.Response;
        // return returnWrapper;
        return results;
    }

    @AuraEnabled
    public static ACET_AutoDocUtil.TableDetails getProviderLookupResults(String taxId, String npi, String providerId, String providerType, String speciality, String lastNameOrFacility,
        String firstName, String state, String zipCode, String radius, String acceptNewPatients, String prefferedLab, String inactiveProvs,
        String freestandingFac, String cosmosDiv, String cosmosPanelNum, String tciTableNum, String lineofBusiness, String memType,
        Integer start, Integer count, Boolean filtered, String benefitLevel, String marketSite, String entityType, String sharedArrangement,
        String obligorID, String productCode, String marketType, Boolean isDetailOpened, String sourceCode, CoverageDateWrapper coverageDates) {
        ACET_AutoDocUtil.TableDetails lookupTable = new ACET_AutoDocUtil.TableDetails();
        // US3452064
        String providerDiv='';
        try {
            // US3452064: Provider Lookup M&R Div Update- Krish - 22th April 2021 - Start
            /*if(sourceCode !=null && String.isNotBlank(sourceCode) && sourceCode == 'CO' && coverageDates != null && String.isNotBlank(coverageDates.coverageStartDate) && String.isNotBlank(coverageDates.coverageEndDate) && String.isNotBlank(cosmosDiv)){
                providerDiv = ACET_ProviderStatusCtrl.convertCosmosDiv(cosmosDiv, coverageDates.coverageStartDate, coverageDates.coverageEndDate);//US3574032
                if(String.isNotBlank(providerDiv)){
                    cosmosDiv = providerDiv;
                }
            }*/
            //US3574032
            cosmosDiv = (String.isNotBlank(sourceCode) && sourceCode == 'CO' && coverageDates!= null && string.isNotBlank(coverageDates.providerDiv)) ? coverageDates.providerDiv : '';
            System.debug('@@ ACET_ProviderLookupController.getProviderLookupResults(): cosmosDiv: '+cosmosDiv);
            // US3452064: Provider Lookup M&R Div Update- Krish - 22th April 2021 - End
            ACETWSCalloutResult resultsAll = ACET_ProviderLookupController.getLookupResults(taxId, npi, providerId, providerType, speciality, lastNameOrFacility,
                firstName, state, zipCode, radius, acceptNewPatients, prefferedLab, inactiveProvs,
                freestandingFac, cosmosDiv, cosmosPanelNum, tciTableNum, lineofBusiness, memType, start, count, filtered, benefitLevel, marketSite, entityType, sharedArrangement, obligorID, productCode, marketType);
            List < ACET_ProviderLookupService.ProviderLookupResultsWrapper > resultsData = (List < ACET_ProviderLookupService.ProviderLookupResultsWrapper > ) resultsAll.Response;

            lookupTable.type = 'table';
            lookupTable.showComponentName = false;
            lookupTable.componentOrder = 1;
            lookupTable.caseItemsEnabled = true;
            lookupTable.componentName = 'Provider Lookup Results';
            lookupTable.autodocHeaderName = 'Provider Lookup Results';
            lookupTable.statusCode = resultsAll.statusCode;
            lookupTable.errorMessage = resultsAll.Message;
            lookupTable.tableHeaders = new List < String > {
                'PROVIDER ID/MPIN',
                'STATUS',
                'TIER/TIER TYPE',
                'UHPD',
                'PROVIDER NAME',
                'MILES',
                'ADDRESS',
                'ADDRESS TYPE',
                'TAX ID',
                'NPI'
            }; //US2990280 - Sravan
            List < ACET_AutoDocUtil.TableRow > tableRows = new List < ACET_AutoDocUtil.TableRow > ();

            if (lookupTable != null) {
                if (resultsData != null) {
                    for (ACET_ProviderLookupService.ProviderLookupResultsWrapper results: resultsData) {
                        ACET_AutoDocUtil.TableRow tableRow = new ACET_AutoDocUtil.TableRow();
                        tableRow.checked = false;
                        tableRow.resolved = false;
                        tableRow.linkDisabled = false;
                        tableRow.checkBoxDisabled = false;
                        // US3429736 - Case Item relationship change
                        // tableRow.caseItemsExtId = results.providerId;
                        String fullCaseExt = results.providerId + '-' + results.address;
                        tableRow.caseItemsExtId = fullCaseExt.length() >= 255 ? fullCaseExt.substring(0, 254) : fullCaseExt;

                        tableRow.uniqueKey = results.addressId + results.providerId;
                        //US2954656	TECH - Submit the Authorization Summary & Confirmation Page: Provider Details - Integration - Sarma - 13/10/2010
                        tableRow.createSRNProviderDetails = results.createSRNProviderDetails;
                        tableRow.rowDetails = results.taxId + ',' + results.providerId + ',' + results.addressId + ',' + results.addressSequence + ',' + results.providerName + ',' + results.isPhysician; //Don't change this order
                        List < ACET_AutoDocUtil.RowColumnData > rowColumns = new List < ACET_AutoDocUtil.RowColumnData > ();
                        // US2808569 - Thanish - 27th Oct 2020
                        rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', results.providerId, true));
                        rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', results.benefitLevel, true));
                        rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', results.tierValue, true));
                        rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', results.uhpd, true));
                        rowColumns.add(ACET_AutoDocUtil.setRowColumnData('link', results.providerName, true));
                        rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', results.miles, true));
                        rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', results.address, true)); // Don't remove or change this order, address column should be 7th postion in rowColumnData list and it is used as part of US3074131
                        rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', results.addressType, true));
                        rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', results.taxId, true));
                        rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', results.npi, true));
                        tableRow.rowColumnData = rowColumns;
                        tableRows.add(tableRow);
                    }
                } else {
                    if (!isDetailOpened) {
                        ACET_AutoDocUtil.TableRow tableRow = new ACET_AutoDocUtil.TableRow();
                        // US3192316 - Thanish - 27th Jan 2021
                        tableRow.checked = true;
                        tableRow.resolved = true;
                        tableRow.isResolvedDisabled = true;
                        //tableRow.uniqueKey = 'No Records Found';
                        List < ACET_AutoDocUtil.RowColumnData > rowColumns = new List < ACET_AutoDocUtil.RowColumnData > ();
                        // US2808569 - Thanish - 27th Oct 2020
                        rowColumns.add(ACET_AutoDocUtil.setRowColumnData('noRecords', 'No Matching Provider Lookup Results Found', true));
                        tableRow.rowColumnData = rowColumns;
                        tableRow.caseItemsExtId = 'No Matching Provider Lookup Results Found';
                        tableRows.add(tableRow);
                        lookupTable.selectedRows.add(tableRow); // US3192316 - Thanish - 27th Jan 2021
                    }
                }
            }

            lookupTable.tableBody = tableRows;

            // Setting Pagination
            Integer startNo = (((Integer.valueOf(resultsAll.pageNumber) - 1) * 50) + 1);
            Integer endNo = (Integer.valueOf(resultsAll.pageNumber) * 50);
            Integer totalRecords = Integer.valueOf(resultsAll.totalCount);
            Integer noOfPages = (Integer) Math.ceil((Decimal) totalRecords / 50);

            // Pagination
            Integer resultsSize = resultsData != null ? resultsData.size() : 0;
            ACET_AutoDocUtil.PaginationInfo p_info = ACET_AutoDocUtil.processPaginationData(startNo, resultsSize, totalRecords, 50);
            lookupTable.startNumber = (startNo < 0) ? 0 : startNo;
            lookupTable.endNumber = p_info.endNo;
            lookupTable.recordCount = p_info.recordCount;
            lookupTable.noOfPages = p_info.pageSize;
        } catch (exception e) {
            system.debug('exce::' + e.getStackTraceString());
            lookupTable.statusCode = 999;
            lookupTable.errorMessage = 'Unexpected Error Occurred in the Provider Lookup Results card. Please try again. If problem persists please contact the help desk.';
        }
        return lookupTable;
    }

    @AuraEnabled
    public static string getProviderDetaiils(String providerId, String taxId, String adrseq) {
        SAE_ProviderSnapshotWrapper.ReturnResponse provData = SAE_ProviderSnapshotController.getProviderData(providerId, taxId, adrseq);
        return JSON.serialize(provData);
    }

    // US3452064: Provider Lookup M&R Div Update - Krish
    public class CoverageDateWrapper {
        @Auraenabled public string coverageStartDate {get;set;}
        @Auraenabled public string coverageEndDate {get;set;}
        @Auraenabled public string providerDiv {get;set;} //US3574032
    }
}