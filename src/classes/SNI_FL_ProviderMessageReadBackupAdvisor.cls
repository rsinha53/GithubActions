/****************************************************************************** 
Class Name     : SNI_FL_ProviderMessageReadBackupAdvisor
Description    : implement query functionalities related to backupadvisor for newprovidermessagepopup
Created By     : Vamsi - ACDC US3124318,US3124366,US24385
Created Date   : 12/16/2020
******************************************************************************/

public with sharing class SNI_FL_ProviderMessageReadBackupAdvisor implements SNI_FL_ProviderReadInterface {
    
    
    private String providerGroupId;
    private String searchString;
    private String searchQuery;
    private String filterField;
    private String providerAffliationId;
    private String recordTypeId;
    private String objectName;
    private String userId;
    private List<ID> providerUserPersonAccID = new List<ID>();

    
    static final String READABLE = 'READABLE';
    List<List<SObject>> lstsearchList;
    List<SNI_FL_ProviderMessageUtil.ProviderData> lstdropdownValues;
    Set<Id> lstAccountTeamMembers;
    
    public SNI_FL_ProviderMessageReadBackupAdvisor(Map<Object,Object> inParameterObj){
        lstdropdownValues = new List<SNI_FL_ProviderMessageUtil.ProviderData>();
        this.providerGroupId = (String)inParameterObj.get('selectProviderGroupId');
        this.searchString = String.escapeSingleQuotes((String)inParameterObj.get('searchString'));
        this.filterField = (String)inParameterObj.get('filterField');
        this.objectName = (String)inParameterObj.get('objectName');
        this.providerAffliationId = (String)inParameterObj.get('selectedProviderAffliation');
        this.userId = (String)inParameterObj.get('userId');
        this.lstAccountTeamMembers = new Set<Id>();
    }
     
    
    
    /**
    * 
    * @returns `List<SNI_FL_ProviderMessageUtil.ProviderData>`
    */    
    
    public List<SNI_FL_ProviderMessageUtil.ProviderData> getProviderAffliations(){
        try{
            
            recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider_Affiliation').getRecordTypeId();
            
            if(this.searchString.length()>2){
                Set<String> setAccIds = getTeamUsers();
                String query = 'Find :searchString IN NAME FIELDS RETURNING '+objectName+'(Id, Program__r.Program__c,Population__c WHERE RecordTypeId=:recordTypeId AND Id IN:setAccIds)';
                
                for(Account providerAffliation:(List<Account>)search.query(query)[0]) {
                    SNI_FL_ProviderMessageUtil.ProviderData providerObj = new SNI_FL_ProviderMessageUtil.ProviderData();
                    providerObj.label = providerAffliation.Program__r.Program__c+' - '+providerAffliation.Population__c;
                    providerObj.value= providerAffliation.Id;

                    lstdropdownValues.add(providerObj);
                }
                
                return lstdropdownValues;
                
            }else{
                
                for(AccountTeamMember act:getAccountRecords(getTeamUsers())){
                    SNI_FL_ProviderMessageUtil.ProviderData providerObj = new SNI_FL_ProviderMessageUtil.ProviderData();
                    providerObj.label = act.Account.Program__r.Program__c+' - '+act.Account.Population__c;
                    providerObj.value= act.AccountId;

                    lstdropdownValues.add(providerObj);
                }
                
                return lstdropdownValues;
            }
            
        }catch(Exception ex){
          
            return null;
        }
        
    }
    public List<SNI_FL_ProviderMessageUtil.ProviderData> getRelatedMembers(){
        try{
            
            
            
            if(this.searchString.length()>2){
                
                
                for(Member_Affiliation__c affliationRecord:getMemberAffliations(providerAffliationId)) {
                    if(affliationRecord.Member__r.Name.containsIgnoreCase(this.searchString)){
                        
                        SNI_FL_ProviderMessageUtil.ProviderData providerObj = new SNI_FL_ProviderMessageUtil.ProviderData();
                        providerObj.label = affliationRecord.Member__r.Name;
                        providerObj.value= affliationRecord.Id;
                        
                        Map<Id,String> lstProviderMemberId = getMemberIdOfProvider(providerObj.value);

                        if(lstProviderMemberId != NULL){
                            for(Id memberIdRecord:lstProviderMemberId.keySet()){                               
                                providerObj.memberId = lstProviderMemberId.get(memberIdRecord);
                                
                            }
                        }

                        lstdropdownValues.add(providerObj);
                    }
                }
                return lstdropdownValues;
                
            }else{
                
                for(Member_Affiliation__c affliationRecord:getMemberAffliations(providerAffliationId)){
                    
                     SNI_FL_ProviderMessageUtil.ProviderData providerObj = new SNI_FL_ProviderMessageUtil.ProviderData();
                     providerObj.label = affliationRecord.Member__r.Name;
                     providerObj.value= affliationRecord.Member__c;
                     
                     Map<Id,String> lstProviderMemberId = getMemberIdOfProvider(providerObj.value);

                     if(lstProviderMemberId != NULL){
                         for(Id memberIdRecord:lstProviderMemberId.keySet()){                             
                             providerObj.memberId = lstProviderMemberId.get(memberIdRecord);
                             
                         }
                     }
                    
                     lstdropdownValues.add(providerObj);

                }
                return lstdropdownValues;
            }

        }catch(Exception ex){
          
            return null;
        }
    }
    public List<SNI_FL_ProviderMessageUtil.ProviderData> getMessagingToUsers(){
        return getToMembersForAgentLevel();
    }
    
    
    private List<SNI_FL_ProviderMessageUtil.ProviderData> getToMembersForAgentLevel(){
        try{
        
            ID providerUserrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider_User').getRecordTypeId();
            ID providerTeamrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider_Team').getRecordTypeId();
            
            for(AccountContactRelation acr:[SELECT Id,Contact.AccountId FROM AccountContactRelation where AccountId=:providerAffliationId]){
                providerUserPersonAccID.add(acr.Contact.AccountId);
            }

            if(this.searchString.length()>2){

                List<List<sObject>> advisors = [Find :searchString IN NAME FIELDS RETURNING User(Id,Name WHERE id IN :getAdvisorUserIDs())];
                List<List<SObject>> providers = [Find :searchString IN NAME FIELDS RETURNING User(Id,AccountId,Account.Name WHERE Account.RecordTypeId=:providerUserrecordTypeId AND AccountId IN :providerUserPersonAccID)];

                lstdropdownValues.addAll(getSearchedAdvisors((List<User>)advisors[0]));
                lstdropdownValues.addAll(getSearchedProviderTeam(searchString,getProviderTeams(providerTeamrecordTypeId)));
                lstdropdownValues.addAll(getSearchedProviderUser((List<User>)providers[0]));
                

            }else{
                lstdropdownValues.addAll(getAdvisorUserList());
                lstdropdownValues.addAll(getProviderUsers(providerUserrecordTypeId));
                lstdropdownValues.addAll(getProviderTeams(providerTeamrecordTypeId));

            }
            
            return lstdropdownValues;

        }catch(Exception ex){
           
            return null;
        }
    }
    
    
     /**
     * 
     * @param lstProviderTeam 
     * @author vamsi
     * @description getProvider team wrapper object
     * @return  `List<SNI_FL_ProviderMessageUtil.ProviderData>`
     */  
    private List<SNI_FL_ProviderMessageUtil.ProviderData> getSearchedProviderTeam(String search,List<SNI_FL_ProviderMessageUtil.ProviderData> lstProviderTeam){
        try{
             List<SNI_FL_ProviderMessageUtil.ProviderData> lstAdvisor = new List<SNI_FL_ProviderMessageUtil.ProviderData>();

            for(SNI_FL_ProviderMessageUtil.ProviderData providerTeamWrapper:lstProviderTeam){
                
                if(providerTeamWrapper.label.containsIgnoreCase(search)){
                    lstAdvisor.add(providerTeamWrapper);
                }
                
            }
           
            return lstAdvisor;
        }catch(Exception ex){
           
            return null;
        }
        
    }

    /**
     * 
     * @param lstProviderTeam 
     * @author vamsi
     * @description getProvider team wrapper object
     * @return  `List<SNI_FL_ProviderMessageUtil.ProviderData>`
     */    
    private List<SNI_FL_ProviderMessageUtil.ProviderData> getSearchedProviderUser(List<User> lstProviderUser){
        try{
            List<SNI_FL_ProviderMessageUtil.ProviderData> lstAdvisor = new List<SNI_FL_ProviderMessageUtil.ProviderData>();

            for(User providerUser:lstProviderUser){
    
                SNI_FL_ProviderMessageUtil.ProviderData providerObj = new SNI_FL_ProviderMessageUtil.ProviderData();
                providerObj.label = providerUser.Account.Name;
                providerObj.value= providerUser.Id;
                providerObj.userType = 'PU';
    
                lstAdvisor.add(providerObj);
            }
            return lstAdvisor;
        }catch(Exception ex){
           
            return null;
        }
       
    }
    
  /**
     * @author Vamsi
     * @description get user record ids for advisors
     * @return  `Set<ID>`
     */    
    private Set<ID> getAdvisorUserIDs(){
        Set<Id> userIDs = new Set<Id>();

        try{
            for(AccountTeamMember accTeamMembers:[SELECT UserId,User.Name FROM AccountTeamMember WHERE AccountId=:providerAffliationId AND UserId !=:Userinfo.getUserId()]){
            
                userIDs.add(accTeamMembers.UserId);
            }
            return userIDs;
        }catch(Exception ex){
           
            return null;
        }
        
    }
    
    
    
    /**
     * @author  vamsi
     * @description getSearched advisor wrapped details
     * @param lstAdvisors 
     * @return  `List<SNI_FL_ProviderMessageUtil.ProviderData>`
     */    
    private List<SNI_FL_ProviderMessageUtil.ProviderData> getSearchedAdvisors(List<User> lstAdvisors){

        try{
            List<SNI_FL_ProviderMessageUtil.ProviderData> lstAdvisor = new List<SNI_FL_ProviderMessageUtil.ProviderData>();

            for(User advisor:lstAdvisors){
    
                SNI_FL_ProviderMessageUtil.ProviderData providerObj = new SNI_FL_ProviderMessageUtil.ProviderData();
                providerObj.label = advisor.Name;
                providerObj.value= advisor.Id;
                providerObj.userType = 'A';
    
                lstAdvisor.add(providerObj);
            }
            return lstAdvisor;
        }catch(Exception ex){
          
            return null;
        }
        
    }

    
    
    /**
     * @Author vamsi
     * @Description retrieves account team members from provider affliations id 
     * @return  `List<SNI_FL_ProviderMessageUtil.ProviderData>`
     */    
    private List<SNI_FL_ProviderMessageUtil.ProviderData> getAdvisorUserList(){
        
        try{
            List<SNI_FL_ProviderMessageUtil.ProviderData> lstAdvisors = new List<SNI_FL_ProviderMessageUtil.ProviderData>();
            for(AccountTeamMember teamMember:[SELECT UserId,User.Name FROM AccountTeamMember WHERE AccountId=:providerAffliationId AND UserId !=:Userinfo.getUserId()]){
            
                SNI_FL_ProviderMessageUtil.ProviderData providerObj = new SNI_FL_ProviderMessageUtil.ProviderData();
                providerObj.label = teamMember.User.Name;
                providerObj.value= teamMember.UserId;
                providerObj.userType = 'A';
    
                lstAdvisors.add(providerObj);
            }
            
            return lstAdvisors;
        }catch(Exception ex){
          
            return null;
        }
        
    }

    /**
     * @author vamssi
     * @description retrieves provider user list linked with provider group
     * @return  `List<SNI_FL_ProviderMessageUtil.ProviderData>`
     */    
    private List<SNI_FL_ProviderMessageUtil.ProviderData> getProviderUsers(ID providerUserrecordTypeId){

        try{
            List<SNI_FL_ProviderMessageUtil.ProviderData> lstProviderUsers = new List<SNI_FL_ProviderMessageUtil.ProviderData>();
            
            for(User providerUser:[SELECT Id,AccountId,Account.Name FROM User WHERE AccountId IN :providerUserPersonAccID AND Account.RecordTypeId=:providerUserrecordTypeId]){
            
                SNI_FL_ProviderMessageUtil.ProviderData providerObj = new SNI_FL_ProviderMessageUtil.ProviderData();
                providerObj.label = providerUser.Account.Name;
                providerObj.value= providerUser.Id;
                providerObj.userType = 'PU';
    
                lstProviderUsers.add(providerObj);
            }
            
            return lstProviderUsers;
        }catch(Exception ex){
            
            return null;
        }
        
    }

    /**
     * @author vamsi
     * @description retrieved provider team linked to provider groupd
     * @return  `List<SNI_FL_ProviderMessageUtil.ProviderData>`
     */    
    private List<SNI_FL_ProviderMessageUtil.ProviderData> getProviderTeams(ID providerTeamrecordTypeId){

        try{
             List<SNI_FL_ProviderMessageUtil.ProviderData> lstProviderTeamMembers = new List<SNI_FL_ProviderMessageUtil.ProviderData>();
  
        for(AccountContactRelation providerTeam:[SELECT Contact.AccountId, Contact.Account.Name FROM AccountContactRelation WHERE AccountId=:providerAffliationId AND Contact.Account.RecordTypeId=:providerTeamrecordTypeId AND Account.ParentId=:providerGroupId]){

            SNI_FL_ProviderMessageUtil.ProviderData providerObj = new SNI_FL_ProviderMessageUtil.ProviderData();
            providerObj.label = providerTeam.Contact.Account.Name;
            providerObj.value= providerTeam.Contact.AccountId;
            providerObj.userType = 'PT';

            lstProviderTeamMembers.add(providerObj);
        }
        
        return lstProviderTeamMembers;
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
    */ 
    
    private List<AccountTeamMember> getAccountTeamRecords(String providerGroupId,String recordTypeID,String userId){
        
        return [SELECT Id, Account.Name,AccountId,UserId FROM AccountTeamMember WHERE Account.ParentId=:providerGroupId 
                                                                                        AND (UserId=:userId  OR UserId=:UserInfo.getUserId() ) AND Account.RecordTypeId=:recordTypeId];
    }
    
    /**
    * 
    * @param setAccIds 
    * @returns `List<Account>`
    */    
    
    private List<AccountTeamMember> getAccountRecords(set<string> setAccIds){
            return [SELECT Id, Account.Population__c,Account.Program__r.Program__c,AccountId FROM AccountTeamMember WHERE Account.ParentId=:providerGroupId AND UserId=:UserInfo.getUserId() AND Account.RecordTypeId=:recordTypeId AND AccountId IN:setAccIds ];
    
    }
    
    /**
    * 
    * @param setAccIds 
    * @returns `set<string> `
    */ 
    
    private set<string>  getTeamUsers(){
        map<string,set<string>> mapAccUser = new map<string,set<string>>();
        set<string> setAccIds = new set<string>();
        for(AccountTeamMember actTeamMember:getAccountTeamRecords(providerGroupId,recordTypeId,userId)){
            if(!mapAccUser.containsKey(actTeamMember.AccountId)){
                mapAccUser.put(actTeamMember.AccountId,new set<string>());
            }
            mapAccUser.get(actTeamMember.AccountId).add(actTeamMember.userId);
        }
        for(string obj: mapAccUser.keyset()){
            if(!setAccIds.contains(obj)){
                set<string> newSetAccIds = mapAccUser.get(obj);
                if(newSetAccIds.contains(userId) && newSetAccIds.contains(UserInfo.getUserId())){
                    setAccIds.add(obj);
                }
            }
        }
        return setAccIds;
    }
    
    private List<Member_Affiliation__c> getMemberAffliations(String providerAffliationId){
        if(providerAffliationId != NULL){
            return [SELECT Provider_Affiliation__c,Member__c,Member__r.Name,Name,Id FROM Member_Affiliation__c WHERE Provider_Affiliation__c=:providerAffliationId AND Member__c != NULL limit 50];
        }else{
            return null;
        }
        
    }

    /**
     * 
     * @param personAccountId 
     * @author Pavithra
     * @returns `Map<Id,String>`
     * @description retrieve Member Ids from PersonId
     */    
    private  Map<Id,String> getMemberIdOfProvider(String personAccountId){
        
        try{
            Map<Id,String> memberIdAffliations = new Map<Id,String>();

            if(personAccountId != NULL){
                List<Member_Affiliation__c> maf = [SELECT Member__c, Member_Id__c FROM Member_Affiliation__c WHERE Member__c=:personAccountId AND Member_Id__c != NULL];
                system.debug('getMemberIdOfProvider maf =' + maf);
                if(maf != NULL){
                    for(Member_Affiliation__c affliation: maf){
                        memberIdAffliations.put(affliation.Member__c,affliation.Member_Id__c);
                    }
                    return memberIdAffliations;
                }
                return memberIdAffliations;
            }else{
                return null;
            }
        }catch(Exception ex){
            System.debug(ex.getStackTraceString());
            System.debug(ex.getMessage());
            System.debug(ex.getLineNumber());
            return null;
        }
        
        
    }
}