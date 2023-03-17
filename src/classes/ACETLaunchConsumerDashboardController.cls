public with sharing class ACETLaunchConsumerDashboardController { 
    public String nurseCoachName { get; set; }

    public String timeOfAppointment { get; set; }

    public String dateOfAppointment { get; set; }
    
    public Pattern MyPattern  {get;set;}
    
    public String dateErrorMsg {get; set;}
    
    public String selectedValue {get;set;}
    
    
    public ACETCallTopicsDataWrapper wrapper {get;set;}
    public String Topic {get;set;}
    public boolean isCancelCaseCreation{get;set;}
    public String baseURL{get;set;}
    public string surrogateKey {get; set;}
    public boolean thererenderer{get;set;}
    
    //public String dateOfAppointment{get; set;}
    
    //for test
    public string buttonURL{get;set;}
    
    
    public ACETLaunchConsumerDashboardController() {
        dateOfAppointment = '';
        timeOfAppointment ='';
        nurseCoachName ='';
        thererenderer = false;
        
        selectedValue ='N';
        try{
        wrapper = new ACETCallTopicsDataWrapper();
        wrapper.init();
        wrapper.CaseObj.Topic__c = 'View Consumer Dashboard';
        string st = apexpages.currentpage().getparameters().get('contactId');
        system.debug('st is '+st);
        initHighlightPanelAdditionalInfo();
        List<Contact> contactList = new List<Contact>();
        //Contact varContact = [select FirstName , lastName from Contact where Id=:apexpages.currentpage().getparameters().get('contactId')];
        contactList = [select FirstName , lastName from Contact where Id=:apexpages.currentpage().getparameters().get('contactId')];
        System.debug('*****'+wrapper.AdditionalInfo.PolicyNumber+'***'+apexpages.currentpage().getparameters().get('memberId'));
        User usr = [select FederationIdentifier from user where id=:userinfo.getUserId()];
            system.debug('wrapper.AdditionalInfo.DOB is '+wrapper.AdditionalInfo);
        string [] dobval = wrapper.AdditionalInfo.DOB.split('/');
        Datetime dt = Datetime.newInstance(integer.valueof(dobval[2]), integer.valueof(dobval[0]), integer.valueof(dobval[1]));
        system.debug('dt is '+dt);
        String dtformat = dt.format('YYYY-MM-dd');
        system.debug('dtformat is '+dtformat);
        surrogateKey = ApexPages.currentPage().getParameters().get('SRK');
        if(contactList.size() > 0){
        for(Contact con : contactList ){
        baseURL = ACETURLEncryptionUtility.getEncryptedConsumerDashURL(usr.FederationIdentifier, apexpages.currentpage().getparameters().get('memberId'), con.FirstName, con.LastName, dtformat, wrapper.AdditionalInfo.GroupNumber, surrogateKey);
        system.debug('**baseURL - '+ baseURL);}
        } 
        }
        catch(Exception ex){
            system.debug('Exception is '+ex.getMessage()+'at line '+ex.getLineNumber());
        }
        //below is for test 
        string targetString = EncodingUtil.URLENCODE('cdbXrefId=780991&cdbXrefIdPartitionNumber=91&policy=0123171&subscriberId=00134100009&firstName=MIKE&lastName=TESTER&functionId=Consumer_Dashboard&landingPage=consumerDashboard&applicationId=ACET','UTF-8');
        buttonURL = 'https://devacet--acetdev.cs26.my.salesforce.com/idp/login?app=0sp210000008OKG&RelayState=https://icuedev.uhc.com/icue/consumerDashboardSSOLogin.uhg?'+targetString;
        system.debug('**called - '+ buttonURL);
       
        
        if (!String.isEmpty(surrogateKey)){ 
            wrapper.surrogateKey = surrogateKey;
        }        
    }
    
   
    public void updateWrapper(){
        wrapper.blockedCallTopic = Topic; // added by vishakha 12/02 for US413581
        dateOfAppointment = '';
        timeOfAppointment ='';
        nurseCoachName ='';
        selectedValue ='N';
        thererenderer = false;
        if(Topic == 'Accepted'){
            thererenderer = true;
        } 
    }
    
    private void initHighlightPanelAdditionalInfo(){
        String additionalInfoStr = apexpages.currentpage().getparameters().get('additionalInfo');
        wrapper.AdditionalInfo = (ACETHighlightsPanelAdditionalInfo)json.deserialize(additionalInfoStr,ACETHighlightsPanelAdditionalInfo.class); 
        //system.debug(wrapper.Addit    
    }
    
    public PageReference routeCase(){
        wrapper.caseObj.Topic__c ='View Consumer Dashboard';
        wrapper.createCase();            
        PageReference caseDetailsReference = new PageReference('/' + wrapper.CaseObj.Id);
        return caseDetailsReference;
    }    
    public List<SelectOption> getTopics(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','--None--'));
        options.add(new SelectOption('Accepted','Accepted'));
        options.add(new SelectOption('Declined','Declined'));
        options.add(new SelectOption('Not Discussed','Not Discussed'));
        return options;        
    }
    public void checkSelectedValue(){        
        system.debug('Selected value is: ' + selectedValue);  
        
    } 
   
    
    public String getdateError(){
        
        MyPattern = Pattern.compile('(0?[1-9]|1[012])/(0?[1-9]|[12][0-9]|3[01])/((19|20)\\d\\d)'); // ([0-1]?[0-9]|[2][0-3]):([0-5][0-9]) (AM|PM)
        Matcher MyMatcher = MyPattern.matcher(dateOfAppointment);
            if(!MyMatcher.matches()){
                dateErrorMsg = 'Error: valid string is mm/dd/yyyy.'; // hh:mm AM/PM
            }
        return dateErrorMsg;           
    }  
    
    public PageReference checkValidations(){
        
        if(dateOfAppointment == null ||
           String.isBlank(selectedValue) ||
           String.isBlank(Topic) ||
           String.isBlank(timeOfAppointment) ||
           String.isBlank(nurseCoachName)){
            
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter values into all required fields.'));
            return null;
        }
        
        if(String.isNotBlank(timeOfAppointment)){
            String errorDate = getdateError();
            system.debug('errorDate------------' + errorDate);
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,errorDate));
            return null;
        }
       return null;
    }
    
    public void clear(){
        Topic ='';
        
        
    }
   
}