public class ACETFamilyStoryGuideUIController {

    @AuraEnabled        
    public static List<String> getPickListValuesIntoList(){
        List<String> pickListValuesList = new List<String>();
        List<Family_Story_Guide_Questionare__c> fsgq = new List<Family_Story_Guide_Questionare__c>();
        Schema.DescribeFieldResult fieldResult = Family_Story_Guide_Questionare__c.Topic__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        fsgq = [select  id,Topic__c,hoverHelpText__c,Question__c,QuestionNumber__c,Response__c  from Family_Story_Guide_Questionare__c where Topic__c =: ple[0].getLabel() order by Question_Order__c];
        Map<String,Map<String,String>> optionMap = new Map<String,Map<String,String>>();
        Map<String,wrapperQuestions> questionMap = new Map<String,wrapperQuestions>();
        for(Family_Story_Guide_Questionare__c fsg:fsgq){
            if(optionMap.containsKey(fsg.QuestionNumber__c)) {
                Map<String,String> quesKey = optionMap.get(fsg.QuestionNumber__c);
                quesKey.put(fsg.Response__c,fsg.id);
                optionMap.put(fsg.QuestionNumber__c, quesKey);
            } else {
                optionMap.put(fsg.QuestionNumber__c, new Map<String,String> {fsg.Response__c => fsg.id});
            }
        }
        for(Family_Story_Guide_Questionare__c fsg:fsgq){
            questionMap.put(fsg.QuestionNumber__c,new wrapperQuestions(optionMap.get(fsg.QuestionNumber__c),fsg.Question__c,fsg.QuestionNumber__c,fsg.hoverHelpText__c));
        }
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.add(pickListVal.getLabel());
        }
        if(! pickListValuesList.isEmpty()){
            pickListValuesList.add('Notes/Results');
        }
        return pickListValuesList;
    }
    public class wrapperQuestions {
        @AuraEnabled
        public Map<String,String> answerOptions{get; set;}
         @AuraEnabled
        public String Question{get; set;}
         @AuraEnabled
        public String QuestionNumber{get; set;}
         @AuraEnabled
        public String helpText{get;set;}
        public wrapperQuestions( Map<String,String> answerOptions,String Question,String QuestionNumber,String HelpText) {
            this.answerOptions = answerOptions;
            this.Question = Question;
            this.QuestionNumber = QuestionNumber;
            this.helpText = HelpText;
        }
    }
	public class wrapperAnswers {
        @AuraEnabled
        public String qsNumber{get; set;}
         @AuraEnabled
        public String question{get; set;}
         @AuraEnabled
        public String answer{get; set;}
         @AuraEnabled
        public String notes{get;set;}
        public wrapperAnswers( String qsNumber,String question,String answer,String notes) {
            this.qsNumber = qsNumber;
            this.question = question;
            this.answer = answer;
            this.notes = notes;
        }
    }
    @AuraEnabled        
    public static List<wrapperQuestions> getTopicQuestions(String TopicName){
        List<Family_Story_Guide_Questionare__c> fsgq = new List<Family_Story_Guide_Questionare__c>();
        Schema.DescribeFieldResult fieldResult = Family_Story_Guide_Questionare__c.Topic__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        fsgq = [select  id,Topic__c,hoverHelpText__c,Question__c,QuestionNumber__c,Response__c  from Family_Story_Guide_Questionare__c where Topic__c =:TopicName order by Question_Order__c];
        Map<String,Map<String,String>> optionMap = new Map<String,Map<String,String>>();
        Map<String,wrapperQuestions> questionMap = new Map<String,wrapperQuestions>();
        for(Family_Story_Guide_Questionare__c fsg:fsgq){
            if(optionMap.containsKey(fsg.QuestionNumber__c)) {
                Map<String,String> quesKey = optionMap.get(fsg.QuestionNumber__c);
                quesKey.put(fsg.Response__c,fsg.id);
                optionMap.put(fsg.QuestionNumber__c, quesKey);
            } else {
                optionMap.put(fsg.QuestionNumber__c, new Map<String,String> {fsg.Response__c => fsg.id});
            }
        }
        for(Family_Story_Guide_Questionare__c fsg:fsgq){
            questionMap.put(fsg.QuestionNumber__c,new wrapperQuestions(optionMap.get(fsg.QuestionNumber__c),fsg.Question__c,fsg.QuestionNumber__c,fsg.hoverHelpText__c));
        }
        system.debug('questionMap.values()...'+questionMap.values());
        return questionMap.values();
    }
    @AuraEnabled        
    public static List<wrapperQuestions> getDefaultTopicQuestions(){
        List<Family_Story_Guide_Questionare__c> fsgq = new List<Family_Story_Guide_Questionare__c>();
        Schema.DescribeFieldResult fieldResult = Family_Story_Guide_Questionare__c.Topic__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        fsgq = [select  id,Topic__c,hoverHelpText__c,Question__c,QuestionNumber__c,Response__c  from Family_Story_Guide_Questionare__c where Topic__c =:ple[0].getLabel() order by Question_Order__c];
        Map<String,Map<String,String>> optionMap = new Map<String,Map<String,String>>();
        Map<String,wrapperQuestions> questionMap = new Map<String,wrapperQuestions>();
        for(Family_Story_Guide_Questionare__c fsg:fsgq){
            if(optionMap.containsKey(fsg.QuestionNumber__c)) {
                Map<String,String> quesKey = optionMap.get(fsg.QuestionNumber__c);
                quesKey.put(fsg.Response__c,fsg.id);
                optionMap.put(fsg.QuestionNumber__c, quesKey);
            } else {
                optionMap.put(fsg.QuestionNumber__c, new Map<String,String> {fsg.Response__c => fsg.id});
            }
        }
        for(Family_Story_Guide_Questionare__c fsg:fsgq){
            questionMap.put(fsg.QuestionNumber__c,new wrapperQuestions(optionMap.get(fsg.QuestionNumber__c),fsg.Question__c,fsg.QuestionNumber__c,fsg.hoverHelpText__c));
        }
        return questionMap.values();
    }
    // fetch all answers....
    @AuraEnabled        
    public static list<Family_Story_Guide_Answers__c> getSavedAnswers(string fsgId){
        system.debug('getSavedAnswers-----');
        list<Family_Story_Guide_Answers__c> lstFamAnswrs = [select Family_Story_Guide__c,Name,Notes__c,Family_Story_Guide_Questionare__c,Family_Story_Guide_Questionare__r.Question__c,Family_Story_Guide_Questionare__r.Topic__c,Family_Story_Guide_Questionare__r.QuestionNumber__c,Family_Story_Guide_Questionare__r.Intervention__c,Family_Story_Guide_Questionare__r.Response__c	from Family_Story_Guide_Answers__c where Family_Story_Guide__c =: fsgId order by Family_Story_Guide_Questionare__r.Question_Order__c asc];
        return lstFamAnswrs;
    }
    // fetch all answers....
    @AuraEnabled        
    public static list<string> getSavedInterventions(string fsgId){
        system.debug('getSavedInterventions-----');
        set<string> setInterven = new set<string>();
        for(Family_Story_Guide_Answers__c famAns : [select Family_Story_Guide_Questionare__c,Family_Story_Guide_Questionare__r.Intervention__c from Family_Story_Guide_Answers__c where Family_Story_Guide__c =: fsgId order by Family_Story_Guide_Questionare__r.Question_Order__c asc]){
            if( famAns.Family_Story_Guide_Questionare__r.Intervention__c != null){
              setInterven.add(famAns.Family_Story_Guide_Questionare__r.Intervention__c);
            }
        }
        list<string> lstInterv = new list<string>();
        lstInterv.addAll(setInterven);
        return lstInterv;
    }
      
    @AuraEnabled        
    public static map<string,list<wrapperAnswers>> forNotesSection(string fsgId,list<string> lstTopics){
        //system.debug('forNotesSection-----');
        map<string,list<wrapperAnswers>> mapTopAns = new map<string,list<wrapperAnswers>>();
        //List<Family_Story_Guide_Answers__c> lstFamAnswrs = [select Family_Story_Guide__c,Notes__c,Name,Family_Story_Guide_Questionare__c,Family_Story_Guide_Questionare__r.Question__c,Family_Story_Guide_Questionare__r.Topic__c,Family_Story_Guide_Questionare__r.QuestionNumber__c,Family_Story_Guide_Questionare__r.Response__c,Family_Story_Guide_Questionare__r.Order__c	from Family_Story_Guide_Answers__c where Family_Story_Guide__c =: fsgId group by Family_Story_Guide_Questionare__r.Topic__c,Family_Story_Guide__c,Notes__c,Name,Family_Story_Guide_Questionare__c,Family_Story_Guide_Questionare__r.Question__c,Family_Story_Guide_Questionare__r.Topic__c,Family_Story_Guide_Questionare__r.QuestionNumber__c,Family_Story_Guide_Questionare__r.Response__c, Family_Story_Guide_Questionare__r.Order__c  order by Family_Story_Guide_Questionare__r.Order__c asc ];
        List<Family_Story_Guide_Answers__c> lstFamAnswrs = [select Family_Story_Guide__c,Notes__c,Name,Family_Story_Guide_Questionare__c,Family_Story_Guide_Questionare__r.Question__c,Family_Story_Guide_Questionare__r.Topic__c,Family_Story_Guide_Questionare__r.QuestionNumber__c,Family_Story_Guide_Questionare__r.Response__c,Family_Story_Guide_Questionare__r.Question_Order__c	from Family_Story_Guide_Answers__c where Family_Story_Guide__c =: fsgId 
                                                  order by Family_Story_Guide_Questionare__r.Question_Order__c asc,Family_Story_Guide_Questionare__r.Response__c asc]; //
       
        for(string curTop : lstTopics){
          if(curTop != 'Notes/Results' && ! mapTopAns.containsKey(curTop)){
                list<wrapperAnswers> lstAns = new list<wrapperAnswers>();
				string chkQsNum = '';string chkQsn = '';string chkRespons = '';string chkRNotes = ''; string isNaSel = '';
                for(Family_Story_Guide_Answers__c fAns : lstFamAnswrs){
                    
                    if(curTop == 'Social Determinants' && curTop == fAns.Family_Story_Guide_Questionare__r.Topic__c){
                        if(fAns.Family_Story_Guide_Questionare__r.Response__c != null && fAns.Family_Story_Guide_Questionare__r.Response__c.contains(')')){
						    string answ = fAns.Family_Story_Guide_Questionare__r.Response__c;
                           String[] answrs = fAns.Family_Story_Guide_Questionare__r.Response__c.split('\\)');
						   // String[] answrs = fAns.Family_Story_Guide_Questionare__r.Response__c.split(')');
                            system.debug('chkRespons---NA--------'+answrs[1] );
                            if(answrs[1].trim() == 'N/A'){
                                isNaSel = 'N/A';
                            }
                            else{
                                if(chkRespons == '')
                                    chkRespons = answrs[1];
                                else
                                    chkRespons = chkRespons+', '+answrs[1];
                            }
                            //system.debug('chkRespons---in if--------'+chkRespons);
							chkQsNum = fAns.Family_Story_Guide_Questionare__r.QuestionNumber__c;
							chkQsn = fAns.Family_Story_Guide_Questionare__r.Question__c;
							chkRNotes = fAns.Notes__c;
						}							
                    }
                    else if(curTop == fAns.Family_Story_Guide_Questionare__r.Topic__c){
                        if(fAns.Family_Story_Guide_Questionare__r.Response__c != null && fAns.Family_Story_Guide_Questionare__r.Response__c.contains(')')){
                            string answ = fAns.Family_Story_Guide_Questionare__r.Response__c;
                            String[] answrs = fAns.Family_Story_Guide_Questionare__r.Response__c.split('\\)');
							wrapperAnswers wrapAns = new wrapperAnswers(fAns.Family_Story_Guide_Questionare__r.QuestionNumber__c,fAns.Family_Story_Guide_Questionare__r.Question__c,answrs[1],fAns.Notes__c);
                            //fAns.Family_Story_Guide_Questionare__r.Response__c = answrs[1];
						    lstAns.add(wrapAns);	
                         }
                        
                    }        
               } 
			   if(curTop == 'Social Determinants'){
                   system.debug('chkRespons-----------'+chkRespons);
                 //  system.debug('chkRespons-----isNaSel------'+isNaSel);
                   if(isNaSel != ''){
                       wrapperAnswers wrapAns = new wrapperAnswers(chkQsNum,chkQsn,isNaSel,chkRNotes);
			            lstAns.add(wrapAns);
                   }
                   else{
                       wrapperAnswers wrapAns = new wrapperAnswers(chkQsNum,chkQsn,chkRespons,chkRNotes);
                       lstAns.add(wrapAns);
                   }
				  
			   }
			   mapTopAns.put(curTop,lstAns);
            }           
        }
       // system.debug('forNotesSection--mapTopAns---'+mapTopAns.size());
        return mapTopAns;
        
    }
   
@AuraEnabled        
public static void  saveDeleteAnswers(string fsgId, string newQsRecId,string oldAnswId,string curNotes,string qNum){
        /*
        system.debug('saveDeleteAnswers-----fsgId--'+fsgId);
        system.debug('saveDeleteAnswers-----newRecId--'+newQsRecId);
        system.debug('saveDeleteAnswers-----curNotes--'+curNotes);
        */
	if(curNotes != '' && curNotes != null && curNotes.length() > 32768){
        curNotes = curNotes.substring(0, 32768);
    }
    system.debug('saveDeleteAnswers-----qNum--'+qNum);
    boolean q31 = false;
    if(qNum == '3.1'){
        q31 = true;
        /* delete old answers for 3.1 */
        list<Family_Story_Guide_Answers__c> delOldQs = new list<Family_Story_Guide_Answers__c>();
        for(Family_Story_Guide_Answers__c fAns : [select id from Family_Story_Guide_Answers__c where Family_Story_Guide_Questionare__r.QuestionNumber__c = '3.1' and Family_Story_Guide__c =: fsgId]){
            delOldQs.add(fAns);
        }
        if(delOldQs.size()>0){
            delete delOldQs;
        }
        /* delete old answers 3.1 - end */
        /* insert new answers 3.1 -start */
        if(newQsRecId != null && newQsRecId != ''){
            if(newQsRecId.contains(';')){
               // system.debug('saveDeleteAnswers----111--');
                list<Family_Story_Guide_Answers__c> insNewAns = new list<Family_Story_Guide_Answers__c>();
                for(string str : newQsRecId.split(';')){
				   if(str != ''){
                    Family_Story_Guide_Answers__c answ = new Family_Story_Guide_Answers__c();
                    answ.Family_Story_Guide__c = fsgId;
                    answ.Family_Story_Guide_Questionare__c = str;
                    answ.Notes__c = curNotes;
                    insNewAns.add(answ);
					}
                }
                if(insNewAns.size()>0){
                    insert insNewAns;
                   // system.debug('saveDeleteAnswers----222--');
                }
            }
            else{
                
                Family_Story_Guide_Answers__c answ = new Family_Story_Guide_Answers__c();
                answ.Family_Story_Guide__c = fsgId;
                answ.Family_Story_Guide_Questionare__c = newQsRecId;
                answ.Notes__c = curNotes;
                insert answ;  
              //  system.debug('saveDeleteAnswers----333--');
            }   
        }
       
    }
    /* insert new answers 3.1 - end */
               
    /* for all the questions, save or update */
    if(! q31){
        if(oldAnswId == null || oldAnswId == '') 
           {
             Family_Story_Guide_Answers__c answ = new Family_Story_Guide_Answers__c();
            answ.Family_Story_Guide__c = fsgId;
            answ.Family_Story_Guide_Questionare__c = newQsRecId;
            answ.Notes__c = curNotes;
            insert answ;
        }
        else{
            Family_Story_Guide_Answers__c answ = new Family_Story_Guide_Answers__c();
            answ.id = oldAnswId;
            answ.Family_Story_Guide_Questionare__c = newQsRecId;
            answ.Notes__c = curNotes;
            update answ;
        }
    }
    /* for all the questions, save or update */
    if(! q31 && (qNum == '6.1' || qNum == '6.2' || qNum == '1.3' )){
       set<string> setSkipQs = new set<string>();
        if(qNum == '6.1' ){
           setSkipQs.add('6.1');
		   setSkipQs.add('6.1.1');
        }
        else if(qNum == '6.2' ){
           setSkipQs.add('6.2');
		   setSkipQs.add('6.2.1');
        }
        else if(qNum == '1.3' ){
           setSkipQs.add('1.3');
		   setSkipQs.add('1.3.1');
        }
		
		map<string,Family_Story_Guide_Answers__c> mapAnsw = new map<string,Family_Story_Guide_Answers__c>();
        for(Family_Story_Guide_Answers__c fAns : [select id,Family_Story_Guide_Questionare__r.Response__c,Family_Story_Guide_Questionare__r.QuestionNumber__c from  Family_Story_Guide_Answers__c where Family_Story_Guide_Questionare__r.QuestionNumber__c IN : setSkipQs and Family_Story_Guide__c =: fsgId]){
		   mapAnsw.put(fAns.Family_Story_Guide_Questionare__r.QuestionNumber__c,fAns);
		}
        if(mapAnsw.size()>0){
           
		   list<Family_Story_Guide_Answers__c> delJumpAns = new list<Family_Story_Guide_Answers__c>();
		   if(mapAnsw.containsKey('1.3') && mapAnsw.containsKey('1.3.1')){
               if( mapAnsw.get('1.3').Family_Story_Guide_Questionare__r.Response__c == 'B) No' || mapAnsw.get('1.3').Family_Story_Guide_Questionare__r.Response__c == 'E) N/A'){
			       delJumpAns.add(mapAnsw.get('1.3.1'));
               }
		   }
           if(mapAnsw.containsKey('6.1') && mapAnsw.containsKey('6.1.1')){
			   if( mapAnsw.get('6.1').Family_Story_Guide_Questionare__r.Response__c == 'B) No' || mapAnsw.get('6.1').Family_Story_Guide_Questionare__r.Response__c == 'E) N/A'){
			       delJumpAns.add(mapAnsw.get('6.1.1'));
			   }
		   }
           if(mapAnsw.containsKey('6.2') && mapAnsw.containsKey('6.2.1')){
			   if( mapAnsw.get('6.2').Family_Story_Guide_Questionare__r.Response__c == 'B) No'){
			       delJumpAns.add(mapAnsw.get('6.2.1'));
			   }
		   }
		   if(delJumpAns.size()>0){
		     delete delJumpAns;
		   }
		}
        }
   
    }
    @AuraEnabled
    public static string  getFsgStatus(string fsgId){
        string status = '';
        if(fsgId  != null){
            List<Family_Story_Guide__c> fsgRec = [SELECT ID,Status__c FROM Family_Story_Guide__c Where Id =: fsgId ];
            if(fsgRec.size()>0){
                status = fsgRec[0].Status__c ;
            }
            
        }
        return status ;
        
    }
     @AuraEnabled
    public static list<string>  getCompletedData(string fsgId){
       // system.debug('getCompletedData -------');
        set<string> setAnsw = new set<string>();
        list<string> lstTopics = new list<string>();
        for(Family_Story_Guide_Answers__c fsdgAns : [ select id,Family_Story_Guide_Questionare__r.QuestionNumber__c from Family_Story_Guide_Answers__c where Family_Story_Guide__c =: fsgId ] ) {
            setAnsw.add(fsdgAns.Family_Story_Guide_Questionare__r.QuestionNumber__c);
        }
        if(setAnsw.size()>0){
          
          map<string,string> mapTopic = new map<string,string>();
          for(Family_Story_Guide_Questionare__c fsgQs : [select id,QuestionNumber__c,Topic__c  from Family_Story_Guide_Questionare__c]){
              /*
			  if(fsgQs.QuestionNumber__c == '4.2'){
                  system.debug('getCompletedData -- qs 4.2');
                  if(setAnsw.contains(fsgQs.QuestionNumber__c)){
                      system.debug('getCompletedData -- qs 4.2-- containes true');
                  }
              }
			  */
			  
              if(setAnsw.contains(fsgQs.QuestionNumber__c) || fsgQs.QuestionNumber__c == '1.3.1' ||  fsgQs.QuestionNumber__c == '6.2.1' ||  fsgQs.QuestionNumber__c == '6.1.1'){
                 if( ! mapTopic.containsKey(fsgQs.Topic__c))  {
                       mapTopic.put(fsgQs.Topic__c,'yes');
                  }
              }
              else{
                   //system.debug('getCompletedData -nooo--topi--'+fsgQs.Topic__c+'--number---'+fsgQs.QuestionNumber__c);
				
                 mapTopic.put(fsgQs.Topic__c,'no');
              }
             
          }
            if(mapTopic.size()>0){
               
                for(string key : mapTopic.keyset()){
                    if( mapTopic.get(key) == 'yes'){
							lstTopics.add(key);
                    }
                }
            }
        }
       // system.debug('getCompletedData -completed section-- list is-----'+lstTopics);
        return lstTopics;
     }
}