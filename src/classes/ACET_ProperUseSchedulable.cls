global class ACET_ProperUseSchedulable implements Schedulable {

    global void execute(SchedulableContext SC) {
        System.enqueueJob(new ACET_ProperUseQueable());
    }

}