@isTest
public class ETSBE_AgeCalculationBatch_HandlerTest {
    public static testMethod void AgeCalcultion_Test() {
        try{
        DateTime testDateTime = DateTime.newInstance(2019, 12, 17, 13, 6, 6);
        BusinessHours businessHourId=[select id from BusinessHours where IsDefault=true];
        Datetime startDT = system.today();
        Datetime endDT = DateTime.Now().AddDays(2);
        Long intervalMilliseconds = 50000;
        ETSBE_AgeCalculationBatch_Handler.returnAgeInDaysAndHours(startDT, endDT, null, testDateTime, '', businessHourId);
        }catch(Exception e) {
            
        }
        
    }
      public static testMethod void AgeCalcultion_Test1() {
        try{
        DateTime testDateTime = DateTime.newInstance(2020, 12, 17, 13, 6, 6);
        BusinessHours businessHourId=[select id from BusinessHours where IsDefault=true];
        Datetime startDT = system.today();
        Datetime endDT = DateTime.Now().AddDays(2);
        Long intervalMilliseconds = 50000;
        ETSBE_AgeCalculationBatch_Handler.returnAgeInDaysAndHours(startDT, endDT,null, testDateTime, 'null', businessHourId);
        }catch(Exception e) {
            
        }
        
    }
    
}