trigger FamilyStoryGuideAnswersTrigger on Family_Story_Guide_Answers__c (after insert) {
    list<string> lstFsgIds = new list<string>();
    for(Family_Story_Guide_Answers__c famAns : trigger.new){
        lstFsgIds.add(famAns.Family_Story_Guide__c);
    }
    
    Map<string,Family_Story_Guide__c> mapFsg = new Map<string,Family_Story_Guide__c>();
    for(Family_Story_Guide__c fsg : [select id, Status__c from Family_Story_Guide__c where id IN : lstFsgIds]){
        mapFsg.put(fsg.id,fsg);
    }
    
    map<string,set<string>> mapansw = new map<string,set<string>>();
    for(Family_Story_Guide_Answers__c famAns :[select id,Family_Story_Guide__c,Family_Story_Guide_Questionare__r.QuestionNumber__c from Family_Story_Guide_Answers__c where Family_Story_Guide__c IN : mapFsg.keyset()]){
        if(! mapansw.containskey(famAns.Family_Story_Guide__c)){
		   mapansw.put(famAns.Family_Story_Guide__c,new set<string>{famAns.Family_Story_Guide_Questionare__r.QuestionNumber__c});
		}
		else{
			set<string> setstr = mapansw.get(famAns.Family_Story_Guide__c);
			setstr.add(famAns.Family_Story_Guide_Questionare__r.QuestionNumber__c);
			 mapansw.put(famAns.Family_Story_Guide__c,setstr);
		}
    }
   
    
    set<string> setQnum = new set<string>();
    for(Family_Story_Guide_Questionare__c famQS : [select id,QuestionNumber__c	from Family_Story_Guide_Questionare__c]){
        if( ! ( famQS.QuestionNumber__c == '1.3.1' ||  famQS.QuestionNumber__c == '6.2.1' ||  famQS.QuestionNumber__c == '6.1.1') ){
          setQnum.add(famQS.QuestionNumber__c);
		}
    }
	
	list<Family_Story_Guide__c> lstUpdateFSG = new list<Family_Story_Guide__c>();
    
	for(Family_Story_Guide__c fsg : mapFsg.values()){
             //system.debug('111111');
		     set<string> curfsgAnsw = mapansw.get(fsg.id);
	         if( fsg.Status__c !=  'Completed'){
                // system.debug('222');
	            boolean match = false;
				for(string qs : setQnum){
                   // system.debug('333');
				    if(! curfsgAnsw.contains(qs)){
						match = true;
						if( fsg.Status__c !=  'Partially Completed'){
                           // system.debug('444');
							Family_Story_Guide__c fs = new Family_Story_Guide__c();
                            fs.id = fsg.id;
                            fs.Status__c = 'Partially Completed';
                            fs.Status_Modified_Date__c	= system.today();
                            fs.Expiration_Date__c	= system.today().addMonths(6);
                            lstUpdateFSG.add(fs);
						}
						break;
					}
				}
				if(! match){
                   // system.debug('555');
                     Family_Story_Guide__c fs = new Family_Story_Guide__c();
                     fs.id = fsg.id;
                     fs.Status__c = 'Completed';
                     fs.Status_Modified_Date__c	= system.today();
                     fs.Expiration_Date__c	= system.today().addMonths(6);
                     lstUpdateFSG.add(fs);
                     
                }
			 }
	
	}
	
	if(lstUpdateFSG.size()>0){
       update lstUpdateFSG;
	/*for(Family_Story_Guide__c fm : lstUpdateFSG){
	system.debug('fsg id is ----'+fm.id);
	}*/
    }
}