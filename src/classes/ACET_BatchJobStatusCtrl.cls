public without sharing class ACET_BatchJobStatusCtrl {

    @AuraEnabled
    public static CronTrigger getBatchJobStatus(String serviceRecordId) {
        CronTrigger cronTriggerRecord = new CronTrigger();
        try {
            String serviceName = [SELECT Name FROM WebserviceConfigurations__c WHERE Id = :serviceRecordId].Name;
            String jobName = serviceName + ' Access Token Job';
            System.debug('@@ ACET_BatchJobStatusCtrl: getBatchJobStatus: jobName: ' + jobName);
            cronTriggerRecord = [SELECT Id, CronJobDetail.Name, PreviousFireTime, NextFireTime, StartTime, EndTime, State FROM CronTrigger
                WHERE CronJobDetail.Name =: jobName AND State != 'DELETED'
            ];
        } catch (QueryException qe) {}
        return cronTriggerRecord;
    }

    @AuraEnabled
    public static Boolean initiateJob(String serviceName) {
        //CronTrigger cronTriggerRecord = new CronTrigger();
        Boolean isBatchScheduled = false;
        try {
            String jobName = serviceName + ' Access Token Job';
            System.debug('@@ ACET_BatchJobStatusCtrl: initiateJob: jobName: ' + jobName);
            //System.scheduleBatch(new ACET_GetCachedAuthTokensBatch(serviceName), jobName, 2, 1);
            isBatchScheduled = true;
            /* cronTriggerRecord = [SELECT Id, CronJobDetail.Name, PreviousFireTime, NextFireTime, StartTime, EndTime, State FROM CronTrigger
                WHERE CronJobDetail.Name =: jobName AND State != 'DELETED'
            ]; */
        } catch (QueryException qe) {
            isBatchScheduled = false;
        }
        return isBatchScheduled;
    }

}