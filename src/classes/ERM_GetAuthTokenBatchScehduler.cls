public class ERM_GetAuthTokenBatchScehduler implements Schedulable{
    public void execute(SchedulableContext sc) {
        Set<String> serviceNames = new Set<String>();
        serviceNames.add('ERMServiceTokenAPI');
        Database.executeBatch(new ACET_GetAuthTokenBatch(serviceNames), 1);					
    }
}