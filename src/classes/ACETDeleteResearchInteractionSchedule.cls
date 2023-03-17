global class ACETDeleteResearchInteractionSchedule implements Schedulable{
    global void execute(SchedulableContext SC) {
        ACETDeleteResearchInteractionBatch batchClass = new ACETDeleteResearchInteractionBatch();
        Database.ExecuteBatch(batchClass);
        
        //Run following block of statements in Developer Console to schedule batch job it run after every day at 12AM   
        /*  
        String day = string.valueOf(system.now().day());
        String month = string.valueOf(system.now().month());
        
        Integer hour = Integer.Valueof(system.now().hour() + Integer.valueof(Label.ACETResearchInteractionBatchHour));
        
        String actualHour = String.valueof(hour > 23 ? hour - 24 : hour);
        String minute = string.valueOf(system.now().minute());
        String second = string.valueOf(system.now().second());
        String year = string.valueOf(system.now().year());
        
        String strJobName = 'Job-' + second + '_' + minute + '_' + actualHour + '_' + day + '_' + month + '_' + year;
        //String strSchedule = '0 ' + minute + ' ' + actualHour + ' ' + day + ' ' + month + ' ?' + ' ' + year;
        String strSchedule = '0 0 0 * * ?';
        
        system.schedule(strJobName, strSchedule, new ACETDeleteResearchInteractionSchedule ()); */
        
        
    } 
}