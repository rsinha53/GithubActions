public with sharing class ACET_ReadMemberCobHistory
{
    public static final String APP_NAME = 'ISET';
    public static final String APP_INS_NAME = 'HAD';

    public static ACET_SAECalloutResult invokeService(String userId, String systemDiv, String groupNum, String subId, String dpCode, String effDate){
        ACET_SAECalloutResult calloutRes = new ACET_SAECalloutResult();
        try {
            String xmlBody = '';
            xmlBody = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:v4="http://upm3.uhc.com/cosmosmember/readmembercobhistory/v4">'+
                        +'<soapenv:Header/>'+
                        +'<soapenv:Body>'+ 
                        +'<v4:invokeService xmlns:v4="http://upm3.uhc.com/cosmosmember/readmembercobhistory/v4">'+
                        +'<arg0>'+
                        +'<requestHeader>'+
                        +'<applicationName>'+APP_NAME+'</applicationName>'+
                        +'<applicationInstanceName>'+APP_INS_NAME+'</applicationInstanceName>'+
                        +'<logLevel>DEFAULT</logLevel>'+
                        +'<serviceOption>'+
                        +'<key>SOAP_FAULTS_AS_STATUS_MESSAGE_BEANS</key>'+
                        +'<value>true</value>'+
                        +'</serviceOption>'+
                        +'</requestHeader>'+
                        +'<controlModifiers><cosmosSystemParameters>'+
                        +'<userId>'+userId+'</userId>'+
                        +'</cosmosSystemParameters></controlModifiers>'+
                        +'<systemDivision>'+systemDiv+'</systemDivision>'+
                        +'<groupNumber>'+groupNum+'</groupNumber>'+
                        +'<subscriberId>'+subId+'</subscriberId>'+
                        +'<dependentCode>'+dpCode+'</dependentCode>'+
                        +'<effectiveDate>'+effDate+'</effectiveDate>'+
                        +'</arg0>'+
                        +'</v4:invokeService></soapenv:Body></soapenv:Envelope>';

            Http ht = new Http();
            HttpRequest request   = new HttpRequest();        
            request.setMethod('POST');
            request.setBody(xmlBody);
            request.setEndpoint('callout:COB_ReadMemberHistory');
            Map<String, String> headers = new map<String, String>{'Content-type' => 'text/xml','Content-Length' => '','SoapAction' => ''};
            for(String HeaderKey :headers.keySet()){
                request.setHeader(HeaderKey, Headers.get(HeaderKey));
            }
            HttpResponse response = new HttpResponse();
            response = ht.send(request);
            if(response.getStatusCode() == 200){
                calloutRes.isSuccess = true;
                calloutRes.statusCode = 200;
                System.debug('response body' + response.getBody());
                calloutRes.response = processXMLData(response.getBody());
            }else{
                calloutRes.isSuccess = false;
                calloutRes.message = response.getStatus();
                calloutRes.statusCode = response.getStatusCode();
            }             
        } catch (Exception e) {
            calloutRes.isSuccess = false;
            calloutRes.message = e.getMessage();
            calloutRes.statusCode = 999;
            System.debug(e.getMessage() +'=>'+ e.getLineNumber()); 
        }
        return calloutRes;
    }

    public static List<COBHistoyWrapper> processXMLData(String xmlStr){
        Dom.Document doc = new Dom.Document();
        doc.load(xmlStr);
        Dom.XMLNode envelope = doc.getRootElement();        
        Dom.XmlNode cobHistory = envelope.getChildElements()[0].getChildElements()[0].getChildElements()[0];
        List<COBHistoyWrapper> retWrap = new List<COBHistoyWrapper>();
        if(cobHistory != null){
            // US3340930 - Thanish - 6th Mar 2021
            for (Dom.XmlNode child : cobHistory.getChildElements()) {
                COBHistoyWrapper cob = new COBHistoyWrapper();
                // COB History
                if(child.getName() == 'memberCobHistory'){
                    // OI Primary and Payer Name
                    String OIPrimary='--'; String PayerName='--';
                    if(child.getChildElement('primaryGroupName', null)!=null){
                        if(String.isNotBlank(child.getChildElement('primaryGroupName', null).getText())){
                            OIPrimary='Yes'; PayerName=child.getChildElement('primaryGroupName', null).getText();
                        }else{
                            OIPrimary='No';
                        }
                    }
                    cob.oiPrimary=OIPrimary;
                    cob.payerName=PayerName;

                    // End
                    for(Dom.XmlNode subchild : child.getChildElements()){
                        if(subchild.getName() == 'policyHistory'){
                            // OI Type
                            String OIType='--';
                            if(subchild.getChildElement('label', null)!=null){
                                OIType=subchild.getChildElement('label', null).getText();
                            }
                            cob.oiType=OIType;
                            // Updated
                            String Updated='--';
                            if(subchild.getChildElement('fileMaintenanceDate', null)!=null){
                                Updated=SAEUtils.formatDate(subchild.getChildElement('fileMaintenanceDate', null).getText());
                            }
                            cob.updated=Updated;
                            // Eligible Dates
                            String polEffDate='--'; String polExDate='--';
                            if(subchild.getChildElement('primaryPolicyEffectiveDate', null)!=null){
                                polEffDate=SAEUtils.formatDate(subchild.getChildElement('primaryPolicyEffectiveDate', null).getText());
                            }
                            if(subchild.getChildElement('primaryPolicyExpirationDate', null)!=null){
                                polExDate=SAEUtils.formatDate(subchild.getChildElement('primaryPolicyExpirationDate', null).getText());
                            }
                            cob.eligDates=polEffDate+' - '+polExDate;
                        }
                    }
                    retWrap.add(cob);
                }
                // Medicare History
                if(child.getName()=='memberMedicareHistory'){
                    // Updated
                    String Updated='--';
                    if(child.getChildElement('fileMaintenanceDate', null)!=null){
                        Updated=SAEUtils.formatDate(child.getChildElement('fileMaintenanceDate', null).getText());
                    }
                    cob.updated=Updated;
                    // OI Primary and Payer Name
                    String OIPrimary='--'; String PayerName='--';
                    if(child.getChildElement('primaryGroupName', null)!=null){
                        if(String.isNotBlank(child.getChildElement('primaryGroupName', null).getText())){
                            OIPrimary='Yes'; PayerName=child.getChildElement('primaryGroupName', null).getText();
                        }else{
                            OIPrimary='No';
                        }
                    }
                    cob.oiPrimary=OIPrimary;
                    cob.payerName=PayerName;
                    // OI Type
                    String OIType='--';
                    if(child.getChildElement('label', null)!=null){
                        OIType=SAEUtils.formatDate(child.getChildElement('label', null).getText());
                    }
                    cob.oiType=OIType;
                    // Eligible Dates
                    String polEffDate='--'; String polExDate='--';
                    if(child.getChildElement('primaryPolicyEffectiveDate', null)!=null){
                        polEffDate=SAEUtils.formatDate(child.getChildElement('primaryPolicyEffectiveDate', null).getText());
                    }
                    if(child.getChildElement('primaryPolicyExpirationDate', null)!=null){
                        polExDate=SAEUtils.formatDate(child.getChildElement('primaryPolicyExpirationDate', null).getText());
                    }
                    cob.eligDates=polEffDate+' - '+polExDate;
                }
                // Medicare Type - getting from extended coverage
                cob.medicareType = '--';
                // Medicare Entitlement Reason - getting from extended coverage
                cob.medicareEntReason = '--';
            }
        }
        return retWrap;
    }

    public class COBHistoyWrapper
    {
        @AuraEnabled public String updated{get;set;}    
        @AuraEnabled public String oiPrimary{get;set;}
        @AuraEnabled public String oiType{get;set;}
        @AuraEnabled public String payerName{get;set;}
        @AuraEnabled public String eligDates{get;set;}
        @AuraEnabled public String medicareType{get;set;}
        @AuraEnabled public String medicareEntReason{get;set;}
    }
}