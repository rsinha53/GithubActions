public class ETSBE_AgeCalculationBatch_Handler {
    
    public static AgeDataWrapper returnAgeInDaysAndHours(DateTime startDateTime, DateTime endDateTime, Integer currentYear, DateTime recCreatedDateTime, String recAge, BusinessHours businessHoursObj) {
        
        AgeDataWrapper ageDataWrapperObj = new AgeDataWrapper();
        
        try {
            
            Long seconds = BusinessHours.diff(businessHoursObj.ID, startDateTime, endDateTime); 
            seconds = (seconds != null) ? seconds : 0;
            Long hours = seconds / 3600000;
            hours = (hours != null) ? hours : 0;
            
            Long days = hours / 24;
            Long hoursRemaining = Math.mod(hours, 24);
            
            System.debug(days+' Day/\'s & '+hoursRemaining+' Hours');                        
            
            ageDataWrapperObj.noOfDays = 0;
            if(recCreatedDateTime != null && recCreatedDateTime.year() != currentYear) {           
                String existingInterActAge = recAge;
                if(existingInterActAge != null && existingInterActAge.length() > 0) {
                    String[] existingInterActAgeArray = existingInterActAge.split(':');
                    ageDataWrapperObj.noOfDays =  Integer.valueOf(existingInterActAgeArray[0])+1;
                    //System.debug('Old Val for Days - '+ageDataWrapperObj.noOfDays);
                    //System.debug('Old Val for Hours - '+ageDataWrapperObj.noOfHours);
                }                
            }
            if(hours != null) {              
                ageDataWrapperObj.noOfDays = days;            
                ageDataWrapperObj.noOfHours = hoursRemaining;
            }
            //System.debug('Days - '+ageDataWrapperObj.noOfDays);
            //System.debug('Hours - '+ageDataWrapperObj.noOfHours);
            
        } catch(Exception e) {
            
            System.debug('Excpetion occured while performing the Interaction Age Calculation logic in returnInteractionAgeInDaysAndHours(Interaction__c interActObj) in  AgeCalculationBatch_Handler Class -> '+e);
            throw e;
        }        
        
        return ageDataWrapperObj;
    }
    
    /* Wrapper class to return the Age Calculation Data */
    
    public class AgeDataWrapper {
        
        public Long noOfDays {get;set;}
        public Long noOfHours {get;set;}
        
        public AgeDataWrapper() {
            noOfDays = 0;
            noOfHours = 0;
        }
    }
    
}