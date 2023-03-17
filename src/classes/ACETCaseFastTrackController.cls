public with sharing class ACETCaseFastTrackController extends ACETErrorHandler{
    public Interaction__c Interaction {get;set;}
    public Third_Party__c ThirdParty {get;set;}
    public Case CaseObj {get;set;}
    public ACETHighlightsPanelAdditionalInfo AdditionalInfo {get;set;}
    
    public ACETCaseFastTrackController(){

        String caseId = ApexPages.currentPage().getParameters().get('caseId');
        String Autodoc = ApexPages.currentPage().getParameters().get('autoDoc');      
        CaseObj = [select Interaction__c,Originator_name__c, Surrogate_Key__c, Subject_Group_ID__c, Topic__c, Originator_Type__c, ID__c, TaxId__c, Caller__c, AutoDoc__c, Originator_Relationship__c, Interaction__r.Originator__r.LastName from Case where Id = :caseId];        
        if(CaseObj != null){
            Interaction = (Interaction__c)ACETQueryUtil.query(CaseObj.Interaction__c, 'Interaction__c');
        } 
         if(Interaction != null && Interaction.Third_Party__C != null){
        ThirdParty =[SELECT Mailing_PostalCode__c,DOB__c,Email__c,Employer_Name__c,First_Name__c,Flow_Name__c,FullName__c,Group_Name__c,Group_Number__c,Id,LastName__c,Mailing_State__c,NPI__c,Phone_Number__c,Tax_ID__c,Producer_Id__c,Producer_Name__c FROM Third_Party__c where ID=:Interaction.Third_Party__C];
        }
        String ADS = '';
        
        if(CaseObj.AutoDoc__c != null && CaseObj.AutoDoc__c !=''){
            ADS = CaseObj.AutoDoc__c;
        }else{
            try{
           List<ContentDocumentLink> attachAutoDoc = [select ContentDocumentId,LinkedEntityId from ContentDocumentLink where LinkedEntityId=:caseId];
            if(attachAutoDoc != null && attachAutoDoc.size()>0){
              List<ContentVersion>  conVer = [select ContentDocumentId,VersionData from ContentVersion where ContentDocumentId =:attachAutoDoc[0].ContentDocumentId];
                if(conVer != null && conVer.size()>0){
                    ADS = conVer[0].VersionData.toString();
                }
            }
            }Catch(QueryException qe){
                System.debug('There is no autodoc content available');
            }
        }
         
         
        system.debug('CaseObj::'+CaseObj);
        /*system.debug('autodoc1-->' + CaseObj.AutoDoc__c);
        system.debug('autodoc2-->' + Autodoc);
        system.debug('autodoc3-->' + ADS);*/
        
        AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
        AdditionalInfo.RelationshipType = CaseObj.Originator_Relationship__c;
        AdditionalInfo.OriginatorRelationship = CaseObj.Originator_Relationship__c;
        AdditionalInfo.contactName = CaseObj.Caller__c;
        AdditionalInfo.producerName = CaseObj.Caller__c;
        if(CaseObj.Originator_Type__c=='Provider'){
            AdditionalInfo.providerType = 'test';
            if(ADS!=null){
                //boolean ConNameFound = false;
                boolean PPhoneFound = false;
                boolean PlatProvFound = false;
                boolean PrimSpecFound = false;
                String ADwithoutCSS = ADS.split('<div class="highlights-panel-collapsible">')[1];
                String ADProvInfo = ADwithoutCSS.split('<table width="100%" cellspacing="10">')[0];
                String [] ADLabelList = ADProvInfo.split('<label class="outputLabelPanel">');
                system.debug('ADProvInfo-->' + ADPRovInfo);
                for(integer i=0; i<ADLabelList.size(); i++){
                    /*if(ADLabelList[i].contains('Contact Name')){
                        ConNameFound = true;
                        String temp1 = ADLabelList[i].split('</label>')[1];
                        String temp2 = temp1.split('</span>')[0];
                        system.debug('Contact Name' + temp2);
                        AdditionalInfo.contactName = temp2;
                    }
                    else*/ if(ADLabelList[i].contains('Phone Number')){
                        PPhoneFound = true;
                        String temp1 = ADLabelList[i].split('</label>')[1];
                        String temp2 = temp1.split('</span>')[0];
                        system.debug('Provider Phone Number' + temp2);
                        AdditionalInfo.providerPhoneNumber = temp2;
                    }
                    else if(ADLabelList[i].contains('Platinum Provider')){
                        PlatProvFound = true;
                        String temp1 = ADLabelList[i].split('</label>')[1];
                        String temp2 = temp1.split('</span>')[0];
                        system.debug('Platinum Provider' + temp2);
                        AdditionalInfo.platinumProvider = temp2;
                    }
                    else if(ADLabelList[i].contains('Primary Specialty')){
                        PrimSpecFound = true;
                        String temp1 = ADLabelList[i].split('</label>')[1];
                        String temp2 = temp1.split('</span>')[0];
                        system.debug('Primary Specialty' + temp2);
                        AdditionalInfo.primarySpecialty = temp2;
                    }
                    if(PPhoneFound && PlatProvFound && PrimSpecFound){
                        i = ADLabelList.size();
                    }
                }
            }
        }
    } 
    
    public String getHpAdditionInfoStr(){
    if(CaseObj.Originator_Type__c=='Other'){
    if(ThirdParty.Flow_Name__c=='ProviderNotFoundFlow'){
    AdditionalInfo.providerType ='FACL';
    AdditionalInfo.providerPhoneNumber=ThirdParty.Phone_Number__c;
    }
   else if(ThirdParty.Flow_Name__c=='GroupNotFoundFlow'){
    AdditionalInfo.Zip=ThirdParty.Mailing_PostalCode__c;
    AdditionalInfo.State = ThirdParty.Mailing_State__c;
    AdditionalInfo.PhoneNumber=ThirdParty.Phone_Number__c;
    AdditionalInfo.EmployerName=ThirdParty.Employer_Name__c;
    //AdditionalInfo.MemberId= CaseObj.ID__c;
    AdditionalInfo.GroupN=CaseObj.Subject_Group_ID__c;
    AdditionalInfo.RelationshipType=CaseObj.Originator_Relationship__c;
    AdditionalInfo.OriginatorRelationship=CaseObj.Originator_Relationship__c;
    AdditionalInfo.isGroupNotFound = '1';
    }else if(ThirdParty.Flow_Name__c=='ProducerNotFoundFlow'){
    AdditionalInfo.isProducerNotFound = '1';
    AdditionalInfo.producerIDPNF = ThirdParty.Producer_Id__c;
    AdditionalInfo.State = ThirdParty.Mailing_State__c;
    AdditionalInfo.PhoneNumber = ThirdParty.Phone_Number__c;  
    }
    }
        return EncodingUtil.urlEncode(JSON.serialize(AdditionalInfo), 'UTF-8');
    }
    
    @RemoteAction
    public static ACETWSCalloutResult findMember(String memberId){
        ACETFindMemberWebService service = new ACETFindMemberWebService();
        service.init(memberId, '', '', '', '', '');
        return service.queryPaginatedData(1,10,1);                
    }  
    
    @RemoteAction
    public static ACETWSCalloutResult findGroup(String groupId){
        ACETFindEmployerGroupSearchWebService service = new ACETFindEmployerGroupSearchWebService();
        service.init(groupId, '', '', '');
        return service.queryPaginatedData(1,1,1);                
    }  
    
    @RemoteAction
    public static ACETWSCalloutResult findProvider(String providerId, String taxId, String zipCode){
        ACETFindProviderLookupWebservice service = new ACETFindProviderLookupWebservice();
        service.GetEndpoint();
        service.Init(providerId, null, taxId, null, null, null, null,null, zipCode, null, null, null, null,null, null, null, null, null, null , null ,null,null,'false',null,null);
        return service.queryPaginatedData(0,service.PageSize,0);                
    }  
    
    @RemoteAction
    public static ACETWSCalloutResult findProducer(String producerId){
      //  ACETFindProducerWebservice service = new ACETFindProducerWebservice();  
      //  service.init('', '', producerID, '', '', '', '', '', '', '',''); 
        ACETFindProducerAPI service = new ACETFindProducerAPI();  
        service.init(producerID,'', '', '', '', '', '', '', '', '','','','','',''); 
        return service.queryPaginatedData(1,50,1);                
    }  
    
    public void messageClass() {
         String messagecode= Apexpages.currentPage().getParameters().get('messagecode');
         system.debug('messagecode-->'+messagecode);
         setErrorMsg(messagecode);
         
}

    
       
}