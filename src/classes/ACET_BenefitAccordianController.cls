public class ACET_BenefitAccordianController {

    @AuraEnabled
    public static BenefitResponseWrapper getBenefitDetails(ACET_CopayCoInsuranceWebService.CopayCoInsuranceRequest requestObject, String componentName, Integer componentOrder, Integer policyIndex) {
        System.debug(Logginglevel.INFO, '### COPAY-REQUEST-OBJECT:' + requestObject);
        BenefitResponseWrapper benefitWrapper = new BenefitResponseWrapper();
        //Service call out
        ACETWSCalloutResult returnObject = new ACET_CopayCoInsuranceWebService().getBenefit(requestObject);

        //response
        ACET_CopayCoInsuranceResult resultWrapper = (ACET_CopayCoInsuranceResult) returnObject.Response;

        //Autodoc table
        ACET_AutoDocUtil.TableDetails benefitTable = new ACET_AutoDocUtil.TableDetails();
        try {
            ACET_CopayCoInsuranceResult.Individual tableData = new ACET_CopayCoInsuranceResult.Individual();
            if (resultWrapper != null && resultWrapper.copayCoInsurance != null) {
                tableData = resultWrapper.copayCoInsurance.individual;
            }
            benefitTable.type = 'table';
            benefitTable.showComponentName = false;
            benefitTable.showCardStyle = false;
            benefitTable.componentName = componentName;
            benefitTable.caseItemExtId = componentName + ' - Benefit Accumulations';
            benefitTable.autodocHeaderName = 'Benefit Accumulations: ' + componentName; //US3125177 Plan Benefits - Benefit Accumulation HIPPA Service Type Code UI 
            benefitTable.componentOrder = componentOrder;
            benefitTable.caseItemsEnabled = true;
            benefitTable.statusCode = returnObject.statusCode;
            benefitTable.errorMessage = returnObject.Message;
            benefitTable.policyIndex = policyIndex;
            List < String > benefitHeaders = new List < String > {
                'COVERAGE LEVEL',
                'BENEFIT LIMIT'
            };
            if (tableData.isDollarAmountAvailable != null && tableData.isDollarAmountAvailable) {
                benefitHeaders.add('DOLLAR AMOUNT');
            }
            benefitHeaders.add('APPLIED');
            benefitHeaders.add('REMAINING');
            if (tableData.isMskAvailable != null && tableData.isMskAvailable) {
                benefitHeaders.add('MSK REMAINING');
            }
            // US3248728: Plan Benefits: Benefit Accumulations UI
            //benefitHeaders.add('COPAY');
            //benefitHeaders.add('COINSURANCE');
            benefitTable.tableHeaders = benefitHeaders;
            List < ACET_AutoDocUtil.TableRow > tableRows = new List < ACET_AutoDocUtil.TableRow > ();
            ACET_AutoDocUtil.TableRow tableRow = new ACET_AutoDocUtil.TableRow();
            if (tableData != null) {
                //Tier1
                tableRow = new ACET_AutoDocUtil.TableRow();
                tableRow.checked = false;
                tableRow.uniqueKey = 'Tier1' + componentName;
                List < ACET_AutoDocUtil.RowColumnData > tier1Row = new List < ACET_AutoDocUtil.RowColumnData > ();
                tier1Row.add(ACET_AutoDocUtil.setRowColumnData('outputText', 'Tier1', 'COVERAGE LEVEL', 'Tier1', true));
                tier1Row.add(ACET_AutoDocUtil.setRowColumnData('outputText', tableData.tier1 != null ? (tableData.tier1.benefitsAllowed.length() > 25 ? tableData.tier1.benefitsAllowed.substring(0, 24) + '...' : tableData.tier1.benefitsAllowed) : '--', 'BENEFIT LIMIT', tableData.tier1 != null ? tableData.tier1.benefitsAllowed : '--', true));
                if (tableData.isDollarAmountAvailable != null && tableData.isDollarAmountAvailable) {
                    tier1Row.add(ACET_AutoDocUtil.setRowColumnData('outputText', tableData.tier1 != null ? (tableData.tier1.dollarAmount.length() > 25 ? tableData.tier1.dollarAmount.substring(0, 24) + '...' : tableData.tier1.dollarAmount) : '--', 'DOLLAR AMOUNT', tableData.tier1 != null ? tableData.tier1.dollarAmount : '--', true));
                }
                tier1Row.add(ACET_AutoDocUtil.setRowColumnData('outputText', '--', 'APPLIED', '--', true));
                tier1Row.add(ACET_AutoDocUtil.setRowColumnData('outputText', tableData.tier1 != null ? (tableData.tier1.benefitsRemaining.length() > 25 ? tableData.tier1.benefitsRemaining.substring(0, 24) + '...' : tableData.tier1.benefitsRemaining) : '--', 'REMAINING', tableData.tier1 != null ? tableData.tier1.benefitsRemaining : '--', true));
                if (tableData.isMskAvailable != null && tableData.isMskAvailable) {
                    tier1Row.add(ACET_AutoDocUtil.setRowColumnData('outputText', tableData.tier1 != null ? (tableData.tier1.mskRemaining.length() > 25 ? tableData.tier1.mskRemaining.substring(0, 24) + '...' : tableData.tier1.mskRemaining) : '--', 'MSK REMAINING', tableData.tier1 != null ? tableData.tier1.mskRemaining : '--', true));
                }
                // US3248728: Plan Benefits: Benefit Accumulations UI
                //tier1Row.add(ACET_AutoDocUtil.setRowColumnData('outputText', tableData.tier1 != null ? (tableData.tier1.copay.length() > 25 ? tableData.tier1.copay.substring(0, 24) + '...' : tableData.tier1.copay) : '--', 'CO-PAY', tableData.tier1 != null ? tableData.tier1.copay : '--', true));
                //tier1Row.add(ACET_AutoDocUtil.setRowColumnData('outputText', tableData.tier1 != null ? (tableData.tier1.coInsurance.length() > 25 ? tableData.tier1.coInsurance.substring(0, 24) + '...' : tableData.tier1.coInsurance) : '--', 'CO-PAY', tableData.tier1 != null ? tableData.tier1.coInsurance : '--', true));
                tableRow.rowColumnData = tier1Row;
                tableRows.add(tableRow);

                //INN
                tableRow = new ACET_AutoDocUtil.TableRow();
                tableRow.checked = false;
                tableRow.uniqueKey = 'INN' + componentName;
                List < ACET_AutoDocUtil.RowColumnData > inNetworkRow = new List < ACET_AutoDocUtil.RowColumnData > ();
                inNetworkRow.add(ACET_AutoDocUtil.setRowColumnData('outputText', 'INN', 'COVERAGE LEVEL', 'INN', true));
                inNetworkRow.add(ACET_AutoDocUtil.setRowColumnData('outputText', tableData.inNetwork != null ? (tableData.inNetwork.benefitsAllowed.length() > 25 ? tableData.inNetwork.benefitsAllowed.substring(0, 24) + '...' : tableData.inNetwork.benefitsAllowed) : '--', 'BENEFIT LIMIT', tableData.inNetwork != null ? tableData.inNetwork.benefitsAllowed : '--', true));
                if (tableData.isDollarAmountAvailable != null && tableData.isDollarAmountAvailable) {
                    inNetworkRow.add(ACET_AutoDocUtil.setRowColumnData('outputText', tableData.inNetwork != null ? (tableData.inNetwork.dollarAmount.length() > 25 ? tableData.inNetwork.dollarAmount.substring(0, 24) + '...' : tableData.inNetwork.dollarAmount) : '--', 'DOLLAR AMOUNT', tableData.inNetwork != null ? tableData.inNetwork.dollarAmount : '--', true));
                }
                inNetworkRow.add(ACET_AutoDocUtil.setRowColumnData('outputText', '--', 'APPLIED', '--', true));
                inNetworkRow.add(ACET_AutoDocUtil.setRowColumnData('outputText', tableData.inNetwork != null ? (tableData.inNetwork.benefitsRemaining.length() > 25 ? tableData.inNetwork.benefitsRemaining.substring(0, 24) + '...' : tableData.inNetwork.benefitsRemaining) : '--', 'REMAINING', tableData.inNetwork != null ? tableData.inNetwork.benefitsRemaining : '--', true));
                if (tableData.isMskAvailable != null && tableData.isMskAvailable) {
                    inNetworkRow.add(ACET_AutoDocUtil.setRowColumnData('outputText', tableData.inNetwork != null ? (tableData.inNetwork.mskRemaining.length() > 25 ? tableData.inNetwork.mskRemaining.substring(0, 24) + '...' : tableData.inNetwork.mskRemaining) : '--', 'MSK REMAINING', tableData.inNetwork != null ? tableData.inNetwork.mskRemaining : '--', true));
                }
                // US3248728: Plan Benefits: Benefit Accumulations UI
                // inNetworkRow.add(ACET_AutoDocUtil.setRowColumnData('outputText', tableData.inNetwork != null ? (tableData.inNetwork.copay.length() > 25 ? tableData.inNetwork.copay.substring(0, 24) + '...' : tableData.inNetwork.copay) : '--', 'CO-PAY', tableData.inNetwork != null ? tableData.inNetwork.copay : '--', true));
                // inNetworkRow.add(ACET_AutoDocUtil.setRowColumnData('outputText', tableData.inNetwork != null ? (tableData.inNetwork.coInsurance.length() > 25 ? tableData.inNetwork.coInsurance.substring(0, 24) + '...' : tableData.inNetwork.coInsurance) : '--', 'CO-PAY', tableData.inNetwork != null ? tableData.inNetwork.coInsurance : '--', true));
                tableRow.rowColumnData = inNetworkRow;
                tableRows.add(tableRow);

                //OON
                tableRow = new ACET_AutoDocUtil.TableRow();
                tableRow.checked = false;
                tableRow.uniqueKey = 'OON' + componentName;
                List < ACET_AutoDocUtil.RowColumnData > outNetworkRow = new List < ACET_AutoDocUtil.RowColumnData > ();
                outNetworkRow.add(ACET_AutoDocUtil.setRowColumnData('outputText', 'OON', 'COVERAGE LEVEL', 'OON', true));
                outNetworkRow.add(ACET_AutoDocUtil.setRowColumnData('outputText', tableData.outNetwork != null ? (tableData.outNetwork.benefitsAllowed.length() > 25 ? tableData.outNetwork.benefitsAllowed.substring(0, 24) + '...' : tableData.outNetwork.benefitsAllowed) : '--', 'BENEFIT LIMIT', tableData.outNetwork != null ? tableData.outNetwork.benefitsAllowed : '--', true));
                if (tableData.isDollarAmountAvailable != null && tableData.isDollarAmountAvailable) {
                    outNetworkRow.add(ACET_AutoDocUtil.setRowColumnData('outputText', tableData.outNetwork != null ? (tableData.outNetwork.dollarAmount.length() > 25 ? tableData.outNetwork.dollarAmount.substring(0, 24) + '...' : tableData.outNetwork.dollarAmount) : '--', 'DOLLAR AMOUNT', tableData.outNetwork != null ? tableData.outNetwork.dollarAmount : '--', true));
                }
                outNetworkRow.add(ACET_AutoDocUtil.setRowColumnData('outputText', '--', 'APPLIED', '--', true));
                outNetworkRow.add(ACET_AutoDocUtil.setRowColumnData('outputText', tableData.outNetwork != null ? (tableData.outNetwork.benefitsRemaining.length() > 25 ? tableData.outNetwork.benefitsRemaining.substring(0, 24) + '...' : tableData.outNetwork.benefitsRemaining) : '--', 'REMAINING', tableData.outNetwork != null ? tableData.outNetwork.benefitsRemaining : '--', true));
                if (tableData.isMskAvailable != null && tableData.isMskAvailable) {
                    outNetworkRow.add(ACET_AutoDocUtil.setRowColumnData('outputText', tableData.outNetwork != null ? (tableData.outNetwork.mskRemaining.length() > 25 ? tableData.outNetwork.mskRemaining.substring(0, 24) + '...' : tableData.outNetwork.mskRemaining) : '--', 'MSK REMAINING', tableData.outNetwork != null ? tableData.outNetwork.mskRemaining : '--', true));
                }
                // US3248728: Plan Benefits: Benefit Accumulations UI
                // outNetworkRow.add(ACET_AutoDocUtil.setRowColumnData('outputText', tableData.outNetwork != null ? (tableData.outNetwork.copay.length() > 25 ? tableData.outNetwork.copay.substring(0, 24) + '...' : tableData.outNetwork.copay) : '--', 'CO-PAY', tableData.outNetwork != null ? tableData.outNetwork.copay : '--', true));
                // outNetworkRow.add(ACET_AutoDocUtil.setRowColumnData('outputText', tableData.outNetwork != null ? (tableData.outNetwork.coInsurance.length() > 25 ? tableData.outNetwork.coInsurance.substring(0, 24) + '...' : tableData.outNetwork.coInsurance) : '--', 'CO-PAY', tableData.outNetwork != null ? tableData.outNetwork.coInsurance : '--', true));
                tableRow.rowColumnData = outNetworkRow;
                tableRows.add(tableRow);
            }
            benefitTable.tableBody = tableRows;
            benefitWrapper.benefitTable = benefitTable;
        } catch (exception ex) {
            System.debug('exception::' + ex.getStackTraceString());
        }
        return benefitWrapper;
    }

    public class BenefitResponseWrapper {
        @Auraenabled public ACET_AutoDocUtil.TableDetails benefitTable;
        @Auraenabled public ACET_AutoDocUtil.CardDetails benefitLanguageCard;
        @Auraenabled public ACET_AutoDocUtil.CardDetails tieroneLanguageCard;
        @Auraenabled public ACET_AutoDocUtil.CardDetails innetworkLanguageCard;
        @Auraenabled public ACET_AutoDocUtil.CardDetails outnetworkLanguageCard;
    }

    // US3125215 - Thanish - 22nd Dec 2020
    @AuraEnabled
    public static BenefitLanguageWrapper getBenefitLanguageDetails(String transactionId, String benefitCode, String componentName, Integer componentOrder) {
        BenefitLanguageWrapper returnWrapper = new BenefitLanguageWrapper();
        ACET_BenefitDetailsHelper.BenefitLanguageDetails languageDetails = ACET_BenefitDetailsHelper.getBenefitLanguage(transactionId, benefitCode);
        returnWrapper.statusCode = languageDetails.statusCode;// US3125215 - Thanish - 22nd Dec 2020
        ACET_AutoDocUtil.CardDetails languageCard = new ACET_AutoDocUtil.CardDetails();
        try {
            if (languageDetails.benefit.size() > 0) {
                ACET_BenefitDetailsHelper.Benefit language = new ACET_BenefitDetailsHelper.Benefit();
                for(ACET_BenefitDetailsHelper.Benefit lang : languageDetails.benefit) {
                    if(lang.benefitName.equalsignorecase(componentName)) {
                        language = lang;
                        break;
                    }
                }
                if(language.benefitDetails == null) {
                    language = languageDetails.benefit[0];
                }
                returnWrapper.benefitLanguage = language.benefitDetails;

                List < NetworkStatus > networkStatusList = new List < NetworkStatus > ();
                for (ACET_BenefitDetailsHelper.BenefitNetworkSection network: language.benefitNetworkSection) {
                    // US3368412: Plan Benefits: Benefit Details:  Benefit Language Cost Shares - E&I and M&R
                    if (!String.isEmpty(network.networkStatus[0])){
                        networkStatusList.add(new NetworkStatus(network.networkStatus[0], network.costs));
                    }
                    /*if (network.networkStatus[0].containsIgnoreCase('your cost if you use network benefits')) {
                        networkStatusList.add(new NetworkStatus('INN', network.costs));
                    } else if (network.networkStatus[0].containsIgnoreCase('your cost if you use out-of-network benefits')) {
                        networkStatusList.add(new NetworkStatus('OON', network.costs));
                    } else if (network.networkStatus[0].containsIgnoreCase('your cost if you use tier 1')) {
                        networkStatusList.add(new NetworkStatus('Tier 1', network.costs));
                    } else if (network.networkStatus[0].containsIgnoreCase('your cost if you use tier 2')) {
                        networkStatusList.add(new NetworkStatus('Tier 2', network.costs));
                    } else {
                        returnWrapper.benefitLanguage = returnWrapper.benefitLanguage + '<br/>' + network.costs;
                    }*/
                }
                returnWrapper.networkStatusList = networkStatusList;

                for (ACET_BenefitDetailsHelper.LimitsAndExceptions lim: language.limitsAndExceptions) {
                    // DE430022 - Thanish - 8th Apr 2021
                    returnWrapper.benefitLanguage = returnWrapper.benefitLanguage + (String.isNotBlank(lim.description) ? '<br/>' + lim.description : '') + (String.isNotBlank(lim.details) ? '<br/>' + lim.details : '');
                }
            }

            //Autodoc Card formation
            languageCard.componentName = componentName;
            languageCard.componentOrder = componentOrder;
            languageCard.type = 'card';
            languageCard.noOfColumns = 'slds-size_12-of-12';
            languageCard.caseItemsEnabled = true;
            languageCard.caseItemExtId = componentName + ' - Benefit Details';
            languageCard.caseItemsExtId = componentName + ' - Benefit Details';
            List < ACET_AutoDocUtil.FieldDetails > cardData = new List < ACET_AutoDocUtil.FieldDetails > ();
            if (returnWrapper != null) {
                cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Benefit Language', returnWrapper.benefitLanguage, 'accordian', 'utility:chevrondown', true, 'slds-show'));
                for (NetworkStatus network: returnWrapper.networkStatusList) {
                    cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, network.Type, network.description, 'accordian', 'utility:chevronright', true, 'slds-hide'));
                }
            }
            languageCard.cardData = cardData;
        } catch (Exception e) {
            returnWrapper.statusCode = 999;// US3125215 - Thanish - 22nd Dec 2020
            System.debug('Exception in ACET_BenefitAccordianController - Line ' + e.getLineNumber());
            System.debug('Exception in ACET_BenefitAccordianController - Message ' + e.getMessage());
        }
        // US3125215 - Thanish - 22nd Dec 2020
        returnWrapper.languageCard = languageCard;
        return returnWrapper;
    }

    public class BenefitLanguageWrapper {
        @AuraEnabled public String benefitLanguage;
        @AuraEnabled public List < NetworkStatus > networkStatusList;
        // US3304569 - Thanish - 17th Mar 2021
        @AuraEnabled public ACET_AutoDocUtil.CardDetails languageCard;
        @AuraEnabled public Integer statusCode;
    }
    public class NetworkStatus {
        @AuraEnabled public String type;
        @AuraEnabled public String description;

        public NetworkStatus(String tp, String des) {
            this.type = tp;
            this.description = des;
        }
    }
}