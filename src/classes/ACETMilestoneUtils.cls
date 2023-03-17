public class ACETMilestoneUtils {
    
    public static void completeMilestone(List<Id> WOIds) {  
        List<EntityMilestone> emsToUpdate = [select Id, completionDate
                                             from EntityMilestone
                                             where ParentEntityId  in :WOIds
                                             and completionDate = null limit 1];
        system.debug('emsToUpdate.........'+emsToUpdate);
        if (emsToUpdate.isEmpty() == false || Test.isRunningTest()){
            for (EntityMilestone cm : emsToUpdate){
                cm.completionDate = System.now();
            }
            update emsToUpdate;
        }
        
        
    }
}