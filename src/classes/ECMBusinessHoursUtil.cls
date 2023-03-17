public class ECMBusinessHoursUtil {
  public static final Integer SECOND = 1000;
  public static final Integer MINUTE = 60 * SECOND;
  public static final Integer HOUR = 60 * MINUTE;
    /*
     *  Find the business day between start date and end date.After remaining MS convert in to hours and minutes.
     */
    public Static String getBusinessWorkingDaysHoursMin(Id businessHoursId,Datetime startDate,Datetime endDate){
         String bsTime = ''; 
         Integer bsDayCount = 0;
         //Initiate date and time with out seconds. No need to consider time out
         startDate = Datetime.newInstance(startDate.year(), startDate.month(), startDate.day(), startDate.hour(), startDate.minute(), 0);
         endDate =  Datetime.newInstance(endDate.year(), endDate.month(), endDate.day(), endDate.hour(), endDate.minute(), 0);
        Datetime bsDay  = startDate;
        Integer dayCount = 0;
        Integer daysDiff = startDate.date().daysBetween(endDate.date());
        long bsMscalc =0;
       
        DateTime calcTimeStart = constructBsDate(businessHoursId,startDate);
        if(calcTimeStart == null){
            calcTimeStart = BusinessHours.nextStartDate(businessHoursId,startDate);
        }
  		for( dayCount = 1;dayCount <= daysDiff;  dayCount ++) {
               bsDay = constructBsDate(businessHoursId,calcTimeStart.addDays(dayCount));
      		  if(bsDay != null && bsDay.getTime() <= endDate.getTime()){
                  bsDayCount ++;
                  bsMscalc =  BusinessHours.diff(businessHoursId, startDate, bsDay);
     			 }
        }
        long intervalMilliseconds = BusinessHours.diff(businessHoursId, startDate, endDate);
        bsTime = String.valueOf(bsDayCount) ;
        if(bsDayCount > 1) {
            bsTime += ' Days';
          }else {
             bsTime += ' Day';
          }
          bsTime += converHoursAndMin(intervalMilliseconds - bsMscalc);
          
        
       return bsTime;
    }

    public static Datetime constructBsDate(String  businessHoursId,Datetime receivedDate){
      Datetime bsDate = null;
      if( BusinessHours.isWithin(businessHoursId, receivedDate)) {
          bsDate =  receivedDate;
      }
        return bsDate;
    }
    
    public static String converHoursAndMin(long dayntervalms ) {
          String bsTime = ' : '; 
          if(dayntervalms >= HOUR){
            long bsHour = dayntervalms/HOUR;
            bsTime += String.valueOf(bsHour);
            if(bsHour > 1) {
               bsTime += ' Hours';
            }else { 
             bsTime += ' Hour';
            }
        
        	dayntervalms = Math.mod(dayntervalms, HOUR);
    	}else { 
       	bsTime += ' 0 Hour';
    	}
    	
 		if(dayntervalms >= MINUTE){
       long bsMin = dayntervalms/MINUTE; 
         bsTime += ' : '+String.valueOf(bsMin);
       if(bsMin > 1) {
               bsTime += ' Minutes';
            }else {
             bsTime += ' Minute';
            }
     
     		dayntervalms = Math.mod(dayntervalms, MINUTE);
        }else{
              bsTime += ' : 0 Minute';
        }
      
        
        return bsTime; 
    }
    /*
      Calculate the target ,completion and variance in Busniess days hours and minutes
    */
    public static void setBusinessCalculation(String businessHoursId,Milestone_Performance__c msp){
      if(msp != null ) {
         Long targetMin = msp.PlannedMilestoneMinutestoComplete__c.longValue() *  MINUTE;
         Datetime targetTime = BusinessHours.add(businessHoursId,msp.MilestoneStartDateTime__c,targetMin );
         msp.Target_Time_DDD_HH_MM__c = getBusinessWorkingDaysHoursMin(businessHoursId,  msp.MilestoneStartDateTime__c, targetTime);
       if(msp.ActualMilestoneCompletionDateTime__c != null) {
         Long interval = msp.ActualMilestoneMinutestoComplete__c == null ? 0 : msp.ActualMilestoneMinutestoComplete__c.longValue() *  MINUTE;
         Datetime completionTime = BusinessHours.add(businessHoursId,msp.MilestoneStartDateTime__c,interval );
         msp.Completion_Time_DDD_HH_MM__c = getBusinessWorkingDaysHoursMin(businessHoursId,  msp.MilestoneStartDateTime__c,completionTime );
          if(msp.ActualMilestoneMinutestoComplete__c  > msp.PlannedMilestoneMinutestoComplete__c) {
            msp.Variance_Time_DDD_HH_MM__c = getBusinessWorkingDaysHoursMin(businessHoursId, targetTime,completionTime);
          }else {
             msp.Variance_Time_DDD_HH_MM__c = '- ' +getBusinessWorkingDaysHoursMin(businessHoursId, completionTime, targetTime);
 
        }
      }
      }
    }
}