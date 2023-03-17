public with sharing class ACET_BenefitNonTherapyWebService {
    public static final String APP_NAME = 'ISET';
    public static final String APP_INS_NAME = 'HAD';
    
    public static ACET_SAECalloutResult invokeService(String securityToken, String policyNumber, String subscriberId, String dependentNumber, String  planYearStartdate){
        ACET_SAECalloutResult calloutResults = new ACET_SAECalloutResult();
        try{
            String xmlBody = '';
            xmlBody = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:v1="http://upm3.uhc.com/unetmember/selectservicecategoryaccumulations/v1">'
                +'<soapenv:Header/>'
                +'<soapenv:Body>'
                +'<v1:invokeService xmlns:v1="http://upm3.uhc.com/unetmember/selectservicecategoryaccumulations/v1">'
                +'<arg0>'
                +'<requestHeader>'
                +'<applicationName>'+APP_NAME+'</applicationName>'
                +'<applicationInstanceName>'+APP_INS_NAME+'</applicationInstanceName>'
                +'<logLevel>DEFAULT</logLevel>'
                +'<serviceOption>'
                +'<key>SOAP_FAULTS_AS_STATUS_MESSAGE_BEANS</key>'
                +'<value>true</value>'
                +'</serviceOption>'
                +'</requestHeader>'
                +'<controlModifiers>'
                +'<topsSystemParameter>'
                +'<securityToken>'+securityToken+'</securityToken>'
                +'</topsSystemParameter>'
                +'</controlModifiers>'
                +'<policyNumber>'+policyNumber+'</policyNumber>'
                +'<subscriberId>'+subscriberId+'</subscriberId>'
                +'<dependentNumber>'+dependentNumber+'</dependentNumber>'
                +'<planYearStartdate>'+planYearStartdate+'</planYearStartdate>'
                +'</arg0>'
                +'</v1:invokeService>'
                +'</soapenv:Body>'
                +'</soapenv:Envelope>';

            Http http = new Http();
            HttpRequest request   = new HttpRequest();        
            request.setMethod('POST');
            request.setBody(xmlBody);
            
            // Named Credential Endpoint
            request.setEndpoint('callout:Benefit_SelectServiceCategoryAccumulations');
            Map<String, String> headers = new map<String, String>{'Content-type' => 'text/xml','Content-Length' => '','SoapAction' => ''};
                for(String HeaderKey :headers.keySet()){
                    request.setHeader(HeaderKey, Headers.get(HeaderKey));
                }
            HttpResponse response = new HttpResponse();
            System.debug('@@@ ACET_BenefitNonTherapyWebService.invokeService(): Request: '+request);
            response = http.send(request);
            System.debug('@@@ ACET_BenefitNonTherapyWebService.invokeService(): Response: '+response);
            System.debug('@@@ ACET_BenefitNonTherapyWebService.invokeService(): Response: '+response.getBody());
            if(response.getStatusCode() == 200){
                calloutResults.isSuccess = true;
                calloutResults.statusCode = 200;
                calloutResults.response = processXMLData(response.getBody()); // xmlResponseBody
            }else{
                calloutResults.isSuccess = false;
                calloutResults.message = response.getStatus();
                calloutResults.statusCode = response.getStatusCode();
            }
            
        }catch(Exception ex){
            System.debug('@@@ ACET_BenefitNonTherapyWebService.invokeService(): Exception:: '+ex.getStackTraceString());
            calloutResults.isSuccess = false;
            calloutResults.message = ex.getMessage();
            calloutResults.statusCode = 999;
        }
        return calloutResults;
    }
    public static AccumulationsWrapper processXMLData(String xmlStr){
        Dom.Document doc = new Dom.Document();
        doc.load(xmlStr);
        Dom.XMLNode envelope = doc.getRootElement();   
        DOM.XmlNode body = envelope.getChildElements()[0];
        List<Dom.XmlNode> nonTherapyAccumulations = body.getChildElements()[0].getChildElements()[0].getChildElements();
        List<NonTherapyWrapper> nonTherapyAccumulationsList = new List<NonTherapyWrapper>();
        try{
            if(nonTherapyAccumulations!=null){
                for(Integer i = 0; i < nonTherapyAccumulations.size(); i++){
                    if(nonTherapyAccumulations[i].getName() == 'benefitServiceCategoryAccumulationreference'){
                        NonTherapyWrapper nonTherapy = new NonTherapyWrapper();
                        nonTherapy.serviceCategory = nonTherapyAccumulations[i].getChildElement('serviceCategory', null).getText();
                        nonTherapy.serviceCategoryDescription = nonTherapyAccumulations[i].getChildElement('serviceCategoryDescription', null).getText();
                        nonTherapy.planYearStartDate = nonTherapyAccumulations[i].getChildElement('planYearStartDate', null).getText();
                        nonTherapy.planYearEndDate = nonTherapyAccumulations[i].getChildElement('planYearEndDate', null).getText();
                        nonTherapy.unitIndicatorDescription = nonTherapyAccumulations[i].getChildElement('unitIndicatorDescription', null).getText();
                        nonTherapy.totalYtdPaidAmount = nonTherapyAccumulations[i].getChildElement('totalYtdPaidAmount', null).getText();
                        nonTherapy.totalYtdPaidCount = nonTherapyAccumulations[i].getChildElement('totalYtdPaidCount', null).getText();
                        nonTherapyAccumulationsList.add(nonTherapy);
                    }
                }
            }
        }catch(Exception ex){
            System.debug('@@@ ACET_BenefitNonTherapyWebService.processXMLData(): Exception:: '+ex.getStackTraceString());
        }
        AccumulationsWrapper accumulations = new AccumulationsWrapper();
        accumulations.nonTherapy = nonTherapyAccumulationsList;
        System.debug('Accumulations: '+JSON.serialize(accumulations));
        return accumulations;
    }
    public class AccumulationsWrapper{
        @AuraEnabled public List<NonTherapyWrapper> nonTherapy {get; set;}
    }
    public class NonTherapyWrapper{
       	@AuraEnabled public String serviceCategory {get;set;}
        @AuraEnabled public String serviceCategoryDescription {get;set;}
        @AuraEnabled public String planYearStartDate {get;set;}
        @AuraEnabled public String planYearEndDate {get;set;}
        @AuraEnabled public String unitIndicatorDescription {get;set;}
        @AuraEnabled public String totalYtdPaidAmount {get;set;}
        @AuraEnabled public String totalYtdPaidCount {get;set;}
    }
    
}