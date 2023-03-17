/*
* Created By : Madhura Priyadarshana
* Created Date : 08/28/2020
* Description : Perform financial overview related services
*/ 
public without sharing class ADBFinancialOverViewWebService {
    final static Set<String> accountTypes = new Set<String>{'HSA', 'HRA', 'FSA', 'HIA', 'MRA', 'FSALIM', 'FSADC', 'FSALP', 'FSAHC', 'RMSA', 'HRAAP', 'HCSA'};
        // Actual Call for Security access API: US2923041 - sunil vennam
        public static List<String> getUserAccessDetails(String userId){
            List<String> respWrapper = new List<String>();
            try{
                ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework('ADBUserSecurityAccessAPIDetails','',null);
                wsCallOutFW.endpointExtraPath = userId +'/groups';
                HttpResponse response = wsCallOutFW.getResponse();  
                system.debug('response Security access API'+response.getBody());
                system.debug('response Security access API status code'+response.getStatusCode());
                // Checking the status code is success
                if(response.getStatusCode() == 200) {
                    respWrapper = (List<String>) System.JSON.deserialize(response.getBody(), List<String>.class);
                } 
                else{
                    system.debug('Security access API Response code && Response body if not 200 ::' + response.getStatusCode() +'-'+ response.getBody());
                }
            }catch(Exception e){
                system.debug('Security access API Exception ::' + e.getMessage());
            }
            return respWrapper;
        }    
    public static Map<String,Object> getFinancialOverview(String memberId, String fName, String lName, String planNumber, String birthdate,boolean hsaaccess, String ssn) {
        Map<String,Object> resultMap = new Map<String,Object>();
        ADBFinancialOverViewResponseWrapper wrapper;
        ADBFinancialOverviewUIWrapper uiWrapper;
        ADBContributionsUIWrapper contributionsWrapper;
        ADBTransactionsWrapper transWrapper;
        try{
            // generating the request body
            List<String> values ;
            if(String.isBlank(ssn))
            	values = new List<String>{memberId, fName, lName, planNumber, birthdate, '', memberId};
			else
                values = new List<String>{memberId, fName, lName, planNumber, birthdate, ssn, ''};

                StaticResource requestTemplate = [SELECT body FROM StaticResource WHERE Name = 'ADBFinancialAPIRequest'];	//	getting the request template
            String strBody = requestTemplate.Body.toString();
            System.debug('strBody : ' + strBody);
            String body = String.format(strBody, values).replaceAll('~', '{');	// replacing the template values with actuals
            System.debug('template after replacing with actual values : ' + body);
            // Hit the service 
            ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework('ADBFinancialOverView', body, null);
            HttpResponse response = wsCallOutFW.getResponse();

        //   if (fName.toLowerCase().equals('bethel')) {
        //    String memberMockData = 'ADBFinancialMockresponse';
        //    StaticResource mock = [SELECT body FROM StaticResource WHERE Name =: memberMockData];
        //    response.setBody(mock.body.toString());
        //    response.setStatusCode(200);
        // }
        // if (fName.toLowerCase().equals('evelyn')) {
        //        String memberMockData = 'ADBFinancialMockresponseEvelyn';
        //        StaticResource mock = [SELECT body FROM StaticResource WHERE Name =: memberMockData];
        //        response.setBody(mock.body.toString());
        //        response.setStatusCode(200);
        //     }

            // StaticResource mock = [SELECT body FROM StaticResource WHERE Name = 'ADBFinancialMockresponse'];
            // response.setBody(mock.body.toString());
            // response.setStatusCode(200);

            system.debug('Financial Overview reponse : '+response.getBody());
            // Checking the status code is success
            if(response.getStatusCode() == 200) {
                system.debug('response code 200');
                String resp = response.getBody();
                resp = resp.replaceAll('"desc"', '"desc_Z"').replaceAll('"type"', '"type_Z"');
                wrapper = (ADBFinancialOverViewResponseWrapper) JSON.deserialize(resp, ADBFinancialOverViewResponseWrapper.class);
                uiWrapper = prepareDeductiblesAndOOPMax(wrapper);
                resultMap.put('deductiblesWrapper',uiWrapper);
                contributionsWrapper = prepareContributions(wrapper,hsaaccess);
                resultMap.put('contributionsWrapper',contributionsWrapper);
                //Added Nadeem : 16/09/2020
                transWrapper = prepareTransactions(wrapper);
                System.debug('Transaction Wrapper Mapped Values :: '+transWrapper);
                resultMap.put('transactionWrapper',transWrapper);
            } 
            else{
                system.debug('Financial Overview API is failing ::' + response.getStatusCode() +'-'+ response.getBody());
            }
        } catch(Exception ex)    {
            System.debug('ERROR at ADBFinancialOverViewWebService.getFinancialOverview : ' + ex.getMessage() + ' : ' + ex.getStackTraceString());
        }
        
        return resultMap;            
    }
    //	Deductibles and OOP Max
    private static ADBFinancialOverviewUIWrapper prepareDeductiblesAndOOPMax(ADBFinancialOverViewResponseWrapper response) {
        ADBFinancialOverviewUIWrapper deductibles = new ADBFinancialOverviewUIWrapper();
        ADBFinancialOverviewUIWrapper.Deductible deductible = new ADBFinancialOverviewUIWrapper.Deductible();        
        ADBFinancialOverviewUIWrapper.DeductibleIndividual individual = new ADBFinancialOverviewUIWrapper.DeductibleIndividual();
        ADBFinancialOverviewUIWrapper.DeductibleFamily family = new ADBFinancialOverviewUIWrapper.DeductibleFamily();
        ADBFinancialOverviewUIWrapper.CopayMax copay = new ADBFinancialOverviewUIWrapper.CopayMax();
        ADBFinancialOverviewUIWrapper.CopayIndividual copayIndividual = new ADBFinancialOverviewUIWrapper.CopayIndividual();
        ADBFinancialOverviewUIWrapper.CopayFamily copayFamily = new ADBFinancialOverviewUIWrapper.CopayFamily();
        ADBFinancialOverviewUIWrapper.OOPMaximums oopMaximum = new ADBFinancialOverviewUIWrapper.OOPMaximums();
        ADBFinancialOverviewUIWrapper.OOPMaximumsIndividual oopMaxIndividual = new ADBFinancialOverviewUIWrapper.OOPMaximumsIndividual();
        ADBFinancialOverviewUIWrapper.OOPMaximumsFamily oopMaxFamily = new ADBFinancialOverviewUIWrapper.OOPMaximumsFamily();
        try {
            if(response != null && response.data != null && response.data.planDetail != null &&
               response.data.planDetail.planDetailsResult != null && response.data.planDetail.planDetailsResult.member != null &&
               !response.data.planDetail.planDetailsResult.member.isEmpty() && response.data.planDetail.planDetailsResult.member[0] != null && response.data.planDetail.planDetailsResult.member[0].eligibility != null &&
               response.data.planDetail.planDetailsResult.member[0].eligibility.benefitSet != null &&
               !response.data.planDetail.planDetailsResult.member[0].eligibility.benefitSet.isEmpty() && response.data.planDetail.planDetailsResult.member[0].eligibility.benefitSet[0] != null &&
               response.data.planDetail.planDetailsResult.member[0].eligibility.benefitSet[0].planBenefitSet != null &&
               !response.data.planDetail.planDetailsResult.member[0].eligibility.benefitSet[0].planBenefitSet.isEmpty() &&
               response.data.planDetail.planDetailsResult.member[0].eligibility.benefitSet[0].planBenefitSet[0] != null &&
               response.data.planDetail.planDetailsResult.member[0].eligibility.benefitSet[0].planBenefitSet[0].planBenefitLevel != null) {
                   //	Assumption : all the array nodes  under the planDetail node come with a single element inside them
                   for(Integer i = 0; i < response.data.planDetail.planDetailsResult.member[0].eligibility.benefitSet[0].planBenefitSet[0].planBenefitLevel.size(); i++) {
                       String networkStatusCode = (String)response.data.planDetail.planDetailsResult.member[0].eligibility.benefitSet[0].planBenefitSet[0].planBenefitLevel[i].networkStatusCode.code;
                       if(String.isNotBlank(networkStatusCode)) {
                           ADBFinancialOverViewResponseWrapper.PlanLevel plan = response.data.planDetail.planDetailsResult.member[0].eligibility.benefitSet[0].planBenefitSet[0].planBenefitLevel[i].planLevel;
                           if(networkStatusCode.equalsIgnoreCase('IN-NETWORK')) {                                                                                   
                               //	Deductibles
                               individual.inNetwork = prepareDeductibles(plan, 'Individual');
                               family.inNetwork = prepareDeductibles(plan, 'Family');
                               //	Copay
                               copayIndividual.inNetwork = prepareCopayMax(plan, 'Individual');
                               copayFamily.inNetwork = prepareCopayMax(plan, 'Family');
                               //	OOP/OOP Max2                        
                               oopMaxIndividual.inNetwork = prepareOOPIndividual(plan);
                               oopMaxFamily.inNetwork = prepareOOPFamily(plan);
                               System.debug('in network : ' + plan.deductible);
                           } else if(networkStatusCode.equalsIgnoreCase('OUT-NETWORK')) {                                               
                               //	Deductibles
                               individual.outNetwork = prepareDeductibles(plan, 'Individual');
                               family.outNetwork = prepareDeductibles(plan, 'Family');
                               //	Copay
                               copayIndividual.outNetwork = prepareCopayMax(plan, 'Individual');
                               copayFamily.outNetwork = prepareCopayMax(plan, 'Family');
                               //	OOP / OOP Max2
                               oopMaxIndividual.outNetwork = prepareOOPIndividual(plan);
                               oopMaxFamily.outNetwork = prepareOOPFamily(plan);
                               System.debug('out network : ' + individual.outNetwork);
                           }
                       }
                       deductible.individual = individual;
                       deductible.family = family;
                       copay.individual = copayIndividual;
                       copay.family = copayFamily;
                       oopMaximum.individual = oopMaxIndividual;
                       oopMaximum.family = oopMaxFamily;
                   }
               }
        } catch(Exception ex) {
            System.debug('ERROR at ADBFinancialOverViewWebService.prepareDeductibles : ' + ex.getMessage());
        }
        deductibles.deductible = deductible;
        deductibles.copay = copay;
        deductibles.oopMaximums = oopMaximum;
        return deductibles;
    }
    //	Deductibles
    private static ADBFinancialOverviewUIWrapper.DeductibleAttributes prepareDeductibles(ADBFinancialOverViewResponseWrapper.PlanLevel plan, String memberType) {
        ADBFinancialOverviewUIWrapper.DeductibleAttributes deductible = new ADBFinancialOverviewUIWrapper.DeductibleAttributes();
        if(plan != null && plan.deductible != null) {
            //	Individual - deductible
            if('Individual'.equalsIgnoreCase(memberType) && plan.deductible.individual != null) {    
                deductible.ytdAmount = String.isNotBlank(plan.deductible.individual.ytdAmount) ? plan.deductible.individual.ytdAmount : '0.00';
                deductible.deductibleAmount = String.isNotBlank(plan.deductible.individual.deductibleAmount) ? plan.deductible.individual.deductibleAmount : '0.00';
                deductible.planRemainingDeductibleAmount = String.isNotBlank(plan.deductible.individual.planIndividualRemainingDeductibleAmount) ? plan.deductible.individual.planIndividualRemainingDeductibleAmount : '0.00';
            } else if('Family'.equalsIgnoreCase(memberType) && plan.deductible.family != null) {	//	Family - deductible            
                deductible.ytdAmount = String.isNotBlank(plan.deductible.family.ytdAmount) ? plan.deductible.family.ytdAmount : '0.00';
                deductible.deductibleAmount = String.isNotBlank(plan.deductible.family.deductibleAmount) ? plan.deductible.family.deductibleAmount : '0.00';
                deductible.planRemainingDeductibleAmount = String.isNotBlank(plan.deductible.family.planFamilyRemainingDeductibleAmount) ? plan.deductible.family.planFamilyRemainingDeductibleAmount : '0.00';
            }
        }
        return deductible;
    }
    //	Copay
    private static ADBFinancialOverviewUIWrapper.CopayMaxAttributes prepareCopayMax(ADBFinancialOverViewResponseWrapper.PlanLevel plan, String memberType) {
        ADBFinancialOverviewUIWrapper.CopayMaxAttributes copayMax = new ADBFinancialOverviewUIWrapper.CopayMaxAttributes();
        if(plan != null && plan.oop != null) {
            //	Individual - Copay
            if('Individual'.equalsIgnoreCase(memberType) && plan.oop.individual != null) {            
                //	TODO : There's no attribute called individualCopayMax in the response. Chandeesha is working with RF on that
                copayMax.ytdAmount = String.isNotBlank(plan.oop.individual.individualCopayYTD) ? plan.oop.individual.individualCopayYTD : '0.00';
                copayMax.copayMaxAmount = String.isNotBlank(plan.oop.individual.individualCopayMax) ? plan.oop.individual.individualCopayMax : '0.00';
                copayMax.planRemainingCopayAmount = String.isNotBlank(plan.oop.individual.planIndividualCopayRemaining) ? plan.oop.individual.planIndividualCopayRemaining : '0.00';
            } else if('Family'.equalsIgnoreCase(memberType) && plan.oop.family != null) {	//	Family - Copay            
                //	TODO : There's no attribute called individualCopayMax in the response. Chandeesha is working with RF on that
                copayMax.ytdAmount = String.isNotBlank(plan.oop.family.familyCopayYTD) ? plan.oop.family.familyCopayYTD : '0.00';
                copayMax.copayMaxAmount = String.isNotBlank(plan.oop.family.familyCopayMax) ? plan.oop.family.familyCopayMax : '0.00';
                copayMax.planRemainingCopayAmount = String.isNotBlank(plan.oop.family.planFamilyCopayRemaining) ? plan.oop.family.planFamilyCopayRemaining : '0.00';
            }
        }
        
        return copayMax;
    }
    //	OOP / OOP Max 2 - Individual (OOP needed two logics for Individual and Family due to the specific attributes)
    private static ADBFinancialOverviewUIWrapper.OOPMaximumsIndividualAttributes prepareOOPIndividual(ADBFinancialOverViewResponseWrapper.PlanLevel plan) {
        ADBFinancialOverviewUIWrapper.OOPMaximumsIndividualAttributes individualOOP = new ADBFinancialOverviewUIWrapper.OOPMaximumsIndividualAttributes();
        if(plan != null && plan.oop != null && plan.oop.individual != null) {
            //	Individual - OOP
            individualOOP.oopYTDAmount = String.isNotBlank(plan.oop.individual.oopYTDAmount) ? plan.oop.individual.oopYTDAmount : '0.00';
            individualOOP.planIndividualOOP = String.isNotBlank(plan.oop.individual.planIndividualOOP) ? plan.oop.individual.planIndividualOOP : '0.00';
            individualOOP.planIndividualOOPRemaining = String.isNotBlank(plan.oop.individual.planIndividualOOPRemaining) ? plan.oop.individual.planIndividualOOPRemaining : '0.00';
            // Individual - OOP Max 2
            individualOOP.individualCoreYTD = String.isNotBlank(plan.oop.individual.individualCoreYTD) ? plan.oop.individual.individualCoreYTD : '0.00';
            individualOOP.individualCore = String.isNotBlank(plan.oop.individual.individualCore) ? plan.oop.individual.individualCore : '0.00';
            individualOOP.planIndividualCoreRemaining = String.isNotBlank(plan.oop.individual.planIndividualCoreRemaining) ? plan.oop.individual.planIndividualCoreRemaining : '0.00';
        }
        return individualOOP;
    }
    //	OOP / OOP Max 2 - Family (OOP needed two logics for Individual and Family due to the specific attributes)
    private static ADBFinancialOverviewUIWrapper.OOPMaximumsFamilyAttributes prepareOOPFamily(ADBFinancialOverViewResponseWrapper.PlanLevel plan) {
        ADBFinancialOverviewUIWrapper.OOPMaximumsFamilyAttributes familyOOP = new ADBFinancialOverviewUIWrapper.OOPMaximumsFamilyAttributes();
        if(plan != null && plan.oop!= null &&plan.oop.family != null) {
            //	Family - OOP
            familyOOP.oopYTDAmount = String.isNotBlank(plan.oop.family.oopYTDAmount) ? plan.oop.family.oopYTDAmount : '0.00';
            familyOOP.planFamilyOOP = String.isNotBlank(plan.oop.family.planFamilyOOP) ? plan.oop.family.planFamilyOOP : '0.00';
            familyOOP.planFamilyOOPRemaining = String.isNotBlank(plan.oop.family.planFamilyOOPRemaining) ? plan.oop.family.planFamilyOOPRemaining : '0.00';
            // Family - OOP Max 2
            familyOOP.familyCoreYTD = String.isNotBlank(plan.oop.family.familyCoreYTD) ? plan.oop.family.familyCoreYTD : '0.00';
            familyOOP.familyCore = String.isNotBlank(plan.oop.family.familyCore) ? plan.oop.family.familyCore : '0.00';
            familyOOP.planFamilyCoreRemaining = String.isNotBlank(plan.oop.family.planFamilyCoreRemaining) ? plan.oop.family.planFamilyCoreRemaining : '0.00';
        }
        return familyOOP;
    }
    private static ADBContributionsUIWrapper prepareContributions(ADBFinancialOverViewResponseWrapper response,boolean hsaaccess) {
        system.debug('in perpareCOntributions'+response);
        ADBContributionsUIWrapper acu = new ADBContributionsUIWrapper();
        acu.accountBalance = new ADBContributionsUIWrapper.AccountBalance();
        acu.accountBalance.account = new List<ADBContributionsUIWrapper.Account>();
        Decimal tempTotalCurrentYrBalance = 0.00;
        Decimal tempTotalPriorYrBalance = 0.00;
        Decimal tempTotalCumulativeBalance = 0.00;
        //	collecting bank name to code mapping
        Map<String, String> codeToNameMap = new Map<String, String>();
        for(ADBFinancialsBankNameCodes__mdt mdt : [SELECT MasterLabel, BankName__c FROM ADBFinancialsBankNameCodes__mdt]) {
            codeToNameMap.put(mdt.MasterLabel, mdt.BankName__c);
        }
        if(response.data.accountBalance.accountBalanceResult.account != null){
            //acbAcntsList = response.data.accountBalance.account;
            for(ADBFinancialOverViewResponseWrapper.Account acnt:response.data.accountBalance.accountBalanceResult.account){
                ADBContributionsUIWrapper.Account acbAcnt = new ADBContributionsUIWrapper.Account();
                acbAcnt.accountNumberId = acnt.accountNumberId;
                //Added 10/16/2020
                //logic updated to go with set.contains : Madhura 11/10/2020
                if(String.isNotBlank(acnt.accountType.code)){
                    String tempAccountType = acnt.accountType.code.replace(' ', '');
                    if(accountTypes.contains(tempAccountType)){
                        if(null == acnt.accountSystemCode || acnt.accountSystemCode.contains('null') || String.isBlank(acnt.accountSystemCode)
                           || acnt.accountSystemCode.contains('Null') || acnt.accountSystemCode.contains('0')){
                               acbAcnt.accountSystemCode = 'N/A';
                           }else {
                               if(codeToNameMap.containsKey(acnt.accountSystemCode)){
                                   acbAcnt.accountSystemCode = codeToNameMap.get(acnt.accountSystemCode);
                               }
                           }                
                        system.debug('account in contributions'+acnt);
                        if(acnt.accountType != null){
                            system.debug('acnt.accountType.code'+acnt.accountType.code);
                            system.debug('acnt.accountType.desc_Z'+acnt.accountType.desc_Z);
                            acbAcnt.accountTypeCode = acnt.accountType.code;
                            acbAcnt.accountTypeDescription = acnt.accountType.desc_Z;
                        }
                        if(acnt.accountPlanYear != null){
                            List<ADBContributionsUIWrapper.AccountPlanYear> accountPlanYrList = new List<ADBContributionsUIWrapper.AccountPlanYear>();
                            for(ADBFinancialOverViewResponseWrapper.AccountPlanYear ap:acnt.accountPlanYear){
                                ADBContributionsUIWrapper.AccountPlanYear acntPlanYr = new ADBContributionsUIWrapper.AccountPlanYear();
                                if(acnt.accountType != null && !'HSA'.equals(acnt.accountType.code) ){ 
                                    if(ap.effectiveDateRange != null){
                                        system.debug('ap.effectiveDateRange.startDate'+ap.effectiveDateRange.startDate);
                                        system.debug('ap.effectiveDateRange.stopDate'+ap.effectiveDateRange.stopDate);
                                        Date apStrtDt = Date.valueOf(ap.effectiveDateRange.startDate);
                                        Date apStopDt = Date.valueOf(ap.effectiveDateRange.stopDate);
                                        Date todayDt = system.today();
                                        system.debug('today date'+system.today());
                                        if(todayDt > apStrtDt && todayDt < apStopDt){
                                            system.debug('current year');
                                            acntPlanYr.yearType = 'Current';
                                            if(ap.accountBalance != null){
                                                acbAcnt.currentYearBalance = ap.accountBalance.currentBalanceAmount;//current year balance
                                            }
                                        }else{
                                            acntPlanYr.yearType = 'Prior';
                                            if(ap.accountBalance != null){
                                                acbAcnt.priorYearBalance = ap.accountBalance.currentBalanceAmount;//current year balance
                                            }
                                        }
                                    }
                                }else if('HSA'.equals(acnt.accountType.code) ){
                                    acntPlanYr.yearType = 'Current';
                                    if(ap.accountBalance != null){
                                        acbAcnt.currentYearBalance = ap.accountBalance.currentBalanceAmount;//current year balance
                                    }
                                    acbAcnt.priorYearBalance = '';
                                }
                                if(ap.accountFunding != null){
                                    acntPlanYr.employerContributionIndicator =  ap.accountFunding.employerContributionIndicator !=null ? ap.accountFunding.employerContributionIndicator : '';
                                    acntPlanYr.employeeContributionAmountYTD = ap.accountFunding.employeeContributionAmount!=null ? ap.accountFunding.employeeContributionAmount: '';//YTD
                                    if(('HSA'.equals(acnt.accountType.code))){
                                        acntPlanYr.employeeElectedAmountTotal = ap.accountFunding.contributionLimit.currentYearContributionLimit !=null ? ap.accountFunding.contributionLimit.currentYearContributionLimit : '';
                                    }else if(!'HSA'.equals(acnt.accountType.code)){
                                        acntPlanYr.employeeElectedAmountTotal = ap.accountFunding.employeeElectedAmount != null ? ap.accountFunding.employeeElectedAmount : '';
                                    }
                                    Decimal employeeElecAmntTot = String.isNotBlank(acntPlanYr.employeeElectedAmountTotal) ? Decimal.valueOf(acntPlanYr.employeeElectedAmountTotal) : 0.0;
                                    Decimal employeeContr = String.isNotBlank(acntPlanYr.employeeContributionAmountYTD) ? Decimal.valueOf(acntPlanYr.employeeContributionAmountYTD) : 0.0;
                                    Decimal employeebal = employeeElecAmntTot - employeeContr;
                                    acntPlanYr.employeeBalance = employeebal!=null ? String.valueOf(employeebal): '';
                                    acntPlanYr.employerContributionAmountYTD = ap.accountFunding.employerContributionAmount!=null ? ap.accountFunding.employerContributionAmount : '';
                                    if(('HSA'.equals(acnt.accountType.code))){
                                        acntPlanYr.employerContributionLessIncentiveAmountTotal = ap.accountFunding.contributionLimit.currentYearContributionLimit!=null ? ap.accountFunding.contributionLimit.currentYearContributionLimit : '';
                                    }else if(!'HSA'.equals(acnt.accountType.code)){
                                        acntPlanYr.employerContributionLessIncentiveAmountTotal = ap.accountFunding.employerContributionLessIncentiveAmount!=null ? ap.accountFunding.employerContributionLessIncentiveAmount: '';
                                    }
                                    Decimal employerElecAmntTot = String.isNotBlank(acntPlanYr.employerContributionLessIncentiveAmountTotal) ? Decimal.valueOf(acntPlanYr.employerContributionLessIncentiveAmountTotal) : 0.0;
                                    Decimal employerContr = String.isNotBlank(acntPlanYr.employerContributionAmountYTD) ? Decimal.valueOf(acntPlanYr.employerContributionAmountYTD) : 0.0;
                                    Decimal employerbal = employerElecAmntTot - employerContr;
                                    acntPlanYr.employerBalance = employerbal!=null ? String.valueOf(employerbal) : '';
                                }
                                accountPlanYrList.add(acntPlanYr);
                            }
                            // end of account plan year loop
                            acbAcnt.accountPlanYear = accountPlanYrList;
                            if(String.isNotBlank(acbAcnt.priorYearBalance) && String.isNotBlank(acbAcnt.currentYearBalance)){
                                Decimal cumulativeBal = Decimal.valueOf(acbAcnt.priorYearBalance) +  Decimal.valueOf(acbAcnt.currentYearBalance);
                                acbAcnt.cumulativeBalance = String.valueOf(cumulativeBal);     
                            }else if(String.isNotBlank(acbAcnt.currentYearBalance)){
                                Decimal cumulativeBal =  Decimal.valueOf(acbAcnt.currentYearBalance);
                                acbAcnt.cumulativeBalance = String.valueOf(cumulativeBal);     
                            }
                        }
                        acu.accountBalance.account.add(acbAcnt);
                        if(String.isNotBlank(acbAcnt.currentYearBalance) && 'HSA'.equals(acnt.accountType.code) && hsaaccess){
                            tempTotalCurrentYrBalance = tempTotalCurrentYrBalance + Decimal.valueOf(acbAcnt.currentYearBalance);
                        }else if(String.isNotBlank(acbAcnt.currentYearBalance) && !'HSA'.equals(acnt.accountType.code)){
                            tempTotalCurrentYrBalance = tempTotalCurrentYrBalance + Decimal.valueOf(acbAcnt.currentYearBalance);
                        }
                        if(String.isNotBlank(acbAcnt.priorYearBalance)){
                            tempTotalPriorYrBalance = tempTotalPriorYrBalance + Decimal.valueOf(acbAcnt.priorYearBalance);
                        }
                        if(String.isNotBlank(acbAcnt.cumulativeBalance) && 'HSA'.equals(acnt.accountType.code) && hsaaccess ){
                            tempTotalCumulativeBalance = tempTotalCumulativeBalance + Decimal.valueOf(acbAcnt.cumulativeBalance);
                        }else if(String.isNotBlank(acbAcnt.cumulativeBalance) && !'HSA'.equals(acnt.accountType.code)){
                            tempTotalCumulativeBalance = tempTotalCumulativeBalance + Decimal.valueOf(acbAcnt.cumulativeBalance);
                        }
                        system.debug('@@@tempTotalCurrentYrBalance'+tempTotalCurrentYrBalance+'//'+tempTotalCumulativeBalance+'//'+hsaaccess);
                    }
                }
                acu.accountBalance.totalCurrentYrBalance = String.valueOf(tempTotalCurrentYrBalance);
                acu.accountBalance.totalPriorYrBalance = String.valueOf(tempTotalPriorYrBalance);
                acu.accountBalance.totalCumulativeBalance = String.valueOf(tempTotalCumulativeBalance);
                system.debug('ACU------------------------------------------'+acu);
            }
        }
        return acu;
    }
    //Changes Made : 15/09/2020
    //By:Nadeem
    //Reason:Extract Faro Account & Transaction from Response
    private static ADBTransactionsWrapper prepareTransactions(ADBFinancialOverViewResponseWrapper response) {
        System.debug('in prepareTransactions Method : '+response);
        ADBTransactionsWrapper twrap = new ADBTransactionsWrapper();
        if((response != null)&&(response.data != null)&&(response.data.faro != null)){
            if((response.data.faro.accounts != null)){
                List<ADBTransactionsWrapper.TransactionData> td = new List<ADBTransactionsWrapper.TransactionData>();
                for(ADBFinancialOverViewResponseWrapper.Accounts acnt:response.data.faro.accounts){
                    //Check only the 7 account types
                    // using set.contains : Madhura 11/10/2020
                    if(String.isNotBlank(acnt.accountType)) {
                        String tempAccountType = acnt.accountType.replace(' ', '');
                        if(ADBFinancialOverViewWebService.accountTypes.contains(tempAccountType)){
                            ADBTransactionsWrapper.TransactionData faroAcnt = new ADBTransactionsWrapper.TransactionData();
                            faroAcnt.accountCode = String.isNotBlank(acnt.accountCode) ? acnt.accountCode : '';
                            faroAcnt.accountNumber = String.isNotBlank(acnt.accountNumber) ? 'XXXXX'+acnt.accountNumber.substring(acnt.accountNumber.length()-4):'';
                            if(String.isNotBlank(acnt.accountType)){
                                faroAcnt.accountType = acnt.accountType;
                                if('HSA'.equalsIgnoreCase(acnt.accountType)){
                                    if(response.data.faro.memberDetail != null){
                                        
                                        faroAcnt.ssn = String.isNotBlank(response.data.faro.memberDetail.ssn) ? 'XXX-XX-'+response.data.faro.memberDetail.ssn.substring(response.data.faro.memberDetail.ssn.length()-4):'';
                                        faroAcnt.firstName = String.isNotBlank(response.data.faro.memberDetail.firstName) ? response.data.faro.memberDetail.firstName : '';
                                        faroAcnt.lastName = String.isNotBlank(response.data.faro.memberDetail.lastName) ? response.data.faro.memberDetail.lastName : '';
                                    }
                                }



                                    faroAcnt.spendingCardType= String.isNotBlank(acnt.spendingCardType) ? (acnt.spendingCardType=='true') ? 'Yes': 'No' :'N/A' ;
                                    faroAcnt.coordinatedPayment = String.isNotBlank(acnt.coordinatedPayment) ?  (acnt.coordinatedPayment=='true') ? 'Yes': 'No' :'N/A' ;
                                    faroAcnt.preFunded = String.isNotBlank(acnt.preFunded) ? (acnt.preFunded=='true') ? 'Yes': 'No' :'N/A';
                                    faroAcnt.allowCoordPayOver = String.isNotBlank(acnt.allowCoordPayOver) ? (acnt.allowCoordPayOver=='true') ? 'Yes': 'No' :'N/A';
                                    faroAcnt.disableOverrideFromPortal = String.isNotBlank(acnt.disableOverrideFromPortal) ? (acnt.disableOverrideFromPortal=='true') ? 'Yes': 'No' :'N/A';
                                    faroAcnt.carryoverIndicator = String.isNotBlank(acnt.carryoverIndicator) ? (acnt.carryoverIndicator=='true') ? 'Yes': 'No' :'N/A';
                                    faroAcnt.acctPlanYearGracePeriodExpirationDate=String.isNotBlank(acnt.acctPlanYearGracePeriodExpirationDate) ? acnt.acctPlanYearGracePeriodExpirationDate : '';
                                }
                            if(null!= acnt.investedBalance && String.isNotBlank(acnt.investedBalance)){
                                decimal tval = Decimal.valueOf(acnt.investedBalance);
                                
                                faroAcnt.investedBalance =  String.isNotBlank(acnt.investedBalance) ? (acnt.investedBalance.contains('.') ? String.valueOf(tval.setscale(2,system.RoundingMode.DOWN)) : acnt.investedBalance+'.00' ) : '';//String.isNotBlank(acnt.investedBalance) ? (acnt.investedBalance.contains('.00') ? acnt.investedBalance : acnt.investedBalance+'.00' ) : '';
                            }
                            faroAcnt.accountError = String.isNotBlank(acnt.accountError) ? acnt.accountError : '';
                            List<ADBTransactionsWrapper.TransactionList> accountTransactions = new List<ADBTransactionsWrapper.TransactionList>();
                            if((acnt.transactions != null)){
                                for(ADBFinancialOverViewResponseWrapper.Transactions tlv :acnt.transactions){
                                    ADBTransactionsWrapper.TransactionList transVal = new ADBTransactionsWrapper.TransactionList();
                                    
                                    
                                    decimal val = Decimal.valueOf(tlv.amount);
                                    
                                    transVal.amount =  String.isNotBlank(tlv.amount) ? (tlv.amount.contains('.') ? String.valueOf(val.setscale(2,system.RoundingMode.DOWN)) : tlv.amount+'.00' ) : '';
                                    transVal.description = String.isNotBlank(tlv.description) ? tlv.description : '';
                                    transVal.processedDate = String.isNotBlank(tlv.processedDate) ? cleanDate(String.ValueOf((Date.valueOf(tlv.processedDate )).format())): '';
                                    transVal.status = String.isNotBlank(tlv.status) ? tlv.status : '';
                                    transVal.type_Z = String.isNotBlank(tlv.type_Z) ? tlv.type_Z : '';
                                    system.debug('@@@'+transVal);
                                    accountTransactions.add(transVal);
                                } 
                            }
                            faroAcnt.transList = accountTransactions;
                            td.add(faroAcnt);
                        }
                    }
                }
                twrap.transData = td;    
            }
        }
        System.debug('Transactions Response : '+twrap);
        return twrap;  
    }
    public static String cleanDate(String theDate){
        String [] s = theDate.split('/');
        String newDate= '';
        String newMonth= '';
        String newDay= '';
        if(s[0].length() == 1){
            newMonth = '0'+s[0];
        }else{
            newMonth = s[0];
        }
        if(s[1].length() == 1){
            newDay = '0'+s[1];
        }else{
            newDay = s[1];
        }
        newDate = newMonth+'/'+newDay+'/'+s[2];
        return newDate;
    } 
}