/****************************************************************************** 
Class Name     : SNI_FL_ProviderMessageToDropdown
Description    : implement query functionalities related to "To" dropdown
Created By     : Sameera - US3121134
Created Date   : 1/7/2020
******************************************************************************/
public with sharing class SNI_FL_ProviderMessageToDropdown {

    private static final String READABLE = 'READABLE';
    private List<SNI_FL_ProviderMessageUtil.ProviderData> lstdropdownValues;

    public SNI_FL_ProviderMessageToDropdown(){
        lstdropdownValues = new List<SNI_FL_ProviderMessageUtil.ProviderData>();
    }


    /**
     * 
     * @param searchString 
     * @param providerGroupId 
     * @return  `List<SNI_FL_ProviderMessageUtil.ProviderData>`
     */    
    public List<SNI_FL_ProviderMessageUtil.ProviderData> getToMembers(String searchString,String providerGroupId,String providerAffliationID){
        try{
        
            ID providerUserrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider_User').getRecordTypeId();
            ID providerTeamrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Provider_Team').getRecordTypeId();
            List<ID> providerUserPersonAccID = new List<ID>();

            for(AccountContactRelation acr:[SELECT Id,Contact.AccountId FROM AccountContactRelation where AccountId=:providerAffliationId]){
                providerUserPersonAccID.add(acr.Contact.AccountId);
            }

            if(searchString.length()>2){

                List<List<sObject>> advisors = [Find :searchString IN NAME FIELDS RETURNING User(Id,Name WHERE id IN :getAdvisorUserIDs(providerAffliationID))];
                List<List<SObject>> providers = [Find :searchString IN NAME FIELDS RETURNING User(Id,AccountId,Account.Name WHERE Account.RecordTypeId=:providerUserrecordTypeId AND AccountId IN:providerUserPersonAccID)];

                lstdropdownValues.addAll(getSearchedAdvisors((List<User>)advisors[0]));
                lstdropdownValues.addAll(getSearchedProviderTeam(searchString,getProviderTeams(providerAffliationID,providerTeamrecordTypeId,providerGroupId)));
                lstdropdownValues.addAll(getSearchedProviderUser((List<User>)providers[0]));
                

            }else{
                lstdropdownValues.addAll(getAdvisorUserList(providerAffliationID));
                lstdropdownValues.addAll(getProviderUsers(providerUserrecordTypeId,providerUserPersonAccID));
                lstdropdownValues.addAll(getProviderTeams(providerAffliationID,providerTeamrecordTypeId,providerGroupId));

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
     * @author  sameera
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
            System.debug(ex.getStackTraceString());
            System.debug(ex.getMessage());
            System.debug(ex.getLineNumber());
            return null;
        }
        
    }

    /**
     * 
     * @param lstProviderTeam 
     * @author sameera
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
     * @author sameera
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
     * @author sameera
     * @description get user record ids for advisors
     * @return  `Set<ID>`
     */    
    private Set<ID> getAdvisorUserIDs(String providerAffliationId){
        Set<Id> userIDs = new Set<Id>();

        try{
           
            for(AccountTeamMember accTeamMembers:[SELECT UserId,User.Name FROM AccountTeamMember WHERE AccountId=:providerAffliationId AND UserId !=:Userinfo.getUserId()]){
            
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
     * @Author Sameera ACDC
     * @Description retrieves account team members from provider affliations id 
     * @return  `List<SNI_FL_ProviderMessageUtil.ProviderData>`
     */    
    private List<SNI_FL_ProviderMessageUtil.ProviderData> getAdvisorUserList(String providerAffliationId){
       
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
            System.debug(ex.getStackTraceString());
            System.debug(ex.getMessage());
            System.debug(ex.getLineNumber());
            return null;
        }
        
    }

    /**
     * @author Sameera
     * @description retrieves provider user list linked with provider group
     * @return  `List<SNI_FL_ProviderMessageUtil.ProviderData>`
     */  
    private List<SNI_FL_ProviderMessageUtil.ProviderData> getProviderUsers(ID providerUserrecordTypeId,List<ID> providerUserPersonAccID){
        
    
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
                System.debug(ex.getStackTraceString());
                System.debug(ex.getMessage());
                System.debug(ex.getLineNumber());
                return null;
            }
        
        
    }

    /**
     * @author sameera
     * @description retrieved provider team linked to provider groupd
     * @return  `List<SNI_FL_ProviderMessageUtil.ProviderData>`
     */    
    private List<SNI_FL_ProviderMessageUtil.ProviderData> getProviderTeams(ID providerAffliations ,ID providerTeamrecordTypeId,String providerGroupId){

        try{
            List<SNI_FL_ProviderMessageUtil.ProviderData> lstProviderTeamMembers = new List<SNI_FL_ProviderMessageUtil.ProviderData>();
  
        for(AccountContactRelation providerTeam:[SELECT Contact.AccountId, Contact.Account.Name FROM AccountContactRelation WHERE AccountId=:providerAffliations AND Contact.Account.RecordTypeId=:providerTeamrecordTypeId AND Account.ParentId=:providerGroupId]){

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