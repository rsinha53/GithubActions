public class ACET_BenefitDetailsController {
    static final String BenefitAccumulations = ' - Benefit Accumulations';
    static final String covLevel = 'Coverage Level';
    static final String benefitName = 'Speech Therapy';
    static final String benefitServiceName = 'speechTherapy';

    @AuraEnabled
    public static List < sObject > fetchBenefitCodes(String searchKeyWord, String ObjectName, List<sObject> ExcludeitemsList) {
        String searchKey = '%' + searchKeyWord + '%';
        List < sObject > returnList = new List < sObject > ();
        String type = 'HIPAA';
        List<string> lstExcludeitems = new List<string>();
        for(sObject item : ExcludeitemsList ){
            lstExcludeitems.add(item.id);
        }

        // Create a Dynamic SOQL Query For Fetch Record List with LIMIT 5 and exclude already selected records
        // US1741780	Tech Story: Benefit and Coverage Benefit Limits - Query Update  
        // US3125177	Plan Benefits - Benefit Accumulation HIPPA Service Type Code UI - Updated the query  
        String sQuery =  'select id, Benefit_Code__c, Benefit_Code_Description_UI__c, Benefit_Code_Description_API__c from ' + ObjectName + ' where (Benefit_Code_Description_UI__c LIKE: searchKey OR Benefit_Code__c LIKE: searchKey) AND Benefit_Code_Type__c = :type order by Benefit_Code_Description_UI__c ASC';
        system.debug('sQuery>>> ' + sQuery);
        List < sObject > lstOfRecords = Database.query(sQuery);
        system.debug('-----In 1---->'+lstOfRecords);
        for (sObject obj: lstOfRecords) {
            returnList.add(obj);
        }
        system.debug('-----In 2---->'+returnList);
        return returnList;
    }

    // US3253559 - Sanka
    @AuraEnabled
    public static ACET_SAECalloutResult getTherapyAccumulations(String patienKey, String policyId){
        ACET_SAECalloutResult resp = new ACET_SAECalloutResult();
        try {
            ACET_BenefitTherapyWebService benObj = new ACET_BenefitTherapyWebService();
            ACETWSCalloutResult serverResp = benObj.getBenefit(patienKey, policyId);
            if(serverResp.Success){
                resp.isSuccess = true;
                resp.statusCode = 200;
                if(serverResp.Response != null){
                    List<ACET_CopayCoInsuranceResult.copayCoInsurance> servList = (List<ACET_CopayCoInsuranceResult.copayCoInsurance>) serverResp.Response;
                    for(Integer i=0;i<servList.size();i++){
                        ACET_CopayCoInsuranceResult.copayCoInsurance serv = servList.get(i);
                        ACET_AutoDocUtil.TableDetails servTable = new ACET_AutoDocUtil.TableDetails();
                        servTable.type = 'table';
                        servTable.showComponentName = false;
                        servTable.componentOrder = i+6;
                        servTable.componentName = serv.serviceName + ' ('+serv.serviceCode+')';
                        servTable.autodocHeaderName = serv.serviceName + ' ('+serv.serviceCode+')';
                        servTable.caseItemExtId = servTable.autodocHeaderName + BenefitAccumulations;
                        servTable.caseItemsEnabled = true;
                        if(serv.serviceName == benefitServiceName || serv.serviceName == benefitName){
                            servTable.tableHeaders = new List<String>{covLevel,'Rehab Limit','Rehab Remaining','Hab Limit','Hab Remaining','Post Cochlear Rehab Limit','Post Cochlear Rehab Remaining','Post Cochlear Hab Limit','Post Cochlear Hab Remaining'};
                        } else {
                            servTable.tableHeaders = new List<String>{covLevel,'Rehab Limit','Rehab Remaining','Hab Limit','Hab Remaining','MSK Remaining'};
                        }
                        List<ACET_AutoDocUtil.TableRow> tableRows = new List<ACET_AutoDocUtil.TableRow>();
                        if(serv.individual.tier1 != null){
                            tableRows.add(setRowData(serv.individual.tier1, 'Tier 1','1', servTable.caseItemExtId, serv.serviceName));
                        }
                        if(serv.individual.tier2 != null){
                            tableRows.add(setRowData(serv.individual.tier2, 'Tier 2','2', servTable.caseItemExtId, serv.serviceName));
                        }
                        if(serv.individual.tier1Preferred != null){
                            tableRows.add(setRowData(serv.individual.tier1Preferred, 'Tier 1 Preferred','3', servTable.caseItemExtId, serv.serviceName));
                        }
                        if(serv.individual.inNetwork != null){
                            tableRows.add(setRowData(serv.individual.inNetwork, 'INN','4', servTable.caseItemExtId, serv.serviceName));
                        }
                        if(serv.individual.outNetwork != null){
                            tableRows.add(setRowData(serv.individual.outNetwork, 'OON','5', servTable.caseItemExtId, serv.serviceName));
                        }
                        servTable.tableBody = tableRows;
                        serv.tableData = servTable;
                    }
                }
                resp.response = serverResp.Response;
            }else{
                resp.isSuccess = false;
                resp.statusCode = serverResp.statusCode;
                resp.message = serverResp.Message;
            }
        } catch (Exception e) {
            resp.isSuccess = false;
            resp.statusCode = 999;
            resp.message = 'Unexpected Error Occured';
        }
        return resp;
    }

    private static ACET_AutoDocUtil.TableRow setRowData(ACET_CopayCoInsuranceResult.InNetwork serv, String coverageLevel, String uIndex, String caseItemsExtId, String servName){
        ACET_AutoDocUtil.TableRow trINN = new ACET_AutoDocUtil.TableRow();
        trINN.checked = false;
        trINN.resolved = false;
        trINN.linkDisabled = false;
        trINN.checkBoxDisabled = false;
        trINN.uniqueKey = uIndex;
        trINN.caseItemsExtId = caseItemsExtId;
        List<ACET_AutoDocUtil.RowColumnData> rcINN = new List<ACET_AutoDocUtil.RowColumnData>();
        if(serv != null){
            // US3786086 - Thanish - 17th Aug 2021
            rcINN.add(ACET_AutoDocUtil.setRowColumnData('outputText', coverageLevel, true));
            rcINN.add(ACET_AutoDocUtil.setRowColumnData('outputText', serv.rehablimit, true));
            rcINN.add(ACET_AutoDocUtil.setRowColumnData('outputText', serv.rehabRemaining, true));
            rcINN.add(ACET_AutoDocUtil.setRowColumnData('outputText', serv.habLimit, true));
            rcINN.add(ACET_AutoDocUtil.setRowColumnData('outputText', serv.habRemaining, true));
            if(servName != benefitServiceName && servName != benefitName){
                rcINN.add(ACET_AutoDocUtil.setRowColumnData('outputText', String.isNotBlank(serv.mskRemaining) ? serv.mskRemaining : '--', true));
            }
            if(servName == benefitServiceName || servName == benefitName){
                rcINN.add(ACET_AutoDocUtil.setRowColumnData('outputText', serv.cochlearRehabLimit, true));
                rcINN.add(ACET_AutoDocUtil.setRowColumnData('outputText', serv.cochlearRehabRem, true));
                rcINN.add(ACET_AutoDocUtil.setRowColumnData('outputText', serv.cochlearHabLimit, true));
                rcINN.add(ACET_AutoDocUtil.setRowColumnData('outputText', serv.cochlearHabRem, true));
            }
        }else{
            rcINN.add(ACET_AutoDocUtil.setRowColumnData('outputText', coverageLevel, true));
            for(Integer i = 0; i < 5; i++) {
                rcINN.add(ACET_AutoDocUtil.setRowColumnData('outputText', '--', true));
            }
        }
        trINN.rowColumnData = rcINN;
        return trINN;
    }

    @AuraEnabled
    public static List<ACET_BenefitDetailsHelper.BenefitResponse> getBenefitInfo(String transactionId){
        return ACET_BenefitDetailsHelper.getBenefitSummary(transactionId);
    }

    // US3304569 - Thanish - 17th Mar 2021
    @AuraEnabled
    public static ACET_BenefitDetailsHelper.SearchBenefitWrapper getBenefitSearchResults(String transactionId, String searchPhrase){
        return ACET_BenefitDetailsHelper.searchBenefit(transactionId, searchPhrase);
    }
    // US3248728
    // US3304569 - Thanish - 17th Mar 2021
    @AuraEnabled
    public static ACET_SAECalloutResult getNonTherapy(NonTherapyRequest nonTherapyRequestParam, String sourceCode){
        ACET_SAECalloutResult calloutResults = new ACET_SAECalloutResult();
        ACET_AutoDocUtil.TableDetails nonTherapyTable = new ACET_AutoDocUtil.TableDetails();
        nonTherapyTable.type = 'table';
        nonTherapyTable.showComponentName = false;
        nonTherapyTable.componentOrder = 1;
        nonTherapyTable.componentName = '';
        nonTherapyTable.autodocHeaderName = 'Non-Therapy';
        nonTherapyTable.caseItemsEnabled = true;
        nonTherapyTable.caseItemExtId = nonTherapyTable.autodocHeaderName + BenefitAccumulations;
        nonTherapyTable.tableHeaders = new List<String>{covLevel,'Code/Description','Benefit Period','Type','Used $','Used Count'};
        List<ACET_AutoDocUtil.TableRow> tableRows = new List<ACET_AutoDocUtil.TableRow>();  
        try {
            if(!String.isBlank(sourceCode) && sourceCode.equals('CS')){
                //get userToken
                String userToken = (String) Cache.Session.get('local.TOPSProfileInfo.userToken');
                if (String.isBlank(userToken)) {
                    ACET_LoginFlowCtrl loginflow = new ACET_LoginFlowCtrl();
                    loginflow.validateTopsCredentials();
                    userToken = (String) Cache.Session.get('local.TOPSProfileInfo.userToken');
                }
                // policyNumber
                if (String.isNotBlank(nonTherapyRequestParam.policyNumber)){
                   if(nonTherapyRequestParam.policyNumber.length() == 5) {
                        nonTherapyRequestParam.policyNumber = '0' + (String) nonTherapyRequestParam.policyNumber;
                    }
                    if(nonTherapyRequestParam.policyNumber.length() > 6){
                        nonTherapyRequestParam.policyNumber = nonTherapyRequestParam.policyNumber.right(6);
                    }
                }
                // subscriberId 
                if (String.isNotBlank(nonTherapyRequestParam.subscriberId) && nonTherapyRequestParam.subscriberId.length() > 9) {
                    nonTherapyRequestParam.subscriberId = nonTherapyRequestParam.subscriberId.right(9);
                }
                nonTherapyRequestParam.subscriberId = 'S' + nonTherapyRequestParam.subscriberId;
                // dependentNumber
                if (String.isNotBlank(nonTherapyRequestParam.dependentNumber) && nonTherapyRequestParam.dependentNumber.length() > 2) {
                    nonTherapyRequestParam.dependentNumber = nonTherapyRequestParam.dependentNumber.right(2);
                }
                nonTherapyRequestParam.securityToken = userToken;
                System.debug('@@@ ACET_BenefitDetailsController.getNonTherapy: nonTherapyRequestParam: '+ JSON.serialize(nonTherapyRequestParam));
                // Calling Service
                // US3304569 - Thanish - 17th Mar 2021
                calloutResults = ACET_BenefitNonTherapyWebService.invokeService(nonTherapyRequestParam.securityToken, nonTherapyRequestParam.policyNumber,nonTherapyRequestParam.subscriberId, nonTherapyRequestParam.dependentNumber, nonTherapyRequestParam.planYearStartdate );
                if(calloutResults.isSuccess){
                    if(calloutResults.statusCode == 200){
                        ACET_BenefitNonTherapyWebService.AccumulationsWrapper accumulationsWrapper = (ACET_BenefitNonTherapyWebService.AccumulationsWrapper) calloutResults.response;
                        System.debug('AccumulationWrapper: '+JSON.serialize(accumulationsWrapper));
                        for(ACET_BenefitNonTherapyWebService.NonTherapyWrapper nonTherapyWrapper : accumulationsWrapper.nonTherapy){
                            ACET_AutoDocUtil.TableRow tableRow = new ACET_AutoDocUtil.TableRow();
                            tableRow.checked = false;
                            tableRow.checkBoxDisabled = false;
                            tableRow.caseItemsExtId = nonTherapyTable.autodocHeaderName + BenefitAccumulations;
                            tableRow.rowColumnData = new List<ACET_AutoDocUtil.RowColumnData>();
                            tableRow.rowColumnData.add(ACET_AutoDocUtil.setRowColumnData('outputText', 'INN/OON', true));

                            string serviceCategoryDescription = nonTherapyWrapper.serviceCategoryDescription;
                            string serviceCategory = nonTherapyWrapper.serviceCategory;
                            ACET_AutoDocUtil.RowColumnData rowColumnData1 =  ACET_AutoDocUtil.setRowColumnData('outputText', serviceCategory+'/'+serviceCategoryDescription, true);
                            rowColumnData1.fieldLabel='Code/Description';
                            tableRow.rowColumnData.add(rowColumnData1);

                            String startDate = SAEUtils.formatDate(nonTherapyWrapper.planYearStartDate);
                            String endDate = SAEUtils.formatDate(nonTherapyWrapper.planYearEndDate);
                            String benefitPeriod = String.isNotBlank(startDate)? startDate : '--';
                            benefitPeriod = benefitPeriod + ' - ';
                            benefitPeriod = benefitPeriod + (String.isNotBlank(endDate)? endDate : '--');
                            tableRow.rowColumnData.add(ACET_AutoDocUtil.setRowColumnData('outputText', String.isNotBlank(benefitPeriod) ? benefitPeriod : '--', true));
                            tableRow.rowColumnData.add(ACET_AutoDocUtil.setRowColumnData('outputText', String.isNotBlank(nonTherapyWrapper.unitIndicatorDescription) ? nonTherapyWrapper.unitIndicatorDescription : '--', true));
                            tableRow.rowColumnData.add(ACET_AutoDocUtil.setRowColumnData('Currency', String.isNotBlank(nonTherapyWrapper.totalYtdPaidAmount) ? nonTherapyWrapper.totalYtdPaidAmount : '--', true));
                            tableRow.rowColumnData.add(ACET_AutoDocUtil.setRowColumnData('outputText', String.isNotBlank(nonTherapyWrapper.totalYtdPaidCount) ? nonTherapyWrapper.totalYtdPaidCount : '--', true));
                            nonTherapyTable.tableBody.add(tableRow);
                        }
                    }
                }
                // Creating a No Records Found Table for all the negative cases - isSuccess - False and Status code not 200
                if(nonTherapyTable.tableBody.size() == 0){
                    ACET_AutoDocUtil.TableRow tableRow = new ACET_AutoDocUtil.TableRow();
                    tableRow.checked = false;
        tableRow.checkBoxDisabled = false;
                    tableRow.caseItemsExtId = 'No Records Found';
                    tableRow.rowColumnData = new List<ACET_AutoDocUtil.RowColumnData>();
                    tableRow.rowColumnData.add(ACET_AutoDocUtil.setRowColumnData('noRecords', 'No Records Found', 'noRecords'));
                    nonTherapyTable.tableBody.add(tableRow);
                }
            }else{
                ACET_AutoDocUtil.TableRow tableRow = new ACET_AutoDocUtil.TableRow();
                tableRow.checked = false;
                tableRow.checkBoxDisabled = false;
                tableRow.caseItemsExtId = 'No Records Found';
                tableRow.rowColumnData = new List<ACET_AutoDocUtil.RowColumnData>();
                tableRow.rowColumnData.add(ACET_AutoDocUtil.setRowColumnData('noRecords', 'No Records Found', 'noRecords'));
                nonTherapyTable.tableBody.add(tableRow);
            }
        }catch(Exception e){
            system.debug('@@@ ACET_BenefitDetailsController.getNonTherapy()  '+e.getStackTraceString());
            ACET_AutoDocUtil.TableRow tableRow = new ACET_AutoDocUtil.TableRow();
            tableRow.checked = false;
            tableRow.checkBoxDisabled = false;
            tableRow.caseItemsExtId = 'No Records Found';
            tableRow.rowColumnData = new List<ACET_AutoDocUtil.RowColumnData>();
            tableRow.rowColumnData.add(ACET_AutoDocUtil.setRowColumnData('noRecords', 'No Records Found', 'noRecords'));
            nonTherapyTable.tableBody.add(tableRow);
            // US3304569 - Thanish - 17th Mar 2021
            calloutResults.statusCode=999;
        }
        calloutResults.response=nonTherapyTable;
        return calloutResults;
    }
    public class NonTherapyRequest {
        @AuraEnabled public String securityToken {get;set;}
        @AuraEnabled public String policyNumber {get;set;}
        @AuraEnabled public String subscriberId {get;set;}
        @AuraEnabled public String dependentNumber {get;set;}
        @AuraEnabled public String planYearStartDate {get;set;}
    }
}