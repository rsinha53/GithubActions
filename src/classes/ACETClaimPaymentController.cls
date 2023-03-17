public with sharing class ACETClaimPaymentController extends ACETErrorHandler{
    
    public String getChecks() {
        return null;
    }
    
    public String ProviderId {get;set;}
    public String TaxId {get;set;}
    public String NPI {get;set;}
    public String CallCode {get;set;}
    public String CheckNumber {get;set;}
    public String CheckNum {get;set;}
    public String SeriesDesignator {get;set;} 
    public String SeriesDesig {get;set;} 
    public String TotalPayment {get;set;} 
    public String LastName {get;set;}
    public String FirstName {get;set;}
    public String MemberId {get;set;}
    public String PolicyNumber {get;set;}       
    public Interaction__c Interaction {get;set;}  
    public Contact Subject {get;set;}
    public String SourceOriginator {get;set;}
    public ACETHighlightsPanelAdditionalInfo AdditionalInfo {get;set;}
    public List<WrapperPayeeInformation> wrapperpayeeinfo {get;set;}
    public List<WrapperPaidClaims> wrapperpaidclaims{get;set;}
    public Boolean ShowDetails{get;set;}
    public Boolean ShowSearch{get;set;}
    public Boolean renderclaims{get;set;}
    public String hpAdditionInfoStr {get;set;}
    public Boolean disableChecknumber{get;set;}
    public String PaymentType {get;set;}
    public ACETCallTopicsDataWrapper wrapper {get;set;}
    public List<ACETClaimPaymentResult> Payments {get;set;}
    public Integer PaymentSize {get;set;}
    public Integer PmtSize{get;set;}
    public ACETClaimPaymentResult SelectedPayment {get;set;}
    public String SelectedPaymentGUID {get;set;}
    public String ReturnedDate {get;set;}
    public date VoidStopDate {get;set;}
    public String RemailedDate {get;set;}
    public date CashedDate {get; set;}
    public String issuedDate{set;get;}
    public ACETGetClaimCheckStatusResult checks {get;set;}
    public string surrogateKey {get; set;}
    
    public List<ACETClaimPaymentResult.Claims> searchresultlist{get;set;}
    
    public ACETDatatableWrapper DTWrapper {get;set;}
    Public String CheckImageUrl{get;set;}
    Public boolean isCheck{get;set;}
    
    public ACETClaimPaymentController(){          
        ProviderId = '';
        TaxId = '';
        NPI = '';
        LastName = '';
        FirstName = '';
        MemberId = '';
        PolicyNumber = '';
        disableChecknumber =false;
        ShowDetails = false;
        ShowSearch = false;
        renderclaims = false;
        isCheck = false;
        Interaction = new Interaction__c(); 
        AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
        system.debug('Apexpages.currentPage().getparameters() is '+Apexpages.currentPage().getparameters());
        String interactionId = ApexPages.currentPage().getParameters().get('interactionId');  
        if (!String.isEmpty(interactionId)){ 
            Interaction = ACETProviderUtility.GetInteractionByID(interactionId);
            SourceOriginator = Interaction.Interaction_Type__c;
            if(Interaction.Originator_Type__c == 'Member'){
                CallCode = 'M';
            }else{
                CallCode = 'P';
            }                        
        }
        ACETHighlightsPanelAdditionalInfo AdditionalInfoData;
        String additionalInfostr = ApexPages.currentPage().getParameters().get('additionalInfo');
        
        if(additionalInfostr != null){
            if(additionalInfostr.contains('&') || additionalInfostr.contains('\\'))
        {
                   system.debug('additionalInfostr 1 --->'+additionalInfostr );

            additionalInfostr = additionalInfostr.replace('&', 'and');
           additionalInfostr = additionalInfostr.replace('\\', '');
           system.debug('additionalInfostr 1 --->'+additionalInfostr );
        }
            AdditionalInfoData  = (ACETHighlightsPanelAdditionalInfo)JSON.deserialize(additionalInfostr, ACETHighlightsPanelAdditionalInfo.class);
        }
        system.debug('AdditionalInfoData is '+AdditionalInfoData);
        String contactId = ApexPages.currentPage().getParameters().get('contactId');
        system.debug('contactId232323'+contactId);
        if (!String.isEmpty(contactId)){ 
            if(Interaction.Originator_Type__c == 'Provider'){
                if(AdditionalInfoData.isMember  != null && AdditionalInfoData.isMember.contains('false')){
                    Subject = ACETProviderUtility.GetContactByID(contactId);
                    MemberId = AdditionalInfoData.MemberId;
                }
                
            }
            else {
                Subject = ACETProviderUtility.GetContactByID(contactId);
                MemberId = AdditionalInfoData.MemberId;
                
            }
        }
        
        if (!String.isEmpty(additionalInfostr)){        
            AdditionalInfo = (ACETHighlightsPanelAdditionalInfo)JSON.deserialize(additionalInfostr , ACETHighlightsPanelAdditionalInfo.class);
            PolicyNumber = AdditionalInfo.PolicyNumber;
            hpAdditionInfoStr = JSON.serialize(AdditionalInfo);  
        }
        
        
        
        
        wrapper = new ACETCallTopicsDataWrapper();
        wrapper.CallTopic ='View Payments'; 
        wrapper.init();
        wrapper.CaseObj.Topic__c = 'View Payments'; 
        //wrapper.caseObj.AutoDoc__c = AutoDoc;
        surrogateKey = ApexPages.currentPage().getParameters().get('SRK');
        if (!String.isEmpty(surrogateKey)){ 
            wrapper.surrogateKey = surrogateKey;
        }
        System.debug('wrapper.surrogateKey ----'+wrapper.surrogateKey );
        
    } 
    
    public void init()
    {
        String checknumberstr = ApexPages.currentPage().getParameters().get('CheckNumber');
        system.debug('***str***'+ checknumberstr);
        if (!String.isEmpty(checknumberstr)){        
            CheckNumber = checknumberstr;
            system.debug('*******Check Number*********'+ CheckNumber); 
        } 
        
        String seriesdesignatorstr;
        if(Apexpages.currentPage().getparameters().containskey('SeriesDesignator'))
        {
            seriesdesignatorstr= ApexPages.currentPage().getParameters().get('SeriesDesignator');
        }
            
        system.debug('***Designator***'+ seriesdesignatorstr);
        if (!String.isEmpty(seriesdesignatorstr)){        
            SeriesDesignator = seriesdesignatorstr;
            system.debug('***Designator11111***'+ SeriesDesignator);  
        } 
        
        if(!String.isEmpty(checknumberstr) && !String.isEmpty(seriesdesignatorstr)){
            if(!Test.isRunningTest()){
            search();
            showDetailsSection();
            }
        }
    }
    public void getDummyProvider(){
        String contactId = Interaction.Originator__c;        
        if (!String.isEmpty(contactId)){ 
            Subject = ACETProviderUtility.GetContactByID(contactId);
            
            if(Interaction.Originator_Type__c == 'Member'){
                //MemberId = Subject.EID__c;
            }else{
                if(CheckNumber == '30000043'){
                    system.debug('CheckNumber1'+CheckNumber);
                    ProviderId = '745687356'; 
                }else{
                    ProviderId = '';
                } 
            }
            if(CheckNumber == '30000043'){
                system.debug('CheckNumber2'+Subject.Tax_ID__c);
                system.debug('CheckNumber3'+Subject.npi__c);
                TaxId = Subject.Tax_ID__c;
                NPI = Subject.npi__c;
            } else{
                TaxId = '';
                NPI = '';
            }
        }
    }
    public void search(){
        ShowSearch = false;
        ShowDetails = false;
        isCheck = false;
        disableCheckNumber = false;
        getDummyProvider(); 
        searchresultlist = null;
        
        ACETFindClaimPaymentWebService ws1 = new ACETFindClaimPaymentWebService();
        ws1.init(SeriesDesignator,CheckNumber,FirstName,LastName,MemberId);
        ACETWSCalloutResult CalloutResult = ws1.findClaimPayments();
        
        if (CalloutResult.Success){
            ShowSearch = true;
            
            Payments = new list<ACETClaimPaymentResult>();
            Payments = (list<ACETClaimPaymentResult>)CalloutResult.Response;
            system.debug('****Payments****'+Payments);
            
            PaymentSize = Payments.size();
            if(PaymentSize == 1){
                ShowDetails = true;
                showDetailsSection();
                system.debug('PaymentSize is '+PaymentSize);
                renderclaims = true;
                ACETFindClaimPaymentWebService ws = new ACETFindClaimPaymentWebService();
                ws.init(SeriesDesignator,CheckNumber,FirstName,LastName,MemberId);
                DTWrapper = new ACETDatatableWrapper('ACETFindClaimPaymentWebService', ws);
                DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Claim Number', 'ClaimNumber'));
                DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Member ID', 'MemberID'));
                DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Policy Number', 'PolicyNumber'));
                DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Patient Account Number', 'PatientAccountNumber'));
                DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('First Name', 'FirstName'));
                DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Last Name', 'LastName'));
                DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Relationship', 'Relationship'));
                DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Paid Amount', 'PaidAmount'));
                DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Start Date', 'StartDate'));
                DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('End Date', 'EndDate'));
                DTWrapper.initOnDocumentReady = false;
                DTWrapper.IsSortEnabled = true;
                DTWrapper.PageSize = 50;
            }
            ApexPages.getMessages().clear(); 
        }
        else{
        	//JWADDERROR
        	system.debug('JWERROR' + CalloutResult.statusCode +  ':' + CalloutResult.Message);
        	if(CalloutResult.statusCode==400) {
            	setErrorMsg('GN400B');
        	}
        	else {
            	setErrorMsg('GN'+CalloutResult.statusCode);
        	}
//        	if(CalloutResult.statusCode == 400 || CalloutResult.statusCode == 404 || CalloutResult.statusCode == 500) {
//                setErrorMsg('GN'+CalloutResult.statusCode);
//        	}
//        	else {
//        		ApexPages.addMessage(new ApexPages.Message(CalloutResult.MessageSeverity, CalloutResult.Message));
//        	}
//            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, +CalloutResult.Message));
        	ShowDetails = false;
            ShowSearch = false;
        }
        
        
    }
    
    public void searchutil(){
        ShowSearch = false;
        ShowDetails = false;
        getDummyProvider(); 
        searchresultlist = null;
        
        ACETFindClaimPaymentWebService ws1 = new ACETFindClaimPaymentWebService();
        ws1.init(SeriesDesig,CheckNum,FirstName,LastName,MemberId);
        ACETWSCalloutResult CalloutResult = ws1.findClaimPayments();
        
        if (CalloutResult.Success){
            ShowSearch = true;
            
            
            renderclaims = true; 
            Payments = new list<ACETClaimPaymentResult>();
            Payments = (list<ACETClaimPaymentResult>)CalloutResult.Response;
            system.debug('****Payments****'+Payments);
            PmtSize = Payments.size();
            
            if(PmtSize == 1){
                
                showDetailsSection();
                ShowDetails = true;
                ACETFindClaimPaymentWebService ws = new ACETFindClaimPaymentWebService();
                ws.init(SeriesDesig,CheckNum,FirstName,LastName,MemberId);
                DTWrapper = new ACETDatatableWrapper('ACETFindClaimPaymentWebService', ws);
                DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Claim Number', 'ClaimNumber'));
                DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Member ID', 'MemberID'));
                DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Policy Number', 'PolicyNumber'));
                DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Patient Account Number', 'PatientAccountNumber'));
                DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('First Name', 'FirstName'));
                DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Last Name', 'LastName'));
                DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Relationship', 'Relationship'));
                DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Paid Amount', 'PaidAmount'));
                DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Start Date', 'StartDate'));
                DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('End Date', 'EndDate'));
                DTWrapper.initOnDocumentReady = false;
                DTWrapper.IsSortEnabled = true;
                DTWrapper.PageSize = 50;
            }
            ApexPages.getMessages().clear(); 
        }
        else{
        	//JWADDERROR
        	if(CalloutResult.statusCode==400) {
            	setErrorMsg('GN400B');
        	}
        	else {
            	setErrorMsg('GN'+CalloutResult.statusCode);
        	}
        	//        	if(CalloutResult.statusCode == 400 || CalloutResult.statusCode == 404 || CalloutResult.statusCode == 500) {
//                setErrorMsg('GN'+CalloutResult.statusCode);
//        	}
//        	else {
//        		ApexPages.addMessage(new ApexPages.Message(CalloutResult.MessageSeverity, CalloutResult.Message));
//        	}
            ShowDetails = false;
            ShowSearch = false;
        }
       
        
        
        
    }
    
    
    public void clear(){
        ShowDetails = false;
        ShowSearch = false;
        isCheck = false;
        disableCheckNumber = false;
        ApexPages.getMessages().clear(); 
    }
    public void showDetailsSection(){
        system.debug('showDetailsSection');
        if(Payments != null){  
            system.debug('SelectedPaymentGUID'+SelectedPaymentGUID);
            system.debug('Payments'+Payments);      
            for(ACETClaimPaymentResult selPayment : Payments){
                system.debug('selPayment.GUID'+selPayment.GUID);
                SelectedPayment = selPayment;
                system.debug('SelectedPayment.CheckEFTNumber---'+SelectedPayment.CheckEFTNumber);
                
            }
            
            if(SelectedPayment != null){   
                system.debug('SelectedPayment is '+SelectedPayment);
                system.debug('SelectedPayment.CheckEFTNumber---'+SelectedPayment.CheckEFTNumber);
                system.debug('SelectedPayment.SeriesDesignator---'+SelectedPayment.SeriesDesignator);
                if(!Test.isRunningTest()){
                    system.debug('inside test check block');
                getClaimPaymentCheckStatus(SelectedPayment.CheckEFTNumber, SelectedPayment.SeriesDesignator);
                }
                User usr = [select FederationIdentifier from user where id=:userinfo.getUserId()];
                String baseURL = String.valueof(URL.getSalesforceBaseUrl().toExternalForm());
                String orginstance ;
                for(ACETOrgInstanceURLToOrgNameMap__c orgname:ACETOrgInstanceURLToOrgNameMap__c.getAll().values()) {
                    
                    if(baseURL.contains(orgname.Name)) {
                        system.debug('tname '+orgname.name);
                        orginstance = ACETOrgInstanceURLToOrgNameMap__c.getValues(orgname.name).Org_Name__c;
                    }
                }
                if(orginstance != null){
                    system.debug('orginstance is '+orginstance);
                    ACETOrgNameToSwivelEndpointMap__c wrapURL = ACETOrgNameToSwivelEndpointMap__c.getValues(orginstance+'_IDRS');
                    // 	US2564113 Start
                    ISL_Webservice_Config__c appName =  ISL_Webservice_Config__c.getValues(orginstance+'_doc360Appname');
                    system.debug('wrapURL is '+wrapURL);
                    string doc360Appname ;
                    doc360Appname = appName.value__c;
                    CheckImageUrl = wrapURL.Swivel_Endpoint__c;
                  //  SelectedPayment.SeriesDesignator ='SY';
                  //  SelectedPayment.CheckEFTNumber='10509822';
                    if(doc360Appname != null && doc360Appname != ''){
                        String strparams = 'appId='+doc360Appname+'&user='+usr.FederationIdentifier+'&datagroup=trsy&screen=4'+'&key0='+SelectedPayment.SeriesDesignator+'&key1='+SelectedPayment.CheckEFTNumber;
                        system.debug('before encoding '+strparams);
                        blob params = blob.valueOf(strparams);
                        String base64params = EncodingUtil.base64Encode(params);
                        CheckImageUrl+= base64params;
                        system.debug('CheckImageUrl is '+CheckImageUrl);
                    }
                    //	US2564113 End
                }
                
                if(SelectedPayment.PaymentType == 'CHK'){
                    disableChecknumber = false;
                    isCheck = true;
                    system.debug('CHK');
                }else{
                    disableChecknumber = true;  
                    isCheck = true;
                    system.debug('Not CHK');
                }
                wrapperpayeeinfo = new List<WrapperPayeeInformation>();
                WrapperPayeeInformation wpi = new WrapperPayeeInformation();
                wpi.PayeeType = SelectedPayment.PayeeType;  
                wpi.PayeeID = SelectedPayment.PayeeID;
                wpi.PayeeName = SelectedPayment.PayeeName;
                wpi.PayeeAddressLine1 = SelectedPayment.PayeeAddressLine1; 
                wpi.PayeeAddressLine2 = SelectedPayment.PayeeAddressLine2;
                wpi.City = SelectedPayment.City;
                wpi.State = SelectedPayment.State;
                wpi.Zip = SelectedPayment.Zip;
                wrapperpayeeinfo.add(wpi); 
                system.debug('wrapperpayeeinfo is '+wrapperpayeeinfo);
                
                wrapperpaidclaims = new List<WrapperPaidClaims>();
                WrapperPaidClaims wpc = new WrapperPaidClaims();
               
            }
            
        }else{
            ShowDetails = false;
        }
    }
    
    
public void getClaimPaymentCheckStatus(String strcheckNumber,string strSeriesDesignator){
        ACETWSCalloutResult CalloutRes =  ACETClaimSearchUtility.getCheckStatus(strcheckNumber,strSeriesDesignator);
        if (CalloutRes.Success){
            checks = new ACETGetClaimCheckStatusResult();
            checks = (ACETGetClaimCheckStatusResult)CalloutRes.Response;
        }
        else{
           
        }  
    }
    public class WrapperPayeeInformation{ 
        public String PayeeType{get;set;}     
        public String PayeeID{get;set;}
        public String PayeeName{get;set;} 
        public String PayeeAddressLine1{get;set;} 
        public String PayeeAddressLine2{get;set;}
        public String City{get;set;}
        public String State{get;set;}
        public String Zip{get;set;}
    }
    public class WrapperPaidClaims{ 
        public String ClaimNumber{get;set;}     
        public String MemberID{get;set;}
        public String PolicyNumber{get;set;} 
        public String PatientAccountNumber{get;set;} 
        public String FirstName{get;set;}
        public String LastName{get;set;}
        public String Relationship{get;set;}
        public String PaidAmount{get;set;}
        public String StartDate{get;set;}
        public String EndDate{get;set;}
    }
}