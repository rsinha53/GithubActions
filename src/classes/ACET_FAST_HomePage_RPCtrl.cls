/*************************************************************************************************************
* @name      ACET_FAST_HomePage_RPCtrl
* @author      kvalakon <karthik@optum.com>
* @created      11 / 09 / 2020
* @description    Apex class for ACET_FAST_HomePage_RPCtrl.
*
* Changes (version)
* -----------------------------------------------------------------------------------------------------------
*            No.    Date         Author          Description
*          ------  ----------  -------------  ----------------------------------------------
* @version  1.0    2020-09-11    kvalakon        Initial
* @version 1.1 	2020-12-29	  Santhosh        E2E changes for self user
*
**************************************************************************************************************/
public with sharing class ACET_FAST_HomePage_RPCtrl {
    
    //  --This method will retive the records created by self user -- 
    @AuraEnabled
    public static ResolutionDataWrapper resolutionData(){
        
        ResolutionDataWrapper resDataWrap = new ResolutionDataWrapper();
        user usr = [SELECT Id, UserRoleId, ProfileId,profile.name, UserRole.Name FROM User Where Id =:UserInfo.getUserId()];

        list<PIR_Resolution_Partner__c> resolutionRecList = [select Id,CreatedById,CreatedDate,Provider_Matrix_Reactive__c,Provider_Matrix_Proactive__c,Provider_Matrix_Proactive__r.name,Provider_Matrix_Reactive__r.name,
                                                             Case__c,Case__r.CaseNumber,Days_Past_SLA__c,RecordType.Name 
                                                             from PIR_Resolution_Partner__c where  Resolution_Partner_Outcome__c!='Resolved' AND Case__r.ownerid =: userinfo.getuserId() ORDER BY Days_Past_SLA__c Desc];
        if(resolutionRecList.size() >0)
        {
            resDataWrap.resolutionList = resolutionRecList;            
        }
        resDataWrap.UserRoleName = usr.UserRole.Name;
        
        return resDataWrap;
    }
    
    @AuraEnabled
    public static List<PIR_Resolution_Partner__c> getProactiveRPRec(){
        
        List<case> caseLst = [select id,status, (SELECT Id FROM PIR_Resolution_Partners__r ORDER BY CreatedDate DESC LIMIT 1) from case where ownerId =: userinfo.getuserId() AND RecordType.Name= 'Proactive Action' AND status != 'Closed' ];
        List<id> rpRecids = new List<id>();
        
        for(case c :caseLst ){
           for(PIR_Resolution_Partner__c rpRec : c.PIR_Resolution_Partners__r){
            rpRecids.add(rpRec.id);
        } 
        }
      
        list<PIR_Resolution_Partner__c> resolutionRecList = [select Id,CreatedById,CreatedDate,Provider_Matrix_Proactive__c,Provider_Matrix_Proactive__r.Name,
                                                             Case__c,Case__r.CaseNumber,RecordType.Name 
                                                             from PIR_Resolution_Partner__c where id in: rpRecids ORDER BY CreatedDate Desc];
        return resolutionRecList;
    }

    @AuraEnabled
    public static User getUserDetails(){
	        user usr = [SELECT Id, UserRoleId, ProfileId,profile.name, UserRole.Name FROM User Where Id =:UserInfo.getUserId()];
        return usr;
	}
    
    public class ResolutionDataWrapper{
        @AuraEnabled
        public List<PIR_Resolution_Partner__c> resolutionList;
        @AuraEnabled
        public String UserRoleName;
    }
}