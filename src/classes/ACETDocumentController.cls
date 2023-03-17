public with sharing class ACETDocumentController {  
    public string documentId{get;set;}
    public string documentType{get;set;}    
    public String documentClass {get;set;}
    Public String bookOfBusinessTypeCode{get;set;}
    
    public String DocTempUrl {get;set;}
    public String AttachmentId {get;set;}
    public String IsDocSizeMoreThanOneMB {get;set;}
    public string encodedStringvalue {get;set;}
    public String IsIdCard;
    public Boolean IsNotId{get;set;}
    
    public String selectAddress{get;set;}
    public Boolean showSubmitBtnAOF{get;set;}
    public Boolean showOriginatorMsg{get;set;}
    
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
    public string performaction{get;set;}
    public string recepientId{get;set;}
    public string recepientType {get;set;}
    public string idQualifier {get;set;}
    
    public ACETHighlightsPanelAdditionalInfo AdditionalInfoData{get;set;}
    public String Flow {get;set;}
    public Boolean IsMemberFocus {get;set;}
    public Boolean IsGroupFocus {get;set;}
    
    public Interaction__c Interaction{get;set;}
    
    public String documentDeliveryResult {get;set;}
    public String unencodedDocTypeWSName; //Modified by Team-Styx Raviteja on June 11 2021
    public ACETDocumentController(){   
        performaction = ApexPages.currentPage().getParameters().get('performaction'); 
        system.debug('performaction -->'+performaction);  
       
        documentId = ApexPages.currentPage().getParameters().get('DocId');                     
        documentType = ApexPages.currentPage().getParameters().get('docType'); 
        system.debug('documentId '+documentId );
        system.debug('documentType '+documentType );
        
        system.debug('ApexPages.currentPage().getParameters() is '+ApexPages.currentPage().getParameters());
        
        isIdCard = ApexPages.currentPage().getParameters().get('idCard');             

        if(performaction =='1'){
            unencodedDocTypeWSName = ''; //Modified by Team-Styx Raviteja on June 11 2021
            Document_Type__mdt docTypeObj = [select Document_Type__c, WS_Field_Name__c from Document_Type__mdt where Document_Type__c= :documentType Limit 1];
            system.debug('docTypeObject>>>' + docTypeObj);
            if(docTypeObj!=null){
                unencodedDocTypeWSName = docTypeObj.WS_Field_Name__c;
            }
            System.debug('unencodedDocTypeWSName>>>' + unencodedDocTypeWSName);
            String unencodedString = 'doctype=' + unencodedDocTypeWSName + '&documentId=' + documentId;
            encodedStringvalue = EncodingUtil.base64Encode(blob.valueOf(unencodedString));
            system.debug('unencoded:' + unencodedString);
            system.debug('encoded:' + encodedStringValue);
       } 
        IsNotId = (IsIdCard == 'true')?false:true;
        
        String interactionId = ApexPages.currentPage().getParameters().get('interactionId');
        system.debug(documentId);
        system.debug(interactionId);
        
        showOriginatorMsg = false;
        selectAddress = 'AddressOnFile';
        
        AddOnFilePersonWrap = new PersonWrapper();
        
        Interaction = ACETMemberQueryUtil.queryInteraction(ApexPages.currentPage().getParameters().get('InteractionId'));
        system.debug('Interaction is '+Interaction);
        string addInfo = ApexPages.currentPage().getParameters().get('additionalInfo');
        if(!String.isEmpty(addInfo)){
            AdditionalInfoData = (ACETHighlightsPanelAdditionalInfo)JSON.deserialize(addInfo, ACETHighlightsPanelAdditionalInfo.class);
        }
          bookOfBusinessTypeCode = ApexPages.currentPage().getParameters().get('bookOfBusinessTypeCode');
        if(bookOfBusinessTypeCode == null &&  AdditionalInfoData !=null){
            bookOfBusinessTypeCode =AdditionalInfoData.bookOfBusinessTypeCode;
        } 
        try {
        Flow = getFlowName(); 
        }
        catch(exception ex){}
        system.debug(Flow); 
        system.debug('AdditionalInfoData is '+AdditionalInfoData);
        
        IsMemberFocus = (AdditionalInfoData !=null && !String.isEmpty(AdditionalInfoData.MemberID)); 
        
        system.debug('IsMemberFocus is '+IsMemberFocus);
        
        IsGroupFocus = false;
        if(Flow == 'Producer' && !IsMemberFocus){
            if(!String.isEmpty(ApexPages.currentPage().getParameters().get('groupID'))){
                IsGroupFocus = true;        
            }
        }
        
    }
     /**
    * @description US3385722 - Team Styx - Preparing Doc360 Document View URL
    * @author Raviteja | 06-11-2021
    * @return string 
    **/
    public String getDoc360URL(){
        String docId = ApexPages.currentPage().getParameters().get('DocId');
        return ACETLGT_DocumentController.getdoc360Url(docId,unencodedDocTypeWSName);
    }
    
    public PageReference fetchDoc(){
       if(performaction != '1'){
        String docId = ApexPages.currentPage().getParameters().get('DocId');
        String docContentType = ApexPages.currentPage().getParameters().get('docContentType');
        String isDocSizeMoreThanOneMB = ApexPages.currentPage().getParameters().get('isDocSizeMoreThanOneMB');
        isIdCard = ApexPages.currentPage().getParameters().get('idCard');       
        
        system.debug(docId);
        system.debug(docContentType);
        system.debug(isDocSizeMoreThanOneMB);
        
        if(!String.isEmpty(docId) && !String.isEmpty(docContentType) && isDocSizeMoreThanOneMB == 'false'){
            ACETGetDocWebservice service = new ACETGetDocWebservice();
            ACETWSCalloutResult ac = new ACETWSCalloutResult();
            if(IsIdCard == 'true')
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
                AttachmentId = a.Id;    
            }else{
                Apexpages.addMessage(new ApexPages.message(ac.MessageSeverity, ac.Message));    
            }       
        }
        else{
            Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, 'A manual document search is required.'));  
        }
        }
        return null;
        
    } 
    
    public void resendSelectedDocs(){  
        ACETDocRedeliveryWebservice ACETDCWS = new ACETDocRedeliveryWebservice();
        ACETWSCalloutResult docRedeliveryCalloutResult = new ACETWSCalloutResult ();        
        
        system.debug('selected address: ' + selectAddress);
              
        system.debug(recepientType);
        system.debug(AddOnFilePersonWrap);
        
        String redeliveryId = 'ACET-' + system.now().getTime();
        ACETDocRedeliveryRequest docRedeliveryReq = new ACETDocRedeliveryRequest();
        docRedeliveryReq.redeliveryID = redeliveryId;
        docRedeliveryReq.recepientId  = recepientId;
        docRedeliveryReq.idQualifier  = idQualifier;
        docRedeliveryReq.recepientType= recepientType;
        docRedeliveryReq.docClass     = documentClass;
		docRedeliveryReq.docId        = documentId;
		docRedeliveryReq.bookOfBusinessTypeCode = bookOfBusinessTypeCode;	 
        if(selectAddress.contains('AddressOnFile')){
            docRedeliveryReq.perAdd1 = AddOnFilePersonWrap.personAddOne;
            docRedeliveryReq.perAdd2 = AddOnFilePersonWrap.personAddTwo;
            docRedeliveryReq.perCity = AddOnFilePersonWrap.personCity;
            docRedeliveryReq.perState= AddOnFilePersonWrap.personState;
            docRedeliveryReq.perZip  = AddOnFilePersonWrap.personZipCode;
            docRedeliveryReq.fName = String.IsBlank(AddOnFilePersonWrap.personFirstName)?AddOnFilePersonWrap.personOrganization:AddOnFilePersonWrap.personFirstName;
            docRedeliveryReq.lName = String.IsBlank(AddOnFilePersonWrap.personLastName)?'.':AddOnFilePersonWrap.personLastName;
            
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
            docRedeliveryReq.fName = String.isBlank(personFirstNameAA)?personOrganizationAA:personFirstNameAA;
            docRedeliveryReq.lName =  String.isBlank(personLastNameAA)?'.':personLastNameAA;
           
            //Modified by Team-Styx Hasara on July 02 2021 For Adding '.' after 'Jr' or 'Sr'
            docRedeliveryReq.suffix = checkSuffix(personSuffixAA);  
            //Modified by Team-Styx Hasara on July 02 2021 For personMiddleName null check
            docRedeliveryReq.mName = checkMiddlename(personMiddleNameAA);
                
        }
        docRedeliveryCalloutResult = ACETDCWS.docRedeliveryWS(docRedeliveryReq);
        if(docRedeliveryCalloutResult.success){ 
            ACETCommunicationSearchResult selComResult = (ACETCommunicationSearchResult)docRedeliveryCalloutResult.Response;
            documentDeliveryResult = 'Resend Submitted: ' + 'Document ' + documentId + ' ' + selComResult.Resend_Status + ' ' + selComResult.Resend_Date_Time;
        }else{
            documentDeliveryResult = docRedeliveryCalloutResult.Message;
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
    public void initDocDelivery(){
    system.debug('Document Open time -->>'+system.now());
        showSubmitBtnAOF = false;
        showOriginatorMsg = false;
        
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
        
        system.debug('documentType is '+documentType);
        List<Document_Type_Flow__mdt> dtfs = [select Document_Type__r.WS_Field_Name__c, Document_Type__r.Document_Type__c, WS_Backup_Address_Type__c, WS_Primary_Address_Type__c,isAlternateAddress__c, Subscriber_Only__c from Document_Type_Flow__mdt where Flow__c = :flow and Is_Member_Focus__c = :isMemberFocus and Document_Type__r.Document_Type__c = :documentType];
        system.debug('dtfs is '+dtfs);
        Document_Type_Flow__mdt selectDocFlow;
        if(dtfs.size() > 0){
            selectDocFlow = dtfs[0];
            documentClass = dtfs[0].Document_Type__r.WS_Field_Name__c;      
        }
        system.debug('selectDocFlow-->'+selectDocFlow);
        system.debug('Flow-->' + Flow);
        system.debug('IsGroupFocus is '+IsGroupFocus);
        if(Flow!=null && selectDocFlow!=null){
            if(Flow == 'Member' || (Flow != 'Provider' && selectDocFlow.isAlternateAddress__c == false && isMemberFocus)){
                findMemberInfo(selectDocFlow);
            }else if(Flow == 'Provider' || (isMemberFocus && Flow == 'Provider')){
                findProviderInfo(selectDocFlow); 
            }         
            else if(Flow == 'Group' || selectDocFlow.isAlternateAddress__c == true || IsGroupFocus){
                findGroupInfo(); 
            }
            else if(Flow == 'Producer'){
                findProducerInfo(selectDocFlow);          
            }else{
                showOriginatorMsg = true;  
            }
        }
        else{
            showOriginatorMsg = true;
        }
        
        system.debug(recepientId);
        system.debug(recepientType);
        
        if(showOriginatorMsg == false && String.isBlank(AddOnFilePersonWrap.personAddOne) &&  String.isBlank(AddOnFilePersonWrap.personCity) && String.isBlank(AddOnFilePersonWrap.personState) &&  String.isBlank(AddOnFilePersonWrap.personZipCode) && (String.isBlank(AddOnFilePersonWrap.personOrganization)|| (String.isBlank(AddOnFilePersonWrap.personFirstName) && String.isBlank(AddOnFilePersonWrap.personLastName)))){
            showSubmitBtnAOF = true;    
        }
        
        system.debug('true value--->'+ showOriginatorMsg +'----'+showSubmitBtnAOF);
        
    }
    
    public void findMemberInfo(Document_Type_Flow__mdt addType){
        ACETMemberDetail memberDetail = new ACETMemberDetail();
        memberDetail.SurrogateKey = ApexPages.currentPage().getParameters().get('SRK');        
        ACETGetIndividualWebService stub = new ACETGetIndividualWebService();
        ACETWSCalloutResult calloutResult ;
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
        if(mapAddress.get(addType.WS_Primary_Address_Type__c) != null){ 
            personAddOneAA = AddOnFilePersonWrap.personAddOne = mapAddress.get(addType.WS_Primary_Address_Type__c).AddressLine1;
            system.debug('Primary Address AddOnFilePersonWrap.personAddOne is '+AddOnFilePersonWrap.personAddOne);
            personAddTwoAA = AddOnFilePersonWrap.personAddTwo = mapAddress.get(addType.WS_Primary_Address_Type__c).AddressLine2;
            personCityAA = AddOnFilePersonWrap.personCity = mapAddress.get(addType.WS_Primary_Address_Type__c).City;
            personStateAA = AddOnFilePersonWrap.personState = mapAddress.get(addType.WS_Primary_Address_Type__c).State;
            personZipCodeAA = AddOnFilePersonWrap.personZipCode = mapAddress.get(addType.WS_Primary_Address_Type__c).Zip;
        }
        else if(mapAddress.get(addType.WS_Backup_Address_Type__c) != null){ 
            personAddOneAA = AddOnFilePersonWrap.personAddOne = mapAddress.get(addType.WS_Backup_Address_Type__c).AddressLine1;
            system.debug('Backup Address AddOnFilePersonWrap.personAddOne is '+AddOnFilePersonWrap.personAddOne);
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
                if(MemberDetailfamily!=null){
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
        if(addType.Subscriber_Only__c == true){
            system.debug('Inside Subscriber Only');
            map<String,ACETMemberDetail.Address> mapSubscriberAddress = new map<String,ACETMemberDetail.Address>();
            ACETFindMembershipWebservice MembershipWS = new ACETFindMembershipWebservice();
            ACETWSCalloutResult memshipResult = MembershipWS.findMembership(AdditionalInfoData.MemberId, memberDetail);
            ACETMemberDetail MemberDetailMembership = new ACETMemberDetail();
            MemberDetailMembership = (ACETMemberDetail)memshipResult.Response;
            ACETGetFamilyMemberWebService Family = new ACETGetFamilyMemberWebService();
            ACETWSCalloutResult res = Family.getFamilyMembers(AdditionalInfoData.MemberId,MemberDetailMembership);
            ACETMemberDetail MemberDetailfamily = (ACETMemberDetail)res.Response;
            if(MemberDetailfamily != null && MemberDetailfamily.FamilyMembers.size() > 0){
                for(ACETMemberDetail.FamilyMember fm : MemberDetailfamily.FamilyMembers){
                    if(fm.relationship == '18')
                    {
                        recepientId = fm.subscriberIndividualId;
                        personFirstNameAA = AddOnFilePersonWrap.personFirstName = fm.FirstName;
                        personMiddleNameAA = AddOnFilePersonWrap.personMiddleName = checkMiddlename(fm.MiddleInitial);
                        PersonLastNameAA = AddOnFilePersonWrap.PersonLastName = fm.LastName;
                        PersonSuffixAA = AddOnFilePersonWrap.PersonSuffix = fm.Suffix;
                        if(fm.Addresses != null){         
                            for(ACETMemberDetail.Address address : fm.Addresses){
                                mapSubscriberAddress.put(address.AddressType , address);      
                            }}
                        if(mapSubscriberAddress.get(addType.WS_Primary_Address_Type__c) != null){ 
                            personAddOneAA = AddOnFilePersonWrap.personAddOne = mapSubscriberAddress.get(addType.WS_Primary_Address_Type__c).AddressLine1;
                            system.debug('Primary Address AddOnFilePersonWrap.personAddOne is '+AddOnFilePersonWrap.personAddOne);
                            personAddTwoAA = AddOnFilePersonWrap.personAddTwo = mapSubscriberAddress.get(addType.WS_Primary_Address_Type__c).AddressLine2;
                            personCityAA = AddOnFilePersonWrap.personCity = mapSubscriberAddress.get(addType.WS_Primary_Address_Type__c).City;
                            personStateAA = AddOnFilePersonWrap.personState = mapSubscriberAddress.get(addType.WS_Primary_Address_Type__c).State;
                            personZipCodeAA = AddOnFilePersonWrap.personZipCode = mapSubscriberAddress.get(addType.WS_Primary_Address_Type__c).Zip;
                        }
                        else if(mapSubscriberAddress.get(addType.WS_Backup_Address_Type__c) != null){ 
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
        
        recepientType = 'Member';
        idQualifier = 'MemberID';
    }
    
    public void findGroupInfo(){
        ACETGroupDetail groupDetails = new ACETGroupDetail();
        String groupNumber = ApexPages.currentPage().getParameters().get('groupID');
        ACETGetEmployerDetailAdapterWebService stubData = new ACETGetEmployerDetailAdapterWebService();
        system.debug('Additionalinfodata.GroupN is '+Additionalinfodata.GroupNumber);
        ACETWSCalloutResult responseData = stubData.GetEmployerGroupDetail(groupNumber);
        
        if(responseData.Success){
            groupDetails = (ACETGroupDetail)responseData.response;
            system.debug('groupDetails.groupAddressInfoList is '+groupDetails.groupAddressInfoList);
            map<String,ACETGroupDetail.AddressInfo> mapAddress = new map<String,ACETGroupDetail.AddressInfo>();
            for(ACETGroupDetail.AddressInfo address : groupDetails.groupAddressInfoList){
                if(address.addrType.contains('Physical')){
                    mapAddress.put('Physical', address);     
                }
                else if(address.addrType.contains('Corporate')){
                    mapAddress.put('Corporate', address); 
                }
            }
            system.debug('mapAddress is '+mapAddress);
            if(mapAddress.get('Physical') != null){ 
                system.debug('mapAddress.get is '+mapAddress.get('Physical').addrLine1);
                
                personAddOneAA = AddOnFilePersonWrap.personAddOne = mapAddress.get('Physical').addrLine1;
                system.debug('AddOnFilePersonWrap.personAddOne is '+AddOnFilePersonWrap.personAddOne);
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
        }
    }
    
    public void findProducerInfo(Document_Type_Flow__mdt addType){
        ACETGetProducerAPI callWebservice = new ACETGetProducerAPI();
        system.debug('producerId is '+ApexPages.currentPage().getParameters().get('producerId'));
        ACETWSCalloutResult responseData = callWebservice.GetProducer(AdditionalInfoData.producerId);
        ACETProducerResult producerDetails = new ACETProducerResult();
        
        if(responseData.Success){
            producerDetails = (ACETProducerResult)responseData.Response;
            system.debug('producerDetails--->'+producerDetails);
            
            map<String,ACETProducerResult.ACETProducerDemography> mapAddress = new map<String,ACETProducerResult.ACETProducerDemography>();
            for(ACETProducerResult.ACETProducerDemography address : producerDetails.addresslist){
                mapAddress.put(address.addressType , address);     
            }
            if(mapAddress.get(addType.WS_Primary_Address_Type__c) != null){ 
                personAddOneAA = AddOnFilePersonWrap.personAddOne = mapAddress.get(addType.WS_Primary_Address_Type__c).streetAddress;
                personCityAA = AddOnFilePersonWrap.personCity = mapAddress.get(addType.WS_Primary_Address_Type__c).City;
                personStateAA = AddOnFilePersonWrap.personState = mapAddress.get(addType.WS_Primary_Address_Type__c).State;
                personZipCodeAA = AddOnFilePersonWrap.personZipCode = mapAddress.get(addType.WS_Primary_Address_Type__c).Zip;
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
            recepientId = providerDetail[0].providerId;
            recepientType = 'Provider';
            idQualifier = 'ProviderID';
            
            map<String,ACETProviderLookupController.ProviderLookupResult> mapAddress = new map<String,ACETProviderLookupController.ProviderLookupResult>();
            for(ACETProviderLookupController.ProviderLookupResult address : providerDetail){
                mapAddress.put(address.addressTypeCode , address);      
            }
            
            system.debug(mapAddress);
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
    }
    
    public String getFlowName(){
        if(Interaction.Originator_Type__c == 'Member'){
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
    
    public String getProfileName() {
        Profile profileName = [select id, Name from Profile where Id =: UserInfo.getProfileId()];
        return profileName.Name;
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
    
    @RemoteAction
    public static String getDocContent(String attachmentId){
        Attachment a = [select body from Attachment where Id = :attachmentId];
        return EncodingUtil.base64Encode(a.body);       
    }
    
}