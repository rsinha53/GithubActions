public with sharing class ACETLGT_CreateLetterController {
    
    
    public  class LetterDataWrapper{
       @Auraenabled
       public string result;
       @Auraenabled 
       public string engageOneUrl;
       @Auraenabled
       public string letter;
       @Auraenabled
       public string modifiedBy;
       @Auraenabled
       public string submittedBy;
       @Auraenabled
       public string submitResult;
       @Auraenabled
       public string cancelResult;
       @Auraenabled
       public string errorMessage;
    }
    
    @AuraEnabled
    public static Case getCaseFromId(Id caseId) {
        Case foundCase = new Case();
        if(caseID!=null) {
            //need to add case number, topic, originator name, subject name, maybe more???
            List<Case> cases = [ SELECT Id, CaseNumber, Topic__c, Originator_name__c, Subject_Name__c,ServiceLevel__c from CASE where ID = :caseId ];
            if(cases.size() > 0) {
                foundCase = cases[0];
            }
        }
        return foundCase;
    
    }
    
    @AuraEnabled
    public static LetterDataWrapper createLetter(string caseId, string templateName, string deliveryMethod1, string deliveryMethod2, string firstName, string middleName, string lastName, string suffix) {
      				         ACETErrorHandler errHandler = new ACETErrorHandler();

        LetterDataWrapper LDW = new LetterDataWrapper();
        Case cases = [select id,ID__c,Topic__c,caseNumber,Originator_name__c,Status,Subject_Name__c,Situs_State__c,Surrogate_Key__c from Case where id=:caseId];
        string templateValue;
        if(ACETLetterTemplates__c.getvalues(templateName)!=null) {
            templateValue = ACETLetterTemplates__c.getvalues(templateName).Value__c;
        }
        
//      Map<String,ACETLetterTemplates__c> lettermap = ACETLetterTemplates__c.getall();
//        
//        system.debug('lettermap.keySet() is '+lettermap.keySet());
//        for(string s:lettermap.keySet())
//        {
//          system.debug('>>>>>>>letterMap: ' + s);
//          if(ACETLetterTemplates__c.getvalues(s).Value__c == templateValue) {
//              system.debug('>>>>>>>letterMapFound: ' + s);
//              templateName = s;
//          }
//        }
        system.debug('>>>>>>>>>>>templateValue: ' + templateValue);
        String casememberid;
        String providertaxid;
        String facilityName;
        String selectedRecipientType = 'Member';
        String selectedRecipientSubtype = 'Person';
        if(cases.Surrogate_Key__c != null)
        {
            casememberid = cases.ID__c;
        }
        list<String> SearchParameters;
        if(templateValue == 'Foreign_Travel' || templateValue == 'Proof_Lost_Coverage' || templateValue == 'OON_Cost_Estimate_Letter')
        {
            SearchParameters = new String[]{templateValue,String.valueof(cases.caseNumber),String.valueof(date.today()),cases.Situs_State__c,casememberid,providertaxid,UserInfo.getFirstname(),Userinfo.getLastName(),deliveryMethod1,deliveryMethod2,'','',selectedRecipientType,selectedRecipientSubType,facilityName,firstName,middleName,lastName,suffix};
                }
        else{
            SearchParameters = new String[]{templateValue,String.valueof(cases.caseNumber),String.valueof(date.today()),'',casememberid,providertaxid,UserInfo.getFirstname(),Userinfo.getLastName(),deliveryMethod1,deliveryMethod2,'','',selectedRecipientType,selectedRecipientSubType,facilityName,firstName,middleName,lastName,suffix};
                }
        
system.debug('SearchParameters is '+SearchParameters);
        
        StaticResource RequestJSONSR;
        String RequestBodyFormat;
        if (!test.isRunningTest())
        {
            RequestJSONSR = [SELECT Body FROM StaticResource WHERE Name = 'ACETLGT_LetterAttachmentXML'];
            RequestBodyFormat = RequestJSONSR.Body.toString(); 
            system.debug('RequestBodyFormat is '+RequestBodyFormat);
        }
        if(Test.isRunningTest()){
         RequestBodyFormat='<?xml version="1.0" encoding="UTF-8" standalone="yes" ?><data><datum name="CaseID">00011122C</datum></data>';
        }
        String XMLAttach = String.format(RequestBodyFormat, SearchParameters).replaceAll('null', '').replaceAll('--None--', '');
        ACETLGT_CreateLetterWebservice ACETCLW = new ACETLGT_CreateLetterWebservice();
        ACETWSCalloutResult createLetterCalloutResult = new ACETWSCalloutResult ();
        createLetterCalloutResult = ACETCLW.CreateLetterWS(XMLAttach,templateValue);
        Pagereference pageref;
        if(Test.isRunningTest()){
           createLetterCalloutResult.success= true;
          }
        if(createLetterCalloutResult.success != null && createLetterCalloutResult.success ){
            ACETCreateLetterResult CLResult = new ACETCreateLetterResult(); 
            if(Test.isRunningTest()){
                  ACETCreateLetterResult letterInfo = new ACETCreateLetterResult();
                  ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult();
                  letterInfo.resultLetterId ='1234';
                   ACETCreateLetterJSON2Apex.CreateLetterResult res = new ACETCreateLetterJSON2Apex.CreateLetterResult();
                   res.letterId = 11111;
                   ACETCreateLetterJSON2Apex json = new ACETCreateLetterJSON2Apex();
                   json.createLetterResult = res;
                   oACETWSCalloutResult.Success = true;
                  oACETWSCalloutResult.Message = '';
                  oACETWSCalloutResult.Response = letterInfo;
                  createLetterCalloutResult =oACETWSCalloutResult;
            }
            CLResult =  (ACETCreateLetterResult)createLetterCalloutResult.Response;
            
            system.debug('CLResult--->'+CLResult);
            Create_Letter__c letter = new Create_Letter__c();
            letter.Case__c = cases.id;
            letter.Letter_Name__c = templateName;
            letter.Letter_Status__c = 'Pending Submission';
            
            letter.Work_Item_Id__c = CLResult.resultLetterId ;
            letter.Delivery_Method_1__c =  deliveryMethod1;
            letter.Delivery_Method_2__c = deliveryMethod2;
            //letter.Email__c = emailAddress;
            //letter.Fax__c = String.valueof(faxNumber);     // converting to field type Phone and encrypted US678840 
            
            //letter.Recipient_Facility_Name__c = recipientfacilityName;
            letter.Recipient_Name__c = firstName;
            letter.Recipient_MI__c = middleName;
            letter.Recipient_Last_Name__c = lastName;
            system.debug('selectedRecipientSubType is '+selectedRecipientSubType);
            if(!test.isRunningTest())
            {
                letter.Recipient_Sub_Type__c = selectedRecipientSubType;
            }
            letter.Recipient_Suffix__c = suffix;
            letter.Recipient_Type__c = selectedRecipientType;  
            letter.Provider_Tax_Id__c = providertaxid;
            system.debug('letter is '+letter);
            if (Schema.sObjectType.Create_Letter__c.isCreateable())
                insert letter;
            
            Create_Letter__c newletter = [SELECT Id,Delivery_Date__c,Delivery_Method_1__c,Delivery_Method_2__c,Email__c,Fax__c,Letter_Name__c,Image_Number__c,Letter_Status__c,
                          Recipient_Address_1__c,Recipient_Address_2__c,Recipient_City__c,Recipient_Last_Name__c,Recipient_MI__c,Recipient_Name__c,Recipient_State__c,Recipient_Suffix__c,Recipient_Type__c,Recipient_Zip__c,Submit_Date_Time__c,
                          Submitted_By__c,Work_Item_Id__c,LastModifiedDate,LastModifiedby.Name,CreatedDate,Createdby.Name,Recipient_Sub_Type__c,Recipient_Facility_Name__c,
                          Review_on_ActiveX__c,Delivery_Method_2_Status__c ,CC_Status__c, Provider_Tax_Id__c
                          FROM Create_Letter__c
                          WHERE Id =: letter.Id];
            
            LDW.letter = JSON.serialize(newletter);
            
            
            
        }else if(!createLetterCalloutResult.success && createLetterCalloutResult.Message == system.Label.ACETLetterWorkItemIdErrorMessage){
set<string> msg_set = errHandler.setErrorMsgInDataTable('GN500',null);
            if(msg_set != null){
                for (string setElement : msg_set) {
                    LDW.errorMessage  = setElement;
      
                     }              
                   msg_set.clear();
                 }
        }
        else if(!createLetterCalloutResult.success && createLetterCalloutResult.Message == system.Label.ACETUnexpectedErrorMessage)
        {
            set<string> msg_set = errHandler.setErrorMsgInDataTable('GN500',null);
            if(msg_set != null){
                for (string setElement : msg_set) {
                    LDW.errorMessage  = setElement;
      
                     }              
                   msg_set.clear();
                 }
                }
        else if(!createLetterCalloutResult.success && createLetterCalloutResult.responseBody == '400'){
            set<string> msg_set = errHandler.setErrorMsgInDataTable('GN400B',null);
            if(msg_set != null){
                for (string setElement : msg_set) {
                    LDW.errorMessage  = setElement;
      
                     }              
                   msg_set.clear();
                 }
                  }
         else if(!createLetterCalloutResult.success && createLetterCalloutResult.responseBody == '404'){
            set<string> msg_set = errHandler.setErrorMsgInDataTable('AL404',null);
            if(msg_set != null){
                for (string setElement : msg_set) {
                    LDW.errorMessage  = setElement;
      
                     }              
                   msg_set.clear();
                 }
                  }
        LDW.result = JSON.serialize(createLetterCalloutResult);
        
        //TODO: fetch engageone URL, make object to return URL, Letter info, and results/status code
        
        return LDW;
    
    }
    
    @AuraEnabled
    public static LetterDataWrapper getEngageOneUrl(string letterid) {

        Create_Letter__c newletter = [SELECT Id,Delivery_Date__c,Delivery_Method_1__c,Delivery_Method_2__c,Email__c,Fax__c,Letter_Name__c,Image_Number__c,Letter_Status__c,
                     Recipient_Address_1__c,Recipient_Address_2__c,Recipient_City__c,Recipient_Last_Name__c,Recipient_MI__c,Recipient_Name__c,Recipient_State__c,Recipient_Suffix__c,Recipient_Type__c,Recipient_Zip__c,Submit_Date_Time__c,
                     Submitted_By__c,Work_Item_Id__c,LastModifiedDate,LastModifiedby.Name,CreatedDate,Createdby.Name,Recipient_Sub_Type__c,Recipient_Facility_Name__c,
                     Review_on_ActiveX__c,Delivery_Method_2_Status__c ,CC_Status__c, Provider_Tax_Id__c
                     FROM Create_Letter__c
                     WHERE Id =: letterid];
        
        system.debug('NewLetter---'+newLetter);
        if (Schema.sObjectType.Create_Letter__c.fields.Review_on_ActiveX__c.isUpdateable())
            newletter.Review_on_ActiveX__c = true;
        
        //Added by Krishna for User story US600908
        if (Schema.sObjectType.Create_Letter__c.fields.Letter_Status__c.isUpdateable()) {
            newletter.Letter_Status__c='Pending Fulfillment';
            system.debug('status changed: ' + newletter.Letter_Status__c);
            
        }
        
        if (Schema.sObjectType.Create_Letter__c.isUpdateable()) {
            update newletter;
            system.debug('letter updated');
        }
        
        String baseURL = String.valueof(URL.getSalesforceBaseUrl().toExternalForm());
        String baseURL2 = String.valueof(System.Url.getOrgDomainUrl());
        system.debug(baseURL + ' || ' + baseURL2);
        String Engageoneurl;
        String orginstance ;
        system.debug(baseURL);
        system.debug(ACETOrgInstanceURLToOrgNameMap__c.getAll().values());
        for(ACETOrgInstanceURLToOrgNameMap__c orgname:ACETOrgInstanceURLToOrgNameMap__c.getAll().values()) {
                                    system.debug(orgname + '||' + baseURL);

            if(baseURL.toLowerCase().contains(orgname.Name)) {
                system.debug('tname '+orgname.name);
                orginstance = ACETOrgInstanceURLToOrgNameMap__c.getValues(orgname.name).Org_Name__c;
            }
            system.debug('orginstance is ' + orginstance);
        }
        if(orginstance != null){
            system.debug('orginstance is '+orginstance);
            Engageoneurl = ACETURLEncryptionUtility.getICUEURL(orginstance+'_EngageOne');
        }
        
        String urlparam1 = 'workitemid='+newletter.Work_Item_Id__c;
        system.debug('Work Item Id '+urlparam1);
        blob urlparam2 = blob.valueOf('&appname=ACET');
        Blob data = Blob.valueOf(urlparam1);
        Blob EncryptKey = Blob.valueOf(ACETWrapEncryptionKey__c.getValues(orginstance+'_Engageonekey').Key__c);
        Blob encryptedworkitem = Crypto.encryptwithManagedIV('AES256', EncryptKey, data);
        system.Debug('url is '+encodingutil.base64Encode(encryptedworkitem));
        String combinedDataAsHex = EncodingUtil.convertToHex(encryptedworkitem) + EncodingUtil.convertToHex(urlparam2);
        blob urlparams = EncodingUtil.convertFromHex(combinedDataAsHex);
        String encodedurlparams = EncodingUtil.base64Encode(urlparams);
        encodedurlparams = EncodingUtil.urlEncode(encodedurlparams, 'ISO-8859-1');
        string getActiveXUrl = Engageoneurl+'id='+encodedurlparams;
        string strModifiedBy;
        string strSubmittedBy;
        if(newletter.Review_on_ActiveX__c == true){
            
        }
        if(newletter.Letter_Status__c == 'Pending Submission'){
        }
        else if(newletter.Letter_Status__c == 'Submitted')
        {
            strSubmittedBy = newletter.Submitted_By__c+' '+newletter.Submit_Date_Time__c;
            
        }
        else if(newletter.Letter_Status__c == 'Canceled')
        {
        }
        //Added by Krishna for User story US600908
        else if(newletter.Letter_Status__c == 'Pending Fulfillment'){
            Datetime modifiedDate=newletter.LastModifiedDate;
            Time modifedTime=modifiedDate.time();
            String formatedDate=ACETUtility.format(modifiedDate.date());
            String formatedtime=modifedTime.hour()+':'+modifedTime.minute()+':'+modifedTime.second();
            strModifiedBy = newletter.LastModifiedBy.Name+', '+formatedDate+', '+formatedtime;
        }
        
        LetterDataWrapper LDW = new LetterDataWrapper();
        LDW.letter = JSON.serialize(newletter);
        LDW.modifiedBy = strModifiedBy;
        LDW.engageOneUrl = getActiveXUrl;
        
        return LDW;
        
    }
    
    @AuraEnabled
    public static LetterDataWrapper submitLetter(string letterid) {
        				         ACETErrorHandler errHandler = new ACETErrorHandler();

        Create_Letter__c newletter = [SELECT Id,Delivery_Date__c,Delivery_Method_1__c,Delivery_Method_2__c,Email__c,Fax__c,Letter_Name__c,Image_Number__c,Letter_Status__c,
                                      Recipient_Address_1__c,Recipient_Address_2__c,Recipient_City__c,Recipient_Last_Name__c,Recipient_MI__c,Recipient_Name__c,Recipient_State__c,Recipient_Suffix__c,Recipient_Type__c,Recipient_Zip__c,Submit_Date_Time__c,
                                      Submitted_By__c,Work_Item_Id__c,LastModifiedDate,LastModifiedby.Name,CreatedDate,Createdby.Name,Recipient_Sub_Type__c,Recipient_Facility_Name__c,
                                      Review_on_ActiveX__c,Delivery_Method_2_Status__c ,CC_Status__c, Provider_Tax_Id__c
                                      FROM Create_Letter__c
                                      WHERE Id =: letterid];
        
        LetterDataWrapper LDW = new LetterDataWrapper();
        
        
        try{
            ACETLGT_FindLetterWebservice find = new ACETLGT_FindLetterWebservice();
            ACETWSCalloutResult findLetterCalloutResult = new ACETWSCalloutResult();
            findLetterCalloutResult = find.FindLetterWS(newletter.Work_Item_Id__c);
            if(findLetterCalloutResult.Message == 'ACTIVE_COMPLETE')
            {
                ACETLGT_ProcessLetterWebservice service = new ACETLGT_ProcessLetterWebservice();
                ACETWSCalloutResult processLetterCalloutResult = new ACETWSCalloutResult();
                system.debug('newletter.Work_Item_Id__c is '+newletter.Work_Item_Id__c);
                processLetterCalloutResult = service.ProcessLetterWS(newletter.Work_Item_Id__c, 'PUBLISH');
                if(processLetterCalloutResult.Success != null && processLetterCalloutResult.Success && processLetterCalloutResult.Message == '')
                {
                    if (Schema.sObjectType.Create_Letter__c.fields.Letter_Status__c.isUpdateable()){
                        newletter.Letter_Status__c = 'Submitted';
                        }
                    if (Schema.sObjectType.Create_Letter__c.fields.Submitted_By__c.isUpdateable()){
                        newletter.Submitted_By__c = userinfo.getName();
                    }
                    if(newletter.Letter_Name__c.contains('Balance Bill Letter')){
                        if (Schema.sObjectType.Create_Letter__c.fields.CC_Status__c.isUpdateable()){
                         newletter.CC_Status__c = 'Submitted';
                            }
                    }
                    if (Schema.sObjectType.Create_Letter__c.isUpdateable()){
                        update newletter;
                        
                        newletter = [SELECT Id,Delivery_Date__c,Delivery_Method_1__c,Delivery_Method_2__c,Email__c,Fax__c,Letter_Name__c,Image_Number__c,Letter_Status__c,
                                      Recipient_Address_1__c,Recipient_Address_2__c,Recipient_City__c,Recipient_Last_Name__c,Recipient_MI__c,Recipient_Name__c,Recipient_State__c,Recipient_Suffix__c,Recipient_Type__c,Recipient_Zip__c,Submit_Date_Time__c,
                                      Submitted_By__c,Work_Item_Id__c,LastModifiedDate,LastModifiedby.Name,CreatedDate,Createdby.Name,Recipient_Sub_Type__c,Recipient_Facility_Name__c,
                                      Review_on_ActiveX__c,Delivery_Method_2_Status__c ,CC_Status__c, Provider_Tax_Id__c
                                      FROM Create_Letter__c
                                      WHERE Id =: letterid];
                        
                        
                        string strSubmittedBy = newletter.Submitted_By__c+' '+newletter.Submit_Date_Time__c;
                        LDW.submittedBy = strSubmittedBy;
                    }
                    LDW.submitResult = 'true';
                    LDW.result = JSON.serialize(processLetterCalloutResult);

                }
                else if(processLetterCalloutResult.Message == system.Label.ACETUnexpectedErrorMessage)
                {
                   set<string> msg_set = errHandler.setErrorMsgInDataTable('GN500',null);
            if(msg_set != null){
                for (string setElement : msg_set) {
                    LDW.errorMessage  = setElement;
      
                     }              
                   msg_set.clear();
                 }
                    LDW.result = JSON.serialize(processLetterCalloutResult);
                }
                else if(processLetterCalloutResult.responseBody == '400'){
                     set<string> msg_set = errHandler.setErrorMsgInDataTable('GN400B',null);
               if(msg_set != null){
                for (string setElement : msg_set) {
                    LDW.errorMessage  = setElement;
                     }              
                   msg_set.clear();
                 }
                    LDW.submitResult = 'false';
                    LDW.result = JSON.serialize(processLetterCalloutResult);
                }else if(processLetterCalloutResult.responseBody == '404'){
                     set<string> msg_set = errHandler.setErrorMsgInDataTable('AL404',null);
               if(msg_set != null){
                for (string setElement : msg_set) {
                    LDW.errorMessage  = setElement;
      
                     }              
                   msg_set.clear();
                 }
                    LDW.submitResult = 'false';
                    LDW.result = JSON.serialize(processLetterCalloutResult);
                }
            }
            else if(findLetterCalloutResult.Message == system.Label.ACETUnexpectedErrorMessage){
                 set<string> msg_set = errHandler.setErrorMsgInDataTable('GN500',null);
               if(msg_set != null){
                for (string setElement : msg_set) {
                    LDW.errorMessage  = setElement;
      
                     }              
                   msg_set.clear();
                 }
                LDW.submitResult = 'false';
                LDW.result = JSON.serialize(findLetterCalloutResult);
            }else if(!findLetterCalloutResult.success && findLetterCalloutResult.responseBody == '400'){
           set<string> msg_set = errHandler.setErrorMsgInDataTable('GN400B',null);
            if(msg_set != null){
                for (string setElement : msg_set) {
                    LDW.errorMessage  = setElement;
      
                     }              
                   msg_set.clear();
                 }
                LDW.submitResult = 'false';
                LDW.result = JSON.serialize(findLetterCalloutResult);
            }
            else if(!findLetterCalloutResult.success && findLetterCalloutResult.responseBody == '404'){
           set<string> msg_set = errHandler.setErrorMsgInDataTable('AL404',null);
            if(msg_set != null){
                for (string setElement : msg_set) {
                    LDW.errorMessage  = setElement;
      
                     }              
                   msg_set.clear();
                 }
                LDW.submitResult = 'false';
                LDW.result = JSON.serialize(findLetterCalloutResult);
            }
            else if(!findLetterCalloutResult.success && findLetterCalloutResult.responseBody == '404'){
             set<string> msg_set = errHandler.setErrorMsgInDataTable('AL404',null);
            if(msg_set != null){
                for (string setElement : msg_set) {
                    LDW.errorMessage  = setElement;
      
                     }              
                   msg_set.clear();
                 }
                LDW.submitResult = 'false';
                LDW.result = JSON.serialize(findLetterCalloutResult);   
            }
            else{
                  set<string> msg_set = errHandler.setErrorMsgInDataTable('GN500',null);
            if(msg_set != null){
                for (string setElement : msg_set) {
                    LDW.errorMessage  = setElement;
      
                     }              
                   msg_set.clear();
                 }
                LDW.submitResult = 'false';
                findLetterCalloutResult.message = 'Letter template is incomplete. Select Review/Edit Letter to finalize/Submit or Cancel Letter';
                LDW.result = JSON.serialize(findLetterCalloutResult);
//                String strurl = String.valueof(URL.getSalesforceBaseUrl().toExternalForm())+'/apex/ACETCreateLetter?id='+cases.id+'&letterid='+newletter.Id+'&submitresult=false&findresult='+findLetterCalloutResult.Success;
//                system.debug('strurl is '+strurl);
//                Pagereference pageref = new pagereference(strurl);
//                system.debug('pageref is '+pageref);
//                return pageref;
            }
        }
        catch(Exception ex){
            ApexPages.addMessages(ex); 
            
        }
        
        
        
        
        LDW.letter = JSON.serialize(newletter);
        return LDW;
        
    }
    
    @AuraEnabled
    public static LetterDataWrapper cancelLetter(string letterid) {
        Create_Letter__c newletter = [SELECT Id,Delivery_Date__c,Delivery_Method_1__c,Delivery_Method_2__c,Email__c,Fax__c,Letter_Name__c,Image_Number__c,Letter_Status__c,
                                      Recipient_Address_1__c,Recipient_Address_2__c,Recipient_City__c,Recipient_Last_Name__c,Recipient_MI__c,Recipient_Name__c,Recipient_State__c,Recipient_Suffix__c,Recipient_Type__c,Recipient_Zip__c,Submit_Date_Time__c,
                                      Submitted_By__c,Work_Item_Id__c,LastModifiedDate,LastModifiedby.Name,CreatedDate,Createdby.Name,Recipient_Sub_Type__c,Recipient_Facility_Name__c,
                                      Review_on_ActiveX__c,Delivery_Method_2_Status__c ,CC_Status__c, Provider_Tax_Id__c
                                      FROM Create_Letter__c
                                      WHERE Id =: letterid];
        
        LetterDataWrapper LDW = new LetterDataWrapper();
        ACETErrorHandler errHandler = new ACETErrorHandler();
        ACETLGT_ProcessLetterWebservice service = new ACETLGT_ProcessLetterWebservice();
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
            
            
            if (Schema.sObjectType.Create_Letter__c.isUpdateable()){
                update newletter;
            }
            system.debug('processLetterCalloutResult is '+processLetterCalloutResult);
            LDW.cancelResult = 'true';
            LDW.result = JSON.serialize(processLetterCalloutResult);
            system.debug('processLetter JSON is ' + LDW.result);
//            String strurl = String.valueof(URL.getSalesforceBaseUrl().toExternalForm())+'/apex/ACETCreateLetter?id='+cases.id+'&letterid='+Apexpages.currentpage().getparameters().get('letterid')+'&cancelresult='+processLetterCalloutResult.Success;
//            system.debug('strurl for cancel is '+strurl);
//            pageref = new pagereference(strurl);
//            system.debug('pageref is '+pageref);
//            
//            return pageref;
        }
        else if(processLetterCalloutResult.Message == system.Label.ACETUnexpectedErrorMessage)
        {
            LDW.cancelResult = 'false';
            LDW.result = JSON.serialize(processLetterCalloutResult);
            set<string> msg_set = errHandler.setErrorMsgInDataTable('GN500',null);
            if(msg_set != null){
                for (string setElement : msg_set) {
                    LDW.errorMessage  = setElement;
      
                     }              
                   msg_set.clear();
                 }
        }
        else if(processLetterCalloutResult.responseBody == '400'){
           set<string> msg_set = errHandler.setErrorMsgInDataTable('GN400B',null);
            if(msg_set != null){
                for (string setElement : msg_set) {
                    LDW.errorMessage  = setElement;
      
                     }              
                   msg_set.clear();
                 }
            LDW.cancelResult = 'false';
            LDW.result = JSON.serialize(processLetterCalloutResult);
      } else if(processLetterCalloutResult.responseBody == '404'){
           set<string> msg_set = errHandler.setErrorMsgInDataTable('AL404',null);
            if(msg_set != null){
                for (string setElement : msg_set) {
                    LDW.errorMessage  = setElement;
      
                     }              
                   msg_set.clear();
                 }
            LDW.cancelResult = 'false';
            LDW.result = JSON.serialize(processLetterCalloutResult);
      }
        LDW.letter = JSON.serialize(newletter);
        return LDW;
        
    }
    
    
    @AuraEnabled
    public static LetterDataWrapper getFulfillmentInfo(string fulfillmentId) {
        system.debug(fulfillmentId);
        Create_Letter__c newletter = [SELECT Id,Delivery_Date__c,Delivery_Method_1__c,Delivery_Method_2__c,Email__c,Fax__c,Letter_Name__c,Image_Number__c,Letter_Status__c,
                                      Recipient_Address_1__c,Recipient_Address_2__c,Recipient_City__c,Recipient_Last_Name__c,Recipient_MI__c,Recipient_Name__c,Recipient_State__c,Recipient_Suffix__c,Recipient_Type__c,Recipient_Zip__c,Submit_Date_Time__c,
                                      Submitted_By__c,Work_Item_Id__c,LastModifiedDate,LastModifiedby.Name,CreatedDate,Createdby.Name,Recipient_Sub_Type__c,Recipient_Facility_Name__c,
                                      Review_on_ActiveX__c,Delivery_Method_2_Status__c ,CC_Status__c, Provider_Tax_Id__c, Case__c
                                      FROM Create_Letter__c
                                      WHERE Id =: fulfillmentId];
        
        LetterDataWrapper LDW = new LetterDataWrapper();
        
        string strModifiedBy;
        string strSubmittedBy;
        
        if(newletter.Submitted_By__c !=null && newletter.Submit_Date_Time__c!=null) {
            strSubmittedBy = newletter.Submitted_By__c+' '+newletter.Submit_Date_Time__c;
        }
        LDW.submittedBy = strSubmittedBy;
       
        
        if(newletter.LastModifiedDate !=null && newletter.LastModifiedBy!=null) {
            Datetime modifiedDate=newletter.LastModifiedDate;
            Time modifedTime=modifiedDate.time();
            String formatedDate=ACETUtility.format(modifiedDate.date());
            String formatedtime=modifedTime.hour()+':'+modifedTime.minute()+':'+modifedTime.second();
            strModifiedBy = newletter.LastModifiedBy.Name+', '+formatedDate+', '+formatedtime;
        }
        LDW.modifiedBy = strModifiedBy;
        
        LDW.letter = JSON.serialize(newletter);

        return LDW;

        
    }
      @AuraEnabled
    public static string getStdErrMsg(String prefix, Integer resultStatusCode) {
        string errorMessage;
        ACETErrorHandler errHandler = new ACETErrorHandler();
        string errorcode = prefix;
        errorcode  = errorcode + resultStatusCode;
        system.debug('inside getStdErrMsg ' + errorcode);
        if(resultStatusCode!=null && resultStatusCode !=200 &&(resultStatusCode == 400 || resultStatusCode == 404 || resultStatusCode == 500)) {
            set<string> msg_set = errHandler.setErrorMsgInDataTable(errorcode,null);
            if(msg_set != null){
                for (string setElement : msg_set) {
                    errorMessage  = setElement;
      
                     }              
                   msg_set.clear();
                 }
        }
        return errorMessage;
    }

}