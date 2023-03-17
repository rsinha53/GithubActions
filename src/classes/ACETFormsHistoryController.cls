public with sharing class ACETFormsHistoryController extends ACETErrorHandler{
    
    public String BusinessUnit { get; set;}
    public List<SelectOption> BUnitOptions {get; set;}
    public Set<SelectOption> DocTypeOptions {get; set;}
    Public String source {get;set;}
    Public String doctype {get;set;}
    public String neworder {get;set;}
    public String orderhistory {get;set;}
    public string order {get;set;}
    public boolean successmessage{set;get;}
    public String bookOfBusinessTypeCode{set;get;}
    public ACETDatatableWrapper DTWrapper {get;set;}
    
    public personWrapper AddOnFilePersonWrap{get;set;}
    
    public ACETCallTopicsDataWrapper wrapper {get;set;}
    
    public Interaction__c Interaction {get; set;}
    public Interaction__c startdate {get;set;}
    public String enddate {get;set;}
    
    Public Boolean isSuccess{get;set;}
    
    public Boolean chooseAddress{get;set;}//Swetha
    public Boolean isLevelFunded{get;set;}
    public String personOrganizationAA1{get;set;}
    public String personOrganizationAA2{get;set;}
    public String personFirstNameAA{get;set;}
    public String personMiddleNameAA{get;set;}
    public String personLastNameAA{get;set;}
    public String personSuffixAA{get;set;}
    public String personAddOneAA{get;set;}
    public String personAddTwoAA{get;set;}
    public String personCityAA{get;set;}
    public String personStateAA{get;set;}
    public String personZipCodeAA{get;set;}
    public String selectAddress{get;set;}
    
    public string recepientId{get;set;}
    public string idQualifier{get;set;}
    public string recipientType{get;set;}
    
    public boolean displayhistoryresults{get;set;}
    
    public List<ACETFormsHistoryResult>  formshistory{ set; get; }
    public Boolean showSubmit {get;set;}
    
    public ACETHighlightsPanelAdditionalInfo AdditionalInfo {get;set;}
    public contact subject {get; set;}
    public String hpAdditionInfoStr {get{
        return JSON.serialize(AdditionalInfo);
    }set;}   
    
    public list<MaterialForms> vListMaterialsForms {get; set;}
    
    public ACETFormsHistoryController(){
        
    }
    
    public void changeOrderDate(){
        startdate.tst_Date_Field__c = Date.today()-30;
        Date d = startdate.tst_Date_Field__c+30;
        String dt = DateTime.newInstance(d.year(),d.month(),d.day()).format('M/dd/YYYY');
        enddate = dt;
        formshistory = new List<ACETFormsHistoryResult>();
    }
    
    public void init()
    { 
        try{
            selectAddress = 'AddressOnFile';
            chooseAddress = true;
            showSubmit = false;
            AddOnFilePersonWrap = new PersonWrapper();
            Interaction = ACETMemberQueryUtil.queryInteraction(ApexPages.currentPage().getParameters().get('InteractionId'));
            string addInfo = ApexPages.currentPage().getParameters().get('additionalInfo');
            if(addInfo != null){
                AdditionalInfoData  = (ACETHighlightsPanelAdditionalInfo)JSON.deserialize(addInfo, ACETHighlightsPanelAdditionalInfo.class);
            }
            system.debug('AdditionalInfoData---->'+AdditionalInfoData);
            Interaction = ACETMemberQueryUtil.queryInteraction(ApexPages.currentPage().getParameters().get('InteractionId'));
            
            wrapper = new ACETCallTopicsDataWrapper();
            wrapper.CallTopic ='Materials Request'; 
            wrapper.init();
            wrapper.CaseObj.Topic__c = 'Materials Request';
            String strSurrogateKey = apexpages.currentpage().getparameters().get('SRK');
            wrapper.SurrogateKey = strSurrogateKey;
            System.debug('wrapper.SurrogateKey--'+wrapper.SurrogateKey);
            startdate = new Interaction__c();
            source = 'ACET';
            doctype = '--None--';
            order = 'New Order';
            BusinessUnit = 'None';
            displayhistoryresults = false;
            orderhistory = 'Order History';
            startdate.tst_Date_Field__c = Date.today()-30;
            Date d = startdate.tst_Date_Field__c+30;
            String dt = DateTime.newInstance(d.year(),d.month(),d.day()).format('M/dd/YYYY');
            enddate = dt;
            formshistory = Null;
             bookOfBusinessTypeCode = ApexPages.currentPage().getParameters().get('bookOfBusinessTypeCode');
               if(bookOfBusinessTypeCode == 'LF' || bookOfBusinessTypeCode=='OL'){
                isLevelFunded = true; 
               }else{
                isLevelFunded = false; 
               }
            
            system.debug('Params is '+Apexpages.currentPage().getparameters());
            String interactionId = ApexPages.currentPage().getParameters().get('interactionId'); 
            String contactId = ApexPages.currentPage().getParameters().get('contactId');
            System.debug('Testing'+contactId+interactionId);
            if(Interaction.Originator_Type__c == 'Member'){
             
                findMemberInfo();
                BusinessUnit = 'Member';
                MaterialForms();
                
            }
            else if(Interaction.Originator_Type__c == 'Group/Employer' || Interaction.Originator_Type__c == 'Broker' || Interaction.Originator_Type__c == 'General Agent' || Interaction.Originator_Type__c == 'UHG' || Interaction.Originator_Type__c == 'Third Party'){
                if(AdditionalInfoData.isMember != null && AdditionalInfoData.isMember.contains('false')){
                    findMemberInfo();
                    BusinessUnit = 'Member';        
                    MaterialForms();
                }
                else{
                    findGroupInfo();
                    BusinessUnit = 'Group';
                    MaterialForms();
                }        
            }
            else if(Interaction.Originator_Type__c == 'Producer'){
                if(AdditionalInfoData.isMember != null && AdditionalInfoData.isMember.contains('false'))
                {
                    findMemberInfo();
                    BusinessUnit = 'Producer';
                    MaterialForms();
                }
                else if(AdditionalInfoData.isGroup != null && AdditionalInfoData.isGroup.contains('false')) {
                    findGroupInfo();
                    BusinessUnit = 'Producer';
                    MaterialForms();
                }
                else {
                    findProducerInfo();
                    BusinessUnit = 'Producer';
                    MaterialForms();
                    
                }    
            }
            else if(Interaction.Originator_Type__c == 'Provider'){
                if(AdditionalInfoData.isMember  != null && AdditionalInfoData.isMember.contains('false')){
                    findMemberInfo();
                    BusinessUnit = 'Provider';
                    MaterialForms();
                }
                else {
                    findProviderInfo();
                    BusinessUnit = 'Provider';
                    MaterialForms();
                    
                }
            }
            //Check if User is redirected to Member Search page from Provider detail page          
            if (!String.isEmpty(interactionId)){                        
                system.debug('InteractionId: ' + InteractionId);
                Interaction = ACETProviderUtility.GetInteractionByID(interactionId);   
            }
            if(!String.isEmpty(contactId)) {
                Subject = ACETProviderUtility.GetContactByID(contactId);
            }
        }
        catch(Exception ex){
            
            system.debug('Exception @@ '+ ex.getLineNumber());
        }
        
        
    }
    
    public ACETHighlightsPanelAdditionalInfo AdditionalInfoData{get;set;}
    
    public void clearsearch(){
        displayhistoryresults = false;
        order  = 'Order History';
        displayhistoryresults = false;
        orderhistory = 'Order History';
        startdate.tst_Date_Field__c = Date.today()-30;
        Date d = startdate.tst_Date_Field__c+30;
        String dt = DateTime.newInstance(d.year(),d.month(),d.day()).format('M/dd/YYYY');
        enddate = dt;
        formshistory = Null;
        source = 'ACET';
    }
    
    public void Search(){
        displayhistoryresults = true;
        formshistory = new List<ACETFormsHistoryResult>();
        if(order.equalsignorecase('Order History')){
            ACETFormsHistoryWebServiceFF formsHistoryWebService = new ACETFormsHistoryWebServiceFF();
            formsHistoryWebService.init(source,10700,String.valueOf(startdate.tst_Date_Field__c),String.valueOf(enddate),recepientId,idQualifier);    
            ACETWSCalloutResult searchResult =  formsHistoryWebService.queryPaginatedData(1,1,1);
            if(searchResult.Response!= null){
            	if(searchResult.statusCode==200 && searchResult.Success) {
                    formshistory.addAll( (List<ACETFormsHistoryResult>) searchResult.Response);
            	}
            	else {
            		if(searchResult.statusCode==400) {
                    	setErrorMsg('GN400B');
            		}
            		else if(searchResult.statusCode==200 && !searchResult.success) {
            			setErrorMsg('MR200');
            		}
            		else if(searchResult.statusCode==404) {
            			setErrorMsg('MR404');
            		}
            		else{
            			setErrorMsg('GN'+searchResult.statusCode);
            		}
            	}
            }
        }
        order = 'Order History';
    }
    
    public void calculateEnddate(){
        if(startdate.tst_Date_Field__c != null){
            Date d = startdate.tst_Date_Field__c+30;
            String dt = DateTime.newInstance(d.year(),d.month(),d.day()).format('M/dd/YYYY');
            enddate = dt;
        }
    }
    
    public List<SelectOption> getBusinessUnitValues() {
        BUnitOptions = new List<SelectOption>();
        try{
            Schema.DescribeFieldResult fieldResult = Material_Forms__c.Business_Unit__c.getDescribe();
            List<Schema.PicklistEntry> BusinessUnitValues = fieldResult.getPicklistValues();
            for( Schema.PicklistEntry f : BusinessUnitValues)
            {  
    //skip the Group option for Member flow and for all the Member in focus
         if((f.getValue()=='Group')){
                    if(Interaction.Originator_Type__c == 'Member'){
                        
                    }
                    
                    else if(Interaction.Originator_Type__c == 'Group/Employer' || Interaction.Originator_Type__c == 'Broker' || Interaction.Originator_Type__c == 'General Agent' || Interaction.Originator_Type__c == 'UHG' || Interaction.Originator_Type__c == 'Third Party'){
                        if(AdditionalInfoData.isMember != null && AdditionalInfoData.isMember.contains('false')){
                            
                        }
                        else{
                            BUnitOptions.add(new SelectOption(f.getLabel(), f.getValue()));
                        }
                    }
                    else if(Interaction.Originator_Type__c == 'Producer'){
                        if(AdditionalInfoData.isMember != null && AdditionalInfoData.isMember.contains('false')){
                            
                        }
                        else{
                            BUnitOptions.add(new SelectOption(f.getLabel(), f.getValue()));
                        }
                    }
                    else if(Interaction.Originator_Type__c == 'Provider'){
                        if(AdditionalInfoData.isMember  != null && AdditionalInfoData.isMember.contains('false')){
                            
                        }
                        else{
                            BUnitOptions.add(new SelectOption(f.getLabel(), f.getValue()));
                        }
                    }

                                  
                }
                else{
                    BUnitOptions.add(new SelectOption(f.getLabel(), f.getValue()));
                }
            }
        }
        catch(Exception ex){
            system.debug('Exception @@ '+ ex.getLineNumber());
        }
        
        return BUnitOptions;
    }
    
    public List<SelectOption> getdocumentTypeValues() {
        
        DocTypeOptions = new Set<SelectOption>();
        List<SelectOption> FinalValues = new List<SelectOption>();
        DocTypeOptions.add(new SelectOption('None','--None--'));
        for(Material_Forms__c vMForms : [SELECT Id,FulfillmentType__c,FulfillmentType_Description__c FROM Material_Forms__c]){          
            DocTypeOptions.add(new SelectOption(vMForms.FulfillmentType__c, vMForms.FulfillmentType_Description__c));
        }
        FinalValues.addAll(DocTypeOptions);             
        return FinalValues;
    }
    
public class MaterialForms {
    public list < Material_Forms__c > LstMaterialForms {
      get;
      set;
    }
    public string CategoryName {
      get;
      set;
    }

    public MaterialForms(Material_Forms__c vMForms) {
      CategoryName = vMForms.Category__c;
      LstMaterialForms = new list < Material_Forms__c > {
        vMForms
      };
    }
  }
    public Map < string, Material_Forms__c > getMaterialForms() {
    Transient Map < string, Material_Forms__c > vLstMaterialForms = new Map < string, Material_Forms__c > ();
    vListMaterialsForms = new list < MaterialForms > ();
    map < string, MaterialForms > mapMaterialForms = new map < string, MaterialForms > ();
    system.debug('mapMaterialForms-->'+mapMaterialForms);
    system.debug('vListMaterialsForms@@@@@@  ' + vListMaterialsForms);
    system.debug('BusinessUnit@@@@@@  ' + BusinessUnit);
        system.debug('bookOfBusinessTypeCode--->'+bookOfBusinessTypeCode);
    try {
      for (Material_Forms__c vMForms: [SELECT Id, Business_Unit__c, Category__c, Document_Title__c, Document_URL__c, FulfillmentType__c, MRE__c, Quantity__c, Service_Level__c FROM Material_Forms__c where Business_Unit__c =: BusinessUnit ORDER BY Category__c ASC, Document_Title__c ASC]) {
                    if (bookOfBusinessTypeCode !=null && mapMaterialForms.get(vMForms.Category__c) == null  && vMForms.Service_Level__c != null && vMForms.Service_Level__c.contains(bookOfBusinessTypeCode)){
                      mapMaterialForms.put(vMForms.Category__c, new MaterialForms(vMForms));
                      vListMaterialsForms.add(mapMaterialForms.get(vMForms.Category__c));
                      }
                      else if (bookOfBusinessTypeCode ==null && mapMaterialForms.get(vMForms.Category__c) == null && vMForms.Service_Level__c != 'OL' && vMForms.Service_Level__c != 'LF'){
                       mapMaterialForms.put(vMForms.Category__c, new MaterialForms(vMForms));
                      vListMaterialsForms.add(mapMaterialForms.get(vMForms.Category__c));
                      }
                     else if (bookOfBusinessTypeCode !=null && mapMaterialForms.get(vMForms.Category__c) != null &&  vMForms.Service_Level__c != null && vMForms.Service_Level__c.contains(bookOfBusinessTypeCode)){
                     mapMaterialForms.get(vMForms.Category__c).LstMaterialForms.add(vMForms);
                     }
                    else if (bookOfBusinessTypeCode ==null && mapMaterialForms.get(vMForms.Category__c) != null  && vMForms.Service_Level__c != 'OL' && vMForms.Service_Level__c != 'LF'){
                     mapMaterialForms.get(vMForms.Category__c).LstMaterialForms.add(vMForms);
                     }           
             }
      system.debug('mapMaterialForms@@@@@@  ' + mapMaterialForms.size());

   } catch (Exception ex) {
      system.debug('Exception@@ ' + ex.getLineNumber());
    }
    return vLstMaterialForms;
  }
    
    public PageReference MaterialForms() {
       
        getMaterialForms();
        return null;
    }
    public void findMemberInfo(){
        system.debug('findMemberInfo--->');  
        ACETMemberDetail memberDetail = new ACETMemberDetail();
        memberDetail.SurrogateKey = ApexPages.currentPage().getParameters().get('SRK');
        System.debug('memberDetail.SurrogateKey---'+memberDetail.SurrogateKey);
        ACETGetIndividualWebService stub = new ACETGetIndividualWebService();
        ACETWSCalloutResult calloutResult ;
        if(!String.isEmpty(MemberDetail.SurrogateKey)){
            calloutResult = stub.getIndividual(MemberDetail.SurrogateKey, MemberDetail);     
        } 
        else {
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
        if(mapAddress.get('Mailing') != null){ 
            personAddOneAA = AddOnFilePersonWrap.personAddOne = mapAddress.get('Mailing').AddressLine1;
            personAddTwoAA = AddOnFilePersonWrap.personAddTwo = mapAddress.get('Mailing').AddressLine2;
            personCityAA = AddOnFilePersonWrap.personCity = mapAddress.get('Mailing').City;
            personStateAA = AddOnFilePersonWrap.personState = mapAddress.get('Mailing').State;
            personZipCodeAA = AddOnFilePersonWrap.personZipCode = mapAddress.get('Mailing').Zip;
        }
        else if(mapAddress.get('Home') != null){ 
            personAddOneAA = AddOnFilePersonWrap.personAddOne = mapAddress.get('Home').AddressLine1;
            personAddTwoAA = AddOnFilePersonWrap.personAddTwo = mapAddress.get('Home').AddressLine2;
            personCityAA = AddOnFilePersonWrap.personCity = mapAddress.get('Home').City;
            personStateAA = AddOnFilePersonWrap.personState = mapAddress.get('Home').State;
            personZipCodeAA = AddOnFilePersonWrap.personZipCode = mapAddress.get('Home').Zip;
        }
        if(memberDetail.age!= null){
            if(Integer.valueof(memberDetail.age) > 12){
                recepientId = AdditionalInfoData.MemberId;
                system.debug('AdditionalInfoData@@@@@ '+AdditionalInfoData);
                idQualifier = 'MemberID';
                recipientType = 'Member';
                personFirstNameAA = AddOnFilePersonWrap.personFirstName = memberDetail.FirstName;
                personMiddleNameAA = AddOnFilePersonWrap.personMiddleName = memberDetail.MiddleName;
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
                ACETMemberDetail MemberDetailfamily = new ACETMemberDetail();
                idQualifier = 'MemberID';
                recipientType = 'Member';
                MemberDetailfamily = (ACETMemberDetail)res.Response;
                if(MemberDetailfamily != null){
                    for(ACETMemberDetail.FamilyMember fm : MemberDetailfamily.FamilyMembers){
                        if(fm.relationship == '18')
                        {
                            recepientId = fm.subscriberIndividualId;
                            personFirstNameAA = AddOnFilePersonWrap.personFirstName = fm.FirstName;
                            personMiddleNameAA = AddOnFilePersonWrap.personMiddleName = fm.MiddleInitial;
                            PersonLastNameAA = AddOnFilePersonWrap.PersonLastName = fm.LastName;
                            PersonSuffixAA = AddOnFilePersonWrap.PersonSuffix = fm.Suffix;
                        }
                    }
                }
                system.debug('ACETWSCalloutResult is '+res);
            }
        }
        
    }
    public void findGroupInfo(){
        ACETGroupDetail groupDetails = new ACETGroupDetail();
        String groupNumber = ApexPages.currentPage().getParameters().get('groupID');
        ACETGetEmployerDetailAdapterWebService stubData = new ACETGetEmployerDetailAdapterWebService();
        ACETWSCalloutResult responseData = new ACETWSCalloutResult();
        if(!Test.isRunningTest()){  
            responseData = stubData.GetEmployerGroupDetail(groupNumber);
        }
        if(Test.isRunningTest()){  
            responseData = stubData.GetEmployerGroupDetail(groupNumber);
            
            responseData.Attach=null; 
            responseData.Message='Success';
            responseData.MessageSeverity=null;
            responseData.Success=true; 
            responseData.pageNumber='0'; 
            responseData.pageSize='50'; 
            responseData.recordCount='0'; 
            responseData.totalCount='0'; 
            responseData.totalPages='0';
        }
        system.debug('===responseData'+responseData);
        system.debug('===responseData.response'+responseData.response);
        groupDetails = (ACETGroupDetail)responseData.response;
        system.debug('===groupDetails'+groupDetails);
        system.debug('===groupDetails.groupAddressInfoList'+groupDetails.groupAddressInfoList);
        if((!Test.isRunningTest() && responseData.Success) || Test.isRunningTest()){
            
            
            map<String,ACETGroupDetail.AddressInfo> mapAddress = new map<String,ACETGroupDetail.AddressInfo>();
            for(ACETGroupDetail.AddressInfo address : groupDetails.groupAddressInfoList){
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
            personOrganizationAA1 = AddOnFilePersonWrap.personOrganization1 = groupDetails.genGroupInfo.groupName;
            recepientId = groupDetails.genGroupInfo.groupId;
            idQualifier = 'GroupID';
            recipientType = 'Group';
        }
    }
    
    public void findProducerInfo(){
        ACETGetProducerAPI callWebservice = new ACETGetProducerAPI();
        ACETWSCalloutResult responseData = callWebservice.GetProducer(ApexPages.currentPage().getParameters().get('producerId'));
        ACETProducerResult producerDetails = new ACETProducerResult();
        
        if(responseData.Success){
            producerDetails = (ACETProducerResult)responseData.Response;
            system.debug('producerDetails--->'+producerDetails);
            
            map<String,ACETProducerResult.ACETProducerDemography> mapAddress = new map<String,ACETProducerResult.ACETProducerDemography>();
            for(ACETProducerResult.ACETProducerDemography address : producerDetails.addresslist){
                mapAddress.put(address.addressType , address);     
            }
            system.debug('producer>>'+mapAddress);
            if(mapAddress.get('M') != null){ 
                personAddOneAA = AddOnFilePersonWrap.personAddOne = mapAddress.get('M').streetAddress;
                personCityAA = AddOnFilePersonWrap.personCity = mapAddress.get('M').City;
                personStateAA = AddOnFilePersonWrap.personState = mapAddress.get('M').State;
                personZipCodeAA = AddOnFilePersonWrap.personZipCode = mapAddress.get('M').Zip;
            }
            else if(mapAddress.get('B') != null){ 
                personAddOneAA = AddOnFilePersonWrap.personAddOne = mapAddress.get('B').streetAddress;
                personCityAA = AddOnFilePersonWrap.personCity = mapAddress.get('B').City;
                personStateAA = AddOnFilePersonWrap.personState = mapAddress.get('B').State;
                personZipCodeAA = AddOnFilePersonWrap.personZipCode = mapAddress.get('B').Zip;
            }
            personOrganizationAA1 = AddOnFilePersonWrap.personOrganization1 = producerDetails.CompanyName;
            personFirstNameAA = AddOnFilePersonWrap.personFirstName = producerDetails.firstName;
            personMiddleNameAA = AddOnFilePersonWrap.personMiddleName = producerDetails.MiddleInitial;
            personLastNameAA = AddOnFilePersonWrap.PersonLastName =   producerDetails.lastName;
            recepientId = producerDetails.legacyBrokerCode;
            idQualifier = 'ProducerID';
            recipientType = 'Producer';
        }
    }
    
    public void findProviderInfo(){
        ACETWSCalloutResult CalloutResult;
        ACETFindHCOWebservice ACTFHCOWS = new ACETFindHCOWebservice();
        ACETFindHCPWebservice ACTFHCPWS = new ACETFindHCPWebservice();
        
        List<ACETProviderLookupController.ProviderLookupResult> providerDetail = new List<ACETProviderLookupController.ProviderLookupResult>();
        
        String ProvTypeCode = ApexPages.currentPage().getParameters().get('ProvTypeCode');
        if(String.isBlank(ProvTypeCode)){
            ProvTypeCode = AdditionalInfoData.providerType; // Provider(Member in focus)--- PRA
        }
        system.debug('ProvTypeCode--->'+ProvTypeCode);
        if (ProvTypeCode!= Null && ProvTypeCode == 'HCO') {
            CalloutResult = ACTFHCOWS.FindHCO(Interaction.Originator__r.Tax_ID__c,null,Interaction.Originator__r.EID__c,null,'',null,null,'','',null,null,null,null,null,null,null,null,null,null);   
            
        } else {
            CalloutResult = ACTFHCPWS.FindHCP(Interaction.Originator__r.Tax_ID__c, null, Interaction.Originator__r.EID__c, null, '', null, null,null,null, '', '', null,null, null, null, null, null, null, null, null, null);
        }
        system.debug('CalloutResult is '+CalloutResult);
        if (CalloutResult.Success) {
            providerDetail = (List<ACETProviderLookupController.ProviderLookupResult>)CalloutResult.Response;
            system.debug('ProviderDetail*****'+providerDetail);
            if(ProvTypeCode == 'HCO'){
                personOrganizationAA1 = AddOnFilePersonWrap.personOrganization1 = providerDetail[0].fullName ;
            }
            else{
                personFirstNameAa = AddOnFilePersonWrap.personFirstName = providerDetail[0].firstName ;
                personMiddlenameAA = AddOnFilePersonWrap.personMiddlename = providerDetail[0].MiddleName ;
                personLastNameAA = AddOnFilePersonWrap.personLastName =providerDetail[0].lastName ;
                PersonSuffixAA = AddOnFilePersonWrap.PersonSuffix =providerDetail[0].suffix ;
            }
            recepientId = providerDetail[0].taxId;
            idQualifier = 'ProviderID';
            recipientType = 'Provider';
            map<String,ACETProviderLookupController.ProviderLookupResult> mapAddress = new map<String,ACETProviderLookupController.ProviderLookupResult>();
            for(ACETProviderLookupController.ProviderLookupResult address : providerDetail){
                mapAddress.put(address.addressTypeCode , address);      
            }
            System.debug('mapAddress---'+mapAddress);
            
            if(mapAddress.get('PRAC') != null){
                personAddOneAA = AddOnFilePersonWrap.personAddOne = mapAddress.get('PRAC').addressLine1;
                personAddTwoAa = AddOnFilePersonWrap.personAddTwo = mapAddress.get('PRAC').addressLine2;
                personCityAA = AddOnFilePersonWrap.personCity = mapAddress.get('PRAC').City;
                personStateAA = AddOnFilePersonWrap.personState = mapAddress.get('PRAC').state;
                personZipCodeAa = AddOnFilePersonWrap.personZipCode = mapAddress.get('PRAC').zipCode;
            }
            if(mapAddress.get('BIL') != null){
                personAddOneAA = AddOnFilePersonWrap.personAddOne = mapAddress.get('BIL').addressLine1;
                personAddTwoAa = AddOnFilePersonWrap.personAddTwo = mapAddress.get('BIL').addressLine2;
                personCityAA = AddOnFilePersonWrap.personCity = mapAddress.get('BIL').City;
                personStateAA = AddOnFilePersonWrap.personState = mapAddress.get('BIL').state;
                personZipCodeAa = AddOnFilePersonWrap.personZipCode = mapAddress.get('BIL').zipCode;
            }
            
            
        }
        
    }
    public class personWrapper{
        public String personOrganization1{get;set;}
        public String personOrganization2{get;set;}
        
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
    
    public Pagereference btnSubmit(){
        try{
            ACETProcessFulfillmentWebservice ACETPFWS = new ACETProcessFulfillmentWebservice();
            ACETWSCalloutResult proFulfillmentCalloutResult = new ACETWSCalloutResult ();
            List<Material_Forms__c> matForms = new list<Material_Forms__c>();
            for(MaterialForms clsmatform : vListMaterialsForms){
                for(Material_Forms__c matform :clsmatform.LstMaterialForms){
                    if(String.IsNOTBlank(matform.Quantity__c)){
                        matForms.add(matform);  
                    }
                }
            }
            if(selectAddress.contains('AddressOnFile')){
                proFulfillmentCalloutResult = ACETPFWS.processRedeliveryWS(recepientId, idQualifier ,recipientType, AddOnFilePersonWrap.personFirstName, AddOnFilePersonWrap.personMiddleName, AddOnFilePersonWrap.personLastName, AddOnFilePersonWrap.personSuffix, AddOnFilePersonWrap.personAddOne,AddOnFilePersonWrap.personAddtwo, AddOnFilePersonWrap.personCity, AddOnFilePersonWrap.personState,AddOnFilePersonWrap.personZipCode, matforms,AddOnFilePersonWrap.personOrganization1,AddOnFilePersonWrap.personOrganization2,BusinessUnit);
            }
            else if(selectAddress.contains('AlternateAddress')){
                system.debug('selectAddress is '+selectAddress);
                proFulfillmentCalloutResult = ACETPFWS.processRedeliveryWS(recepientId,idQualifier,recipientType, personFirstNameAA, personMiddleNameAA, personLastNameAA, personSuffixAA, personAddOneAA,personAddTwoAA, personCityAA, personStateAA,personZipCodeAA, matforms,personOrganizationAA1,personOrganizationAA2,BusinessUnit);
            }
            if(proFulfillmentCalloutResult.success != null && proFulfillmentCalloutResult.success ){ 
                if(proFulfillmentCalloutResult.Message.equalsIgnoreCase('Accepted')){
                    isSuccess = true;
                    ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Order submitted.'));  
                } 
                else{
                    isSuccess = false;
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Order failed.'));
                }
            }
            else {
            	if(proFulfillmentCalloutResult.statusCode==400) {
                	setErrorMsg('GN400B');
            	}
            	else if(proFulfillmentCalloutResult.statusCode==404) {
            		setErrorMsg('MR404');
            	}
            	else {
                	setErrorMsg('GN'+proFulfillmentCalloutResult.statusCode);
            	}
            }
//            else if(proFulfillmentCalloutResult!= null && !proFulfillmentCalloutResult.success && proFulfillmentCalloutResult.Message !=null){
//                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, proFulfillmentCalloutResult.Message));   
//            }
//            else{
//                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, label.ACETUnexpectedErrorMessage));   
//            }
        }
        catch(exception ex)
        {
            system.debug('Exception is '+ex.getMessage()+'at line '+ex.getLineNumber());
        }
        return null;
    }
    
    
    public void checkValidQuantity(){
        
        system.debug('vListMaterialsForms==='+vListMaterialsForms);
        system.debug('@@@@@@@@size of vlist material form:   '+vListMaterialsForms.size());        
        for(MaterialForms objMaterialForms : vListMaterialsForms){
            system.debug('size 2@@@@@@@@:   '+objMaterialForms.LstMaterialForms.size());
            for(Material_Forms__c objMaterial_Forms : objMaterialForms.LstMaterialForms){            
                if(String.isNotBlank(objMaterial_Forms.Quantity__c) && Integer.valueOf(objMaterial_Forms.Quantity__c) > 0){
                    showSubmit = true;
                }else {
                    showSubmit=false;
                }              
            }
        }
    }
    
    public String getProfileName() {
        Profile profileName = [select id, Name from Profile where Id =: UserInfo.getProfileId()];
        return profileName.Name;
    }
}