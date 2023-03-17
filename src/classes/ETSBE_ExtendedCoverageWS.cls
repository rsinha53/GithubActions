public class ETSBE_ExtendedCoverageWS {
	public ACETWSCalloutResult getPolicyWS(String transactionId){
    	system.debug('transactionId:::' + transactionId);
        ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();

        //SAEProviderMemberSearchInteractionResult returnResponse = new SAEProviderMemberSearchInteractionResult();
        ETSBE_PolicyDetailsResults pResponse = new ETSBE_PolicyDetailsResults();
        try{

            String reqMethod='GET';
            HttpResponse response;
            String endPoint = ISL_Webservice_Config__c.getInstance('SAE_PolicySearch').Value__c;
            String resultQuery = '?transactionId='+EncodingUtil.urlEncode(transactionId, 'UTF-8'); //DE282083 - 05/12/2019 - Sarma
            system.debug('resultQuery::: ' + resultQuery);

            String responseStr = '';
            StaticResource responseJSONSR = null;
            String responseBody;

            response = SAEWebservice.makeCallout(resultQuery,endPoint,reqMethod);
            system.debug('response WS:::'+response);
            calloutResult.statusCode= response.getStatusCode();
            responseStr = response.getBody();

			system.debug('responseStr WS:::'+response.getBody());

            if(responseStr != null && String.isNotBlank(responseStr)){

                //calloutResult.statusCode= response.getStatusCode();

                Map<String, Object> policyMainMap = (Map<String, Object>)JSON.deserializeUntyped(responseStr);
                //Attributes will no longer be used
                //Map<String, Object> policyAttrMap = (Map<String, Object>)policyMainMap.get('attributes');
                Map<String, Object> policyAddPlanDetMap = (Map<String, Object>)policyMainMap.get('additionalPlanDetails');

                //Removed due to inconsistency of data
                //SAEPolicyDetailsJsonToApex json2Apex = SAEPolicyDetailsJsonToApex.parse(responseStr);
                SAEPolicyDetailsJsonToApex json2Apex;
                ETSBE_PolicyDetailsResults.policyResults respToReturn = new ETSBE_PolicyDetailsResults.policyResults();

                //US - After Extended Service changed - Lahiru
                if (!policyMainMap.isEmpty()){
                    String localSourceCode = (String) policyMainMap.get('sourceCode');

                    //US1827051 - Show only core fields - Sanka - 06/06/2019
                    respToReturn.showAllFields = true;

                    if (localSourceCode == 'CO'){
                        respToReturn.isMedicarePlan = true;
                        respToReturn.isPHSPlan = false;
                        respToReturn.isComPlan = false;
                        respToReturn.isMedicaidPlan = false;

                        //US1827051 - Show only core fields - Sanka - 06/06/2019
                        respToReturn.showAllFields = true;
                    }else if (localSourceCode == 'PA'){
                        respToReturn.isPHSPlan = true;
                        respToReturn.isMedicarePlan = false;
                        respToReturn.isComPlan = false;
                        respToReturn.isMedicaidPlan = false;

                        //US1827051 - Show only core fields - Sanka - 06/06/2019
                        respToReturn.showAllFields = true;
                    }else if (localSourceCode == 'CS'){
                        respToReturn.isComPlan = true;
                        respToReturn.isMedicarePlan = false;
                        respToReturn.isMedicaidPlan = false;
                        respToReturn.isPHSPlan = false;

                        //US1827051 - Show only core fields - Sanka - 06/06/2019
                        respToReturn.showAllFields = true;
                    }else if (localSourceCode == 'AP'){
                        respToReturn.isMedicaidPlan = true;
                        respToReturn.isMedicarePlan = false;
                        respToReturn.isPHSPlan = false;
                        respToReturn.isComPlan = false;

                        //US1827051 - Show only core fields - Sanka - 06/06/2019
                        respToReturn.showAllFields = true;
                    }else if(localSourceCode == '' || localSourceCode == null){
                        //US1827051 - Show only core fields - Sanka - 06/06/2019
                        respToReturn.showAllFields = false;
                    }


                    respToReturn.productType = (String) policyMainMap.get('productType');
                    //mapping change for fundingType with schema change
                    respToReturn.fundingType = (String) policyAddPlanDetMap.get('fundingType');
                    respToReturn.groupNumber = (String) policyMainMap.get('groupNumber');

                    //USS2221006 - START
                    if(String.isBlank(respToReturn.groupNumber) || respToReturn.groupNumber.contains('N/A')) {
                        respToReturn.groupNumber = (String) policyMainMap.get('policyNumber');
                    }
                    //USS2221006 - END

                    respToReturn.marketType = (String) policyMainMap.get('marketType');
                    respToReturn.stateOfIssueCode = (String) policyMainMap.get('stateOfIssueCode');  //Health Plan
                    respToReturn.productId = (String) policyMainMap.get('productID');	//Network Type
                    respToReturn.cosmosDivision = (String) policyMainMap.get('cosmosDivision');    //DIV
                    respToReturn.groupPanelNumber = (String) policyMainMap.get('groupPanelNumber');
                    respToReturn.xrefId = policyMainMap.containsKey('xrefId') ? (String) policyMainMap.get('xrefId') : ''; //US2154799
					 respToReturn.homeTelephoneNumber = policyMainMap.containsKey('homeTelephoneNumber') ? (String) policyMainMap.get('homeTelephoneNumber') : '';
		    //US1901028	- Member CDHP Integration - Sarma - 29/08/2019 : Start
                    if((String)policyAddPlanDetMap.get('cdhp') != null ){
                        if((String)policyAddPlanDetMap.get('cdhp') == 'YES'){
                            respToReturn.isCdhp = true;
                            if((String)policyAddPlanDetMap.get('hsa') != null ){
                                if((String)policyAddPlanDetMap.get('hsa') == 'YES'){
                                 	respToReturn.isHsa = true;
                                } else{ respToReturn.isHsa = false; }
                            } else{ respToReturn.isHsa = false; }

                        } else{
                            respToReturn.isCdhp = false;
                            respToReturn.isHsa = false;
                        }
                    } else {
                        respToReturn.isCdhp = false;
                        respToReturn.isHsa = false;
                    }
                    //US1901028	- Member CDHP Integration : End

                    //
                    System.debug('@@ SAEExtendedCoverageWS: respToReturn.stateOfIssueCode: ' + respToReturn.stateOfIssueCode);
                    try{
                        respToReturn.HealthPlanSite = [SELECT Link__c FROM Healthplan_Site__mdt WHERE Label = :respToReturn.stateOfIssueCode LIMIT 1].Link__c;
                        System.debug('@@ SAEExtendedCoverageWS: respToReturn.HealthPlanSite try: ' + respToReturn.HealthPlanSite);
                        if(respToReturn.HealthPlanSite == null) {
                            respToReturn.HealthPlanSite = '';
                        }
                    } catch(Exception e) {
                        respToReturn.HealthPlanSite = '';
                        System.debug('@@ SAEExtendedCoverageWS: respToReturn.HealthPlanSite catch: ' + respToReturn.HealthPlanSite);
                    }
                    //

                    pResponse.policyRes = respToReturn;

                    //Add other related List <Household etc...>
                    //returnResponse.houseHold = houseHoldList;

                    calloutResult.Success = true;
                    calloutResult.Message = '';
                    calloutResult.Response = pResponse;

                }


                /*
                 * Removing below according to the schema change - Lahiru
                 *
                 * system.debug('policyAttrMap:: '+policyMainMap);
                if (!policyAttrMap.isEmpty()){

                    SAEPolicyDetailsJsonToApex.Attributes policyAttr = new SAEPolicyDetailsJsonToApex.Attributes();
                    respToReturn.sourceCode = (String) policyAttrMap.get('sourceCode');
                    system.debug('respToReturn.sourceCode:::'+respToReturn.sourceCode);

                    //US1827051 - Show only core fields - Sanka - 06/06/2019
                    respToReturn.showAllFields = true;

                    if (respToReturn.sourceCode == 'CO'){
                        respToReturn.isMedicarePlan = true;
                        respToReturn.isPHSPlan = false;
                        respToReturn.isComPlan = false;
                        respToReturn.isMedicaidPlan = false;

                        //US1827051 - Show only core fields - Sanka - 06/06/2019
                        respToReturn.showAllFields = true;
                    }else if (respToReturn.sourceCode == 'PA'){
                        respToReturn.isPHSPlan = true;
                        respToReturn.isMedicarePlan = false;
                        respToReturn.isComPlan = false;
                        respToReturn.isMedicaidPlan = false;

                        //US1827051 - Show only core fields - Sanka - 06/06/2019
                        respToReturn.showAllFields = true;
                    }else if (respToReturn.sourceCode == 'CS'){
                        respToReturn.isComPlan = true;
                    	respToReturn.isMedicarePlan = false;
                    	respToReturn.isMedicaidPlan = false;
                    	respToReturn.isPHSPlan = false;

                        //US1827051 - Show only core fields - Sanka - 06/06/2019
                        respToReturn.showAllFields = true;
                    }else if (respToReturn.sourceCode == 'AP'){
                        respToReturn.isMedicaidPlan = true;
                        respToReturn.isMedicarePlan = false;
                        respToReturn.isPHSPlan = false;
                        respToReturn.isComPlan = false;

                        //US1827051 - Show only core fields - Sanka - 06/06/2019
                        respToReturn.showAllFields = true;
                    }else if(respToReturn.sourceCode == '' || respToReturn.sourceCode == null){
                        //US1827051 - Show only core fields - Sanka - 06/06/2019
                       respToReturn.showAllFields = false;
                    }

                    //(String) policyAttrMap.get('sourceCode')
                    respToReturn.productType = (String) policyAttrMap.get('productType');
                    respToReturn.fundingType = (String) policyAttrMap.get('fundingType');
                    respToReturn.groupNumber = (String) policyAttrMap.get('groupNumber');
                    respToReturn.marketType = (String) policyAttrMap.get('marketType');
                    respToReturn.stateOfIssueCode = (String) policyAttrMap.get('stateOfIssueCode');     //Health Plan
                    respToReturn.productId = (String) policyAttrMap.get('productID');  //Network Type
                    respToReturn.cosmosDivision = (String) policyAttrMap.get('cosmosDivision');    //DIV
                    system.debug('respToReturn.cosmosDivision::'+respToReturn.cosmosDivision);
                    respToReturn.groupPanelNumber = (String) policyAttrMap.get('groupPanelNumber');

                    pResponse.policyRes = respToReturn;

                    calloutResult.Success = true;
                    calloutResult.Message = '';
                    calloutResult.Response = pResponse;

                }
                */

                /*
                if(json2Apex != null){
                    if(json2Apex.Attributes != null){
                        SAEPolicyDetailsJsonToApex.Attributes policyAttr = new SAEPolicyDetailsJsonToApex.Attributes();
                        system.debug('policyAttr::'+policyAttr.groupPanelNumber);
                        policyAttr = json2Apex.Attributes;

                        respToReturn.sourceCode = policyAttr.sourceCode;

                        if (policyAttr.sourceCode == 'CO')
                            respToReturn.isMedicarePlan = true;
                        else if (policyAttr.sourceCode == 'PA')
                            respToReturn.isPHSPlan = true;
                        else if (policyAttr.sourceCode == 'CS')
                            respToReturn.isComPlan = true;
                        else if (policyAttr.sourceCode == 'AP')
                            respToReturn.isMedicaidPlan = true;

                        respToReturn.productType = policyAttr.productType;
                        respToReturn.fundingType = policyAttr.fundingType;
                        respToReturn.groupNumber = policyAttr.groupNumber;
                        respToReturn.marketType = policyAttr.marketType;
                        respToReturn.stateOfIssueCode = policyAttr.stateOfIssueCode;    //Health Plan
                        respToReturn.productId = policyAttr.productId;  //Network Type
                        respToReturn.cosmosDivision = policyAttr.cosmosDivision;    //DIV
                        respToReturn.groupPanelNumber = policyAttr.groupPanelNumber;

						pResponse.policyRes = respToReturn;

                    }





                    //Add other related List <Household etc...>
                    //returnResponse.houseHold = houseHoldList;

                    calloutResult.Success = true;
                    calloutResult.Message = '';
                    calloutResult.Response = pResponse;

                }
                */

            }
        }catch(Exception e){
            system.debug(e.getStackTraceString());
            calloutResult.MessageSeverity = ApexPages.Severity.ERROR;
            calloutResult.Success = false;
            calloutResult.Message = 'Web Service or External System is temporarily unavailable.';
            calloutResult.statusCode=999;
           }
        system.debug('Callout Res::: ' + calloutResult);
        return calloutResult;
    }

    //US1974546 - Coverage Level Integration
    //Sanka Dharmasena - 28/08/2019
    public static ETSBE_PolicyDetailsResults.ProviderCoverageLevel getCoverageLevel(String transactionId)
    {
        ETSBE_PolicyDetailsResults.ProviderCoverageLevel CoverageResult = new ETSBE_PolicyDetailsResults.ProviderCoverageLevel();
        try
        {
            String reqMethod='GET';
            HttpResponse response;
            
            String responseStr = '';
            StaticResource responseJSONSR = null;
            String responseBody;

            
            Boolean isStaticResponseChecked = SAEUtils.getMockStatus();
            System.debug('@@ SAEMemberStandaloneSearchWebService: findIndividual: isStaticResponseChecked: '+isStaticResponseChecked);
            
            if(isStaticResponseChecked && !Test.isRunningTest()) {
                
                String searchparameter = 'ExtendedCoverage_' + transactionId.remove('-').remove('%').substring(0, 23);
                system.debug(':: searchparameter :: '+searchparameter);
                response = SAEUtils.getResponse(searchparameter);
                responseStr = response.getBody();
            } else{
                String endPoint = ISL_Webservice_Config__c.getInstance('SAE_PolicySearch').Value__c;
                String resultQuery = '?transactionId='+EncodingUtil.urlEncode(transactionId, 'UTF-8'); //DE282083 - 05/12/2019 - Sarma
                                
                response = SAEWebservice.makeCallout(resultQuery,endPoint,reqMethod);
                
                CoverageResult.StatusCode = response.getStatusCode();
                CoverageResult.Message = response.getStatus();
                
                responseStr = response.getBody();
            }
                        
            if(responseStr != null && !String.isEmpty(responseStr) && response.getStatusCode() == 200)
            {
                Map<String, Object> policyMainMap = (Map<String, Object>)JSON.deserializeUntyped(responseStr);
                String CoverageLevel = (String) policyMainMap.get('coverageLevel');
                if(SAEConstants.COVERAGELEVEL.get(CoverageLevel) != null){
                    CoverageResult.CoverageLevel = SAEConstants.COVERAGELEVEL.get(CoverageLevel);
                }else{
                    CoverageResult.CoverageLevel = CoverageLevel;
                }
                CoverageResult.Success = true;

               
                //USS2221006 - START
                String strGroupNumber = (String) policyMainMap.get('groupNumber');
                String strPolicyNumber = (String) policyMainMap.get('policyNumber');
                if(String.isBlank(strGroupNumber) || strGroupNumber.contains('N/A')) {
                    CoverageResult.GroupNumber = strPolicyNumber;
                }
                //USS2221006 - END
            }
            else
            {
                CoverageResult.Success = false;
                CoverageResult.CoverageLevel = '--';
            }
        }
        catch (Exception e)
        {
            CoverageResult.CoverageLevel = '--';
            CoverageResult.Success = false;
            CoverageResult.Message = 'Web Service or External System is temporarily unavailable.';
            CoverageResult.StatusCode = 999;
        }

        return CoverageResult;
    }
}