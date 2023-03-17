public class ACETGetIndividualWebService extends ACETWebService{
    public override void getEndpoint(){
        GetEndpointDetail('GetIndividualEndpoint'); 
    }
     public ACETGetIndividualWebService() {
       if(!Test.isRunningTest()){
          super('Stargate');
          }
    }
    public void getRequestBody(String identifier){
        RequestBody = '{"getIndividualRequest" : {"identifier": "'+identifier+'","identifierType": "SRK"}}';               
    }

    public ACETWSCalloutResult getIndividual(String memberId, ACETMemberDetail memberDetail){
        if(memberDetail == null){
            memberDetail = new ACETMemberDetail();
        }

        ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();
        try {
            HttpResponse  response;
            getEndpoint();
            getRequestBody(memberId);
            
            response = Send(OAuthConfig); 
            //response.setStatusCode(500);
            if(response!=null){
             calloutResult.statusCode=response.getStatusCode();

            if(response.getStatusCode() == 200){
                if(response.getBody() != null){
                        String responseBody = response.getBody().contains('\"date\":')?response.getBody().replace('\"date\":', '\"date2\":'):response.getBody();
                        responseBody = response.getBody().contains('\"desc\":')?responseBody.replace('\"desc\":', '\"desc2\":'):response.getBody();
                        
                        ACETGetIndividualJSON2APexADP jSON2Apex = (ACETGetIndividualJSON2APexADP)JSON.deserialize(responseBody, ACETGetIndividualJSON2APexADP.class);
                        system.debug('JSON2Apex : ' + jSON2Apex);
                        
                        ACETGetIndividualJSON2APexADP.cls_individual individual = json2Apex.getIndividualResponse.individual;                       
                        //This is incorrect
                       //memberDetail.MemberId = individual.individualIdentifier;
                    if(individual!=null){
                       if(individual.name!=null){
                           memberDetail.FirstName = String.isNotBlank(individual.name.firstName)?individual.name.firstName:'';
                           memberDetail.LastName = String.isNotBlank(individual.name.lastName)?individual.name.lastName:'';
                           memberDetail.MiddleName = String.isNotBlank(individual.name.middleName)?individual.name.middleName:'';
                           memberDetail.Suffix = String.isNotBlank(individual.name.nameSuffix)?individual.name.nameSuffix:'';
                           memberDetail.MiddleInitial = String.isNotBlank(individual.name.middleName)?individual.name.middleName:'';
                       }

                       memberDetail.DOB = String.isNotBlank(individual.birthDate)?formatDate(individual.birthDate):'';
                      
                       memberDetail.Gender = individual.genderCode;
                       memberDetail.Age = String.isNotBlank(individual.birthDate)?getAgeFromBirthday(individual.birthDate):'';  
                       memberDetail.SSN = individual.socialSecurityNumber;
                       memberDetail.FullSSN = String.isNotBlank(individual.socialSecurityNumber)?getSSNHyphen(individual.socialSecurityNumber):'';
                       for(EligibilityEmploymentStatusList__mdt empCode:[select EmploymentStatus__c, EmploymentStatusCode__c from EligibilityEmploymentStatusList__mdt order by EmploymentStatusCode__c asc]) {
                                  if(individual.employment.size()>0 && individual.employment[0].employmentStatus == empCode.EmploymentStatusCode__c){
                                    memberDetail.EmploymentStatus = empCode.EmploymentStatus__c;
                                  }
                       }
                       //memberDetail.EmploymentStatus = individual.employment[0].employmentStatus;
                       if(individual.employment.size()>0 && individual.employment[0].employmentStartDate!=null){
                           memberDetail.EmploymentStartDate = formatDate(individual.employment[0].employmentStartDate);
                       }
                        if(individual.email!=null){
                            for(ACETGetIndividualJSON2APexADP.cls_email emailObj : individual.email){
                                if(emailObj.primaryIndicator == 'Y'){
                                    memberDetail.email = String.isNotBlank(emailObj.electronicAddress)?emailObj.electronicAddress:'';
                                }
                            }
                        }
                        if(individual.deceasedDate!=null)
                            memberDetail.DeceasedDate = String.isNotBlank(individual.deceasedDate)?formatDate(individual.deceasedDate):'';
                        
                        MemberDetail.disabilityInfo = new List<ACETMemberDetail.DependentDisability>();
                        if(individual.dependentDisabilityList!=null && !individual.dependentDisabilityList.isEmpty()){
                            for(ACETGetIndividualJSON2APexADP.DisabilityList dis : individual.dependentDisabilityList){
                                ACETMemberDetail.DependentDisability disItem = new ACETMemberDetail.DependentDisability();
                                disItem.disabilityType = (dis.disabilityType!= null)?dis.disabilityType:'';
                                for(Disability_Information__mdt disCode:[select Disability_Type__c, Disability_Type_Description__c from Disability_Information__mdt ]) {
                                  if(disItem.disabilityType == disCode.Disability_Type__c){
                                    disItem.disabilityType = String.isNotBlank(disCode.Disability_Type_Description__c)?disCode.Disability_Type_Description__c:'';
                                  }
                                }
                                disItem.diagnosisCode = (dis.diagnosisCode!= null)?dis.diagnosisCode:'';
                                disItem.diagnosisCodeType = (dis.diagCodeType!= null)?(dis.diagCodeType == '9'?'ICD-9':(dis.diagCodeType == '0'?'ICD-10':'')):'';
                                disItem.effectiveDate = (dis.effectiveDate!= null)?string.valueOf(ACETUtility.format(Date.valueOf(dis.effectiveDate))):'';
                                disItem.endDate = (dis.expirationDate!= null)?string.valueOf(ACETUtility.format(Date.valueOf(dis.expirationDate))):'';
                                if(disItem.disabilityType != '')
                                    MemberDetail.disabilityInfo.add(disItem);
                            }
                            
                            MemberDetail.disability = (MemberDetail.disabilityInfo != null && MemberDetail.disabilityInfo.size() > 0?'Y':'N');
                        }
                        else
                            MemberDetail.disability ='N';
                        
                        MemberDetail.Addresses = new List<ACETMemberDetail.Address>();
                    if(individual.address!=null){
                        for(ACETGetIndividualJSON2APexADP.cls_address addr : individual.address){
                            ACETMemberDetail.Address address = new ACETMemberDetail.Address();
                            address.AddressLine1 = String.isNotBlank(addr.AddressLine1)?addr.AddressLine1:''; 
                            address.AddressLine2 = String.isNotBlank(addr.AddressLine2)?addr.AddressLine2:'';
                            address.City = String.isNotBlank(addr.City)?addr.City:'';
                            address.State = String.isNotBlank(addr.stateCode)?addr.stateCode:'';
                            address.Zip = String.isNotBlank(addr.postalCode)?addr.postalCode:'';
                            if (addr.typeCode == 'HOM')
                                address.AddressType = 'Home'; 
                            else if (addr.typeCode == 'WRK')
                                address.AddressType = 'Work'; 
                            else if (addr.typeCode == 'BILL')
                                address.AddressType = 'Billing';
                            else if (addr.typeCode == 'MAIL')
                                address.AddressType = 'Mailing'; 
                            else if (addr.typeCode == 'PRAC')
                                address.AddressType = 'Practice'; 
                            MemberDetail.Addresses.add(address);
                        }
                    }
                        MemberDetail.Phones = new List<ACETMemberDetail.Phone>();
                     if(individual.phone!=null){
                        for(ACETGetIndividualJSON2APexADP.cls_phone telephone : individual.phone){
                            ACETMemberDetail.Phone phone = new ACETMemberDetail.Phone();
                            phone.PhoneNumber = String.isNotBlank(telephone.phoneNumber)?telephone.phoneNumber:'';
                            if(telephone.phoneType == 'H'){
                                phone.PhoneNumberType = 'Home';
                                 phone.WorkExt = String.isNotBlank(telephone.phoneExt)?telephone.phoneExt:'';//Code Added By Chandan -US1206900
                                 }
                            if(telephone.phoneType == 'F'){
                                phone.PhoneNumberType = 'Fax';
                                phone.WorkExt = String.isNotBlank(telephone.phoneExt)?telephone.phoneExt:'';//Code Added By Chandan -US1206900
                                 }
                            if(telephone.phoneType == 'W'){
                                phone.PhoneNumberType = 'Work';
                                phone.WorkExt = String.isNotBlank(telephone.phoneExt)?telephone.phoneExt:'';
                            }
                            if(telephone.phoneType == 'M')
                                phone.PhoneNumberType = 'Mobile';
                            if(telephone.primaryIndicator == 'Y')
                                phone.primaryIndicator = 'Primary';
                            else
                                phone.primaryIndicator = '';
                            MemberDetail.Phones.add(phone);
                        }
                       }
                        MemberDetail.ROIcontacts = new List<ACETMemberDetail.otherContact>();
                        system.debug('MemberDetail.ROIcontacts----1--->'+ MemberDetail.ROIcontacts + '---->'+individual.otherContact);
                       if(individual.otherContact!=null){
                        for(ACETGetIndividualJSON2APexADP.cls_otherContact otherCon : individual.otherContact){
                            ACETMemberDetail.otherContact ROIrec = new ACETMemberDetail.otherContact();
                            if(otherCon.name != null){
                                ROIrec.firstName = String.isNotBlank(otherCon.name.firstName)?otherCon.name.firstName:'';
                                ROIrec.middleName = String.isNotBlank(otherCon.name.MiddleName)?otherCon.name.MiddleName:'';
                                ROIrec.lastName = String.isNotBlank(otherCon.name.Lastname)?otherCon.name.Lastname:'';
                                ROIrec.docLink = '';
                                MemberDetail.ROIcontacts.add(ROIrec);
                            }
                            
                            //ROIrec.effectiveDate = formatDate('');
                            //ROIrec.terminationDate = formatDate('');
                          }  
                        }
                        system.debug('MemberDetail.ROIcontacts----2--->'+ MemberDetail.ROIcontacts);
       
                        calloutResult.Success = true;
                        calloutResult.Message = '';
                        System.debug('!!!!!!!!!!!!!!!!!!!!'+memberDetail );
                        calloutResult.Response = memberDetail;                                                
                }
             }
                system.debug('memberDetail.SurrogateKeys ::' + memberDetail.SurrogateKeys);
            }else if(response.getStatusCode() == 500){                
                //currently servce returns 500 if no records found
                calloutResult.MessageSeverity = ApexPages.Severity.INFO;
                calloutResult.Success = true;                
                calloutResult.Response = new ACETMemberDetail();
                system.debug(calloutResult); 
             } 
            }else{
                calloutResult.MessageSeverity = ApexPages.Severity.ERROR;
                calloutResult.Success = false;
                calloutResult.Message = 'Web Service or External System is temporarily unavailable.';
                calloutResult.statusCode=999;
             }
            }catch(Exception e){
                    system.debug(e.getStackTraceString());
                    system.debug(e.getMessage());
                    calloutResult.MessageSeverity = ApexPages.Severity.ERROR;
                    calloutResult.Success = false;
                    calloutResult.Message = 'Web Service or External System is temporarily unavailable.';
                    calloutResult.statusCode=999;

           }
        
        return calloutResult;    
    } 

    
    //to remove to global util class
    public String formatDate(String dateString){
      try{
        if(String.isBlank(dateString)) return null;
        
        List<String> dateParts = dateString.split('-');
        if(dateParts.size() == 3){
            String mm = dateParts[1];
            String dd = dateParts[2];
            String yyyy = dateParts[0];
            
            mm = mm.contains('0') && mm.indexOf('0') == 0 ? mm.replace('0','') : mm ; 
            dd = dd.contains('0') && dd.indexOf('0') == 0 ? dd.replace('0','') : dd; 
                                   
            return mm  + '/' + dd + '/' + yyyy;
        }else{
            return dateString;
        }
       }catch(Exception e){
          System.debug('Exception Happened='+e); 
          return null;
      }
    }
        
    public String getAgeFromBirthday(String birthDate){
      String memAge = '';
      if(birthDate != ''){
         Integer birthdateYear = Integer.valueof(birthDate.split('-')[0]);
         Integer birthdateMonth = Integer.valueof(birthDate.split('-')[1]);
         Integer birthdateDay = Integer.valueof(birthDate.split('-')[2]);
         Integer currentYear = Date.Today().year();
         Integer currentMonth = Date.Today().month();
         Integer currentDay = Date.Today().day();
         if(currentMonth < birthdateMonth){
             memAge = String.valueOf(currentYear - birthdateYear - 1);
         } else if(currentMonth > birthdateMonth){
             memAge = String.valueOf(currentYear - birthdateYear);
         } else if(currentMonth == birthdateMonth){
             if(currentDay < birthdateDay){
                 memAge = String.valueOf(currentYear - birthdateYear - 1);
             } else if(currentDay >= birthdateDay){
                 memAge = String.valueOf(currentYear - birthdateYear);
             }
         }
     }
     return memAge;
    }
    
    public String getMaskedSSN(String ssn){
        if(String.isEmpty(ssn) || ssn.length() < 4) return '';
        
        return 'xxx-xx-' + ssn.substring(ssn.length() - 4);
    } 
    
    public String getSSNHyphen(String ssn){
        if(String.isEmpty(ssn) || ssn.length() < 9) return '';
               
        return ssn.substring(0,3) + '-' + ssn.substring(3,5) + '-' + ssn.substring(5,9);
    }
    public Continuation StartRequest(String memberId, ACETMemberDetail MemberDetail, String CallbackMethodName, Continuation oContinuation)
    {   
        if(MemberDetail == null){
            MemberDetail = new ACETMemberDetail();
        }
        getEndpoint(); 
        getRequestBody(memberId);
        oContinuation = AddHttpRequest(OAuthConfig, CallbackMethodName, oContinuation);
        return oContinuation;         
    }
     public ACETWSCalloutResult ProcessResponse(String HttpRequestLabel, ACETMemberDetail memberDetail){
        if(memberDetail == null){
            memberDetail = new ACETMemberDetail();
        }

         ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();
       
       
        try {
            HttpResponse response = GetHttpResponse(HttpRequestLabel);
            //response.setStatusCode(500);
           if(response!=null){
            calloutResult.statusCode=response.getStatusCode();
            if(response.getStatusCode() == 200){
                if(response.getBody() != null){
                    //Hardcoded just to check the flow of code
                        String responseBody = response.getBody().contains('\"date\":')?response.getBody().replace('\"date\":', '\"date2\":'):response.getBody();
                        responseBody = response.getBody().contains('\"desc\":')?responseBody.replace('\"desc\":', '\"desc2\":'):response.getBody();
                        system.debug('responseBody >>> '+response);
                        ACETGetIndividualJSON2APexADP jSON2Apex = (ACETGetIndividualJSON2APexADP)JSON.deserialize(responseBody, ACETGetIndividualJSON2APexADP.class);
                        system.debug('JSON2Apex : ' + jSON2Apex);
                        
                        //ACETGetIndividualJSON2APexADP.cls_individual individual = json2Apex.getIndividualResponse.individual;                       
                        ACETGetIndividualJSON2APexADP.cls_individual individual = null;
                        if(json2Apex != null && json2Apex.getIndividualResponse != null && json2Apex.getIndividualResponse.individual != null)
                            individual = json2Apex.getIndividualResponse.individual;
                       memberDetail.EID = individual.individualIdentifier;
                    
                    if(individual!=null){
                       if(individual.identifiers!=null){
                           for(ACETGetIndividualJSON2APexADP.cls_identifiers indv : individual.identifiers){
                               system.debug('------indv------->'+indv);
                               if(indv.type == 'MCH'){
                                   //memberDetail.MemberId = indv.id;
                               }
                               if(indv.type == 'CPTIN'){
                                   memberDetail.CPTIN = indv.id;  
                                   memberDetail.CPTIN =memberDetail.CPTIN!=null?memberDetail.CPTIN.trim():'';
                               }
    
                           }
                        }
                       
                    if(individual.name!=null){
                       memberDetail.FirstName = String.isNotBlank(individual.name.firstName)?individual.name.firstName:'';
                       memberDetail.LastName = String.isNotBlank(individual.name.lastName)?individual.name.lastName:'';
                       memberDetail.MiddleName = String.isNotBlank(individual.name.middleName)?individual.name.middleName:'';
                       memberDetail.Suffix = String.isNotBlank(individual.name.nameSuffix)?individual.name.nameSuffix:'';
                       memberDetail.MiddleInitial = String.isNotBlank(individual.name.middleName)?individual.name.middleName:'';
                        }

                       memberDetail.DOB = String.isNotBlank(individual.birthDate)?formatDate(individual.birthDate):'';
                       memberDetail.Gender = String.isNotBlank(individual.genderCode)?individual.genderCode:'';
                       memberDetail.Age = String.isNotBlank(individual.birthDate)?getAgeFromBirthday(individual.birthDate):'';  

                       memberDetail.SSN = String.isNotBlank(individual.socialSecurityNumber)?individual.socialSecurityNumber:'';
                       memberDetail.FullSSN = String.isNotBlank(individual.socialSecurityNumber)?getSSNHyphen(individual.socialSecurityNumber):'';
                       for(EligibilityEmploymentStatusList__mdt empCode:[select EmploymentStatus__c, EmploymentStatusCode__c from EligibilityEmploymentStatusList__mdt order by EmploymentStatusCode__c asc]) {
                                      if(individual.employment.size()>0 && individual.employment[0].employmentStatus == empCode.EmploymentStatusCode__c){
                                        memberDetail.EmploymentStatus = String.isNotBlank(empCode.EmploymentStatus__c)?empCode.EmploymentStatus__c:'';
                                      }
                            }
                       //memberDetail.EmploymentStatus = individual.employment[0].employmentStatus;
                       if(individual.employment.size()>0 && individual.employment[0].employmentStartDate!=null)
                           memberDetail.EmploymentStartDate = formatDate(individual.employment[0].employmentStartDate);
                           
                        if(individual.language!=null){
                          for(ACETGetIndividualJSON2APexADP.cls_Language lan : individual.language){
                                if(lan !=null && !String.isEmpty(lan.languageCode)){
                                    if(lan.languageUsedTypeCode == '7'){
                                        memberDetail.SpokenLanguage = ACETLanguage__c.getValues(lan.languageCode).Description__c;   
                                    }
                                    if(lan.languageUsedTypeCode == '5' && memberDetail.SpokenLanguage =='' || memberDetail.SpokenLanguage == null){
                                        memberDetail.SpokenLanguage = ACETLanguage__c.getValues(lan.languageCode).Description__c;   
                                    }
                                    if(lan.languageUsedTypeCode == '6' && (memberDetail.SpokenLanguage =='' || memberDetail.SpokenLanguage == null)){
                                        memberDetail.SpokenLanguage = ACETLanguage__c.getValues(lan.languageCode).Description__c;   
                                    } 
                                    if(lan.languageUsedTypeCode == '5' && memberDetail.WrittenLanguage =='' || memberDetail.WrittenLanguage == null){
                                        memberDetail.WrittenLanguage = ACETLanguage__c.getValues(lan.languageCode).Description__c;   
                                    }                              
                                    
                                }   
                             }
                          }
                      

                            if(individual.email!=null){
                                for(ACETGetIndividualJSON2APexADP.cls_email emailObj : individual.email){
                                    if(emailObj.primaryIndicator == 'Y'){
                                        memberDetail.email = String.isNotBlank(emailObj.electronicAddress)?emailObj.electronicAddress:'';
                                    }
                                }
                             }
                             
                             if(individual.deceasedDate!=null)
                               memberDetail.DeceasedDate = formatDate(individual.deceasedDate);
                        
                            MemberDetail.disabilityInfo = new List<ACETMemberDetail.DependentDisability>();
                            if(individual.dependentDisabilityList!=null && !individual.dependentDisabilityList.isEmpty()){
                                for(ACETGetIndividualJSON2APexADP.DisabilityList dis : individual.dependentDisabilityList){
                                    ACETMemberDetail.DependentDisability disItem = new ACETMemberDetail.DependentDisability();
                                    disItem.disabilityType = (dis.disabilityType!= null)?dis.disabilityType:'';
                                    for(Disability_Information__mdt disCode:[select Disability_Type__c, Disability_Type_Description__c from Disability_Information__mdt ]) {
                                      if(disItem.disabilityType == disCode.Disability_Type__c){
                                        disItem.disabilityType = disCode.Disability_Type_Description__c;
                                      }
                                    }
                                    disItem.diagnosisCode = (dis.diagnosisCode!= null)?dis.diagnosisCode:'';
                                    disItem.diagnosisCodeType = (dis.diagCodeType!= null)?(dis.diagCodeType == '9'?'ICD-9':(dis.diagCodeType == '0'?'ICD-10':'')):'';
                                    disItem.effectiveDate = (dis.effectiveDate!= null)?string.valueOf(ACETUtility.format(Date.valueOf(dis.effectiveDate))):'';
                                    disItem.endDate = (dis.expirationDate!= null)?string.valueOf(ACETUtility.format(Date.valueOf(dis.expirationDate))):'';
                                    if(disItem.disabilityType != '')
                                        MemberDetail.disabilityInfo.add(disItem);
                                }
                                
                                MemberDetail.disability = (MemberDetail.disabilityInfo != null && MemberDetail.disabilityInfo.size() > 0?'Y':'N');
                            }
                            else
                                MemberDetail.disability ='N';
                            
                           MemberDetail.Addresses = new List<ACETMemberDetail.Address>();
                           if(individual.address!=null){
                            for(ACETGetIndividualJSON2APexADP.cls_address addr : individual.address){
                                ACETMemberDetail.Address address = new ACETMemberDetail.Address();
                                address.AddressLine1 = (addr.AddressLine1 != null) ? addr.AddressLine1:'';    
                                address.AddressLine2 = (addr.AddressLine2 != null) ? addr.AddressLine2 : '';
                                address.City = (addr.City != null) ? addr.City:'';
                                address.State = (addr.stateCode != null) ? addr.stateCode : '';
                                address.Zip = (addr.postalCode != null) ? addr.postalCode : '';   
                                if (addr.typeCode == 'HOM')
                                    address.AddressType = 'Home'; 
                                else if (addr.typeCode == 'WRK')
                                    address.AddressType = 'Work'; 
                                else if (addr.typeCode == 'BILL')
                                    address.AddressType = 'Billing';
                                else if (addr.typeCode == 'MAIL')
                                    address.AddressType = 'Mailing';
                                else if (addr.typeCode == 'PRAC')
                                    address.AddressType = 'Practice'; 
                                    
                                MemberDetail.Addresses.add(address);
                            }
                          }
                            
                        MemberDetail.Phones = new List<ACETMemberDetail.Phone>();
                      if(individual.phone!=null){
                        for(ACETGetIndividualJSON2APexADP.cls_phone telephone : individual.phone){
                            ACETMemberDetail.Phone phone = new ACETMemberDetail.Phone();
                            phone.PhoneNumber = String.isNotBlank(telephone.phoneNumber)?telephone.phoneNumber:'';
                            if(telephone.phoneType == 'H'){
                                phone.PhoneNumberType = 'Home';
                                 phone.WorkExt = String.isNotBlank(telephone.phoneExt)?telephone.phoneExt:''; //Code Added By Chandan -US1206900
                                 }
                            if(telephone.phoneType == 'F'){
                                phone.PhoneNumberType = 'Fax';
                                 phone.WorkExt = String.isNotBlank(telephone.phoneExt)?telephone.phoneExt:''; //Code Added By Chandan -US1206900
                                 }
                            if(telephone.phoneType == 'W'){
                                phone.PhoneNumberType = 'Work';
                                phone.WorkExt = String.isNotBlank(telephone.phoneExt)?telephone.phoneExt:'';
                            }
                            if(telephone.phoneType == 'M')
                                phone.PhoneNumberType = 'Mobile';
                            if(telephone.primaryIndicator == 'Y')
                                phone.primaryIndicator = 'Primary';
                            else
                                phone.primaryIndicator = '';
                            MemberDetail.Phones.add(phone);
                          }
                        }
                        MemberDetail.ROIcontacts = new List<ACETMemberDetail.otherContact>();
                        system.debug('MemberDetail.ROIcontacts----1--->'+ MemberDetail.ROIcontacts + '---->'+individual.otherContact);
                       if(individual.otherContact!=null){
                        for(ACETGetIndividualJSON2APexADP.cls_otherContact otherCon : individual.otherContact){
                            ACETMemberDetail.otherContact ROIrec = new ACETMemberDetail.otherContact();
                            if(otherCon.name != null){
                                ROIrec.firstName = String.isNotBlank(otherCon.name.firstName)?otherCon.name.firstName:'';
                                ROIrec.middleName = String.isNotBlank(otherCon.name.MiddleName)?otherCon.name.MiddleName:'';
                                ROIrec.lastName = String.isNotBlank(otherCon.name.Lastname)?otherCon.name.Lastname:''; 
                                ROIrec.effectiveDate = String.isNotBlank(otherCon.effectiveDate)?formatDate(otherCon.effectiveDate):'';
                                ROIrec.terminationDate = String.isNotBlank(otherCon.expirationDate)?formatDate(otherCon.expirationDate):''; 
                                 ROIrec.docLink = '';
                            MemberDetail.ROIcontacts.add(ROIrec);
                            }
                         }
                            
                        }
                        system.debug('MemberDetail.ROIcontacts----2--->'+ MemberDetail.ROIcontacts);

                          system.debug('2323checking SRK list getindividual' + memberDetail.SurrogateKeys);        
                        calloutResult.Success = true;
                        calloutResult.Message = '';
                        System.debug('!!!!!!!!!!!!!!!!!!!!'+memberDetail );
                        calloutResult.Response = memberDetail;                                                
                    
                }
                system.debug('memberDetail.SurrogateKeys ::' + memberDetail.SurrogateKeys);
              }
            }
            //commented by khoushik 6-7-2017 
            else {
                calloutResult.MessageSeverity = ApexPages.Severity.ERROR;
                calloutResult.Success = false;                
                calloutResult.Response = memberDetail;
                calloutResult.Message = ACETWebserviceHelper.getErrorMessageFromCode(response.getStatusCode());
              }
           }else{
               calloutResult.MessageSeverity = ApexPages.Severity.ERROR;
               calloutResult.Success = false;
               calloutResult.Message = 'Web Service or External System is temporarily unavailable.';
               calloutResult.statusCode=999;
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