public with sharing class ACET_FeeScheduleService 
{
    public static ACET_SAECalloutResult invoke(FeeRequst feeRequest)
    {
        ACET_SAECalloutResult calloutRes = new ACET_SAECalloutResult();
        try {
            String xmlBody = '';
            xmlBody = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:v6="http://upm3.uhc.com/provider/readproviderfeeschedule/v6">'+
            '<soapenv:Header/>'+
            '<soapenv:Body>'+
                '<v6:invokeService>'+
                    '<arg0>'+
                        '<requestHeader>'+
                            '<applicationName>ISET</applicationName>'+
                            '<applicationInstanceName>HAD</applicationInstanceName>'+
                            '<logLevel>DEBUG</logLevel>'+
                            '<externalId></externalId>'+
                            // <!--Zero or more repetitions:-->
                            '<serviceOption><key>SOURCE_SYSTEM</key><value>NDB</value></serviceOption>'+
                            '<serviceOption><key>SOAP_FAULTS_AS_STATUS_MESSAGE_BEANS</key><value>true</value></serviceOption>'+
                            // //Optional
                            '<internalUse>'+
                                '<uid></uid>'+
                                '<serviceName></serviceName>'+
                                '<serviceVersion></serviceVersion>'+
                                '<originalConsumer></originalConsumer>'+
                                '<originalServiceName></originalServiceName>'+
                                '<originalServiceVersion></originalServiceVersion>'+
                                '<logSequence></logSequence>'+
                                '<uidGeneratedBy></uidGeneratedBy>'+
                            '</internalUse>'+
                        '</requestHeader>'+
                        // //Optional
                        '<sourceSystemParameters>'+
                            //Optional
                            '<cosmosSystemParameters>'+
                                //Optional
                                '<sourceId>'+ (String.isNotEmpty(feeRequest.sourceId) ? feeRequest.sourceId : '') +'</sourceId>'+
                                //Optional
                                '<userId>'+ (String.isNotEmpty(feeRequest.cosmosUserId) ? feeRequest.cosmosUserId : '') +'</userId>'+
                            '</cosmosSystemParameters>'+
                            //Optional
                            '<facetsSystemParameters>'+
                                //Optional
                                '<password>'+(String.isNotEmpty(feeRequest.password) ? feeRequest.password : '')+'</password>'+
                                //Optional
                                '<securityToken>'+(String.isNotEmpty(feeRequest.securityToken) ? feeRequest.securityToken : '')+'</securityToken>'+
                                //Optional
                                '<userId>'+(String.isNotEmpty(feeRequest.facetsUserId) ? feeRequest.facetsUserId : '')+'</userId>'+
                            '</facetsSystemParameters>'+
                        '</sourceSystemParameters>'+
                        // <!--Zero or more repetitions:-->
                        concatTags(feeRequest.procedureCode, 'procedureCode')+
                        // <!--Zero or more repetitions:-->
                        concatTags(feeRequest.revenueCode, 'revenueCode')+
                        // <!--Zero or more repetitions:-->
                        concatTags(feeRequest.revenueTypeIndicators, 'revenueTypeIndicators')+
                        // <!--Zero or more repetitions:-->
                        concatTags(feeRequest.modifier, 'modifier')+
                        //Optional
                        '<div>'+(String.isNotEmpty(feeRequest.div) ? feeRequest.div : '')+'</div>'+
                        //Optional
                        '<fromDateOfService>'+(String.isNotEmpty(feeRequest.fromDateOfService) ? feeRequest.fromDateOfService : '')+'</fromDateOfService>'+
                        //Optional
                        '<toDateOfService>'+(String.isNotEmpty(feeRequest.toDateOfService) ? feeRequest.toDateOfService : '')+'</toDateOfService>'+
                        //Optional
                        '<zipPrefix>'+(String.isNotEmpty(feeRequest.zipPrefix) ? feeRequest.zipPrefix : '')+'</zipPrefix>'+
                        //Optional
                        '<zipSuffix>'+(String.isNotEmpty(feeRequest.zipSuffix) ? feeRequest.zipSuffix : '')+'</zipSuffix>'+
                        //Optional
                        '<zip>'+(String.isNotEmpty(feeRequest.zip) ? feeRequest.zip : '')+'</zip>'+
                        //Optional
                        '<percent>'+(String.isNotEmpty(feeRequest.percent) ? feeRequest.percent : '')+'</percent>'+
                        //Optional
                        '<providerId>'+(String.isNotEmpty(feeRequest.providerId) ? feeRequest.providerId : '')+'</providerId>'+
                        //Optional
                        '<providerType>'+(String.isNotEmpty(feeRequest.providerType) ? feeRequest.providerType : '')+'</providerType>'+
                        //Optional
                        '<genderCode>'+(String.isNotEmpty(feeRequest.genderCode) ? feeRequest.genderCode : '')+'</genderCode>'+
                        //Optional
                        '<market>'+(String.isNotEmpty(feeRequest.market) ? feeRequest.market : '')+'</market>'+
                        //Optional
                        '<marketType>'+(String.isNotEmpty(feeRequest.marketType) ? feeRequest.marketType : '')+'</marketType>'+
                        //Optional
                        '<placeOfServiceCode>'+(String.isNotEmpty(feeRequest.placeOfServiceCode) ? feeRequest.placeOfServiceCode : '')+'</placeOfServiceCode>'+
                        //Optional
                        '<productCode>'+(String.isNotEmpty(feeRequest.productCode) ? feeRequest.productCode : '')+'</productCode>'+
                        //Optional
                        '<productOfferId>'+(String.isNotEmpty(feeRequest.productOfferId) ? feeRequest.productOfferId : '')+'</productOfferId>'+
                        //Optional
                        '<diagnosisCode>'+(String.isNotEmpty(feeRequest.diagnosisCode) ? feeRequest.diagnosisCode : '')+'</diagnosisCode>'+
                        //Optional
                        '<icdVersionIndicator>'+(String.isNotEmpty(feeRequest.icdVersionIndicator) ? feeRequest.icdVersionIndicator : '')+'</icdVersionIndicator>'+
                        //Optional
                        '<numberOfUnits>'+(String.isNotEmpty(feeRequest.numberOfUnits) ? feeRequest.numberOfUnits : '')+'</numberOfUnits>'+
                        //Optional
                        '<unitType>'+(String.isNotEmpty(feeRequest.unitType) ? feeRequest.unitType : '')+'</unitType>'+
                        //Optional
                        '<chargeAmount>'+(String.isNotEmpty(feeRequest.chargeAmount) ? feeRequest.chargeAmount : '')+'</chargeAmount>'+
                        //Optional
                        '<ipa>'+(String.isNotEmpty(feeRequest.ipa) ? feeRequest.ipa : '')+'</ipa>'+
                        //Optional
                        '<ioRateTableNumber>'+(String.isNotEmpty(feeRequest.ioRateTableNumber) ? feeRequest.ioRateTableNumber : '')+'</ioRateTableNumber>'+
                        //Optional
                        '<feeScheduleNumber>'+(String.isNotEmpty(feeRequest.feeScheduleNumber) ? feeRequest.feeScheduleNumber : '')+'</feeScheduleNumber>'+
                        //Optional
                        '<contractPayMethod>'+(String.isNotEmpty(feeRequest.contractPayMethod) ? feeRequest.contractPayMethod : '')+'</contractPayMethod>'+
                        //Optional
                        '<facilityContractCode>'+(String.isNotEmpty(feeRequest.facilityContractCode) ? feeRequest.facilityContractCode : '')+'</facilityContractCode>'+
                        //Optional
                        '<specialtyNumber>'+(String.isNotEmpty(feeRequest.specialtyNumber) ? feeRequest.specialtyNumber : '')+'</specialtyNumber>'+
                        //Optional
                        '<contractId>'+(String.isNotEmpty(feeRequest.contractId) ? feeRequest.contractId : '')+'</contractId>'+
                        //Optional
                        '<pcpInd>'+(String.isNotEmpty(feeRequest.pcpInd) ? feeRequest.pcpInd : '')+'</pcpInd>'+
                        //Optional
                        '<penaltySwitch>'+(String.isNotEmpty(feeRequest.penaltySwitch) ? feeRequest.penaltySwitch : '')+'</penaltySwitch>'+
                        //Optional
                        '<taxId>'+(String.isNotEmpty(feeRequest.taxId) ? feeRequest.taxId : '')+'</taxId>'+
                        //Optional
                        '<providerNetworkType>'+(String.isNotEmpty(feeRequest.providerNetworkType) ? feeRequest.providerNetworkType : '')+'</providerNetworkType>'+
                        //Optional
                        '<providerNetworkId>'+(String.isNotEmpty(feeRequest.providerNetworkId) ? feeRequest.providerNetworkId : '')+'</providerNetworkId>'+
                        //Optional
                        '<searchLimit>'+(String.isNotEmpty(feeRequest.searchLimit) ? feeRequest.searchLimit : '')+'</searchLimit>'+
                        //Optional
                        '<pagingState>'+
                            '<moreData>'+(String.isNotEmpty(feeRequest.moreData) ? feeRequest.moreData : '')+'</moreData>'+
                            //Optional
                            '<nextCode>'+(String.isNotEmpty(feeRequest.nextCode) ? feeRequest.nextCode : '')+'</nextCode>'+
                            //Optional
                            '<nextDate>'+(String.isNotEmpty(feeRequest.nextDate) ? feeRequest.nextDate : '')+'</nextDate>'+
                            //Optional
                            '<nextMod>'+(String.isNotEmpty(feeRequest.nextMod) ? feeRequest.nextMod : '')+'</nextMod>'+
                        '</pagingState>'+
                    '</arg0>'+
                '</v6:invokeService>'+
            '</soapenv:Body>'+
            '</soapenv:Envelope>';
            Http ht = new Http();
            HttpRequest request   = new HttpRequest();        
            request.setMethod('POST');
            System.debug('Request ::: ' + xmlBody);
            request.setBody(xmlBody);
            request.setEndpoint('callout:FeeScheduleEndpoint');
            Map<String, String> headers = new map<String, String>{'Content-type' => 'text/xml','Content-Length' => '','SoapAction' => ''};
            for(String HeaderKey :headers.keySet()){
                request.setHeader(HeaderKey, Headers.get(HeaderKey));
            }
            HttpResponse response = new HttpResponse();
            response = ht.send(request);
            System.debug('Response ::: ' + response.getBody());
            if(response.getStatusCode() == 200){
                calloutRes.isSuccess = true;
                calloutRes.statusCode = 200;
                calloutRes.response = processXMLData(response.getBody(),feeRequest);
            }else{
                calloutRes.isSuccess = false;
                calloutRes.message = response.getStatus();
                calloutRes.statusCode = response.getStatusCode();
            }
        } catch (Exception e) {
            calloutRes.isSuccess = false;
            calloutRes.response = null;
            calloutRes.statusCode = 999;
            calloutRes.message = e.getMessage();
        }
        return calloutRes;
    }

    private static String concatTags(List<String> values, String tagName){
        String returnStr = '';
        if(values != null && values.size() > 0){
            for(String st : values){
                returnStr = returnStr + '<' + tagName + '>' + st + '</' + tagName + '>';
            }
        }else{
            returnStr = '<' + tagName + '>' + '</' + tagName + '>';
        }
        return returnStr;
    }

    public static FeeResponse processXMLData(String xmlStr, FeeRequst freq){
        FeeResponse retWrap = new FeeResponse();
        Dom.Document doc = new Dom.Document();
        doc.load(xmlStr);
        Dom.XMLNode envelope = doc.getRootElement();
        Dom.XmlNode feeSceduleType = envelope.getChildElements()[0].getChildElements()[0].getChildElements()[0].getChildElement('feeScheduleType', null);
        if(feeSceduleType != null){
            Dom.XmlNode serviceLine = feeSceduleType.getChildElement('serviceLine', null);
            if(serviceLine != null){
                retWrap.startDate = serviceLine.getChildElement('fromServiceDate', null) != null ? SAEUtils.formatDate(serviceLine.getChildElement('fromServiceDate', null).getText()) : '--';
                retWrap.endDate = serviceLine.getChildElement('toServiceDate', null) != null ? SAEUtils.formatDate(serviceLine.getChildElement('toServiceDate', null).getText()) : '--';
                retWrap.pos = serviceLine.getChildElement('placeOfServiceCode', null) != null ? serviceLine.getChildElement('placeOfServiceCode', null).getText() : '--';
                retWrap.cptHcpc = serviceLine.getChildElement('procedureCode', null) != null ? serviceLine.getChildElement('procedureCode', null).getText() : '--';
                retWrap.modifier = serviceLine.getChildElement('modifierCode', null) != null ? serviceLine.getChildElement('modifierCode', null).getText() : '--';
                retWrap.dx = freq.diagnosisCode;
                retWrap.feeScheduleNo = freq.feeScheduleNumber;
                retWrap.type = serviceLine.getChildElement('unitTypeCode', null) != null ? serviceLine.getChildElement('unitTypeCode', null).getText() : '--';
                retWrap.count = serviceLine.getChildElement('numberOfUnits', null) != null ? serviceLine.getChildElement('numberOfUnits', null).getText() : '--';
                retWrap.billedAmount = serviceLine.getChildElement('chargeAmount', null) != null ? '$ ' + serviceLine.getChildElement('chargeAmount', null).getText() : '--';
                retWrap.fee = serviceLine.getChildElement('feeScheduleAmount', null) != null ? '$ ' +serviceLine.getChildElement('feeScheduleAmount', null).getText() : '--';
            }            
        }else{
            return null;
        }
        System.debug(JSON.serialize(retWrap));
        return retWrap;
    }

    public class FeeRequst
    {
        public String sourceId;
        public String cosmosUserId;
        public String password;
        public String securityToken;
        public String facetsUserId;
        public String div;
        public String fromDateOfService;
        public String toDateOfService;
        public String zipPrefix;
        public String zipSuffix;
        public String zip;
        public String percent;
        public String providerId;
        public String providerType;
        public String genderCode;
        public String market;
        public String marketType;
        public String placeOfServiceCode;
        public String productCode;
        public String productOfferId;
        public String diagnosisCode;
        public String icdVersionIndicator;
        public String numberOfUnits;
        public String unitType;
        public String chargeAmount;
        public String ipa;
        public String ioRateTableNumber;
        public String feeScheduleNumber;
        public String contractPayMethod;
        public String facilityContractCode;
        public String specialtyNumber;
        public String contractId;
        public String pcpInd;
        public String penaltySwitch;
        public String taxId;
        public String providerNetworkType;
        public String providerNetworkId;
        public String searchLimit;
        public String moreData;
        public String nextCode;
        public String nextDate;
        public String nextMod;
        // Multiple inputs
        public List<String> procedureCode;
        public List<String> revenueCode;
        public List<String> revenueTypeIndicators;
        public List<String> modifier;
    }

    public class FeeResponse
    {
        @AuraEnabled public String startDate;
        @AuraEnabled public String endDate;
        @AuraEnabled public String pos;
        @AuraEnabled public String cptHcpc;
        @AuraEnabled public String modifier;
        @AuraEnabled public String dx;
        @AuraEnabled public String feeScheduleNo;
        @AuraEnabled public String type;
        @AuraEnabled public String count;
        @AuraEnabled public String billedAmount;
        @AuraEnabled public String fee;
    }
}