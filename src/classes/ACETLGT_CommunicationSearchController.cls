public class ACETLGT_CommunicationSearchController {
  public class acetUserInfo{
  @AuraEnabled
  public String Id {get;set;}
  @AuraEnabled
  public String FirstName {get;set;}
  @AuraEnabled
  public String LastName {get;set;}
  @AuraEnabled
  public String Email {get;set;}
  @AuraEnabled
  public String Profilename {get;set;}    
}
  
    @AuraEnabled
public static acetUserInfo getUserInfo(){
  try{
    acetUserInfo info = new acetUserInfo();
    info.Id = Userinfo.getUserId();
    info.FirstName = Userinfo.getFirstName();
    info.LastName = Userinfo.getLastName();
    info.Email = Userinfo.getUserEmail();
      Id profileId=userinfo.getProfileId();
info.Profilename =[Select Id,Name from Profile where Id=:profileId].Name;
    return info;
  }catch(Exception e){
     throw new AuraHandledException(e.getMessage()); 
  }
  } 
  public class personWrapper{         
    @AuraEnabled 
        public string personFirstName;
        @AuraEnabled 
        public string personMiddleName;
        @AuraEnabled 
        public string personLastName;
        @AuraEnabled 
        public string personSuffix;
        @AuraEnabled 
        public string personAddOne;
        @AuraEnabled 
        public string personAddTwo;
        @AuraEnabled 
        public string personCity;
        @AuraEnabled 
        public string personState;
        @AuraEnabled 
        public string personZipCode;
        @AuraEnabled 
        public string personOrganization; 
        @AuraEnabled 
        public string personFirstNameAA;
        @AuraEnabled 
        public string personMiddleNameAA;
        @AuraEnabled 
        public string personLastNameAA;
        @AuraEnabled 
        public string personSuffixAA;
        @AuraEnabled 
        public string personAddOneAA;
        @AuraEnabled 
        public string personAddTwoAA;
        @AuraEnabled 
        public string personCityAA;
        @AuraEnabled 
        public string personStateAA;
        @AuraEnabled 
        public string personZipCodeAA;
        @AuraEnabled 
        public string personOrganizationAA; 
        @AuraEnabled
      public string recipientId;
        @AuraEnabled
      public string idQualifier;
        @AuraEnabled
      public string recipientType;
    }
  
  @AuraEnabled
  public static List<Document_Type_Flow__mdt> getDocTypes(string flow, boolean isMemberFocus, string relationship) {
    List<Document_Type_Flow__mdt> dtfs = new List<Document_Type_Flow__mdt>();
    if(relationship=='Self') {
            dtfs = [select  Document_Type__r.Document_Type__c, WS_Backup_Address_Type__c, WS_Primary_Address_Type__c, Is_Group_Focus__c, Label from Document_Type_Flow__mdt where Flow__c = :flow and Is_Member_Focus__c = :isMemberFocus and Document_Type__r.Document_Type__c!=null order by label asc];
        }
        else {
            dtfs = [select  Document_Type__r.Document_Type__c, WS_Backup_Address_Type__c, WS_Primary_Address_Type__c, Is_Group_Focus__c, Label from Document_Type_Flow__mdt where Flow__c = :flow and Is_Member_Focus__c = :isMemberFocus and Document_Type__r.Is_Subscriber__c = false and Document_Type__r.Document_Type__c!=null order by label asc];
        }
        return dtfs;
  }
  
  @AuraEnabled
  public static List<Document_Type_Search_By_Field__mdt> changeSearchFilter(string documentType) {
    List<Document_Type_Search_By_Field__mdt> listSearchFilter = [SELECT Id,Document_Type__r.WS_Field_Name__c, DeveloperName, Document_Type_Field__r.Label, Document_Type__r.Document_Type__c, Document_Type_Field__r.Field_Name__c, Document_Type_Field__r.HP_Field_Name__c, Document_Type_Field__r.Length__c, Required__c, Disabled__c, Display_Order__c, WS_Default_Value__c, WS_MultiValue_Field__c, Document_Type_Field__r.Field_Type__c, Document_Type_Field__r.WS_Field_Name__c, Document_Type_Field__r.Data_Type__c, Document_type_Field__r.Operator__c FROM Document_Type_Search_By_Field__mdt WHERE Document_Type__r.Document_Type__c = :documentType Order By Display_Order__c asc];
        return listSearchFilter;
  }
  
  @AuraEnabled
  public static List<Document_Type_Search_Result_Field__mdt> getSearchResultFields(string documentType) {
        List<Document_Type_Search_Result_Field__mdt> resultFields = [select DeveloperName,Document_Type_Field__r.WS_Field_Name__c,Document_Type_Field__r.Field_Name__c, Display_Order__c from Document_Type_Search_Result_Field__mdt where Document_Type__r.Document_Type__c = :documentType order by Display_Order__c];           
        return resultFields;
  }
  
  public  class DataWrapper{
       @Auraenabled
        public string responce;
       @Auraenabled 
         public string wrapperdetails;
       @Auraenabled
       public string resultFields;
        public DataWrapper(String responce, string resultFields){
            this.responce = responce;    
            this.resultFields = resultFields;
        }       
    }
  
    @AuraEnabled 
    public static DataWrapper getCommunicationSearchResults(String documentType,String dynamicParams){
         System.debug('dynamicParams' +dynamicParams);
         List<String> keyparams = (List<String>)JSON.deserialize(dynamicParams, List<String>.class);
         system.debug('keyparams is '+keyparams[0]);
         ACETLGT_FindDocWebservice.documentKey key;
         List<ACETLGT_FindDocWebservice.documentKey> findDocKeys = new List<ACETLGT_FindDocWebservice.documentKey>();
         system.debug(keyparams);
        for(String par: keyparams){
            String [] str = par.split(',');
            system.debug('str[0] '+str);   
            system.debug('str size '+str.size());
            key = new ACETLGT_FindDocWebservice.documentKey();
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
            findDocKeys.add(key);
            system.debug('findDocKeys.add is '+findDocKeys);
            
        }
            List<Document_Type_Search_By_Field__mdt> listSearchFilter = new List<Document_Type_Search_By_Field__mdt>();
        listSearchFilter = [SELECT Id, DeveloperName, Document_Type_Field__r.Label, Document_Type__r.Document_Type__c, Document_Type_Field__r.Field_Name__c, Document_Type_Field__r.HP_Field_Name__c, Document_Type_Field__r.Length__c, Required__c, Disabled__c, Display_Order__c, WS_Default_Value__c, WS_MultiValue_Field__c, Document_Type_Field__r.Field_Type__c, Document_Type_Field__r.WS_Field_Name__c, Document_Type_Field__r.Data_Type__c, Document_type_Field__r.Operator__c FROM Document_Type_Search_By_Field__mdt WHERE Document_Type__r.Document_Type__c = :documentType Order By Display_Order__c asc];
        if(documentType=='Provider RA'){
            for(Document_Type_Search_By_Field__mdt sf : listSearchFilter){
                if(sf.Display_Order__c < 0 && sf.Required__c == true){
                    key = new ACETLGT_FindDocWebservice.documentKey();
                    key.name = sf.Document_Type_Field__r.WS_Field_Name__c;
                    if(sf.DeveloperName == Label.ACETDocumentPaymentCycleStartDatePRA){
                        key.value = '2017-12-1';
                    }
                    else if(sf.DeveloperName == Label.ACETDocumentPaymentCycleEndDatePRA){
                        Date dt = Date.today();
                        key.value = dt.year()+'-'+dt.month()+'-'+dt.day();
                    }
                    //key.value = sf.WS_Default_Value__c;
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
        }
        //add template doc keys for handbook doc types
        if(documentType=='Oxford Group Handbook'){
            system.debug('oxford group handbook selected');
            key = new ACETLGT_FindDocWebservice.documentKey(); 
            key.value = 'GROUP HANDBOOK';  // Updated by Abhinav for DOC360 migration
            key.name = 'u_tmplt_nm';
            key.dataTypeIndicator = 'String';
            key.operator = '=';
            findDocKeys.add(key);
        }
        else if(documentType=='Oxford Member Handbook'){
            system.debug('oxford member handbook selected');
            key = new ACETLGT_FindDocWebservice.documentKey();
            key.value = 'MEMBER HANDBOOK';  // Updated by Abhinav for DOC360 migration
            key.name = 'u_tmplt_nm';
            key.dataTypeIndicator = 'String';
            key.operator = '=';
            findDocKeys.add(key);
        }else if(documentType=='Member Handbook'){
            system.debug('member handbook selected');
            key = new ACETLGT_FindDocWebservice.documentKey();
            key.value = 'MEMBER HANDBOOK';  // Updated by Abhinav for DOC360 migration
            key.name = 'u_tmplt_nm';
            key.dataTypeIndicator = 'String';
            key.operator = '=';
            findDocKeys.add(key);
        }else if(documentType=='Group Handbook'){
            system.debug('group handbook selected');
            key = new ACETLGT_FindDocWebservice.documentKey();
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
                for(ACETLGT_FindDocWebservice.documentKey docKey : findDocKeys){
                    if(sf.Document_Type_Field__r.WS_Field_Name__c == docKey.name){
                        docKey.operator += ' ANY';
                    }   
                }   
            }
        }
        String WSDocumentClass = '';
        if(!String.isEmpty(documentType)){
            List<Document_Type__mdt> docTypes = [SELECT Id,Order__c,Label, Document_Type__c, WS_Field_Name__c FROM Document_Type__mdt where Document_Type__c = :documentType];
            if(docTypes.size() > 0){
                WSDocumentClass = docTypes[0].WS_Field_Name__c; 
            }
        }
        system.debug('findDocKeys before is '+findDocKeys);
        system.debug('WSDocumentClass' +WSDocumentClass);
        ACETLGT_FindDocWebservice FindDocService = new ACETLGT_FindDocWebservice();
        FindDocService.init(WSDocumentClass,findDocKeys); 
        string  service = JSON.serialize(FindDocService).replace('\'', '&#x27;');
        service = service.replace('&#x27;', '\'');
        System.debug(JSON.serialize(service));
        List<Document_Type_Search_Result_Field__mdt> resultFields = [select DeveloperName,Document_Type_Field__r.WS_Field_Name__c,Document_Type_Field__r.Field_Name__c, Display_Order__c from Document_Type_Search_Result_Field__mdt where Document_Type__r.Document_Type__c = :documentType order by Display_Order__c];           
        return new DataWrapper(JSON.serialize(service), JSON.serialize(resultFields)); 
    }
    
    @AuraEnabled
  public static string findMemberInfo(string memberId, string SRK, string documentType){
    List<Document_Type_Flow__mdt> dtfs = [select Document_Type__r.WS_Field_Name__c, Document_Type__r.Document_Type__c, WS_Backup_Address_Type__c, WS_Primary_Address_Type__c,isAlternateAddress__c, Subscriber_Only__c from Document_Type_Flow__mdt where Flow__c = 'Member' and Is_Member_Focus__c = true and Document_Type__r.Document_Type__c = :documentType];
        system.debug('dtfs is '+dtfs);
        Document_Type_Flow__mdt selectDocFlow;
        if(dtfs.size() > 0){
            selectDocFlow = dtfs[0];
            string documentClass = dtfs[0].Document_Type__r.WS_Field_Name__c;      
        }
    personWrapper AddOnFilePersonWrap = new personWrapper();
        ACETMemberDetail memberDetail = new ACETMemberDetail();
        memberDetail.SurrogateKey = SRK;
        ACETGetIndividualWebService stub = new ACETGetIndividualWebService();
        ACETWSCalloutResult calloutResult ;
        system.debug('srk: ' + memberDetail.SurrogateKey + ' memid: ' + memberId);
        if(!String.isEmpty(MemberDetail.SurrogateKey)){
            calloutResult = stub.getIndividual(MemberDetail.SurrogateKey, MemberDetail);    
        } 
        else {
            system.debug(MemberDetail);
            calloutResult = stub.getIndividual(memberId, MemberDetail);
            
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
        if(mapAddress.get(selectDocFlow.WS_Primary_Address_Type__c) != null){ 
          AddOnFilePersonWrap.personAddOne = AddOnFilePersonWrap.personAddOneAA = mapAddress.get(selectDocFlow.WS_Primary_Address_Type__c).AddressLine1;
            system.debug('Primary Address AddOnFilePersonWrap.personAddOne is '+AddOnFilePersonWrap.personAddOne);
            AddOnFilePersonWrap.personAddTwo = AddOnFilePersonWrap.personAddTwoAA = mapAddress.get(selectDocFlow.WS_Primary_Address_Type__c).AddressLine2;
            AddOnFilePersonWrap.personCity = AddOnFilePersonWrap.personCityAA = mapAddress.get(selectDocFlow.WS_Primary_Address_Type__c).City;
            AddOnFilePersonWrap.personState = AddOnFilePersonWrap.personStateAA = mapAddress.get(selectDocFlow.WS_Primary_Address_Type__c).State;
            AddOnFilePersonWrap.personZipCode = AddOnFilePersonWrap.personZipCodeAA = mapAddress.get(selectDocFlow.WS_Primary_Address_Type__c).Zip;
        }
        else if(mapAddress.get(selectDocFlow.WS_Backup_Address_Type__c) != null){ 
          AddOnFilePersonWrap.personAddOne = AddOnFilePersonWrap.personAddOneAA = mapAddress.get(selectDocFlow.WS_Backup_Address_Type__c).AddressLine1;
            system.debug('Backup Address AddOnFilePersonWrap.personAddOne is '+AddOnFilePersonWrap.personAddOne);
            AddOnFilePersonWrap.personAddTwo = AddOnFilePersonWrap.personAddTwoAA = mapAddress.get(selectDocFlow.WS_Backup_Address_Type__c).AddressLine2;
            AddOnFilePersonWrap.personCity = AddOnFilePersonWrap.personCityAA = mapAddress.get(selectDocFlow.WS_Backup_Address_Type__c).City;
            AddOnFilePersonWrap.personState = AddOnFilePersonWrap.personStateAA = mapAddress.get(selectDocFlow.WS_Backup_Address_Type__c).State;
            AddOnFilePersonWrap.personZipCode = AddOnFilePersonWrap.personZipCodeAA = mapAddress.get(selectDocFlow.WS_Backup_Address_Type__c).Zip;
        }
        
        if(memberDetail.age!= null){
            if(Integer.valueof(memberDetail.age) > 12){
                AddOnFilePersonWrap.recipientId = memberId;
                AddOnFilePersonWrap.personFirstName = AddOnFilePersonWrap.personFirstNameAA = memberDetail.FirstName;
                AddOnFilePersonWrap.personMiddleName = AddOnFilePersonWrap.personMiddleNameAA = memberDetail.MiddleName;
                AddOnFilePersonWrap.PersonLastName = AddOnFilePersonWrap.PersonLastNameAA = memberDetail.LastName;
                AddOnFilePersonWrap.PersonSuffix = AddOnFilePersonWrap.PersonSuffixAA = memberDetail.Suffix;
            }
            else{
                // if age is less than 12 get subscriber name
                ACETLGT_FindIndMemberShipsWebService FindIndMemService = new ACETLGT_FindIndMemberShipsWebService();
                ACETWSCalloutResult memshipResult = FindIndMemService.findMemberWS(memberId, memberDetail.firstName, memberDetail.lastName, memberDetail.dob, '', '', '');
                ACETMemberDetail MemberDetailMembership = new ACETMemberDetail();
                MemberDetailMembership = (ACETMemberDetail)memshipResult.Response;
                ACETGetFamilyMemberWebService Family = new ACETGetFamilyMemberWebService();
                ACETWSCalloutResult res = Family.getFamilyMembers(memberId,MemberDetailMembership);
                ACETMemberDetail MemberDetailfamily = (ACETMemberDetail)res.Response;
                if(MemberDetailfamily!=null){
                    for(ACETMemberDetail.FamilyMember fm : MemberDetailfamily.FamilyMembers){
                        if(fm.relationship == '18')
                        {
                          AddOnFilePersonWrap.recipientId = fm.subscriberIndividualId;
                          AddOnFilePersonWrap.personFirstName = AddOnFilePersonWrap.personFirstNameAA = fm.FirstName;
                          AddOnFilePersonWrap.personMiddleName = AddOnFilePersonWrap.personMiddleNameAA = fm.MiddleInitial;
                          AddOnFilePersonWrap.PersonLastName = AddOnFilePersonWrap.PersonLastNameAA = fm.LastName;
                          AddOnFilePersonWrap.PersonSuffix = AddOnFilePersonWrap.PersonSuffixAA = fm.Suffix;
                        }
                    }
                }
            }
        }
        if(selectDocFlow.Subscriber_Only__c == true){
            system.debug('Inside Subscriber Only');
            map<String,ACETMemberDetail.Address> mapSubscriberAddress = new map<String,ACETMemberDetail.Address>();
            ACETLGT_FindIndMemberShipsWebService FindIndMemService = new ACETLGT_FindIndMemberShipsWebService();
            ACETWSCalloutResult memshipResult = FindIndMemService.findMemberWS(memberId, memberDetail.firstName, memberDetail.lastName, memberDetail.dob, '', '', '');
            ACETMemberDetail MemberDetailMembership = new ACETMemberDetail();
            MemberDetailMembership = (ACETMemberDetail)memshipResult.Response;
            ACETGetFamilyMemberWebService Family = new ACETGetFamilyMemberWebService();
            ACETWSCalloutResult res = Family.getFamilyMembers(memberId,MemberDetailMembership);
            ACETMemberDetail MemberDetailfamily = (ACETMemberDetail)res.Response;
            if(MemberDetailfamily != null && MemberDetailfamily.FamilyMembers.size() > 0){
                for(ACETMemberDetail.FamilyMember fm : MemberDetailfamily.FamilyMembers){
                    if(fm.relationship == '18')
                    {
                        AddOnFilePersonWrap.recipientId = fm.subscriberIndividualId;
                        AddOnFilePersonWrap.personFirstName = AddOnFilePersonWrap.personFirstNameAA = fm.FirstName;
                      AddOnFilePersonWrap.personMiddleName = AddOnFilePersonWrap.personMiddleNameAA = fm.MiddleInitial;
                      AddOnFilePersonWrap.PersonLastName = AddOnFilePersonWrap.PersonLastNameAA = fm.LastName;
                      AddOnFilePersonWrap.PersonSuffix = AddOnFilePersonWrap.PersonSuffixAA = fm.Suffix;
                        if(fm.Addresses != null){         
                            for(ACETMemberDetail.Address address : fm.Addresses){
                                mapSubscriberAddress.put(address.AddressType , address);      
                            }}
                        if(mapSubscriberAddress.get(selectDocFlow.WS_Primary_Address_Type__c) != null){ 
                          AddOnFilePersonWrap.personAddOne = AddOnFilePersonWrap.personAddOneAA = mapSubscriberAddress.get(selectDocFlow.WS_Primary_Address_Type__c).AddressLine1;
                            system.debug('Primary Address AddOnFilePersonWrap.personAddOne is '+AddOnFilePersonWrap.personAddOne);
                            AddOnFilePersonWrap.personAddTwo = AddOnFilePersonWrap.personAddTwoAA = mapSubscriberAddress.get(selectDocFlow.WS_Primary_Address_Type__c).AddressLine2;
                            AddOnFilePersonWrap.personCity = AddOnFilePersonWrap.personCityAA = mapSubscriberAddress.get(selectDocFlow.WS_Primary_Address_Type__c).City;
                            AddOnFilePersonWrap.personState = AddOnFilePersonWrap.personStateAA = mapSubscriberAddress.get(selectDocFlow.WS_Primary_Address_Type__c).State;
                            AddOnFilePersonWrap.personZipCode = AddOnFilePersonWrap.personZipCodeAA = mapSubscriberAddress.get(selectDocFlow.WS_Primary_Address_Type__c).Zip;
                        }
                        else if(mapSubscriberAddress.get(selectDocFlow.WS_Backup_Address_Type__c) != null){ 
                          AddOnFilePersonWrap.personAddOne = AddOnFilePersonWrap.personAddOneAA = mapSubscriberAddress.get(selectDocFlow.WS_Backup_Address_Type__c).AddressLine1;
                            system.debug('Backup Address AddOnFilePersonWrap.personAddOne is '+AddOnFilePersonWrap.personAddOne);
                            AddOnFilePersonWrap.personAddTwo = AddOnFilePersonWrap.personAddTwoAA = mapSubscriberAddress.get(selectDocFlow.WS_Backup_Address_Type__c).AddressLine2;
                            AddOnFilePersonWrap.personCity = AddOnFilePersonWrap.personCityAA = mapSubscriberAddress.get(selectDocFlow.WS_Backup_Address_Type__c).City;
                            AddOnFilePersonWrap.personState = AddOnFilePersonWrap.personStateAA = mapSubscriberAddress.get(selectDocFlow.WS_Backup_Address_Type__c).State;
                            AddOnFilePersonWrap.personZipCode = AddOnFilePersonWrap.personZipCodeAA = mapSubscriberAddress.get(selectDocFlow.WS_Backup_Address_Type__c).Zip;
                        }
                    }
                    
                }
            }
        }
        AddOnFilePersonWrap.recipientType = 'Member';
        AddOnFilePersonWrap.idQualifier = 'MemberID';
        return JSON.serialize(AddOnFilePersonWrap);
    }
    
    @AuraEnabled 
    public static String resendSelectedDocs(List<String> docIds, string AddOnFilePersonWrapString, string selectAddress, string documentClass,string bookOfBusinessTypeCode){        
    personWrapper AddOnFilePersonWrap  = (personWrapper)JSON.deserialize(AddOnFilePersonWrapString, personWrapper.class);
        ACETDocRedeliveryWebservice ACETDCWS = new ACETDocRedeliveryWebservice();
        List<ACETDocRedeliveryRequest> docRedeliveryReqList = new List<ACETDocRedeliveryRequest>();
        system.debug(docIds);
        for(Integer i=0 ; i<docIds.size();i++){
            String redeliveryId = 'ACET-' + (system.now().getTime()+i);
            ACETDocRedeliveryRequest docRedeliveryReq = new ACETDocRedeliveryRequest();
            docRedeliveryReq.redeliveryID = redeliveryId;
            docRedeliveryReq.recepientId = AddOnFilePersonWrap.recipientId;
            docRedeliveryReq.idQualifier = AddOnFilePersonWrap.idQualifier;
            docRedeliveryReq.recepientType = AddOnFilePersonWrap.recipientType;
            docRedeliveryReq.docClass = documentClass;
            docRedeliveryReq.docId = docIds[i];
            docRedeliveryReq.bookOfBusinessTypeCode = bookOfBusinessTypeCode;
            if(selectAddress.contains('addOnFile')){
                docRedeliveryReq.perAdd1 = AddOnFilePersonWrap.personAddOne;
                docRedeliveryReq.perAdd2 = AddOnFilePersonWrap.personAddTwo;
                docRedeliveryReq.perCity = AddOnFilePersonWrap.personCity;
                docRedeliveryReq.perState= AddOnFilePersonWrap.personState;
                docRedeliveryReq.perZip  = AddOnFilePersonWrap.personZipCode;
                docRedeliveryReq.fName = ACETCommunicationSearchController.firstnameHelper(AddOnFilePersonWrap.personFirstName, AddOnFilePersonWrap.personOrganization);
                docRedeliveryReq.lName = ACETCommunicationSearchController.lastnameHelper(AddOnFilePersonWrap.personLastName);
                //Modified by Team-Styx Hasara on July 02 2021 For Adding '.' after 'Jr' or 'Sr'
                docRedeliveryReq.suffix = ACETCommunicationSearchController.checkSuffix(AddOnFilePersonWrap.personSuffix);
                //Modified by Team-Styx Hasara on July 02 2021 For personMiddleName null check
                docRedeliveryReq.mName = ACETCommunicationSearchController.checkMiddlename(AddOnFilePersonWrap.personMiddleName);
            }
            else if(selectAddress.contains('altAdd')){
                docRedeliveryReq.perAdd1 = AddOnFilePersonWrap.personAddOneAA;
                docRedeliveryReq.perAdd2 = AddOnFilePersonWrap.personAddTwoAA;
                docRedeliveryReq.perCity = AddOnFilePersonWrap.personCityAA;
                docRedeliveryReq.perState= AddOnFilePersonWrap.personStateAA;
                docRedeliveryReq.perZip  = AddOnFilePersonWrap.personZipCodeAA;
                docRedeliveryReq.fName = ACETCommunicationSearchController.firstnameHelper(AddOnFilePersonWrap.personFirstNameAA, AddOnFilePersonWrap.personOrganizationAA);
                docRedeliveryReq.lName = ACETCommunicationSearchController.lastnameHelper(AddOnFilePersonWrap.personLastNameAA);
                //Modified by Team-Styx Hasara on July 02 2021 For Adding '.' after 'Jr' or 'Sr'
                docRedeliveryReq.suffix = ACETCommunicationSearchController.checkSuffix(AddOnFilePersonWrap.personSuffixAA);  
                //Modified by Team-Styx Hasara on July 02 2021 For personMiddleName null check
                docRedeliveryReq.mName = ACETCommunicationSearchController.checkMiddlename(AddOnFilePersonWrap.personMiddleNameAA);
            }
            docRedeliveryReqList.add(docRedeliveryReq);
        }
        list<ACETWSCalloutResult> docRedeliveryCalloutResultList = ACETDCWS.docRedeliveryMultipleWS(docRedeliveryReqList);
        
        return JSON.serialize(processResendResponse(docIds, docRedeliveryCalloutResultList));
    }
    
    public static list<String> processResendResponse(list<String> docIds, list<ACETWSCalloutResult> docRedeliveryCalloutResultList){
        integer i=0;
        List<String> resultList = new List<String>();
        for(ACETWSCalloutResult docRedeliveryCalloutResult: docRedeliveryCalloutResultList){
            String documentDeliveryResult;  
            if(docRedeliveryCalloutResult.success){ 
                ACETCommunicationSearchResult selComResult = (ACETCommunicationSearchResult)docRedeliveryCalloutResult.Response;
                documentDeliveryResult = 'Document ' + docIds[i] + ' ' + selComResult.Resend_Status + ' ' + selComResult.Resend_Date_Time;
            }else{
                documentDeliveryResult = docRedeliveryCalloutResult.Message;
            }
            resultList.add(documentDeliveryResult);
            i++;
        }
        return resultList;
    }
}