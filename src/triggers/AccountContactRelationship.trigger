trigger AccountContactRelationship on AccountContactRelation(before insert, after insert, before update, after update, before delete, after delete) {
    public Boolean byPassOn = Boolean.valueOf(Label.SNI_ByPassOn); 
    public Boolean migration_User = Label.SNI_DataMigration_Users.split(',').contains(UserInfo.getUserId().subString(0,15));
    public Boolean sniByPass = !(byPassOn && migration_User);
    if (Trigger.isBefore) {
        if (Trigger.isUpdate || Trigger.isInsert) {
            Set<Id> AccID = new Set<Id>(); 
            Set<Id> contactId = new Set<Id>();
             for(AccountContactRelation acr:Trigger.new){
                 contactId.add(acr.contactId);
             }
            map<Id,Contact> mapofAccountContact = new map<Id,Contact>();
            List<Contact> contList = [SELECT Id,
                                      AccountId, 
                                      Account.Complex_Indicator__c 
                                      FROM 
                                      Contact 
                                      WHERE Id=:contactId];
            for(Contact con:contList){
                mapofAccountContact.put(con.Id,con);  
            }
            if(mapofAccountContact.values().size()>0){
                for(AccountContactRelation acr:Trigger.new){
                    AccountContactRelation oldACR = trigger.OldMap==null?null:trigger.OldMap.get(acr.Id);
                    system.debug('check****' + mapofAccountContact.containskey(acr.ContactId) + mapofAccountContact.get(acr.ContactId).Account.Complex_Indicator__c!=null);
                    if((oldACR == null || (oldACR!=null && acr.Complex_Indicator__c != oldACR.Complex_Indicator__c)) 
                       && mapofAccountContact.containskey(acr.ContactId)){
                       AccountContactHandler.priorComplexIndicator(acr, mapofAccountContact.get(acr.ContactId).Account.Complex_Indicator__c);
                    }
                }
            }
        } 
        if (Trigger.isDelete) {
          
        }
    }
    
    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            AccountContactHandler.memAffShareInsertOperation(Trigger.NewMap);
          if(sniByPass){
          	AccountContactHandler.handleAfterInsert(Trigger.Old,Trigger.NewMap);
		AccountContactHandler.createCareteam(Trigger.New,Trigger.NewMap);
          }else {
          	AccountContactHandler.acrAfterInsert(Trigger.NewMap);
          }
        } 
        if (Trigger.isUpdate) {
          AccountContactHandler.handleAfterUpdate(Trigger.New,Trigger.NewMap,Trigger.OldMap);
          AccountContactHandler.updateCIinSENSPublish(Trigger.New,Trigger.OldMap); 
          List<AccountContactRelation> accounts = [SELECT Id, Complex_Indicator__c, Complex_Indicator_Text__c FROM AccountContactRelation WHERE Id IN :trigger.new];

        }
        if (Trigger.isDelete) {
          AccountContactHandler.handleAfterDelete(Trigger.Old,Trigger.OldMap);
        }
    }
}