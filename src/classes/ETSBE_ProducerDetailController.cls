public class ETSBE_ProducerDetailController {
    @AuraEnabled
    Public static responseWrapper getProducerDetail(String producerId){
        String response;
        responseWrapper producerdata = new responseWrapper();
        System.debug('PASSED PRODUCER ID: ' + producerId);
        ETSBE_GetBrokerSearchWebservice getBroker = new ETSBE_GetBrokerSearchWebservice();
        ACETWSCalloutResult CalloutResult = getBroker.getProducer(producerId);
        if(CalloutResult.Success != null && CalloutResult.Success){
            ETSBE_ProducerResults resultWrapper = (ETSBE_ProducerResults)CalloutResult.Response;
            System.debug('RETURNED RESULTWRAPPER: ' + resultWrapper);
            if(resultWrapper != null){
                producerdata.type = (resultWrapper.producerType != null)?resultWrapper.producerType:'';
                if(resultWrapper.producerIndividualName != null){
                	producerdata.firstName = (resultWrapper.producerIndividualName.firstName != null)?resultWrapper.producerIndividualName.firstName:'';
                    producerdata.middleinitial = (resultWrapper.producerIndividualName.middleInitial != null)?resultWrapper.producerIndividualName.middleInitial:'';
                	producerdata.lastname = (resultWrapper.producerIndividualName.lastName != null)?resultWrapper.producerIndividualName.lastName:'';
                }
                producerdata.producerId = (resultWrapper.producerID != null)?resultWrapper.producerID:'';
                producerdata.taxid = (resultWrapper.producerTIN != null)?resultWrapper.producerTIN:'';
                producerdata.ssn = (resultWrapper.producerSSN != null)?resultWrapper.producerSSN:'';
                if(producerdata.ssn != '' && producerdata.ssn != null){
                     string ssn = resultWrapper.producerSSN;
                    
                    System.debug('mmmmmmm'+ssn);
                if(ssn.length()==9)
                   producerdata.ssn = ssn.substring(0, 3) + '-' + ssn.substring(3, 5) + '-' + ssn.substring(5, 9);
                    String valueToMask = producerdata.ssn.substring(0,producerdata.ssn.length()-4);
                    String mask = 'x'.repeat(valueToMask.length());
                    producerdata.maskedssn = mask+ssn.substring(ssn.length()-4,ssn.length());
                    string maskedssn=producerdata.maskedssn;
                    if(maskedssn.length()==9)
                    producerdata.maskedssn = maskedssn.substring(0, 3) + '-' + maskedssn.substring(3, 5) + '-' + maskedssn.substring(5, 9);
                }
                producerdata.agencyName = (resultWrapper.producerCompanyName != null)?resultWrapper.producerCompanyName:'';
                producerdata.primarycontactname = (resultWrapper.producerContact != null)?resultWrapper.producerContact:'';
                List<String> legacyList = new List<String>();
                String legacyStr = '';
                if(resultWrapper.legacyProducers != null && resultWrapper.legacyProducers.size() > 0){
                    for(ETSBE_ProducerResults.LegacyProducers legacyResult: resultWrapper.legacyProducers){
                        if(legacyResult.legacyProducerID != null && legacyResult.legacyProducerID != ''){
                            legacyList.add(legacyResult.legacyProducerID);
                        }
                    }
                }
                if(legacyList.size() > 0){
                    legacyStr = string.join(legacyList,',');
                }
                producerdata.Legacybrokercode = legacyStr;
                List<ACETProducerDemography> addressList = new List<ACETProducerDemography>();
                ETSBE_ProducerResults.Address demography = resultWrapper.producerAddress;
                ACETProducerDemography addressInfo = new ACETProducerDemography(); 
                addressInfo.addressType = (demography.addressTypeCode != null)?demography.addressTypeCode:'';
                String streetAddr = (demography.producerStreetLine1 != null)?demography.producerStreetLine1:'';
                streetAddr = (demography.producerStreetLine2 != null && demography.producerStreetLine2 != '')?streetAddr + ',' + demography.producerStreetLine2:streetAddr;
                addressInfo.streetAddress =streetAddr;
                addressInfo.city = (demography.producerCity != null)?demography.producerCity:'';
                addressInfo.zip = (demography.producerZipCode != null)?demography.producerZipCode:'';
                addressInfo.state = (demography.producerState != null)?demography.producerState:'';
                String phoneNum = (demography.producerPhoneNumber != null)?demography.producerPhoneNumber:'';
                if(!phoneNum.contains('-') && phoneNum.length() == 10){
                    phoneNum = phoneNum.substring(0,3) + '-' + phoneNum.substring(3,6) + '-' + phoneNum.substring(6,phoneNum.length());
                }
                addressInfo.phone = phoneNum;
                addressList.add(addressInfo);
                producerdata.addressInfo = addressList;
            }
        }
        /*
          ACETProducerResult producerDetailresult;
        ACETWSCalloutResult GetProducergroupResponse;
        ACETGetProducerAdapterWebservice ACETPDWS = new ACETGetProducerAdapterWebservice();
        GetProducergroupResponse = ACETPDWS.GetProducer(producerId);
            if(GetProducergroupResponse.Success){
                producerDetailresult = (ACETProducerResult)GetProducergroupResponse.Response;
                system.debug(',,,,,,,,,,,,,,,,'+producerDetailresult);
                producerdata.type = producerDetailresult.type;
                producerdata.firstName = producerDetailresult.firstName;
                producerdata.lastname = producerDetailresult.lastName;
                producerdata.producerId = producerDetailresult.producerId;
                producerdata.middleinitial = producerDetailresult.MiddleInitial;
                producerdata.taxid = producerDetailresult.tax_id;
                producerdata.ssn = producerDetailresult.tax_SSN;
                if(producerDetailresult.tax_SSN != '' && producerDetailresult.tax_SSN != null){
                     string ssn = producerDetailresult.tax_SSN;
                if(ssn.length()==9)
                   producerdata.ssn = ssn.substring(0, 3) + '-' + ssn.substring(3, 5) + '-' + ssn.substring(5, 9);
                    String valueToMask = producerDetailresult.tax_SSN.substring(0,producerDetailresult.tax_SSN.length()-4);
                    String mask = 'x'.repeat(valueToMask.length());
                    producerdata.maskedssn = mask+ssn.substring(ssn.length()-4,ssn.length());
                    string maskedssn=producerdata.maskedssn;
                    if(maskedssn.length()==9)
                    producerdata.maskedssn = maskedssn.substring(0, 3) + '-' + maskedssn.substring(3, 5) + '-' + maskedssn.substring(5, 9);
                }
                producerdata.agencyName = producerDetailresult.CompanyName;
                producerdata.primarycontactname = producerDetailresult.primaryContactName;
                producerdata.Legacybrokercode = producerDetailresult.legacyBrokerCode;
                List<ACETProducerDemography> addressList = new List<ACETProducerDemography>();
                for(ACETProducerResult.ACETProducerDemography demography : producerDetailresult.addresslist){
                    ACETProducerDemography addressInfo = new ACETProducerDemography(); 
                    addressInfo.addressType = demography.addressType;
                    addressInfo.streetAddress =demography.streetAddress;
                    addressInfo.city = demography.city;
                    addressInfo.zip = demography.zip;
                    addressInfo.state = demography.state;
                    addressInfo.phone = demography.phone;
                    addressInfo.country = demography.country;
                    addressList.add(addressInfo);
                }
                producerdata.addressInfo = addressList;
                system.debug(',,,,,,,,,producerdata,,,,,,,'+producerdata);
            }*/
        return producerdata;
    }
    Public class responseWrapper{
    
        @AuraEnabled Public string firstName;
        @AuraEnabled Public string producerId;
        @AuraEnabled Public  String middleinitial;
        @AuraEnabled Public string taxid;
        @AuraEnabled Public string lastname;
        @AuraEnabled Public string ssn;
        @AuraEnabled Public string maskedssn;
        @AuraEnabled Public String agencyName;
        @AuraEnabled Public String primarycontactname;
        @AuraEnabled Public String Legacybrokercode;
        @AuraEnabled Public String type;
        @AuraEnabled public List<ACETProducerDemography> addressInfo;
    }
     public class ACETProducerDemography
    {
       @AuraEnabled  public String addressType ;
       @AuraEnabled  public String streetAddress ;
       @AuraEnabled  public String city;
       @AuraEnabled  public String zip ;
       @AuraEnabled  public String state ;
       @AuraEnabled  public String phone ;
       @AuraEnabled  public String country ;
    }
}