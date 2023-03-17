public class SAE_AlertsCtrl {
    @AuraEnabled(cacheable=true) 
    public static List<Alert__c> getAlertsData(){
       // MemberDetails md = (SAEProviderSearch.MemberDetails) System.JSON.deserialize(memberDetails, SAEProviderSearch.MemberDetails.class);
        List<Alert__c> alertLst = [SELECT Id, Alert_Comments__c, Alert_Title__c, Effective_Date__c,
                                   End_Date__c, Group_Number__c, ID_Number__c, SharePoint_ID__c, 
                                   Type__c, AlertExternalID__c FROM Alert__c 
                                   WHERE End_Date__c >= TODAY AND Effective_Date__c <= TODAY
                                   Order by Type__c asc, Effective_Date__c desc];
        return alertLst;
        
    }
    
    @AuraEnabled
    public static void createInteractionAlert(List<Alert__c> alerts, String interactionRec){
        Interaction__c interaction = [Select id, Name from Interaction__c limit 1];
        list<Interaction_Alert__c> intAlertList = new list<Interaction_Alert__c>();
        //checking null value
        if (interactionRec != null && interactionRec != '') {
            for(Alert__c alert :  alerts){
                Interaction_Alert__c ia = new Interaction_Alert__c();
                ia.Alert_Comments_at_Display__c = alert.Alert_Comments__c;
                ia.ID_Number__c = alert.ID_Number__c;
                ia.Alert__c = alert.id;
                ia.Interaction__c = interactionRec;
                //ia.Intercation_Alert_Unique_Id_del__c = alert.Group_Number__c ;
                intAlertList.add(ia);
            }
            upsert intAlertList;
        }
        
    }

    @AuraEnabled(cacheable = true)
    public static List<Alert__c> getAlertsIO (String groupNumber, String providerId){
        List<Alert__c> returnList = new List<Alert__c> ();
        try {
            String qfilter = '';
            List<String> queryParamList = new List<String>();
            if(!String.isBlank(groupNumber)){
                queryParamList.add(groupNumber);
            }
            if(!String.isBlank(providerId)){
                queryParamList.add(providerId);
            }

            queryParamList.add('Every Provider');
            qfilter = String.join(queryParamList, ' OR ');

            List<String> types = new List<String> { 'Provider', 'Provider Group' };
                List<List<SObject>> searchList = [FIND :qfilter
                                                  RETURNING Alert__c(Id, Alert_Comments__c, Alert_Title__c, Effective_Date__c,
                                                                     End_Date__c, Group_Number__c, ID_Number__c, SharePoint_ID__c,
                                                                     Type__c, AlertExternalID__c
                                                                     WHERE End_Date__c >= TODAY AND (Business_Segment__c='Spire' OR Business_Segment__c='PIR - RR/PA')
                                                                     AND Effective_Date__c <= TODAY AND Type__c IN :types
                                                                     ORDER BY Type__c ASC, Effective_Date__c DESC)];
            //returnList = searchList[0];
            for (Alert__c al : (List<Alert__c>)searchList[0]) {
                if ((!String.isBlank(groupNumber) && al.Group_Number__c == groupNumber) ||
                        (!String.isBlank(providerId) && al.ID_Number__c == providerId)|| al.ID_Number__c == 'Every Provider') {
                    returnList.add (al);
                }
            }
        } catch (Exception exp) {
            returnList = new List<Alert__c> ();
        }
        return returnList;
    }

    @AuraEnabled(cacheable = true)
    public static AlertReturn policyAlerts(String policyMemberId, String taxtId, String providerId, String policyGroupId){
        List<Alert__c> returnList = new List<Alert__c> ();
        AlertReturn returnItems = new AlertReturn();
        returnItems.alerts = returnList;
        returnItems.openDialog = false;

        try {
            // String qfilter = policyMemberId + ' OR ' + taxtId + ' OR ' + providerId + ' OR ' + policyGroupId;
            String qfilter = '';
            List<String> queryParamList = new List<String>();
            if(!String.isBlank(policyMemberId)){
                queryParamList.add(policyMemberId);
            }
            if(!String.isBlank(taxtId)){
                queryParamList.add(taxtId);
            }
            if(!String.isBlank(providerId)){
                queryParamList.add(providerId);
            }
            if(!String.isBlank(policyGroupId)){
                queryParamList.add(policyGroupId);
            }
            queryParamList.add('Every Provider');
            qfilter = String.join(queryParamList, ' OR ');

            List<List<SObject>> searchList = [FIND :qfilter
                                              RETURNING Alert__c(Id, Alert_Comments__c, Alert_Title__c, Effective_Date__c,
                                                                End_Date__c, Group_Number__c, ID_Number__c, SharePoint_ID__c,
                                                                Type__c, AlertExternalID__c
                                                                WHERE End_Date__c >= TODAY AND Business_Segment__c='Spire'
                                                                AND Effective_Date__c <= TODAY
                                                                ORDER BY Type__c ASC, Effective_Date__c DESC)];
            for (Alert__c al : (List<Alert__c>)searchList[0]) {
                if ((!String.isBlank(policyGroupId) && al.Group_Number__c == policyGroupId) ||
                    (!String.isBlank(policyMemberId) && al.ID_Number__c == policyMemberId) ||
                    (!String.isBlank(taxtId) && al.Group_Number__c == taxtId) ||
                    (!String.isBlank(providerId) && al.ID_Number__c == providerId)) {
                    returnList.add (al);
                    if(((!String.isBlank(policyGroupId) && al.Group_Number__c == policyGroupId) ||
                    (!String.isBlank(policyMemberId) && al.ID_Number__c == policyMemberId) ||al.ID_Number__c == 'Every Provider') &&
                    returnItems.openDialog != true){
                        returnItems.openDialog = true;
                    }
                }
            }
            returnItems.alerts = returnList;

        } catch (Exception exp) {
            returnList = new List<Alert__c> ();
            returnItems = new AlertReturn();
            returnItems.alerts = returnList;
            returnItems.openDialog = false;
        }
        return returnItems;
    }

    @AuraEnabled(cacheable = true)
    public static AlertReturn snapshotAlerts(String memberId, String taxtId, String providerId,
    String policyGroupId, String groupId,String houseHoldMemberId, String houseHoldGroupId){
        List<Alert__c> returnList = new List<Alert__c> ();
        AlertReturn returnItems = new AlertReturn();
        returnItems.alerts = returnList;
        returnItems.openDialog = false;
        try {
            // String qfilter = policyMemberId + ' OR ' + taxtId + ' OR ' + providerId + ' OR ' + policyGroupId;
            String qfilter = '';
            List<String> queryParamList = new List<String>();
            if(!String.isBlank(memberId)){
                queryParamList.add(memberId);
            }
            if(!String.isBlank(taxtId)){
                queryParamList.add(taxtId);
            }
            if(!String.isBlank(providerId)){
                queryParamList.add(providerId);
            }
            if(!String.isBlank(policyGroupId)){
                queryParamList.add(policyGroupId);
            }
            if(!String.isBlank(groupId)){
                queryParamList.add(groupId);
            }
            if(!String.isBlank(houseHoldMemberId)){
                queryParamList.add(houseHoldMemberId);
            }
            if(!String.isBlank(houseHoldGroupId)){
                queryParamList.add(houseHoldGroupId);
            }
            queryParamList.add('Every Provider');
            qfilter = String.join(queryParamList, ' OR ');

            List<List<SObject>> searchList = [FIND :qfilter
                                              RETURNING Alert__c(Id, Alert_Comments__c, Alert_Title__c, Effective_Date__c,
                                                                End_Date__c, Group_Number__c, ID_Number__c, SharePoint_ID__c,
                                                                Type__c, AlertExternalID__c
                                                                WHERE End_Date__c >= TODAY AND Business_Segment__c='Spire'
                                                                AND Effective_Date__c <= TODAY
                                                                ORDER BY Type__c ASC, Effective_Date__c DESC)];
            for (Alert__c al : (List<Alert__c>)searchList[0]) {
                if ((!String.isBlank(policyGroupId) && al.Group_Number__c == policyGroupId) ||
                    (!String.isBlank(memberId) && al.ID_Number__c == memberId) ||
                    (!String.isBlank(taxtId) && al.Group_Number__c == taxtId) ||
                    (!String.isBlank(providerId) && al.ID_Number__c == providerId) ||
                    (!String.isBlank(groupId) && al.Group_Number__c == groupId) ||
                    (!String.isBlank(houseHoldMemberId) && al.ID_Number__c == houseHoldMemberId) ||
                    (!String.isBlank(houseHoldGroupId) && al.Group_Number__c == houseHoldGroupId)
                    || al.ID_Number__c == 'Every Provider') {
                    returnList.add (al);
                    if(((!String.isBlank(groupId) && al.Group_Number__c == groupId) ||
                    (!String.isBlank(memberId) && al.ID_Number__c == memberId)) &&
                    returnItems.openDialog != true){
                        returnItems.openDialog = true;
                    }
                }
            }
            returnItems.alerts = returnList;
        } catch (Exception exp) {
            returnList = new List<Alert__c> ();
            returnItems = new AlertReturn();
            returnItems.alerts = returnList;
            returnItems.openDialog = false;
        }
        return returnItems;
    }

    public class AlertReturn
    {
        @AuraEnabled public List<Alert__c> alerts{get;set;}
        @AuraEnabled public Boolean openDialog{get;set;}
    }
     // US3480373: Service Request Detail Page Alignment - Krish - 5 May 2021
     @AuraEnabled
     public static AlertReturn serviceRequestDetailAlerts(String caseId, String memberId, String taxId, String providerId, String groupId){
        AlertReturn response;
         try{
             if(String.isNotBlank(caseId)){
                 List<Case> caseList = [SELECT Id, ID__c, Subject_Group_ID__c FROM Case WHERE Id =: caseId LIMIT 1];
                 System.debug('caseList Length: '+caseList.size());
                 if(caseList.size() > 0){
                    memberId = String.isNotBlank(memberId) ? memberId : caseList[0].ID__c;
                    groupId = String.isNotBlank(groupId) ? groupId : caseList[0].Subject_Group_ID__c;
                 }
             }
             response = SAE_AlertsCtrl.snapshotAlerts(memberId, taxId, providerId, '', groupId, '', '');
             return response;
         }catch(Exception ex){
             System.debug('@@ ACET_ServiceRequestDetailCtrl: getCaseDetails: '+ex.getStackTraceString());
             return response;
         }
     }    
}