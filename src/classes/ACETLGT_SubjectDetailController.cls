public class ACETLGT_SubjectDetailController {
     
    public  class DatatableWrapper{
        @Auraenabled
        public User oUser;
        @Auraenabled
        public case caseobj;  
        @AuraEnabled
        Public Interaction__c Interaction;
        @AuraEnabled 
        Public Third_Party__c ThirdParty;
        @AuraEnabled 
        Public string ADS;
        @AuraEnabled 
        Public ACETHighlightsPanelAdditionalInfo  AdditionalInfo;
         @AuraEnabled 
        Public string invalidcase;
        @AuraEnabled
        Public string result;
         @AuraEnabled 
        Public string error;
        @AuraEnabled 
        Public string flowname; 
        @AuraEnabled
        Public List<ACETLGT_MemberSearchCoveragesResult> CoveragesresultWrapper;
    }
    
    @AuraEnabled
    Public static DatatableWrapper getrecorddata(id cseId){  
        string invalidcase;
        string error;
        string flowname;
            case  CaseObj = [select Interaction__c,Originator_name__c, Surrogate_Key__c, Subject_Group_ID__c, Topic__c, Originator_Type__c, ID__c, TaxId__c, Caller__c, AutoDoc__c, Originator_Relationship__c, Interaction__r.Originator__r.LastName from Case where Id = :cseId limit 1];     
      Interaction__c   Interaction;
        if(CaseObj != null){
          Interaction =    [SELECT Third_Party__c,Question_Type_Code__c,Question_Type__c,Provider_Type__c,Tax_Id__c,Provider_ID__c,Provider_Address_Type__c,Provider_Address_Id__c,Producer_Name__c,Id,Producer_ID__c,Originator_Type__c,NPI__c,Originator_Name__c,Originator__c,Member_Id__c,Member_Date_of_Birth__c,Interaction_Type__c,Id__c,Group_ID__c,tst_Date_Field__c,Contact_Type__c,Contact_Name__c,Caller_Type__c FROM Interaction__c where ID=:CaseObj.Interaction__c];
        } 
        Third_Party__c ThirdParty;
         if(Interaction != null && Interaction.Third_Party__C != null){
        ThirdParty =[SELECT Mailing_PostalCode__c,DOB__c,Email__c,Employer_Name__c,First_Name__c,Flow_Name__c,FullName__c,Group_Name__c,Group_Number__c,Id,LastName__c,Mailing_State__c,NPI__c,Phone_Number__c,Tax_ID__c,Producer_Id__c,Producer_Name__c FROM Third_Party__c where ID=:Interaction.Third_Party__C];
        }
         User oUser = [select id,Name,Agent_Type__c,Profile_Name__c,Role_Name__c FROM User Where id =: userInfo.getUserId()];
      

        if(caseobj.Originator_Type__c =='Other' && ThirdParty.Flow_Name__c == null){  
        invalidcase = 'true';
        }
        system.debug('caseobj.Originator_Type__c==>'+caseobj.Originator_Type__c);
        if(caseobj.Originator_Type__c =='Member'){
            flowname = 'Memberflow';
           
        }else if(caseobj.Originator_Type__c =='Group/Employer'||caseobj.Originator_Type__c =='Broker'||caseobj.Originator_Type__c =='General Agent'||caseobj.Originator_Type__c =='UHG'||caseobj.Originator_Type__c =='Third Party'){
                   flowname = 'Groupflow';
        }else if (caseobj.Originator_Type__c =='Producer'){
                               flowname = 'Producerflow';

        }else if(caseobj.Originator_Type__c =='Provider'){
            flowname = 'Providerflow';
        }
        else if(caseobj.Originator_Type__c =='Other'){
            flowname = 'Other';
        }
         if(flowname == 'Memberflow'&& caseobj.ID__c == null){
                error = 'Member id is missing on case record.';
            }
        else if(flowname == 'Groupflow'&& Interaction.Group_ID__c == null){
                error = 'Group id is missing on interaction record.';
            }     
         else if(flowname == 'Producerflow'&& Interaction.Producer_ID__c == null){
                error = 'Producer id is missing on interaction record.';
            }  
         else if(flowname == 'Providerflow'&& Interaction.Provider_ID__c == null){
                error = 'Provider id is missing on interaction record.';
            } 
             ACETWSCalloutResult cr = new ACETWSCalloutResult();
                       List<ACETLGT_MemberSearchCoveragesResult> resultwrap = new List<ACETLGT_MemberSearchCoveragesResult>(); 

        if(error == null){
        ACETLGT_FindIndMemberShipsWebService FindIndMemService = new ACETLGT_FindIndMemberShipsWebService();
        ACETWSCalloutResult CalloutResult = null;
        CalloutResult = FindIndMemService.findMemberWS(caseobj.ID__c, '', '', '', ' ', '', Interaction.Interaction_Type__c);
        if (CalloutResult.Success)
        {   
            resultwrap= (list<ACETLGT_MemberSearchCoveragesResult>)CalloutResult.Response;
        }else{
             error = 'Unexpected Error Occured. Please Try Agin.';

        }

       ACETFindMemberWebService service = new ACETFindMemberWebService();
        service.init(caseobj.ID__c, '', '', '', '', '');
         cr = service.queryPaginatedData(1,10,1);   
        }
        

     DatatableWrapper dw = new DatatableWrapper();
        dw.caseobj = CaseObj;
        dw.Interaction= Interaction;
        dw.ThirdParty=ThirdParty;
        dw.invalidcase = invalidcase;
        dw.result=JSON.serialize(cr);
        dw.error=error;
        dw.flowname=flowname;
        dw.oUser=oUser;
        dw.CoveragesresultWrapper = resultwrap;
        return dw;
    }
}