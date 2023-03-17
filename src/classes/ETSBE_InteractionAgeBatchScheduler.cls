global class ETSBE_InteractionAgeBatchScheduler implements Schedulable {
    
    global void execute(SchedulableContext sc) {
        ETSBE_InteractionAgeCalculationBatch b = new ETSBE_InteractionAgeCalculationBatch();
        database.executebatch(b);
    }
    
}