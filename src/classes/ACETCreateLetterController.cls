public with sharing class ACETCreateLetterController extends ACETErrorHandler{
    
    public string templateTest{get;set;}
    
    public string deliveryType{get;set;}
    public string recipientfacilityName{get;set;}
    public string recipientFirstName{get;set;}
    public string recipientMiddleName{get;set;}
    public string recipientLastName{get;set;}
    public string recipientsuffix{get;set;}
    public string workitemid{get;set;}
    
    public string strModifiedBy {get; set;}
    public string strSubmittedBy {get; set;}
    
    
    public string deliverystatus1{get;set;}
    public string deliverystatus2{get;set;}
    public string CCstatus{get;set;}
    public string letterNumber{get;set;}
    public Datetime submittedBy{get;set;}
    public Datetime submittedDt{get;set;}
    public Datetime modifiedBy{get;set;}
    public Datetime createdBy{get;set;}
    public string createdByUserRole{get;set;}
    
    public string emailAddress{get;set;}
    public string faxNumber{get;set;}
    public string CC{get;set;}
    public string selectedTemplate{get;set;}
    public string selectedRecipientType{get;set;}
    public string selectedRecipientSubType{get;set;}
    public string selectedDeliveryOption{get;set;}
    public string selectedDeliveryOption2{get;set;}
    public string selectedType{get;set;}
    Public Case cases{get;set;}
    Public boolean ispagevisible{get;set;}
    Public boolean rendercreateletter{get;set;}
    Public boolean rendersubmitletter{get;set;}
    Public boolean renderreviewletter{get;set;}
    Public boolean rendercancelletter{get;set;}
    Public boolean renderreadonlyfields{get;set;}
    Public boolean rendereditfields{get;set;}
    public String getActiveXUrl{get;set;}
    public String engageoneworkitemid{get;set;}
    public String receipentVal {get; set;}
    
    public String providertaxid{get;set;}
    
    public List<Selectoption> RecipientSubType{get;set;}
    public List<SelectOption> recipientType{get;set;}
    public List<Selectoption> templates{get;set;}
    
    Public String func{set;get;}
    
    public Create_Letter__c newletter{get;set;}
    
    public ACETCreateLetterResult CLResult{get;set;}
    
    public String RequestBodyFormat{get;set;}
    public String Selectedtemplatename{get;set;}
    
    public ACETCreateLetterController(ApexPages.StandardController controller)
    {
        ispagevisible = true;
        rendercreateletter = true;
        rendersubmitletter = false;
        renderreviewletter = false;
        rendercancelletter = false;
        rendereditfields = false;
        faxNumber = null;
        strModifiedBy = '';
        strSubmittedBy = '';
        receipentVal = '--None--';
        system.debug('Id is '+Apexpages.currentpage().getparameters().get('letterid'));
        
        templates = new List<SelectOption>();
        templates.add(new SelectOption('--None--','--None--'));
        selectedTemplate = '--None--';
        recipientType = new List<SelectOption>();
        recipientType.add(new SelectOption('--None--','--None--'));
        recipientType.add(new SelectOption('Member','Member'));
        // recipientType.add(new SelectOption('Provider','Provider'));
        RecipientSubType = new List<selectOption>();
        RecipientSubType.add(new selectOption('--None--','--None--'));
        //RecipientSubType.add(new selectOption('Facility','Facility'));
        RecipientSubType.add(new selectOption('Person','Person'));
        Case cs = (Case)controller.getrecord();
        system.debug('cs is '+cs);
        
        Map<String,ACETLetterTemplates__c> lettermap = ACETLetterTemplates__c.getall();
        
        system.debug('lettermap.keySet() is '+lettermap.keySet());
        templates = ACETCreateLetterController.getSelectOptions(cs,lettermap);
        system.debug('templates is '+templates);
        if(Apexpages.currentpage().getparameters().get('letterid') != null)
        {
            renderreadonlyfields = true;
            
            newletter = [SELECT Id,Delivery_Date__c,Delivery_Method_1__c,Delivery_Method_2__c,Email__c,Fax__c,Letter_Name__c,Image_Number__c,Letter_Status__c,
                         Recipient_Address_1__c,Recipient_Address_2__c,Recipient_City__c,Recipient_Last_Name__c,Recipient_MI__c,Recipient_Name__c,Recipient_State__c,Recipient_Suffix__c,Recipient_Type__c,Recipient_Zip__c,Submit_Date_Time__c,
                         Submitted_By__c,Work_Item_Id__c,LastModifiedDate,LastModifiedby.Name,CreatedDate,Createdby.Name,Recipient_Sub_Type__c,Recipient_Facility_Name__c,
                         Review_on_ActiveX__c,Delivery_Method_2_Status__c ,CC_Status__c, Provider_Tax_Id__c
                         FROM Create_Letter__c
                         WHERE Id =: Apexpages.currentpage().getparameters().get('letterid')];
            
            system.debug('NewLetter---'+newLetter);
            String baseURL = String.valueof(URL.getSalesforceBaseUrl().toExternalForm());
            String Engageoneurl;
            String orginstance ;
            for(ACETOrgInstanceURLToOrgNameMap__c orgname:ACETOrgInstanceURLToOrgNameMap__c.getAll().values()) {
                
                if(baseURL.contains(orgname.Name)) {
                    system.debug('tname '+orgname.name);
                    orginstance = ACETOrgInstanceURLToOrgNameMap__c.getValues(orgname.name).Org_Name__c;
                }
            }
            if(orginstance != null){
                system.debug('orginstance is '+orginstance);
                Engageoneurl = ACETURLEncryptionUtility.getICUEURL(orginstance+'_EngageOne');
            }
            
            String urlparam1 = 'workitemid='+newletter.Work_Item_Id__c;
            system.debug('Work Item Id '+urlparam1);
            blob urlparam2 = blob.valueOf('&appname=ACET');
            Blob data = Blob.valueOf(urlparam1);
            system.debug('orginstance++'+orginstance);
            Blob EncryptKey = Blob.valueOf(ACETWrapEncryptionKey__c.getValues(orginstance+'_Engageonekey').Key__c);
            Blob encryptedworkitem = Crypto.encryptwithManagedIV('AES256', EncryptKey, data);
            system.Debug('url is '+encodingutil.base64Encode(encryptedworkitem));
            String combinedDataAsHex = EncodingUtil.convertToHex(encryptedworkitem) + EncodingUtil.convertToHex(urlparam2);
            blob urlparams = EncodingUtil.convertFromHex(combinedDataAsHex);
            String encodedurlparams = EncodingUtil.base64Encode(urlparams);
            encodedurlparams = EncodingUtil.urlEncode(encodedurlparams, 'ISO-8859-1');
            getActiveXUrl = Engageoneurl+'id='+encodedurlparams;
            if(newletter.Review_on_ActiveX__c == true){
                
                rendersubmitletter = true;
            }
            if(newletter.Letter_Status__c == 'Pending Submission'){
                
                rendercreateletter = false;
                renderreviewletter = true;
                rendercancelletter = true;
                engageoneworkitemid = newletter.Work_Item_Id__c ;
                deliverystatus1= newLetter.Letter_Status__c ;
                deliverystatus2= newLetter.Delivery_Method_2_Status__c;
                ccStatus= newLetter.CC_Status__c;
                strModifiedBy = '';
                
                system.debug('rendercreateletter is '+rendercreateletter);
            }
            else if(newletter.Letter_Status__c == 'Submitted')
            {
                rendercreateletter = false;
                rendersubmitletter = false;
                strSubmittedBy = newletter.Submitted_By__c+' '+newletter.Submit_Date_Time__c;
                
            }
            else if(newletter.Letter_Status__c == 'Canceled')
            {
                rendercreateletter = false;
                renderreviewletter = false;
                rendercancelletter = false;
            }
            //Added by Krishna for User story US600908
            else if(newletter.Letter_Status__c == 'Pending Fulfillment'){
                Datetime modifiedDate=newletter.LastModifiedDate;
                Time modifedTime=modifiedDate.time();
                String formatedDate=modifiedDate.date().format();
                String formatedtime=modifedTime.hour()+':'+modifedTime.minute()+':'+modifedTime.second();
                strModifiedBy = newletter.LastModifiedBy.Name+', '+formatedDate+', '+formatedtime;
                rendercreateletter = false;
                renderreviewletter = true;
                rendercancelletter = true;
            }
        }
        
        
        else{
            rendereditfields = true;
            newletter = new Create_Letter__c();
        }
        
        CC = 'Mail';

         cases = [select id,ID__c,Topic__c,caseNumber,Originator_name__c,Status,Subject_Name__c,Situs_State__c,Surrogate_Key__c,ServiceLevel__c from Case where id=:cs.Id];
      
        CLResult = new ACETCreateLetterResult(); 
    }
    
     
     Public Static List<SelectOption> getSelectOptions(Case cs, Map<String,ACETLetterTemplates__c> lettermap){
       Case cases = [select id,ID__c,Topic__c,caseNumber,Originator_name__c,Status,Subject_Name__c,Situs_State__c,Surrogate_Key__c,ServiceLevel__c from Case where id=:cs.Id];
        system.debug('cases is '+cases);
        List<SelectOption> templates = new List<SelectOption>();
       for(string s:lettermap.keySet())
        {
            if(cases.ServiceLevel__c != null &&( cases.ServiceLevel__c == 'LF' || cases.ServiceLevel__c == 'OL') && ACETLetterTemplates__c.getvalues(s).Value__c =='OON_Cost_Estimate_Letter'){
               // ignore OON_Cost_Estimate_Letter
            }else{
               templates.add(new SelectOption(ACETLetterTemplates__c.getvalues(s).Value__c,s));
            }
        }
        templates.sort();
        return templates;

}
    public List<SelectOption> getDeliveryOptions() {
        List<SelectOption> deliveryOptions = new List<SelectOption>();
        deliveryOptions.add(new SelectOption('--None--','--None--'));
        deliveryOptions.add(new SelectOption('Mail','US Mail'));
        /*deliveryOptions.add(new SelectOption('Email','Email'));
deliveryOptions.add(new SelectOption('Fax','Fax'));*/
        deliveryOptions.add(new SelectOption('Overnight','Overnight'));
        return deliveryOptions;
    }
    
    public void onchangetemplate()
    {
        system.debug('selectedTemplate is '+selectedTemplate);
        if(selectedTemplate == 'Balance_Bill_Letter')
        {
            recipientType = new List<SelectOption>();
            //recipientType.add(new SelectOption('Provider','Provider'));
            system.debug('recipientTypee is '+recipientType);
            RecipientSubType = new List<selectOption>();
            RecipientSubType.add(new selectOption('--None--','--None--'));
            //RecipientSubType.add(new selectOption('Facility','Facility'));
            RecipientSubType.add(new selectOption('Person','Person'));
            selectedRecipientSubType = '--None--';
        }
        else if(selectedTemplate == '--None--') {
            recipientType = new List<SelectOption>();
            recipientType.add(new SelectOption('--None--','--None--'));
            recipientType.add(new SelectOption('Member','Member'));
            // recipientType.add(new SelectOption('Provider','Provider'));
            system.debug('recipientTypee is '+recipientType);
            selectedRecipientType='--None--';
            selectedRecipientSubType = '--None--';
        }
        else if(selectedTemplate != '--None--' || selectedTemplate != 'Balance_Bill_Letter')
        {
            recipientType = new List<SelectOption>();
            //recipientTypee.add(new SelectOption('--None--','--None--'));
            recipientType.add(new SelectOption('Member','Member'));
            RecipientSubType = new List<selectOption>();
            RecipientSubType.add(new selectOption('Person','Person'));
            //recipientfacilityName = '';
            //receipentVal = 'Member';
        }
    }
    
    public void onchangerecipienttype()
    {
        system.debug('selectedRecipientType is '+receipentVal);
        
        //if(receipentVal == '--None--' || receipentVal == 'Provider')
        if(receipentVal == '--None--')
        { 
            system.debug('receipentVal is '+receipentVal);
            RecipientSubType = new List<selectOption>();
            RecipientSubType.add(new selectOption('--None--','--None--'));
            //RecipientSubType.add(new selectOption('Facility','Facility'));
            RecipientSubType.add(new selectOption('Person','Person'));
            
            system.debug('RecipientSubTypee is '+RecipientSubType);
            selectedRecipientSubType = '--None--';
        }
        else if(receipentVal == 'Member')
        {
            RecipientSubType = new List<selectOption>();
            RecipientSubType.add(new selectOption('Person','Person'));
        }
    }
    
    public List<SelectOption> getTypes() {
        List<SelectOption> types = new List<SelectOption>();
        types.add(new SelectOption('Letter','Letter'));
        return types;
    }
    
    public Pagereference CreateLetter(){
        
        for (SelectOption so : Templates)
        {
            if (so.getValue() == selectedTemplate)
            {
                Selectedtemplatename = so.getLabel();
            }
        }
        //system.debug('cases.ID__c is '+Cases.ID__c);
        String casememberid;
        if(cases.Surrogate_Key__c != null)
        {
            casememberid = cases.ID__c;
        }
        list<String> SearchParameters;
        if(Selectedtemplate == 'Foreign_Travel' || Selectedtemplate == 'Proof_Lost_Coverage' || Selectedtemplate == 'OON_Cost_Estimate_Letter')
        {
            SearchParameters = new String[]{Selectedtemplate,String.valueof(cases.caseNumber),String.valueof(date.today()),cases.Situs_State__c,casememberid,providertaxid,UserInfo.getFirstname(),Userinfo.getLastName(),selectedDeliveryOption,selectedDeliveryOption2,'','',selectedRecipientType,selectedRecipientSubType,recipientfacilityName,recipientFirstName,recipientMiddleName,recipientLastName,recipientsuffix};
                }
        else{
            SearchParameters = new String[]{Selectedtemplate,String.valueof(cases.caseNumber),String.valueof(date.today()),'',casememberid,providertaxid,UserInfo.getFirstname(),Userinfo.getLastName(),selectedDeliveryOption,selectedDeliveryOption2,'','',selectedRecipientType,selectedRecipientSubType,recipientfacilityName,recipientFirstName,recipientMiddleName,recipientLastName,recipientsuffix};
                }
        system.debug('SearchParameters is '+SearchParameters);
        
        StaticResource RequestJSONSR;
        if (!test.isRunningTest())
        {
            RequestJSONSR = [SELECT Body FROM StaticResource WHERE Name = 'ACETLetterAttachmentXML'];
            RequestBodyFormat = RequestJSONSR.Body.toString(); 
            system.debug('RequestBodyFormat is '+RequestBodyFormat);
        }
        String XMLAttach = String.format(RequestBodyFormat, SearchParameters).replaceAll('null', '').replaceAll('--None--', '');
        
        system.debug('XML attachment'+XMLAttach);
        ACETCreateLetterWebservice ACETCLW = new ACETCreateLetterWebservice();
        ACETWSCalloutResult createLetterCalloutResult = new ACETWSCalloutResult ();
        createLetterCalloutResult = ACETCLW.CreateLetterWS(XMLAttach,Selectedtemplate);
        Pagereference pageref;
        if(createLetterCalloutResult.success != null && createLetterCalloutResult.success ){
            CLResult =  (ACETCreateLetterResult)createLetterCalloutResult.Response;
            
            system.debug('CLRESULT--->'+clresult);
            Create_Letter__c letter = new Create_Letter__c();
            letter.Case__c = cases.id;
            letter.Letter_Name__c = selectedTemplatename;
            letter.Letter_Status__c = 'Pending Submission';
            if(selectedTemplate.contains('Balance Bill Letter'))
                letter.CC_Status__c = 'Pending Submission';
            
            letter.Work_Item_Id__c = clResult.resultLetterId ;
            letter.Delivery_Method_1__c =  selectedDeliveryOption;
            letter.Delivery_Method_2__c = selectedDeliveryOption2;
            //letter.Email__c = emailAddress;
            //letter.Fax__c = String.valueof(faxNumber);     // converting to field type Phone and encrypted US678840 
            
            //letter.Recipient_Facility_Name__c = recipientfacilityName;
            letter.Recipient_Name__c = recipientFirstName;
            letter.Recipient_MI__c = recipientMiddleName;
            letter.Recipient_Last_Name__c = recipientLastName;
            system.debug('selectedRecipientSubType is '+selectedRecipientSubType);
            if(!test.isRunningTest())
            {
                letter.Recipient_Sub_Type__c = selectedRecipientSubType;
            }
            letter.Recipient_Suffix__c = recipientsuffix;
            letter.Recipient_Type__c = selectedRecipientType;  
            letter.Provider_Tax_Id__c = providertaxid;
            system.debug('letter is '+letter);
            if (Schema.sObjectType.Create_Letter__c.isCreateable())
                insert letter;
            String strurl = String.valueof(URL.getSalesforceBaseUrl().toExternalForm())+'/apex/ACETCreateLetter?id='+cases.id+'&letterid='+letter.Id;
            system.debug('strurl is '+strurl);
            pageref = new pagereference(strurl);
            system.debug('pageref is '+pageref);
            return pageref;
        }else if(!createLetterCalloutResult.success && createLetterCalloutResult.Message == system.Label.ACETLetterWorkItemIdErrorMessage){
                        setErrorMsg('GN400B');
        }
        else if(!createLetterCalloutResult.success && createLetterCalloutResult.Message == system.Label.ACETUnexpectedErrorMessage)
        {
                        setErrorMsg('GN500');
        }
        else if(!createLetterCalloutResult.success && createLetterCalloutResult.responseBody == '400'){
                        setErrorMsg('GN400B');
        } else if(!createLetterCalloutResult.success && createLetterCalloutResult.responseBody == '404'){
                        setErrorMsg('AL404');
        }
        return pageref;
    }
    public Pagereference SubmitLetter(){
        try{
            ACETFindLetterService find = new ACETFindLetterService();
            ACETWSCalloutResult findLetterCalloutResult = new ACETWSCalloutResult();
            findLetterCalloutResult = find.FindLetterWS(newletter.Work_Item_Id__c);
            if(findLetterCalloutResult.Message == 'ACTIVE_COMPLETE' || Test.isRunningTest())
            {
                ACETProcessLetterWebservice service = new ACETProcessLetterWebservice();
                ACETWSCalloutResult processLetterCalloutResult = new ACETWSCalloutResult();
                system.debug('newletter.Work_Item_Id__c is '+newletter.Work_Item_Id__c);
                processLetterCalloutResult = service.ProcessLetterWS(newletter.Work_Item_Id__c, 'PUBLISH');
                if(processLetterCalloutResult.Success != null && processLetterCalloutResult.Success && processLetterCalloutResult.Message == '')
                {
                    if (Schema.sObjectType.Create_Letter__c.fields.Letter_Status__c.isUpdateable())
                        newletter.Letter_Status__c = 'Submitted';
                    if (Schema.sObjectType.Create_Letter__c.fields.Submitted_By__c.isUpdateable())
                        newletter.Submitted_By__c = userinfo.getName();
                    
                    if(newletter.Letter_Name__c.contains('Balance Bill Letter')){
                        if (Schema.sObjectType.Create_Letter__c.fields.CC_Status__c.isUpdateable())
                            newletter.CC_Status__c = 'Submitted';
                    }
                    if (Schema.sObjectType.Create_Letter__c.isUpdateable())
                        update newletter;
                    
                    String strurl = String.valueof(URL.getSalesforceBaseUrl().toExternalForm())+'/apex/ACETCreateLetter?id='+cases.id+'&letterid='+newletter.Id+'&submitresult='+processLetterCalloutResult.Success+'&findresult='+findLetterCalloutResult.Success;
                    system.debug('strurl is '+strurl);
                    Pagereference pageref = new Pagereference(strurl);
                    system.debug('pageref is '+pageref);
                    return pageref;
                }
                else if(processLetterCalloutResult.Message == system.Label.ACETUnexpectedErrorMessage)
                {
                               setErrorMsg('GN500');
                 }
                else if(processLetterCalloutResult.responseBody == '400'){
                           setErrorMsg('GN400B');

                }else if(processLetterCalloutResult.responseBody == '404'){
                           setErrorMsg('AL404');

                }
            }
            else if(findLetterCalloutResult.Message == system.Label.ACETUnexpectedErrorMessage){
                                        setErrorMsg('GN500');
            }else if(!findLetterCalloutResult.success && findLetterCalloutResult.responseBody == '400'){
                                        setErrorMsg('GN400B');
            }
            else if(!findLetterCalloutResult.success && findLetterCalloutResult.responseBody == '404'){
                                        setErrorMsg('AL404');
            }
            else{
                String strurl = String.valueof(URL.getSalesforceBaseUrl().toExternalForm())+'/apex/ACETCreateLetter?id='+cases.id+'&letterid='+newletter.Id+'&submitresult=false&findresult='+findLetterCalloutResult.Success;
                system.debug('strurl is '+strurl);
                Pagereference pageref = new pagereference(strurl);
                system.debug('pageref is '+pageref);
                return pageref;
            }
        }
        catch(Exception ex){
            ApexPages.addMessages(ex); 
            
        }
        return null;
    }
    
    Public Pagereference LaunchActiveX()
    {
        /*Create_Letter__c letter = new Create_Letter__c();
if (Schema.sObjectType.Create_Letter__c.fields.id.isUpdateable())
letter.id = Apexpages.currentpage().getparameters().get('letterid');*/
        
        if (Schema.sObjectType.Create_Letter__c.fields.Review_on_ActiveX__c.isUpdateable())
            newletter.Review_on_ActiveX__c = true;
        
        //Added by Krishna for User story US600908
        if (Schema.sObjectType.Create_Letter__c.fields.Letter_Status__c.isUpdateable())
            newletter.Letter_Status__c='Pending Fulfillment';
        
        if(newletter.Letter_Name__c.contains('Balance Bill Letter')){
            if (Schema.sObjectType.Create_Letter__c.fields.CC_Status__c.isUpdateable())
                newletter.CC_Status__c = 'Pending Fulfillment';
        }
        if (Schema.sObjectType.Create_Letter__c.isUpdateable())
            update newletter;
        
        system.debug('newletter is '+newletter);
        String strurl = String.valueof(URL.getSalesforceBaseUrl().toExternalForm())+'/apex/ACETCreateLetter?id='+cases.id+'&letterid='+newletter.Id;
        system.debug('strurl is '+strurl);
        Pagereference pageref = new pagereference(strurl);
        system.debug('pageref is '+pageref);
        return pageref;
    }
    
    public Pagereference CancelLetter()
    {
        ACETProcessLetterWebservice service = new ACETProcessLetterWebservice();
        ACETWSCalloutResult processLetterCalloutResult = new ACETWSCalloutResult();
        system.debug('newletter.Work_Item_Id__c is '+newletter.Work_Item_Id__c);
        processLetterCalloutResult = service.ProcessLetterWS(newletter.Work_Item_Id__c, 'CANCEL');
        system.debug('processLetterCalloutResult '+processLetterCalloutResult);
        Pagereference pageref;
        if(processLetterCalloutResult.Success != null && processLetterCalloutResult.Success && processLetterCalloutResult.Message == '')
        {
            newletter.Letter_Status__c = 'Canceled';
            if(newletter.Letter_Name__c.contains('Balance Bill Letter')){
                newletter.CC_Status__c = 'Canceled';
            }
            
            
            if (Schema.sObjectType.Create_Letter__c.isUpdateable())
                update newletter;
            
            system.debug('processLetterCalloutResult is '+processLetterCalloutResult);
            String strurl = String.valueof(URL.getSalesforceBaseUrl().toExternalForm())+'/apex/ACETCreateLetter?id='+cases.id+'&letterid='+Apexpages.currentpage().getparameters().get('letterid')+'&cancelresult='+processLetterCalloutResult.Success;
            system.debug('strurl for cancel is '+strurl);
            pageref = new pagereference(strurl);
            system.debug('pageref is '+pageref);
            
            return pageref;
        }
        else if(processLetterCalloutResult.Message == system.Label.ACETUnexpectedErrorMessage)
        {
            setErrorMsg('GN500');

        }
        else if(processLetterCalloutResult.responseBody == '400'){
            setErrorMsg('GN400B');
                   return null;
        }else if(processLetterCalloutResult.responseBody == '404'){
            setErrorMsg('AL404');
                   return null;
        }
        return pageref;
    }
    
    public void DisplayMessage()
    {
        system.debug('Display Message');
        system.debug('myparam is '+Apexpages.currentpage().getparameters().get('myparam'));
        Apexpages.addMessage(new ApexPages.message(Apexpages.Severity.Error,Apexpages.currentpage().getparameters().get('myparam')));
    }
}