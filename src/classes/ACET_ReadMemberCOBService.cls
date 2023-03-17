public with sharing class ACET_ReadMemberCOBService 
{
    public static final String APP_NAME = 'ISET';
    public static final String APP_INS_NAME = 'HAD';

    public static ACET_SAECalloutResult invokeService(String userId, String systemDiv, String groupNum, String subId, String dpCode, String effDate){
        ACET_SAECalloutResult calloutRes = new ACET_SAECalloutResult();
        try {
            String xmlBody = '';
            xmlBody = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:v5="http://upm3.uhc.com/cosmosmember/readmembercobbyplanid/v5">'+
                        +'<soapenv:Header/>'+
                        +'<soapenv:Body>'+ 
                        +'<v5:invokeService xmlns:v5="http://upm3.uhc.com/cosmosmember/readmembercobbyplanid/v5">'+
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
                        +'</v5:invokeService></soapenv:Body></soapenv:Envelope>';

            Http ht = new Http();
            HttpRequest request   = new HttpRequest();        
            request.setMethod('POST');
            System.debug('xmlBody::'+xmlBody);
            request.setBody(xmlBody);
            // Named Credential Endpoint
            request.setEndpoint('callout:COB_ReadMemberCOB');
            Map<String, String> headers = new map<String, String>{'Content-type' => 'text/xml','Content-Length' => '','SoapAction' => ''};
            for(String HeaderKey :headers.keySet()){
                request.setHeader(HeaderKey, Headers.get(HeaderKey));
            }
            HttpResponse response = new HttpResponse();
            response = ht.send(request);
            System.debug('responsebody::'+response.getBody());
            if(response.getStatusCode() == 200){
                calloutRes.isSuccess = true;
                calloutRes.statusCode = 200;
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

    public static ReadMemberWrapper processXMLData(String xmlStr){
        Dom.Document doc = new Dom.Document();
        doc.load(xmlStr);
        Dom.XMLNode envelope = doc.getRootElement();        
        Dom.XmlNode comHistory = envelope.getChildElements()[0]
                                            .getChildElements()[0]
                                            .getChildElements()[0]
                                            .getChildElement('commercialHistory', null);
        
        ReadMemberWrapper memberCOB = new ReadMemberWrapper();
        // US3340930 - Thanish - 6th Mar 2021
        if(comHistory != null){
            // Other Insurance/Type
            String otherInsuranceStatus='--';
            if(comHistory.getChildElement('otherInsuranceStatus', null)!=null){
                otherInsuranceStatus=comHistory.getChildElement('otherInsuranceStatus', null).getText().toLowerCase().capitalize()+'/--';
            }
            memberCOB.otherInsurance = otherInsuranceStatus;
            // OI Eligible Dates
            String effectiveDate='--'; String expirationDate='--';
            if(comHistory.getChildElement('effectiveDate', null)!=null){
                effectiveDate=SAEUtils.formatDate(comHistory.getChildElement('effectiveDate', null).getText());
            }
            if(comHistory.getChildElement('expirationDate', null)!=null){
                expirationDate=SAEUtils.formatDate(comHistory.getChildElement('expirationDate', null).getText());
            }
            memberCOB.eligDates=effectiveDate+' - '+expirationDate;
            // Other Insurance Primary - Gap
            memberCOB.otherPriInsurance = '--';
            // memberCOB.otherPriInsurance = String.isBlank(comHistory.getChildElement('carrierName', null).getText()) ? 'No' : 'Yes';
            // US3314325
            // String reltoPrimary = comHistory.getChildElement('relationshipToPrimaryInsured',null).getText();
            // memberCOB.otherPriInsurance = memberCOB.otherInsurance.equalsIgnoreCase('No') ? 'No' : memberCOB.otherInsurance.equalsIgnoreCase('Yes') && String.isNotBlank(reltoPrimary) ? 'Yes' : 'No';
            // Primary Effective dates - Gap
            memberCOB.priEffDates = '--';

            // Payer Name
            String payerName='--';
            if(comHistory.getChildElement('carrierGroupName', null)!=null){
                payerName=comHistory.getChildElement('carrierGroupName', null).getText().toLowerCase().capitalize();
            }
            memberCOB.payerName = payerName;
            // Medicare Information - getting from extended coverage
            memberCOB.medicareInfo = '--';
            // Update Status - Gap
            memberCOB.updateStatus = '--';
            // Last Updated Date
            String lastUpdatedDate='--';
            if(comHistory.getChildElement('lastUpdatedDate', null)!=null){
                lastUpdatedDate=SAEUtils.formatDate(comHistory.getChildElement('lastUpdatedDate', null).getText());
            }
            memberCOB.lastUpdatedDate=lastUpdatedDate;
            
            List<ACET_ReadCarrierComments.CommentWrapper> comments = new List<ACET_ReadCarrierComments.CommentWrapper>();           
            for(Dom.XmlNode child : comHistory.getChildElements()){
                if(child.getName() == 'comments'){
                    ACET_ReadCarrierComments.CommentWrapper cw = new ACET_ReadCarrierComments.CommentWrapper();
                    // Type
                    cw.planType = '--';
                    // Dates
                    String carrierEffectiveDate='--';
                    if(child.getChildElement('carrierEffectiveDate', null)!=null){
                        carrierEffectiveDate=SAEUtils.formatDate(child.getChildElement('carrierEffectiveDate', null).getText());
                    }
                    String carrierExpirationDate='--';
                    if(child.getChildElement('carrierExpirationDate', null)!=null){
                        carrierExpirationDate=SAEUtils.formatDate(child.getChildElement('carrierExpirationDate', null).getText());
                    }
                    cw.commentDate=carrierEffectiveDate+' - '+carrierExpirationDate;
                    // Comments
                    String comment = '';
                    for(Dom.XmlNode subchild : child.getChildElements()){
                        if(subchild!=null && subchild.getName()=='commentLine' && String.isNotBlank(subchild.getText())){
                            comment = String.isBlank(comment) ? subchild.getText() : comment + ' \n ' + subchild.getText();
                        }
                    }
                    cw.comment = comment;
                    comments.add(cw);
                }
            }            
            memberCOB.comments = comments;                    
        }      
        System.debug(JSON.serialize(memberCOB));
        return memberCOB;
    }

    public class ReadMemberWrapper
    {
        // US3340930 - Thanish - 6th Mar 2021
        @Auraenabled public String otherInsurance{get;set;}
        @Auraenabled public String otherPriInsurance{get;set;}
        @Auraenabled public String priEffDates{get;set;}
        @Auraenabled public String eligDates{get;set;}
        @Auraenabled public String payerName{get;set;}
        @Auraenabled public String medicareInfo{get;set;}
        @Auraenabled public String updateStatus{get;set;}
        @Auraenabled public String lastUpdatedDate{get;set;}
        @Auraenabled public List<ACET_ReadCarrierComments.CommentWrapper> comments{get;set;}
    }
}