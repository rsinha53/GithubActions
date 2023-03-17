/****************************************************************************** 
Class Name     : SNI_FL_ProviderMessageReadAgent
Description    : implement query functionalities related to advisor for newprovidermessagepopup
Created By     : Sameera - ACDC US3075477,US3078403,US3121134
Created Date   : 12/16/2020
******************************************************************************/
public with sharing class SNI_FL_ProviderMessageReadAgent implements SNI_FL_ProviderReadInterface{

    private String providerGroupId;
    private String providerAffliationId;
    private String searchString;
    private String searchQuery;
    private String recordTypeId;
    private String objectName;
    private String familyId;
    private List<String> lstAccountTeamMembers;
    private Map<Object,Object> inParameters;
    private static final String READABLE = 'READABLE';
    private List<SNI_FL_ProviderMessageUtil.ProviderData> lstdropdownValues;
    
    
    public SNI_FL_ProviderMessageReadAgent(Map<Object,Object> inParameterObj){
        this.lstAccountTeamMembers = new List<String>();
        this.inParameters = inParameterObj;
        lstdropdownValues = new List<SNI_FL_ProviderMessageUtil.ProviderData>();
        this.providerGroupId = (String)inParameterObj.get('selectProviderGroupId');
        this.searchString = String.escapeSingleQuotes((String)inParameterObj.get('searchString'));
        this.objectName = (String)inParameterObj.get('objectName');
        this.familyId = (String)inParameterObj.get('familyId');
        this.providerAffliationId = (String)inParameterObj.get('selectedProviderAffliation');
    }

   
    /**
     * 
     * @returns `List<SNI_FL_ProviderMessageUtil.ProviderData>`
     * @author sameera
     * @description query provider affliation dropdown records. if family Id is 
     * existing(person account level) if not my message level
     */    
    public List<SNI_FL_ProviderMessageUtil.ProviderData> getProviderAffliations(){
        
        if(familyId != NULL){
           
            
            SNI_FL_ProviderMessageProgramDropdown membrLevelObject = new SNI_FL_ProviderMessageProgramDropdown(inParameters);
            return membrLevelObject.getProviderAffliationsForMemberLevel();

        }else{
            
            
            SNI_FL_ProviderMessageProgramDropdown messageLevelObject = new SNI_FL_ProviderMessageProgramDropdown(inParameters);
            return messageLevelObject.getProviderAffliationsForMyMessage();
        }

    }

    /**
     * 
     * @returns `List<SNI_FL_ProviderMessageUtil.ProviderData>`
     * @author sameera
     * @description  query members who are linked to a selected provider 
     * affliation
     * 
     */    
    public List<SNI_FL_ProviderMessageUtil.ProviderData> getRelatedMembers(){ 
       
        SNI_FL_ProviderMessageRelatedToDropdown relatedToObj = new SNI_FL_ProviderMessageRelatedToDropdown();
        return relatedToObj.getRelatedMembersAgentLevel(providerAffliationId,searchString,objectName);
    }

    /**
     * @author sameera
     * @description retrieves provider team,provider users and advisors
     * @return  `List<SNI_FL_ProviderMessageUtil.ProviderData>`
     */    
    public List<SNI_FL_ProviderMessageUtil.ProviderData> getMessagingToUsers(){

        SNI_FL_ProviderMessageToDropdown toObj = new SNI_FL_ProviderMessageToDropdown();
        return toObj.getToMembers(searchString,providerGroupId,providerAffliationId);
 
    }

    public static String getMemberIdByAccountId(String accountID){
        String memberId;        
        try{
            List<Member_Affiliation__c> member =[select Member_Id__c   from Member_Affiliation__c where Member__c = :accountID AND Member_Id__c != null Limit 1];
            if(member!=null && member.size()>0){
                memberId = member[0].Member_Id__c;
            }
            system.debug('MEMBER ID = ' + memberId);
            return memberId;
        }catch(Exception ex){
            System.debug('ACDC Exception '+ex.getMessage()+'Line '+ex.getLineNumber());
            return null;
        }
        
    }

    public static String getMemberNameByAccountId(String accountID){
        String memberId;        
        try{
            List<Account> memberName =[select Name from Account where Id = :accountID ];
            if(memberName!=null && memberName.size()>0){
                memberId = memberName[0].Name;
            }
            system.debug('MEMBER ID = ' + memberId);
            return memberId;
        }catch(Exception ex){
            System.debug('ACDC Exception '+ex.getMessage()+'Line '+ex.getLineNumber());
            return null;
        }
        
    }
    

}