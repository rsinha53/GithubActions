trigger ACETfamilyOverviewTrigger on Family_Overview__c (before update,after update) {

  if(trigger.isUpdate){
    if(trigger.isbefore){
        ACETFamilyOverviewTriggerHelper.beforeUpdate(trigger.newmap,trigger.oldmap);
        /*for(Family_Overview__c fo: trigger.new){

            //Code Added for US2582440 -Chandan-Start
            if(trigger.oldmap.get(fo.id).Designation__c!=fo.Designation__c){
                fo.EHub_Update_Check__c=true;
            }//Code Addded for US2582440 -End
            if(trigger.oldmap.get(fo.id).Designation__c == 'Assigned' && fo.Designation__c == 'Removed' && fo.Family_Status__c == 'Active' )
            {
                fo.adderror('Before you can choose this designation, Close all open Case(s), Support Request(s) and Task(s)');
            }

        }*/
    }
    if(trigger.isafter){

        ACETFamilyOverviewTriggerHelper.afterUpdate(trigger.newmap,trigger.oldmap);
        /*
        ACETFamilyOverviewTriggerHelper.beforeUpdate(trigger.newmap,trigger.oldmap);
        set<string> accIds = new set<string>();
        for(Family_Overview__c fo: trigger.new){
            if(trigger.oldmap.get(fo.id).Designation__c == 'Assigned' && fo.Designation__c == 'Removed' && fo.Family_Status__c == 'Inactive' ){
               accIds.add(fo.Account__c);
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
        }*/
    }
   }
}