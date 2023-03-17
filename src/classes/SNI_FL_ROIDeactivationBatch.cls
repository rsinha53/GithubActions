public class SNI_FL_ROIDeactivationBatch implements Database.Batchable<sObject>{
    
    public List<SNI_FL_Members_ROI__c> start(Database.BatchableContext BC){
        Date todayDate=System.today();
        List<SNI_FL_Members_ROI__c> lstROIExpired = new List<SNI_FL_Members_ROI__c>([
            SELECT Id,Exp_Date__c,SNI_FL_Status__c, SNI_FL_Account__c,  
                                         SNI_FL_ROI_Signed_Date__c, SNI_FL_ROI_Signed_With__c, SNI_FL_Member__c
                                         FROM SNI_FL_Members_ROI__c where Exp_Date__c<= :todayDate]);


        system.debug(LoggingLevel.INFO, 'lstROIExpired.size: ' + lstROIExpired.size());
        
        return lstROIExpired;
    }
    
    public void execute(Database.BatchableContext BC, List<SNI_FL_Members_ROI__c> scope) {
        SNI_FL_ROIUtility.deActivateROI(scope);
    }
    
    public void finish(Database.BatchableContext BC) {
        AsyncApexJob mainjob =[Select Id,status,numberoferrors,jobitemsprocessed,totaljobitems from AsyncApexJob WHERE Id =:BC.getJobId()];
        if(mainjob.NumberOfErrors>0){
            String errorMessage='job id:'+mainjob.Id+',numberoferrors:'+ mainjob.numberoferrors +',totaljobitems:'+mainjob.totaljobitems+',jobitemsprocessed:'+mainjob.jobitemsprocessed+'status:'+mainjob.status;
            ACETUtility.CreateApplicationExcepLog('Roi Deactivation Batch', 'Acet', 'Batch Job Error', mainjob.Status, '', errorMessage, '');

        }
    }

}