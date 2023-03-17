public with sharing class TriggerHelper {
	private static set<String> originalList ;
    @Testvisible private static boolean isSyncProcess = false;
    @Testvisible private static boolean isdupeExistNeed = true;
    
    public static boolean isDupExist(String dupString){
        if(isdupeExistNeed){
     
    	if(originalList == null || originalList.isEmpty()){
    		originalList = new Set<String>();
    	}
    	if(!originalList.contains(dupString)){
    		originalList.add(dupString);
    		return false;
    	}
    	return true;
        }
        return isdupeExistNeed;
    }
    
    public static boolean isSync(){
          return (System.isBatch() || System.isQueueable() || system.isFuture()|| isSyncProcess);
    }
}