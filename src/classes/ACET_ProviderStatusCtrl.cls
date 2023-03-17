public with sharing class ACET_ProviderStatusCtrl {

    @AuraEnabled
    public static ACET_MAndRProviderStatusWrapper getMAndRProviderStatus(String providerId, String taxId, String addressId, String cosDiv, String cosPanNum, String coverageStartDate, String coverageEndDate,string provDiv){ //US3574032
        // list to store the contract data
        List<ACET_MAndRContractDataWrapper> contractDataWrapperList = new List<ACET_MAndRContractDataWrapper>();
        // get m and r contract data from api
        ACET_ProviderContractService providerContractService = new ACET_ProviderContractService();
        // US3244384 Integration for Member Div to Provider Div Mapping - Sarma - 01/03/2021
        //String providerDiv = convertCosmosDiv(cosDiv,coverageStartDate,coverageEndDate); //US3574032
         String providerDiv  = string.isNotBlank(provDiv) ? provDiv : ''; //US3574032
        ACETWSCalloutResult calloutResult = providerContractService.getMAndRContracts(providerId, taxId, addressId, providerDiv, cosPanNum, true);

        if(calloutResult.Success){
            try{
                ACET_MAndRContractsResponse contractResponse = (ACET_MAndRContractsResponse) calloutResult.Response;
                if(contractResponse.medicareandretirement.size() > 0){
                    List<String> dateArr = contractResponse.medicareandretirement[0].cos_canc_date.split('-');
                    Date cancelDate = Date.today();
                    if(dateArr.size() == 3){
                        cancelDate = Date.newInstance(Integer.valueOf(dateArr[0]), Integer.valueOf(dateArr[1]), Integer.valueOf(dateArr[2]));
                    }
                    Date today = Date.today();
                    
                    if(cancelDate > today) {
                        ACET_MAndRProviderStatusWrapper wrapper = new ACET_MAndRProviderStatusWrapper();
                        wrapper.mnrCardDetails = ACET_ProviderStatusCtrl.getMNRCardDetails(contractResponse, 'INN', 'Match', 'action:approval', cosDiv, cosPanNum);
                        //US3291595
                        wrapper.success = true;
                        wrapper.contractResponse = contractResponse;
                        return wrapper;
                    } else {
                        ACET_MAndRProviderStatusWrapper wrapper = new ACET_MAndRProviderStatusWrapper();
                        wrapper.mnrCardDetails = ACET_ProviderStatusCtrl.getMNRCardDetails(contractResponse, 'OON', 'Match', 'action:close', cosDiv, cosPanNum);
                        //US3291595
                        wrapper.success = true;
                        wrapper.contractResponse = contractResponse;
                        return wrapper;
                    }
                } else{
                    ACET_MAndRProviderStatusWrapper wrapper = new ACET_MAndRProviderStatusWrapper();
                    wrapper.mnrCardDetails = ACET_ProviderStatusCtrl.getMNRCardDetails(contractResponse, 'OON', 'No Match', 'action:close', cosDiv, cosPanNum);
                    wrapper.isMNREmpty = true;
                    //US3291595
                    wrapper.success = true;
                    wrapper.contractResponse = contractResponse;
                    return wrapper;
                }
            } catch(Exception ex){
                ACET_MAndRProviderStatusWrapper wrapper = new ACET_MAndRProviderStatusWrapper();
                wrapper.mnrCardDetails = ACET_ProviderStatusCtrl.getMNRCardDetails(null, '--', '--', 'standard:macros', cosDiv, cosPanNum);
                return wrapper;
            }
        } else{
            ACET_MAndRProviderStatusWrapper wrapper = new ACET_MAndRProviderStatusWrapper();
            wrapper.mnrCardDetails = ACET_ProviderStatusCtrl.getMNRCardDetails(null, '--', '--', 'standard:macros', cosDiv, cosPanNum);
            wrapper.success = false;
            return wrapper;
        }
    }

    private static ACET_AutoDocUtil.CardDetails getMNRCardDetails(ACET_MAndRContractsResponse contractResponse, String statusText, String iconValue, String iconName, String cosDiv, String cosPanNum){
        ACET_AutoDocUtil.CardDetails cardDetails = new ACET_AutoDocUtil.CardDetails();
        cardDetails.type = 'card';
        if(contractResponse != null && contractResponse.medicareandretirement.size() > 0){
            cardDetails.componentName = 'Provider Status ( ' + SAEUtils.formatDate(contractResponse.medicareandretirement[0].cos_eff_dt) + ' - ' + SAEUtils.formatDate(contractResponse.medicareandretirement[0].cos_canc_date) + ' )';
        } else{
            cardDetails.componentName = 'Provider Status (--)';
        }
        cardDetails.noOfColumns = 'slds-size_1-of-12';
        cardDetails.componentOrder = 7;
        cardDetails.cardData = new  List<ACET_AutoDocUtil.FieldDetails>();
        cardDetails.cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Status', statusText, 'outputText'));
        ACET_AutoDocUtil.FieldDetails div = new ACET_AutoDocUtil.FieldDetails(false, false, true, 'DIV', iconValue, 'iconWithText');
        div.iconName = iconName;
        div.iconText = cosDiv;
        cardDetails.cardData.add(div);
        ACET_AutoDocUtil.FieldDetails panel = new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Panel', iconValue, 'iconWithText');
        panel.iconName = iconName;
        panel.iconText = cosPanNum;
        cardDetails.cardData.add(panel);
        return cardDetails;
    }

    public static string getMockNetworkKey(){
        Map < String, ACETOrgInstanceURLToOrgNameMap__c > OrgInstance2OrgNameMap = ACETOrgInstanceURLToOrgNameMap__c.getAll();
        String orgName = Test.isRunningTest() ? 'dev' : ACETUtility.GetOrgName(OrgInstance2OrgNameMap);
        Map < String, ISL_Webservice_Config__c > islWebserviceData = ISL_Webservice_Config__c.getAll();
        String networkKey = islWebserviceData.get(orgName + '_RCESNetworkKey') != NULL ?
            (islWebserviceData.get(orgName + '_RCESNetworkKey').Is_Available__c ?
             (string.isBlank(islWebserviceData.get(orgName + '_RCESNetworkKey').Value__c) ? '' : islWebserviceData.get(orgName + '_RCESNetworkKey').Value__c ) : null ) : null;
        return networkKey;
    }

    // US3308070 - Thanish - 2nd Mar 2021
    @AuraEnabled
    public static ACET_NetworkKeyStatusWrapper getNetworkKeyStatus(String subscriberId, String policyNumber, String sourceCode, String coverageLevel){
        ACET_ReadConsumerEligibilityService.ReadConsumerWrapper rcWrapper = new  ACET_ReadConsumerEligibilityService.ReadConsumerWrapper();
        ACET_NetworkKeyStatusWrapper wrapper = new ACET_NetworkKeyStatusWrapper();
        String coverageStartDate = System.now().format('YYYY-MM-dd');
        rcWrapper = ACET_ReadConsumerEligibilityService.call_RCED_API(subscriberId, policyNumber, sourceCode, coverageLevel, coverageStartDate);

        if(rcWrapper.networkKey != null){
            wrapper.networkKey = rcWrapper.networkKey;

            if((rcWrapper.networkKey == 'M') || (rcWrapper.networkKey == 'T') || (rcWrapper.networkKey == 'X') || (String.isBlank(rcWrapper.networkKey))){
                wrapper.callENIContracts = true;
                wrapper.success = true;
            } else{
                wrapper.callENIContracts = false;
                wrapper.success = true;
            }

        } else{
            wrapper.errorMessage = 'Failed to retrieve Network Key';
        }

        return wrapper;
    }

    // US3308070 - Thanish - 2nd Mar 2021
    @AuraEnabled
    public static ACET_NetworkKeyStatusWrapper getNetworkKeyStatus(String subscriberId, String policyNumber, String sourceCode, String coverageLevel, String coverageStartDate, Boolean isTermedPolicy){ // US3308070 - Thanish - 2nd Mar 2021
        ACET_ReadConsumerEligibilityService.ReadConsumerWrapper rcWrapper = new  ACET_ReadConsumerEligibilityService.ReadConsumerWrapper();
        ACET_NetworkKeyStatusWrapper wrapper = new ACET_NetworkKeyStatusWrapper();
        // US3308070 - Thanish - 2nd Mar 2021
        // Boolean isStaticResponseChecked = false;
        // isStaticResponseChecked = SAEUtils.getMockStatus();
        // if(isStaticResponseChecked && !Test.isRunningTest()) {

        //     rcWrapper.networkKey = getMockNetworkKey();
        // } else{
        if(!isTermedPolicy){
            coverageStartDate = System.now().format('YYYY-MM-dd');
        }
        rcWrapper = ACET_ReadConsumerEligibilityService.call_RCED_API(subscriberId, policyNumber, sourceCode, coverageLevel, coverageStartDate);
        // }

        if(rcWrapper.networkKey != null){
            wrapper.networkKey = rcWrapper.networkKey;

            if((rcWrapper.networkKey == 'M') || (rcWrapper.networkKey == 'T') || (rcWrapper.networkKey == 'X') || (String.isBlank(rcWrapper.networkKey))){
                wrapper.callENIContracts = true;
                wrapper.success = true;
            } else{
                wrapper.callENIContracts = false;
                wrapper.success = true;
            }

        } else{
            wrapper.errorMessage = 'Failed to retrieve Network Key';
            wrapper.success = false;
        }

        return wrapper;
    }

    @AuraEnabled
    public static ACET_EAndIProviderStatusWrapper getEAndIProviderStatus(String providerId, String taxId, String addressSeq, String marketType, String marketSite, String insTypeCode, String networkKey){
        
        ACET_EAndIProviderStatusWrapper wrapper = new ACET_EAndIProviderStatusWrapper();

            // list to store the contract data
            List<ACET_EAndIContractDataWrapper> contractDataWrapperList = new List<ACET_EAndIContractDataWrapper>();
            // get e and i contract data from api
            ACET_ProviderContractService providerContractService = new ACET_ProviderContractService();
            ACETWSCalloutResult calloutResult = providerContractService.getEAndIContracts(providerId, taxId, addressSeq, marketType, marketSite, insTypeCode, true);
			Map<string,Object> detailsMap = new Map<string,Object>();
        	detailsMap.put('Product',insTypeCode);
        	detailsMap.put('Market Type',marketType);
       		detailsMap.put('Market',marketSite);
            if(calloutResult.Success){
                try{
                    ACET_EAndIContractsResponse contractResponse = (ACET_EAndIContractsResponse) calloutResult.Response;
                    string strIPAValue= '--';
                    if(contractResponse.employerandindividual.size() > 0){
                        List<String> dateArr = contractResponse.employerandindividual[0].pnc_canc_dt.split('-');
                        Date cancelDate = Date.newInstance(Integer.valueOf(dateArr[0]), Integer.valueOf(dateArr[1]), Integer.valueOf(dateArr[2]));
                        Date today = Date.today();
                         if (string.isNotBlank(contractResponse.employerandindividual[0].pnc_ipa_nbr) && contractResponse.employerandindividual[0].pnc_ipa_nbr.length() == 1) {
                             strIPAValue =  '00' + contractResponse.employerandindividual[0].pnc_ipa_nbr + ',' + contractResponse.employerandindividual[0].pnc_ipa_desc;

                        } else {
                            strIPAValue= contractResponse.employerandindividual[0].pnc_ipa_nbr + ', ' + contractResponse.employerandindividual[0].pnc_ipa_desc;

                        }
                        detailsMap.put('IPA',strIPAValue);
                        if(cancelDate > today) {
                            wrapper.success = true;
                            wrapper.eniCardDetails = ACET_ProviderStatusCtrl.getENICardDetails('Provider Status ('+ SAEUtils.formatDate(contractResponse.employerandindividual[0].pnc_eff_dt) + ' - ' + SAEUtils.formatDate(contractResponse.employerandindividual[0].pnc_canc_dt) +')',
                                                                                               'INN', networkKey, 'Match', 'action:approval',detailsMap);
                            return wrapper;

                        } else {
                            wrapper.success = true;
                            wrapper.eniCardDetails = ACET_ProviderStatusCtrl.getENICardDetails('Provider Status (--)', 'OON', networkKey, 'Match', 'action:approval',detailsMap);
                            return wrapper;
                        }

                    } else{
                        wrapper.success = true;
                        wrapper.eniCardDetails = ACET_ProviderStatusCtrl.getENICardDetails('Provider Status (--)', 'OON', networkKey, 'No Match', 'action:close',detailsMap);

                        return wrapper;
                    }
                } catch(Exception ex){
                ACET_EAndIProviderStatusWrapper exceptionWrapper = new ACET_EAndIProviderStatusWrapper();
                exceptionWrapper.success = false; exceptionWrapper.errorMessage = 'Failed to retrieve E and I contracts';
                return exceptionWrapper;
            }
        } else{
            wrapper.success = false; wrapper.errorMessage = 'Failed to retrieve E and I contracts';
            return wrapper;
        }
    }

     @AuraEnabled
    public static ACET_EAndIProviderStatusWrapper getEAndIProviderStatusNew(String providerId, String taxId, String addressSeq, String marketType, String marketSite, String insTypeCode, String networkKey,string ipaValue){
        system.debug('=ipaValue'+ipaValue);
        ACET_EAndIProviderStatusWrapper wrapper = new ACET_EAndIProviderStatusWrapper();
        Map<string,Object> detailsMap = new Map<string,Object>();
        detailsMap.put('Product',insTypeCode);
        detailsMap.put('Market Type',marketType);
        detailsMap.put('Market',marketSite);

        if( networkKey.equalsIgnoreCase('M') || networkKey.equalsIgnoreCase('X') || string.isBlank(networkKey) ){ marketSite = null; }

        if(networkKey.equalsIgnoreCase('X')) {marketType = null;}

        // list to store the contract data
            List<ACET_EAndIContractDataWrapper> contractDataWrapperList = new List<ACET_EAndIContractDataWrapper>();
            // get e and i contract data from api
            ACET_ProviderContractService providerContractService = new ACET_ProviderContractService();
            ACETWSCalloutResult calloutResult = providerContractService.getEAndIContracts(providerId, taxId, addressSeq, marketType, marketSite, insTypeCode, true);

           if(calloutResult.Success){
                try{

                    ACET_EAndIContractsResponse contractResponse = (ACET_EAndIContractsResponse) calloutResult.Response;
                    if(string.isNotBlank(ipaValue)){
                        //ipaValue= ipaValue.remove('(').remove(')').remove(',');
                        //List<string> lstOfstrings = ipaValue.split(' ');
                        //ipaValue = lstOfstrings.get(lstOfstrings.indexof('IPA')+1);
                        ipaValue = processIPAString(ipaValue);
                        if(networkKey.equalsIgnoreCase('M')) detailsMap.put('IPA',ipaValue);
                    }

                    if(contractResponse.employerandindividual != null && !contractResponse.employerandindividual.isEmpty() && networkKey.equalsIgnoreCase('M') && string.isNotBlank(ipaValue) ){
                        List<ACET_EAndIContractsResponse.Employerandindividual> returnList = processIPAResults(contractResponse.employerandindividual,ipaValue);
                        if(!returnList.isEmpty()){
                            contractResponse.employerandindividual = returnList;
                            detailsMap.put('IPAFound',true);
                        }
                    }
                    string strIPAValue= '--';
                    if(contractResponse.employerandindividual != null && !contractResponse.employerandindividual.isEmpty()){
                        system.debug('=rec='+contractResponse.employerandindividual[0]);
                        List<String> dateArr = contractResponse.employerandindividual[0].pnc_canc_dt.split('-');
                        Date cancelDate = Date.newInstance(Integer.valueOf(dateArr[0]), Integer.valueOf(dateArr[1]), Integer.valueOf(dateArr[2]));
                        Date today = Date.today();
                        if (string.isNotBlank(contractResponse.employerandindividual[0].pnc_ipa_nbr) && contractResponse.employerandindividual[0].pnc_ipa_nbr.length() == 1) {
                             strIPAValue =  '00' + contractResponse.employerandindividual[0].pnc_ipa_nbr + ',' + contractResponse.employerandindividual[0].pnc_ipa_desc;

                        } else {
                            strIPAValue= contractResponse.employerandindividual[0].pnc_ipa_nbr + ', ' + contractResponse.employerandindividual[0].pnc_ipa_desc;

                        }
                        if(!networkKey.equalsIgnoreCase('M')){ detailsMap.put('IPA',strIPAValue);}
                        if(cancelDate > today) {
                            wrapper.success = true;
                            wrapper.eniCardDetails = ACET_ProviderStatusCtrl.getENICardDetails('Provider Status ('+ SAEUtils.formatDate(contractResponse.employerandindividual[0].pnc_eff_dt) + ' - ' + SAEUtils.formatDate(contractResponse.employerandindividual[0].pnc_canc_dt) +')',
                                                                                               'INN', networkKey, 'Match', 'action:approval',detailsMap);
                            return wrapper;

                        } else {
                            wrapper.success = true;
                            wrapper.eniCardDetails = ACET_ProviderStatusCtrl.getENICardDetails('Provider Status (--)', 'OON', networkKey, 'Match', 'action:approval',detailsMap);
                            return wrapper;
                        }

                    } else{
                        wrapper.success = true;
                        wrapper.eniCardDetails = ACET_ProviderStatusCtrl.getENICardDetails('Provider Status (--)', 'OON', networkKey, 'No Match', 'action:close',detailsMap);

                        return wrapper;
                    }
                } catch(Exception ex){
                ACET_EAndIProviderStatusWrapper exceptionWrapper = new ACET_EAndIProviderStatusWrapper();
                exceptionWrapper.success = false; exceptionWrapper.errorMessage = 'Failed to retrieve E and I contracts';
                return exceptionWrapper;
            }
        } else{
            wrapper.success = false; wrapper.errorMessage = 'Failed to retrieve E and I contracts';
            return wrapper;
        }
    }

    public static string processIPAString(string strInput){
        System.debug('@strInput@'+strInput);
        string returnStr = '';
        Integer index = 0;
        if(string.isNotBlank(strInput)){
            List<string> lstOfstrings = strInput.split(' ');
            if(lstOfstrings != null && !lstOfstrings.isEmpty()){
                for(string  st: lstOfstrings){
                    st = st.remove('(').remove(')');
                    if(st.contains('IPA')){
                        if(st.length() == 3){
                            returnStr = (lstOfstrings.size() > (index+1))? lstOfstrings.get(index+1) : '';
                            returnStr = returnStr.remove('(').remove(')');
                        }
                        else{
                            returnStr = st.remove('IPA').remove('-').remove('/');
                        }
                        returnStr = returnStr.remove(',');
                        returnStr = returnStr.trim();
                    }
                    if(returnStr.isNumeric()) break;
                    else returnStr ='';
                    index = index+1;
                }
            }

        }
        System.debug('@returnIPAStr@'+returnStr);
        return returnStr;
    }

    public static List<ACET_EAndIContractsResponse.Employerandindividual> processIPAResults(List<ACET_EAndIContractsResponse.Employerandindividual> lstRecords,string ipaValue){
        List<ACET_EAndIContractsResponse.Employerandindividual> lstofResp = new List<ACET_EAndIContractsResponse.Employerandindividual>();
        for(ACET_EAndIContractsResponse.Employerandindividual each : lstRecords){
            System.debug('pnc_ipa_nbr: ' + each.pnc_ipa_nbr);
            if(string.isNotBlank(each.pnc_ipa_nbr)  && (Integer.valueof(each.pnc_ipa_nbr) ==  Integer.valueof(ipaValue))){
                lstofResp = new List<ACET_EAndIContractsResponse.Employerandindividual>{each};
                break;
            }
        }
        return lstofResp;
    }

    private static ACET_AutoDocUtil.CardDetails getENICardDetails(String cmpName, String status, String networkKey, String iconValue, String iconName, Map<string,Object> detailsMap ){
        ACET_AutoDocUtil.CardDetails cardDetails = new ACET_AutoDocUtil.CardDetails();
        cardDetails.type = 'card';
        cardDetails.componentName = cmpName;
        cardDetails.noOfColumns = 'slds-size_1-of-10';
        cardDetails.componentOrder = 7;
        cardDetails.cardData = new  List<ACET_AutoDocUtil.FieldDetails>();
        cardDetails.cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Status', detailsMap.get('IPAFound') != NULL  ? 'Tier 1' : status , 'outputText'));
        cardDetails.cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Network Key', string.isNotBlank(networkKey) ? networkKey : '--', 'outputText'));
        ACET_AutoDocUtil.FieldDetails product = new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Product', iconValue, 'iconWithText');
        product.iconName = iconName;
        product.iconText = detailsMap.get('Product') != NULL ? (string) detailsMap.get('Product') : '';
        cardDetails.cardData.add(product);
        ACET_AutoDocUtil.FieldDetails mktType = new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Market Type', iconValue, 'iconWithText');
        mktType.iconName = iconName;
        mktType.iconText =  detailsMap.get('Market Type') != NULL ? (string) detailsMap.get('Market Type') : '';
        if(!networkKey.equalsIgnoreCase('X')) {cardDetails.cardData.add(mktType);}
        // DE421882 - Thanish - 11th Mar 2021
        ACET_AutoDocUtil.FieldDetails market = new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Market', iconValue, 'iconWithText');
        market.iconName = iconName;
        market.iconText = detailsMap.get('Market') != NULL ? (string) detailsMap.get('Market') : '';
        if(!networkKey.equalsIgnoreCase('M') && !networkKey.equalsIgnoreCase('X') && string.isNotBlank(networkKey)) { cardDetails.cardData.add(market);}
        if(networkKey.equalsIgnoreCase('I') || networkKey.equalsIgnoreCase('P')){
            ACET_AutoDocUtil.FieldDetails ipa = new ACET_AutoDocUtil.FieldDetails(false, false, true, 'IPA', iconValue, 'iconWithText');
            ipa.iconName = iconName;
            ipa.iconText = detailsMap.get('IPA') != NULL ? (string) detailsMap.get('IPA') : '';
            cardDetails.cardData.add(ipa);
        }
        if(networkKey.equalsIgnoreCase('M')){
            ACET_AutoDocUtil.FieldDetails ipa = new ACET_AutoDocUtil.FieldDetails(false, false, true, 'IPA', detailsMap.get('IPAFound') != NULL  ? 'Match' : 'No Match', 'iconWithText');
            ipa.iconName = detailsMap.get('IPAFound') != NULL  ? 'action:approval' : 'action:close' ;
            ipa.iconText = detailsMap.get('IPA') != NULL ? (string) detailsMap.get('IPA') : '--';
            cardDetails.cardData.add(ipa);
        }

        return cardDetails;
    }

    @AuraEnabled
    public static ACET_MAndRProviderStatusWrapper getCnsProviderStatusDetails(string providerId, string taxId, string addressId, boolean isActive, string benefitPlanId) {
        string strCSPProviderValue = '';
        // get c and s contract data from api
        ACET_ProviderContractService providerContractService = new ACET_ProviderContractService();
        ACETWSCalloutResult calloutResult = providerContractService.getCAndSContracts(providerId, taxId, addressId, isActive);
        ACET_MAndRProviderStatusWrapper wrapper = new ACET_MAndRProviderStatusWrapper();
        if (calloutResult.Success) {
             // cast callout result to c and s contract response
            ACET_CAndSContractsResponse contractResponse = (ACET_CAndSContractsResponse) calloutResult.Response;
            if(contractResponse != null && contractResponse.communityandstate != null){
                for(ACET_CAndSContractsResponse.Communityandstate communityAndState : contractResponse.communityandstate) {
                    if(string.isNotBlank(communityAndState.csp_pltfm_prov_id) ){
                        strCSPProviderValue =communityAndState.csp_pltfm_prov_id;
                        break;
                    }
                }
            }
            system.debug('==strCSPProviderValue='+strCSPProviderValue);
            if(String.isBlank(strCSPProviderValue)) {
		    ACET_AutoDocUtil.CardDetails cardDetails = new ACET_AutoDocUtil.CardDetails();
		    cardDetails.type = 'card';
		    cardDetails.componentName = 'Provider Status (--)';
		    cardDetails.noOfColumns = 'slds-size_1-of-10';
		    cardDetails.componentOrder = 7;
		    cardDetails.cardData = new  List<ACET_AutoDocUtil.FieldDetails>();
		    cardDetails.cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Status', 'OON', 'outputText'));
		    ACET_AutoDocUtil.FieldDetails product = new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Network Prefix', 'No Match', 'iconWithText');
		    product.iconName = 'action:close';
		    product.iconText = '--';
		    cardDetails.cardData.add(product);
		    wrapper.mnrCardDetails = cardDetails;
		    return wrapper;
		}
            if(string.isNotBlank(strCSPProviderValue)){
                ACET_FacetsGETProviderContractsService facetCNSContractService = new ACET_FacetsGETProviderContractsService();
        		ACETWSCalloutResult calloutResultResponse = facetCNSContractService.getContractDetails(strCSPProviderValue);
                if (calloutResultResponse.Success) {
                    wrapper.success = true;
                  	ACET_FacetsGETProviderContractsResponse facetContractResponse = (ACET_FacetsGETProviderContractsResponse) calloutResultResponse.Response;
                    Date today = Date.today();
                    Date effectiveDate, termDate;
                    Boolean isMatched = false;
                    String networkPrefixCode = (String.isNotblank(benefitPlanId) ? benefitPlanId.substring(0, 4): '--'),strEffectiveDate, strTermDate;
                    for(ACET_FacetsGETProviderContractsResponse.InNetworkRelations objNetwork :  facetContractResponse.data.attributes.InNetworkRelations) {
                        effectiveDate = Date.valueof(objNetwork.effDate.split('T')[0]);
                        termDate = Date.valueof(objNetwork.termDate.split('T')[0]);
                        strEffectiveDate = objNetwork.effDate.split('T')[0];
                        strTermDate = objNetwork.termDate.split('T')[0];
                        if(benefitPlanId.contains(objNetwork.networkPrefix.code) && termDate > today ){
                            effectiveDate = Date.valueof(objNetwork.effDate.split('T')[0]);
                        	termDate = Date.valueof(objNetwork.termDate.split('T')[0]);
                            isMatched = true;
                            break;
                        }
                    }
                    if(isMatched) {
                        ACET_AutoDocUtil.CardDetails cardDetails = new ACET_AutoDocUtil.CardDetails();
                        cardDetails.type = 'card';
                        cardDetails.componentName = 'Provider Status ('+ SAEUtils.formatDate(strEffectiveDate) + ' - ' + SAEUtils.formatDate(strTermDate) +')';
                        cardDetails.noOfColumns = 'slds-size_1-of-10';
                        cardDetails.componentOrder = 7;
                        cardDetails.cardData = new  List<ACET_AutoDocUtil.FieldDetails>();
                        cardDetails.cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Status', 'INN', 'outputText'));
                        ACET_AutoDocUtil.FieldDetails product = new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Network Prefix', 'Match', 'iconWithText');
                        product.iconName = 'action:approval';
                        product.iconText = networkPrefixCode;
                        cardDetails.cardData.add(product);
                        wrapper.mnrCardDetails = cardDetails;
                    }else {
                        ACET_AutoDocUtil.CardDetails cardDetails = new ACET_AutoDocUtil.CardDetails();
                        cardDetails.type = 'card';
                        cardDetails.componentName = 'Provider Status (--)';
                        cardDetails.noOfColumns = 'slds-size_1-of-10';
                        cardDetails.componentOrder = 7;
                        cardDetails.cardData = new List < ACET_AutoDocUtil.FieldDetails > ();
                        cardDetails.cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Status', 'OON', 'outputText'));
                        ACET_AutoDocUtil.FieldDetails product = new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Network Prefix', 'No Match', 'iconWithText');
                        product.iconName = 'action:close';
                        product.iconText = networkPrefixCode;
                        cardDetails.cardData.add(product);
                        wrapper.mnrCardDetails = cardDetails;
                    }
                }
            }
        }
        return wrapper;
    }

    public class ACET_NetworkKeyStatusWrapper{
        @AuraEnabled public Boolean callENIContracts;
        @AuraEnabled public Boolean success;
        @AuraEnabled public String networkKey;
        @AuraEnabled public String errorMessage;

        public ACET_NetworkKeyStatusWrapper(){
            this.callENIContracts = false; this.success = false; this.errorMessage = ''; this.networkKey = '';
        }
    }

    public class ACET_MAndRProviderStatusWrapper{
        @AuraEnabled public Boolean isMNREmpty;
        @AuraEnabled public ACET_AutoDocUtil.CardDetails mnrCardDetails;
        // US3291595 - Err Code handling
        @AuraEnabled public Boolean success;
        @AuraEnabled public ACET_MAndRContractsResponse contractResponse;
        @AuraEnabled public String contractNum;
        public ACET_MAndRProviderStatusWrapper(){
            this.isMNREmpty = false;
            this.success = false;
        }
    }

    public class ACET_EAndIProviderStatusWrapper{
        @AuraEnabled public ACET_AutoDocUtil.CardDetails eniCardDetails;
        @AuraEnabled public Boolean success;
        @AuraEnabled public String errorMessage;

        public ACET_EAndIProviderStatusWrapper(){
            this.success = false; this.errorMessage = '';
        }
    }

    // US3244384 Integration for Member Div to Provider Div Mapping - Sarma - 01/03/2021
    /*public static String convertCosmosDiv (String memberDiv, String coverageStartDate, String coverageEndDate){

        String providerDiv ='';
        Date startDate = Date.today();
        Date cancelDate = Date.today();

        if(coverageStartDate != null && String.isNotBlank(coverageStartDate) && coverageStartDate != '--'){
            List<String> startDateArr = coverageStartDate.split('-');
            if(startDateArr.size() == 3){
                startDate = Date.newInstance(Integer.valueOf(startDateArr[0]), Integer.valueOf(startDateArr[1]), Integer.valueOf(startDateArr[2]));
            }
        }
        if(coverageEndDate != null && String.isNotBlank(coverageEndDate) && coverageEndDate != '--'){
            List<String> cancelDateArr = coverageEndDate.split('-');
            if(cancelDateArr.size() == 3){
                cancelDate = Date.newInstance(Integer.valueOf(cancelDateArr[0]), Integer.valueOf(cancelDateArr[1]), Integer.valueOf(cancelDateArr[2]));
            }
        }

        List<ACET_ProviderDivConversionCombination__mdt> providerMappingList = new List<ACET_ProviderDivConversionCombination__mdt>();
        try {
            providerMappingList = [SELECT DeveloperName,MasterLabel,Provider_Div__c,Member_Div__c,Start_Date__c,Cancel_Date__c FROM ACET_ProviderDivConversionCombination__mdt WHERE
                                            Member_Div__c = :memberDiv AND Start_Date__c <= :startDate AND Cancel_Date__c >= : cancelDate];

            if(providerMappingList.size() > 0){
                providerDiv = providerMappingList[0].Provider_Div__c;
                System.debug('providerDiv:: ' + providerMappingList[0].Provider_Div__c);
            }
        } catch(Exception e) {
            System.debug('Exception:: '+ e.getMessage());
        }
        return providerDiv;
    }*/
}