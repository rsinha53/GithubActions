public with sharing class ACETLGT_UpdateCOBDetails {

    public static String primaryIndicator = 'primaryIndicator';
    public static String dateconst = '\"date\":';
    private static String getRequestBody(UpdateCOBWrapper cobWrap){
        String requestBody='';
        if(cobWrap.relationshipcode == 'null'){
            cobWrap.relationshipcode = '';
        }
        String ssn = String.isNotBlank(cobWrap.ssn)?cobWrap.ssn.replaceAll('-', ''):'';
        requestBody =   '{"updateIndividualMembershipRequest": {'
                        +'"individualMembership": {'
                        +'"groupNumber":'+ cobWrap.groupNumber +' ,'
                        +'"subscriberIDCardSerialNumber": "'+ cobWrap.scrId+'",'
                        +'"memberIDCardSerialNumber":'+ cobWrap.memberId +' ,'
                        +'"name": {'
                        +'"lastName": "'+ cobWrap.lastName +'",'
                        +'"firstName": "'+ cobWrap.firstname +'",'
                        +'"middleName": "'+ cobWrap.middleName +'",'
                        +'"nameSuffix": "'+ getSuffixCode(cobWrap.nameSuffix) +'"'
                        +'},'
                        +'"socialSecurityNumber":"'+ ssn +'" ,'                                            
                        +'"gender": "'+ cobWrap.gender +'",'
                        +'"birthDate": "'+ cobWrap.dob +'",'
        				+'"relationShipCode":"'+ cobWrap.relationshipcode +'",';
        system.debug('requestBody@@'+cobWrap.address[0]);
        if(String.isNotBlank(cobWrap.pcpId)){                
            requestBody = requestBody +'"providers": [{'
                +'"providerIdentifiers":[ {' 
                +'"id":"'+ cobWrap.npiVal +'",'
                +'"type":"'+ cobWrap.npiType +'"'
                +'}],'
                +'"assignmentType": "'+ cobWrap.pcpAssignmentType +'",'
                +'"effectiveStartDate": "'+ cobWrap.pcpStartDate +'",'
                +'"effectiveEndDate": "",' 
                +'"locationAffiliationID": "'+ cobWrap.pcpId +'",'
                +'"existingPatientIndicator": "'+cobWrap.existpatientindicator+'"'
                +'}]';                                  
        }else if(cobWrap.cobData!=null && cobWrap.cobData){      
            requestBody = requestBody +'"cob": [{'
                +'"otherInsuranceIndicator": "'+cobWrap.otherInsuranceIndicator+'",'
                +'"otherInsuranceCoverageType": "'+cobWrap.otherInsuranceCoverageType+'",'
                +'"otherInsuranceEffectiveStartDate": "'+ACETWebserviceHelper.formatToYYYYMMDD(ACETWebserviceHelper.formatDateFromDashToSlash(cobWrap.otherInsuranceEffectiveStartDate))+'",'
                +'"otherInsuranceEndDate": "'+ACETWebserviceHelper.formatToYYYYMMDD(ACETWebserviceHelper.formatDateFromDashToSlash(cobWrap.otherInsuranceEndDate))+'",'
                +'"otherInsuranceVerificationDate": "'+ACETWebserviceHelper.formatToYYYYMMDD(ACETWebserviceHelper.formatDateFromDashToSlash(cobWrap.otherInsuranceVerificationDate))+'",'
                +'"custodyCode": "'+cobWrap.custodyCode+'",'
                +'"otherInsurancePolicyNumber": "'+cobWrap.otherInsurancePolicyNumber+'",'
                +'"otherInsuranceType": "'+cobWrap.otherInsuranceType+'",'
                +'"primacyIndicator": "'+cobWrap.primacyIndicator+'",'
                +'"otherInsuranceCardholderFirstName": "'+cobWrap.otherInsuranceCardholderFirstName+'",'
                +'"otherInsuranceCardholderLastName": "'+cobWrap.otherInsuranceCardholderLastName+'",'
                +'"medicareIndicator": "'+cobWrap.medicareIndicator+'",'
                +'"entitlementType": "'+cobWrap.entitlementType+'",'
                +'"entitlementTypeReason": "'+cobWrap.entitlementTypeReason+'"'
                +'}]';
        }else if(cobWrap.address.size()>0){
            requestBody = requestBody +'"address": [';
            system.debug('addr##'+cobWrap.address);
            for(address addr : cobWrap.address) { 
                if(String.isNotBlank(addr.addressLine1) || String.isNotBlank(addr.addressLine2) || String.isNotBlank(addr.city) || String.isNotBlank(addr.stateCode) || String.isNotBlank(addr.postalCode)){
                    system.debug('addr##'+addr);
                    requestBody = requestBody +'{'
                        +'"addressTypeCode": "'+getAddressTypeCode(addr.addressTypeCode)+'",'
                        +'"addressLine1": "'+addr.addressLine1+'",'
                        +'"addressLine2": "'+addr.addressLine2+'",'
                        +'"city": "'+addr.city+'",'
                        +'"stateCode": "'+addr.stateCode+'",'
                        +'"countryCode": "US",'
                        +'"postalCode": "'+addr.postalCode+'"'
                        +'},';
                }
            }      
            requestBody = requestBody.substring(0,requestBody.length()-1); 
            requestBody = requestBody +']';
        }
        
        requestBody +=' }'+'}'+'}';  
        system.debug('@Request Body '+requestBody);
        return requestBody;
    }
    
    public static String getSuffixCode(String suffix){
        String suffixCode='';
        Switch on suffix{
            when 'I'{
                suffixCode = '1';
            }
            when 'II'{
                suffixCode = '2';
            }
            when 'III'{
                suffixCode = '3';
            }
            when 'IV'{
                suffixCode = '4';
            }
            when 'V'{
                suffixCode = '5';
            }
            when 'VI'{
                suffixCode = '6';
            }
            when 'VII'{
                suffixCode = '7';
            }
            when 'VIII'{
                suffixCode = '8';
            }
            when 'Jr'{
                suffixCode = 'JR';
            }
            when 'Sr'{
                suffixCode = 'SR';
            }
            when else{
                suffixCode = '';
            }
        }
        return suffixCode;
    }
    
    public static String getAddressTypeCode(String addressType){
        String addressTypeCode='';
        Switch on addressType{
            when 'Mail'{
                addressTypeCode = 'MAIL';
            }
            when 'Work'{
                addressTypeCode = 'WRK';
            }
            when 'Home'{
                addressTypeCode = 'HOM';
            }
            when else{
                addressTypeCode = '';
            }
        }
        return addressTypeCode;
    }
    
    @auraEnabled
    public static ACETLGT_WSCalloutResult updateMembers(String cobData, String addressData){
        system.debug('@@@cobWrapaddress '+addressData);
        system.debug('@@@cobWrapcobData '+cobData);
        ACETLGT_WSCalloutResult updateResult = new ACETLGT_WSCalloutResult();  
        try {            
            UpdateCOBWrapper cobWrap = new UpdateCOBWrapper();
            cobWrap = (UpdateCOBWrapper)JSON.deserialize(cobData, UpdateCOBWrapper.class);
            list<address> addWrap = (list<address>)JSON.deserialize(addressData, list<address>.class);
            system.debug('@@@cobWrap '+cobWrap);
            cobWrap.address = addWrap;
            system.debug('@@@cobWrap '+cobWrap.address);
            String requestBody = GetRequestBody(cobWrap);
            system.debug('@@@requestBody '+requestBody);
            ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework('updateIndividualMembershipService',requestBody,null);
            HttpResponse httpResponse = wsCallOutFW.getResponse();
            Integer statusCode = httpResponse.getStatusCode();
            String body = httpResponse.getBody();       
            if(statusCode == 200 && body != null){
                //replace date with date2 as date is preserved keyword
                String responseBody = body.replace(dateconst, '\"date2\":');
                system.debug('responseBody'+ responseBody);
                responseBody = body.replace('\"type\":', '\"type_Z\":');  
                Type resultType = Type.forName('ACETLGT_UpdateIndividualJSON2APEX');
                ACETLGT_UpdateIndividualJSON2APEX memberUpdateResult = (ACETLGT_UpdateIndividualJSON2APEX)JSON.deserialize(responseBody, resultType);   
                system.debug('memberUpdateResultBidy '+ memberUpdateResult);
                ACETLGT_UpdateIndividualJSON2APEX.cls_response res = memberUpdateResult.UpdateIndividualMembershipResponse.response; 
                if(responseBody.contains('responseCode') && res.responseCode == '200'){
                    updateResult.Success = true;
                    updateResult.Message = '';
                    updateResult.Response = memberupdateResult;                           
                }else if(responseBody.contains('responseCode') && res.responseCode != '200' && String.isNotBlank(cobWrap.pcpId)){
                    UpdateResult.MessageSeverity = ApexPages.Severity.INFO;
                    UpdateResult.message = Label.ACETPCPCannotBeAssigned;  
                    UpdateResult.Success = false;   
                    UpdateResult.statusCode=207;
                } else if(responseBody.contains('responseCode') && res.responseCode != '200' && !String.isNotBlank(cobWrap.pcpId)){
                    UpdateResult.MessageSeverity = ApexPages.Severity.INFO;
                    UpdateResult.message =  Label.ACET_UpdateFailed+' '+res.responseDesc;  
                    UpdateResult.Success = false;   
                    UpdateResult.statusCode=208;
                }                                                   
            }else{
                updateResult = processErrorResponse(statusCode, body);          
            }
           
        }
        catch(Exception e){
            system.debug(e);
            updateResult.MessageSeverity = ApexPages.Severity.ERROR;
            updateResult.Success = false;
            updateResult.Message = 'Web Service or External System is temporarily unavailable.';
            updateResult.statusCode=999;       
            
        }
        
        return updateResult;    
    } 
    
    private static ACETLGT_WSCalloutResult processErrorResponse(Integer statusCode, String body){
        String resperror = '';
        if(body != null){
            //replace date with date2 as date is preserved keyword
            String responseBody = body.replace(dateconst, '\"date2\":');
            responseBody = body.replace('\"type\":', '\"type_Z\":');  
            Type resultType = Type.forName('ACETLGT_UpdateIndividualJSON2APEX');
            ACETLGT_UpdateIndividualJSON2APEX memberUpdateResult = (ACETLGT_UpdateIndividualJSON2APEX)JSON.deserialize(responseBody, resultType);
            list<ACETLGT_UpdateIndividualJSON2APEX.cls_error> res = new list<ACETLGT_UpdateIndividualJSON2APEX.cls_error>();
            res = memberUpdateResult.UpdateIndividualMembershipResponse.errors; 
            resperror = (responseBody.contains('errors')&&res.size()>0)?res[0].description:'';
        }
        ACETLGT_WSCalloutResult updateResult = new ACETLGT_WSCalloutResult();
        if(statusCode == 500){
            //currently servce returns 500 if no records found
            updateResult.MessageSeverity = ApexPages.Severity.INFO;
            updateResult.message =ACETWebserviceHelper.getErrorMessageFromCode(statusCode);
            System.debug('updateResult.message ='+updateResult.message);  
            updateResult.Success = false;                              
        }else if(statusCode == 404 || statusCode == 400){                
            //currently servce returns 404 or 400 if no records found (Adapters)
            updateResult.MessageSeverity = ApexPages.Severity.INFO;
            updateResult.Success = false;
            updateResult.message = Label.ACET_UpdateFailed+' '+resperror.replace('SSN Status: WARNING: Record received cannot update record on system when SSN type is satisfied.-','');               
        }
        return updateResult;
    } 
      
    public class UpdateCOBWrapper{
        @auraEnabled public String memberId;
        @auraEnabled public String scrId;
        @auraEnabled public String groupNumber;
        @auraEnabled public String lastName;
        @auraEnabled public string firstname;
        @auraEnabled public string middleName;
        @auraEnabled public string nameSuffix;
        @auraEnabled public string ssn;
        @auraEnabled public string gender;
        @auraEnabled public string dob;
        @auraEnabled public string relationshipcode;
        @auraEnabled public String emlindicator;
        @auraEnabled public String emailId;
        @auraEnabled public String commCode; 
        @auraEnabled public List<ACETLGT_MemberSearchCoveragesResult.Phone> phoneList;
        @auraEnabled public String pcpId;
        @auraEnabled public String pcpAssignmentType;
        @auraEnabled public String pcpStartDate;
        @auraEnabled public String pcpEffectiveEndDate;
        @auraEnabled public String npiType;
        @auraEnabled public String npiVal;
        @auraEnabled public String existpatientindicator;
        @auraEnabled public Boolean cobData;
        @auraEnabled public String otherInsuranceIndicator;
        @auraEnabled public String otherInsuranceCoverageType;
        @auraEnabled public String otherInsuranceEffectiveStartDate;
        @auraEnabled public String otherInsuranceEndDate;
        @auraEnabled public String otherInsuranceVerificationDate;
        @auraEnabled public String custodyCode;
        @auraEnabled public String otherInsurancePolicyNumber;
        @auraEnabled public String otherInsuranceType;
        @auraEnabled public String primacyIndicator;
        @auraEnabled public String otherInsuranceCardholderFirstName;
        @auraEnabled public String otherInsuranceCardholderLastName;
        @auraEnabled public String medicareIndicator;
        @auraEnabled public String entitlementType;
        @auraEnabled public String entitlementTypeReason;
        @auraEnabled public list<address> address;
        public updateCOBWrapper(){
            this.entitlementTypeReason='';
            this.entitlementType='';
            this.medicareIndicator='';
            this.otherInsuranceCardholderLastName='';
            this.otherInsuranceCardholderFirstName='';
            this.primacyIndicator='';
            this.otherInsuranceType='';
            this.otherInsurancePolicyNumber='';
            this.custodyCode='';
            this.otherInsuranceVerificationDate='';
            this.otherInsuranceEndDate='';
            this.otherInsuranceEffectiveStartDate='';
            this.otherInsuranceCoverageType='';
            this.otherInsuranceIndicator='';
            this.cobData=false;
            this.existpatientindicator='';
            this.npiVal='';
            this.npiType='';
            this.pcpEffectiveEndDate='';
            this.pcpStartDate='';
            this.pcpAssignmentType='';
            this.pcpId='';
            this.commCode='';
            this.emailId='';
            this.emlindicator='';
            this.relationshipcode='';
            this.dob='';
            this.gender='';
            this.ssn='';
            this.nameSuffix='';
            this.middleName='';
            this.firstname='';
            this.lastname='';
            this.groupNumber='';
            this.scrId='';
            this.memberId='';
            this.address = new list<address>();
        }
    }
    
    public class address{
        @auraEnabled public String addressTypeCode;
        @auraEnabled public String addressLine1;
        @auraEnabled public String addressLine2;
        @auraEnabled public String city;
        @auraEnabled public String stateCode;
        @auraEnabled public String postalCode;
        @auraEnabled public String countryCode;
        public address(){
            this.countryCode = 'US';
        }
    }
}