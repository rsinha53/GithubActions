public class ACET_QuestionnaireController {
    @AuraEnabled
    public static QuestionnairesRes getQuestionnaires(String category,String defaultQuestion){
        List<ACET_Questionnaire__mdt> questionsList = [select id,MasterLabel,DeveloperName,Category__c,If_No__c,If_Yes__c,Options__c,Type__c,Value__c
                                                       from ACET_Questionnaire__mdt where Category__c=: category];
        
        Map<String,QuestionRec> questionsMap = new Map<String,QuestionRec>();
        
        Map<String,MappingRec> questionsMapping = new Map<String,MappingRec>();
        
        Map<String,Object> responseMap = new Map<String,Object>();
        
        List<QuestionRec> paCheckQuestionnaireResult = new List<QuestionRec>();
        
        QuestionnairesRes QuestnRes = new QuestionnairesRes();
        
        for(ACET_Questionnaire__mdt ques: questionsList){
            QuestionRec rec = new QuestionRec();
            rec.seq = ques.DeveloperName;
            rec.recType = ques.Type__c;
            rec.value = ques.Value__c;
            //rec.options = ques.Options__c;
            rec.optionValue = '';
            rec.optionPreValue = '';
            if(defaultQuestion == ques.DeveloperName){
                paCheckQuestionnaireResult.add(rec);
            }
            if(ques.Type__c =='Question' && !String.isBlank(ques.Options__c)){
                system.debug('ques.Options__c: '+ques.Options__c);
                List<recOptions> optionsList = (List<recOptions>) JSON.deserialize(ques.Options__c, List<recOptions>.class);
                system.debug('optionsList: '+optionsList);
                List<recOptions> opList = new List<recOptions>();
                for(recOptions recOp: optionsList){
                    recOptions op = new recOptions();
                    op.label = recOp.label;
                    op.value = recOp.value;
                    opList.add(op);
                }
                rec.options = opList;
            }
            questionsMap.put(ques.DeveloperName,rec);
            if(!String.isBlank(ques.If_Yes__c) || !String.isBlank(ques.If_No__c)){
                MappingRec mRec = new MappingRec();
                mRec.ifYes = ques.If_Yes__c;
                mRec.ifNo = ques.If_No__c;
                questionsMapping.put(ques.DeveloperName,mRec);
            }
            
        }
        
        //responseMap.put('questionsMap',questionsMap);
        //responseMap.put('questionsMapping',questionsMapping);
        //responseMap.put('paCheckQuestionnaireResult',paCheckQuestionnaireResult);
        //responseMap.put('isSuccess',true);
        QuestnRes.questionsMap = questionsMap;
        QuestnRes.questionsMapping = questionsMapping;
        QuestnRes.paCheckQuestionnaireResult = paCheckQuestionnaireResult;
        
        return QuestnRes;
    }
    
    public class QuestionnairesRes{
        @AuraEnabled public Map<String, QuestionRec> questionsMap;
        @AuraEnabled public List<QuestionRec> paCheckQuestionnaireResult;
        @AuraEnabled public Map<String,MappingRec> questionsMapping;
    }
    
    
    public class QuestionRec{
        @AuraEnabled public String Category;
        @AuraEnabled public String seq;
        @AuraEnabled public String value;
        @AuraEnabled public String recType;
        @AuraEnabled public List<recOptions> options;
        @AuraEnabled public String optionValue;
        @AuraEnabled public String optionPreValue;
        @AuraEnabled public String ifYes;
        @AuraEnabled public String ifNo;
    }
    
    public class MappingRec{
        @AuraEnabled public String ifYes;
        @AuraEnabled public String ifNo;
    }
    
    public class recOptions{
        @AuraEnabled public String label;
        @AuraEnabled public String value;
    }
}