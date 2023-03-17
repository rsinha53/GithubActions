public class ACETUpdateIndividualWebService extends ACETWebService {

    public override void getEndpoint(){
        GetEndpointDetail('UpdateIndividualMemberEndpoint');         
    }
    public override void GetMethod(){
       Method = 'PUT';          
    }
    public ACETUpdateIndividualWebService() {
        super('Stargate');
    }
    public void getRequestBody(String memberId, String scrId, String groupNumber, String lastName,string firstname,string middleName, string nameSuffix,string ssn,string gender,string dob,string relationshipcode, String emlindicator, String emailId,String commCode, List<ACETMemberDetail.Phone> PhoneList,String pcpId,String pcptype,String pcpAssignmentType,String pcpStartDate,String pcpEffectiveEndDate, String npiType,String npiVal,String existpatientindicator){
        if(phoneList != null && phoneList.size() > 0){
										   
                RequestBody =   '{"updateIndividualMembershipRequest": {'
                                        +'"individualMembership": {'
                                        +'"groupNumber":"'+ groupNumber +'" ,'
                                        +'"subscriberIDCardSerialNumber": "'+ scrId+'",'
                                        +'"memberIDCardSerialNumber":"'+ memberId +'" ,'
                                        +'"name": {'
                                                +'"lastName": "'+ lastName +'",'
                                                +'"firstName": "'+ firstname +'",'
                                                +'"middleName": "'+ middleName +'",'
                                                +'"nameSuffix": "'+ nameSuffix +'"'
                                        +'},'
                                        +'"socialSecurityNumber":"'+ ssn +'" ,'                                            
                                        +'"gender": "'+ gender +'",'
                                        +'"birthDate": "'+ formatDate(dob) +'",'                                            
                                        +'"phone": [';
																  
                 for(ACETMemberDetail.Phone phn : phoneList) {                          
                     RequestBody =          RequestBody +'{'
                                                    +'"phoneType": "'+ phn.PhoneNumberType +'",'
                                                    +'"phoneNumber": "'+ phn.PhoneNumber +'",'
                                                    +'"phoneExt": "'+ phn.WorkExt +'",'
                                                    +'"primaryIndicator": "'+ phn.primaryIndicator +'"'
                                                +'},' ;
                 } 
																  
                 RequestBody = RequestBody.substring(0,RequestBody.length()-1); 
																   
                 RequestBody =          RequestBody +'],';
																  
                 if(emailId != ''){    
                 RequestBody =          RequestBody +'"email": [{'
                                                +'"communicationTypeCode": "'+ commCode +'",'
                                                +'"electronicAddress": "'+ emailId +'",'
                                                +'"primaryIndicator": "'+ emlindicator +'"'
                                            +'}],';
                 }
																  
                 RequestBody =              RequestBody +'"relationShipCode":"'+ relationshipcode +'"'
                                        +' }'
                                    +'}'
                                +'}';           
            
        }else if(emailId != null && emailId != '' && commCode != '' && emlindicator != ''){
														   
                RequestBody =   '{"updateIndividualMembershipRequest": {'
                                        +'"individualMembership": {'
                                            +'"groupNumber":"'+ groupNumber +'" ,'
                                            +'"subscriberIDCardSerialNumber": "'+ scrId+'",'
                                            +'"memberIDCardSerialNumber":"'+ memberId +'" ,'
                                            +'"name": {'
                                                +'"lastName": "'+ lastName +'",'
                                                +'"firstName": "'+ firstname +'",'
                                                +'"middleName": "'+ middleName +'",'
                                                +'"nameSuffix": "'+ nameSuffix +'"'
                                            +'},'
                                            +'"socialSecurityNumber":"'+ ssn +'" ,'                                            
                                            +'"gender": "'+ gender +'",'
                                            +'"birthDate": "'+ formatDate(dob) +'",' ; 
                 
                 RequestBody =              RequestBody +'"email": [{'                                           
                                                +'"communicationTypeCode": "'+ commCode +'",'
                                                +'"electronicAddress": "'+ emailId +'",'
                                                +'"primaryIndicator": "'+ emlindicator +'"'
                                            +'}],'
                                            +'"relationShipCode":"'+ relationshipcode +'"'
                                        +' }'
                                    +'}'
                                +'}';           
																			
            
        }else if(!String.isEmpty(pcpId)){
            
                if(relationshipcode == 'null'){
                    relationshipcode = '';
                }           
                RequestBody =   '{"updateIndividualMembershipRequest": {'
                                        +'"individualMembership": {'
                                            +'"groupNumber":"'+ groupNumber +'" ,'
                                            +'"subscriberIDCardSerialNumber": "'+ scrId+'",'
                                            +'"memberIDCardSerialNumber":"'+ memberId +'" ,'
                                            +'"name": {'
                                                +'"lastName": "'+ lastName +'",'
                                                +'"firstName": "'+ firstname +'",'
                                                +'"middleName": "'+ middleName +'",'
                                                +'"nameSuffix": "'+ nameSuffix +'"'
                                            +'},'
                                            +'"socialSecurityNumber":"'+ ssn +'" ,'                                            
                                            +'"gender": "'+ gender +'",'
                                            +'"birthDate": "'+ formatdate(dob) +'",'                                            
                                            +'"relationShipCode":"'+ relationshipcode +'",'
                                            +'"providers": [{'
                                                +'"providerIdentifiers":[ {' 
                                                    +'"id":"'+ npiVal +'",'
                                                    +'"type":"'+ npiType +'"'
                                                +'}],'
                                                +'"assignmentType": "'+ pcpAssignmentType +'",'
                                                +'"effectiveStartDate": "'+ pcpStartDate +'",'
                                                +'"effectiveEndDate": "",' //pcpEffectiveEndDate 
                                                +'"locationAffiliationID": "'+ pcpId +'",'
                                                +'"existingPatientIndicator": "'+existpatientindicator+'"'
                                            +'}],'
                                            +'"relationShipCode":"'+ relationshipcode +'"'
                                        +' }'
                                    +'}'
                                +'}'; 
													   
        }
       system.debug('Request body' + RequestBody);                                     
    }    
    
    public ACETWSCalloutResult updateMembers(String memberId,String scrId, String groupNumber, String lastName,string firstname,string middleName, string nameSuffix,string ssn,string gender,string dob,string relationshipcode, String emlindicator, String emailId,String commCode, List<ACETMemberDetail.Phone> PhoneList,String pcpId,String pcptype,String pcpAssignmentType,String pcpStartDate,String pcpEffectiveEndDate,String npiType,String npiVal,String existpatientindicator){
        
        ACETWSCalloutResult UpdateResult = new ACETWSCalloutResult();
           
        try {
            ServiceName = 'updateIndividualMembershipService';
            GetEndpoint();                       
            GetRequestBody( memberId,  scrId, groupNumber, lastName, firstname, middleName, nameSuffix, ssn, gender, dob, relationshipcode, emlindicator, emailId, commCode, PhoneList, pcpId, pcptype, pcpAssignmentType, pcpStartDate, pcpEffectiveEndDate,npiType,npiVal,existpatientindicator);
            GetMethod();
            HttpResponse response;  
            if(RequestBody != null )
                response = Send(OAuthConfig);          
            system.debug('----------->'+ response);    
            
            UpdateResult.statusCode=response!=null?response.getStatusCode():null;       
            if(response != null && response.getStatusCode() == 200){
                if(response.getBody() != null){
                        
                        //replace date with date2 as date is preserved keyword
                            String responseBody = response.getBody().replace('\"date\":', '\"date2\":');
                            system.debug('responseBody'+ responseBody);
                            responseBody = response.getBody().replace('\"type\":', '\"type_Z\":');  
                            Type resultType = Type.forName('ACETUpdIndividualMemResJSON2Apex');
                            ACETUpdIndividualMemResJSON2Apex memberUpdateResult = (ACETUpdIndividualMemResJSON2Apex)JSON.deserialize(responseBody , resultType);                      
                            ACETUpdIndividualMemResJSON2Apex.cls_response res = memberUpdateResult.UpdateIndividualMembershipResponse.response; 
                            if(responseBody.contains('responseCode') && res.responseCode == '200'){
                          String rescode = res.responseCode;
                          String resdesc = res.responseDesc;
                          UpdateResult.Success = true;
                          UpdateResult.Message = '';
                          UpdateResult.Response = memberUpdateResult;                           
                        } else if(responseBody.contains('responseCode') && res.responseCode != '200' && String.isNotBlank(pcpId)){
                          //Code added by Avish on 05/032018 for US1091062 for handling update failed logic for PCP/OBGYN
                        UpdateResult.MessageSeverity = ApexPages.Severity.INFO;
                        UpdateResult.message = 'PCP/OBGYN cannot be assigned.';  
                        UpdateResult.Success = false;   
                        UpdateResult.statusCode=207;
                        } else if(responseBody.contains('responseCode') && res.responseCode != '200' && !String.isNotBlank(pcpId)){
                          //Code added by Avish on 05/032018 for US1091062 for handling update failed logic for PCP/OBGYN
                        UpdateResult.MessageSeverity = ApexPages.Severity.INFO;
                        UpdateResult.message = 'Update failed.';  
                        UpdateResult.Success = false;   
                        UpdateResult.statusCode=208;
                        }else{
                          String rescode = res.responseCode;
                          String resdesc = res.responseDesc;
                          UpdateResult.Success = true;
                          UpdateResult.Message = '';
                          UpdateResult.Response = memberUpdateResult;
                        }                    
                    }                                      
                }else if(response.getStatusCode() == 500){
                    //currently servce returns 500 if no records found
                    UpdateResult.MessageSeverity = ApexPages.Severity.INFO;
                    //UpdateResult.message = 'System Unavailable'; 
                    UpdateResult.message =ACETWebserviceHelper.getErrorMessageFromCode(response.getStatusCode());
                    System.debug('UpdateResult.message ='+UpdateResult.message);  
                    UpdateResult.Success = false;                              
                }else if(response.getStatusCode() == 404){                
                    //currently servce returns 404 if no records found (Adapters)
                    UpdateResult.MessageSeverity = ApexPages.Severity.INFO;
                    UpdateResult.Success = false;
                    UpdateResult.message = 'Update failed';               
                }
                else if(response.getStatusCode() == 400){                
                    UpdateResult.MessageSeverity = ApexPages.Severity.INFO;
                    UpdateResult.Success = false;
                    UpdateResult.message = 'Update failed';                
                }
            }
            catch(Exception e){
                    system.debug(e);
                    UpdateResult.MessageSeverity = ApexPages.Severity.ERROR;
                    UpdateResult.Success = false;
                    UpdateResult.Message = 'Web Service or External System is temporarily unavailable.';
                    UpdateResult.statusCode=999;       

            }
        
        return UpdateResult;    
    } 
    public String formatDate(String dateString){
        if(dateString == null) return null;
        
        List<String> dateParts = dateString.split('/');
        if(dateParts.size() == 3){
            String mm = dateParts[0];
            String dd = dateParts[1];
            String yyyy = dateParts[2];            
            mm = mm.length() == 1 ? '0'+mm : mm ; 
            dd = dd.length() == 1?  '0'+dd  : dd; 
                                   
            return yyyy  + '-' + mm + '-' + dd;
        }else{
            return dateString;
        }
    }
}