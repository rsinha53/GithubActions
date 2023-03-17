global class ETSBE_InteractionAgeCalcmorethan90Batch implements Database.Batchable<Sobject>, Database.Stateful {

    global Integer totalNoOfInteractionsProcessed = 0;
    global Integer successfulInteractionsRecords = 0;
    global Integer failureInteractionsRecords = 0;
    global List<String> errorMessagesList = new List<String>();
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        
        System.debug('ETSBE Interaction Age Calculation Batch START');
        //US3189754:Change
        String recTypeName='BEO Interaction';
        date resolutiondate = date.parse(label.resolutionDate);
        String query = 'Select Id, Evt_Recvd_Dt_Time__c, Resolution_Date__c, CreatedDate, Age__c from Interaction__c where  Evt_Recvd_Dt_Time__c != null AND Resolution_Date__c <: resolutiondate and (RecordType.Name=:recTypeName)  and  age__c like'+'\'%-%\'';
        return Database.getQueryLocator(query);

    }
    
    global void execute(Database.BatchableContext BC, List<Interaction__c> interactionRecordsList) {
        System.debug('interactionRecordsList=='+interactionRecordsList.size());
        List<Interaction__c> interactionRecsListToBeUpdated = new List<Interaction__c>();
        
        try {
            
            if(interactionRecordsList != null && interactionRecordsList.size() > 0) {
                
                // Get the default business hours
                BusinessHours businessHoursObj = [SELECT Id FROM BusinessHours WHERE Name='ETS-BE/BEO' AND IsActive=true];            
                
                Integer currentYear = Date.today().year();
                
                for(Interaction__c interactionObj : interactionRecordsList) {
                    
                    DateTime resolutionDtTime = interactionObj.Resolution_Date__c;
                    DateTime startDateTime;            
                    DateTime endDateTime;
                    
                    DateTime interActCreatedDt = interactionObj.CreatedDate;
                    //DE413884: Interaction Age Incorrectly Calculating INC-19863291
                    
                   startDateTime = interactionObj.Evt_Recvd_Dt_Time__c;
                    
                    if(resolutionDtTime != null) {
                        endDateTime = resolutionDtTime;
                    } else {
                        endDateTime = DateTime.now();
                    }
                    system.debug('....startDateTime......'+startDateTime);
                    system.debug('....endDateTime......'+endDateTime);
                    
                    
                    ETSBE_AgeCalculationBatch_Handler.AgeDataWrapper ageDataWrapperObj = ETSBE_AgeCalculationBatch_Handler.returnAgeInDaysAndHours(startDateTime, endDateTime, currentYear, interactionObj.CreatedDate, interactionObj.Age__c, businessHoursObj);
                    
                    if(ageDataWrapperObj != null && ageDataWrapperObj.noOfDays != null && ageDataWrapperObj.noOfHours != null) {
                        
                        Interaction__c intrObj = new Interaction__c();
                        intrObj.Id = interactionObj.Id;
                        intrObj.Age__c = ageDataWrapperObj.noOfDays+':'+ageDataWrapperObj.noOfHours;                        
                        interactionRecsListToBeUpdated.add(intrObj);
                    }
                }
                
            }
            //System.debug('InteractionRecsListToBeUpdated-'+interactionRecsListToBeUpdated);
            
            if(interactionRecsListToBeUpdated != null && interactionRecsListToBeUpdated.size() > 0) {
                
                totalNoOfInteractionsProcessed = totalNoOfInteractionsProcessed + interactionRecsListToBeUpdated.size();
                Database.SaveResult[] srList = Database.update(interactionRecsListToBeUpdated, false);
                
                List<Id> successfulIds = new List<Id>();
                List<Id> failureIds = new List<Id>();
                for (Database.SaveResult sr : srList) {
                    if (sr.isSuccess()) {
                        successfulIds.add(sr.getId());
                    }
                    else {
                        failureIds.add(sr.getId());               
                        for(Database.Error err : sr.getErrors()) {
                            errorMessagesList.add('While updating the Interaction, the fields affected - '+ err.getFields() + ' => ' + err.getStatusCode() + ': ' + err.getMessage());
                        }
                    }
                }
                
                successfulInteractionsRecords += successfulIds.size();
                failureInteractionsRecords += failureIds.size();
            }
            
        } catch(Exception e) {
           
            System.debug('Excpetion occurred in ETSBE Interaction Age Calculation Batch execute() - '+e);
            errorMessagesList.add(e.getMessage());
            failureInteractionsRecords = totalNoOfInteractionsProcessed;
        }
        
    }
    
    global void finish(Database.BatchableContext BC) {
        
        try {
            
            AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email, ExtendedStatus from AsyncApexJob where Id = :BC.getJobId()];
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String toAddrsSucOrFaiNotis = System.Label.ETSBE_InteractAge_Batch_ToEmailAddrs;
            String[] toAddresses = toAddrsSucOrFaiNotis.split(';;');
            mail.setToAddresses(toAddresses);   
            
            String emailBody = 'Total number of Interaction Records to be processed -> '+ totalNoOfInteractionsProcessed + '<br/><br/>';
            emailBody += 'Successfully processed Interaction Records -> '+ successfulInteractionsRecords + '<br/><br/>';   
            emailBody += 'Failure Interaction Records -> '+ failureInteractionsRecords + '<br/><br/>';   
            
            if(errorMessagesList != null && errorMessagesList.size() > 0 ) {
                
                mail.setSubject('Batch - Interaction Age Failure Notification');
                emailBody += 'Please find the following errors - <br/><br/>';
                for(String errorMsg : errorMessagesList) {
                    emailBody += errorMsg + '<br/>';
                }
                
                emailBody += '<br/><a href="'+System.Url.getSalesforceBaseUrl().toExternalForm()+'/lightning/setup/AsyncApexJobs/home">Navigate to Apex Jobs</a>';
                
            } else {
                
                if(a.Status == 'Completed' && a.NumberOfErrors == 0) {               
                    mail.setSubject('Batch - Interaction Age Success Notification'); 
                    emailBody += '<br/>' + 'The Batch Apex processed ' + a.TotalJobItems + ' job items successfully.';                
                } else {                
                    mail.setSubject('Batch - Interaction Age Failure Notification');                                
                    emailBody += '<br/>' + 'The Batch Apex processed ' + a.TotalJobItems + ' job items with '+ a.NumberOfErrors + ' failures.';
                }                        
            }
            
            mail.setHtmlBody(emailBody);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });                        
        } catch(Exception e) {
            
            System.debug('Excpetion occurred in ETSBE Interaction Age Calculation Batch finish() - '+e);
        }        
                
        System.debug('ETSBE Interaction Age Calculation Batch END');
    }
    
}