/* Author : Vishal Badoni
 * Created Date : 13 August 2021
 * Schedubale class created to schedule ACET_FreezingUserBatch for 3:AM CT
*/

global class ACET_FreezingUserBatchScheduler Implements Schedulable {
    
    global void execute(SchedulableContext sc)
   		 {	
            
         	ACET_FreezingUserBatch b = new ACET_FreezingUserBatch();
             database.executeBatch(b,200);

          }
}