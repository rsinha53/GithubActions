public without sharing class ACETLGT_LastCallController {
	
    @AuraEnabled
    public static Case getLastCalldetails(String surrogate){
        list<string> surrogateList = new list<String>();
        if(surrogate.contains(','))
            surrogateList = surrogate.split(',');
        else
            surrogateList.add(surrogate);
        list<Case> cs = [Select Id, Topic__c, Type__c, Subtype__c from case where Originator_Type__c='member' AND Surrogate_Key__c IN: surrogateList AND Status!='Canceled' Order by Createddate desc LIMIT 1];
        return (cs!=null && cs.size()>0)?cs[0]:null;
    }
}