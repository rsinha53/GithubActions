//public class ACETLGT_ReferralWebservice extends ACETWebService{
public with sharing class ACETLGT_ReferralWebservice{
    public String replaceKeyword = 'pcp-referrals-response';
    public String c_firstName;
    public String c_lastName;
    public String c_birthDate;
    public String c_srk;
    private List<String> searchParameters ;
    public map<String,String> errorMap=new map<String,String>();
    
    public void init(string firstName, string lastName, string birthDate, string srk){ 
        c_firstName = firstName;
        c_lastName = lastName;
        c_birthDate = birthDate;
        c_srk = srk;                     
    }
    
    /*public override void GetEndpoint(){
        GetEndpointDetail('SearchClinicalReferralsEndpoint');
    }*/
    public ACETLGT_ReferralWebservice() {
        //super('Stargate'); //Doubt
         
        List<AcetErrorMessage__mdt> ErrorMessages =[SELECT  masterlabel,Error_Message__c,Message_Type__c,ServiceError__c,TopPriority__c,
                                                    Error_log_enabled__c FROM AcetErrorMessage__mdt ];//where masterlabel=:errorCode
        for(AcetErrorMessage__mdt em:ErrorMessages){
            errorMap.put(em.masterlabel, em.Error_Message__c);
        }
    }
     private String GetRequestBody(String srkId, String firstName, String lastName, String dob, String startDate,String pageNumber,String pageSize, String startRecord){
         System.debug('srkId::'+srkId);
         System.debug('firstName::'+firstName);
         System.debug('lastName::'+lastName);
         System.debug('dob::'+dob);
         System.debug('pageNumber::'+pageNumber);
         System.debug('pageSize::'+pageSize);
         System.debug('startRecord::'+startRecord);
         String requestBody = '';   
         ACETLGT_ReferralWebserviceRequest refServiceRequest = new ACETLGT_ReferralWebserviceRequest();
         	requestBody = refServiceRequest.addSearchInput(srkId, firstName, lastName, dob, startDate, pageNumber, pageSize, startRecord);
         requestBody = requestBody.replace('pcpReferralsRequest', 'pcp-referrals-request');
         return requestBody;
        }

    /*private string GetRequestBody(){
        String RequestBody;
        ACETLGT_ReferralWebserviceRequest rw = new ACETLGT_ReferralWebserviceRequest();
        RequestBody = rw.prepareRequest();
        RequestBody = String.format(RequestBody, searchParameters);
        RequestBody = RequestBody.replace('PcpReferralsRequest', 'pcp-referrals-request');
        system.debug(LoggingLevel.INFO, 'RequestBody: ' + RequestBody);
        if(test.isRunningTest()){
            RequestBody = '{ "pcp-referrals-request": { "searchType": "M", "member": { "enrolleeIdentifier": { "id": 3, "type": "SRK" }, "firstName": "{0}", "lastName": "{1}", "birthDate": "{2}" }, "requestDateRange": { "startDate": "{4}", "stopDate": "9999-12-31", "dateRangeTypeCode": "" }, "pagination": { "pageNumber": 1, "pageSize": "", "startRecord": "" } } }';
        }
       return RequestBody;
    }*/
    public virtual ACETWSCalloutResult ParseFailureResponse(HttpResponse FailureResponse)   {
        ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult();
        oACETWSCalloutResult.Success = false;
        oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;
        try {
            Map<String, Object> mapRootNode = (Map<String, Object>)JSON.deserializeUntyped(FailureResponse.getBody());
            if (FailureResponse.getStatusCode() == 500 &&
                (mapRootNode.containsKey('ErrorCode') && mapRootNode.containsKey('Advice'))) {
                    //Parse failure repsonse from ISL
                    oACETWSCalloutResult.Message = Label.ACETUnexpectedErrorMessage;
                } else {
                    //Parse failure response from OIL
                    Map<String, Object> mapErrors = (Map<String, Object>)mapRootNode.values().get(0);
                    system.debug('Map Errors:' + mapErrors);
                    List<Object> lstErrors = (List<Object>)mapErrors.get('errors');
                    system.debug('List Errors:' + lstErrors);
                    if (lstErrors == null) {
                        Map<String, Object> mapTypeNode = (Map<String, Object>)mapErrors.values().get(0);
                        lstErrors = (List<Object>)mapTypeNode.get('errors');
                        system.debug('List Errors 2:' + lstErrors);
                    }
                    Map<String, Object> mapError;
                    String ErrorDescription;
                    if(lstErrors != null) {
                        for (Object oError :lstErrors) {
                            mapError = (Map<String, Object>)oError;
                            system.debug('Error: ' + mapError);
                            ErrorDescription = String.valueOf(mapError.get('description'));
                            ParseFailureResponseStoreErrorMsg(oACETWSCalloutResult,ErrorDescription);
                        }
                    }
                }
        }
        catch(Exception ex)
        {
            system.debug(LoggingLevel.INFO, 'Error serializing error response JSON. Details: ' + ex);
            oACETWSCalloutResult.Message = FailureResponse.getBody();
        }
        
        return oACETWSCalloutResult;
    }
    public void ParseFailureResponseStoreErrorMsg(ACETWSCalloutResult oACETWSCalloutResult, String ErrorDescription){
        if (String.isBlank(oACETWSCalloutResult.Message)) {
            oACETWSCalloutResult.Message = ErrorDescription;
        } else {
            if (oACETWSCalloutResult.Message.length() + ErrorDescription.length() <= 255) {
                oACETWSCalloutResult.Message += '; ' + ErrorDescription;
            } else {
               // break;
            }
        }
    }
    //Change date format from YYYY-MM-DD to MM/DD/YYYY
    public String ChangeDateFormat(String OILDate) {
        String FormattedDate = '';
        
        if (String.isNotBlank(OILDate)) {
            List<String> OILDateSplit = OILDate.split('-');
            if(OILDateSplit.size() == 3) {
                FormattedDate = OILDateSplit[1] + '/' + OILDateSplit[2] + '/' + OILDateSplit[0];
            }
        }
        
        return FormattedDate;
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
    public ACETWSCalloutResult queryPaginatedData(Integer pageNumber, Integer pageSize, Integer startRecord){ //created replica of this method added by suresh
        return queryPaginatedData(pageNumber,pageSize,startRecord,null,null,null,null);
    }
    public ACETWSCalloutResult queryPaginatedData(Integer pageNumber, Integer pageSize, Integer startRecord, String firstName, String lastName, String birthDate, String srk){ //This was a override method
        String RequestBody;
        system.debug('birthDate is '+c_birthDate);
        searchParameters = new String[] {c_firstName, c_lastName,setStringToDateFormat(c_birthDate), c_srk, setStringToDateFormat(c_birthDate)};    
        ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult();
        List<ACETLGT_ReferralSearchResult> lstReferrals = new List<ACETLGT_ReferralSearchResult>();
        ACETLGT_ReferralSearchResult referral;
        List<ACETLGT_ReferralJSON2Apex.referrals> SRReferrals;
        
        try{
            //c_srk,  c_firstName,  c_lastName,  c_birthDate - These values are coming null that's why no results are coming as transections are different. Init Method calling in different transection and this method is calling in different transcetion. 
            RequestBody = GetRequestBody( srk,  firstName,  lastName,  setStringToDateFormat(birthDate),  setStringToDateFormat(birthDate), String.valueOf(pageNumber), String.valueOf(pageSize),  String.valueOf(startRecord));
            String responseStr;
            ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework();
            wsCallOutFW.serviceName = 'Search Clinical Referrals Endpoint';
            wsCallOutFW.RequestBody = RequestBody; 
            system.debug('RequestBody>>>'+RequestBody);
            HttpResponse response  = wsCallOutFW.getResponse();
            responseStr = response!=null?response.getBody():'';
            system.debug('Respone--->'+Response.getBody());
            if (Response.getStatusCode() == 200){
                String ResponseBody = Response.getBody().replace('desc','desc_z').replace(replaceKeyword,'referralDetailsResponse');
                system.debug('ResponseBody: ' + ResponseBody);    
                
                ACETLGT_ReferralJSON2Apex ACTRefJSON2Apex = (ACETLGT_ReferralJSON2Apex)JSON.deserialize(ResponseBody, ACETLGT_ReferralJSON2Apex.class);
                system.debug('ACTRefJSON2Apex****'+ ACTRefJSON2Apex);
                
                SRReferrals = ACTRefJSON2Apex.referralDetailsResponse.referrals;
                system.debug('SRReferrals ***'+SRReferrals );   
                processSRReferrals(SRReferrals,lstReferrals,referral);
                    if (lstReferrals.size() > 0){
                        oACETWSCalloutResult.Success = true;
                        oACETWSCalloutResult.Message = '';
                        oACETWSCalloutResult.Response = lstReferrals;
                        oACETWSCalloutResult.statusCode = Response.getStatusCode();
                    }
                
                
            }
            else {
                oACETWSCalloutResult.Success = false;
                oACETWSCalloutResult.statusCode = Response.getStatusCode();
                getErrorMessage(oACETWSCalloutResult,errorMap,response);
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
    public void processSRReferralsDiagnosis(ACETLGT_ReferralJSON2Apex.referrals SRReferral,ACETLGT_ReferralSearchResult referral){
        if(SRReferral.diagnosis != null && SRReferral.diagnosis.size()>0){
            referral.resultDxcode = (SRReferral.diagnosis[0] != null && SRReferral.diagnosis[0].diagnosisCode != null && SRReferral.diagnosis[0].diagnosisCode.Code!= null)?SRReferral.diagnosis[0].diagnosisCode.Code:''; 
            referral.resultDXDescription = (SRReferral.diagnosis[0] != null && SRReferral.diagnosis[0].diagnosisCode != null && SRReferral.diagnosis[0].diagnosisCode.codeDesc!= null)?SRReferral.diagnosis[0].diagnosisCode.codeDesc:'';
            
        }
    }
    public void processSRReferrals(List<ACETLGT_ReferralJSON2Apex.referrals> SRReferrals, List<ACETLGT_ReferralSearchResult> lstReferrals,ACETLGT_ReferralSearchResult referral){ //this method has been written to reduce to if condition for queryPaginatedData method
        if (SRReferrals != null && SRReferrals.size() > 0){
            for (ACETLGT_ReferralJSON2Apex.referrals SRReferral : SRReferrals){
                referral = new ACETLGT_ReferralSearchResult();
                referral.resultreferralExternalID = SRReferral.referralId;
                referral.resultReferaltype = SRReferral.referralDescription;
                referral.resultStartdate = ChangeDateFormat(SRReferral.referralDateRange.startDate);
                referral.resultEnddate = ChangeDateFormat(SRReferral.referralDateRange.stopDate);
                referral.resultReferralstatus = SRReferral.statusCode.desc_z;
                system.debug('json.serialize(SRReferral) '+json.serialize(SRReferral));                       
                processSRReferralsDiagnosis(SRReferral,referral);
                List<ACETLGT_ReferralJSON2Apex.Providers>  provVar = new List<ACETLGT_ReferralJSON2Apex.Providers>();
                if(SRReferral.providers != null && !SRReferral.providers.isEmpty()) {
                    provVar = SRReferral.providers; 
                }
                system.debug('provVar is '+provVar);
                for(ACETLGT_ReferralJSON2Apex.Providers ProvItem:provVar ){
                    
                    system.debug('***Role'+ProvItem.role);
                   processSRReferalsRole(ProvItem, referral);
                }
                
                lstReferrals.add(referral);
            }
        }
    }
    public void processSRReferalsRoleServicing(ACETLGT_ReferralJSON2Apex.Providers ProvItem, ACETLGT_ReferralSearchResult referral,ACETLGT_ReferralSearchResult.Provider provList){
        ProvItem.firstName = (ProvItem.firstName != null )?ProvItem.firstName :'';
        ProvItem.middleName = (ProvItem.middleName != null )?ProvItem.middleName :'';
        ProvItem.lastName = (ProvItem.lastName != null )?ProvItem.lastName :'';
        provList.resultName = ProvItem.firstName + ' ' + ProvItem.middleName + ' ' + ProvItem.lastName ;
        referral.resultServicingprovider  = provList.resultName ;
        system.debug('*** Provider Item SServicing'+provList);
    }
    public void processSRReferalsRoleRequestingProvider(ACETLGT_ReferralJSON2Apex.Providers ProvItem, ACETLGT_ReferralSearchResult referral, ACETLGT_ReferralSearchResult.Provider provList){
        ProvItem.firstName = (ProvItem.firstName != null )?ProvItem.firstName :'';
        ProvItem.middleName = (ProvItem.middleName != null )?ProvItem.middleName :'';
        ProvItem.lastName = (ProvItem.lastName != null )?ProvItem.lastName :'';
        provList.resultName =  ProvItem.firstName + ' ' + ProvItem.middleName + ' ' + ProvItem.lastName ;
        referral.resultRequestingprovider = provList.resultName;
    }
    public void processSRReferalsRole(ACETLGT_ReferralJSON2Apex.Providers ProvItem, ACETLGT_ReferralSearchResult referral){//this method has been written to reduce to if condition for queryPaginatedData method
        if(ProvItem.Role != null && !ProvItem.Role.isEmpty()){
            for(ACETLGT_ReferralJSON2Apex.Role roleItem:ProvItem.Role){
                ACETLGT_ReferralSearchResult.Provider provList = new ACETLGT_ReferralSearchResult.Provider();
                
                if(roleItem.desc_z == 'Servicing'){
                    processServicingTIN03(ProvItem,referral);
                    processSRReferalsRoleServicing(ProvItem,referral,provList);                 
                }
                if(roleItem.desc_z == 'Requesting Provider'){
                    processRequestingProviderTIN03(ProvItem,referral);
                    processSRReferalsRoleRequestingProvider(ProvItem,referral,provList);                  
                }
                
            }
        }
    }
    public void processServicingTIN03(ACETLGT_ReferralJSON2Apex.Providers ProvItem, ACETLGT_ReferralSearchResult referral){//this method has been written to reduce to if condition for queryPaginatedData method
        if(ProvItem.providerIdentifiers != null)
        {
            system.debug('***Servicing'+ProvItem.providerIdentifiers );
            for(ACETLGT_ReferralJSON2Apex.EnrolleIdentifiers provIden:ProvItem.providerIdentifiers ){
                if(provIden.typeCode == '03'){
                    system.debug('***ServicingTIN03'+provIden);
                    referral.resultServicingtin = provIden.Id;
                }
            }
        }
    }
    public void processRequestingProviderTIN03(ACETLGT_ReferralJSON2Apex.Providers ProvItem, ACETLGT_ReferralSearchResult referral){//this method has been written to reduce to if condition for queryPaginatedData method
        if(ProvItem.providerIdentifiers != null)
        {
            system.debug('***Requesting'+ProvItem.providerIdentifiers );
            for(ACETLGT_ReferralJSON2Apex.EnrolleIdentifiers provIden:ProvItem.providerIdentifiers){
                if(provIden.typeCode == '03')
                {
                    system.debug('***Requesting 03 TIN'+provIden);
                    referral.resultRequestingtin = provIden.Id;
                }
                
            } 
        }
    }
    public void processFRServicingTIN03(ACETLGT_ReferralJSON2Apex.Providers ProvItem, ACETLGT_ReferralSearchResult referral,ACETLGT_ReferralSearchResult.Provider provList){//this method has been written to reduce to if condition for findReferrals method
        if(ProvItem.providerIdentifiers != null)
        {
            system.debug('***Servicing'+ProvItem.providerIdentifiers );
            for(ACETLGT_ReferralJSON2Apex.EnrolleIdentifiers provIden:ProvItem.providerIdentifiers ){
                if(provIden.typeCode == '03'){
                    system.debug('***ServicingTIN03'+provIden);
                    provList.resultTIN =  provIden.Id;
                    referral.resultServicingtin = provIden.Id;
                }
                
                if(provIden.typeCode == '14')
                    provList.resultMPIN =  provIden.Id;
            }
        }
    }
    public void processFRRequestingProviderTIN03(ACETLGT_ReferralJSON2Apex.Providers ProvItem, ACETLGT_ReferralSearchResult referral, ACETLGT_ReferralSearchResult.Provider provList){//this method has been written to reduce to if condition for findReferrals method
        if(ProvItem.providerIdentifiers != null)
        {
            system.debug('***Requesting'+ProvItem.providerIdentifiers );
            
            for(ACETLGT_ReferralJSON2Apex.EnrolleIdentifiers provIden:ProvItem.providerIdentifiers){
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
    }
    public void processFRPrimaryCareProvider(ACETLGT_ReferralJSON2Apex.Providers ProvItem, ACETLGT_ReferralSearchResult referral, ACETLGT_ReferralSearchResult.Provider provList){//this method has been written to reduce to if condition for findReferrals method
        if(ProvItem.providerIdentifiers !=null){
            for(ACETLGT_ReferralJSON2Apex.EnrolleIdentifiers provIden:ProvItem.providerIdentifiers){
                if(provIden.typeCode == '03'){
                    provList.resultTIN = provIden.Id;
                    referral.resultPrimarytin = provIden.Id;
                }
                
                if(provIden.typeCode == '14')
                    provList.resultMPIN =  provIden.Id;
            }
        }
    }
    public void porcessFRAddress(ACETLGT_ReferralJSON2Apex.Providers ProvItem, ACETLGT_ReferralSearchResult.Provider provList){//this method has been written to reduce to if condition for findReferrals method
        if(ProvItem.address != null){
            provList.resultCity = (ProvItem.address.city != null)?ProvItem.address.city : '';
            provList.resultState = (ProvItem.address.state.code != null)?ProvItem.address.state.code : '';
            provList.resultAddress = (ProvItem.address.addressLine1 !=null)?ProvItem.address.addressLine1:'';
            provList.resultZip = (ProvItem.address.postalCode1 != null) ? ProvItem.address.postalCode1 : '';
        }
    }
    public void processFRDateTime(String dateTimeString,ACETLGT_ReferralSearchResult referral){//this method has been written to reduce to if condition for findReferrals method
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
    }
    public void processFRReferalNotText(ACETLGT_ReferralJSON2Apex.referrals SRReferral, ACETLGT_ReferralSearchResult referral){//this method has been written to reduce to if condition for findReferrals method
        if(json.serialize(SRReferral).contains('"noteText":'))
        {
            referral.noteText = (SRReferral.noteText != null)?SRReferral.noteText:'';
        }
    }
    public void processFRReferalServices(ACETLGT_ReferralJSON2Apex.referrals SRReferral, ACETLGT_ReferralSearchResult referral, List<ACETLGT_ReferralJSON2Apex.Services>  serVar){//this method has been written to reduce to if condition for findReferrals method
        if(SRReferral.services!=null && !SRReferral.services.isEmpty())
        {
            serVar = SRReferral.services;
            
            for(ACETLGT_ReferralJSON2Apex.Services serVarItem: serVar){
                ACETLGT_ReferralSearchResult.Service servList = new ACETLGT_ReferralSearchResult.Service();
                servList.resultProcedureType = serVarItem.procedureCode.typeCodeDesc;
                servList.resultProcedureCode = serVarItem.procedureCode.code;
                servList.resultDescription = serVarItem.procedureCode.codeDesc;
                referral.servicelst.add(servList);
            }
        }
    }
    public void processFRReferalDiagnosisHlpr(ACETLGT_ReferralJSON2Apex.referrals SRReferral, ACETLGT_ReferralSearchResult referral){
        referral.resultDxcode = (SRReferral.diagnosis[0] != null && SRReferral.diagnosis[0].diagnosisCode != null && SRReferral.diagnosis[0].diagnosisCode.Code!= null)?SRReferral.diagnosis[0].diagnosisCode.Code:''; 
        referral.resultDXDescription = (SRReferral.diagnosis[0] != null && SRReferral.diagnosis[0].diagnosisCode != null && SRReferral.diagnosis[0].diagnosisCode.codeDesc!= null)?SRReferral.diagnosis[0].diagnosisCode.codeDesc:'';
    }
    public void processFRReferalDiagnosis(ACETLGT_ReferralJSON2Apex.referrals SRReferral, ACETLGT_ReferralSearchResult referral){//this method has been written to reduce to if condition for findReferrals method
        if(SRReferral.diagnosis != null && SRReferral.diagnosis.size()>0){
            processFRReferalDiagnosisHlpr(SRReferral,referral);
            for(ACETLGT_ReferralJSON2Apex.Diagnosis dxItem :SRReferral.diagnosis){
                ACETLGT_ReferralSearchResult.Diagnosis  dxResult = new ACETLGT_ReferralSearchResult.Diagnosis();
                dxResult.resultdiagCode = (dxitem.diagnosisCode != null && dxitem.diagnosisCode.Code != null)?dxitem.diagnosisCode.Code:'';
                dxResult.resultdiadDesc = (dxitem.diagnosisCode != null && dxitem.diagnosisCode.codeDesc!= null)?dxitem.diagnosisCode.codeDesc:'';
                referral.diagnosisList.add(dxResult);
            }
        }
    }
    public void processFRServicingMainSpeciality(ACETLGT_ReferralJSON2Apex.Providers ProvItem, ACETLGT_ReferralSearchResult.Provider provList){
        if(ProvItem.specialityType != null)
        {
            for(ACETLGT_ReferralJSON2Apex.SpecialityType spec:ProvItem.specialityType){
                
                provList.speciality = (spec.desc_z!= null)?spec.desc_z:'';
                
            }
        }
    }
    public void processFRServicingMain(ACETLGT_ReferralJSON2Apex.Providers ProvItem, ACETLGT_ReferralSearchResult referral, ACETLGT_ReferralSearchResult.Provider provList,ACETLGT_ReferralJSON2Apex.Role roleItem){
        if(roleItem.desc_z == 'Servicing'){
            processFRServicingTIN03(ProvItem,referral,provList);
            provList.resultProviderRole  = roleItem.desc_Z;
            ProvItem.firstName = (ProvItem.firstName != null )?ProvItem.firstName :'';
            ProvItem.middleName = (ProvItem.middleName != null )?ProvItem.middleName :'';
            ProvItem.lastName = (ProvItem.lastName != null )?ProvItem.lastName :'';
            provList.resultName = ProvItem.firstName + ' ' + ProvItem.middleName + ' ' + ProvItem.lastName ;
            referral.resultServicingprovider  = provList.resultName ;
            porcessFRAddress(ProvItem,provList);
            processFRServicingMainSpeciality(ProvItem,provList);
            system.debug('*** Provider Item SServicing'+provList);
            referral.providerlst.add(provList); 
            
            
        }
    }
    public void processFRRequestingProviderMain(ACETLGT_ReferralJSON2Apex.Providers ProvItem, ACETLGT_ReferralSearchResult referral, ACETLGT_ReferralSearchResult.Provider provList,ACETLGT_ReferralJSON2Apex.Role roleItem){
        if(roleItem.desc_z == 'Requesting Provider'){
            processFRRequestingProviderTIN03(ProvItem,referral,provList);
            provList.resultProviderRole  = roleItem.desc_Z;
            ProvItem.firstName = (ProvItem.firstName != null )?ProvItem.firstName :'';
            ProvItem.middleName = (ProvItem.middleName != null )?ProvItem.middleName :'';
            ProvItem.lastName = (ProvItem.lastName != null )?ProvItem.lastName :'';
            provList.resultName =  ProvItem.firstName + ' ' + ProvItem.middleName + ' ' + ProvItem.lastName ;
            referral.resultRequestingprovider = provList.resultName;
            porcessFRAddress(ProvItem,provList);
            for(ACETLGT_ReferralJSON2Apex.SpecialityType spec:ProvItem.specialityType){
                
                provList.speciality = (spec.desc_z!= null)?spec.desc_z:'';
                
            }
            system.debug('*** Provider Item Requesting'+provList);
            referral.providerlst.add(provList); 
            
        }
    }
    public void processFRPrimaryCareProviderMain(ACETLGT_ReferralJSON2Apex.Providers ProvItem, ACETLGT_ReferralSearchResult referral, ACETLGT_ReferralSearchResult.Provider provList,ACETLGT_ReferralJSON2Apex.Role roleItem){
        if(roleItem.desc_z == 'Primary Care Provider'){
            processFRPrimaryCareProvider(ProvItem,referral,provList);
            provList.resultProviderRole  = roleItem.desc_Z;
            ProvItem.firstName = (ProvItem.firstName != null )?ProvItem.firstName :'';
            ProvItem.middleName = (ProvItem.middleName != null )?ProvItem.middleName :'';
            ProvItem.lastName = (ProvItem.lastName != null )?ProvItem.lastName :'';
            provList.resultName  = ProvItem.firstName + ' ' + ProvItem.middleName + ' ' + ProvItem.lastName ;
            referral.resultPrimaryprovider = provList.resultName;
            porcessFRAddress(ProvItem,provList);
            
            for(ACETLGT_ReferralJSON2Apex.SpecialityType spec:ProvItem.specialityType){
                
                provList.speciality = (spec.desc_z!= null)?spec.desc_z:'';
                
            }
            system.debug('*** Provider Item PCP'+provList);
            referral.providerlst.add(provList); 
            
        }
    }
    public void processProvItemRole(ACETLGT_ReferralJSON2Apex.Providers ProvItem, ACETLGT_ReferralSearchResult referral){
        if(ProvItem.Role != null && !ProvItem.Role.isEmpty()){
            for(ACETLGT_ReferralJSON2Apex.Role roleItem:ProvItem.Role){
                ACETLGT_ReferralSearchResult.Provider provList = new ACETLGT_ReferralSearchResult.Provider();
                processFRServicingMain(ProvItem,referral,provList,roleItem);
                processFRRequestingProviderMain(ProvItem,referral,provList,roleItem);
                processFRPrimaryCareProviderMain(ProvItem,referral,provList,roleItem);
                
                system.debug('*** Provider Item All'+referral.providerlst);
                
            }
        }
    }
    public void processFRSRReferrals(List<ACETLGT_ReferralJSON2Apex.referrals> SRReferrals, List<ACETLGT_ReferralSearchResult> lstReferrals,ACETLGT_ReferralSearchResult referral){//this method has been written to reduce to if condition for findReferrals method
        if (SRReferrals != null && SRReferrals.size() > 0){
            for (ACETLGT_ReferralJSON2Apex.referrals SRReferral : SRReferrals){
                referral = new ACETLGT_ReferralSearchResult();
                referral.resultreferralExternalID = SRReferral.referralId;
                referral.resultReferaltype = SRReferral.referralDescription;
                referral.resultStartdate = ChangeDateFormat(SRReferral.referralDateRange.startDate);
                referral.resultEnddate = ChangeDateFormat(SRReferral.referralDateRange.stopDate);
                referral.resultReferralstatus = SRReferral.statusCode.desc_z;
                
                String dateTimeString = SRReferral.createDateTime;
                system.debug('datetime--->'+dateTimeString);
                processFRDateTime(dateTimeString,referral);
                //US935410
                referral.numberofvisit = SRReferral.numberofvisits; 
                
                //system.debug('SRReferral.noteText is '+SRReferral.noteText);
                system.debug('json.serialize(SRReferral) '+json.serialize(SRReferral));
                processFRReferalNotText(SRReferral,referral);
                referral.servicelst = new List<ACETLGT_ReferralSearchResult.Service>();
                List<ACETLGT_ReferralJSON2Apex.Services>  serVar = new List<ACETLGT_ReferralJSON2Apex.Services>();
                //system.debug('SRReferral.services is '+SRReferral.services);
                processFRReferalServices(SRReferral,referral,serVar);
                referral.diagnosisList = new List<ACETLGT_ReferralSearchResult.Diagnosis>();
                processFRReferalDiagnosis(SRReferral,referral);
                referral.providerlst = new List<ACETLGT_ReferralSearchResult.Provider>();
                
                List<ACETLGT_ReferralJSON2Apex.Providers>  provVar = new List<ACETLGT_ReferralJSON2Apex.Providers>();
                if(SRReferral.providers != null && !SRReferral.providers.isEmpty()) {
                    provVar = SRReferral.providers; 
                }
                system.debug('provVar is '+provVar);
                //ACETReferralSearchResult.Provider provList;
                
                for(ACETLGT_ReferralJSON2Apex.Providers ProvItem:provVar ){
                    processProvItemRole(ProvItem,referral);
                    system.debug('***Role'+ProvItem.role);

                }
                
                lstReferrals.add(referral);
            }
        }
    }
    public void getErrorMessage(ACETWSCalloutResult oACETWSCalloutResult,map<String,String> errorMap, HttpResponse response){ //this method has been added to reduce if condition for both
        if(oACETWSCalloutResult.statusCode!=null && oACETWSCalloutResult.statusCode == 400){
            oACETWSCalloutResult.Message = errorMap.get('GN400');
        }
        else if(oACETWSCalloutResult.statusCode!=null && oACETWSCalloutResult.statusCode == 500){
            oACETWSCalloutResult.Message = errorMap.get('GN500');
        }
        else if(oACETWSCalloutResult.statusCode!=null && oACETWSCalloutResult.statusCode == 404){
            String ResponseBody = Response.getBody().replace(replaceKeyword,'referralDetailsResponse');
            ACETLGT_ReferralJSON2Apex JSON2ApexError = (ACETLGT_ReferralJSON2Apex)JSON.deserialize(ResponseBody, ACETLGT_ReferralJSON2Apex.class);
            system.debug(LoggingLevel.INFO,'JSON2ApexError :: ' + JSON2ApexError);
            List<ACETLGT_ReferralJSON2Apex.errors> authErrors = new List<ACETLGT_ReferralJSON2Apex.errors>();       
            authErrors = JSON2ApexError.ReferralDetailsResponse.errors;  
            oACETWSCalloutResult.Success = false;
            oACETWSCalloutResult.Message = errorMap.get('GN404');
            oACETWSCalloutResult.statusCode = Response.getStatusCode();
            if(authErrors[0].code == 404 && (authErrors[0].description.contains('ERR003-No Records found') || authErrors[0].description.contains('ERR004-Member not found'))){
                system.debug(LoggingLevel.INFO,'authErrors :: ' + authErrors[0].description);
                oACETWSCalloutResult = ParseFailureResponse(Response);
                oACETWSCalloutResult.Message = errorMap.get('GN404');
                oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;                 
            } 
        }
    }
    public ACETWSCalloutResult findReferrals(String firstName,String lastName,String birthDate, String SRKNumber){
        //Date dob = setStringToDateFormat(birthDate);
        system.debug('birthDate is '+birthDate);
        //searchParameters = new String[] {firstName, lastName,String.valueof(birthDate), SRKNumber, String.valueof(birthDate)};
        searchParameters = new String[] {firstName, lastName,setStringToDateFormat(birthDate), SRKNumber, setStringToDateFormat(birthDate)};    
        ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult();
        List<ACETLGT_ReferralSearchResult> lstReferrals = new List<ACETLGT_ReferralSearchResult>();
        ACETLGT_ReferralSearchResult referral;
        List<ACETLGT_ReferralJSON2Apex.referrals> SRReferrals;
        
        try{
            String responseStr;
            ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework();
            wsCallOutFW.serviceName = 'Search Clinical Referrals Endpoint';
            wsCallOutFW.requestBody = GetRequestBody( SRKNumber,  firstName,  lastName,  setStringToDateFormat(birthDate),  setStringToDateFormat(birthDate), '', '',  '');
            HttpResponse Response  = wsCallOutFW.getResponse();
            responseStr = Response!=null?Response.getBody():'';
           // HttpResponse Response = Send(OAuthConfig);
	    String ResponseBody = Response.getBody().replace('desc','desc_z').replace(replaceKeyword,'referralDetailsResponse');
            system.debug('ResponseBody: ' + ResponseBody); 
            ACETLGT_ReferralJSON2Apex ACTRefJSON2Apex = (ACETLGT_ReferralJSON2Apex)JSON.deserialize(ResponseBody, ACETLGT_ReferralJSON2Apex.class);
            system.debug('ACTRefJSON2Apex****'+ ACTRefJSON2Apex);
            if (Response.getStatusCode() == 200){
                SRReferrals = ACTRefJSON2Apex.referralDetailsResponse.referrals;
                system.debug('SRReferrals ***'+SRReferrals );   
                processFRSRReferrals(SRReferrals,lstReferrals,referral);
                    if (lstReferrals.size() > 0){
                        oACETWSCalloutResult.Success = true;
                        oACETWSCalloutResult.Message = '';
                        oACETWSCalloutResult.Response = lstReferrals;
                        oACETWSCalloutResult.statusCode = Response.getStatusCode();
                    }
            }
            else {
                oACETWSCalloutResult.Success = false;
                oACETWSCalloutResult.statusCode = Response.getStatusCode();
                getErrorMessage(oACETWSCalloutResult,errorMap,response);
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