public class ACETLGT_GetIndividualWebService extends ACETWebService{
    public String dateconst = '\"date\":';
    public String desconst = '\"desc\":';
    public override void getEndpoint(){
        GetEndpointDetail('GetIndividualEndpoint'); 
    }
    public ACETLGT_GetIndividualWebService() {
        super('Stargate');
    }
    public void getRequestBody(String identifier){
        RequestBody = '{"getIndividualRequest" : {"identifier": "'+identifier+'","identifierType": "SRK"}}';               
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
      try{
        if(String.isBlank(birthDate)) return null;
        system.debug('birthdate >>> '+birthdate);
        Date d = Date.valueOf(birthDate);
        return String.valueOf(d.daysBetween(Date.today())/365);
      }catch(Exception e){
          System.debug('Exception Happened='+e); 
          return null;
      }
    }
    
    public String getMaskedSSN(String ssn){
        if(String.isEmpty(ssn) || ssn.length() < 4) return '';
        
        return 'XXX-XX-' + ssn.substring(ssn.length() - 4);
    } 
    
    public String getSSNHyphen(String ssn){
        if(String.isEmpty(ssn) || ssn.length() < 9) return '';
               
        return ssn.substring(0,3) + '-' + ssn.substring(3,5) + '-' + ssn.substring(5,9);
    }
    
    public ACETWSCalloutResult getMemberWS(string srk){
		Map<string,string> otherContactMap = new Map<string,string>();
        otherContactMap.put('6Y', 'Case Manager');
        otherContactMap.put('9K', 'Key Person');
        otherContactMap.put('E1', 'Authorized Rep');
        otherContactMap.put('EI', 'Executor of Estate');
        otherContactMap.put('EXS', 'Ex-Spouse');
        otherContactMap.put('GB', 'Other Insured');
        otherContactMap.put('GD', 'Guardian');
        otherContactMap.put('J6', 'Power of Attorney');
        otherContactMap.put('LR', 'Legal Rep');
        otherContactMap.put('QD', 'Responsible Party');
        otherContactMap.put('S1','Parent');
        otherContactMap.put('S3','Custodial Parent');
        otherContactMap.put('TZ','Significant Other');
        otherContactMap.put('X4','Spouse');

        ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();
        ACETLGT_MemberSearchCoveragesResult memberdetail = new ACETLGT_MemberSearchCoveragesResult();
        //try {
            ServiceName = 'getIndividual';
            getEndpoint();
            getRequestBody(srk);                          
                         
            HttpResponse response = new HttpResponse();  
            response = Send(OAuthConfig);
            //response.setStatusCode(500);
            	
            if(response!=null){
            calloutResult.statusCode=response.getStatusCode();

            if(response.getStatusCode() == 200){
                if(response.getBody() != null){
                    String responseBody = response.getBody().contains(dateconst)?response.getBody().replace(dateconst, '\"date2\":'):response.getBody();
                      responseBody = response.getBody().contains(desconst)?responseBody.replace(desconst, '\"desc2\":'):response.getBody();
                    
                    system.debug('responseBody >>> '+response);
                        ACETLGT_GetIndividualJSON2APexADP jSON2Apex = (ACETLGT_GetIndividualJSON2APexADP)JSON.deserialize(responseBody, ACETLGT_GetIndividualJSON2APexADP.class);
                        
                    system.debug('JSON2Apex : ' + jSON2Apex);
                        
                        //ACETLGT_GetIndividualJSON2APexADP.cls_individual individual = json2Apex.getIndividualResponse.individual;                       
                        ACETLGT_GetIndividualJSON2APexADP.cls_individual individual = null;
                        if(json2Apex != null && json2Apex.getIndividualResponse != null && json2Apex.getIndividualResponse.individual != null)
                            individual = json2Apex.getIndividualResponse.individual;
                       
                       system.debug('------individual.identifiers------->'+individual.identifiers);
                    if(individual!=null){
                       if(individual.identifiers!=null){
                           for(ACETLGT_GetIndividualJSON2APexADP.cls_identifiers indv : individual.identifiers){
                               system.debug('------indv------->'+indv);
                               if(indv.type == 'MCH'){
                                   //memberDetail.MemberId = indv.id;
                               }
                               if(indv.type == 'CPTIN'){
                                   memberDetail.CPTIN = (indv.id != null)?getMaskedSSN(indv.id):'';  
                                   memberDetail.CPTIN =memberDetail.CPTIN!=null?memberDetail.CPTIN.trim():'';
                                   memberDetail.fullCPTIN = (String.isNotBlank(indv.id))?indv.id:'';
                               }
    
                           }
                        }
                       
                    if(individual.name!=null){
                       memberDetail.FirstName = String.isNotBlank(individual.name.firstName)?individual.name.firstName:'';
                       memberDetail.LastName = String.isNotBlank(individual.name.lastName)?individual.name.lastName:'';
                       memberDetail.MiddleName = String.isNotBlank(individual.name.middleName)?individual.name.middleName:'';
                       memberDetail.Suffix = String.isNotBlank(individual.name.nameSuffix)?individual.name.nameSuffix:'';
                       memberDetail.MiddleInitial = String.isNotBlank(individual.name.middleName)?individual.name.middleName:'';
                       memberDetail.fullName = (memberDetail.MiddleInitial != '')?(memberDetail.FirstName+' '+memberDetail.MiddleInitial+' '+memberDetail.LastName+' '+memberDetail.Suffix):(memberDetail.FirstName+' '+memberDetail.LastName+' '+memberDetail.Suffix);
                        }

                       memberDetail.DOB = String.isNotBlank(individual.birthDate)?formatDate(individual.birthDate):'';
                       memberDetail.Gender = String.isNotBlank(individual.genderCode)?individual.genderCode:'';
                       memberDetail.Age = String.isNotBlank(individual.birthDate)?getAgeFromBirthday(individual.birthDate):'';  
					   system.debug('---------SSN---->'+individual.socialSecurityNumber);
                       memberDetail.SSN = String.isNotBlank(individual.socialSecurityNumber)?getMaskedSSN(individual.socialSecurityNumber):'';                       
                       system.debug('---------SSN---->'+memberDetail.SSN);
                       //memberDetail.FullSSN = String.isNotBlank(individual.socialSecurityNumber)?getSSNHyphen(individual.socialSecurityNumber):'';
                       memberDetail.FullSSN = String.isNotBlank(individual.socialSecurityNumber)?individual.socialSecurityNumber:'';
                       for(EligibilityEmploymentStatusList__mdt empCode:[select EmploymentStatus__c, EmploymentStatusCode__c from EligibilityEmploymentStatusList__mdt order by EmploymentStatusCode__c asc]) {
                                      if(individual.employment.size()>0 && individual.employment[0].employmentStatus == empCode.EmploymentStatusCode__c){
                                        memberDetail.EmploymentStatus = String.isNotBlank(empCode.EmploymentStatus__c)?empCode.EmploymentStatus__c:'';
                                      }
                            }
                       //memberDetail.EmploymentStatus = individual.employment[0].employmentStatus;
                       if(individual.employment.size()>0 && individual.employment[0].employmentStartDate!=null)
                           memberDetail.EmploymentStartDate = formatDate(individual.employment[0].employmentStartDate);
                           
                        if(individual.language!=null){
                          memberDetail.languageMap = new Map<string, List<string>>();
                          List<String> spokenlangList = new List<String>();
                          List<String> writtenlangList = new List<String>();
                          for(ACETLGT_GetIndividualJSON2APexADP.cls_Language lan : individual.language){
                                if(lan !=null && !String.isEmpty(lan.languageCode)){
                                    
                                    if( lan.languageUsedTypeCode == '7'){
                                        memberDetail.SpokenLanguage = ACETLanguage__c.getValues(lan.languageCode).Description__c;
                                        //spokenlangList.add(memberDetail.SpokenLanguage);
                                    }
                                    if(lan.languageUsedTypeCode == '7' && (memberDetail.SpokenLanguage !='' && memberDetail.SpokenLanguage != null) && memberDetail.SpokenLanguage != ACETLanguage__c.getValues(lan.languageCode).Description__c){
                                        memberDetail.SpokenLanguage = memberDetail.SpokenLanguage + ', '+ACETLanguage__c.getValues(lan.languageCode).Description__c;   
                                        //spokenlangList.add(memberDetail.SpokenLanguage);
                                    }
                                    
                                    if(lan.languageUsedTypeCode == '6' && (memberDetail.WrittenLanguage =='' || memberDetail.WrittenLanguage == null)){
                                        memberDetail.WrittenLanguage = ACETLanguage__c.getValues(lan.languageCode).Description__c; 
                                        //writtenlangList.add(memberDetail.WrittenLanguage );
                                    } 
                                    if(lan.languageUsedTypeCode == '6' && memberDetail.WrittenLanguage !='' && memberDetail.WrittenLanguage != null && memberDetail.WrittenLanguage != ACETLanguage__c.getValues(lan.languageCode).Description__c){
                                        memberDetail.WrittenLanguage = memberDetail.WrittenLanguage +', '+ACETLanguage__c.getValues(lan.languageCode).Description__c; 
                                        //writtenlangList.add(memberDetail.WrittenLanguage );
                                    }
                                    system.debug('-------memberDetail.WrittenLanguage---->>'+memberDetail.WrittenLanguage);
                                    system.debug('-------memberDetail.SpokenLanguage---->>'+memberDetail.SpokenLanguage);
                                    /**boolean nonMatchinglangs = false;
                                    for(string rec:spokenlangList){
                                        if(writtenlangList.size() == spokenlangList.size() && !writtenlangList.contains(rec)){
                                            nonMatchinglangs = true;
                                        }
                                        
                                    }
                                    if(!nonMatchinglangs){
                                        if(memberDetail.SpokenLanguage != null && memberDetail.SpokenLanguage != '')
                                        	memberDetail.WrittenLanguage = '';
                                        
                                            
                                    }**/
                                    //memberDetail.languageMap.put('Spoken', spokenlangList );
                                    //memberDetail.languageMap.put('Written', writtenlangList );
                                    
                                }   
                             }
                          }
                      	/* ************************************** NOTES *********************************** 
                        Language - Writing/Speaking (Use only 6 and 7 usedType Codes)
                        Ex: Response has 3 records (Eng - spoken and written and spanish - spoken)
                        
                        Map<Language, list<usedTypeCode>>
                        
                        Map:
                        Eng , Written and Spoken
                        Spa , Spoken
                        
                        Display Text:
                        English
                        Spanish - Spoken
                      	 * */
							
                            if(individual.email!=null){
                                
                                for(ACETLGT_GetIndividualJSON2APexADP.cls_email emailObj : individual.email){
                                    
                                    if(emailObj.primaryIndicator == 'Y'){
                                        memberDetail.Email = String.isNotBlank(emailObj.electronicAddress)?emailObj.electronicAddress:'';
                                        
                                    }
                                }
                             }
                             if(individual.deceasedDate!=null)
                               memberDetail.DeceasedDate = formatDate(individual.deceasedDate);
                            
                            MemberDetail.disabilityInfo = new List< ACETLGT_MemberSearchCoveragesResult.DependentDisability>();
                            if(individual.dependentDisabilityList!=null && !individual.dependentDisabilityList.isEmpty()){
                                for(ACETLGT_GetIndividualJSON2APexADP.DisabilityList dis : individual.dependentDisabilityList){
                                    ACETLGT_MemberSearchCoveragesResult.DependentDisability disItem = new ACETLGT_MemberSearchCoveragesResult.DependentDisability();
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
                            
                           MemberDetail.Addresses = new List<ACETLGT_MemberSearchCoveragesResult.Address>();
                           if(individual.address!=null){
                            for(ACETLGT_GetIndividualJSON2APexADP.cls_address addr : individual.address){
                                ACETLGT_MemberSearchCoveragesResult.Address address = new ACETLGT_MemberSearchCoveragesResult.Address();
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
                            
                        MemberDetail.Phones = new List<ACETLGT_MemberSearchCoveragesResult.Phone>();
                      if(individual.phone!=null){
                        for(ACETLGT_GetIndividualJSON2APexADP.cls_phone telephone : individual.phone){
                            ACETLGT_MemberSearchCoveragesResult.Phone phone = new ACETLGT_MemberSearchCoveragesResult.Phone();
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
                        // Other contact list 
                        MemberDetail.ROIcontacts = new List<ACETLGT_MemberSearchCoveragesResult.otherContact>();
                        system.debug('MemberDetail.ROIcontacts----1--->'+ MemberDetail.ROIcontacts + '---->'+individual.otherContact);
                       if(individual.otherContact!=null){
                        for(ACETLGT_GetIndividualJSON2APexADP.cls_otherContact otherCon : individual.otherContact){
                            ACETLGT_MemberSearchCoveragesResult.otherContact ROIrec = new ACETLGT_MemberSearchCoveragesResult.otherContact();
                            if(otherCon.name != null){
                                ROIrec.firstName = String.isNotBlank(otherCon.name.firstName)?otherCon.name.firstName:'';
                                ROIrec.middleName = String.isNotBlank(otherCon.name.MiddleName)?otherCon.name.MiddleName:'';
                                ROIrec.lastName = String.isNotBlank(otherCon.name.Lastname)?otherCon.name.Lastname:''; 
                                ROIrec.effectiveDate = String.isNotBlank(otherCon.effectiveDate)?formatDate(otherCon.effectiveDate):'';
                                ROIrec.terminationDate = String.isNotBlank(otherCon.expirationDate)?formatDate(otherCon.expirationDate):'';
                                ROIrec.Type = String.isNotBlank(otherCon.relationshipType)?otherContactMap.get(otherCon.relationshipType):'';
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
                        System.debug('memberDetail:::::SSN:::'+memberDetail.SSN );
                        calloutResult.Response = memberDetail;                                                
                    
                }
                system.debug('memberDetail.SurrogateKeys ::' + memberDetail.SurrogateKeys);
              }
                }else {
                //calloutResult.MessageSeverity = ApexPages.Severity.ERROR;
                calloutResult.Success = false;                
                calloutResult.Response = memberDetail;
                    calloutResult.Message = ACETWebserviceHelper.getErrorMessageFromCode(response.getStatusCode());
              }
           }else{
               //calloutResult.MessageSeverity = ApexPages.Severity.ERROR;
               calloutResult.Success = false;
               calloutResult.Message = 'Web Service or External System is temporarily unavailable.';
               calloutResult.statusCode=999;
             }
            
        /*}catch(Exception e){
                    system.debug(e.getStackTraceString());
                    //calloutResult.MessageSeverity = ApexPages.Severity.ERROR;
                    calloutResult.Success = false;
                    calloutResult.Message = 'Web Service or External System is temporarily unavailable.';
                    calloutResult.statusCode=999;
           }*/
        
        return calloutResult;    
    }      
    
    public ACETWSCalloutResult getMemberNewFramework(string srk){
		Map<string,string> otherContactMap = new Map<string,string>();
        otherContactMap.put('6Y', 'Case Manager');
        otherContactMap.put('9K', 'Key Person');
        otherContactMap.put('E1', 'Authorized Rep');
        otherContactMap.put('EI', 'Executor of Estate');
        otherContactMap.put('EXS', 'Ex-Spouse');
        otherContactMap.put('GB', 'Other Insured');
        otherContactMap.put('GD', 'Guardian');
        otherContactMap.put('J6', 'Power of Attorney');
        otherContactMap.put('LR', 'Legal Rep');
        otherContactMap.put('QD', 'Responsible Party');
        otherContactMap.put('S1','Parent');
        otherContactMap.put('S3','Custodial Parent');
        otherContactMap.put('TZ','Significant Other');
        otherContactMap.put('X4','Spouse');
        
        ACETLGT_MemberSearchCoveragesResult memberDetail = new ACETLGT_MemberSearchCoveragesResult();
		String requestBody = '{"getIndividualRequest" : {"identifier": "'+srk+'","identifierType": "SRK"}}';
        
        ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();
        
        ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework('getIndividualMembershipService',requestBody,null);
        HttpResponse response = wsCallOutFW.getResponse();
                    	
        if(response!=null){
            Integer statusCode = response.getStatusCode();
            calloutResult.statusCode=statusCode;

            if(statusCode == 200 && response.getBody() != null){
                calloutResult = processResponse(memberDetail,response.getBody(),calloutResult);
            }else {
                calloutResult.Success = false;                
                calloutResult.Response = memberDetail;
                calloutResult.Message = ACETWebserviceHelper.getErrorMessageFromCode(response.getStatusCode());
            }
        }
        else{
            calloutResult.Success = false;
            calloutResult.Message = 'Web Service or External System is temporarily unavailable.';
            calloutResult.statusCode=999;
        }
            
        return calloutResult;    
    }

    public ACETWSCalloutResult processResponse(ACETLGT_MemberSearchCoveragesResult memberDetail, String responseBody, ACETWSCalloutResult calloutResult){
        responseBody = responseBody.contains(dateconst)?responseBody.replace(dateconst, '\"date2\":'):responseBody;
        responseBody = responseBody.contains(desconst)?responseBody.replace(desconst, '\"desc2\":'):responseBody;
        ACETLGT_GetIndividualJSON2APexADP jSON2Apex = (ACETLGT_GetIndividualJSON2APexADP)JSON.deserialize(responseBody, ACETLGT_GetIndividualJSON2APexADP.class);
        
        ACETLGT_GetIndividualJSON2APexADP.cls_individual individual = (json2Apex != null && json2Apex.getIndividualResponse != null && json2Apex.getIndividualResponse.individual != null)?json2Apex.getIndividualResponse.individual:null;
        
        system.debug('------individual.identifiers------->'+individual.identifiers);
        if(individual!=null){
            if(individual.identifiers!=null){
                memberDetail = processIdentifiers(memberDetail, individual);
            }
            memberDetail = processName(memberDetail, individual);
            memberDetail = processDemographics(memberDetail, individual);
            if(individual.address!=null){
                memberDetail = processAddress(memberDetail, individual);
            }
		    memberDetail = processLanguage(memberDetail, individual);
            calloutResult.Success = true;
            calloutResult.Message = '';
            calloutResult.Response = memberDetail;                                                
        }
        return calloutResult;
    }

    public ACETLGT_MemberSearchCoveragesResult processIdentifiers(ACETLGT_MemberSearchCoveragesResult memberDetail, ACETLGT_GetIndividualJSON2APexADP.cls_individual individual){
        
        for(ACETLGT_GetIndividualJSON2APexADP.cls_identifiers indv : individual.identifiers){
            if(indv.type == 'CPTIN'){
                memberDetail.CPTIN = (indv.id != null)?getMaskedSSN(indv.id):'';  
                memberDetail.CPTIN =memberDetail.CPTIN!=null?memberDetail.CPTIN.trim():'';
                memberDetail.fullCPTIN = (String.isNotBlank(indv.id))?indv.id:'';
            }
        }
        return memberDetail;
    }

    public ACETLGT_MemberSearchCoveragesResult processName(ACETLGT_MemberSearchCoveragesResult memberDetail, ACETLGT_GetIndividualJSON2APexADP.cls_individual individual){
        if(individual.name!=null){
            memberDetail.FirstName = String.isNotBlank(individual.name.firstName)?individual.name.firstName:'';
            memberDetail.LastName = String.isNotBlank(individual.name.lastName)?individual.name.lastName:'';
            memberDetail.MiddleName = String.isNotBlank(individual.name.middleName)?individual.name.middleName:'';
            memberDetail.Suffix = String.isNotBlank(individual.name.nameSuffix)?individual.name.nameSuffix:'';
            memberDetail.MiddleInitial = String.isNotBlank(individual.name.middleName)?individual.name.middleName:'';
            memberDetail.fullName = (memberDetail.MiddleInitial != '')?(memberDetail.FirstName+' '+memberDetail.MiddleInitial+' '+memberDetail.LastName+' '+memberDetail.Suffix):(memberDetail.FirstName+' '+memberDetail.LastName+' '+memberDetail.Suffix);
        }
        return memberDetail;
    }

    public ACETLGT_MemberSearchCoveragesResult processDemographics(ACETLGT_MemberSearchCoveragesResult memberDetail, ACETLGT_GetIndividualJSON2APexADP.cls_individual individual){
        memberDetail.DOB = String.isNotBlank(individual.birthDate)?individual.birthDate:'';
        memberDetail.Gender = String.isNotBlank(individual.genderCode)?individual.genderCode:'';
        memberDetail.Age = String.isNotBlank(individual.birthDate)?getAgeFromBirthday(individual.birthDate):'';  
        memberDetail.SSN = String.isNotBlank(individual.socialSecurityNumber)?getMaskedSSN(individual.socialSecurityNumber):'';                       
        memberDetail.FullSSN = String.isNotBlank(individual.socialSecurityNumber)?individual.socialSecurityNumber:'';
        return memberDetail;
    }

    public ACETLGT_MemberSearchCoveragesResult processAddress(ACETLGT_MemberSearchCoveragesResult memberDetail, ACETLGT_GetIndividualJSON2APexADP.cls_individual individual){
        MemberDetail.Addresses = new List<ACETLGT_MemberSearchCoveragesResult.Address>();
        
        for(ACETLGT_GetIndividualJSON2APexADP.cls_address addr : individual.address){
            ACETLGT_MemberSearchCoveragesResult.Address address = new ACETLGT_MemberSearchCoveragesResult.Address();
            address.AddressLine1 = (addr.AddressLine1 != null) ? addr.AddressLine1:'';    
            address.AddressLine2 = (addr.AddressLine2 != null) ? addr.AddressLine2 : '';
            address.City = (addr.City != null) ? addr.City:'';
            address.State = (addr.stateCode != null) ? addr.stateCode : '';
            address.Zip = (addr.postalCode != null) ? addr.postalCode : '';   
            address.AddressType = getAddressType(addr.typeCode);
            MemberDetail.Addresses.add(address);
        }
        return memberDetail;
    }

    public String getAddressType(String addCode){
        String addressType;
        switch on addCode{
            when 'HOM'{
                addressType = 'Home'; 
            }
            when 'WRK'{
                addressType = 'Work'; 
            }
            when 'BILL'{
                addressType = 'Billing';
            }
            when 'MAIL'{
                addressType = 'Mail';
            }
            when 'PRAC'{
                addressType = 'Practice'; 
            }
            when else{
                addressType = ''; 
            }
        } 
        return addressType;
    }

    public ACETLGT_MemberSearchCoveragesResult processLanguage(ACETLGT_MemberSearchCoveragesResult memberDetail, ACETLGT_GetIndividualJSON2APexADP.cls_individual individual){
        if(individual.language!=null){
            memberDetail.languageMap = new Map<string, List<string>>();
            List<String> spokenlangList = new List<String>();
            List<String> writtenlangList = new List<String>();
            for(ACETLGT_GetIndividualJSON2APexADP.cls_Language lan : individual.language){
                if(lan !=null && String.isNotBlank(lan.languageCode)){
                    memberDetail.SpokenLanguage = getLanguage(lan.languageUsedTypeCode, lan.languageCode,memberDetail.SpokenLanguage);
                    memberDetail.WrittenLanguage = getLanguage(lan.languageUsedTypeCode, lan.languageCode,memberDetail.WrittenLanguage);
                }   
            }
        }
        return memberDetail;
    }

    public String getLanguage(String langusedCode, String langCode, String lang){
        return (langusedCode=='7' && String.isBlank(lang))?ACETLanguage__c.getValues(langCode).Description__c:((langusedCode=='7' && String.isNotBlank(lang) && lang != ACETLanguage__c.getValues(langCode).Description__c)?(lang + ', '+ACETLanguage__c.getValues(langCode).Description__c):'');     
    }
}