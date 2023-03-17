public without sharing class SNI_FL_AddFamilyMemController {
    @AuraEnabled
    public static void getCareTeamMembers(string firstName,string lastName,date dateOfBirth,string famId,string memId){
        system.debug('getCareTeamMembers------');
        system.debug('getCareTeamMembers---memId-----'+memId);
        try{
		    list<account> lstAcc;
            if(famId != null ){
                lstAcc = [select id,ownerid from account where id =: famId ];
            }
            if(memId == null || memId == ''){
                Id personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
                Account personAccount = new Account();
                personAccount.PersonBirthdate = date.valueOf(dateOfBirth);
                personAccount.firstName = firstName;
                personAccount.lastName = lastName;
                personAccount.RecordTypeId = personAccRecordTypeId;
				if(lstAcc != null && lstAcc.size()>0){
                   personAccount.OwnerId = lstAcc[0].ownerid;
                }
                insert personAccount;
                system.debug('getCareTeamMembers----personAccount--'+personAccount.id);
                if(personAccount.id != null){
                    SNI_FL_Care_Team_Member__c careTeam = new SNI_FL_Care_Team_Member__c();
                    careTeam.SNI_FL_Family__c = famId;
                    careTeam.SNI_FL_Member__c=personAccount.id;
                    careTeam.SNI_FL_Status__c='Added';
                    careTeam.SNI_FL_Added_Date__c=System.today();
                    //careTeam.SNI_FL_Invited_Date__c=System.today()-1;
                    //careTeam.SNI_FL_Registered_Date__c=System.today();
                    careTeam.SNI_FL_Primary_Caregiver__c=false;
                    careTeam.SNI_FL_Non_Policy_Member__c=true;
                    careTeam.SNI_FL_Not_Visible_in_Familylink__c = false;
                    insert careTeam;
                    system.debug('getCareTeamMembers----careTeam--'+careTeam.id);
                }
            }
            else{
                Account personAccount = new Account();
                personAccount.id = memId;
                personAccount.PersonBirthdate = date.valueOf(dateOfBirth);
                personAccount.firstName = firstName;
                personAccount.lastName = lastName;
				if(lstAcc != null && lstAcc.size()>0){
                   personAccount.OwnerId = lstAcc[0].ownerid;
                }
                update personAccount;
            }
        }
        Catch(Exception e){
        }
    }
}