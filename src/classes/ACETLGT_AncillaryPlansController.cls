/**
 * @description       : Ancillary Plans Controller for Lightning US3727594
 * @author            : Raviteja
 * @group             : Styx
 * @last modified on  : 08-06-2021
 * @last modified by  : Raviteja
**/
public class ACETLGT_AncillaryPlansController {
    
    public static string exceptionMsg ='Exception in Ancillary plans Webservice. Details ';
    
    /**
    * @description To Fetch Ancillary Plans
    * @author Raviteja | 08-06-2021 
    * @param ancillData 
    * @return AncillaryWrapper 
    **/
    @AuraEnabled
    public static AncillaryWrapper getAncillaryPlansData(String ancillData){
        ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult();
        try{
            ACETAncillaryPlansRequest.SearchInput request = new ACETAncillaryPlansRequest.SearchInput();
            if(ancillData!=NULL){
                AncillaryData data = (AncillaryData)JSON.deserialize(ancillData, AncillaryData.class);
                if(data.memberSearch){
                    request.identifier = data.identifier;
                    request.identifierType = 'SRK';
                    request.suppressPlanLanguage = false;
                }
                request.groupNumber = data.groupNumber;
                request.benefitBundleOptionId = data.benefitBundleOptionId;
                String regex = '[0-9]{4}-[0-9]{2}-[0-9]{2}';
                Pattern datePattern = Pattern.compile(regex);
                if(String.isNotBlank(data.asofdate)){
                    request.asofdate = datePattern.matcher(data.asofdate).matches()?data.asofdate:ACETWebserviceHelper.formatToYYYYMMDD(data.asofdate);
                }
                ACETAncillaryPlansRequest requestMain = new ACETAncillaryPlansRequest();
                requestMain.searchInput = request;
                String requestBody = JSON.serialize(requestMain);
                system.debug('@@@requestBody '+requestBody);
                ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework('ACETAncillarySearchEndpoint',requestBody,null);
                HttpResponse httpResponse = wsCallOutFW.getResponse();
                Integer statusCode = httpResponse.getStatusCode();
                String responseBody = httpResponse.getBody();
                ACETAncillaryPlansResponse planResults;
                system.debug('@@@Ancillaryrespone '+responseBody);
                List<Map<String,String>> docs = new List<Map<String,String>>();
                switch on statusCode{
                    when 200{
                        planResults = (ACETAncillaryPlansResponse)JSON.deserializeStrict(responseBody, ACETAncillaryPlansResponse.class);
                        oACETWSCalloutResult.Success = true;
                        oACETWSCalloutResult.Response = planResults;
                        oACETWSCalloutResult.Message = '';
                    }
                    when 404{
                        oACETWSCalloutResult.Success = false;
                        oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;  
                        oACETWSCalloutResult.statusCode=httpResponse.getStatusCode();   
                        oACETWSCalloutResult.Message = 'No Records Found';
                    }
                    when else{
                        oACETWSCalloutResult = ACETFindDocWebService.parseFailureData(httpResponse);
                        oACETWSCalloutResult.statusCode=httpResponse.getStatusCode();        
                    }
                }
            }else{
                oACETWSCalloutResult.Success = false;
                oACETWSCalloutResult.Message = exceptionMsg+'Request Data empty';
                oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;
            }
        }catch(Exception ex){
            oACETWSCalloutResult.Success = false;
            oACETWSCalloutResult.Message = exceptionMsg+ex.getMessage();
            oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;
            oACETWSCalloutResult.statusCode=999; 
        }
        return new AncillaryWrapper(JSON.serialize(oACETWSCalloutResult));
    }

    public class AncillaryWrapper{
        @Auraenabled
         public string response;       
         public AncillaryWrapper(String response){
             this.response = response;        
         }       
    }
    
    public class AncillaryData{
        @Auraenabled public string groupNumber;
        @Auraenabled public string benefitBundleOptionId;
        @Auraenabled public string identifier;
        @Auraenabled public string effectivedate;
        @Auraenabled public string enddate;
        @Auraenabled public boolean membersearch;
        @Auraenabled public string asofdate;
        public AncillaryData(){
            this.groupNumber = '';
            this.benefitBundleOptionId = '';
            this.identifier = '';
            this.asofdate = '';
            this.membersearch = false;
            this.enddate = '';
            this.effectivedate = '';
        }
    }
}