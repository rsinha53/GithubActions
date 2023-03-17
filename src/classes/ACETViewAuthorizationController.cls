public with sharing class ACETViewAuthorizationController extends ACETErrorHandler{
    public Case objCase {get;set;}
    public Interaction__c Interaction {get;set;}
    public Interaction__c StartDate{get;set;}
    public Interaction__c EndDate{get;set;}

    public string strAuthorizationNumber{get;set;}
    public String AuthorizationType {get;set;}
    public string strStatus{get;set;}
    public Contact subject{get;set;}
    public String SourceOriginator {get;set;}
    public string surrogateKey {get; set;}
    public boolean isCancelCaseCreation{get;set;}
    public boolean isDetailPage{get;set;}
    public boolean isMisdirectCaseCreation{get;set;}
    public ACETCallTopicsDataWrapper wrapper {get;set;}
    public Boolean selected{get;set;}
    public List<ACETAuthorizationSearchResult> inPatientAuthorizedList{set;get;}
    public List<ACETAuthorizationSearchResult> outPatientAuthorizedList{set;get;}
    public List<ACETAuthorizationSearchResult> facilityAuthorizedList{set;get;}
    public Boolean errorFlagForNoRecords {get;set;}      
    public Boolean allowedUser {get;set;}
    public Boolean isResearchUser {get;set;}
    public String baseURL{get;set;}
    public String originatorType{get;set;}
    public Boolean errorFlagForNoRecordsOnPage {get;set;} 
    
    public String inpatientErrorMsg {get;set;}
    public String outpatientFacilityErrorMsg {get;set;}
    public String outpatientErrorMsg {get;set;}
    
    public ACETHighlightsPanelAdditionalInfo AdditionalInfo {get;set;}
    public String hpAdditionInfoStr {get {
        return JSON.serialize(wrapper.AdditionalInfo);
    }set;}
    public ACETViewAuthorizationController(){
     try{
        wrapper = new ACETCallTopicsDataWrapper();
        wrapper.CaseObj = new Case();    
        wrapper.init();
        wrapper.CaseObj.topic__c = 'View Authorizations';
        errorFlagForNoRecords = false;   
        errorFlagForNoRecordsOnPage = false;         
     
        Interaction = new Interaction__c();
         StartDate = new Interaction__c();
         EndDate = new Interaction__c(); 
        Subject = new Contact();
        String additionalInfoStr = apexpages.currentpage().getparameters().get('additionalInfo');
        isDetailPage = true;
        inPatientAuthorizedList = new List<ACETAuthorizationSearchResult>();
        outPatientAuthorizedList = new List<ACETAuthorizationSearchResult>();
        facilityAuthorizedList = new List<ACETAuthorizationSearchResult>();
        wrapper.AdditionalInfo = (ACETHighlightsPanelAdditionalInfo)json.deserialize(additionalInfoStr,ACETHighlightsPanelAdditionalInfo.class);  
        AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
        
        set<string> msg_set = setErrorMsgInDataTable('VAUTH404',null);
        if(msg_set != null){
         for (string setElement : msg_set) {
             inpatientErrorMsg = outpatientFacilityErrorMsg = outpatientErrorMsg  = setElement;
              }              
            msg_set.clear();
          }
        
       
        //Get Provider Interaction SFDC Id
       String interactionId = ApexPages.currentPage().getParameters().get('interactionId');  
                  
        //Check if User is redirected to Member Search page from Provider detail page         
        if (!String.isEmpty(interactionId)){                        
            system.debug('InteractionId: ' + InteractionId);
            
            //Query Provider Interaction details
            Interaction = ACETProviderUtility.GetInteractionByID(interactionId);
            SourceOriginator = Interaction.Interaction_Type__c;
            system.debug('Interaction: ' + Interaction + ', SourceOriginator: ' + SourceOriginator);
        }
        String contactId = ApexPages.currentPage().getParameters().get('contactId');
        if (!String.isEmpty(contactId)){ 
            subject = ACETProviderUtility.GetContactByID(contactId);
        }
        if (!String.isEmpty(additionalInfostr)){        
            AdditionalInfo = (ACETHighlightsPanelAdditionalInfo)JSON.deserialize(additionalInfostr , ACETHighlightsPanelAdditionalInfo.class);
        }
        String AuthNumberstr = ApexPages.currentPage().getParameters().get('AuthNumber');
        if (!String.isEmpty(AuthNumberstr)){        
            strAuthorizationNumber = AuthNumberstr;
        }
            surrogateKey = ApexPages.currentPage().getParameters().get('SRK');
         if (!String.isEmpty(surrogateKey)){ 
            wrapper.surrogateKey = surrogateKey;
        }
        
        Contact varContact = [select Name, FirstName , lastName from Contact where Id=:apexpages.currentpage().getparameters().get('contactId')];
        baseURL = String.valueof(URL.getSalesforceBaseUrl().toExternalForm());
        String orginstance ;
        for(ACETOrgInstanceURLToOrgNameMap__c orgname:ACETOrgInstanceURLToOrgNameMap__c.getAll().values()) {
            
            if(baseURL.contains(orgname.Name)) {
                system.debug('tname '+orgname.name);
                orginstance = ACETOrgInstanceURLToOrgNameMap__c.getValues(orgname.name).Org_Name__c;
            }
        }
        if(orginstance != null){
            system.debug('orginstance is '+orginstance);
            baseURL += ACETURLEncryptionUtility.getICUEURL(orginstance+'_ICUECreateAuthorization');
        }
        system.debug('Group Number'+wrapper.AdditionalInfo.GroupNumber);
        originatorType = wrapper.interaction.originator_type__c;
        User usr = [select FederationIdentifier from user where id=:userinfo.getUserId()];
        String tempBaseURL = 'subscriberId={0}&firstName={1}&lastName={2}&userId={3}&contactName={4}&groupNumber={5}&functionId=Initiate_Hsc_Intake&landingPage=initiateHSCIntake&applicationId=ACET';
        if(originatorType == 'Member')
        {
            List<String> fillers = new String[]{apexpages.currentpage().getparameters().get('memberId'),varContact.FirstName,varcontact.LastName, usr.FederationIdentifier, wrapper.interaction.Originator_Name__c,wrapper.AdditionalInfo.GroupNumber};
            tempbaseURL = String.format(tempBaseURL, fillers);
        
        }
        else 
        {
            List<String> fillers = new String[]{apexpages.currentpage().getparameters().get('memberId'),varContact.FirstName,varcontact.LastName, usr.FederationIdentifier, wrapper.AdditionalInfo.contactName,wrapper.AdditionalInfo.GroupNumber};
            tempbaseURL = String.format(tempBaseURL, fillers);
        
        }
        System.debug('tempbaseURL-->'+tempBaseURL);
        //String Key = ACETWrapEncryptionKey__c.getValues(orginstance+'_ICUEEncryptionKey').Key__c;
        //baseURL += ACETURLEncryptionUtility.GetEncryptedValue(Key,'AES128',tempBaseURL);
        baseURL += ACETURLEncryptionUtility.GetEncryptedValue(ACETWrapEncryptionKey__c.getValues(orginstance+'_ICUEEncryptionKey').Key__c,'AES256',tempbaseURL);
        
        getloggedinProfileName();
       }catch(Exception ex){
          setErrorMsg('MGD997',ex);
        }
      }
      
      //Added by Swetha//
    public void renderCancelCaseSection(){
        isCancelCaseCreation=true;
        isDetailPage=false;  
    }
    public void renderMisdirectCaseSection(){
        isMisdirectCaseCreation=true;
        isDetailPage=false;  
    }      
    // Updated by Rama: Begin 
    public List<ACETAuthorizationSearchResult> Authorizations = new List<ACETAuthorizationSearchResult>();
    public void CallFindAuthorizationWS(){
       try{ 
        List<String> strList=new List<String>();
     
        String serviceDOB=AdditionalInfo.DOB;
        
        if(serviceDOB !=null){
            strList=serviceDOB.split('/',3);
        }
        if(strList.size()==3){     
              
            serviceDOB=strList[2]+'-'+minTwoDigits(strList[0])+'-'+minTwoDigits(strList[1]);
            strList=NULL;
        }
        else{
            serviceDOB='';
        }
               
        string serviceEffectiveDate=AdditionalInfo.EffectiveDate;
        
        if(serviceEffectiveDate !=null){
         strList = serviceEffectiveDate.split('/',3);
             if(strList.size()==3){       
            date d = date.valueOf((strList[2]+'-'+strList[0]+'-'+strList[1]));
            serviceEffectiveDate = string.valueOf(d.addMonths(-3));
            
            strList=NULL;
        }
            else{
                serviceEffectiveDate='';
            }
        }
        else{
            serviceEffectiveDate='';
        }
        
         // Date SED=date.today();
         // String serviceEndDate = string.valueOf(SED);
         String serviceEndDate= string.valueOf(Date.newInstance(9999, 12, 31));
        /* String serviceEndDate=AdditionalInfo.EndDate;
        
       if(serviceEndDate !=null){
            strList=serviceEndDate.split('/',3);
                if(strList.size()==3){        
            serviceEndDate=strList[2]+'-'+strList[0]+'-'+strList[1]; 
            strList=NULL;
        }
        else{
            serviceEndDate='';
            }
        }
        else{
            serviceEndDate='';
        } */
        //Code added by Avish to retrieve the User Federation ID and pass it to the webeservice class on 06012017
        String federationID = ACETProviderUtility.getFederationIDByUserID();        
        
        ACETWSCalloutResult findAuthServiceCalloutResult = ACETProviderUtility.FindAuthorization(surrogateKey,serviceDOB, subject.FirstName,subject.LastName,serviceEffectiveDate,serviceEndDate,federationID,null);
        system.debug(LoggingLevel.INFO,'findAuthServiceCalloutResult :: ' + findAuthServiceCalloutResult); 
        
        if(findAuthServiceCalloutResult.Success!=null && findAuthServiceCalloutResult.Success){
                errorFlagForNoRecords = false; 
            this.Authorizations = (list<ACETAuthorizationSearchResult>)findAuthServiceCalloutResult.Response;
            String strData = String.valueOf(findAuthServiceCalloutResult.totalCount);
            system.debug('--------------------count--------'+strData);
     //Added By Srinivasa           
        Integer count = Integer.valueOf(strData);
        system.debug('--------------------count--------'+count);
     
            inPatientAuthorizedList.clear();
            outPatientAuthorizedList.clear();
            facilityAuthorizedList.clear();
        
            for(ACETAuthorizationSearchResult objAcetSerchResult :Authorizations){
                if(objAcetSerchResult.Case_Type_Desc == 'Inpatient' && objAcetSerchResult!=null){
                    string jsonString = objAcetSerchResult.Authorization_Number+'_'+objAcetSerchResult.Case_Status+'_'+objAcetSerchResult.Pre_Determination+'_'+objAcetSerchResult.Create_Date+'_'+objAcetSerchResult.Expected_Admit_Date+'_'+objAcetSerchResult.Actual_Admit_Date+'_'+objAcetSerchResult.Expected_Dscharg_Date+'_'+objAcetSerchResult.Actual_Dscharg_Date+'_'+objAcetSerchResult.Facility_Status+'_'+objAcetSerchResult.Primary_Diagnosis+'_'+objAcetSerchResult.POS+'_'+objAcetSerchResult.ServiceDescDetail+'_'+objAcetSerchResult.LOS;
                    jsonString.replace('null','');  
                    jsonString = EncodingUtil.urlEncode(jsonString, 'UTF-8');                  
                    objAcetSerchResult.jsonString = jsonString;
                    inPatientAuthorizedList.add(objAcetSerchResult);

                }
                else if(objAcetSerchResult.Case_Type_Desc == 'Outpatient' && objAcetSerchResult!=null){
                   // String strProcCode = objAcetSerchResult.Procedure_Code.replace('&', '%26');
                    string jsonString = objAcetSerchResult.Authorization_Number+'_'+objAcetSerchResult.Case_Status+'_'+objAcetSerchResult.Pre_Determination+'_'+objAcetSerchResult.Create_Date+'_'+objAcetSerchResult.Start_Date+'_'+objAcetSerchResult.End_Date+'_'+objAcetSerchResult.ServiceProviderStatus+'_'+objAcetSerchResult.Primary_Diagnosis+'_'+objAcetSerchResult.Procedure_Code+'_'+objAcetSerchResult.Count+'_'+objAcetSerchResult.POS+'_'+objAcetSerchResult.ServiceDescDetail;
                    jsonString.replace('null',''); 
                    jsonString = EncodingUtil.urlEncode(jsonString, 'UTF-8');                   
                    objAcetSerchResult.jsonString = jsonString;
                    outPatientAuthorizedList.add(objAcetSerchResult);
                }
                else if(objAcetSerchResult.Case_Type_Desc == 'Outpatient Facility' && objAcetSerchResult!=null){
                  //  String strProcCode = objAcetSerchResult.Procedure_Code.replace('&', '%26'); 
              //@Rama : Changing the value from "objAcetSerchResult.ServiceProviderStatus" to "objAcetSerchResult.ServiceProvider"
                    string jsonString = objAcetSerchResult.Authorization_Number+'_'+objAcetSerchResult.Case_Status+'_'+objAcetSerchResult.Pre_Determination+'_'+objAcetSerchResult.ServiceProvider+'_'+objAcetSerchResult.Primary_Diagnosis+'_'+objAcetSerchResult.Procedure_Code+'_'+objAcetSerchResult.POS+'_'+objAcetSerchResult.ServiceDescDetail;
                    jsonString.replace('null','');  
                    jsonString = EncodingUtil.urlEncode(jsonString, 'UTF-8');                  
                    objAcetSerchResult.jsonString = jsonString;
                    facilityAuthorizedList.add(objAcetSerchResult);
                }
                else{
                    continue;
                }
            }
            system.debug(LoggingLevel.INFO, 'inPatientAuthorizedList: ' + inPatientAuthorizedList);
            if(inPatientAuthorizedList.size()==0) {
                set<string> msg_set = setErrorMsgInDataTable('VAUTH404',null);
                 if(msg_set != null){
                  for (string setElement : msg_set) {
                      inpatientErrorMsg = setElement;
                       }              
                     msg_set.clear();
                   }
            }
            system.debug(LoggingLevel.INFO, 'outPatientAuthorizedList: ' + outPatientAuthorizedList);
            if(outPatientAuthorizedList.size()==0) {
                set<string> msg_set = setErrorMsgInDataTable('VAUTH404',null);
                 if(msg_set != null){
                  for (string setElement : msg_set) {
                      outpatientErrorMsg = setElement;
                       }              
                     msg_set.clear();
                   }
            }
            system.debug(LoggingLevel.INFO, 'facilityAuthorizedList: ' + facilityAuthorizedList);
            if(facilityAuthorizedList.size()==0) {
                set<string> msg_set = setErrorMsgInDataTable('VAUTH404',null);
                 if(msg_set != null){
                  for (string setElement : msg_set) {
                      outpatientFacilityErrorMsg = setElement;
                       }              
                     msg_set.clear();
                   }
            }
        }else {
            if(findAuthServiceCalloutResult.statusCode==400){
                  errorFlagForNoRecords = false;
                  errorFlagForNoRecordsOnPage = true;
                  setErrorMsg('GN'+'400B',null);
                }else if(findAuthServiceCalloutResult.statusCode==404){
                 errorFlagForNoRecords = false;
                 errorFlagForNoRecordsOnPage = false;
                 set<string> msg_set = setErrorMsgInDataTable('VAUTH404',null);
                 if(msg_set != null){
                  for (string setElement : msg_set) {
                      inpatientErrorMsg = outpatientFacilityErrorMsg = outpatientErrorMsg  = setElement;
                       }              
                     msg_set.clear();
                   }
                }
                else{
                  errorFlagForNoRecords = false;
                  errorFlagForNoRecordsOnPage = true;
                  setErrorMsg('GN'+findAuthServiceCalloutResult.statusCode,null);
                }
          }
        } catch(Exception e){
         setErrorMsg('MGD997',e);
        }
      }
    //This methods filters results based on case type and return as a list 
    public List<ACETAuthorizationSearchResult> getAuthorizationsByType(String Type_Desc){
        List<ACETAuthorizationSearchResult> returnAuthorizations = new List<ACETAuthorizationSearchResult>();
        for(ACETAuthorizationSearchResult objAcetSerchResult :this.Authorizations){
            if(objAcetSerchResult.Case_Type_Desc == Type_Desc){
               
              returnAuthorizations.add(objAcetSerchResult);
            }
        }
        return returnAuthorizations;
       }
    private void getloggedinProfileName(){ 
        String userRole = ACETUtility.GetUserRoleName();
        allowedUser = false;
        List<Call_Topic_Access__c> accesses = (List<Call_Topic_Access__c>)ACETQueryUtil.query(null,'Call_Topic_Access__c', null, null);
        for(Call_Topic_Access__c acc : accesses){
            if(acc.Call_Topic__c == 'Create Authorization'){
                String roles = acc.Limit_To_Roles__c;
                system.debug('$$$$roles'+roles);
                if(roles.contains(';'))
                {
                    system.debug('$$$$multipleroles'+roles);
                    List<String> rolesList = new List<String>(roles.split(';'));
                    for(String role : rolesList){
                        if(role == userRole){
                            allowedUser = true;
                        }
                        system.debug('$$$$$$$'+ role + ' roles ' + userRole);
                    }
                }
                else if(String.isNotBlank(roles) && roles.containsNone(';') && roles == userRole)
                {
                    allowedUser = true;
                }
                               
            }
            system.debug('$$$$$$$'+ acc.Call_Topic__c + 'roles ' + acc.Limit_To_Roles__c);

            
        }
        if(ACETUtility.GetUserProfileName() == 'Research User' && allowedUser == true){
            isResearchUser = true;
            allowedUser = false;
        } else if(ACETUtility.GetUserProfileName() == 'Research User' && allowedUser == false){
            isResearchUser = false;
            allowedUser = false;
        }
        else if(ACETUtility.GetUserProfileName() != 'Research User') {
            isResearchUser = false;
        }
    }
    public void ApplyFilter() {
        inPatientAuthorizedList.clear();            
        facilityAuthorizedList.clear();
        outPatientAuthorizedList.clear();
        
        system.debug(LoggingLevel.INFO, 'strAuthorizationNumber: ' + strAuthorizationNumber + ', AuthorizationType: ' + AuthorizationType + ', strStatus: ' + strStatus);
        system.debug(LoggingLevel.INFO, 'Start Date: ' + StartDate.tst_Date_Field__c + ', End Date: ' + EndDate.tst_Date_Field__c);
        
        List<ACETAuthorizationSearchResult> tempList = new List<ACETAuthorizationSearchResult>();
        list<string> lstStartDate = StartDate.tst_Date_Field__c != null ? string.valueOf(StartDate.tst_Date_Field__c).split(' '):null;
        list<string> lstEndDate = EndDate.tst_Date_Field__c != null ? string.valueOf(EndDate.tst_Date_Field__c).split(' '):null;
        list<string> LstStartDates = new list<string>();
        list<string> LstEndDates  = new list<string>();
        if(lstStartDate != null && lstStartDate.size() > 0) {
            LstStartDates = lstStartDate[0].split('-');
        }
    
        if( lstEndDate != null && lstEndDate.size() > 0) {
            LstEndDates = lstEndDate[0].split('-');
        }
    
        Integer mm;
        Integer mm1;
        if(LstStartDates!=null && LstStartDates.size()>0) {
            mm  = LstStartDates!=null?Integer.valueOf(LstStartDates[1]):0;
        }
        if(LstEndDates !=null && LstEndDates.size()>0) {
            mm1 = LstEndDates !=null?Integer.valueOf(LstEndDates[1]):0;
        }
    
        string strStartDateFormat;
        if(LstStartDates!=null && LstStartDates.size()>0) {
            strStartDateFormat = LstStartDates!=null ?mm+'/'+LstStartDates[2]+'/'+LstStartDates[0]:'';
        }
        string strEndDateFormat;
    
        strEndDateFormat = LstEndDates!=null && LstEndDates.size() > 0 ? mm1 + '/' + LstEndDates[2] + '/' + LstEndDates[0]:'';
    
        if(AuthorizationType == '----None----') {
            inPatientAuthorizedList = getAuthorizationsByType('Inpatient');
            
            facilityAuthorizedList = getAuthorizationsByType('Outpatient Facility');
            outPatientAuthorizedList = getAuthorizationsByType('Outpatient');
                          
        }
        else if (AuthorizationType == 'Inpatient') {
            inPatientAuthorizedList = getAuthorizationsByType('Inpatient'); 
       }
        else if (AuthorizationType == 'Outpatient Facility') {
            facilityAuthorizedList = getAuthorizationsByType('Outpatient Facility');
            
        }
        else {
            outPatientAuthorizedList = getAuthorizationsByType('Outpatient');
            
        }
        system.debug(LoggingLevel.INFO, 'ApplyFilters. inPatientAuthorizedList: ' + inPatientAuthorizedList);
        system.debug(LoggingLevel.INFO, 'ApplyFilters. outPatientAuthorizedList: ' + outPatientAuthorizedList);
        system.debug(LoggingLevel.INFO, 'ApplyFilters. facilityAuthorizedList: ' + facilityAuthorizedList);
        if (strAuthorizationNumber!='') {
            if(inPatientAuthorizedList.size() > 0){
                for(ACETAuthorizationSearchResult objAcetSerchResult : inPatientAuthorizedList){       
                    if(strAuthorizationNumber==objAcetSerchResult.Authorization_Number){
                        tempList.add(objAcetSerchResult);
                    }
                }
                inPatientAuthorizedList.clear();
                inPatientAuthorizedList.addAll(tempList);  
            }   
        
            if(facilityAuthorizedList.size() > 0){
                tempList.clear();
                for(ACETAuthorizationSearchResult objAcetSerchResult : facilityAuthorizedList ){       
                    if(strAuthorizationNumber==objAcetSerchResult.Authorization_Number){
                        tempList.add(objAcetSerchResult);
                    }
                }
                facilityAuthorizedList.clear();
                facilityAuthorizedList.addAll(tempList);
            }          
            
            if(outPatientAuthorizedList.size() > 0){
                tempList.clear();
                for(ACETAuthorizationSearchResult objAcetSerchResult :outPatientAuthorizedList ){       
                    if(strAuthorizationNumber==objAcetSerchResult.Authorization_Number){
                        tempList.add(objAcetSerchResult);
                    }
                }
                outPatientAuthorizedList.clear();
                outPatientAuthorizedList.addAll(tempList);  
            }          
        }
        
        if (strStatus !='----None----'){
            if(inPatientAuthorizedList.size() > 0){
                tempList.clear();
                for(ACETAuthorizationSearchResult objAcetSerchResult : inPatientAuthorizedList){ 
                   system.debug(LoggingLevel.INFO, 'IP objAcetSerchResult: ' + objAcetSerchResult);      
                    if(objAcetSerchResult.Case_Status.startsWith(strStatus)){
                        tempList.add(objAcetSerchResult);
                    }
                }
                inPatientAuthorizedList.clear();
                inPatientAuthorizedList.addAll(tempList);  
            }
            
            if(facilityAuthorizedList.size() > 0){
                tempList.clear();
                for(ACETAuthorizationSearchResult objAcetSerchResult : facilityAuthorizedList ){
                    system.debug(LoggingLevel.INFO, 'FC objAcetSerchResult: ' + objAcetSerchResult);             
                    if(objAcetSerchResult.Case_Status.startsWith(strStatus)){
                        tempList.add(objAcetSerchResult);
                    }
                }
                facilityAuthorizedList.clear();
                facilityAuthorizedList.addAll(tempList);
            }   
            
            if(outPatientAuthorizedList.size() > 0){
                tempList.clear();
                for(ACETAuthorizationSearchResult objAcetSerchResult :outPatientAuthorizedList ){
                    system.debug(LoggingLevel.INFO, 'OP objAcetSerchResult: ' + objAcetSerchResult);             
                    if(objAcetSerchResult.Case_Status.startsWith(strStatus)){
                        tempList.add(objAcetSerchResult);
                    }
                }
                outPatientAuthorizedList.clear();
                outPatientAuthorizedList.addAll(tempList);  
            }          
        }     
        
        //Only StartDate
        if (strStartDateFormat !=null && strEndDateFormat =='') {
            if(inPatientAuthorizedList.size() > 0){
                tempList.clear();
                for(ACETAuthorizationSearchResult objAcetSerchResult : inPatientAuthorizedList){       
                    if(StartDate.tst_Date_Field__c <=returnDateFormat(objAcetSerchResult.Expected_Admit_Date) || 
                        StartDate.tst_Date_Field__c <=returnDateFormat(objAcetSerchResult.Actual_Admit_Date)){
                        tempList.add(objAcetSerchResult);
                    }
                }
                inPatientAuthorizedList.clear();
                inPatientAuthorizedList.addAll(tempList);  
            }
            
            if(facilityAuthorizedList.size() > 0){
                tempList.clear();
                for(ACETAuthorizationSearchResult objAcetSerchResult : facilityAuthorizedList ){       
                    if(StartDate.tst_Date_Field__c <=returnDateFormat(objAcetSerchResult.Expected_Start_Date) || 
                        StartDate.tst_Date_Field__c <=returnDateFormat(objAcetSerchResult.Actual_Start_Date) ){
                        tempList.add(objAcetSerchResult);
                    }
                }
                facilityAuthorizedList.clear();
                facilityAuthorizedList.addAll(tempList);
            }
            
            if(outPatientAuthorizedList.size() > 0){
                tempList.clear();
                for(ACETAuthorizationSearchResult objAcetSerchResult :outPatientAuthorizedList ){       
                    if(StartDate.tst_Date_Field__c <=returnDateFormat(objAcetSerchResult.Start_Date)){
                        tempList.add(objAcetSerchResult);
                    }
                }
                outPatientAuthorizedList.clear();
                outPatientAuthorizedList.addAll(tempList);  
            }          
        }
    
        //Only EndDate          
        if (strEndDateFormat !='' && strStartDateFormat == null){
            if(inPatientAuthorizedList.size() > 0){
                tempList.clear();
                for(ACETAuthorizationSearchResult objAcetSerchResult : inPatientAuthorizedList){       
                    if(EndDate.tst_Date_Field__c >=returnDateFormat(objAcetSerchResult.Expected_Dscharg_Date)|| 
                        EndDate.tst_Date_Field__c >=returnDateFormat(objAcetSerchResult.Actual_Dscharg_Date)){
                        tempList.add(objAcetSerchResult);
                        system.debug('---DATES-END DATE-EndDate.tst_Date_Field__c--:'+EndDate.tst_Date_Field__c+'---objAcetSerchResult.Expected_Dscharg_Date--:'+returnDateFormat(objAcetSerchResult.Expected_Dscharg_Date));
                    }
                }
                inPatientAuthorizedList.clear();
                inPatientAuthorizedList.addAll(tempList);  
                system.debug('---IN PATIENT LIST--'+inPatientAuthorizedList);
            }
        
            if(facilityAuthorizedList.size() > 0){                
                tempList.clear();
                for(ACETAuthorizationSearchResult objAcetSerchResult : facilityAuthorizedList ){      
                    if(EndDate.tst_Date_Field__c >=returnDateFormat(objAcetSerchResult.Expected_End_Date)|| 
                        EndDate.tst_Date_Field__c >=returnDateFormat(objAcetSerchResult.Actual_End_Date)){
                        tempList.add(objAcetSerchResult);
                    }
                }
                facilityAuthorizedList.clear();
                facilityAuthorizedList.addAll(tempList);
                system.debug('---FACILITY PATIENT LIST--'+facilityAuthorizedList);
            }
        
            if(outPatientAuthorizedList.size() > 0){
                tempList.clear();
                for(ACETAuthorizationSearchResult objAcetSerchResult :outPatientAuthorizedList ){       
                    if(EndDate.tst_Date_Field__c >=returnDateFormat(objAcetSerchResult.End_Date)){
                        tempList.add(objAcetSerchResult);
                    }
                }
                outPatientAuthorizedList.clear();
                outPatientAuthorizedList.addAll(tempList);
                system.debug('---OUT PATIENT LIST--'+outPatientAuthorizedList);  
            }          
        } 
        
        //Both StartDate and EndDate
        if (strStartDateFormat !=null && strEndDateFormat !=''){
            if(inPatientAuthorizedList.size() > 0){
                tempList.clear();
                for(ACETAuthorizationSearchResult objAcetSerchResult : inPatientAuthorizedList){    
                    if((returnDateFormat(objAcetSerchResult.Expected_Admit_Date) >=StartDate.tst_Date_Field__c && 
                        returnDateFormat(objAcetSerchResult.Expected_Admit_Date)<=EndDate.tst_Date_Field__c) || 
                        (returnDateFormat(objAcetSerchResult.Actual_Admit_Date)>=StartDate.tst_Date_Field__c && 
                        returnDateFormat(objAcetSerchResult.Actual_Admit_Date)<=EndDate.tst_Date_Field__c) || 
                        (returnDateFormat(objAcetSerchResult.Expected_Dscharg_Date)>=StartDate.tst_Date_Field__c && 
                        returnDateFormat(objAcetSerchResult.Expected_Dscharg_Date)<=EndDate.tst_Date_Field__c) || 
                        (returnDateFormat(objAcetSerchResult.Actual_Dscharg_Date)>=StartDate.tst_Date_Field__c && 
                        returnDateFormat(objAcetSerchResult.Actual_Dscharg_Date)<=EndDate.tst_Date_Field__c)) {
                        tempList.add(objAcetSerchResult);
                    }
                }
                inPatientAuthorizedList.clear();
                inPatientAuthorizedList.addAll(tempList);  
            }                       
            if(facilityAuthorizedList.size() > 0){
                tempList.clear();
                for(ACETAuthorizationSearchResult objAcetSerchResult : facilityAuthorizedList ){       
                    system.debug('---DATES FACILITY BEFORE IF--EndDate.tst_Date_Field__c--:'+EndDate.tst_Date_Field__c+'---objAcetSerchResult.Expected_Dscharg_Date--:'+returnDateFormat(objAcetSerchResult.Expected_Dscharg_Date));        
                    if((returnDateFormat(objAcetSerchResult.Expected_Start_Date) >=StartDate.tst_Date_Field__c && 
                        returnDateFormat(objAcetSerchResult.Expected_Start_Date)<=EndDate.tst_Date_Field__c) || 
                        (returnDateFormat(objAcetSerchResult.Actual_Start_Date)>=StartDate.tst_Date_Field__c && 
                        returnDateFormat(objAcetSerchResult.Actual_Start_Date)<=EndDate.tst_Date_Field__c) || 
                        (returnDateFormat(objAcetSerchResult.Expected_End_Date)>=StartDate.tst_Date_Field__c && 
                        returnDateFormat(objAcetSerchResult.Expected_End_Date)<=EndDate.tst_Date_Field__c) || 
                        (returnDateFormat(objAcetSerchResult.Actual_End_Date)>=StartDate.tst_Date_Field__c && 
                        returnDateFormat(objAcetSerchResult.Actual_End_Date)<=EndDate.tst_Date_Field__c)) {
                        tempList.add(objAcetSerchResult);
                    }
                }
                facilityAuthorizedList.clear();
                facilityAuthorizedList.addAll(tempList);
            }          
            if(outPatientAuthorizedList.size() > 0){
                tempList.clear();
                for(ACETAuthorizationSearchResult objAcetSerchResult :outPatientAuthorizedList ){       
                    if((returnDateFormat(objAcetSerchResult.Start_Date)>=StartDate.tst_Date_Field__c && 
                        returnDateFormat(objAcetSerchResult.Start_Date)<=EndDate.tst_Date_Field__c) || 
                        (returnDateFormat(objAcetSerchResult.End_Date)>=StartDate.tst_Date_Field__c && 
                        returnDateFormat(objAcetSerchResult.End_Date)<=EndDate.tst_Date_Field__c)){
                        tempList.add(objAcetSerchResult);
                    }
                }
                outPatientAuthorizedList.clear();
                outPatientAuthorizedList.addAll(tempList);
            }          
        }          
    }       
                   
    public void clearFilter() {
        inPatientAuthorizedList.clear();
        outPatientAuthorizedList.clear();
        facilityAuthorizedList.clear(); 
        
        inPatientAuthorizedList = getAuthorizationsByType('Inpatient');
        outPatientAuthorizedList = getAuthorizationsByType('Outpatient');
        facilityAuthorizedList = getAuthorizationsByType('Outpatient Facility');
    }
    public PageReference routeCase(){
        wrapper.caseObj.Topic__c ='View Authorizations';
        wrapper.createCase();            
        PageReference caseDetailsReference = new PageReference('/' + wrapper.CaseObj.Id);
        return caseDetailsReference;
    } 
    public PageReference Save(){
        wrapper.caseObj.Topic__c ='View Authorizations';
        wrapper.createCase();            
        PageReference caseDetailsReference = new PageReference('/' + wrapper.CaseObj.Id);
        return caseDetailsReference;
    }
    public PageReference SaveAndClose(){
        wrapper.caseObj.Topic__c ='View Authorizations';
        wrapper.caseObj.Status='Closed';
        //wrapper.caseObj.AutoDoc__c = AutoDoc;
        wrapper.createCase();            
        PageReference caseDetailsReference = new PageReference('/apex/ACETCallTopicSaveAndClose?caseId=' + wrapper.CaseObj.Id);
        system.debug('wrapper.CaseObj.Id  >>>  '+wrapper.CaseObj.Id);
        return caseDetailsReference;
    }                    
    public static Date returnDateFormat(string strDate) {
        String[] dts = strDate!=null && strDate !='' ? strDate.split('/') : null;
        if(dts!=null && dts.size()>0){
            Date myDate = date.newinstance(Integer.valueOf(dts[2]), Integer.valueOf(dts[0]), Integer.valueOf(dts[1]));
            system.debug('myDate'+myDate);
            return myDate;
        }
        else {
            return null;
        }
    }
    
    public String minTwoDigits(String digit) {
        return (Integer.valueOf(digit) < 10 ? '0' : '') + digit;
    }
           
}