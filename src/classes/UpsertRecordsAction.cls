/*------------------------------------------------------------
Author:        Manmeet Kaur
Description:   Class used in flow to upsert 
			   CHN_Qualified_Data__c  recieved from eVISOR
			   via PlatformEvent
               
Test Class:    UpsertRecordsActionTest
History
Date            Author              Comments
-------------------------------------------------------------
09-08-2022      Manmeet Kaur        Created
------------------------------------------------------------*/

public without sharing class UpsertRecordsAction {

    @InvocableMethod(
            label='Upsert Records'
            description='Updates existing records (or inserts them if they do not exist).')
    public static void upsertRecords(List<CHN_Qualified_Data__c > request) {
        List<CHN_Qualified_Data__c > records = request;
        String externalIdFieldName = 'CHN_Referral_Identifier__c';
        if(request.size()>0){
            Schema.SObjectType sObjectType = records[0].getSObjectType();
            SObjectField externalIDField = getUpsertKeyField(sObjectType, externalIdFieldName);
            Database.upsert(records, externalIDField);
        }
    }

    private static SObjectField getUpsertKeyField(Schema.SObjectType objectType, string fieldName) {
        if (String.isBlank(fieldName)) {
            return null;
        }
        Map<String,Schema.SObjectField> objectFields = objectType.getDescribe().fields.getMap();
        return objectFields.get(fieldName);
    }
}