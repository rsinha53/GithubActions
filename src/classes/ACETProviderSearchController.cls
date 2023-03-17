global with sharing class ACETProviderSearchController 
    {
        public String InteractionType { get; set; }
        public String CallerName { get; set; }
        public String TaxID { get; set; }
        public String NPI { get; set; }
        public String LastName { get; set; }
        public String FirstName { get; set; }
        public String State {get;set;}
        public ACETStateCodeContainer StateCode { get; set; }
        public String ZipCode { get; set; }
        public String PhoneNumber { get; set; }
        public String FilterBy { get; set; }
        public String FilterByStatus {get;set;}
        public ACETCallTopicsDataWrapper wrapper {get;set;}
        public ACETDatatableWrapper DTWrapper { get; set; }     //Used by pagination component
                
        public ACETProviderSearchController() {
            StateCode = new ACETStateCodeContainer('');
        }     
        public void Search() {
            String ProviderTypeCode = (FilterBy == 'FACL') ? 'HCO' : (FilterBy == 'PROF') ? 'HCP' : 'BOTH';
            system.debug(LoggingLevel.INFO, 'FilterBy:: ' + FilterBy + ', ProviderTypeCode: ' + ProviderTypeCode);
            system.debug('FilterByStatus' + FilterByStatus);
            ACETFindProviderLookupWebservice ACTFPWS = new ACETFindProviderLookupWebservice();
            system.debug(LoggingLevel.INFO, ' StateCode1****: ' + State);
             ACTFPWS.Init(null, NPI, TaxId, LastName, FirstName, null, null,null, ZipCode, null, null, State , PhoneNumber, null, null,null,null,null, null,null,null,null,ProviderTypeCode,null,'false',FilterByStatus,null,false);
                           
           ACTFPWS.GetEndpoint();   
            DTWrapper = new ACETDatatableWrapper('ACETFindProviderLookupWebservice', ACTFPWS);   
            DTWrapper.PageSize = ACTFPWS.PageSize;
            DTWrapper.PageStartNumber = 0;
            DTWrapper.PageNumber = 0;
            DTWrapper.StartRecord = 0;
            DTWrapper.initOnDocumentReady = true;
            DTWrapper.isSortEnabled = true;
            DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn(Label.ACETProviderSearchTaxIdLabel, 'taxId'));
            DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn(Label.ACETProviderSearchPlatinumProviderLabel, 'Platinum'));
            DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn(Label.ACETProviderSearchFullNameLabel, 'fullName'));
            DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn(Label.ACETProviderSearchStreetAddressLabel, 'street'));
            DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn(Label.ACETProviderSearchCityLabel, 'city'));
            DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn(Label.ACETProviderSearchStateLabel,'state'));
            DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn(Label.ACETProviderSearchZipCodeLabel, 'zipCode'));
            DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn(Label.ACETProviderSearchPhoneNumberLabel, 'phoneNumber'));
            DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn(Label.ACETProviderSearchFacilityLabel, 'providerType'));         
        }
            
        public void clearResults() {
            DTWrapper = null;   
        }    
        
        @RemoteAction
        public static Interaction__c RedirectToProviderDetail(String InteractionType, String ContactName, String ProviderId, String TaxID, String NPI, String GroupName, String ProviderType,  
                                                              String  addressId, String ProvideraddressTypeCode,String postalPrefixCode) {
            system.debug(LoggingLevel.INFO, 'InteractionType : ' + InteractionType + ', ContactName: ' + ContactName + ', ProviderId: ' + ProviderId + ', TaxId: ' + TaxId);
            system.debug(LoggingLevel.INFO, ', NPI: ' + NPI + ', GroupName: ' + GroupName + ', ProviderType: ' + ProviderType);
            system.debug(LoggingLevel.INFO, 'addressId :' + addressId + ', postalPrefixCode: ' + postalPrefixCode );
            Interaction__c Interaction;
            
            try {
              /*  Account ProviderAccount = ACETProviderUtility.CreateProviderAccount(ProviderId, GroupName, TaxID);
                upsert ProviderAccount EID__c;
                system.debug(LoggingLevel.INFO, 'ProviderAccount: ' + ProviderAccount);
                
                Contact ProviderContact = ACETProviderUtility.CreateProviderContact(ProviderType, ProviderAccount, ProviderId, TaxID, NPI);
                ProviderContact.Contact_Type__c = 'Provider';
                upsert ProviderContact EID__c;*/

              Account ProviderAccount = ACETProviderUtility.CreateProviderPersonAccount(ProviderId, GroupName, TaxID, NPI,ProviderType);
                system.debug(LoggingLevel.INFO, 'ProviderAccount: ' + ProviderAccount);
                upsert ProviderAccount EID__c;
system.debug('account id '+ProviderAccount.id);
system.debug('account contact id '+ProviderAccount.PersonContactId );

account a = [SELECT Id, PersonContactId FROM Account where Id =: ProviderAccount.Id];

                Interaction = ACETProviderUtility.CreateInteraction(a.PersonContactId , InteractionType, Label.ACETProviderSearchOriginatorType, ContactName,
                             addressId, postalPrefixCode, ProviderId, ProvideraddressTypeCode);
                insert Interaction; 
                
                Interaction = [SELECT Id, Name, Originator__r.LastName FROM Interaction__c WHERE Id =:Interaction.Id];
                system.debug(LoggingLevel.INFO, 'Interaction: ' + Interaction);
            }
            catch (Exception ex) {
                system.debug(LoggingLevel.INFO, 'Error creating Interaction. Details: ' + ex);
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, system.Label.ACETUnexpectedErrorMessage));
            }
            return Interaction;                 
        }
        
        public List<SelectOption> getInteractionTypes()
        {
            List<SelectOption> lstInteractionTypes = new List<SelectOption>();
            /***US424980 START ***/
            User currentUser = [Select profile.name from User where Id =: UserInfo.getUserID()];
            if(currentUser.profile.Name.contains('Research User')){
                lstInteractionTypes.add(new SelectOption(label.ACETResearchUserInteractionType, label.ACETResearchUserInteractionType));    
            } 
            /*** US424980 END***/
            else {
                for(String IntrType :Label.ACETProviderSearchInteractionTypes.split(',')) {
                    lstInteractionTypes.add(new SelectOption(IntrType, IntrType));
                }
                system.debug(LoggingLevel.INFO, 'lstInteractionTypes: ' + lstInteractionTypes);
            }
            return lstInteractionTypes;
        }
        
        public void filterTypeChange() {
            if (String.isBlank(FirstName)) {
                FilterBy ='Both';
            } else {
                FilterBy ='PROF';
            }
        } 
    
        public void FNameDisable()  {
            if (FilterBy == 'FACL') {
                FirstName = null;
            }
        } 
    
    }