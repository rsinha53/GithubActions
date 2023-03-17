/****************************************************************************** 
Class Name     : SNI_FL_ProviderMessageProgramDropdown
Description    : implement query functionalities related to "Program" dropdown
Created By     : Sameera - US3075477
Created Date   : 1/7/2020
******************************************************************************/
public with sharing class SNI_FL_ProviderMessageProgramDropdown {

    private String searchString;
    private String providerGroupId;
    private String providerAffliationId;
    private String objectName;
    private String familyId;
    private static final String READABLE = 'READABLE';
    private List<String> lstAccountTeamMembers;
    private List<SNI_FL_ProviderMessageUtil.ProviderData> lstdropdownValues;

    public SNI_FL_ProviderMessageProgramDropdown(Map<Object,Object> inParameterObj){
       
        lstdropdownValues = new List<SNI_FL_ProviderMessageUtil.ProviderData>();
        this.lstAccountTeamMembers = new List<String>();
        this.providerGroupId = (String)inParameterObj.get('selectProviderGroupId');
        this.searchString = String.escapeSingleQuotes((String)inParameterObj.get('searchString'));
        this.objectName = (String)inParameterObj.get('objectName');
        this.familyId = (String)inParameterObj.get('familyId');
        this.providerAffliationId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider_Affiliation').getRecordTypeId();

    }

    /**
     * @Author:Sameera (User stories added at top)
     * @returns `List<SNI_FL_ProviderMessageUtil.ProviderData>`
     * @description: Retrieves programs related to mymessage UI 
     */    
    public List<SNI_FL_ProviderMessageUtil.ProviderData> getProviderAffliationsForMyMessage(){

        try{
            
            if(searchString.length()>2){

                for(AccountTeamMember actTeamMember:getAccountTeamRecords(providerGroupId,providerAffliationId)){
                
                    lstAccountTeamMembers.add(actTeamMember.AccountId);
                }

                String query = 'Find :searchString IN NAME FIELDS RETURNING '+objectName+'(Id,Program__r.Program__c,Population__c WHERE RecordTypeId=:providerAffliationId AND Id IN:lstAccountTeamMembers)';
                
                for(Account providerAffliation:(List<Account>)search.query(query)[0]) {
                    SNI_FL_ProviderMessageUtil.ProviderData providerObj = new SNI_FL_ProviderMessageUtil.ProviderData();
                    providerObj.label = providerAffliation.Program__r.Program__c+' - '+providerAffliation.Population__c;
                    providerObj.value= providerAffliation.Id;

                    lstdropdownValues.add(providerObj);
                }
                
                return lstdropdownValues;

            }else{
                
               
                for(AccountTeamMember actTeamMember:getAccountTeamRecords(providerGroupId,providerAffliationId)){
                    
                    SNI_FL_ProviderMessageUtil.ProviderData providerObj = new SNI_FL_ProviderMessageUtil.ProviderData();
                    providerObj.label = actTeamMember.Account.Program__r.Program__c+' - '+actTeamMember.Account.Population__c;
                    providerObj.value= actTeamMember.AccountId;
                    
                    lstdropdownValues.add(providerObj);

                }
                
                return lstdropdownValues;
            }

        }catch(Exception ex){
            System.debug(ex.getStackTraceString());
            System.debug(ex.getMessage());
            System.debug(ex.getLineNumber());
            return null;
        }

    }

    /**
     * @author sameera
     * @description get provider affliation records 
     * @return  `List<SNI_FL_ProviderMessageUtil.ProviderData>`
     */    
    public List<SNI_FL_ProviderMessageUtil.ProviderData> getProviderAffliationsForMemberLevel(){
       
        try{
          

            if(searchString.length()>2){

                for(AccountTeamMember actTeamMember:getProviderAffFromMemberAffliations(familyId,providerAffliationId,providerGroupId)){
                
                    lstAccountTeamMembers.add(actTeamMember.AccountId);
                }
                String query = 'Find :searchString IN NAME FIELDS RETURNING '+objectName+'(Id, Program__r.Program__c,Population__c WHERE RecordTypeId=:providerAffliationId AND Id IN:lstAccountTeamMembers)';
                for(Account providerAffliation:(List<Account>)search.query(query)[0]) {
                    SNI_FL_ProviderMessageUtil.ProviderData providerObj = new SNI_FL_ProviderMessageUtil.ProviderData();
                    providerObj.label = providerAffliation.Program__r.Program__c+' - '+providerAffliation.Population__c;
                    providerObj.value= providerAffliation.Id;

                    lstdropdownValues.add(providerObj);
                }
                
                return lstdropdownValues;

            }else{
                
            
            for(AccountTeamMember actTeamMember:getProviderAffFromMemberAffliations(familyId,providerAffliationId,providerGroupId)){
                    
                SNI_FL_ProviderMessageUtil.ProviderData providerObj = new SNI_FL_ProviderMessageUtil.ProviderData();
                providerObj.label = actTeamMember.Account.Program__r.Program__c+' - '+actTeamMember.Account.Population__c;
                providerObj.value= actTeamMember.AccountId;
                
                lstdropdownValues.add(providerObj);

                }
                
                return lstdropdownValues;
            }

        }catch(Exception ex){
            System.debug(ex.getStackTraceString());
            System.debug(ex.getMessage());
            System.debug(ex.getLineNumber());
            return null;
        }
    }


    /**
     * 
     * @param providerGroupId 
     * @param recordTypeID 
     * @returns `List<AccountTeamMember>`
     * @Author:Sameera (User stories added at top)
     * @Description: retrieves account team records for selected group id and record type
     */    
    private List<AccountTeamMember> getAccountTeamRecords(String providerGroupId,String recordTypeID){
       
        try{
           
            return [SELECT Id, Account.Population__c,Account.Program__r.Program__c,AccountId FROM AccountTeamMember WHERE Account.ParentId=:providerGroupId AND UserId=:UserInfo.getUserId() AND Account.RecordTypeId=:recordTypeId];
        
        }catch(Exception ex){
            System.debug(ex.getStackTraceString());
            System.debug(ex.getMessage());
            System.debug(ex.getLineNumber());
            return null;
        }

    }

    /**
     * @author sameera
     * @param familyId 
     * @param recordTypeID 
     * @param providerGroupId 
     * @description retrieve member affliation record
     * @return  `List<AccountTeamMember>`
     */    
    private List<AccountTeamMember> getProviderAffFromMemberAffliations(String familyId,String recordTypeID,String providerGroupId){
        try{
            Set<ID> providerAffliations = new Set<Id>();
            
            for(Member_Affiliation__c memberAffliation:[SELECT Provider_Affiliation__c FROM Member_Affiliation__c WHERE Provider_Affiliation__c != NULL AND Member__c =:familyId]){
                providerAffliations.add(memberAffliation.Provider_Affiliation__c);
            }
            return [SELECT Id, Account.Population__c,Account.Program__r.Program__c,AccountId FROM AccountTeamMember WHERE Account.ParentId=:providerGroupId AND UserId=:UserInfo.getUserId() AND Account.RecordTypeId=:recordTypeId AND AccountId IN:providerAffliations];

        }catch(Exception ex){
            System.debug(ex.getStackTraceString());
            System.debug(ex.getMessage());
            System.debug(ex.getLineNumber());
            return null;
        }
       
    }

}