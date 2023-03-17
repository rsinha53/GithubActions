public class ACETCallTopicCreateCaseItem{
    
     public Map<String,ACETCaseitemwrapper> caseitemwrap{get {
     	if(caseitemwrap == null){
     		caseitemwrap =  new Map<String,ACETCaseitemwrapper> ();
     	}
     	return caseitemwrap;
     }
     set;}
     public ACETCaseitemwrapper caseItem {get;set;}
        
    public ACETCallTopicCreateCaseItem(){
         
       }
     //
    public void addCaseItem(){
        string keyFieldName = Apexpages.currentPage().getParameters().get('keyFieldName');
        string topic = system.CurrentPageReference().getParameters().get('topic');
        
        
        system.debug('keyFieldName ' + keyFieldName );
        system.debug('topic ' + topic );
        
         caseItem = new ACETCaseitemwrapper();
        caseItem.caseobj = new case();
        
        caseItem.caseobj.topic__c = topic;
        caseItem.keyfieldId = keyFieldName;
        
        caseitemwrap.put(keyFieldName,caseItem);
    }
}