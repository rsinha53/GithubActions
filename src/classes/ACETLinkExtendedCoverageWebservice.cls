/*
    Created By: Chandan Patro
    Created Date: 06th August 2019
    Description: This class is used to get all the data from Link Eligibility Api.
*/

public with sharing class ACETLinkExtendedCoverageWebservice { 

    public ACETWSCalloutResult getHouseHoldData(String transactionId){

        system.debug('transactionId:::' + transactionId);

        ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();
        ACETHouseHoldWrapper houseHoldDataWrapper = new ACETHouseHoldWrapper();
        ACETHouseHoldWrapper.HouseHold houseObj;
        ACETHouseHoldWrapper.addressInfo houseAddObj;
        List<ACETHouseHoldWrapper.HouseHold> houseHoldLine = new List<ACETHouseHoldWrapper.HouseHold>();
        try{
            Integer i=0;
            //Code Added by Chandan for Static Resource update-	US2044089 -Start
            system.debug('In Link Extende Web service** ');
            HttpResponse response =null;
            Map < String, String > requestParamsMap = new Map < String, String > ();
            Map<String, ACETOrgInstanceURLToOrgNameMap__c> OrgInstance2OrgNameMap = ACETOrgInstanceURLToOrgNameMap__c.getAll();
            String OrgName = Test.isRunningTest() ? 'dev' : ACETUtility.GetOrgName(OrgInstance2OrgNameMap);
            //*Below Code Added by Chandan to switch to static resourse any time-US2044089 */
            String responseStr=AcetUtility.getStaticResponseCheck(null,null,null,null,null,null,transactionId,OrgName);
            if(String.isNotBlank(responseStr)){
                if(responseStr=='Checked'){
                    response=new HttpResponse();
                    response.setBody('Checked');
                    response.setStatusCode(500);
                }
                else{
                    response=new HttpResponse();
                    response.setBody(responseStr);
                    response.setStatusCode(200);
                }
            }
            else{
                requestParamsMap.put('transactionId', String.isNotBlank(transactionId) ? transactionId : '');
                ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework();
                wsCallOutFW.serviceName = 'LinkExtendedCoverage';
                wsCallOutFW.requestParamsMap = requestParamsMap;
                wsCallOutFW.encodeURLParameters = true;        
                response = wsCallOutFW.getResponse();
                //response=Send(OAuthConfig,'LinkApi');
                System.debug('response='+response);
                responseStr = response!=null?response.getBody():'';
            }
            //Code Added by Chandan for Static Resource update-	US2044089 -End
            system.debug('ResponseBody** ' + responseStr);
            if(responseStr != null && String.isNotBlank(responseStr) && response.getStatusCode()== 200){
                String responseSt = responseStr.trim().replace('\uFEFF', '');
				System.debug('responseString'+responseSt);
                Map<String, Object> policyMainMap = (Map<String, Object>)JSON.deserializeUntyped(responseSt);
                String policyNumber;
                String cosmosDivision;
                String sourceCode;
                Map<String, Object> policyMemInfoMap;
                Map<String, Object> policyMemAddressMap;
                if(policyMainMap!=null){
                	policyNumber=policyMainMap.get('policyNumber')!=null?(String)policyMainMap.get('policyNumber'):'';
                    cosmosDivision = policyMainMap.get('cosmosDivision')!=null?(String)policyMainMap.get('cosmosDivision'):'';
                    sourceCode = policyMainMap.get('sourceCode')!=null?(String)policyMainMap.get('sourceCode'):'';
                	system.debug('policyNumber** ' + policyNumber);
                	policyMemInfoMap = policyMainMap.get('memberInfo')!=null?(Map<String, Object>)policyMainMap.get('memberInfo'):null;
                     System.debug('Address==='+policyMainMap.get('postalAddress'));
                    policyMemAddressMap=policyMainMap.get('postalAddress') != null?(Map<String, Object>)policyMainMap.get('postalAddress'):null;
                }
                if (policyMemAddressMap!=null && !policyMemAddressMap.isEmpty()){
                    houseAddObj = new ACETHouseHoldWrapper.addressInfo();
                    houseAddObj.city = policyMemAddressMap.get('city')!=null?(String)policyMemAddressMap.get('city'):'';
                    houseAddObj.country =policyMemAddressMap.get('country')!=null?(String)policyMemAddressMap.get('country'):'';
                    houseAddObj.state = policyMemAddressMap.get('state')!=null?(String)policyMemAddressMap.get('state'):'';
                    houseAddObj.street =policyMemAddressMap.get('street1')!=null?(policyMemAddressMap.get('street2')!=null ?(String)policyMemAddressMap.get('street1')+''+(String)policyMemAddressMap.get('street2'):(String)policyMemAddressMap.get('street1')):'';
                   // houseAddObj.street2 = policyMemAddressMap.get('street2')!=null?(String)policyMemAddressMap.get('street2'):'';
                    houseAddObj.zip =policyMemAddressMap.get('zip')!=null?(String)policyMemAddressMap.get('zip'):'';

                }
                if (policyMemInfoMap!=null && !policyMemInfoMap.isEmpty()){
                    //Code For Subscriber
                    houseObj = new ACETHouseHoldWrapper.HouseHold();
                    houseObj.PolicyId=String.isNotBlank(policyNumber)?policyNumber:'';
                    houseObj.cosmosDivision=String.isNotBlank(cosmosDivision)?cosmosDivision:'';
                    houseObj.sourceCode=String.isNotBlank(sourceCode)?sourceCode:'';
                    houseObj.firstName = policyMemInfoMap.get('firstName')!=null?(String)policyMemInfoMap.get('firstName'):'';
                    houseObj.lastName =  policyMemInfoMap.get('lastName')!=null?(String)policyMemInfoMap.get('lastName'):'';
                    houseObj.fullName = houseObj.firstName + ' ' + houseObj.lastName;
                    houseObj.isMainMember = true;
                    String dobStr = policyMemInfoMap.get('dob')!=null?(String)policyMemInfoMap.get('dob'):'';
                    if(String.isNotBlank(dobStr)){
                        houseObj.dob = AcetUtility.formatDate(dobStr);
                    }
                    houseObj.relationship = policyMemInfoMap.get('relationship')!=null?(String)policyMemInfoMap.get('relationship'):'';
                    houseObj.memberId = policyMemInfoMap.get('memberID')!=null?(String)policyMemInfoMap.get('memberID'):'';
                    houseObj.address = houseAddObj ;
                    houseObj.gender = policyMemInfoMap.get('genderCode')!=null?(String)policyMemInfoMap.get('genderCode'):'';
                    houseHoldLine.add(houseObj);

                    //Add other Members
                    List<Object> familyMembers = (List<Object>) policyMemInfoMap.get('members');
                    system.debug('memberInfo@@ ' + familyMembers);
                    if(familyMembers!=null && familyMembers.size()>0){
                     for(Object member : familyMembers){
                        Map<String,Object> houseHoldObj = (Map<String,Object>)member;
                        system.debug('houseHoldObj@@@' + houseHoldObj);
                        houseObj.PolicyId=String.isNotBlank(policyNumber)?policyNumber:'';
                        houseObj = new ACETHouseHoldWrapper.HouseHold();
                        houseObj.firstName = houseHoldObj.get('firstName')!=null?(String)houseHoldObj.get('firstName'):'';
                        houseObj.lastName = houseHoldObj.get('lastName')!=null?(String)houseHoldObj.get('lastName'):'';
                        houseObj.fullName = houseObj.firstName + ' ' + houseObj.lastName;
                        String dobStr1 = houseHoldObj.get('dob')!=null?(String)houseHoldObj.get('dob'):'';
                        if(String.isNotBlank(dobStr1)){
                            houseObj.dob = AcetUtility.formatDate(dobStr1);
                        }
                        houseObj.relationship = houseHoldObj.get('relationship')!=null?(String)houseHoldObj.get('relationship'):'';
                        houseObj.memberId = houseHoldObj.get('memberID')!=null?(String)houseHoldObj.get('memberID'):'';
                        houseObj.isMainMember = false;
                        houseObj.address = houseAddObj ;
                        houseObj.gender = houseHoldObj.get('genderCode')!=null?(String)houseHoldObj.get('genderCode'):'';
                        houseHoldLine.add(houseObj);
                        ++i;
                        system.debug('i@@@ ' + i);
                     }
                    }

                    houseHoldDataWrapper.houseHoldList = houseHoldLine;
                    system.debug('houseHoldLine Size### ' +houseHoldLine.size());
                    system.debug('houseHoldLine### ' +houseHoldLine);

                }

                calloutResult.Success = true;
                calloutResult.Message = '';
                calloutResult.Response = houseHoldDataWrapper;
				calloutResult.statusCode = 200;
            }
	    else{
                calloutResult.MessageSeverity = ApexPages.Severity.ERROR;
                calloutResult.Success = false;
                calloutResult.Message = ACETUtility.getErrorMessage('GN500');
                calloutResult.statusCode=500;
            }
        }catch(Exception e){
	    System.debug('Exception happened:'+e);
            system.debug(e.getStackTraceString());
            calloutResult.MessageSeverity = ApexPages.Severity.ERROR;
            calloutResult.Success = false;
            calloutResult.Message = ACETUtility.getErrorMessage('GN500');
            calloutResult.statusCode=999;
        }


        return calloutResult;
    }
    /* Code Commented as not required for ITE -Required for SAE
	public ACETWSCalloutResult getPolicyWS(String transactionId){
    	system.debug('transactionId:::' + transactionId);
        getEndpoint();
        setRelativeUrl(transactionId);

        ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();
        ACETPolicyDetailsResult pResponse = new ACETPolicyDetailsResult();
        try{

            HttpResponse response = Send(OAuthConfig,'LinkApi');
            System.debug('response='+response);
            String responseStr = '';
            StaticResource responseJSONSR = null;
            //String responseBody; //Code Not Used -Chandan
            responseStr = response!=null?response.getBody():'';
            system.debug('ResponseBody** ' + responseStr);

            if(responseStr != null && String.isNotBlank(responseStr)){

                Map<String, Object> policyMainMap = (Map<String, Object>)JSON.deserializeUntyped(responseStr);
                Map<String, Object> policyAddPlanDetMap = (Map<String, Object>)policyMainMap.get('additionalPlanDetails');
                ACETLinkExtendedCoverageJSON2Apex json2Apex;
                ACETPolicyDetailsResult.policyResults respToReturn = new ACETPolicyDetailsResult.policyResults();

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
                    respToReturn.marketType = (String) policyMainMap.get('marketType');
                    respToReturn.stateOfIssueCode = (String) policyMainMap.get('stateOfIssueCode');  //Health Plan
                    respToReturn.productId = (String) policyMainMap.get('productID');	//Network Type
                    respToReturn.cosmosDivision = (String) policyMainMap.get('cosmosDivision');    //DIV
                    respToReturn.groupPanelNumber = (String) policyMainMap.get('groupPanelNumber');

                    //
                    System.debug('@@ ACETExtendedCoverageWS: respToReturn.stateOfIssueCode: ' + respToReturn.stateOfIssueCode);
                    try{
                        respToReturn.HealthPlanSite = [SELECT Link__c FROM Healthplan_Site__mdt WHERE Label = :respToReturn.stateOfIssueCode LIMIT 1].Link__c;
                        System.debug('@@ ACETExtendedCoverageWS: respToReturn.HealthPlanSite try: ' + respToReturn.HealthPlanSite);
                        if(respToReturn.HealthPlanSite == null) {
                            respToReturn.HealthPlanSite = '';
                        }
                    } catch(Exception e) {
                        respToReturn.HealthPlanSite = '';
                        System.debug('@@ ACETExtendedCoverageWS: respToReturn.HealthPlanSite catch: ' + respToReturn.HealthPlanSite);
                    }
                    //

                    pResponse.policyRes = respToReturn;
                    calloutResult.Success = true;
                    calloutResult.Message = '';
                    calloutResult.Response = pResponse;

                }
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
    */
	public Static String getStaticResponse(String StaticResourceName){
        System.debug('StaticResourceName in getStaticResponse='+StaticResourceName);
        String responseStr;
        StaticResource responseJSONSR = [SELECT Body FROM StaticResource WHERE Name = :StaticResourceName limit 1];
        //System.debug('StaticResource@@@@='+responseJSONSR);
        responseStr = responseJSONSR!=null?responseJSONSR.Body.toString():'';
        //System.debug('responseStr in getStaticResponse='+responseStr);
        return responseStr;
    }
}