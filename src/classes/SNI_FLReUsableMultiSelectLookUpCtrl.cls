/****************************
Description       : SNI_FLReUsableMultiSelectLookUpCtrl
Created By        : Vamsi
Created Date      : 26-08-2020

Modification Log: 
Developer                   Date                   Description
****************************/


public without sharing class SNI_FLReUsableMultiSelectLookUpCtrl {
    
    @AuraEnabled
    public static List < sObject > fetchLookUpValues(string backupAgentCheck,String searchKeyWord, String ObjectName, String selectedRecordId) {
        List<String> objlst = ObjectName.split(',');
        String searchKey = '%' + searchKeyWord + '%';
        List < sObject > returnList = new List < sObject> ();
        if(objlst!=Null && objlst.size()>0){
            string accOwnerId ;
            for(String obj : objlst){ 
              if(obj == 'Account'){
                    List<sObject> familyadvisor = new List<sObject>();
                    familyadvisor = getFamilyAgentDetails(selectedRecordId);
                    if(familyadvisor!=Null && familyadvisor.size()>0){
                        accOwnerId = familyadvisor[0].id;
                        String actualName = string.valueOf(familyadvisor[0].get('Name'));
                      
                         if(backupAgentCheck != familyadvisor[0].id && searchKeyWord==''){
                            returnList.addall(familyadvisor);
                             
                         }else if((backupAgentCheck != familyadvisor[0].id) && (searchKeyWord!='' && actualName.containsIgnoreCase(searchKeyWord))){
                             returnList.addall(familyadvisor);
                         }
                    }
                }
                else if(obj == 'SNI_FL_Care_Team_Member__c'){
                    User logedUser  = [SELECT AccountId FROM User WHERE Id =:userinfo.getUserId()];
                    List<SNI_FL_Care_Team_Member__c> ctMembersList = [SELECT Id, SNI_FL_Member__r.Name, SNI_FL_Member__c, SNI_FL_Family__c, Name FROM SNI_FL_Care_Team_Member__c WHERE SNI_FL_Family__c =: selectedRecordId AND SNI_FL_Status__c = 'Registered' AND SNI_FL_Member__c !=:logedUser.AccountId];
                    List < sObject > tempreturnList = new List < sObject > ();
                    List<String> sortingList = new List<String>();
                    Map<String, sObject> ctMemberMap = new Map<String, sObject>();
                    
                    for(SNI_FL_Care_Team_Member__c member : ctMembersList){
                        if(member.SNI_FL_Member__r.Name!=null){
                            String actualName = member.SNI_FL_Member__r.Name;
                            
                            if(searchKeyWord==''){
                                String name = actualName.toUpperCase();
                                String concatanateValu = name+member.id;
                                ctMemberMap.put(concatanateValu, member);
                                sortingList.add(concatanateValu);
                            }else{
                                if(actualName.containsIgnoreCase(searchKeyWord)){
                                    String name = actualName.toUpperCase();
                                    String concatanateValu = name+member.id;
                                    ctMemberMap.put(concatanateValu, member);
                                    sortingList.add(concatanateValu);                    
                                }
                            }
                        }
                    }
                    sortingList.sort();
                    for(String s : sortingList) {
                        tempreturnList.add(ctMemberMap.get(s));
                    }
                    if(!tempreturnList.isEmpty()){
                        returnList.addall(tempreturnList);
                    } 
                }else if(obj == 'Family_Partner__c'){
                    List<Family_Partner__c> famPartnerlst = [SELECT Id,Partner__c, Partner__r.Name,Partner__r.FirstName,Partner__r.LastName,Family__c,Partner__r.UserRole.Name FROM Family_Partner__c WHERE Family__c =: selectedRecordId AND Partner__r.isActive=true];
                    List < sObject > templst = new List < sObject > ();
                    List<String> sortlst = new List<String>();
                    Map<String, sObject> partnerMap = new Map<String, sObject>();
                    for(Family_Partner__c fampartner : famPartnerlst){
                        if( backupAgentCheck != fampartner.Partner__c && accOwnerId != fampartner.Partner__c){
                        if(fampartner.Partner__r.Name!=null){
                            String actualName = fampartner.Partner__r.Name;
                            if(searchKeyWord==''){
                                String name = actualName.toUpperCase();
                                String concatanateValu = name+fampartner.id;
                                partnerMap.put(concatanateValu, fampartner);
                                sortlst.add(concatanateValu);
                            }else{
                                if(actualName.containsIgnoreCase(searchKeyWord)){
                                    String name = actualName.toUpperCase();
                                    String concatanateValu = name+fampartner.id;
                                    partnerMap.put(concatanateValu, fampartner);
                                    sortlst.add(concatanateValu);                    
                                }
                            }
                        }
                    }
                    }
                    sortlst.sort();
                    for(String s : sortlst) {
                        templst.add(partnerMap.get(s));
                    }
                    if(!templst.isEmpty()){
                        returnList.addall(templst);
                    } 
               }
            }    
       }
        return returnList;
    }

    @AuraEnabled
    public static List <sObject> fetchUserRecord(String selectedTabId){
        List <sObject> returnList = new List < sObject> ();
        List<User> users = [SELECT Id, Name,FirstName,LastName,UserRole.Name FROM User WHERE Id =:selectedTabId];
        if(!users.isEmpty()){
            returnList.add(users[0]);
        }
        return returnList;
    }

    //Retreives Family Agent Name and ID by using Account ID
    //Author:Sameera ACDC
    @AuraEnabled
    public static List <sObject> getFamilyAgentDetails(String AccountID){

        try {

            List <sObject> returnList = new List < sObject> ();
            List<Account> account = [SELECT Id, OwnerId FROM Account WHERE id =:AccountID];
            if(account.size()>=1){
                List<User> users = [SELECT Id, Name, FirstName, LastName,UserRole.Name FROM User WHERE Id =:account[0].OwnerId AND isActive=true];
                if(users.size()>=1){
                    returnList.add(users[0]);
                    return users;
                }else{
                    return users;
                }
            }else{
                return null;
            }
 
        } catch (Exception ex) {
            
            System.debug('ACDC Exception '+ex.getMessage()+' ClassName:SNI_FLReUsableMultiSelectLookUpCtrl,MethodName:getFamilyAgentDetails, Line '+ex.getLineNumber());
            return null;
        }
        
        
    }
    @AuraEnabled
    public static Map<String,String> mapOfToolTipRoles() {
        List<SNI_FL_Utility__c> lstFUtil = [SELECT Name,SNI_FL_Design__c FROM SNI_FL_Utility__c WHERE Name like 'PartnerRole%'];
            Map<String,String> toolTipRoles = new Map<String,String>();
                for(SNI_FL_Utility__c fUtil:lstFUtil) {
                    if(fUtil.Name != null && fUtil.SNI_FL_Design__c != null) {
                        String partnerName = fUtil.Name.replace('PartnerRole','').trim();
                        toolTipRoles.put(partnerName,fUtil.SNI_FL_Design__c);
                    }
                System.debug(toolTipRoles);
        }
        return toolTipRoles;
    }
}