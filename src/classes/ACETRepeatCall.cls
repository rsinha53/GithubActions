global class ACETRepeatCall {
  
  WebService static void incrementRepeatCall(string caseId){
    //this method called from Repeat Call button on Case page, do not delete -JW (Nirvana) 11/6/17
    Case c = new Case();
    c = [SELECT Id, Repeat_Call__c FROM Case WHERE Id = :caseId];
    if(c.Repeat_Call__c==null){
      c.Repeat_Call__c=1;
    }
    else{
      c.Repeat_Call__c++;
    }
    update c;    
  }
  
}