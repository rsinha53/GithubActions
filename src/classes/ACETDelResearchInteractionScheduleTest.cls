@isTest(SeeAllData=false)
public class ACETDelResearchInteractionScheduleTest {
    @testSetup
    static void setupData(){
        list<Interaction__c> intr = new list<Interaction__c>();
        for(Integer i=0;i<300;i++){
            intr.add(new Interaction__c(Interaction_Type__c='Research Only'));
        }
        insert intr;
    }
    
    static testMethod void deleteScheduleInteractionTest1(){
        test.startTest();
        
        String day = string.valueOf(system.now().day());
        String month = string.valueOf(system.now().month());
        
        Integer hour = Integer.Valueof(system.now().hour() + Integer.valueof(Label.ACETResearchInteractionBatchHour));
        
        String actualHour = String.valueof(hour > 23 ? hour - 24 : hour);
        String minute = string.valueOf(system.now().minute());
        String second = string.valueOf(system.now().second());
        String year = string.valueOf(system.now().year());
        
        String strJobName = 'TestClassJobDelResearchInteraction';
        //String strSchedule = '0 ' + minute + ' ' + actualHour + ' ' + day + ' ' + month + ' ?' + ' ' + year;
        String strSchedule = '0 0 0/4 * * ?';
        
        test.stopTest();
        
        System.schedule(strJobName, strSchedule, new ACETDeleteResearchInteractionSchedule ());
   }
    
   static testMethod void deleteBatchInteractionTest2(){
        test.startTest();
        List<Interaction__c> intracts = [select id,Interaction_Type__c from Interaction__c where Interaction_Type__c='Research Only' limit 10];
        database.executeBatch(new ACETDeleteResearchInteractionBatch());      
        test.stopTest();      
    }
    
}