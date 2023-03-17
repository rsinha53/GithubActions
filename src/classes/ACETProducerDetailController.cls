public with sharing class ACETProducerDetailController extends ACETErrorHandler 
{
    public ACETProducerResult producerDetailresult { get; set;} 
    public id contactid{ get; set;}
     //This lines are used for producer group
   //  public List<ACETProducerResult> producersDetailResults { get; set;}
     public List<ACETProducerResult.ACETGroupInfoWrapper> GroupsList{get;set;}        
     public List<ACETProducerResult.ACETGroupInfoWrapper> GroupHistoryList{get;set;} 
    public list<String> cwList;
     public Boolean isGroupHistory{get;set;} 
    
   // public String statusFlag {get;set;}
    public String interactionId{ get; set;}
     public String hpAdditionInfoStr {get{
        return EncodingUtil.urlEncode(JSON.serialize(AdditionalInfo), 'UTF-8');
    }set;}
    public String Id { get; set;}
   // public Boolean isGroupHistory{get;set;} // added by Harish for US US705141
    public Interaction__c Interaction { get; set;}
    public Contact Subject { get; set;}
    public ACETHighlightsPanelAdditionalInfo AdditionalInfo { get; set;}
    public list<Alert__c> lstMemAlert{ get; set;}
    public list<Alert__c> lstProducerAlert{ get; set;}//added by Harish for Alert
    public String SourceOriginator { get; set;}
    public ACETCallTopicsDataWrapper wrapper { get; set;}   
    public String producerId { get; set; }   
    public List<SelectOption> contactTypeOptions { get; set;}
    public String contactType { get; set;}
    public String originatorName { get; set;}
    public String firstName {get; set;}
    public String lastName {get; set;}
    public String contactName { get; set;}
    public boolean isShowALert{get;set;}
    public boolean displayCName{get; set;}
    //continuation web call
    ACETGetProducerAPI ACETPDWS;
    ACETGetProducerAPI ACETPDWSFutureGroups;
    public ACETProducerResult prodDetailresltfuture { get; set;}
    
    //Added by Avish as a part of US813401 on 12042017
    public String prodNotFound {get; set;}
    public String producerIdPNF {get;set;}
    public String producerNamePNF {get;set;}
    public String contactNamePNF {get;set;}
    public String phoneNumberPNF {get;set;}
    public Double Offset{get;set;} 
    
    public ACETProducerDetailController(){
      try{
        displayCName = false;
        if(!String.ISBLANK(ApexPages.currentPage().getParameters().get('firstName')) )
            firstName = EncodingUtil.urlDecode(ApexPages.currentPage().getParameters().get('firstName'), 'UTF-8').unescapeHtml4();
        if(!String.ISBLANK(ApexPages.currentPage().getParameters().get('lastName')) )
            lastName = EncodingUtil.urlDecode(ApexPages.currentPage().getParameters().get('lastName'), 'UTF-8').unescapeHtml4();
        producerId = ApexPages.currentPage().getParameters().get('ProducerId');
        Id = ApexPages.currentPage().getParameters().get('Id');
        //contactType = 'Broker';
        contactType = 'Producer Contact';
        //Added by Avish on 12042017 as a part of US813401
        prodNotFound = ApexPages.currentPage().getParameters().get('pnf');
        producerNamePNF = ApexPages.currentPage().getParameters().get('PNFProducerName');
        contactNamePNF = ApexPages.currentPage().getParameters().get('PNFContactName');
        phoneNumberPNF = ApexPages.currentPage().getParameters().get('PNFPhoneNumber');
        producerIdPNF = ApexPages.currentPage().getParameters().get('PNFProducerId');
        
        //End of US813401
        timeZone tz = UserInfo.getTimeZone();
        Offset = tz.getOffset(DateTime.now()) / (1000 * 3600 * 24.0);
        
        interactionId = ApexPages.currentPage().getParameters().get('InteractionId'); 
        system.debug('InteractionId: ' + InteractionId); 
       // statusFlag = 'present';
        contactId  = null;
        contactTypeOptions = new List<SelectOption>();
        contactTypeOptions.add(new SelectOption('----None----','----None----'));
        contactTypeOptions.add(new SelectOption('Agent of Record', 'Agent of Record'));
        contactTypeOptions.add(new SelectOption('General Agent', 'General Agent'));
        contactTypeOptions.add(new SelectOption('Service Provider', 'Service Provider'));
        //contactTypeOptions.add(new SelectOption('Broker', 'Broker'));
        //contactTypeOptions.add(new SelectOption('General Agent' , 'General Agent'));        
                Interaction = ACETMemberQueryUtil.queryInteraction(interactionId);
            system.debug('Interaction.Originator__c: ' + Interaction.Originator__c); 
            if(!String.isBlank(Interaction.Originator__c))
                Subject = ACETMemberQueryUtil.queryContact(Interaction.Originator__c);
        isGroupHistory = false;
        AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
        system.debug('producerIdPNF @@@' + producerIdPNF);
        //Added by Avish as a part of US813401 on 12042017
        if(prodNotFound == '1'){
            contactName = contactNamePNF;
            AdditionalInfo.isProducerNotFound = '1';
            AdditionalInfo.producerName = producerNamePNF;
            AdditionalInfo.contactName = contactNamePNF;
            AdditionalInfo.RelationshipType = contactType;
            AdditionalInfo.phoneNumberPNF = phoneNumberPNF;    
            AdditionalInfo.producerIDPNF = producerIdPNF; 
        }        
        AdditionalInfo.producerSubject = Interaction.Originator__r.Name;
        AdditionalInfo.producerOriginator =  Interaction.Originator__r.Name;
        AdditionalInfo.producerId = Interaction.Originator__r.EID__c;            
        hpAdditionInfoStr = JSON.serialize(AdditionalInfo);      
        //lstProducerAlert = new list<Alert__c>();
       //contact name from case fast track
      String fastTrack = ApexPages.currentPage().getParameters().get('fastTrack');
       system.debug('Before Fast Track====='+contactType);       
       if(fastTrack == 'true'){
        system.debug('after Fast Track====='+contactType);
         system.debug('Contact Name before in Fast track=='+contactName);
        contactName = ApexPages.currentPage().getParameters().get('contactName');
        contactType = ApexPages.currentPage().getParameters().get('contactType');       
        displayCName = true;
        updateContact();
        
       }    
       }catch(Exception e){
         setErrorMsg('MGD997',e);
        } 
    }
    public void updateContact()
    {
       try{
         isShowALert = true;
         system.debug('after Fast Track====='+contactType);
         if(prodNotFound != '1'){
            AdditionalInfo.producerName = contactName;
            AdditionalInfo.RelationshipType = contactType;
            AdditionalInfo.OriginatorRelationship = contactType;
            AdditionalInfo.producerSubject = (Interaction.Originator__r.Name);
            AdditionalInfo.contactName = ContactName;
            hpAdditionInfoStr = JSON.serialize(AdditionalInfo); 
         }else{
            AdditionalInfo.contactName = contactNamePNF;
            AdditionalInfo.RelationshipType = contactType;
         }  
       }catch(Exception e){
         setErrorMsg('MGD997',e);
        }  
    }
      
    /*public void removeGroupMemberSearch(){
        String addInfo = ApexPages.currentPage().getParameters().get('additionalInfo');       
        if(addInfo != null && addInfo != '')
        {
            AdditionalInfo  = (ACETHighlightsPanelAdditionalInfo)JSON.deserialize(addInfo, ACETHighlightsPanelAdditionalInfo.class);
        }
        system.debug('group====='+AdditionalInfo.groupN);
            AdditionalInfo.groupN = '';
            hpAdditionInfoStr = JSON.serialize(AdditionalInfo);
        
    }*/
    
    public void updateInteraction(){
        if(Interaction != null){
            
        }
    }    
   
     //This lines are used for producer Group
     public PageReference  groupHistoryWindow(){  
       try{      
       // statusFlag ='past';
         GroupHistoryList = new List<ACETProducerResult.ACETGroupInfoWrapper>();
         ACETWSCalloutResult GetProducergroupResponse;
         ACETPDWS = new ACETGetProducerAPI();
         ACETPDWS.flag= 'past'; 
         GetProducergroupResponse = ACETPDWS.GetProducer(producerId);
         if(GetProducergroupResponse.Success){
            try{
               producerDetailresult = (ACETProducerResult)GetProducergroupResponse.Response;
               if(producerDetailresult.producerGrouplist.size()>0){
                 for(ACETProducerResult.ACETGroupInfoWrapper wrapp:producerDetailresult.producerGrouplist){
                   if(String.IsNotBlank(wrapp.groupNumber)||String.IsNotBlank(wrapp.groupName)){
                     GroupHistoryList.add(wrapp);
                   }
                  }
               }
            }catch(Exception ex){
               setErrorMsg('MGD997',ex);
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, system.Label.ACETUnexpectedErrorMessage));
            }
        }
        else{
           if(GetProducergroupResponse.statusCode==001){
              setErrorMsg('GN'+'400B',null);
           }else if((GetProducergroupResponse.statusCode==404)){
             setErrorMsg('GN'+GetProducergroupResponse.statusCode,null);
           }else{
             setErrorMsg('GN'+'500',null);
             }
        }
        isGroupHistory = true;
        System.debug('grouphistory status===='+isGroupHistory);
        }catch(Exception e){
          setErrorMsg('MGD997',e);
        }
        return null;
    }
    
      public void resetWindow(){    
        isGroupHistory = false;        
      } 
         
    public List<Case> getCaseHistory(){
        String Id = ApexPages.currentPage().getParameters().get('ProducerId');
        system.debug('###Id'+Id+'###Subject'+Subject);
        List<Case> cases = [select CaseNumber, Contact.Name,Caller__c, Parent.Id, Parent.CaseNumber,ContactId, CreatedBy.Name, CreatedDate, Topic__c, Status, Originator_Type__c, Interaction_Type__c, Rollup_Fulfillment__c,Original_Type__c, 
                                Interaction__c,Interaction__r.Name,Interaction__r.Group_ID__c,Interaction__r.Producer_ID__c,
                                (SELECT Id FROM Create_Letters__r) from Case where ContactId =: Subject.id OR (Interaction__r.Producer_ID__c=:Id AND Originator_Type__c = 'Producer') order by CreatedDate desc limit 500];
        
        system.debug('###Cases'+cases);
        
        return cases;
    }
    
    public Object CallGetProducerWS1(){
        Continuation PageLoadContinuation;    
        try{
            ACETPDWS = new ACETGetProducerAPI();
            cwList = new List<String>();
            ACETPDWS.flag = 'present';
            ACETGetProducerAPI.ContinuationWrapper cw1 = ACETPDWS.AddHttpRequest(producerId,'PDWebserviceCallBack',null);
            PageLoadContinuation = cw1.oContinuation;
            cwList.add(cw1.requestLabel);
            ACETPDWSFutureGroups = new ACETGetProducerAPI();
            ACETPDWSFutureGroups.flag = 'future';
            ACETGetProducerAPI.ContinuationWrapper cw2 = ACETPDWSFutureGroups.AddHttpRequest(producerId,'PDWebserviceCallBack',PageLoadContinuation);
            PageLoadContinuation = cw2.oContinuation;
            cwList.add(cw2.requestLabel);
            System.debug('Entery PageLoadContinuation'+PageLoadContinuation);
        }Catch(Exception e){
        } 
        return PageLoadContinuation;
    }
    
    public PageReference PDWebserviceCallBack(){
        GroupsList=new List<ACETProducerResult.ACETGroupInfoWrapper>();
        
        HTTPResponse producerHTTPResponse = Continuation.getResponse(cwList[0]);   
        if(producerHTTPResponse != null){
            ACETWSCalloutResult GetProducerResponse = new ACETWSCalloutResult();
            GetProducerResponse.statusCode = producerHTTPResponse.getStatusCode();
            GetProducerResponse.Success = false;
            if(producerHTTPResponse.getStatusCode()==200){
                GetProducerResponse.Success = true;
                GetProducerResponse.Response = ACETPDWS.parseSuccessAdapterResponse(ACET_WebServiceUtils.ReplaceKeywords(producerHTTPResponse.getBody()));
            }
            
            if(GetProducerResponse!=null && GetProducerResponse.Success){
                try{
                    producerDetailresult = (ACETProducerResult)GetProducerResponse.Response;
                    if(producerDetailresult!=null && producerDetailresult.producerGrouplist!=null && producerDetailresult.producerGrouplist.size()>0){
                        for(ACETProducerResult.ACETGroupInfoWrapper wrapp:producerDetailresult.producerGrouplist){
                            if(String.IsNotBlank(wrapp.groupNumber)||String.IsNotBlank(wrapp.groupName)){
                                GroupsList.add(wrapp);
                            }
                        }
                    }
                    getNumberOfProducerAlert();
                }catch(Exception ex){
                   //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, system.Label.ACETUnexpectedErrorMessage));
                    setErrorMsg('MGD997',ex);
                }
            }else{
                if(GetProducerResponse.statusCode==001){
                    setErrorMsg('GN'+'400B',null);
                }else if((GetProducerResponse.statusCode==404)){
                    setErrorMsg('GN'+GetProducerResponse.statusCode,null);
                }else{
                    setErrorMsg('GN'+'500',null);
                }
            }
        }
        HTTPResponse producerGroupHTTPResponse = Continuation.getResponse(cwList[1]);
        if(producerGroupHTTPResponse!=null){
            ACETWSCalloutResult GetProducerGrpResponse = new ACETWSCalloutResult();
            GetProducerGrpResponse.statusCode =  producerGroupHTTPResponse.getStatusCode();
            GetProducerGrpResponse.Success =false;
            if(producerGroupHTTPResponse.getStatusCode()==200){
                GetProducerGrpResponse.Success = true;
                GetProducerGrpResponse.Response = ACETPDWSFutureGroups.parseSuccessAdapterResponse(ACET_WebServiceUtils.ReplaceKeywords(producerGroupHTTPResponse.getBody()));
            }
            
            if(GetProducerGrpResponse!=null && GetProducerGrpResponse.Success){
                try{
                    prodDetailresltfuture = (ACETProducerResult)GetProducerGrpResponse.Response;
                    if(prodDetailresltfuture!=null && prodDetailresltfuture.producerGrouplist!=null && prodDetailresltfuture.producerGrouplist.size()>0){
                        for(ACETProducerResult.ACETGroupInfoWrapper wrapp:prodDetailresltfuture.producerGrouplist){
                            if(String.IsNotBlank(wrapp.groupNumber)||String.IsNotBlank(wrapp.groupName)){
                                GroupsList.add(wrapp);
                            }
                        }
                    }
                    system.debug('producer group future in controller'+producerDetailresult.producerGrouplist);
                }catch(Exception ex){
                    System.debug(ex.getLineNumber()+'\n'+ex.getMessage()+'\n'+ex.getStackTraceString());
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, system.Label.ACETUnexpectedErrorMessage));
                }
            }else{
                if(GetProducerGrpResponse.statusCode==001){
                    setErrorMsg('GN'+'400B',null);
                }else if((GetProducerGrpResponse.statusCode==404)){
                    setErrorMsg('GN'+GetProducerGrpResponse.statusCode,null);
                }else{
                    setErrorMsg('GN'+'500',null);
                }
            }
        }
        return null; 
    } 
    
    public void getNumberOfProducerAlert()
    {
       ACETInteractionHighlightsPanelController AlertNo = new ACETInteractionHighlightsPanelController();     
           if(producerDetailresult!=null && producerDetailresult.producerId!=null){
             lstProducerAlert= AlertNo.getNoAlert(null,null,producerDetailresult.producerId,null);
           }
           system.debug('-----------producer alerts-------------'+lstProducerAlert);
           system.debug('lstProducerAlert is '+lstProducerAlert);
           if(lstProducerAlert != null && lstProducerAlert.size()>0){
               list<Interaction_Alert__c> lstIntAlert = new list<Interaction_Alert__c>();
               for(Alert__c varalert : lstProducerAlert){
                   Interaction_Alert__c intAlert = new Interaction_Alert__c();
                   intAlert.Alert__c = varAlert.id;
                   intAlert.Interaction__c = Interaction.Id;
                   intAlert.Alert_Title_at_Display__c = varAlert.Alert_Title__c;
                   intAlert.Alert_Comments_at_Display__c= varAlert.Alert_Comments__c;
                   intAlert.Intercation_Alert_Unique_Id_del__c = String.valueof(varAlert.id)+String.valueof(Interaction.id)+producerDetailresult.producerId;
                   lstIntAlert.add(intAlert); 
               }
               try{
                    //US1008265/US1056408 Checkmarx code
                    if(Interaction_Alert__c.sObjectType.getDescribe().isCreateable()
                        && Schema.sObjectType.Interaction_Alert__c.fields.Alert__c.isUpdateable()
                        && Schema.sObjectType.Interaction_Alert__c.fields.Intercation_Alert_Unique_Id_del__c.isUpdateable()
                        && Schema.sObjectType.Interaction_Alert__c.fields.Alert_Comments_at_Display__c.isUpdateable()
                        && Schema.sObjectType.Interaction_Alert__c.fields.Alert_Title_at_Display__c.isUpdateable()
                        && Schema.sObjectType.Interaction_Alert__c.fields.Interaction__c.isUpdateable()){
                        upsert lstIntAlert Intercation_Alert_Unique_Id_del__c;  
                    }
               }
               Catch(DMLException e){
               setErrorMsg('MGD997',e);
                   //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Exception during insertion on Interaction Alert.'));
               }
           } 
    }
    
    public List<SelectOption> getCallTopicOptions()
    { 
        List<SelectOption> callTopics = new List<SelectOption>();
        try{
        String prodNF = ApexPages.currentPage().getParameters().get('pnf');
        if(prodNF != '1')
            callTopics = ACETCallTopicsPicklistUtility.getCallTopicOptions('Producer Detail', Interaction.Originator_Type__c);
        else
            CallTopics = ACETCallTopicsPicklistUtility.getCallTopicOptions('Producer Not Found', 'Other');
        }Catch(Exception e){
        }
        return callTopics;
    }


}