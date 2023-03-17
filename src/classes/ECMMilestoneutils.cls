public with sharing class ECMMilestoneutils {  
  
  //Method to Auto-close case milestones   //
  public static void completeMilestone(List<Id> caseIds,  DateTime complDate){
    
    List<CaseMilestone> caseMilestonesToUpdate = new list<CaseMilestone>([Select Id, completionDate From CaseMilestone cm Where caseId in :caseIds 
                                                    And completionDate = null]);
    
    if(caseMilestonesToUpdate.isEmpty() == false){
        for(CaseMilestone cm : caseMilestonesToUpdate){
            cm.completionDate = complDate;
        }
        
        update caseMilestonesToUpdate;
    }
  }  
}