public class ETSBE_CaseAgeController {

    @AuraEnabled
    public static String calculateCaseAge(String caseId) {
        
        String caseAge = '';
        
        try {
            
            Case caseObj = [SELECT CreatedDate, ClosedDate, Event_Received_Date_Time__c, Is_Cloned__c  FROM Case WHERE id =: caseId];
            
            BusinessHours businessHoursObj = [SELECT Id FROM BusinessHours WHERE Name='ETS-BE/BEO' AND IsActive=true];
            
            DateTime startDateTime;
            Datetime endDateTime;

            if(caseObj != null) {
                
                /*if(caseObj.Event_Received_Date_Time__c != null && caseObj.Is_Cloned__c) {
                   startDateTime = caseObj.Event_Received_Date_Time__c; 
                } else {
                   startDateTime = caseObj.CreatedDate; 
                } */            
                
                startDateTime = caseObj.CreatedDate;
                
                if(caseObj.ClosedDate != null) {
                	endDateTime = caseObj.ClosedDate;    
                } else {
                    endDateTime = DateTime.now();
                }                
            }
            
            ETSBE_AgeCalculationBatch_Handler.AgeDataWrapper ageDataWrapperObj = ETSBE_AgeCalculationBatch_Handler.returnAgeInDaysAndHours(startDateTime, endDateTime, 0, null, '', businessHoursObj);
            
            if(ageDataWrapperObj != null && ageDataWrapperObj.noOfDays != null && ageDataWrapperObj.noOfHours != null) {
                
            	caseAge = ageDataWrapperObj.noOfDays + ' Days' + ' ' + ageDataWrapperObj.noOfHours + ' Hours';  
            }            
            
        } catch(Exception e) {
           
            System.debug('Exception occurred in calculateCaseAge(String caseId) method in CaseAgeController class -> '+e);
        }        
        
        return caseAge;
    }
    
}