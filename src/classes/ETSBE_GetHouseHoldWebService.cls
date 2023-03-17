public class ETSBE_GetHouseHoldWebService {
    
    public ACETWSCalloutResult getHouseHoldData(String transactionId){
        
        system.debug('hs ws tr id::'+transactionId);
        
        ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();
        ETSBE_HouseHoldWrapper houseHoldDataWrapper = new ETSBE_HouseHoldWrapper();
        //SAEHouseHoldWrapper.HouseHold hold = new SAEHouseHoldWrapper.HouseHold();
        ETSBE_HouseHoldWrapper.HouseHold houseObj;
        List<ETSBE_HouseHoldWrapper.HouseHold> houseHoldLine = new List<ETSBE_HouseHoldWrapper.HouseHold>();
        try{
            
            //Directly get data from WS
            String reqMethod='GET';
            HttpResponse response;
            String endPoint = ISL_Webservice_Config__c.getInstance('SAE_PolicySearch').Value__c; 
            String resultQuery = '?transactionId='+EncodingUtil.urlEncode(transactionId, 'UTF-8'); //DE282083 - Avish
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
                
                Map<String, Object> policyMainMap = (Map<String, Object>)JSON.deserializeUntyped(responseStr);
                Map<String, Object> policyMemInfoMap = (Map<String, Object>)policyMainMap.get('memberInfo');
                
                if (!policyMemInfoMap.isEmpty()){
                    houseObj = new ETSBE_HouseHoldWrapper.HouseHold();
                    houseObj.firstName = (String)policyMemInfoMap.get('firstName');
                    houseObj.lastName = (String)policyMemInfoMap.get('lastName');
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
                    system.debug('memberInfo@@ ' + familyMembers);
                    for(Object member : familyMembers){
                        Integer i=0;
                        Map<String,Object> houseHoldObj = (Map<String,Object>)member;
                        system.debug('houseHoldObj@@@' + houseHoldObj);
                        houseObj = new ETSBE_HouseHoldWrapper.HouseHold();
                        houseObj.firstName = (String)houseHoldObj.get('firstName');
                        houseObj.lastName = (String)houseHoldObj.get('lastName');
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
                        system.debug('i@@@ ' + i);
                    }
                    
                    houseHoldDataWrapper.houseHoldList = houseHoldLine;
                    system.debug('houseHoldLine Size### ' +houseHoldLine.size());
                    system.debug('houseHoldLine### ' +houseHoldLine);

                    /*US1970508 - Ravindra - start
                    houseHoldDataWrapper.xRefId = (String)policyMainMap.get('xrefId');
                    US1970508 - Ravindra - end*/
                }
                
                calloutResult.Success = true;
                calloutResult.Message = '';                
                calloutResult.Response = houseHoldDataWrapper;                 

            }            
            

            
        }catch(Exception e){
            system.debug(e.getStackTraceString());
            calloutResult.MessageSeverity = ApexPages.Severity.ERROR;
            calloutResult.Success = false;
            calloutResult.Message = 'Web Service or External System is temporarily unavailable.';
            calloutResult.statusCode=999;
        }
        
        
        return calloutResult;
    }
    
}