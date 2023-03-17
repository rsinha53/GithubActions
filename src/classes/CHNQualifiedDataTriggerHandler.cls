/*------------------------------------------------------------
Description:   Handler for CHNQualifiedDataTrigger Trigger
               
Test Class:    CHNQualifiedDataTriggerHandlerTest
History
Date            Author              Comments
-------------------------------------------------------------
09-19-2022      Manmeet Kaur        Created
------------------------------------------------------------*/
public class CHNQualifiedDataTriggerHandler {
	/*
     * Desc: To update the Complex Indicator field value 
     * 		 from eVisor on the Account
     */
    public static void populateComplexIndicatorOnAccount(Map<Id, CHN_Qualified_Data__c> chnQualifiedOldMap, List<CHN_Qualified_Data__c> chnQualifiedLst){
        try{
            Set<String> eidSet = new set<String>();
            Map<String,Id> updateSensPublishMap = new Map<String,Id>();
            Map<String,String> enterpriseIdMap = new Map<String,String>();
            for(CHN_Qualified_Data__c chnQual: chnQualifiedLst){
                CHN_Qualified_Data__c oldChnQual = chnQualifiedOldMap.get(chnQual.id);
                if(chnQual.complex_indicator__c != oldChnQual.complex_indicator__c && chnQual.EID__c!=''){
                    eidSet.add(chnQual.EID__c);
                    enterpriseIdMap.put(chnQual.EID__c, chnQual.complex_indicator__c);
                }
            }
            Map<Id,Account> updateAccountMap = new Map<Id,Account>();
            if(enterpriseIdMap.values().size()>0){
                for(Account acc: [SELECT Id,Complex_Indicator__c,EID__c FROM Account WHERE EID__c IN: eidSet]){
                    if(enterpriseIdMap.containsKey(acc.EID__c)){
                        acc.Complex_Indicator__c = enterpriseIdMap.get(acc.EID__c);
                        updateAccountMap.put(acc.Id, acc);
                        updateSensPublishMap.put(acc.EID__c,acc.Id);
                    }
                }
            }        
            if(updateAccountMap.values().size()>0){
                update updateAccountMap.values();
            }
            if(updateSensPublishMap.values().size()>0){
                //make a future callout to update sens publish records
                updateSensPublishWithCompIndicator(updateSensPublishMap);
            }
        }catch(exception ex){
            system.debug('exception occured while updating complex indicator field on Account from CHN_Qualified_Data__c trigger' + ex.getMessage());
        }
    }
	/*
     * Desc: To update the Complex Indicator field value 
     * 		 on the Sens Publish
     */
    @future
    public static void updateSensPublishWithCompIndicator(Map<String,String> eidAccountIdMap){
        try{
            Map<Id,Id> accountAndSensPublishIdMap = new Map<Id,Id>();
            Map<Id,Sens_Publish__c> updateSensPublishMap = new Map<Id,Sens_Publish__c>();
            for(Sens_Publish__c sensPub : [SELECT Id,Account__c FROM Sens_Publish__c WHERE Account__r.EID__c IN: eidAccountIdMap.keySet()]){
                accountAndSensPublishIdMap.put(sensPub.Account__c, sensPub.Id);
            }
            if(accountAndSensPublishIdMap.values().size()>0){
                for(AccountContactRelation acr: [SELECT Id,Complex_Indicator_Text__c,
                                                 contact.accountId FROM AccountContactRelation WHERE contact.accountId IN: eidAccountIdMap.values()]){
                    if(accountAndSensPublishIdMap.containsKey(acr.contact.accountId)){
                        Id senspublishId = accountAndSensPublishIdMap.get(acr.contact.accountId);
                        updateSensPublishMap.put(senspublishId,new Sens_Publish__c(Id = senspublishId, 
                                                                                   Complex_Indicator__c = acr.Complex_Indicator_Text__c));
                    }
                }
            }       
            if(updateSensPublishMap.values().size()>0){
                update updateSensPublishMap.values();  
            }
        }catch(exception ex){
            system.debug('exception occured while updating complex indicator field on Sens Publish from CHN_Qualified_Data__c trigger' + ex.getMessage());
        }
    }
}