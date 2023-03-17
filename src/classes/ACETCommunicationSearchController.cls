public with sharing class ACETCommunicationSearchController extends ACETErrorHandler{

    public transient ACETDatatableWrapper DTWrapper {get;set;}
    public String DocumentType {get; set;}
    public String parentPEOId {get; set;}
    public String WSDocumentClass {get;set;}
    public String SelectedDocId {get;set;}
    public String selectAddress{get;set;}
    public string Commhistorytitle{get;set;}
    public ACETCallTopicsDataWrapper wrapper {get;set;}
    public List<SelectOption> documentTypeOptions {get; set;}
    public List<Document_Type__mdt> listDocumentType {get; set;}
    public List<Document_Type_Search_By_Field__mdt> listSearchFilter {get; set;}
    public List<Document_Type_Search_Result_Field__mdt  > listSearchResults {get; set;}
    public List<Document_Type_Field_Picklist_Option__mdt> listPicklistOptions {get;set;}
    public List<SelectOption> searchByFieldSelectOptions {get;set;}
    public String listPicklistOptionsJSON {get;set;}
    public Boolean ShowSearchResult{get;set;}
    public Boolean showPopUPAddress{get;set;}
    public Boolean selectAll {get; set;}
    public Boolean showSearchField {get; set;}
    public Boolean chooseAddress{get;set;}//Vishakha
    public Boolean showBulkResend{get;set;}//Vishakha
    public Boolean showSubmitBtnAOF{get;set;}//Vishakha 
    public Boolean showHistory{get;set;}
    public Boolean selectRecord{get;set;} //Akhila
    public Boolean showOriginatorMsg{get;set;}
    public Boolean ProdMIFSpecial{get;set;}    
    public list<ACETCommunicationSearchResult> resWrapper{get;set;}//vishakha
    public list<ACETCommunicationSearchResult> selectedResWrapper{get;set;}//Vishakha
    public list<ACETCommunicationHistoryResult> Commhistory{get;set;}
    public String DynamicParams{get;set;}
    Public string errorMessage {get;set;}
    public personWrapper AddOnFilePersonWrap{get;set;}  
    public String personOrganizationAA{get;set;}
    public String personFirstNameAA{get;set;}
    public String personMiddleNameAA{get;set;}
    public String personLastNameAA{get;set;}
    public String personSuffixAA{get;set;}
    public String personAddOneAA{get;set;}
    public String personAddTwoAA{get;set;}
    public String personCityAA{get;set;}
    public String personStateAA{get;set;}
    public String personZipCodeAA{get;set;}
    public String bookOfBusinessTypeCode{get;set;}
    public string recepientId{get;set;}
    public string recepientType {get;set;}
    public string idQualifier {get;set;}
    
    public string personWrapString{get;set;}
    
    public String DOC_CONTENT_TYPE {get;set;}
    public String IS_DOC_SIZE_MORE_THAN_ONE_MB {get;set;}
    
    public ACETHighlightsPanelAdditionalInfo AdditionalInfoData{get;set;}
    public String Flow {get;set;}
    public Boolean IsMemberFocus {get;set;}
    public Boolean IsGroupFocus {get;set;}
    
    public List<ACETFindDocWebservice.documentKey> findDocKeys{get;set;}
    
    public Interaction__c Interaction{get;set;} 
    public map<String,ACETCommunicationSearchResult> mapFullComSearResult = new map<string,ACETCommunicationSearchResult>();
    
    public string Selecteddocname{get;set;}
    public String documentTypeName{get;set;}
    
    public void init(){
        parentPEOId = ApexPages.currentPage().getParameters().get('parentPEOId');
    string err = String.join(new List<String>(setErrorMsgInDataTable('CM404',null)), '');
    system.debug('for 500 ---> '+err);
    
       wrapper = new ACETCallTopicsDataWrapper();
        wrapper.init();
        wrapper.CaseObj.Topic__c = 'Communications';//Vishakha
        String strSurrogateKey = apexpages.currentpage().getparameters().get('SRK');
        system.debug('SRK is '+strSurrogateKey);
        wrapper.SurrogateKey = strSurrogateKey;
        
        //Logic moved from Constructure to this page action
          List<Document_Type_Flow__mdt> dtfs = [select Document_Type__r.Document_Type__c, WS_Backup_Address_Type__c, WS_Primary_Address_Type__c, Is_Group_Focus__c, Label from Document_Type_Flow__mdt where Flow__c = :flow and Is_Member_Focus__c = :isMemberFocus];
        
        Set<String> documentTypeSet = new Set<String>();
        for(Document_Type_Flow__mdt dtf : dtfs){
            
            //currenlty isGroupInFocus flag is only used under producer flow
            if(Flow == 'Producer' && dtf.Is_Group_Focus__c != IsGroupFocus) continue;
            if(Flow == 'Producer' && IsMemberFocus && String.isEmpty(AdditionalInfoData.GroupN) && (dtf.Label.contains('Oxford Group Handbook')||dtf.Label.contains('Group Letter'))){
                
            }
            else{
                documentTypeSet.add(dtf.Document_Type__r.Document_Type__c);
            }
            
        }
 
        listDocumentType = [SELECT Id,Is_Subscriber__c,DeveloperName, Order__c,Label, Document_Type__c, WS_Field_Name__c FROM Document_Type__mdt order By Order__c asc];
        
        documentTypeOptions.add(new SelectOption('','--None--'));
        for(Document_Type__mdt mdtDocType :listDocumentType){
            if(documentTypeSet.contains(mdtDocType.Document_Type__c)){
            if(mdtDocType.Is_Subscriber__c){
         

            if(wrapper.AdditionalInfo.Relationship =='self'){
                documentTypeOptions.add(new SelectOption(mdtDocType.DeveloperName,mdtDocType.Document_Type__c ));  
                }
                }else{
                   documentTypeOptions.add(new SelectOption(mdtDocType.DeveloperName,mdtDocType.Document_Type__c ));  
             
                }
            }          
        }
        
        listPicklistOptions = [SELECT Id, DeveloperName, Document_Type_Search_By_Field__r.DeveloperName, Option_Name__c, Order__c FROM Document_Type_Field_Picklist_Option__mdt order By Order__c asc];
        for (Document_Type_Field_Picklist_Option__mdt picklistOption : listPicklistOptions) {
            searchByFieldSelectOptions.add(new SelectOption(picklistOption.Option_Name__c,picklistOption.Option_Name__c));
        }
        listPicklistOptionsJSON = JSON.serialize(listPicklistOptions); 
    }
    
    //Constructor Class
    public ACETCommunicationSearchController(){
        
        ShowSearchResult=false;
        showSearchField = false;
        showPopUPAddress = false;
        showBulkResend = false;
        selectAll  = false;
        selectRecord = false;
        showOriginatorMsg = false;//Vishakha
        showHistory = false;
        selectAddress = 'AddressOnFile';
        
        DOC_CONTENT_TYPE = 'DocumentContentType';
        IS_DOC_SIZE_MORE_THAN_ONE_MB = 'IsDocSizeMoreThanOneMB';
        
        
        AddOnFilePersonWrap = new PersonWrapper();
        personWrapString = '';
        
        documentTypeOptions = new List<SelectOption>();
        searchByFieldSelectOptions = new List<SelectOption>();
        listSearchFilter = new List<Document_Type_Search_By_Field__mdt>();
        
        Interaction = ACETMemberQueryUtil.queryInteraction(ApexPages.currentPage().getParameters().get('InteractionId'));
        
        string addInfo = ApexPages.currentPage().getParameters().get('additionalInfo');
        
        if(!String.isEmpty(addInfo)){
            AdditionalInfoData = (ACETHighlightsPanelAdditionalInfo)JSON.deserialize(addInfo, ACETHighlightsPanelAdditionalInfo.class);
        }
        bookOfBusinessTypeCode = ApexPages.currentPage().getParameters().get('bookOfBusinessTypeCode');
        if(bookOfBusinessTypeCode == null && AdditionalInfoData!=null){
            bookOfBusinessTypeCode =AdditionalInfoData.bookOfBusinessTypeCode;
        } 
        system.debug('AdditionalInfoData---->'+AdditionalInfoData);
        try {
        
        Flow = getFlowName(); 
        system.debug(Flow); 
        }
        
        catch (System.NullPointerException e) {
        
        }
                IsMemberFocus = (AdditionalInfoData !=null && !String.isEmpty(AdditionalInfoData.MemberID)); 
        
        //IsGroupFocus flag is currently only valid under producer flow, under other flows, this flag or the settings could be set as unexpected value.   
        //Due to lack of consistent way to detect if it is groupInFocus by checking groupId in additionalInfo or url params under all flows
        IsGroupFocus = false;
        if(Flow == 'Producer' && !IsMemberFocus){
            if(!String.isEmpty(ApexPages.currentPage().getParameters().get('groupID'))){
                IsGroupFocus = true;        
            }
        }
        
        system.debug('Is Member Infocus: ' + IsMemberFocus);
        system.debug('Is Group Infocus: ' + IsGroupFocus);
        
        List<Document_Type_Flow__mdt> dtfs = [select Document_Type__r.Document_Type__c, WS_Backup_Address_Type__c, WS_Primary_Address_Type__c, Is_Group_Focus__c, Label from Document_Type_Flow__mdt where Flow__c = :flow and Is_Member_Focus__c = :isMemberFocus];
        
        Set<String> documentTypeSet = new Set<String>();
        for(Document_Type_Flow__mdt dtf : dtfs){
            //currenlty isGroupInFocus flag is only used under producer flow
            if(Flow == 'Producer' && dtf.Is_Group_Focus__c != IsGroupFocus) continue;
            if(Flow == 'Producer' && IsMemberFocus && String.isEmpty(AdditionalInfoData.GroupN) && (dtf.Label.contains('Oxford Group Handbook')||dtf.Label.contains('Group Letter'))){
                
            }
            else{
                documentTypeSet.add(dtf.Document_Type__r.Document_Type__c);
            }
        }
    }
    
    public void search(){
        system.debug('DynamicParams is '+DynamicParams);
       system.debug('AdditionalInfoData.EndDate '+AdditionalInfoData.EndDate);
        ShowSearchResult=false;
        resWrapper = new list<ACETCommunicationSearchResult>();//Vishakha 
        Commhistory = null;
        List<String> keyparams = (List<String>)JSON.deserialize(DynamicParams, List<String>.class);
        system.debug('keyparams is '+keyparams[0]);
        ACETFindDocWebservice.documentKey key;
        findDocKeys = new List<ACETFindDocWebservice.documentKey>();
        system.debug(keyparams);
        for(String par: keyparams){
            String [] str = par.split(',');
         system.debug('str[0] '+str);   
            system.debug('str size '+str.size());
            key = new ACETFindDocWebservice.documentKey();
            key.value = str[0];
            
            if(!String.isEmpty(key.value)){
                key.value = key.value.replace('{comma}',',');
            }
            
            key.name = str[1];
            System.debug('key.name' +key.name);
            if(str.size() > 2){
                key.dataTypeIndicator = str[2];
                System.debug('key.dataTypeIndicator if condition' +key.dataTypeIndicator);
            }
            else{
                key.dataTypeIndicator = 'string';
            }
            if(str.size() > 3){
                key.operator = str[3];
                System.debug('key.operator if condition' +key.operator);
            }
            else{
                key.operator = '=';
            }
            
            
            
            if(!String.isEmpty(key.value) && (key.dataTypeIndicator.toLowerCase() == 'date' || key.dataTypeIndicator.toLowerCase() == 'datetime')){
                key.value = ACETWebserviceHelper.formatToYYYYMMDD(key.value.split('T')[0]);
            }
            
            findDocKeys.add(key);
            system.debug('findDocKeys.add is '+findDocKeys);
            
        }
        system.debug(findDocKeys);
        //add hidden search field, e.g template name for oxford handbook member and oxford handbook group
        for(Document_Type_Search_By_Field__mdt sf : listSearchFilter){
            if(sf.Display_Order__c < 0 && sf.Required__c == true){
                key = new ACETFindDocWebservice.documentKey();
                key.name = sf.Document_Type_Field__r.WS_Field_Name__c;
                if(sf.DeveloperName == Label.ACETDocumentPaymentCycleStartDatePRA)
                {
                    key.value = '2017-12-1';
                }
                else if(sf.DeveloperName == Label.ACETDocumentPaymentCycleEndDatePRA){
                    Date dt = Date.today();
                    key.value = dt.year()+'-'+dt.month()+'-'+dt.day();
                }
                key.dataTypeIndicator = sf.Document_Type_Field__r.Data_Type__c;
                if(sf.Document_Type_Field__r.Operator__c != null){
                    key.operator = sf.Document_Type_Field__r.Operator__c;
                }
                else{
                key.operator = '=';
                }
                findDocKeys.add(key);   
            }
        }
        System.debug('documentTypeName' +documentTypeName);
        //add template doc keys for handbook doc types
        if(documentTypeName=='Oxford Group Handbook'){
            system.debug('oxford group handbook selected');
            key = new ACETFindDocWebservice.documentKey();
            key.value = 'GROUP HANDBOOK';  // Updated by Abhinav for DOC360 migration
            key.name = 'u_tmplt_nm';
            key.dataTypeIndicator = 'String';
            key.operator = '=';
            findDocKeys.add(key);
        }
        else if(documentTypeName=='Oxford Member Handbook'){
            system.debug('oxford member handbook selected');
            key = new ACETFindDocWebservice.documentKey();
            key.value = 'MEMBER HANDBOOK';  // Updated by Abhinav for DOC360 migration
            key.name = 'u_tmplt_nm';
            key.dataTypeIndicator = 'String';
            key.operator = '=';
            findDocKeys.add(key);
        }else if(documentTypeName=='Member Handbook'){
            system.debug('Member handbook selected');
            key = new ACETFindDocWebservice.documentKey();
            key.value = 'MEMBER HANDBOOK';  // Updated by Abhinav for DOC360 migration
            key.name = 'u_tmplt_nm';
            key.dataTypeIndicator = 'String';
            key.operator = '=';
            findDocKeys.add(key);
        }else if(documentTypeName=='Group Handbook'){
            system.debug('Group handbook selected');
            key = new ACETFindDocWebservice.documentKey();
            key.value = 'GROUP HANDBOOK';  // Updated by Abhinav for DOC360 migration
            key.name = 'u_tmplt_nm';
            key.dataTypeIndicator = 'String';
            key.operator = '=';
            findDocKeys.add(key);
        }
        system.debug('findDocKeys is '+findDocKeys);
        //change operator to = ANY for WS MultiValue Field
        for(Document_Type_Search_By_Field__mdt sf : listSearchFilter){
            if(sf.WS_MultiValue_Field__c == true){
                for(ACETFindDocWebservice.documentKey docKey : findDocKeys){
                    if(sf.Document_Type_Field__r.WS_Field_Name__c == docKey.name){
                        docKey.operator += ' ANY';
                    }   
                }   
            }
        }
        
        
        system.debug('DTWrapper is '+DTWrapper);
        system.debug('DocumentType' +DocumentType);
        system.debug('documentTypeName' +documentTypeName);
        WSDocumentClass = '';
        if(!String.isEmpty(DocumentType)){
            List<Document_Type__mdt> docTypes = [SELECT Id,Order__c,Label, Document_Type__c, WS_Field_Name__c FROM Document_Type__mdt where Document_Type__c = :documentTypeName];
            if(docTypes.size() > 0){
                WSDocumentClass = docTypes[0].WS_Field_Name__c; 
            }
        }
        system.debug('findDocKeys before is '+findDocKeys);
        system.debug('WSDocumentClass' +WSDocumentClass);
        ACETFindDocWebservice FindDocService = new ACETFindDocWebservice();
        FindDocService.init(WSDocumentClass,findDocKeys); 
        System.debug(JSON.serialize(FindDocService));
         integer recordsCount =  integer.valueOf( ACETDataTableController.queryPaginatedData('ACETFindDocWebservice',JSON.serialize(FindDocService).replace('\'', '&#x27;'),1,1,1 ).totalCount);
         Integer statuscode =  integer.valueOf( ACETDataTableController.queryPaginatedData('ACETFindDocWebservice',JSON.serialize(FindDocService).replace('\'', '&#x27;'),1,1,1 ).statusCode);
          system.debug('statuscode -->'+statuscode );
          if(statuscode != 200){
          if(statuscode == 400 || statuscode == 404){
          set<string> msg_set = setErrorMsgInDataTable('CM400',null);
          if(msg_set != null){
           for (string setElement : msg_set) {
               errorMessage  = setElement;

                }              
              msg_set.clear();
            }
           
           }           
            else if(statuscode == 500){
        set<string> msg_set = setErrorMsgInDataTable('GN500',null);
          if(msg_set != null){
           for (string setElement : msg_set) {
               errorMessage  = setElement;

                }              
              msg_set.clear();
            }
           
            }
           }
           system.debug('errorMessage  --->'+errorMessage  );
                          
        DTWrapper = new ACETDatatableWrapper('ACETFindDocWebservice', FindDocService);
        DTWrapper.PageSize = 25;
        DTWrapper.IsSortEnabled = true;
        DTWrapper.PagingType = 'simple';
        DTWrapper.datatablename =(recordsCount >8 )?'ACETCommunicationSearchtable':'';
        DTWrapper.errorMessage = errorMessage;
        List<Document_Type_Search_Result_Field__mdt> resultFields = [select DeveloperName,Document_Type_Field__r.WS_Field_Name__c,Document_Type_Field__r.Field_Name__c, Display_Order__c from Document_Type_Search_Result_Field__mdt where Document_Type__r.Document_Type__c = :documentTypeName order by Display_Order__c];           
        
        
        system.debug('resultFields---->'+resultFields);
        for(Document_Type_Search_Result_Field__mdt rf : resultFields){
            if(rf.Document_Type_Field__r.Field_Name__c == 'Document ID'){
                DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn(rf.Document_Type_Field__r.Field_Name__c, 'DocumentId'));  
            }else{
                if(!String.isEmpty(rf.Document_Type_Field__r.Field_Name__c)){
                    DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn(rf.Document_Type_Field__r.Field_Name__c, rf.Document_Type_Field__r.WS_Field_Name__c));
                }
            }               
        }        
        DTWrapper.InitOnDocumentReady = false;
        
        
        if(documentType != null){
            ShowSearchResult=true;
            system.debug('documentTypeName is '+documentTypeName);
            listSearchResults = [SELECT Id,DeveloperName,label, Document_Type__r.Document_Type__c, Document_Type_Field__r.Label,Display_Order__c FROM Document_Type_Search_Result_Field__mdt WHERE Document_Type__r.Document_Type__c =:documentTypeName Order By Display_Order__c asc ];            
            
        }
        
    }
    
    public PageReference clear(){
        documentType = '';
        showHistory = false;
        Commhistory = null;
        ShowSearchResult = false;
        if(resWrapper != null){
            resWrapper.clear();
        }
        
        ApexPages.getMessages().clear();
      if(documentTypeName == 'Renewal Letter'){
            Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.INFO,'Resend functionality is not available for Renewal Letters. If additional information is needed, refer to the appropriate SOP.'));
        }
      else if(documentTypeName == 'Renewal Package'){
          Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.INFO,'Resend functionality is not available for Renewal Packages. If additional information is needed, refer to the appropriate SOP.'));
      }
      else if(documentTypeName == 'Summary Plan Description'){
          Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.INFO,'Resend functionality is not available for Summary Plan Descriptions. If additional information is needed, refer to the appropriate SOP.'));
      }
        return null;
    }
    
    public Pagereference resend(){
        showPopUPAddress = true;
        chooseAddress = true;
        selectAddress = 'AddressOnFile';
        personFirstNameAA = AddOnFilePersonWrap.personFirstName;
        personMiddleNameAA = AddOnFilePersonWrap.personMiddleName;
        personLastNameAA = AddOnFilePersonWrap.personLastName;
        personSuffixAA = AddOnFilePersonWrap.personSuffix;
        personAddOneAA = AddOnFilePersonWrap.personAddOne;
        personAddTwoAA = AddOnFilePersonWrap.personAddTwo;
        personCityAA = AddOnFilePersonWrap.personCity;
        personStateAA = AddOnFilePersonWrap.personState;
        personZipCodeAA = AddOnFilePersonWrap.personZipCode;
        personOrganizationAA = AddOnFilePersonWrap.personOrganization;
        
        SelectedDocId = ApexPages.currentPage().getParameters().get('docId'); 
        return null;
    }
    
    
    
    public Void getCommuicationHistoryResults(){
        String docId = ApexPages.currentPage().getParameters().get('docId');   
        
        ACETFinfFulfillmentHistoryWebservice FFH = new ACETFinfFulfillmentHistoryWebservice();
        ACETWSCalloutResult CalloutResult = FFH.FindFulfillmentHistoryWS(docId);
        
        if (CalloutResult.Success){
            Commhistory = (list<ACETCommunicationHistoryResult>)CalloutResult.Response;
            system.debug('Commhistory is '+Commhistory);
            if(Commhistory == null || Commhistory.size()==0){
                Commhistorytitle = CalloutResult.Message;
            }
        }
        else{
            Apexpages.addMessage(new ApexPages.message(CalloutResult.MessageSeverity,CalloutResult.Message));
        }
        showHistory = true;
        
    }

    public void suffixMessage(){
        Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.INFO,'Searching IRS 1095s requires removing the 00 suffix from 11 digit Polaris Subscriber IDs.'));
    }
    
    public void resendSelectedDocs(){        
        showPopUPAddress = false;
        chooseAddress = false;
        
        ACETDocRedeliveryWebservice ACETDCWS = new ACETDocRedeliveryWebservice();
        List<ACETDocRedeliveryRequest> docRedeliveryReqList = new List<ACETDocRedeliveryRequest>();        
        list<String> docIds = ApexPages.currentPage().getParameters().get('docIds').split(',');
        system.debug(docIds);
        
        for(Integer i=0 ; i<docIds.size();i++){
            String redeliveryId = 'ACET-' + (system.now().getTime()+i);
            ACETDocRedeliveryRequest docRedeliveryReq = new ACETDocRedeliveryRequest();
            docRedeliveryReq.redeliveryID = redeliveryId;
            docRedeliveryReq.recepientId  = recepientId;
            docRedeliveryReq.idQualifier  = idQualifier;
            docRedeliveryReq.recepientType= recepientType;
            docRedeliveryReq.docClass     = WSDocumentClass;
            docRedeliveryReq.docId        = docIds[i];
            docRedeliveryReq.bookOfBusinessTypeCode = bookOfBusinessTypeCode;
            if(selectAddress.contains('AddressOnFile')){
                docRedeliveryReq.perAdd1 = AddOnFilePersonWrap.personAddOne;
                docRedeliveryReq.perAdd2 = AddOnFilePersonWrap.personAddTwo;
                docRedeliveryReq.perCity = AddOnFilePersonWrap.personCity;
                docRedeliveryReq.perState= AddOnFilePersonWrap.personState;
            	docRedeliveryReq.perZip  = AddOnFilePersonWrap.personZipCode;
                docRedeliveryReq.fName = firstnameHelper(AddOnFilePersonWrap.personFirstName, AddOnFilePersonWrap.personOrganization);
                docRedeliveryReq.lName = lastnameHelper(AddOnFilePersonWrap.personLastName);
                //Modified by Team-Styx Hasara on July 02 2021 For Adding '.' after 'Jr' or 'Sr'
                docRedeliveryReq.suffix  = checkSuffix(AddOnFilePersonWrap.personSuffix);
                //Modified by Team-Styx Hasara on July 02 2021 For personMiddleName null check
                docRedeliveryReq.mName = checkMiddlename(AddOnFilePersonWrap.personMiddleName);
            }
            else if(selectAddress.contains('AlternateAddress')){
                docRedeliveryReq.perAdd1 = personAddOneAA;
                docRedeliveryReq.perAdd2 = personAddTwoAA;
                docRedeliveryReq.perCity = personCityAA;
                docRedeliveryReq.perState= personStateAA;
                docRedeliveryReq.perZip  = personZipCodeAA;
                docRedeliveryReq.fName = firstnameHelper(personFirstNameAA, personOrganizationAA);
                docRedeliveryReq.lName = lastnameHelper(personLastNameAA);
                //Modified by Team-Styx Hasara on July 02 2021 For Adding '.' after 'Jr' or 'Sr'
                docRedeliveryReq.suffix = checkSuffix(personSuffixAA);  
                //Modified by Team-Styx Hasara on July 02 2021 For personMiddleName null check
                docRedeliveryReq.mName = checkMiddlename(personMiddleNameAA);
            }
            docRedeliveryReqList.add(docRedeliveryReq);
        }
        list<ACETWSCalloutResult> docRedeliveryCalloutResultList  = ACETDCWS.docRedeliveryMultipleWS(docRedeliveryReqList);
        processResendResponse(docIds, docRedeliveryCalloutResultList);
    }
    public static string firstnameHelper(String firstName, String orgName){
        return String.IsBlank(firstName)?orgName:firstName;
    }
    public static string lastnameHelper(String lastName){
        return String.IsBlank(lastName)?'.':lastName;
    }
    public void processResendResponse(list<String> docIds, list<ACETWSCalloutResult> docRedeliveryCalloutResultList){
        integer i=0;
        for(ACETWSCalloutResult docRedeliveryCalloutResult: docRedeliveryCalloutResultList){
            if(docRedeliveryCalloutResult.success){ 
                ACETCommunicationSearchResult selComResult = (ACETCommunicationSearchResult)docRedeliveryCalloutResult.Response;
                String message = 'Document ' + docIds[i] + ' ' + selComResult.Resend_Status + ' ' + selComResult.Resend_Date_Time;
                Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.CONFIRM, 'Resend Submitted', message));
            }else{
                Apexpages.addMessage(new ApexPages.message(docRedeliveryCalloutResult.MessageSeverity, docRedeliveryCalloutResult.Message));    
            }                        
        }
    }
    public static string checkSuffix(String suffix){
        String suffixValue;
        switch on suffix{
            when 'Jr', 'Sr'{
                suffixValue  = suffix + '.';
            }
            when null{
                suffixValue = '';
            }
            when else{
                suffixValue = suffix;
            }
        }
        return suffixValue;
    }

    public static string checkMiddlename(String mName){
        String mNameValue;
        switch on mName{
            when null{
                mNameValue =  '' ;
            }
            when else{
                 mNameValue = (mName.length() > 1)?mName.substring(0,1):mName;
            }
        }
        return mNameValue;
    }
    
    public void updateSearchField(){
        
         ApexPages.getMessages().clear();
        ShowSearchResult=false;
        showSearchField = false;
        showSubmitBtnAOF = false;
        showBulkResend = false;
        showHistory = false;
        showOriginatorMsg = false;
        Commhistory = null;
        
        
        
        listSearchFilter = new List<Document_Type_Search_By_Field__mdt>();
        
        if(String.IsBlank(documentType)) return;
        
        System.debug('documentType---'+documentType);
        System.debug('AdditionalInfoData---'+AdditionalInfoData);
        
        List<Document_Type__mdt> docTypes = [SELECT Document_Type__c, WS_Field_Name__c FROM Document_Type__mdt where DeveloperName = :documentType];
        if(docTypes.size() > 0){
            documentTypeName = docTypes[0].Document_Type__c; 
            if(documentTypeName == 'Renewal Letter'){
                Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.INFO,'Resend functionality is not available for Renewal Letters. If additional information is needed, refer to the appropriate SOP.'));
            }
            else if(documentTypeName == 'Renewal Package'){
                Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.INFO,'Resend functionality is not available for Renewal Packages. If additional information is needed, refer to the appropriate SOP.'));
            }
            else if(documentTypeName == 'Summary Plan Description'){
                Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.INFO,'Resend functionality is not available for Summary Plan Descriptions. If additional information is needed, refer to the appropriate SOP.'));
            }
        }
        
        showSearchField = true;
        listSearchFilter = [SELECT Id, DeveloperName, Document_Type_Field__r.Label, Document_Type__r.Document_Type__c, Document_Type_Field__r.Field_Name__c, Document_Type_Field__r.HP_Field_Name__c, Document_Type_Field__r.Length__c, Required__c, Display_Order__c, WS_Default_Value__c, WS_MultiValue_Field__c, Document_Type_Field__r.Field_Type__c, Document_Type_Field__r.WS_Field_Name__c, Document_Type_Field__r.Data_Type__c, Document_type_Field__r.Operator__c FROM Document_Type_Search_By_Field__mdt WHERE Document_Type__r.Document_Type__c = :documentTypeName Order By Display_Order__c asc];
        
        system.debug('listSearchFilter '+listSearchFilter);
        system.debug('IsGroupFocus: ' + IsGroupFocus);
        system.debug('Flow-->' + Flow);
        
        
        
    }
    
    Public void UpdateAddressFields()
    {
        AddOnFilePersonWrap = new PersonWrapper();
        
        personFirstNameAA = '';
        personMiddleNameAA = '';
        personLastNameAA ='';
        personSuffixAA = '';
        personAddOneAA = '';
        personAddTwoAA = '';
        personCityAA = '';
        personStateAA = '';
        personZipCodeAA = '';
        personOrganizationAA = '';
        personWrapString = '';
        
        List<Document_Type_Flow__mdt> dtfs;
        if(Flow == 'Producer'){
            dtfs = [select id,Document_Type__r.Document_Type__c, WS_Backup_Address_Type__c, WS_Primary_Address_Type__c, isAlternateAddress__c, Subscriber_Only__c, Label from Document_Type_Flow__mdt where Flow__c = :flow and Is_Member_Focus__c = :isMemberFocus and Is_Group_Focus__c = :isGroupFocus and Document_Type__r.Document_Type__c = :documentTypeName];    
        }else{
            dtfs = [select id,Document_Type__r.Document_Type__c, WS_Backup_Address_Type__c, WS_Primary_Address_Type__c, isAlternateAddress__c, Subscriber_Only__c, Label from Document_Type_Flow__mdt where Flow__c = :flow and Is_Member_Focus__c = :isMemberFocus and Document_Type__r.Document_Type__c = :documentTypeName];  
        }
        
        Document_Type_Flow__mdt selectDocFlow;
        if(dtfs!= Null && dtfs.size() > 0){
            selectDocFlow = dtfs[0];        
        }
        system.debug('selectDocFlow-->'+selectDocFlow);
        
        ProdMIFSpecial = false;
        //boolean to indicate Producer, group, Member in focus flow for Enrollment Letter or Oxford SBC
        if(Flow == 'Producer' && IsMemberFocus && !String.isEmpty(AdditionalInfoData.GroupN) && (selectdocflow.Label.contains('Oxford SBC')||selectdocflow.Label.contains('Enrollment Letter'))){
            ProdMIFSpecial = true;
        }
        
        
        if((!prodMIFSpecial && Flow == 'Member') || (!prodMIFSpecial && Flow != 'Provider' && selectDocFlow.isAlternateAddress__c == false && isMemberFocus)){
            findMemberInfo(selectDocFlow);
        }else if(Flow == 'Provider' || (isMemberFocus && Flow == 'Provider')){
            findProviderInfo(selectDocFlow); 
        }         
        else if(Flow == 'Group' || selectDocFlow.isAlternateAddress__c == true || IsGroupFocus ||prodMIFSpecial){
            findGroupInfo(); 
        }
        else if(Flow == 'Producer'){
            findProducerInfo(selectDocFlow);          
        }else{
            showOriginatorMsg = true;  
        }
        
        system.debug(recepientId);
        system.debug(recepientType);
        
        if(showOriginatorMsg == false && String.isBlank(AddOnFilePersonWrap.personAddOne) &&  String.isBlank(AddOnFilePersonWrap.personCity) && String.isBlank(AddOnFilePersonWrap.personState) &&  String.isBlank(AddOnFilePersonWrap.personZipCode) && (String.isBlank(AddOnFilePersonWrap.personOrganization)|| (String.isBlank(AddOnFilePersonWrap.personFirstName) && String.isBlank(AddOnFilePersonWrap.personLastName)))){
            showSubmitBtnAOF = true;    
        }
        
        system.debug('true value--->'+ showOriginatorMsg +'----'+showSubmitBtnAOF);
    }
    
    public PageReference btnCancel(){
        showPopUPAddress = false;
        chooseAddress = false;
        return null;
    }
    
    public void findMemberInfo(Document_Type_Flow__mdt addType){
        ACETMemberDetail memberDetail = new ACETMemberDetail();
        memberDetail.SurrogateKey = ApexPages.currentPage().getParameters().get('SRK');
        ACETGetIndividualWebService stub = new ACETGetIndividualWebService();
        ACETWSCalloutResult calloutResult ;
        
        system.debug('SRK: ' + memberDetail.SurrogateKey);
        if(!String.isEmpty(MemberDetail.SurrogateKey)){
            calloutResult = stub.getIndividual(MemberDetail.SurrogateKey, MemberDetail);    
            
        } 
        else {
            system.debug(AdditionalInfoData.MemberId);
            system.debug(MemberDetail);
            calloutResult = stub.getIndividual(AdditionalInfoData.MemberId, MemberDetail);
            
        }
        system.debug('calloutResult--->'+calloutResult);  
        if(calloutResult.success != null && calloutResult.success){
            memberDetail =  (ACETMemberDetail)calloutResult.Response; 
        }
        system.debug('memberDetail--->'+memberDetail);
        
        map<String,ACETMemberDetail.Address> mapAddress = new map<String,ACETMemberDetail.Address>();
        if(memberDetail.Addresses != null){         
            for(ACETMemberDetail.Address address : memberDetail.Addresses){
                mapAddress.put(address.AddressType , address);      
            }}
        system.debug('mapAddress is '+mapAddress);
        if(mapAddress.get(addType.WS_Primary_Address_Type__c) != null){ 
            personAddOneAA = AddOnFilePersonWrap.personAddOne = mapAddress.get(addType.WS_Primary_Address_Type__c).AddressLine1;
            personAddTwoAA = AddOnFilePersonWrap.personAddTwo = mapAddress.get(addType.WS_Primary_Address_Type__c).AddressLine2;
            personCityAA = AddOnFilePersonWrap.personCity = mapAddress.get(addType.WS_Primary_Address_Type__c).City;
            personStateAA = AddOnFilePersonWrap.personState = mapAddress.get(addType.WS_Primary_Address_Type__c).State;
            personZipCodeAA = AddOnFilePersonWrap.personZipCode = mapAddress.get(addType.WS_Primary_Address_Type__c).Zip;
        }
        else if(mapAddress.get(addType.WS_Backup_Address_Type__c) != null){ 
            personAddOneAA = AddOnFilePersonWrap.personAddOne = mapAddress.get(addType.WS_Backup_Address_Type__c).AddressLine1;
            personAddTwoAA = AddOnFilePersonWrap.personAddTwo = mapAddress.get(addType.WS_Backup_Address_Type__c).AddressLine2;
            personCityAA = AddOnFilePersonWrap.personCity = mapAddress.get(addType.WS_Backup_Address_Type__c).City;
            personStateAA = AddOnFilePersonWrap.personState = mapAddress.get(addType.WS_Backup_Address_Type__c).State;
            personZipCodeAA = AddOnFilePersonWrap.personZipCode = mapAddress.get(addType.WS_Backup_Address_Type__c).Zip;
        }
        
        if(memberDetail.age!= null){
            if(Integer.valueof(memberDetail.age) > 12){
                recepientId = AdditionalInfoData.MemberId;
                personFirstNameAA = AddOnFilePersonWrap.personFirstName = memberDetail.FirstName;
                personMiddleNameAA = AddOnFilePersonWrap.personMiddleName = checkMiddlename(memberDetail.MiddleName);
                PersonLastNameAA = AddOnFilePersonWrap.PersonLastName = memberDetail.LastName;
                PersonSuffixAA = AddOnFilePersonWrap.PersonSuffix = memberDetail.Suffix;
            }
            else{
                // if age is less than 12 get subscriber name
                ACETFindMembershipWebservice MembershipWS = new ACETFindMembershipWebservice();
                ACETWSCalloutResult memshipResult = MembershipWS.findMembership(AdditionalInfoData.MemberId, memberDetail);
                ACETMemberDetail MemberDetailMembership = new ACETMemberDetail();
                MemberDetailMembership = (ACETMemberDetail)memshipResult.Response;
                ACETGetFamilyMemberWebService Family = new ACETGetFamilyMemberWebService();
                ACETWSCalloutResult res = Family.getFamilyMembers(AdditionalInfoData.MemberId,MemberDetailMembership);
                ACETMemberDetail MemberDetailfamily = (ACETMemberDetail)res.Response;
                system.debug('MemberDetailfamily is '+MemberDetailfamily);
                if(MemberDetailfamily != null && MemberDetailfamily.FamilyMembers.size() > 0){
                    for(ACETMemberDetail.FamilyMember fm : MemberDetailfamily.FamilyMembers){
                        if(fm.relationship == '18')
                        {
                            recepientId = fm.subscriberIndividualId;
                            personFirstNameAA = AddOnFilePersonWrap.personFirstName = fm.FirstName;
                            personMiddleNameAA = AddOnFilePersonWrap.personMiddleName = checkMiddlename(fm.MiddleInitial);
                            PersonLastNameAA = AddOnFilePersonWrap.PersonLastName = fm.LastName;
                            PersonSuffixAA = AddOnFilePersonWrap.PersonSuffix = fm.Suffix;
                        }
                    }
                }
            }
        }
        if(addType.Subscriber_Only__c == true ){
            system.debug('Inside Subscriber Only');
            map<String,ACETMemberDetail.Address> mapSubscriberAddress = new map<String,ACETMemberDetail.Address>();
            ACETFindMembershipWebservice MembershipWS = new ACETFindMembershipWebservice();
            ACETWSCalloutResult memshipResult = MembershipWS.findMembership(AdditionalInfoData.MemberId, memberDetail);
            ACETMemberDetail MemberDetailMembership = new ACETMemberDetail();
            MemberDetailMembership = (ACETMemberDetail)memshipResult.Response;
            ACETGetFamilyMemberWebService Family = new ACETGetFamilyMemberWebService();
            ACETWSCalloutResult res = Family.getFamilyMembers(AdditionalInfoData.MemberId,MemberDetailMembership);
            system.debug('Family Member Response is '+res.Response);
            ACETMemberDetail MemberDetailfamily = (ACETMemberDetail)res.Response;
            system.debug('MemberDetailfamily is '+MemberDetailfamily);
          
            if(MemberDetailfamily != null){
                system.debug('MemberDetailfamily.FamilyMembers is '+MemberDetailfamily.FamilyMembers);
                if(!MemberDetailfamily.FamilyMembers.isEmpty()){
                for(ACETMemberDetail.FamilyMember fm : MemberDetailfamily.FamilyMembers){
                    if(fm.relationship == '18')
                    {
                        recepientId = fm.subscriberIndividualId;
                        personFirstNameAA = AddOnFilePersonWrap.personFirstName = fm.FirstName;
                        personMiddleNameAA = AddOnFilePersonWrap.personMiddleName = checkMiddlename(fm.MiddleInitial);
                        PersonLastNameAA = AddOnFilePersonWrap.PersonLastName = fm.LastName;
                        PersonSuffixAA = AddOnFilePersonWrap.PersonSuffix = fm.Suffix;
                        system.debug('fm.Addresses is '+fm.Addresses);
                        if(fm.Addresses != null){         
                            for(ACETMemberDetail.Address address : fm.Addresses){
                                mapSubscriberAddress.put(address.AddressType , address);      
                            }}
                        system.debug('mapSubscriberAddress is '+mapSubscriberAddress);
                        if(mapSubscriberAddress.get(addType.WS_Primary_Address_Type__c) != null){ 
                            system.debug('SUbscriber Primary Address');
                            personAddOneAA = AddOnFilePersonWrap.personAddOne = mapSubscriberAddress.get(addType.WS_Primary_Address_Type__c).AddressLine1;
                            system.debug('Primary Address AddOnFilePersonWrap.personAddOne is '+AddOnFilePersonWrap.personAddOne);
                            personAddTwoAA = AddOnFilePersonWrap.personAddTwo = mapSubscriberAddress.get(addType.WS_Primary_Address_Type__c).AddressLine2;
                            personCityAA = AddOnFilePersonWrap.personCity = mapSubscriberAddress.get(addType.WS_Primary_Address_Type__c).City;
                            personStateAA = AddOnFilePersonWrap.personState = mapSubscriberAddress.get(addType.WS_Primary_Address_Type__c).State;
                            personZipCodeAA = AddOnFilePersonWrap.personZipCode = mapSubscriberAddress.get(addType.WS_Primary_Address_Type__c).Zip;
                        }
                        else if(mapSubscriberAddress.get(addType.WS_Backup_Address_Type__c) != null){ 
                            system.debug('SUbscriber Backup Address');
                            personAddOneAA = AddOnFilePersonWrap.personAddOne = mapSubscriberAddress.get(addType.WS_Backup_Address_Type__c).AddressLine1;
                            system.debug('Backup Address AddOnFilePersonWrap.personAddOne is '+AddOnFilePersonWrap.personAddOne);
                            personAddTwoAA = AddOnFilePersonWrap.personAddTwo = mapSubscriberAddress.get(addType.WS_Backup_Address_Type__c).AddressLine2;
                            personCityAA = AddOnFilePersonWrap.personCity = mapSubscriberAddress.get(addType.WS_Backup_Address_Type__c).City;
                            personStateAA = AddOnFilePersonWrap.personState = mapSubscriberAddress.get(addType.WS_Backup_Address_Type__c).State;
                            personZipCodeAA = AddOnFilePersonWrap.personZipCode = mapSubscriberAddress.get(addType.WS_Backup_Address_Type__c).Zip;
                        }
                        
                    }
                }
            }
        }
      }
        
        
        recepientType = 'Member';
        idQualifier = 'MemberID';
        
        personWrapString = JSON.serialize(AddOnFilePersonWrap);                       
        
    }
    
    public void findGroupInfo(){
        ACETGroupDetail groupDetails = new ACETGroupDetail();
        system.debug('ApexPages.currentPage().getParameters() is '+ApexPages.currentPage().getParameters());
        ACETGetEmployerDetailAdapterWebService stubData = new ACETGetEmployerDetailAdapterWebService();
        system.debug('AdditionalInfoData.GroupN is '+AdditionalInfoData.GroupN);
        String groupNTemp = AdditionalInfoData.GroupN.substring(0,7);
        system.debug('groupN after substring='+groupNTemp);
        ACETWSCalloutResult responseData = stubData.GetEmployerGroupDetail(groupNTemp);
        
        if(responseData.Success ){
            groupDetails = (ACETGroupDetail)responseData.response;
            
            map<String,ACETGroupDetail.AddressInfo> mapAddress = new map<String,ACETGroupDetail.AddressInfo>();
            for(ACETGroupDetail.AddressInfo address : groupDetails.groupAddressInfoList){
                system.debug('ADDRESS TYPE>>>>' +address.addrType);
                if(address.addrType.contains('Physical')){
                    mapAddress.put('Physical', address);     
                }
                else if(address.addrType.contains('Corporate')){
                    mapAddress.put('Corporate', address); 
                }
            }
            if(mapAddress.get('Physical') != null){ 
                personAddOneAA = AddOnFilePersonWrap.personAddOne = mapAddress.get('Physical').addrLine1;
                personAddTwoAA = AddOnFilePersonWrap.personAddTwo = mapAddress.get('Physical').addrLine2;
                personCityAA = AddOnFilePersonWrap.personCity = mapAddress.get('Physical').City;
                personStateAA = AddOnFilePersonWrap.personState = mapAddress.get('Physical').State;
                personZipCodeAA = AddOnFilePersonWrap.personZipCode = mapAddress.get('Physical').Zip;
            }
            else if(mapAddress.get('Corporate') != null){ 
                personAddOneAA = AddOnFilePersonWrap.personAddOne = mapAddress.get('Corporate').addrLine1;
                personAddTwoAA = AddOnFilePersonWrap.personAddTwo = mapAddress.get('Corporate').addrLine2;
                personCityAA = AddOnFilePersonWrap.personCity = mapAddress.get('Corporate').City;
                personStateAA = AddOnFilePersonWrap.personState = mapAddress.get('Corporate').State;
                personZipCodeAA = AddOnFilePersonWrap.personZipCode = mapAddress.get('Corporate').Zip;
            }
            personOrganizationAA = AddOnFilePersonWrap.personOrganization = groupDetails.genGroupInfo.groupName;
            recepientId = groupDetails.genGroupInfo.groupId;
            recepientType = 'Group';
            idQualifier = 'GroupID';
            setErrorMsgInDataTable('test',null);
        }
        personWrapString = JSON.serialize(AddOnFilePersonWrap);
    }
    
    public void findProducerInfo(Document_Type_Flow__mdt addType){
        ACETGetProducerAPI callWebservice = new ACETGetProducerAPI();
        ACETWSCalloutResult responseData = callWebservice.GetProducer(AdditionalInfoData.producerId);
        ACETProducerResult producerDetails = new ACETProducerResult();
        
        if(responseData.Success ){
            producerDetails = (ACETProducerResult)responseData.Response;
            system.debug('producerDetails--->'+producerDetails);
            
            map<String,ACETProducerResult.ACETProducerDemography> mapAddress = new map<String,ACETProducerResult.ACETProducerDemography>();
            for(ACETProducerResult.ACETProducerDemography address : producerDetails.addresslist){
                mapAddress.put(address.addressType , address);     
            }
            system.debug(mapAddress);
            system.debug('ADDTYPE PRIMARY>>>>'+addType.WS_Primary_Address_Type__c);
            system.debug('ADDTYPE BACKUP>>>>'+addType.WS_Backup_Address_Type__c);
            system.debug('MAPADDRESS GET PRIMARY>>>>'+mapAddress.get(addType.WS_Primary_Address_Type__c));
            
            if(mapAddress.get(addType.WS_Primary_Address_Type__c) != null){ 
                personAddOneAA = AddOnFilePersonWrap.personAddOne = mapAddress.get(addType.WS_Primary_Address_Type__c).streetAddress;
                personCityAA = AddOnFilePersonWrap.personCity = mapAddress.get(addType.WS_Primary_Address_Type__c).City;
                personStateAA = AddOnFilePersonWrap.personState = mapAddress.get(addType.WS_Primary_Address_Type__c).State;
                personZipCodeAA = AddOnFilePersonWrap.personZipCode = mapAddress.get(addType.WS_Primary_Address_Type__c).Zip;
                system.debug(AddOnFilePersonWrap);
            }
            else if(mapAddress.get(addType.WS_Backup_Address_Type__c) != null){ 
                personAddOneAA = AddOnFilePersonWrap.personAddOne = mapAddress.get(addType.WS_Backup_Address_Type__c).streetAddress;
                personCityAA = AddOnFilePersonWrap.personCity = mapAddress.get(addType.WS_Backup_Address_Type__c).City;
                personStateAA = AddOnFilePersonWrap.personState = mapAddress.get(addType.WS_Backup_Address_Type__c).State;
                personZipCodeAA = AddOnFilePersonWrap.personZipCode = mapAddress.get(addType.WS_Backup_Address_Type__c).Zip;
            }
            personOrganizationAA = AddOnFilePersonWrap.personOrganization = producerDetails.CompanyName;
            personFirstNameAA = AddOnFilePersonWrap.personFirstName = producerDetails.firstName;
            personMiddleNameAA = AddOnFilePersonWrap.personMiddleName = checkMiddlename(producerDetails.MiddleInitial);
            personLastNameAA = AddOnFilePersonWrap.PersonLastName =   producerDetails.lastName;
            recepientId = producerDetails.producerId;
            recepientType = 'Producer';
            idQualifier = 'ProducerID';            
        }
        
        system.debug(AddOnFilePersonWrap);
        personWrapString = JSON.serialize(AddOnFilePersonWrap);
    }
    
    public void findProviderInfo(Document_Type_Flow__mdt addType){
        ACETWSCalloutResult CalloutResult;
        ACETFindHCOWebservice ACTFHCOWS = new ACETFindHCOWebservice();
        ACETFindHCPWebservice ACTFHCPWS = new ACETFindHCPWebservice();
        
        List<ACETProviderLookupController.ProviderLookupResult> providerDetail = new List<ACETProviderLookupController.ProviderLookupResult>();
        
        String ProvTypeCode = ApexPages.currentPage().getParameters().get('ProvTypeCode');
        if(String.isBlank(ProvTypeCode)){
            ProvTypeCode = AdditionalInfoData.providerType; // Provider(Member in focus)--- PRA
        }
        system.debug('ProvTypeCode--->'+ProvTypeCode);
        if (ProvTypeCode == 'HCO') {
            CalloutResult = ACTFHCOWS.FindHCO(Interaction.Originator__r.Tax_ID__c,null,Interaction.Originator__r.EID__c,null,'',null,null,'','',null,null,null,null,null,null,null,null,null,null);   
            
        } else {
            CalloutResult = ACTFHCPWS.FindHCP(Interaction.Originator__r.Tax_ID__c, null, Interaction.Originator__r.EID__c, null, '', null, null, '', '', null,null, null, null, null, null, null, null, null,null);
        }
        if (CalloutResult.Success) {
            providerDetail = (List<ACETProviderLookupController.ProviderLookupResult>)CalloutResult.Response;
            system.debug('ProviderDetail*****'+providerDetail);
            if(ProvTypeCode == 'HCO'){
                personOrganizationAA = AddOnFilePersonWrap.personOrganization = providerDetail[0].fullName ;
            } 
            else{
                personFirstNameAa = AddOnFilePersonWrap.personFirstName = providerDetail[0].firstName ;
                personMiddlenameAA = AddOnFilePersonWrap.personMiddlename = checkMiddlename(providerDetail[0].MiddleName) ;
                personLastNameAA = AddOnFilePersonWrap.personLastName =providerDetail[0].lastName ;
                PersonSuffixAA = AddOnFilePersonWrap.PersonSuffix =providerDetail[0].suffix;
            }
            if (providerDetail!= Null){
                recepientId = providerDetail[0].providerId;}
            recepientType = 'Provider';
            idQualifier = 'ProviderID';
            
            map<String,ACETProviderLookupController.ProviderLookupResult> mapAddress = new map<String,ACETProviderLookupController.ProviderLookupResult>();
            for(ACETProviderLookupController.ProviderLookupResult address : providerDetail){
                mapAddress.put(address.addressTypeCode , address);      
            }
            system.debug('addType is '+addType);
            system.debug('MAPADRESS>>>>'+mapAddress);
            system.debug('PRIMARY ADDRESS TYPE>>>>'+addType.WS_Primary_address_Type__c);
            system.debug('BACKUP ADDRESS TYPE>>>>'+addType.WS_Backup_Address_Type__c);
            system.debug('BACKUP ADDRESS>>>>'+mapAddress.get(addType.WS_Backup_Address_Type__c));
            if(mapAddress.get(addType.WS_Primary_Address_Type__c)!= null){
                personAddOneAA = AddOnFilePersonWrap.personAddOne = mapAddress.get(addType.WS_Primary_Address_Type__c).addressLine1;
                personAddTwoAa = AddOnFilePersonWrap.personAddTwo = mapAddress.get(addType.WS_Primary_Address_Type__c).addressLine2;
                personCityAA = AddOnFilePersonWrap.personCity = mapAddress.get(addType.WS_Primary_Address_Type__c).City;
                personStateAA = AddOnFilePersonWrap.personState = mapAddress.get(addType.WS_Primary_Address_Type__c).state;
                personZipCodeAa = AddOnFilePersonWrap.personZipCode = mapAddress.get(addType.WS_Primary_Address_Type__c).zipCode;
                
                
            }
            else if(mapAddress.get(addType.WS_Backup_Address_Type__c) != null){ 
                personAddOneAA = AddOnFilePersonWrap.personAddOne = mapAddress.get(addType.WS_Backup_Address_Type__c).addressLine1;
                personAddTwoAa = AddOnFilePersonWrap.personAddTwo = mapAddress.get(addType.WS_Backup_Address_Type__c).addressLine2;
                personCityAA = AddOnFilePersonWrap.personCity = mapAddress.get(addType.WS_Backup_Address_Type__c).City;
                personStateAA = AddOnFilePersonWrap.personState = mapAddress.get(addType.WS_Backup_Address_Type__c).state;
                personZipCodeAa = AddOnFilePersonWrap.personZipCode = mapAddress.get(addType.WS_Backup_Address_Type__c).zipCode;
            }
            
        }
        personWrapString = JSON.serialize(AddOnFilePersonWrap);
        
    }
    
    public String getFlowName(){
    
        if(Interaction.Originator_Type__c !=null && Interaction.Originator_Type__c == 'Member'){
            return 'Member';
        }else if(Interaction.Originator_Type__c == 'Group/Employer' || Interaction.Originator_Type__c == 'Broker' || Interaction.Originator_Type__c == 'General Agent' || Interaction.Originator_Type__c == 'UHG' || Interaction.Originator_Type__c == 'Third Party'){
            return 'Group'; 
        }else if(Interaction.Originator_Type__c == 'Producer'){
            return 'Producer';  
        }else if(Interaction.Originator_Type__c == 'Provider'){
            return 'Provider';  
        }else{
            return '';  
        }
    }
    
   
    
    public class personWrapper{
        public String personOrganization{get;set;}
        public String personFirstName{get;set;}
        public String personMiddleName{get;set;}
        public String personLastName{get;set;}
        public String personSuffix{get;set;}
        public String personAddOne{get;set;}
        public String personAddTwo{get;set;}
        public String personCity{get;set;}
        public String personState{get;set;}
        public String personZipCode{get;set;}
        
    } 
    
    public String getProfileName() {
        Profile profileName = [select id, Name from Profile where Id =: UserInfo.getProfileId()];
        return profileName.Name;
    }
}