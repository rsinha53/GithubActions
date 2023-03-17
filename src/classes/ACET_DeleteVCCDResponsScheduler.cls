/************************************************************
Class Name: ACET_DeleteVCCDResponsScheduler
Description: This is used for scheduling the batch to delete 
             the inactive vccd records
--------------------------------------------------------------
DEVELOPER     DATE             FUNCTIONALITY
---------------------------------------------------------------
Sravan     26/06/2020          Initial Development
***************************************************************/
global class ACET_DeleteVCCDResponsScheduler implements Schedulable {
   global void execute(SchedulableContext SC) {
       //Calling the ACET_DeleteVCCDResponseBatch 
       Database.executebatch(new ACET_DeleteVCCDResponseBatch());
   }
}