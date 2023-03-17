/****************************************************************************** 
Class Name     : SNI_FL_ProviderMessageRelatedToDropdown
Description    : implement query functionalities related to "RelatedTo" dropdown
Created By     : Sameera - US3078403
Created Date   : 1/7/2020
******************************************************************************/
public with sharing class SNI_FL_ProviderMessageRelatedToDropdown {

    private static final String READABLE = 'READABLE';
    private List<SNI_FL_ProviderMessageUtil.ProviderData> lstdropdownValues;

    public SNI_FL_ProviderMessageRelatedToDropdown(){
        lstdropdownValues = new List<SNI_FL_ProviderMessageUtil.ProviderData>();
    }

    /**
     * @author Sameera
     * @returns `List<SNI_FL_ProviderMessageUtil.ProviderData>`
     * @description query related members based on search results and display
     * possible values
     */    
    public List<SNI_FL_ProviderMessageUtil.ProviderData> getRelatedMembersAgentLevel(String providerAffliationId,String searchString,String objectName){  
        try{
            
            Map<Id,String> lstMemberAffliation = getMemberAffliations(providerAffliationId); 

            if(searchString.length()>2 && lstMemberAffliation !=NULL){

                Set<Id> personActIds = lstMemberAffliation.keySet();
                String query = 'Find :searchString IN NAME FIELDS RETURNING '+objectName+'(Id, Name WHERE Id IN:personActIds)';

                for(Account providerAffliation:(List<Account>)search.query(query)[0]) {

                    SNI_FL_ProviderMessageUtil.ProviderData providerObj = new SNI_FL_ProviderMessageUtil.ProviderData();
                    providerObj.label = providerAffliation.Name;
                    providerObj.value= providerAffliation.Id;
                    
                    Map<Id,String> lstProviderMemberId = getMemberIdOfProvider(providerAffliation.Id);

                        if(lstProviderMemberId != NULL){
                            for(Id memberIdRecord:lstProviderMemberId.keySet()){                                
                                providerObj.memberId = lstProviderMemberId.get(memberIdRecord);
                                
                            }
                        }

                    lstdropdownValues.add(providerObj);
                }

                return lstdropdownValues;

            }else if(lstMemberAffliation != NULL){

                    for(Id affliationRecord:lstMemberAffliation.keySet()){
                    
                        SNI_FL_ProviderMessageUtil.ProviderData providerObj = new SNI_FL_ProviderMessageUtil.ProviderData();
                        providerObj.label = lstMemberAffliation.get(affliationRecord);
                        providerObj.value= affliationRecord;
                                              
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
    /**
     * 
     * @param providerAffliationId 
     * @author Sameera
     * @returns `Map<Id,String>`
     * @description retrieve unique member ids and member names
     */    
    private  Map<Id,String> getMemberAffliations(String providerAffliationId){
        
        try{
            Map<Id,String> memberAffliations = new Map<Id,String>();

            if(providerAffliationId != NULL){
                List<Account> act = [SELECT (SELECT Member__c,Member__r.Name FROM Provider_Affiliation__r WHERE Member__c != NULL) FROM Account WHERE id=:providerAffliationId];
                
                if(act[0].Provider_Affiliation__r != NULL){
                    for(Member_Affiliation__c affliation:act[0].Provider_Affiliation__r){
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

    
}