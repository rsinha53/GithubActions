trigger CHNQualifiedDataTrigger on CHN_Qualified_Data__c (before insert, before Update, after update) {
    if ((Trigger.isInsert || Trigger.isUpdate) && Trigger.isBefore) {
        /*List<CHN_Qualified_Data__c> lstCHNQual = new List<CHN_Qualified_Data__c>();
        if (Trigger.isUpdate) {
            for (CHN_Qualified_Data__c cqd : Trigger.new) {
                if (cqd.CHN_Referral_Identifier__c != Trigger.oldMap.get(cqd.Id).CHN_Referral_Identifier__c) {
                    lstCHNQual.add(cqd);
                }
            }
        } else {
            lstCHNQual = Trigger.new;
        }
        
        
        for (CHN_Qualified_Data__c qualData : lstCHNQual) {
            if (qualData.CHN_Referral_Identifier__c != null) {
                qualData.Policy_Number__c = qualData.CHN_Referral_Identifier__c.substringAfter('CHN:');      
            }
        }*/  
    }
    if (Trigger.isUpdate && Trigger.isAfter) {
        //Added on 19th september 2022
        CHNQualifiedDataTriggerHandler.populateComplexIndicatorOnAccount(trigger.oldmap,trigger.new);
    }
}