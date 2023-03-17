public class ACETFamilyOverviewTriggerHelper {
    
    public static void beforeUpdate(Map<Id,Family_Overview__c> newmap,Map<Id,Family_Overview__c> oldMap){
        List<Id> familyAccId = new List<Id>();
        List<Id> personAccLst = new List<Id>();
        List<Account> familyActUpdate = new List<Account>();
        for(Family_Overview__c fo: newmap.values()){
             familyAccId.add(fo.Account__c);
            //Code Added for US2582440 -Start
            if(oldMap.get(fo.id).Designation__c!=fo.Designation__c){
                if(!Auth.CommunitiesUtil.isGuestUser()){
                fo.EHub_Update_Check__c=true;
                }
                RecursiveTriggerHandler.restrictOwnerChange=false;//Code added - US2556794
                fo.Designation_Changed_Date__c = Date.today();
            }//Code Addded for US2582440 -End
            //US3236600-Part 1-Start
            if(oldMap.get(fo.Id).Family_Needs__c != fo.Family_Needs__c || oldMap.get(fo.Id).Family_Status__c != fo.Family_Status__c){
                Account a = new Account();
                a.Id = fo.Account__c;
                    if(oldMap.get(fo.Id).Family_Needs__c != fo.Family_Needs__c){
                        a.Family_Needs__c = fo.Family_Needs__c;
                    }
                    if(oldMap.get(fo.Id).Family_Status__c != fo.Family_Status__c){
                        a.Family_Status__c = fo.Family_Status__c;
                    }
                familyActUpdate.add(a);
            }//US3236600-Part 1- End
        }
        //US3034530: SNI-Enhancement to Tasks to Update on Member Information
        /*Person Account for Member Information*/
        for(AccountContactRelation curAccConRel : [Select accountId,contactid,contact.accountId,account.UHG_Restriction__c from AccountContactRelation where accountId IN :familyAccId]){
            personAccLst.add(curAccConRel.contact.accountId);
        }
        /**Member Information of each Account**/
        List<Member_Information__c> memInfoLst =[Select Id from Member_Information__c where account__c in :personAccLst];
        List<task> activityList = [SELECT Id FROM Task where whatId in :memInfoLst AND Status != 'Completed' AND IsRecurrence != True];
        // End US3034530: SNI-Enhancement to Tasks to Update on Member Information	
        for(Family_Overview__c fo: newmap.values()){
            if(oldMap.get(fo.id).Designation__c == 'Assigned' && fo.Designation__c == 'Removed' && (fo.Family_Status__c == 'Active' || activityList.size()>0))
            {
                fo.adderror('Before you can choose this designation, Close all open Case(s), Support Request(s) and Task(s)');
            }
        }
        //US3236600-Part 2-Start
        if(familyActUpdate.size()>0){
            update familyActUpdate;
        }//US3236600-Part 2-End
    }
    
    public static void afterUpdate(Map<Id,Family_Overview__c> newmap,Map<Id,Family_Overview__c> oldMap){
        
        set<string> accIds = new set<string>();
        set<string> AssignedAccIds = new set<string>();
        for(Family_Overview__c fo: newmap.values()){
            if(oldmap.get(fo.id).Designation__c == 'Assigned' && fo.Designation__c == 'Removed' && fo.Family_Status__c == 'Inactive' ){
               accIds.add(fo.Account__c);
            }else{
                if((oldMap.get(fo.id).Designation__c!=fo.Designation__c) && (fo.Designation__c == 'Attempted' || fo.Designation__c == 'Worked')){
                    accIds.add(fo.Account__c);
                }else{
                    if((oldMap.get(fo.id).Designation__c!=fo.Designation__c) && fo.Designation__c == 'Assigned'){
                        AssignedAccIds.add(fo.Account__c);
                    }
                }
            }
        }
        if(accIds.size()>0){
            user u = [select id from user where name = 'Unassigned'];
            list<account> lstAc = new list<account>();
            for(account acc: [select id,ownerid from account where id IN : accIds]){
                acc.ownerid = u.id;
                lstAc.add(acc);
            }
            if(! lstAc.isEmpty()){
                update lstAc;
            }
        }
        Fo_validations__c famOverviewOverride = fo_validations__c.getOrgDefaults();
        if(AssignedAccIds.size()>0 && famOverviewOverride != null && famOverviewOverride.Is_Automation__c != true && !Auth.CommunitiesUtil.isGuestUser()){
            list<account> AccoList = new list<account>();
            for(account ac:[select id, ownerid from account where id in:AssignedAccIds]){
                ac.OwnerId = UserInfo.getUserId();
                AccoList.add(ac);
            }
            if(! AccoList.isEmpty()){
                update AccoList;
            }
        }
    }

}