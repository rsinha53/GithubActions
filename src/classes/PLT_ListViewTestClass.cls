@isTest(SeeAllData=true)
public with sharing class  PLT_ListViewTestClass {
    @isTest public static void listViewTestMethod() {
                    
        Map<Id, DateTime> idToLastViewedDateMap = new Map<Id, DateTime>();
        Map<Id, Map<Id, Datetime>> userToListViewMap = new Map<Id, Map<Id, DateTime>>();  
        Map<Id, String> listViewToUserMap = new Map<Id, String>();
        Map<Id, String> idToNameListViewMap = new Map<Id, String>();
        
        
        /*Retrieve start and end values from the Custom Setting.
         * Note that this value needs to updated after each execution of the test class.
         * We can't run the logic for Users at the same iteration as it will exceed governor limits. 
         * We have run this inside for loop as the logic need to be run for each user.
         * Hence we have to brake in to 99 chunks and run 10 times [We have almost 975 Active users]
         */
        
        ACET_ListView_Test_Limit__mdt lmtSettings = [Select Iteration_Starting_Number__c,Iteration_Stopping_Number__c,Jenkins_Username__c
                                                    From  ACET_ListView_Test_Limit__mdt Where QualifiedApiName='Iteration_Parameters'];
        Integer startVal = lmtSettings.Iteration_Starting_Number__c.intValue();
        Integer stopVal = lmtSettings.Iteration_Stopping_Number__c.intValue();        
        String jbuilderUser = lmtSettings.Jenkins_Username__c;

        
        System.debug('## Start val : '+startVal+' ## Stop val: '+stopVal);
        system.debug('## jBuilder user : '+jbuilderUser);
        
        List<User> listOfUsers= new List<User>();
        List<User> setOfUsers = [SELECT Id,username FROM User where isActive=True AND username != :jbuilderUser];
      
        for(Integer i=startVal;i<stopVal;i++){
            listOfUsers.add(setOfUsers[i]);       
        }
        for(User usobj : listOfUsers){
            
            //List view query need to run by user context
            System.runAs(usobj) {
                List<ListView> lview =[Select Id ,CreatedDate, LastModifiedDate,  LastViewedDate, LastReferencedDate ,SobjectType,DeveloperName From ListView  Where SobjectType='Case'];
                
                for(ListView lvobj : lview)
                {     
                    If(lvobj.LastViewedDate != null){					
                        idToNameListViewMap.put(lvobj.Id, lvobj.DeveloperName);                    
                        
                        if (idToLastViewedDateMap.get(lvobj.Id) != null){
                            if (lvobj.LastViewedDate > idToLastViewedDateMap.get(lvobj.Id)){                            
                                idToLastViewedDateMap.put(lvobj.Id, lvobj.LastViewedDate);                            
                                listViewToUserMap.put(lvobj.Id, usobj.username);                             
                            }                            
                        }else {
                            idToLastViewedDateMap.put(lvobj.Id, lvobj.LastViewedDate);
                            listViewToUserMap.put(lvobj.Id, usobj.username);
                        } 
                    
                	}
                }  
                
            }
        }
        //Prepare the final List           
        for (Id lId: idToLastViewedDateMap.keySet()){
            system.debug('Id '+lId+' ## ListView Name '+idToNameListViewMap.get(lId)+ ' lastViewedDate '+idToLastViewedDateMap.get(lId)+ ' User '+listViewToUserMap.get(lId));
        }
    }   
}