public Class ACETReferralWebservice extends ACETWebservice{
    
    public List<String> searchParameters ;
    public override void GetEndpoint(){
        GetEndpointDetail('SearchClinicalReferralsEndpoint');
    }
    public ACETReferralWebservice() {
        super('Stargate');
    }
    private void GetRequestBody(){
        RequestBody = GetRequestBody('FindReferralsRequestMember',SearchParameters);
    }
    
    public String setStringToDateFormat(String OILDate) {
        String FormattedDate = '';
        
        if (String.isNotBlank(OILDate)) {
            List<String> OILDateSplit = OILDate.split('/');
            if(OILDateSplit.size() == 3) {
                integer oilmonth = integer.valueOf(OILDateSplit[0]);
                integer oilday = integer.valueOf(OILDateSplit[1]);
                system.debug('oilday : '+oilday+'oilmonth : '+oilmonth);
                if(oilday <10)
                {
                    OILDateSplit[1] = '0'+OILDateSplit[1];
                }
                if(oilmonth <10)
                {
                    OILDateSplit[0] = '0'+OILDateSplit[0];
                }
                system.debug('OILDateSplit[0] is '+OILDateSplit[0]);
                system.debug('OILDateSplit[1] is '+OILDateSplit[1]);
                FormattedDate = OILDateSplit[2] + '-' + OILDateSplit[0] + '-' + OILDateSplit[1];
            }
        }
        
        return FormattedDate;
    }
    
    public String formattedDate(String exisDate){
        String FormattedDate = '';
        List<String> exisDateList = exisDate.split('/');
        if(exisDateList[0].indexof('0') == 0){
            exisDateList[0] = exisDateList[0].remove('0') ;
        }
        if(exisDateList[1].indexof('0') == 0){
            exisDateList[1] = exisDateList[0].remove('0');  
        }
        FormattedDate = exisDateList[0] + '/' + exisDateList[1] + '/' + exisDateList[2];
        
        return FormattedDate;
    }
    
    public String formatDateWithZeros(String exisDate){
        String dateWithZeros = '';
        List<String> exisDateList = exisDate.split('/');
        if(exisDateList[0].indexof('0') == -1 && exisDateList[0].length()==1){
            exisDateList[0] = '0' + exisDateList[0];
        }
        if(exisDateList[1].indexof('0') == -1 && exisDateList[1].length()==1){
            exisDateList[1] = '0' + exisDateList[1];  
        }
        dateWithZeros = exisDateList[0] + '/' + exisDateList[1] + '/' + exisDateList[2];
        
        return dateWithZeros;
    }
    
    public ACETWSCalloutResult findReferrals(String firstName , String lastName, String birthDate, String SRKNumber){
        //Date dob = setStringToDateFormat(birthDate);
        system.debug('birthDate is '+birthDate);
        //searchParameters = new String[] {firstName, lastName,String.valueof(birthDate), SRKNumber, String.valueof(birthDate)};
        searchParameters = new String[] {firstName, lastName,setStringToDateFormat(birthDate), SRKNumber, setStringToDateFormat(birthDate)};    
            ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult();
        List<ACETReferralSearchResult> lstReferrals = new List<ACETReferralSearchResult>();
        ACETReferralSearchResult referral;
        List<ACETReferralJSON2Apex.referrals> SRReferrals;
         map<String,String> errorMap=new map<String,String>();
        List<AcetErrorMessage__mdt> ErrorMessages =[SELECT  masterlabel,Error_Message__c,Message_Type__c,ServiceError__c,TopPriority__c,
                                                    Error_log_enabled__c FROM AcetErrorMessage__mdt ];//where masterlabel=:errorCode
        for(AcetErrorMessage__mdt em:ErrorMessages){
            errorMap.put(em.masterlabel, em.Error_Message__c);
        }
        
        try{
            GetEndpoint();
            GetRequestBody();
            
            HttpResponse Response = Send(OAuthConfig);
            system.debug('Respone--->'+Response.getBody());
            String ResponseBody = Response.getBody().replace('desc','desc_z').replace('pcp-referrals-response','referralDetailsResponse');
            system.debug('ResponseBody: ' + ResponseBody);
            if (Response.getStatusCode() == 200){
                
                ACETReferralJSON2Apex ACTRefJSON2Apex = (ACETReferralJSON2Apex)JSON.deserialize(ResponseBody, ACETReferralJSON2Apex.class);
                system.debug('ACTRefJSON2Apex****'+ ACTRefJSON2Apex);
                
                SRReferrals = ACTRefJSON2Apex.referralDetailsResponse.referrals;
                system.debug('SRReferrals ***'+SRReferrals );   
                if (SRReferrals != null && SRReferrals.size() > 0){
                    for (ACETReferralJSON2Apex.referrals SRReferral : SRReferrals){
                        referral = new ACETReferralSearchResult();
                        referral.resultreferralExternalID = SRReferral.referralId;
                        referral.resultReferaltype = SRReferral.referralDescription;
                        referral.resultStartdate = ChangeDateFormat(SRReferral.referralDateRange.startDate);
                        referral.resultEnddate = ChangeDateFormat(SRReferral.referralDateRange.stopDate);
                        referral.resultReferralstatus = SRReferral.statusCode.desc_z;
                        
                        String dateTimeString = SRReferral.createDateTime;
                        system.debug('datetime--->'+dateTimeString);
                        if(dateTimeString.indexOf('.') != -1) {
                            dateTimeString = dateTimeString.substring(0, dateTimeString.indexOf('.'));
                            dateTimeString = dateTimeString.replace('T', ' ');
                            dateTimeString = DateTime.valueOf(dateTimeString).format('MM/dd/yyyy hh:mm:ss a');
                            system.debug('datetime-->'+dateTimeString);
                            referral.resultCreatedDate = dateTimeString;
                        }
                        else {
                            dateTimeString = dateTimeString.replace('T', ' ');
                            dateTimeString = DateTime.valueOf(dateTimeString).format('MM/dd/yyyy hh:mm:ss a');
                            system.debug('datetime-->'+dateTimeString);
                            referral.resultCreatedDate = dateTimeString;
                            
                        }
                        //US935410
                        referral.numberofvisit = SRReferral.numberofvisits; 
                        
                        //system.debug('SRReferral.noteText is '+SRReferral.noteText);
                        system.debug('json.serialize(SRReferral) '+json.serialize(SRReferral));
                        
                        if(json.serialize(SRReferral).contains('"noteText":'))
                        {
                            referral.noteText = (SRReferral.noteText != null)?SRReferral.noteText:'';
                        }
                        
                        
                        referral.servicelst = new List<ACETReferralSearchResult.Service>();
                        List<ACETReferralJSON2Apex.Services>  serVar = new List<ACETReferralJSON2Apex.Services>();
                        //system.debug('SRReferral.services is '+SRReferral.services);
                        if(SRReferral.services!=null && !SRReferral.services.isEmpty())
                        {
                            serVar = SRReferral.services;
                            
                            for(ACETReferralJSON2Apex.Services serVarItem: serVar){
                                ACETReferralSearchResult.Service servList = new ACETReferralSearchResult.Service();
                                servList.resultProcedureType = serVarItem.procedureCode.typeCodeDesc;
                                servList.resultProcedureCode = serVarItem.procedureCode.code;
                                servList.resultDescription = serVarItem.procedureCode.codeDesc;
                                referral.servicelst.add(servList);
                            }
                        }
                        referral.diagnosisList = new List<ACETReferralSearchResult.Diagnosis>();
                        
                        if(SRReferral.diagnosis != null && SRReferral.diagnosis.size()>0){
                            referral.resultDxcode = (SRReferral.diagnosis[0] != null && SRReferral.diagnosis[0].diagnosisCode != null && SRReferral.diagnosis[0].diagnosisCode.Code!= null)?SRReferral.diagnosis[0].diagnosisCode.Code:''; 
                            referral.resultDXDescription = (SRReferral.diagnosis[0] != null && SRReferral.diagnosis[0].diagnosisCode != null && SRReferral.diagnosis[0].diagnosisCode.codeDesc!= null)?SRReferral.diagnosis[0].diagnosisCode.codeDesc:'';
                            
                            for(ACETReferralJSON2Apex.Diagnosis dxItem :SRReferral.diagnosis){
                                ACETReferralSearchResult.Diagnosis  dxResult = new ACETReferralSearchResult.Diagnosis();
                                dxResult.resultdiagCode = (dxitem.diagnosisCode != null && dxitem.diagnosisCode.Code != null)?dxitem.diagnosisCode.Code:'';
                                dxResult.resultdiadDesc = (dxitem.diagnosisCode != null && dxitem.diagnosisCode.codeDesc!= null)?dxitem.diagnosisCode.codeDesc:'';
                                referral.diagnosisList.add(dxResult);
                            }
                        }
                        referral.providerlst = new List<ACETReferralSearchResult.Provider>();
                        
                        List<ACETReferralJSON2Apex.Providers>  provVar = new List<ACETReferralJSON2Apex.Providers>();
                        if(SRReferral.providers != null && !SRReferral.providers.isEmpty()) {
                           provVar = SRReferral.providers; 
                        }
                        system.debug('provVar is '+provVar);
                        //ACETReferralSearchResult.Provider provList;
                        
                        for(ACETReferralJSON2Apex.Providers ProvItem:provVar ){
                                
                        system.debug('***Role'+ProvItem.role);
                            if(ProvItem.Role != null && !ProvItem.Role.isEmpty()){
                                for(ACETReferralJSON2Apex.Role roleItem:ProvItem.Role){
                                ACETReferralSearchResult.Provider provList = new ACETReferralSearchResult.Provider();
                        
                                    if(roleItem.desc_z == 'Servicing'){
                                        if(ProvItem.providerIdentifiers != null)
                                        {
                                            system.debug('***Servicing'+ProvItem.providerIdentifiers );
                                            for(ACETReferralJSON2Apex.EnrolleIdentifiers provIden:ProvItem.providerIdentifiers ){
                                                if(provIden.typeCode == '03'){
                                                    system.debug('***ServicingTIN03'+provIden);
                                                    provList.resultTIN =  provIden.Id;
                                                    referral.resultServicingtin = provIden.Id;
                                                }
                                            
                                                if(provIden.typeCode == '14')
                                                    provList.resultMPIN =  provIden.Id;
                                            }
                                        }
                                            provList.resultProviderRole  = roleItem.desc_Z;
                                            ProvItem.firstName = (ProvItem.firstName != null )?ProvItem.firstName :'';
                                            ProvItem.middleName = (ProvItem.middleName != null )?ProvItem.middleName :'';
                                            ProvItem.lastName = (ProvItem.lastName != null )?ProvItem.lastName :'';
                                            provList.resultName = ProvItem.firstName + ' ' + ProvItem.middleName + ' ' + ProvItem.lastName ;
                                            referral.resultServicingprovider  = provList.resultName ;
                                            if(ProvItem.address != null){
                                                provList.resultCity = (ProvItem.address.city != null)?ProvItem.address.city : '';
                                                provList.resultState = (ProvItem.address.state.code != null)?ProvItem.address.state.code : '';
                                                provList.resultAddress = (ProvItem.address.addressLine1 !=null)?ProvItem.address.addressLine1:'';
                                                provList.resultZip = (ProvItem.address.postalCode1 != null) ? ProvItem.address.postalCode1 : '';
                                            }
                                            if(ProvItem.specialityType != null)
                                            {
                                                for(ACETReferralJSON2Apex.SpecialityType spec:ProvItem.specialityType){
                                                
                                                    provList.speciality = (spec.desc_z!= null)?spec.desc_z:'';
                                                
                                                }
                                            }
                                            system.debug('*** Provider Item SServicing'+provList);
                                            referral.providerlst.add(provList); 

                                        
                                    }
                                    if(roleItem.desc_z == 'Requesting Provider'){
                                        if(ProvItem.providerIdentifiers != null)
                                        {
                                            system.debug('***Requesting'+ProvItem.providerIdentifiers );
                                            
                                            for(ACETReferralJSON2Apex.EnrolleIdentifiers provIden:ProvItem.providerIdentifiers){
                                                if(provIden.typeCode == '03')
                                                {
                                                    system.debug('***Requesting 03 TIN'+provIden);
                                            
                                                    provList.resultTIN =  provIden.Id;
                                                    referral.resultRequestingtin = provIden.Id;
                                                }
                                                if(provIden.typeCode == '14')
                                                    provList.resultMPIN =  provIden.Id;
                                                    
                                            } 
                                        }
                                            provList.resultProviderRole  = roleItem.desc_Z;
                                            ProvItem.firstName = (ProvItem.firstName != null )?ProvItem.firstName :'';
                                            ProvItem.middleName = (ProvItem.middleName != null )?ProvItem.middleName :'';
                                            ProvItem.lastName = (ProvItem.lastName != null )?ProvItem.lastName :'';
                                            provList.resultName =  ProvItem.firstName + ' ' + ProvItem.middleName + ' ' + ProvItem.lastName ;
                                            referral.resultRequestingprovider = provList.resultName;
                                            if(ProvItem.address != null){
                                                provList.resultCity = (ProvItem.address.city != null)?ProvItem.address.city : '';
                                                provList.resultState = (ProvItem.address.state.code != null)?ProvItem.address.state.code : '';
                                                provList.resultAddress = (ProvItem.address.addressLine1 !=null)?ProvItem.address.addressLine1:'';
                                                provList.resultZip = (ProvItem.address.postalCode1 != null) ? ProvItem.address.postalCode1 : '';
                                            }
                                            for(ACETReferralJSON2Apex.SpecialityType spec:ProvItem.specialityType){
                                            
                                                provList.speciality = (spec.desc_z!= null)?spec.desc_z:'';
                                            
                                            }
                                        system.debug('*** Provider Item Requesting'+provList);
                                        referral.providerlst.add(provList); 
                                        
                                    }
                                    if(roleItem.desc_z == 'Primary Care Provider'){
                                        if(ProvItem.providerIdentifiers !=null){
                                            for(ACETReferralJSON2Apex.EnrolleIdentifiers provIden:ProvItem.providerIdentifiers){
                                                if(provIden.typeCode == '03'){
                                                    provList.resultTIN = provIden.Id;
                                                    referral.resultPrimarytin = provIden.Id;
                                                }
                                            
                                                if(provIden.typeCode == '14')
                                                    provList.resultMPIN =  provIden.Id;
                                            }
                                        }
                                            provList.resultProviderRole  = roleItem.desc_Z;
                                            ProvItem.firstName = (ProvItem.firstName != null )?ProvItem.firstName :'';
                                            ProvItem.middleName = (ProvItem.middleName != null )?ProvItem.middleName :'';
                                            ProvItem.lastName = (ProvItem.lastName != null )?ProvItem.lastName :'';
                                            provList.resultName  = ProvItem.firstName + ' ' + ProvItem.middleName + ' ' + ProvItem.lastName ;
                                            referral.resultPrimaryprovider = provList.resultName;
                                            if(ProvItem.address != null){
                                                provList.resultCity = (ProvItem.address.city != null)?ProvItem.address.city : '';
                                                provList.resultState = (ProvItem.address.state.code != null)?ProvItem.address.state.code : '';
                                                provList.resultAddress = (ProvItem.address.addressLine1 !=null)?ProvItem.address.addressLine1:'';
                                                provList.resultZip = (ProvItem.address.postalCode1 != null) ? ProvItem.address.postalCode1 : '';
                                            }
                                            
                                            for(ACETReferralJSON2Apex.SpecialityType spec:ProvItem.specialityType){
                                            
                                                provList.speciality = (spec.desc_z!= null)?spec.desc_z:'';
                                            
                                            }
                                      system.debug('*** Provider Item PCP'+provList);
                                      referral.providerlst.add(provList); 
                                      
                                    }
                                    
                                    system.debug('*** Provider Item All'+referral.providerlst);
                                    
                                }
                             }
                          }
                          
                    lstReferrals.add(referral);
                    }
                    }
                    if (lstReferrals.size() > 0){
                        oACETWSCalloutResult.Success = true;
                        oACETWSCalloutResult.Message = '';
                        oACETWSCalloutResult.Response = lstReferrals;
                    }
                
                
            }
            //Added by Pavan to display No Records found for the Member
            else if(Response.getStatusCode() == 400){
                oACETWSCalloutResult.Success = false;
                oACETWSCalloutResult.Message = errorMap.get('GN400');
                oACETWSCalloutResult.statusCode = Response.getStatusCode();
            }
            else if(Response.getStatusCode() == 500 ){
                oACETWSCalloutResult.Success = false;
                oACETWSCalloutResult.Message =  errorMap.get('GN500');
                oACETWSCalloutResult.statusCode = Response.getStatusCode();
            }
            
            else if (Response.getStatusCode() == 404){
              ACETReferralJSON2Apex JSON2ApexError = (ACETReferralJSON2Apex)JSON.deserialize(ResponseBody, ACETReferralJSON2Apex.class);
              system.debug(LoggingLevel.INFO,'JSON2ApexError :: ' + JSON2ApexError);
              List<ACETReferralJSON2Apex.errors> authErrors = new List<ACETReferralJSON2Apex.errors>();       
              authErrors = JSON2ApexError.ReferralDetailsResponse.errors;  
              oACETWSCalloutResult.Success = false;
              oACETWSCalloutResult.Message = errorMap.get('GN404');
              oACETWSCalloutResult.statusCode = Response.getStatusCode();
              if(authErrors[0].code == 404 && authErrors[0].description.contains('ERR003-No Records found')){
                  system.debug(LoggingLevel.INFO,'authErrors :: ' + authErrors[0].description); 
                  
                  oACETWSCalloutResult = ParseFailureResponse(Response);
                  oACETWSCalloutResult.Success = false;
                  oACETWSCalloutResult.Message = errorMap.get('GN404');
                  oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;  
                  oACETWSCalloutResult.statusCode = Response.getStatusCode();
              } 
              else if(authErrors[0].code == 404 && authErrors[0].description.contains('ERR004-Member not found')){
                  system.debug(LoggingLevel.INFO,'authErrors :: ' + authErrors[0].description); 
                  
                  oACETWSCalloutResult = ParseFailureResponse(Response);
                  oACETWSCalloutResult.Success = false;
                  oACETWSCalloutResult.Message = errorMap.get('VPCP_Memnotfound');
                  oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;
                  oACETWSCalloutResult.statusCode = Response.getStatusCode();                 
              }    
          }
          
        }
        catch(Exception ex){
            system.debug(LoggingLevel.INFO, 'Exception in Find Referrals. Details: ' + ex.getMessage()+'at line '+ex.getLineNumber()); 
            oACETWSCalloutResult.Success = false;
            oACETWSCalloutResult.Message = ex.getMessage();
            oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;
        }
        system.debug('**oACETWSCalloutResult**'+oACETWSCalloutResult);
        return oACETWSCalloutResult;
    }
}