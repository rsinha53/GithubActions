public with sharing class ACETProducerSearchController {

    public String ProducerId { get;set; }
    public String FirstName { get;set; }
    public String producerTaxId {get; set;}
    
    public String producerTIN {get; set;}
    public String MiddleInitial {get; set;}
    public String Status {get; set;}
    public String legacyProducerSystem {get; set;}
    public String legacyProducerId {get; set;}
    public String customerNumber {get; set;}
    public String customerName {get; set;}
    public String adminSystem {get; set;}
   
    public String producerSSN {get; set;}
    public String LastName { get;set; }
    public String Companyname { get;set; }
    public string groupNumber {get;set;}
    public String FilterBy { get; set; }
    Public boolean Searched{ get;set; }
    Public string SortBy{ get;set; }
    public String State { get;set; }
    public String LastSortBy{ get;set; }
    public String SortOrder{ get;set; }
    public static string SourceOriginator{ get;set; }
    public static Contact Subject { get;set; }
    public static Interaction__c Interaction { get;set; }
    public String interactionIdAferInsert { get;set; }
    public String urlParam { get;set; }
    public String lastNameParam { get;set; }
    public String firstNameParam { get;set; }
    public String producerIdParam { get;set; }
    public String ErrorMessage { get;set; }
    public ACETDatatableWrapper DTWrapper {get;set;}
    
    Public List<ACETProducerSearchResult> ProducerSearchResults{get;set;}

    Public void sortTable(){
         if(LastSortBy != null){
            if(LastSortBy != SortBy){
                SortOrder = 'Asc';
            }else{
                SortOrder = (SortOrder == 'Asc'? 'Desc' : 'Asc');
            }
        }

        ACETProducerSearchResult.SortBy = SortBy;
        ACETProducerSearchResult.SortOrder = SortOrder;
        LastSortBy = SortBy;

    }

    public void doinit(){
     searched = false;
    }

    public void clear()
    {
      searched = false;
      State = '';
      ErrorMessage = null;
      DTWrapper = null;
    }

    Public void search()
    {
        try{
            SortBy = 'LastName';
            SortOrder = 'Asc';   
            ErrorMessage = null; 
            //added by Ranjit : vccd integration 
            string vccdParam = ApexPages.currentPage().getParameters().get('vccdParams');
            if(vccdParam != '' && vccdParam != null){
                ApexPages.currentPage().getParameters().put('noAutoSearch','true');
            }
    
            searched = true;
            ProducerSearchResults = null;
            groupNumber = '';
            if(producerID == '111111'){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, label.ACETWebServiceUnavailableErrorMessage));
                ProducerSearchResults = null;
                searched = false;
            }else{       
             //   ACETFindProducerWebservice ACTFPWS = new ACETFindProducerWebservice();
             //   ACTFPWS.init(producerSSN, producerTaxId, producerID, companyName, groupNumber, LastName, FirstName, State, SortBy, SortOrder,FilterBy);
             //   DTWrapper = new ACETDatatableWrapper('ACETFindProducerWebservice', ACTFPWS);
                ACETFindProducerAPI ACTFPWS = new ACETFindProducerAPI();
                ACTFPWS.init(producerID, producerSSN, producerTIN, FirstName, MiddleInitial, LastName,  companyName, State, Status, groupNumber, legacyProducerSystem,  legacyProducerId, customerNumber, customerName,adminSystem);
               	DTWrapper = new ACETDatatableWrapper('ACETFindProducerAPI', ACTFPWS);
                
                // Added as First Column by Kalyan as per US1048784 Start
                DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Producer ID', 'ProducerID'));  
                //END    
                DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Legacy ID', 'producerLegacyBrokerCode'));   
                DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Agency Name', 'CompanyName'));
                DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Last Name', 'LastName'));
                DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('First Name', 'FirstName'));
                DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Middle Initial', 'MiddleInitial'));
                DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('TIN/SSN', 'ProducerTIN'));
                DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Producer State', 'producerState'));
                DTWrapper.PageSize = 50;
                           
            }      
           
        }catch(Exception ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, label.ACETWebServiceUnavailableErrorMessage));
        }
    }

   public List<SelectOption> getSourceOriginators(){
        List<SelectOption> lstInteractionTypes= new List<SelectOption>();
        /**** added by Vishakha US424980 START***/
        User currentUser = [select profile.Name from User where Id = :UserInfo.getUserId()];
        if(currentUser.profile.Name.contains('Research User')){
            lstInteractionTypes.add(new SelectOption('Research Only','Research Only'));
        } /**** added by Vishakha US424980 END***/

        else{
            for(String IntrType :Label.ACETProducerSearchInteractionTypes.split(','))
            {
                lstInteractionTypes.add(new SelectOption(IntrType, IntrType));
            }
            system.debug(LoggingLevel.INFO, 'lstInteractionTypes: ' + lstInteractionTypes);
        }
        return lstInteractionTypes;
    }
    
    @RemoteAction
    public static String crtInteraction(string firstNameParam,string lastNameParam,string producerIdParam,String interactionType){
    firstNameparam = EncodingUtil.urlDecode(firstNameParam, 'UTF-8').unescapeHtml4();
    lastNameParam = EncodingUtil.urlDecode(lastNameParam, 'UTF-8').unescapeHtml4();
        system.debug('producerIdParam :: ' + producerIdParam);
        //added by Ranjit : vccd integration
       /* string vccdParam = ApexPages.currentPage().getParameters().get('vccdParams');
        if(vccdParam != '' && vccdParam != null){
            ApexPages.currentPage().getParameters().put('noAutoSearch','clicked');
        } */
        //Code to insert Account and Contact
        Account UpsertAccount;
        List<Account> existingAccount = [SELECT Id,EID__c,personcontactId,FirstName,LastName from Account where EID__c =: producerIdParam AND IsPersonAccount = true];
        system.debug('existingAccount :: ' + existingAccount.size() + ' >>> firstName >>> ' + firstNameParam + ' ' + lastNameParam);

        if(existingAccount.size() == 0){
            UpsertAccount = new Account();
            UpsertAccount.FirstName = firstNameParam;
            UpsertAccount.LastName =lastNameParam;
            UpsertAccount.EID__c = producerIdParam;
            UpsertAccount.EID__pc = producerIdParam;
            UpsertAccount.Contact_Type__pc= 'Producer';
            UpsertAccount.Tax_ID__pc = producerIdParam;
            UpsertAccount.RecordTypeId = ACETMemberQueryUtil.getPersonAccountRecordType();
            Insert UpsertAccount;
        }else{
            UpsertAccount = existingAccount[0];
            UpsertAccount.FirstName = firstNameParam;
            UpsertAccount.LastName =lastNameParam;
            Upsert UpsertAccount;
        } 
        system.debug('UpsertAccount :: ' + UpsertAccount);
        Account acc =[SELECT Id,personcontactId from Account where Id=:UpsertAccount.Id];
        Contact Subject = [SELECT Id,LastName,FirstName,EID__c,AccountId from Contact where Id=:acc.personcontactId];
        system.debug('Subject :: ' + Subject);

        
        Interaction = new Interaction__c();
        Interaction.Originator__c = Subject.Id;

        //for now, we only have the use case as member calls themselves
        Interaction.Interaction_Type__c = interactionType;
        Interaction.Originator_Type__c = 'Producer'; 
        Interaction.Producer_ID__c = producerIdParam;
        upsert Interaction;
        Interaction = ACETMemberQueryUtil.queryInteraction(Interaction.Id);
        system.debug('Interaction:::'+Interaction);
        return Interaction.id;
             
    } 


}