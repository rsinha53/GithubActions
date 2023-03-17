/************************************************************
Class Name: SNI_FL_DeleteNPSDataRecordsScheduler
Description: This is used for scheduling the batch to delete 
             the last weeks NPS data records.
--------------------------------------------------------------
DEVELOPER     DATE             FUNCTIONALITY
---------------------------------------------------------------
Bindu     11/03/2021          Initial Development
***************************************************************/
global class SNI_FL_DeleteNPSDataRecordsScheduler implements Schedulable {
    global void execute(SchedulableContext SC) {
        //Calling the SNI_FL_DeleteNPSDataRecordsBatch 
        Database.executebatch(new SNI_FL_DeleteNPSDataRecordsBatch());
    }
}