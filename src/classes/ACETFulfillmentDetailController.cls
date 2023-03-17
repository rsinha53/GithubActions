public with sharing class ACETFulfillmentDetailController {
    
    public string CC{get;set;}
    public string strModifiedBy {get; set;}
    public string strSubmittedBy {get; set;}
    public String getActiveXUrl{get;set;}
    Public boolean rendersubmitletter{get;set;}
    Public boolean renderreviewletter{get;set;}
    Public boolean rendercancelletter{get;set;}
    public Create_Letter__c newletter{get;set;}
    
    public ACETFulfillmentDetailController(ApexPages.StandardController controller)
    {
        CC = 'Mail';
        Create_Letter__c letter = (Create_Letter__c)controller.getrecord();
        system.debug('letter is '+letter);
        system.debug('Apexpages.currentpage().getparameters() is '+Apexpages.currentpage().getparameters().get('id'));
        newletter = [SELECT Delivery_Date__c,Delivery_Method_1__c,Delivery_Method_2__c,Email__c,Fax__c,Letter_Name__c,Image_Number__c,Letter_Status__c,
                         Recipient_Address_1__c,Recipient_Address_2__c,Recipient_City__c,Recipient_Last_Name__c,Recipient_MI__c,Recipient_Name__c,Recipient_State__c,Recipient_Suffix__c,Recipient_Type__c,Recipient_Zip__c,Submit_Date_Time__c,
                         Submitted_By__c,Work_Item_Id__c,LastModifiedDate,LastModifiedby.Name,CreatedDate,Createdby.Name,Recipient_Sub_Type__c,Recipient_Facility_Name__c,
                         Review_on_ActiveX__c,Delivery_Method_2_Status__c ,CC_Status__c , Provider_Tax_Id__c
                         FROM Create_Letter__c
                         WHERE Id =: letter.Id or Id= :Apexpages.currentpage().getparameters().get('letterid')];
        
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
            String urlparam1 = 'workitemid='+newletter.Work_Item_Id__c;
            blob urlparam2 = blob.valueOf('&appname=ACET');
            Blob data = Blob.valueOf(urlparam1);
            Blob EncryptKey = Blob.valueOf(ACETWrapEncryptionKey__c.getValues(orginstance+'_Engageonekey').Key__c);
            Blob encryptedworkitem = Crypto.encryptWithManagedIV('AES256', EncryptKey , data);
            String combinedDataAsHex = EncodingUtil.convertToHex(encryptedworkitem) + EncodingUtil.convertToHex(urlparam2);
            blob urlparams = EncodingUtil.convertFromHex(combinedDataAsHex);
            String encodedurlparams = EncodingUtil.base64Encode(urlparams);
            encodedurlparams = EncodingUtil.urlEncode(encodedurlparams, 'UTF-8');
            getActiveXUrl = Engageoneurl+'id='+encodedurlparams;
            system.debug('getActiveXUrl $ '+ getActiveXUrl ); 
            if(newletter.Review_on_ActiveX__c == true){
                
                rendersubmitletter = true;
            }
        }
        if(newletter.Letter_Status__c == 'Pending Submission')
        {
            renderreviewletter = true;
                rendercancelletter = true;
        }
       else if(newletter.Letter_Status__c == 'Submitted')
            {
                rendersubmitletter = false;
                strSubmittedBy = newletter.Submitted_By__c+' '+newletter.Submit_Date_Time__c;
            }
            
            else if(newletter.Letter_Status__c == 'Pending Fulfillment'){
                Datetime modifiedDate=newletter.LastModifiedDate;
                Time modifedTime=modifiedDate.time();
                String formatedDate=ACETUtility.format(modifiedDate.date());
                String formatedtime=modifedTime.hour()+':'+modifedTime.minute()+':'+modifedTime.second();
                strModifiedBy = newletter.LastModifiedBy.Name+', '+formatedDate+', '+formatedtime;
                renderreviewletter = true;
                rendercancelletter = true;
            }
        else if(newletter.Letter_Status__c=='Canceled')
        {
            rendersubmitletter = false;
            renderreviewletter = false;
            rendercancelletter = false;
        }
        
    }
    
    public Pagereference SubmitLetter(){
        try{
            ACETFindLetterService find = new ACETFindLetterService();
            ACETWSCalloutResult findLetterCalloutResult = new ACETWSCalloutResult();
            findLetterCalloutResult = find.FindLetterWS(newletter.Work_Item_Id__c);
            if(findLetterCalloutResult.Message == 'ACTIVE_COMPLETE')
            {
            ACETProcessLetterWebservice service = new ACETProcessLetterWebservice();
            ACETWSCalloutResult processLetterCalloutResult = new ACETWSCalloutResult();
            system.debug('newletter.Work_Item_Id__c is '+newletter.Work_Item_Id__c);
            processLetterCalloutResult = service.ProcessLetterWS(newletter.Work_Item_Id__c, 'PUBLISH');
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
            
            String strurl = String.valueof(URL.getSalesforceBaseUrl().toExternalForm())+'/apex/ACETFulfillmentDetail?letterid='+newletter.Id+'&submitresult='+processLetterCalloutResult.Success+'&findresult='+findLetterCalloutResult.Success;
            system.debug('strurl is '+strurl);
            Pagereference pageref = new pagereference(strurl);
            system.debug('pageref is '+pageref);
            return pageref;
            }
            else{
                String strurl = String.valueof(URL.getSalesforceBaseUrl().toExternalForm())+'/apex/ACETFulfillmentDetail?letterid='+newletter.Id+'&submitresult=false&findresult='+findLetterCalloutResult.Success;
                system.debug('strurl is '+strurl);
                Pagereference pageref = new pagereference(strurl);
                system.debug('pageref is '+pageref);
                return pageref;
                //Apexpages.addMessage(new ApexPages.message(Apexpages.Severity.Error,'Letter Incomplete Please complete the letter by clicking on Review/Edit'));
            }
        }
        catch(Exception ex){
            ApexPages.addMessages(ex); 
            
        }
        return null;
    }
    
    Public Pagereference LaunchActiveX()
    {
        Create_Letter__c letter = new Create_Letter__c();
        //if (Schema.sObjectType.Create_Letter__c.fields.id.isUpdateable())
        letter.id = newletter.Id;
        if (Schema.sObjectType.Create_Letter__c.fields.Review_on_ActiveX__c.isUpdateable())
        letter.Review_on_ActiveX__c = true;
        if (Schema.sObjectType.Create_Letter__c.fields.Letter_Status__c.isUpdateable())
        letter.Letter_Status__c='Pending Fulfillment';
        if(newletter.Letter_Name__c.contains('Balance Bill Letter')){
            if (Schema.sObjectType.Create_Letter__c.fields.CC_Status__c.isUpdateable())
            letter.CC_Status__c = 'Pending Fulfillment';
         }
       system.debug('letter is '+letter); 
        if (Schema.sObjectType.Create_Letter__c.isUpdateable())
        update letter;
        
        
        String strurl = String.valueof(URL.getSalesforceBaseUrl().toExternalForm())+'/apex/ACETFulfillmentDetail?letterid='+letter.Id;
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
        if(processLetterCalloutResult.Success!= Null)
        {
            if (Schema.sObjectType.Create_Letter__c.fields.Letter_Status__c.isUpdateable())
            newletter.Letter_Status__c = 'Canceled';
            if(newletter.Letter_Name__c.contains('Balance Bill Letter')){
                if (Schema.sObjectType.Create_Letter__c.fields.CC_Status__c.isUpdateable())
                newletter.CC_Status__c = 'Canceled';
            }
        }
        if (Schema.sObjectType.Create_Letter__c.isUpdateable())
        update newletter;
        
        system.debug('processLetterCalloutResult is '+processLetterCalloutResult);
        String strurl = String.valueof(URL.getSalesforceBaseUrl().toExternalForm())+'/apex/ACETFulfillmentDetail?letterid='+newletter.Id+'&cancelresult='+processLetterCalloutResult.Success;
        system.debug('strurl for cancel is '+strurl);
        Pagereference pageref = new pagereference(strurl);
        system.debug('pageref is '+pageref);
        
        return pageref;
    }
    
    public void DisplayMessage()
    {
        system.debug('Display Message');
        system.debug('myparam is '+Apexpages.currentpage().getparameters().get('myparam'));
        Apexpages.addMessage(new ApexPages.message(Apexpages.Severity.Error,Apexpages.currentpage().getparameters().get('myparam')));
    }
    
}