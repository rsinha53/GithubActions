({
    doInit : function(component, event, helper) {
        //helper.initializeQuestionsList(component, event, helper);
        helper.getQuestionnaires(component, event, helper);
    },
    onChangeHandler : function(component, event, helper) {
        //var selecetedValue = event.getSource().get('v.value') ;
        //var selecetedOption = event.getSource().get('v.label') ;
        //var checked = event.getSource().get("v.checked");
        //var currentRowIndex = event.getSource().get("v.name");
        var currentRowIndex = event.getSource().get("v.name");
        var changeValue = event.getParam("value");
        //var cellIndex = event.currentTarget.getAttribute("data-cell-index");
        //var qValue = event.currentTarget.getAttribute("data-question");
        var paCheckQuestionnaireResult = component.get("v.paCheckQuestionnaireResult");
        var currentRow = paCheckQuestionnaireResult[currentRowIndex];
        if($A.util.isUndefinedOrNull(currentRow.optionPreValue) || $A.util.isEmpty(currentRow.optionPreValue)){
            paCheckQuestionnaireResult[currentRowIndex].optionPreValue = changeValue;
        }
        console.log("currentRow: "+JSON.stringify(currentRow));
        var questionsMap = component.get("v.questionsMap");
        console.log("questionsMap: "+JSON.stringify(component.get("v.questionsMap")));
        var questionsMaping = component.get("v.questionsMaping");
        console.log("questionsMaping: "+JSON.stringify(component.get("v.questionsMaping")));
        var sourceCode = component.get("v.sourceCode");
        
        if(!$A.util.isUndefinedOrNull(paCheckQuestionnaireResult[currentRowIndex].optionPreValue) && 
           !$A.util.isEmpty(paCheckQuestionnaireResult[currentRowIndex].optionPreValue)){
            
            var listSize = paCheckQuestionnaireResult.length;
            if(paCheckQuestionnaireResult[currentRowIndex].optionPreValue != changeValue){
                var indexNumber = currentRowIndex+1;
                var numberOfItems = (listSize - currentRowIndex) > 0 ? (listSize - currentRowIndex) : 1;
                paCheckQuestionnaireResult.splice(indexNumber,numberOfItems);
                paCheckQuestionnaireResult[currentRowIndex].optionPreValue = changeValue;
            }
        }
        
        var qMapping = questionsMaping[currentRow.seq];
        var nextAction;
        var nextActionValues;
        if(changeValue === "Yes"){
            nextAction = qMapping.ifYes;
            nextActionValues =  nextAction.split(',');
        }
        
        if(changeValue === "No"){
            nextAction = qMapping.ifNo;
            nextActionValues =  nextAction.split(',');
        }
        if(changeValue === "Radiology/Cardiology"){
            var T13REC = questionsMap["T13"];
            if(!$A.util.isUndefinedOrNull(T13REC)){
                paCheckQuestionnaireResult.push(T13REC);
            }
            var Q8REC1 = questionsMap["Q8"];            
            if(!$A.util.isUndefinedOrNull(Q8REC1)){
                Q8REC1.optionValue = "";
                paCheckQuestionnaireResult.push(Q8REC1);
            }
        }
        if(changeValue === "Oncology/Chemotherapy"){
            var T14REC = questionsMap["T14"];
            if(!$A.util.isUndefinedOrNull(T14REC)){
                paCheckQuestionnaireResult.push(T14REC);
            }
            var Q8REC2 = questionsMap["Q8"];
            if(!$A.util.isUndefinedOrNull(Q8REC2)){
                Q8REC2.optionValue = "";
                paCheckQuestionnaireResult.push(Q8REC2);
            }
        }
        if(changeValue === "Genetic/Molecular Testing"){
            var T15REC = questionsMap["T15"];
            if(!$A.util.isUndefinedOrNull(T15REC)){
                paCheckQuestionnaireResult.push(T15REC);
            }
            var Q8REC3 = questionsMap["Q8"];
            if(!$A.util.isUndefinedOrNull(Q8REC3)){
                Q8REC3.optionValue = "";
                paCheckQuestionnaireResult.push(Q8REC3);
            }
        }
        var x;
        for (x in nextActionValues) {
            var questionOrText = questionsMap[nextActionValues[x]];
            if(!$A.util.isUndefinedOrNull(questionOrText)){
                if(!$A.util.isUndefinedOrNull(questionOrText.recType) ){
                    if(questionOrText.recType === 'Question'){
                        questionOrText.optionValue = "";
                        paCheckQuestionnaireResult.push(questionOrText);
                    }
                    if(!$A.util.isUndefinedOrNull(questionOrText.seq)){
                        if(questionOrText.seq === "Q4POLICY"){
                            if(sourceCode =="CS"){
                                var Q5REC = questionsMap["Q5"];
                                if(!$A.util.isUndefinedOrNull(Q5REC)){
                                    Q5REC.optionValue = "";
                                    paCheckQuestionnaireResult.push(Q5REC);
                                }
                            }
                            if(sourceCode =="CO"){
                                var Q6REC = questionsMap["Q6"];
                                if(!$A.util.isUndefinedOrNull(Q6REC)){
                                    Q6REC.optionValue = "";
                                    paCheckQuestionnaireResult.push(Q6REC);
                                }
                            }
                        }
                        if(questionOrText.seq === "G"){
                            if(sourceCode =="CS"){
                                var G_REC = questionsMap["Q12"];
                                if(!$A.util.isUndefinedOrNull(G_REC)){
                                    G_REC.optionValue = "";
                                    paCheckQuestionnaireResult.push(G_REC);
                                }
                            }
                            if(sourceCode =="CO"){
                                var ER_REC = questionsMap["T11"];
                                if(!$A.util.isUndefinedOrNull(ER_REC)){
                                    paCheckQuestionnaireResult.push(ER_REC);
                                }
                                var ARec = questionsMap["A"];
                                if(!$A.util.isUndefinedOrNull(ARec)){
                                    ARec.optionValue = "";
                                    paCheckQuestionnaireResult.push(ARec);
                                }
                            }
                            
                        }
                    }
                    if(questionOrText.recType === 'Text'){
                        paCheckQuestionnaireResult.push(questionOrText);
                    }
                }
            }
        }
        component.set("v.paCheckQuestionnaireResult",paCheckQuestionnaireResult);
        helper.updateQuestionAuodoc(component, event, helper);
        //helper.scrollQuestionsIntoView(component, event, helper);
        setTimeout(function() {
               helper.scrollQuestionsIntoView(component, event, helper);
           }, 100);
    }
})