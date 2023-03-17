public class SAEGetHouseHoldWebService {
    
    public ACETWSCalloutResult getHouseHoldData(String transactionId){
        
        ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();
        
        try{
            Boolean isStaticResponseChecked = false;
            String responseStr = '';
            HttpResponse response;
            isStaticResponseChecked = SAEUtils.getMockStatus();
            System.debug('@@ SAEGetHouseHoldWebService: getHouseHoldData: isStaticResponseChecked: '+isStaticResponseChecked);
            
            if(isStaticResponseChecked && !Test.isRunningTest() ) {
                String searchparameter = 'ExtendedCoverage_' + transactionId.remove('-').remove('%').substring(0, 23);
                response = SAEUtils.getResponse(searchparameter);
            } else {
                //Directly get data from WS
                String reqMethod='GET';
                String endPoint = ISL_Webservice_Config__c.getInstance('SAE_PolicySearch').Value__c; 
                String resultQuery = '?transactionId='+EncodingUtil.urlEncode(transactionId, 'UTF-8'); //DE282083 - Avish
                StaticResource responseJSONSR = null;
                String responseBody;
                
                response = SAEWebservice.makeCallout(resultQuery,endPoint,reqMethod);
                calloutResult.statusCode= response.getStatusCode();
            }
				responseStr = response.getBody();  
				calloutResult.Success = true;
				calloutResult.Message = '';                
				calloutResult.Response = getHouseHoldResult(responseStr);  
        }catch(Exception e){
            calloutResult.MessageSeverity = ApexPages.Severity.ERROR;
            calloutResult.Success = false;
            calloutResult.Message = 'Web Service or External System is temporarily unavailable.';
            calloutResult.statusCode=999;
        }
        return calloutResult;
    }
    //this method parsing the response string into SAEHouseHoldWrapper __vishnu kasu
	Public SAEHouseHoldWrapper getHouseHoldResult(String responseStr)
	{
		
				SAEHouseHoldWrapper houseHoldDataWrapper = new SAEHouseHoldWrapper();
				SAEHouseHoldWrapper.HouseHold houseObj;
				List<SAEHouseHoldWrapper.HouseHold> houseHoldLine = new List<SAEHouseHoldWrapper.HouseHold>();
                Map<String, Object> policyMainMap = (Map<String, Object>)JSON.deserializeUntyped(responseStr);
                Map<String, Object> policyMemInfoMap = (Map<String, Object>)policyMainMap.get('memberInfo');
                if (!policyMemInfoMap.isEmpty()){
                    houseObj = new SAEHouseHoldWrapper.HouseHold();
                    houseObj.firstName = (String)policyMemInfoMap.get('firstName');
                    houseObj.lastName = (String)policyMemInfoMap.get('lastName');
                    houseObj.gender = (String)policyMemInfoMap.get('genderCode');
                    houseObj.fullName = (String)policyMemInfoMap.get('firstName') + ' ' + (String)policyMemInfoMap.get('lastName');
                    houseObj.isMainMember = true;
                    String dobStr = (String)policyMemInfoMap.get('dob');
                    if(String.isNotBlank(dobStr)){
                        houseObj.dob = SAEUtils.formatDate(dobStr);
                    }                    
                    houseObj.relationship = (String)policyMemInfoMap.get('relationship');
                    houseHoldLine.add(houseObj); 
                    
                    //Add other Members
                    List<Object> familyMembers = (List<Object>) policyMemInfoMap.get('members');
                   
                    for(Object member : familyMembers){
                        Integer i=0;
                        Map<String,Object> houseHoldObj = (Map<String,Object>)member;
                        houseObj = new SAEHouseHoldWrapper.HouseHold();
                        houseObj.firstName = (String)houseHoldObj.get('firstName');
                        houseObj.lastName = (String)houseHoldObj.get('lastName');
                        houseObj.gender = (String)houseHoldObj.get('genderCode');
                        houseObj.fullName = (String)houseHoldObj.get('firstName') + ' ' + (String)houseHoldObj.get('lastName');
                        String dobStr1 = (String)houseHoldObj.get('dob');
                        if(String.isNotBlank(dobStr1)){
                            houseObj.dob = SAEUtils.formatDate(dobStr1);
                        }                    
                        houseObj.relationship = (String)houseHoldObj.get('relationship');
                        houseObj.memberId = (String)houseHoldObj.get('memberID');
                        houseObj.isMainMember = false;
                        houseHoldLine.add(houseObj);  
                        ++i;
                    }
                    
                    houseHoldDataWrapper.houseHoldList = houseHoldLine;
                    /*US1970508 - Ravindra - start
                    houseHoldDataWrapper.xRefId = (String)policyMainMap.get('xrefId');
                    US1970508 - Ravindra - end*/
                }
				return houseHoldDataWrapper;
		}
    
}