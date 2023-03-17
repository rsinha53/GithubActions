public class ETSBE_OpenDetailController {
     @AuraEnabled
    public static Boolean getMockStatus() {
        Boolean isStaticResponseChecked = false;
        isStaticResponseChecked = SAEUtils.getMockStatus();
        return isStaticResponseChecked;
    }
	@AuraEnabled
    Public static String getSelectedGroupInfo(String groupId,String caseId){
		String encoded = EncodingUtil.urlEncode(groupId, 'UTF-8');
        String solarisResults = ETSBE_OneClickController.searchGroup(encoded);
        ETSBE_SolarisGroupDetailResult selectedGroupData = new ETSBE_SolarisGroupDetailResult();
        if(caseId != null && caseId!= '' ){
            Case queryCaseData = [select id,Group_Name__c,Subject_Group_ID__c,Platform__c,Policy__c from Case 
                                  where id=:caseId ];
            String internalResults = ETSBE_OneClickController.searchGroupSBamMerit(groupId);
            List<ETSBE_SolarisGroupDetailResult> newResults = new List<ETSBE_SolarisGroupDetailResult>();
            List<ETSBE_SolarisGroupDetailResult> internalnewResults = new List<ETSBE_SolarisGroupDetailResult>();
            
            
            if(solarisResults != null && solarisResults!= '')
            newResults    = (List<ETSBE_SolarisGroupDetailResult> )  json.deserialize(solarisResults, List<ETSBE_SolarisGroupDetailResult>.class) ;  
            if(internalResults != null && internalResults!= '')
            internalnewResults = (List<ETSBE_SolarisGroupDetailResult> )  json.deserialize(internalResults, List<ETSBE_SolarisGroupDetailResult>.class) ; 
            if(internalnewResults.size()>0){
                newResults.addall(internalnewResults);
            }
            system.debug('..........'+json.serialize(newResults));
            for(ETSBE_SolarisGroupDetailResult groupDetail  :newResults ){
                if(groupDetail.groupName == queryCaseData.Group_Name__c && groupDetail.groupId == queryCaseData.Subject_Group_ID__c
                  && groupDetail.policyNumber == queryCaseData.Policy__c && groupDetail.platform == queryCaseData.Platform__c
                  ){
                      
                    selectedGroupData = groupDetail;
                      system.debug('............'+selectedGroupData);
                }
            }
        }
      return json.serialize(selectedGroupData);  
    }
     @AuraEnabled
    Public static One_Click_Originator__c fetchOriginatorRecord(String caseId){
       // System.debug('caseId Originator===>'+caseId);
        if(caseId!=null){
            Case fetchCase=[select id,OriginatorEmail__c,OriginatorPhone__c	,
                            Originator_Type__c,Reward_Account_Number__c,group_name__c,Policy__c from Case where id=:caseId ];   
            System.debug('fetchCase Originator=='+fetchCase);
            
            if(fetchCase.OriginatorEmail__c == null){
                fetchCase.OriginatorEmail__c ='';
            }
            One_Click_Originator__c oneclickData=[select id,First_Name__c,Last_Name__c,Phone_Number__c,Email__c,Originator_Type__c,General_Agency__c,Agency_Broker_Name__c,
                                                  Franchise_Code__c,Group_Number__c,Group_Name__c,Policy_Number__c,Reward_Account_Number__c from One_Click_Originator__c
                                                  where Email__c=:fetchCase.OriginatorEmail__c AND Originator_Type__c=:fetchCase.Originator_Type__c
                                                  AND Reward_Account_Number__c=:fetchCase.Reward_Account_Number__c limit 1];
            System.debug('Serialized Originator' +JSON.serialize(oneclickData));
			oneclickData.Phone_Number__c = fetchCase.OriginatorPhone__c;
           // return JSON.serialize(oneclickData);
           return oneclickData;
        }else
            return null;      
    }
     @AuraEnabled
    Public static Case getCaseInfoMethod(String caseId){
        System.debug('caseId===>'+caseId);
        if(caseId!=null){
            Case fetchCase=[select id,Status,contactId,Subject_Type__c,Contact.Name,DOB__c,Contact.Id,Contact.FirstName,Contact.Lastname,Member_SSN__c,SourceCode__c,Situs__c,Sales_Office__c,Policy_Renewal_Year__c,
                            Policy__c,Platform__c,Line_of_Business__c,Subject_Group_ID__c,ID__c,Group_ID_Formula__c,Group_Name__c,Funding_Type__c,Health_Plan_Minor__c,Region__c,Health_Plan_Major__c,
                            Broker_ID__c,Interaction__r.Interaction_Type__c,Interaction__r.id,Interaction__r.Name,Interaction__r.Originator_Name__c,Originator_Type__c,OriginatorEmail__c,Reward_Account_Number__c,
                            Interaction__r.Current_Status__c,Special_Instructions_Description__c,Special_Instructions_Business_Unit__c,Issue_Category_Desc__c from Case where id=:caseId];
            System.debug('fetchCase==='+JSON.serialize(fetchCase));
            
            //return JSON.serialize(fetchCase);
            return fetchCase;
        }
        else 
            return null;
        
    }
    
      @AuraEnabled
    public static String searchBroker(String producerId){
        String resultstring;
        try{
            ETSBE_BrokerSearchWebservice findBroker = new ETSBE_BrokerSearchWebservice();
            ACETWSCalloutResult CalloutResult = findBroker.findProducer(producerId);
            if(CalloutResult.Success != null && CalloutResult.Success){
                List<ETSBE_ProducerResults> resultWrapper = (List<ETSBE_ProducerResults>)CalloutResult.Response;
                System.debug('RETURNED RESULTWRAPPER: ' + resultWrapper);
                if(resultWrapper != null){
                    resultstring = JSON.serialize(resultWrapper);
                }
            }
        }catch(exception e){
            resultstring='';
        }
        System.debug('PRODUCER RESULT PASSED: ' + resultstring);
        return resultstring;
    }
}