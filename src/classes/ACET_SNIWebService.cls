public class ACET_SNIWebService {
	
    public static ACETWSCalloutResult getSNIDetails(String requestBody){
       ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();
       try{
            //Boolean isStaticResponseChecked = false;
            HttpResponse response = new HttpResponse();
            String responseStr = '', strEligiblieType = '', strAdvisoryName = '';
            /*isStaticResponseChecked = SAEUtils.getMockStatus();
            if(isStaticResponseChecked && !Test.isRunningTest()) {
                String searchparameter = 'SNI_MockData';
                response = SAEUtils.getResponse(searchparameter);
            } else {
                //String OrgName = SAEUtils.getOrgName();
                //US3098067 - Avish & vishnu
                 Map<String, ACETOrgInstanceURLToOrgNameMap__c> OrgInstance2OrgNameMap = ACETOrgInstanceURLToOrgNameMap__c.getAll();
        		 String orgName = Test.isRunningTest() ? 'dev' : ACETUtility.GetOrgName(OrgInstance2OrgNameMap);

                String customSettingName = orgName + '_GETSNIDATA';
                String endPoint = ISL_Webservice_Config__c.getInstance(customSettingName).Value__c;
                response = SAEWebservice.makePostCallOut(requestBody, endPoint);
            }*/

            ACET_WebserviceCalloutFramework wsCallOut = new ACET_WebserviceCalloutFramework();
            wsCallOut.serviceName = 'SNIWebService';
            wsCallOut.requestBody = requestBody;
            response = wscallout.getResponse();

            calloutResult.statusCode= response.getStatusCode();
            responseStr = response.getBody();
            if(response.getStatusCode() == 200){
                Map<String,Object> mapResponse = (Map<String,Object>)JSON.deserializeUntyped(responseStr);
                String strResult = JSON.serialize(mapResponse.get('result'));
                Map<String,Object> mapData = (Map<String,Object>)JSON.deserializeUntyped(strResult);
                String strData = JSON.serialize(mapData.get('data'));
                List<object> lstData = (List<Object>)(JSON.deserializeUntyped(strData));
                for(Object each: lstData) {
                    String strEachData = JSON.serialize(each);
                    Map<String,Object> mapEachDataRecord = (Map<String,Object>)JSON.deserializeUntyped(strEachData);
                    strEligiblieType = (String)mapEachDataRecord.get('sniEligibility');
                    if(strEligiblieType.equalsIgnoreCase('eligible')) {
                        strEligiblieType = 'Special Needs Eligible';
                    } else if(strEligiblieType.equalsIgnoreCase('engaged')) {
                        strEligiblieType = 'Special Needs Engaged - ' + (String)mapEachDataRecord.get('advisorFullName') ;
                    } else {
                         strEligiblieType = '' ;
                    }
                }
                //if(String.isNotBlank(strEligiblieType)) {
                    calloutResult.Success = true;
                    calloutResult.Message = '';
                    calloutResult.Response = strEligiblieType;
               /* } else {
					calloutResult.Success = true;
                    calloutResult.Message = '';
					calloutResult.Response = strEligiblieType;
                }*/
            }else{
                calloutResult.Success = false;
                calloutResult.Response = null;
            }
        }
        catch(Exception e){
            system.debug(e.getStackTraceString());
            calloutResult.MessageSeverity = ApexPages.Severity.ERROR;
            calloutResult.Success = false;
            calloutResult.Message = 'Web Service or External System is temporarily unavailable.';
            calloutResult.statusCode=999;
        }
        return calloutResult;
    }
}