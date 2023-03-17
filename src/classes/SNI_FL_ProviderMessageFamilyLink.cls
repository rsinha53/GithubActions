/****************************************************************************** 
Class Name     : SNI_FL_ProviderMessageFamilyLink
Description    : implement query functionalities related to Provider Messaging Family Link
Created By     : Pavithra - US3124954
Created Date   : 05/01/2020
******************************************************************************/

public without sharing class SNI_FL_ProviderMessageFamilyLink {
    private String providerAffliationId;
    private String searchString;
    private String objectName;
    private static final String READABLE = 'READABLE';
    private List<SNI_FL_ProviderMessageUtil.ProviderData> lstdropdownValues;
    
    public SNI_FL_ProviderMessageFamilyLink(Map<Object,Object> inParameterObj){
        lstdropdownValues = new List<SNI_FL_ProviderMessageUtil.ProviderData>();
        this.searchString = String.escapeSingleQuotes((String)inParameterObj.get('searchString'));
        this.objectName = (String)inParameterObj.get('objectName');
        this.providerAffliationId = (String)inParameterObj.get('selectedProviderAffliation');
    }
        
    public List<SNI_FL_ProviderMessageUtil.ProviderData> getRelatedMembers(){        
        return getRelatedMembersFamilyLink();            
    }

    public List<SNI_FL_ProviderMessageUtil.ProviderData> getMessagingToUsers(){        
        return getToListMembersFamilyLink();            
    }
    
    //////////////////////////////////////Related To Dropdown////////////////////////////////////
    
    /**
     * @author Pavithra
     * @returns `List<SNI_FL_ProviderMessageUtil.ProviderData>`
     * @description query related members based on search results and display
     * possible values
     */    
    private List<SNI_FL_ProviderMessageUtil.ProviderData> getRelatedMembersFamilyLink(){
        
        try{

            Map<Id,String> lstMemberAffliation = getMemberAffliations(providerAffliationId); 
            system.debug('lstMemberAffliation : ' + lstMemberAffliation);
            if(this.searchString.length()>2 && lstMemberAffliation !=NULL){
                Set<Id> personActIds = lstMemberAffliation.keySet();
                String query = 'Find :searchString IN NAME FIELDS RETURNING '+objectName+'(Id, Name WHERE Id IN:personActIds)';
                for(Account providerAffliation:(List<Account>)search.query(query)[0]) {
                    
                    SNI_FL_ProviderMessageUtil.ProviderData providerObj = new SNI_FL_ProviderMessageUtil.ProviderData();
                    providerObj.label = providerAffliation.Name;
                    providerObj.value= providerAffliation.Id;
                    
                    lstdropdownValues.add(providerObj);
                }
                
                return lstdropdownValues;
                
            }else if(lstMemberAffliation != NULL){
                
                for(Id affliationRecord:lstMemberAffliation.keySet()){
                    
                    SNI_FL_ProviderMessageUtil.ProviderData providerObj = new SNI_FL_ProviderMessageUtil.ProviderData();
                    providerObj.label = lstMemberAffliation.get(affliationRecord);
                    providerObj.value= affliationRecord;
                    
                    lstdropdownValues.add(providerObj);
                    
                }
                
                return lstdropdownValues;
            }
            return lstdropdownValues;
        }catch(Exception ex){
            System.debug(ex.getStackTraceString());
            System.debug(ex.getMessage());
            System.debug(ex.getLineNumber());
            return null;
        }
    }
    
    /**
     * 
     * @param providerAffliationId 
     * @author Pavithra
     * @returns `Map<Id,String>`
     * @description retrieve unique member ids and member names
     */    
    private  Map<Id,String> getMemberAffliations(String providerAffliationId){
        Map<Id,String> memberAffliations = new Map<Id,String>();
        List<Member_Affiliation__c> aff = new List<Member_Affiliation__c>();
        String accountId = [SELECT contact.AccountId FROM User WHERE id =: Userinfo.getUserid()].contact.AccountId;
        try{
            if(providerAffliationId != NULL){
                aff = [SELECT Member__c, Member__r.Name  FROM Member_Affiliation__c WHERE Provider_Affiliation__c =:providerAffliationId AND Member__c != ''];

                if(aff != NULL){
                    for(Member_Affiliation__c affliation:aff){
                        memberAffliations.put(affliation.Member__c,affliation.Member__r.Name);
                    }
                    return memberAffliations;
                }
                return memberAffliations;
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

    //////////////////////////////////////To Dropdown////////////////////////////////////

    /**
     * @author Nanthu
     * @returns `List<SNI_FL_ProviderMessageUtil.ProviderData>`
     * @description query To List members based on search results and display possible values
     */    
    private List<SNI_FL_ProviderMessageUtil.ProviderData> getToListMembersFamilyLink(){
        try{
            String providerGroup = [SELECT ParentId FROM Account WHERE id = :providerAffliationId].ParentId;

            ID providerUserrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider_User').getRecordTypeId();
            ID providerTeamrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider_Team').getRecordTypeId();
            List<ID> providerUserPersonAccID = new List<ID>();

            for(AccountContactRelation acr:[SELECT Id,Contact.AccountId FROM AccountContactRelation where AccountId=:providerAffliationId]){
                providerUserPersonAccID.add(acr.Contact.AccountId);
            }

            if(searchString.length()>2){

                List<List<sObject>> advisors = [Find :searchString IN NAME FIELDS RETURNING User(Id,Name,FirstName,LastName WHERE id IN :getAdvisorUserIDs(providerAffliationId))];
                List<List<SObject>> providers = [Find :searchString IN NAME FIELDS RETURNING User(Id,AccountId,Account.Name WHERE Account.RecordTypeId=:providerUserrecordTypeId AND AccountId IN:providerUserPersonAccID)];

                lstdropdownValues.addAll(getSearchedAdvisors((List<User>)advisors[0]));
                lstdropdownValues.addAll(getSearchedProviderTeam(searchString,getProviderTeams(providerAffliationID,providerTeamrecordTypeId,providerGroup)));
                lstdropdownValues.addAll(getSearchedProviderUser((List<User>)providers[0]));

            }else{
                lstdropdownValues.addAll(getAdvisorUserList(providerAffliationId));
                lstdropdownValues.addAll(getProviderUsers(providerUserrecordTypeId,providerUserPersonAccID));
                lstdropdownValues.addAll(getProviderTeams(providerAffliationId,providerTeamrecordTypeId,providerGroup));
            }
            
            return lstdropdownValues;

        }catch(Exception ex){
            System.debug(ex.getStackTraceString());
            System.debug(ex.getMessage());
            System.debug(ex.getLineNumber());
            return null;
        }
    }

    /**
     * @author Nanthu
     * @description get user record ids for advisors
     * @param lstProviderAffliation 
     * @return  `Set<ID>`
     */    
    private Set<ID> getAdvisorUserIDs(String providerAffliationId){
        Set<Id> userIDs = new Set<Id>();

        try{
            for(AccountTeamMember accTeamMembers:[SELECT UserId,User.Name FROM AccountTeamMember WHERE AccountId = :providerAffliationId]){
                userIDs.add(accTeamMembers.UserId);
            }
            return userIDs;
        }catch(Exception ex){
            System.debug(ex.getStackTraceString());
            System.debug(ex.getMessage());
            System.debug(ex.getLineNumber());
            return null;
        }
    }

    /**
     * @author  Nanthu
     * @description getSearched advisor wrapped details
     * @param lstAdvisors 
     * @return  `List<SNI_FL_ProviderMessageUtil.ProviderData>`
     */    
    private List<SNI_FL_ProviderMessageUtil.ProviderData> getSearchedAdvisors(List<User> lstAdvisors){

        try{
            List<SNI_FL_ProviderMessageUtil.ProviderData> lstAdvisor = new List<SNI_FL_ProviderMessageUtil.ProviderData>();

            for(User advisor:lstAdvisors){
    
                SNI_FL_ProviderMessageUtil.ProviderData providerObj = new SNI_FL_ProviderMessageUtil.ProviderData();
                String lName = advisor.LastName;
                if(advisor.FirstName != null){
                  providerObj.label = advisor.FirstName + ' '+lName.substring(0,1);  
                }else{
                   providerObj.label = advisor.Name; 
                }
                providerObj.value= advisor.Id;
                providerObj.userType = 'A';
    
                lstAdvisor.add(providerObj);
            }
            return lstAdvisor;
        }catch(Exception ex){
            System.debug(ex.getStackTraceString());
            System.debug(ex.getMessage());
            System.debug(ex.getLineNumber());
            return null;
        }
    }

    /**
     * 
     * @param lstProviderTeam 
     * @author Nanthu
     * @description getProvider team wrapper object
     * @return  `List<SNI_FL_ProviderMessageUtil.ProviderData>`
     */    
    private List<SNI_FL_ProviderMessageUtil.ProviderData> getSearchedProviderTeam(String search,List<SNI_FL_ProviderMessageUtil.ProviderData> providerTeams){
        
        try{

            List<SNI_FL_ProviderMessageUtil.ProviderData> lstAdvisor = new List<SNI_FL_ProviderMessageUtil.ProviderData>();

            for(SNI_FL_ProviderMessageUtil.ProviderData providerTeamWrapper:providerTeams){
                
                if(providerTeamWrapper.label.containsIgnoreCase(search)){
                    lstAdvisor.add(providerTeamWrapper);
                }
                
            }
            return lstAdvisor;
        }catch(Exception ex){
            System.debug(ex.getStackTraceString());
            System.debug(ex.getMessage());
            System.debug(ex.getLineNumber());
            return null;
        }
   
    }   

    /**
     * 
     * @param lstProviderTeam 
     * @author Nanthu
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
            System.debug(ex.getStackTraceString());
            System.debug(ex.getMessage());
            System.debug(ex.getLineNumber());
            return null;
        }
    }

    /**
     * @Author Nanthu
     * @Description retrieves account team members from provider affliations id 
     * @param providerAffiliations
     * @return  `List<SNI_FL_ProviderMessageUtil.ProviderData>`
     */    
    private List<SNI_FL_ProviderMessageUtil.ProviderData> getAdvisorUserList(String providerAffliationId){
        
        try{
            List<SNI_FL_ProviderMessageUtil.ProviderData> lstAdvisors = new List<SNI_FL_ProviderMessageUtil.ProviderData>();
            for(AccountTeamMember teamMember:[SELECT UserId,User.Name,User.FirstName,User.LastName FROM AccountTeamMember WHERE AccountId = :providerAffliationId]){
    
                SNI_FL_ProviderMessageUtil.ProviderData providerObj = new SNI_FL_ProviderMessageUtil.ProviderData();
                String lName = teamMember.User.LastName;
                if(teamMember.User.FirstName != null){
                 providerObj.label = teamMember.User.FirstName + ' '+lName.substring(0,1);   
                }else{
                   providerObj.label = teamMember.User.Name; 
                }
                providerObj.value= teamMember.UserId;
                providerObj.userType = 'A';
    
                lstAdvisors.add(providerObj);
            }
            
            return lstAdvisors;
        }catch(Exception ex){
            System.debug(ex.getStackTraceString());
            System.debug(ex.getMessage());
            System.debug(ex.getLineNumber());
            return null;
        }
    }

    /**
     * @author Nanthu
     * @description retrieves provider user list linked with provider group
     * @param providerUserrecordTypeId, providerGroup
     * @return  `List<SNI_FL_ProviderMessageUtil.ProviderData>`
     */    
    private List<SNI_FL_ProviderMessageUtil.ProviderData> getProviderUsers(ID providerUserrecordTypeId,List<ID> providerUserPersonAccID){
        try{
            List<SNI_FL_ProviderMessageUtil.ProviderData> lstProviderUsers = new List<SNI_FL_ProviderMessageUtil.ProviderData>();
        
            for(User providerUser:(List<User>)SNI_FL_ProviderMessageUtil.enforceApexSecurity([SELECT Id,AccountId,Account.Name,Account.LastName,Account.FirstName FROM User WHERE AccountId IN :providerUserPersonAccID AND Account.RecordTypeId=:providerUserrecordTypeId AND Id != :UserInfo.getUserId()],READABLE)){
    
                SNI_FL_ProviderMessageUtil.ProviderData providerObj = new SNI_FL_ProviderMessageUtil.ProviderData();
                providerObj.label = providerUser.Account.Name;
                providerObj.value= providerUser.Id;
                providerObj.userType = 'PU';
    
                lstProviderUsers.add(providerObj);
            }
            
            return lstProviderUsers;
        }catch(Exception ex){
            System.debug(ex.getStackTraceString());
            System.debug(ex.getMessage());
            System.debug(ex.getLineNumber());
            return null;
        }
    }

    /**
     * @author Nanthu
     * @description retrieved provider team linked to provider groupd
     * @param providerTeamrecordTypeId, providerGroup
     * @return  `List<SNI_FL_ProviderMessageUtil.ProviderData>`
     */    
    private List<SNI_FL_ProviderMessageUtil.ProviderData> getProviderTeams(ID providerAffliations,ID providerTeamrecordTypeId,String providerGroup){

        try{
            List<SNI_FL_ProviderMessageUtil.ProviderData> lstProviderTeamMembers = new List<SNI_FL_ProviderMessageUtil.ProviderData>();
  
            for(AccountContactRelation providerTeam:[SELECT Contact.AccountId, Contact.Account.Name FROM AccountContactRelation WHERE AccountId=:providerAffliations AND Contact.Account.RecordTypeId=:providerTeamrecordTypeId AND Account.ParentId=:providerGroup]){

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
    
}