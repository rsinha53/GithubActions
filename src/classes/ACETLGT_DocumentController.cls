public class ACETLGT_DocumentController {
    
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
        @AuraEnabled
        public string userprofilename;
    }
    
    
    
    @AuraEnabled
    public static string fetchDoc(string docId, string docContentType, string docName, string docSize, string isDocSizeMoreThanOneMB, String isIdCard){
            String docUrl = '';
            String DocTempUrl;
            system.debug(docId);
            system.debug(docContentType);
            system.debug(isDocSizeMoreThanOneMB);
            
            if(!String.isEmpty(docId) && !String.isEmpty(docContentType) && isDocSizeMoreThanOneMB == 'false'){           
                ACETGetDocWebservice service = new ACETGetDocWebservice();
                ACETWSCalloutResult ac = new ACETWSCalloutResult();
                if(isIdCard == 'true')
                    ac = service.fetchDocument('FiServ', docId);
                else
                    ac = service.fetchDocument('PSEUDO1', docId);

                system.debug(ac.Success);
                
                if(ac.Success){
                    Attachment a;           
                    String value = EncodingUtil.convertToHex(ac.Attach.body);           
                    
                    //locate the first <payload> in the reponse stream
                    String payload = EncodingUtil.convertToHex(Blob.valueOf('<payload>'));
                    Integer index = value.indexOf(payload);
                    
                    if(index > = -1){               
                        //locate the end boundary of payload
                        String uuid = EncodingUtil.convertToHex(Blob.valueOf('--uuid:'));
                        Integer index2 = value.indexOf(uuid, index);
                        
                        //skip the \r\n after <payload> and retrieve attachment content
                        system.debug('index '+index);
                        system.debug('>>>> value '+value);
                        system.debug('index2 '+index2);
                        system.debug('index + payload.length() '+index + payload.length());
                        
                        value = value.substring(index + payload.length() + 8, index2);
                        
                        //remove blank lines \r\n at end
                        if(value.substring(value.length()-4, value.length()) == '0d0a'){
                            value = value.substring(0, value.length()-4);   
                        }               
                    }
                    
                    Temp_Document__c td = new Temp_Document__c();
                    insert td;
                    a = new Attachment();
                    if (Schema.sObjectType.Attachment.fields.Name.isCreateable())
                    a.Name = docId+'.pdf';
                    a.parentId = td.Id;
                    a.body = EncodingUtil.convertFromHex(value);
                    a.ContentType = docContentType;
                    if (Schema.sObjectType.Attachment.isCreateable())
                    insert a;
                    
                    DocTempUrl = '/servlet/servlet.FileDownload?file=' + a.Id;
                    docUrl = DocTempUrl;
                }else{
//                  Apexpages.addMessage(new ApexPages.message(ac.MessageSeverity, ac.Message));    
                }       
            }
            else{
//              Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, 'A manual document search is required.'));  
            }
          
            return docUrl;
            
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
      List<Profile> PROFILE = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
       AddOnFilePersonWrap.userprofilename = PROFILE[0].Name;  
        
        AddOnFilePersonWrap.recipientType = 'Member';
        AddOnFilePersonWrap.idQualifier = 'MemberID';
        return JSON.serialize(AddOnFilePersonWrap);
    }
    
    @AuraEnabled
    public static string resendSelectedDocs(string AddOnFilePersonWrapString, string documentId, string selectAddress, string documentClass,string bookOfBusinessTypeCode){        
        personWrapper AddOnFilePersonWrap  = (personWrapper)JSON.deserialize(AddOnFilePersonWrapString, personWrapper.class);
        
        ACETDocRedeliveryWebservice ACETDCWS = new ACETDocRedeliveryWebservice();
        ACETWSCalloutResult docRedeliveryCalloutResult = new ACETWSCalloutResult();        
        
        system.debug('selected address: ' + selectAddress);
                
        system.debug(AddOnFilePersonWrap.recipientType);
        system.debug(AddOnFilePersonWrap);
        
        String redeliveryId = 'ACET-' + system.now().getTime();
        
        String documentDeliveryResult;
        ACETDocRedeliveryRequest docRedeliveryReq = new ACETDocRedeliveryRequest();
        docRedeliveryReq.redeliveryID = redeliveryId;
        docRedeliveryReq.recepientId = AddOnFilePersonWrap.recipientId;
        docRedeliveryReq.idQualifier = AddOnFilePersonWrap.idQualifier;
        docRedeliveryReq.recepientType = AddOnFilePersonWrap.recipientType;
        docRedeliveryReq.docClass = documentClass;
		docRedeliveryReq.docId = documentId;
		docRedeliveryReq.bookOfBusinessTypeCode = bookOfBusinessTypeCode;	        
        if(selectAddress.contains('addOnFile')){
            docRedeliveryReq.perAdd1 = AddOnFilePersonWrap.personAddOne;
            docRedeliveryReq.perAdd2 = AddOnFilePersonWrap.personAddTwo;
            docRedeliveryReq.perCity = AddOnFilePersonWrap.personCity;
            docRedeliveryReq.perState= AddOnFilePersonWrap.personState;
            docRedeliveryReq.perZip  = AddOnFilePersonWrap.personZipCode;
            docRedeliveryReq.fName = String.IsBlank(AddOnFilePersonWrap.personFirstName)?AddOnFilePersonWrap.personOrganization:AddOnFilePersonWrap.personFirstName;
            docRedeliveryReq.lName = String.IsBlank(AddOnFilePersonWrap.personLastName)?'.':AddOnFilePersonWrap.personLastName;  
           
            //Modified by Team-Styx Hasara on July 02 2021 For Adding '.' after 'Jr' or 'Sr'
            docRedeliveryReq.suffix = ACETDocumentController.checkSuffix(AddOnFilePersonWrap.personSuffix);
            //Modified by Team-Styx Hasara on July 02 2021 For personMiddleName null check
            docRedeliveryReq.mName = ACETDocumentController.checkMiddlename(AddOnFilePersonWrap.personMiddleName);
        }
        else if(selectAddress.contains('altAdd')){
            docRedeliveryReq.perAdd1 = AddOnFilePersonWrap.personAddOneAA;
            docRedeliveryReq.perAdd2 = AddOnFilePersonWrap.personAddTwoAA;
            docRedeliveryReq.perCity = AddOnFilePersonWrap.personCityAA;
            docRedeliveryReq.perState= AddOnFilePersonWrap.personStateAA;
            docRedeliveryReq.perZip  = AddOnFilePersonWrap.personZipCodeAA;
            docRedeliveryReq.fName = String.IsBlank(AddOnFilePersonWrap.personFirstNameAA)?AddOnFilePersonWrap.personOrganizationAA:AddOnFilePersonWrap.personFirstNameAA;
            docRedeliveryReq.lName = String.IsBlank(AddOnFilePersonWrap.personLastNameAA)?'.':AddOnFilePersonWrap.personLastNameAA; 
            
            //Modified by Team-Styx Hasara on July 02 2021 For Adding '.' after 'Jr' or 'Sr'
            docRedeliveryReq.suffix = ACETDocumentController.checkSuffix(AddOnFilePersonWrap.personSuffixAA);
            //Modified by Team-Styx Hasara on July 02 2021 For personMiddleName null check
            docRedeliveryReq.mName = ACETDocumentController.checkMiddlename(AddOnFilePersonWrap.personMiddleNameAA);
        }
        docRedeliveryCalloutResult = ACETDCWS.docRedeliveryWS(docRedeliveryReq);
        if(docRedeliveryCalloutResult.success){ 
            ACETCommunicationSearchResult selComResult = (ACETCommunicationSearchResult)docRedeliveryCalloutResult.Response;
            documentDeliveryResult = 'Resend Submitted: ' + 'Document ' + documentId + ' ' + selComResult.Resend_Status + ' ' + selComResult.Resend_Date_Time;
        }else{
            documentDeliveryResult = docRedeliveryCalloutResult.Message;
             }                        
        return JSON.serialize(documentDeliveryResult);
        
    }
  
   /**
    * @description US3543138 - Team Styx - Preparing Doc360 Request Body
    * @author Raviteja | 06-08-2021 
    * @param pageNumber 
    * @param pageSize 
    * @param startRecord 
    * @param filters 
    * @return ACETFindDoc360SearchRequest 
    **/
   @AuraEnabled 
   public static String getdoc360Url(String documentId , String doctypeWSName){ 
    ACET_ClaimRelatedDocumentController.AttachmentsResponseData doc360Input = new ACET_ClaimRelatedDocumentController.AttachmentsResponseData();
    List<Document_Type__mdt> doctypeList = [Select id, (select id, Label, DeveloperName from Document_Type_Doc_Class__r) from Document_Type__mdt where WS_Field_Name__c=:doctypeWSName];
    if(doctypeList.size()>0){
       Map<String,String> feildMap = new Map<String, String>();
       List<Doctype_Doc_Class__mdt> docclassmdt = new List<Doctype_Doc_Class__mdt>();
        for(Document_Type__mdt mdt: doctypeList){
            if(mdt.Document_Type_Doc_Class__r!=NULL && mdt.Document_Type_Doc_Class__r.size()>0){
                docclassmdt = mdt.Document_Type_Doc_Class__r;
                feildMap.put('docClass',docclassmdt[0].Label);
                if(doctypeWSName=='u_optum_physical_health_ltr'){
                    feildMap.put(('Global_Doc_Id'+doctypeWSName),documentId);
                }else{
                    feildMap.put(('Global_Doc_Id_'+doctypeWSName),documentId);
                }
               doc360Input.feildMap=feildMap;
               break;
            }
        }
    }
    string  urlIs = ACET_WebserviceUtils.generateDoc360URL(System.JSON.serialize(doc360Input));
    system.debug('###urlIs'+urlIs);
    return urlIs;       
  }
    
}