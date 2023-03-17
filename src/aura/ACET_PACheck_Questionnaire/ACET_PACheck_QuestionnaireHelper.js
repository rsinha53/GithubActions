({
    getQuestionnaires : function(component,event,helper) {
        
        var action = component.get("c.getQuestionnaires");
        action.setParams({
            "category": component.get("v.category"), 
            "defaultQuestion": component.get("v.defaultQuestion")
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state == 'SUCCESS') {
                var result = response.getReturnValue();
                console.log("PA Check result: "+result);
                var questionsMap = result.questionsMap;
                var questionsMapping = result.questionsMapping;
                var paCheckQuestionnaireResult = result.paCheckQuestionnaireResult;
                component.set("v.questionsMap",questionsMap);
                component.set("v.questionsMaping",questionsMapping);
                component.set("v.paCheckQuestionnaireResult",paCheckQuestionnaireResult);
            }else if(state == 'ERROR'){
                //this.fireErrorToastMessage("Unexpected Error Occurred in the Case History�card. Please try again. If problem persists please contact the help desk.");
            }
        });
        
        $A.enqueueAction(action);
    },
    
    initializeQuestionsList : function(component, event) {
        var questionsList = [
            {"seq":"Q1","value":"Is UHC Primary?","type":"Q","isQuestion":"true","options":[{"label":"Yes","value":"Yes"},{"label":"No","value":"No"}],"optionValue":"","optionPreValue":""},
            {"seq":"Q2","value":"Is the plan Delegated for Authorizations?","type":"Q","isQuestion":"true","options":[{"label":"Yes","value":"Yes"},{"label":"No","value":"No"}],"optionValue":"","optionPreValue":""},
            {"seq":"Q3","value":"Does a code(s) show Blocked in the UHC Pripr Auth Req'd field","type":"Q","isQuestion":"true","options":[{"label":"Yes","value":"Yes"},{"label":"No","value":"No"}],"optionValue":"","optionPreValue":""},
            {"seq":"Q4","value":"Is the Code for Radiology/Cardiology/Oncology/Chemotherapy, or Genetic/Molecular testing ?","type":"Q","isQuestion":"true","options":[{"label":"Yes","value":"Yes"},{"label":"No","value":"No"}],"options":[{"label":"Yes","value":"Yes"},{"label":"No","value":"No"}],"optionValue":"","optionPreValue":""},
            {"seq":"Q5","value":"Based on the type of Code,is the Corresponding Med Nec Indicator Yes or No?","type":"Q","isQuestion":"true","options":[{"label":"Yes","value":"Yes"},{"label":"No","value":"No"}],"options":[{"label":"Yes","value":"Yes"},{"label":"No","value":"No"}],"optionValue":"","optionPreValue":""},
            {"seq":"Q6","value":"Select Service Types","type":"Q","isQuestion":"true","options":[{"label":"Radiology/Cardiology","value":"Radiology/Cardiology"},{"label":"Oncology/Chemotherapy","value":"Oncology/Chemotherapy"},{"label":"Genetic/Molecular Testing","value":"Genetic/Molecular Testing"}],"optionValue":"","optionPreValue":""},
            {"seq":"Q7","value":"Based on the criteria listed, is Authorization required ?","type":"Q","isQuestion":"true","options":[{"label":"Yes","value":"Yes"},{"label":"No","value":"No"}],"options":[{"label":"Yes","value":"Yes"},{"label":"No","value":"No"}],"optionValue":"","optionPreValue":""},
            {"seq":"Q7a","value":"Based on the criteria listed, is Authorization required ?","type":"Q","isQuestion":"true","options":[{"label":"Yes","value":"Yes"},{"label":"No","value":"No"}],"options":[{"label":"Yes","value":"Yes"},{"label":"No","value":"No"}],"optionValue":"","optionPreValue":""},
            {"seq":"Q7b","value":"Based on the criteria listed, is Authorization required ?","type":"Q","isQuestion":"true","options":[{"label":"Yes","value":"Yes"},{"label":"No","value":"No"}],"options":[{"label":"Yes","value":"Yes"},{"label":"No","value":"No"}],"optionValue":"","optionPreValue":""},
            {"seq":"Q7c","value":"Based on the criteria listed, is Authorization required ?","type":"Q","isQuestion":"true","options":[{"label":"Yes","value":"Yes"},{"label":"No","value":"No"}],"options":[{"label":"Yes","value":"Yes"},{"label":"No","value":"No"}],"optionValue":"","optionPreValue":""},
            {"seq":"Q8","value":"Do you need to check code(s) with another status?","type":"Q","isQuestion":"true","options":[{"label":"Yes","value":"Yes"},{"label":"No","value":"No"}],"options":[{"label":"Yes","value":"Yes"},{"label":"No","value":"No"}],"optionValue":"","optionPreValue":""},
            {"seq":"Q8a","value":"Do you need to check code(s) with another status?","type":"Q","isQuestion":"true","options":[{"label":"Yes","value":"Yes"},{"label":"No","value":"No"}],"options":[{"label":"Yes","value":"Yes"},{"label":"No","value":"No"}],"optionValue":"","optionPreValue":""},
            {"seq":"Q8b","value":"Do you need to check code(s) with another status?","type":"Q","isQuestion":"true","options":[{"label":"Yes","value":"Yes"},{"label":"No","value":"No"}],"options":[{"label":"Yes","value":"Yes"},{"label":"No","value":"No"}],"optionValue":"","optionPreValue":""},
            {"seq":"Q8c","value":"Do you need to check code(s) with another status?","type":"Q","isQuestion":"true","options":[{"label":"Yes","value":"Yes"},{"label":"No","value":"No"}],"options":[{"label":"Yes","value":"Yes"},{"label":"No","value":"No"}],"optionValue":"","optionPreValue":""},
            {"seq":"Q8d","value":"Do you need to check code(s) with another status?","type":"Q","isQuestion":"true","options":[{"label":"Yes","value":"Yes"},{"label":"No","value":"No"}],"options":[{"label":"Yes","value":"Yes"},{"label":"No","value":"No"}],"optionValue":"","optionPreValue":""},
            {"seq":"Q8e","value":"Do you need to check code(s) with another status?","type":"Q","isQuestion":"true","options":[{"label":"Yes","value":"Yes"},{"label":"No","value":"No"}],"options":[{"label":"Yes","value":"Yes"},{"label":"No","value":"No"}],"optionValue":"","optionPreValue":""},
            {"seq":"Q8f","value":"Do you need to check code(s) with another status?","type":"Q","isQuestion":"true","options":[{"label":"Yes","value":"Yes"},{"label":"No","value":"No"}],"options":[{"label":"Yes","value":"Yes"},{"label":"No","value":"No"}],"optionValue":"","optionPreValue":""},
            {"seq":"Q8g","value":"Do you need to check code(s) with another status?","type":"Q","isQuestion":"true","options":[{"label":"Yes","value":"Yes"},{"label":"No","value":"No"}],"options":[{"label":"Yes","value":"Yes"},{"label":"No","value":"No"}],"optionValue":"","optionPreValue":""},
            {"seq":"Q9","value":"Does a code(s) show May be Blocked - Conditionally in the UHC Prior Auth Req'd field.","type":"Q","isQuestion":"true","options":[{"label":"Yes","value":"Yes"},{"label":"No","value":"No"}],"options":[{"label":"Yes","value":"Yes"},{"label":"No","value":"No"}],"optionValue":"","optionPreValue":""},
            {"seq":"Q10","value":"Does a code(s) show Yes in the UHC Prior Auth Req'd field.","type":"Q","isQuestion":"true","options":[{"label":"Yes","value":"Yes"},{"label":"No","value":"No"}],"options":[{"label":"Yes","value":"Yes"},{"label":"No","value":"No"}],"optionValue":"","optionPreValue":""},
            {"seq":"Q11","value":"Does a code(s) show Prior Auth May Be Required in the UCH Prior Auth Req'd field","type":"Q","isQuestion":"true","options":[{"label":"Yes","value":"Yes"},{"label":"No","value":"No"}],"options":[{"label":"Yes","value":"Yes"},{"label":"No","value":"No"}],"optionValue":"","optionPreValue":""},
            {"seq":"Q12","value":"Are any codes for PT, OT, and/or Chiropractic?","type":"Q","isQuestion":"true","options":[{"label":"Yes","value":"Yes"},{"label":"No","value":"No"}],"options":[{"label":"Yes","value":"Yes"},{"label":"No","value":"No"}],"optionValue":"","optionPreValue":""},
            {"seq":"Q13","value":"Does the OptumHealth Auth Req'd field show contact Optum health for PT, OT, and Chiro?","type":"Q","isQuestion":"true","options":[{"label":"Yes","value":"Yes"},{"label":"No","value":"No"}],"options":[{"label":"Yes","value":"Yes"},{"label":"No","value":"No"}],"optionValue":"","optionPreValue":""},
            {"seq":"A","value":"Advise caller No Authorization is Required.","type":"T","isText":"true"},
            {"seq":"B","value":"Follow your standard processes for transferring the call.","type":"T","isText":"true"},
            {"seq":"C","value":"Does a code(s) show Maybe Blocked Conditionally in the UHC Prior Auth Req Req’d field","type":"Q","isQuestion":"true","options":[{"label":"Yes","value":"Yes"},{"label":"No","value":"No"}],"optionValue":"","optionPreValue":""},
            {"seq":"D","value":"Does a code(s) show Yes in the UHC Prior Auth Req'd field.","type":"Q","isQuestion":"true","options":[{"label":"Yes","value":"Yes"},{"label":"No","value":"No"}],"optionValue":"","optionPreValue":""},
            {"seq":"E","value":"Assist the caller with any additional needs.","type":"T","isText":"true"},
            {"seq":"F","value":"Does a code(s) show Prior Auth May Be Required in the UCH Prior Auth Req'd field","type":"Q","isQuestion":"true","options":[{"label":"Yes","value":"Yes"},{"label":"No","value":"No"}],"optionValue":"","optionPreValue":""},
            {"seq":"G","value":"GPolicy","type":"C"},
            {"seq":"T1","value":"Advise caller that Authorizations are handled by the Delegation.","type":"T","isText":"true"},
            {"seq":"T2","value":"Review the Decision Summary field for additional instructions and/or criteria.","type":"T","isText":"true"},
            {"seq":"T3","value":"Advise caller that authorization is not required for this code(s)","type":"T","isText":"true"},
            {"seq":"T4","value":"Advise caller that authorization is required and provide applicable next steps.","type":"T","isText":"true"},
            {"seq":"T5","value":"Review the Decision Summary and Conditional Details field(s) for additional instructions and/or criteria.","type":"T","isText":"true"},
            {"seq":"T6","value":"Advise caller that authorization is required. Select the Create Auth button in the View Authorization to follow your standard case creation process once all requirements have been given.","type":"T","isText":"true"},
            {"seq":"T7","value":"Advise caller that authorization is required. Select the Create Auth button in the View Authorization to follow your standard case creation process once all requirements have been given.","type":"T","isText":"true"},
            {"seq":"T8","value":"Review the Decision Summary and Conditional Details field(s) for additional instructions and/or criteria.","type":"T","isText":"true"},
            {"seq":"T9","value":"Assist the caller with any additional needs.","type":"T","isText":"true"},
            {"seq":"T10","value":"Advise caller that authorization is required. Select the Create Auth button in the View Authorization to follow your standard case creation process once all requirements have been given.","type":"T","isText":"true"},
            {"seq":"T11","value":"Any remaining codes should show that No Authorization is required. If you have other statuses, review previous selections above.","type":"T","isText":"true"},
            {"seq":"T12","value":"Advise caller to contact OptumHealth for Authorization.","type":"T","isText":"true"},
            {"seq":"T13","value":"Advise caller that authorization is required. Advise to submit online at uhcprovider.com or contact Evicore at 866-889-8054.","type":"T","isText":"true"},
            {"seq":"T14","value":"Advise caller that authorization is required. Advise to submit online at uhcprovider.com or contact Optum at 888-397-8129.","type":"T","isText":"true"},
            {"seq":"T15","value":"Advise caller that authorization is required. Advise to submit online at uhcprovider.com or transfer to 877-303-7736.","type":"T","isText":"true"},
            {"seq":"Q4POLICY","value":"Advise caller to contact OptumHealth for Authorization.","type":"T","isPolicyCheck":"true"}
        ];
        
        component.set("v.paCheckQuestionsList",questionsList);
        console.log("paCheckQuestionsList: "+JSON.stringify(component.get("v.paCheckQuestionsList")));
        
        /****************/
        var questionsMap = {};
        
        var i;
        for (i = 0; i < questionsList.length; i++) {
            questionsMap[questionsList[i].seq]= questionsList[i];
        }
        //console.log("questionsMap: "+JSON.stringify(questionsMap)); [{"label":"Yes","value":"Yes"},"label":"No","value":"No"}]
        /****************************/
        
        
        component.set("v.questionsMap",questionsMap);
        console.log("questionsMap: "+JSON.stringify(component.get("v.questionsMap")));
        
        var questionsMappings = {};
        
        questionsMappings["Q1"] = this.createMappingsObj(component, event,"","Q2","A");
        questionsMappings["Q2"] = this.createMappingsObj(component, event,"Q1-Y","T1,B","Q3");
        questionsMappings["Q3"] = this.createMappingsObj(component, event,"Q2-N","T2,Q4","C");
        questionsMappings["Q4"] = this.createMappingsObj(component, event,"Q3-Y","Q4POLICY","Q7");
        questionsMappings["Q4POLICY"] = this.createMappingsObj(component, event,"Q4-Y","E&I-Q5","M&R-Q6");
        questionsMappings["Q4POLICYEIMR"] = this.createMappingsObj(component, event,"Q4-Y-EI","Q5","Q6");
        questionsMappings["Q5"] = this.createMappingsObj(component, event,"Q4POLICY","Q6","A");
        questionsMappings["Q6"] = this.createMappingsObj(component, event,"Q5,Q4POLICY","Q6","A");
        questionsMappings["Q7"] = this.createMappingsObj(component, event,"Q4-N","T4,Q8","T3,Q8a");
        questionsMappings["Q8"] = this.createMappingsObj(component, event,"Q7-Y","C","B");
        questionsMappings["Q8a"] = this.createMappingsObj(component, event,"Q7-N","C","A");
        //questionsMappings["Q8a"] = this.createMappingsObj(component, event,"Q7-N","C","A");
        questionsMappings["C"] = this.createMappingsObj(component, event,"Q8-Y","T5,Q7a","D");
        questionsMappings["Q7a"] = this.createMappingsObj(component, event,"C-Y","T6,Q8b","Q8c");
        questionsMappings["Q8b"] = this.createMappingsObj(component, event,"Q7a-Y","D","E");
        questionsMappings["Q8c"] = this.createMappingsObj(component, event,"Q8b-Y","D","A");
        questionsMappings["D"] = this.createMappingsObj(component, event,"","T7,Q8d","F");
        questionsMappings["Q8d"] = this.createMappingsObj(component, event,"D-Y","F","E");
        questionsMappings["F"] = this.createMappingsObj(component, event,"","T8,Q7b","G");
        questionsMappings["Q7b"] = this.createMappingsObj(component, event,"F-Y","T10,Q8f","Q8e");
        questionsMappings["Q8e"] = this.createMappingsObj(component, event,"Q7b-N","G","A");
        questionsMappings["Q8f"] = this.createMappingsObj(component, event,"Q7b-Y","G","E");
        questionsMappings["G"] = this.createMappingsObj(component, event,"","T11,A","Q12");
        questionsMappings["Q12"] = this.createMappingsObj(component, event,"G","Q13","A");
        questionsMappings["Q13"] = this.createMappingsObj(component, event,"Q12-Y","T12,B","A");
        //var testMap = questionsMappings;
        //console.log("questionsMappings: "+questionsMappings);
        //console.log("testMap: "+testMap);
        component.set('v.questionsMaping',questionsMappings);
        console.log("questionsMaping: "+JSON.stringify(component.get("v.questionsMaping")));
        var qListToDisplay = [questionsList[0]];
        //qListToDisplay.push(questionsList[0]); 
        //qListToDisplay.push(questionsList[1]); 
        //qListToDisplay.push(questionsList[2]); 
        component.set("v.paCheckQuestionnaireResult",qListToDisplay);
        console.log("paCheckQuestionnaireResult: "+JSON.stringify(component.get("v.paCheckQuestionnaireResult")));
        
        
        
    },
    createMappingsObj : function(component, event,pre,ifYes,ifNo) {
        var mappingsObj = {
            "previousQ": pre,
            "ifYes":ifYes,
            "ifNo": ifNo
        };
        return mappingsObj;
    },
    updateQuestionAuodoc: function (component, event) {
        
        var autodocCmp = _autodoc.getAutodocComponent(component.get("v.autodocUniqueId"), component.get("v.autodocUniqueIdCmp"), 'Benefit/PA Check');
        var sCode = component.get("v.sourceCode");
        if (!$A.util.isUndefinedOrNull(autodocCmp)) {
            
            var questionList = [];
            
            var paCheckQuestionnaireResult = component.get("v.paCheckQuestionnaireResult");
            
            var i;
            for (i = 0; i < paCheckQuestionnaireResult.length; i++) {
                if(!$A.util.isUndefinedOrNull(paCheckQuestionnaireResult[i].recType)){
                    if(paCheckQuestionnaireResult[i].recType ==="Question"){
                        questionList.push(new fieldDetails(true, 'slds-size_2-of-2', paCheckQuestionnaireResult[i].value, paCheckQuestionnaireResult[i].optionValue)); 
                    }
                    if(paCheckQuestionnaireResult[i].recType ==="Text"){
                        questionList.push(new fieldDetails(true, 'slds-size_2-of-2', paCheckQuestionnaireResult[i].value, "")); 
                    }
                    
                }
            }
            
            autodocCmp.additionalSectionData = questionList;
            autodocCmp.caseItemsExtId = 'PA Check';
            
            _autodoc.setAutodoc(component.get("v.autodocUniqueId"), component.get("v.autodocUniqueIdCmp"), autodocCmp);
            
        }
        
        var autodocCmp = _autodoc.getAutodocComponent(component.get("v.autodocUniqueId"), component.get("v.autodocUniqueIdCmp"), 'Authorization Results' + component.get('v.paCheckTabId'));
        
        function fieldDetails(c, nc, fn, fv) {
            this.checked = c;
            this.noOfColumns = nc;
            this.fieldName = fn;
            this.fieldValue = fv;
            this.isReportable = true;
        }
    },
    scrollQuestionsIntoView : function(component,event,helper) {
        var elementId = component.find("questionsId")
        if (!$A.util.isUndefinedOrNull(elementId)) {
            elementId.getElement().scrollIntoView({
                behavior: 'smooth',
                block: 'start',
                inline: 'end'
            });
        }
    }
})