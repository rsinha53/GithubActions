({
    callIcueMemberId : function(component, event, helper){
        var sourceMemberID = component.get("v.memberXrefId");
        // sourceMemberID='31460306';
        if(sourceMemberID == '')
            console.log('Atleast one attribute is blank so skipped callout');
        else{
            var action = component.get("c.fetchGetIcueMemberIdService");
            action.setParams({sourceMemberID : sourceMemberID});
            action.setCallback(this,function(response){
                var state = response.getState();
                console.log('State value for callGetIcueMemberIdService'+state);
                if (state === "SUCCESS") {
                    var results = response.getReturnValue();
                    if(!$A.util.isEmpty(results) && !$A.util.isUndefined(results)){
                        if(!$A.util.isEmpty(results.icueMemberId) && !$A.util.isUndefined(results.icueMemberId)){
                            component.set("v.icueMemberId", results.icueMemberId);
                        }
                        else if(!$A.util.isEmpty(results.icueMemIdMessage) && !$A.util.isUndefined(results.icueMemIdMessage)){
                            component.set("v.icueMembIdMessage", results.icueMemIdMessage);
                            component.set("v.isButtonActive", true);
                        }
                    }
                }
            });
            $A.enqueueAction(action);
        }
    },
    callSearchTemplateListService : function(component, event, helper){
        component.set("v.showSpinner", true);
        var action = component.get("c.fetchSearchTemplateListService");
        action.setParams({});
        action.setCallback(this,function(response){
            var state = response.getState();
            console.log('State value for callSearchTemplateListService'+state);
            if (state === "SUCCESS") {
                var results = response.getReturnValue();
                console.log('response for callSearchTemplateListService'+results);
                if(!$A.util.isEmpty(results) && !$A.util.isUndefined(results)){
                    if(!$A.util.isEmpty(results.templateId) && !$A.util.isUndefined(results.templateId)){
                        component.set("v.templateId", results.templateId);
                        helper.callGetTemplateByIdService(component, event, helper);
                    }
                    else if(!$A.util.isEmpty(results.errorMessage) && !$A.util.isUndefined(results.errorMessage)){
                        component.set("v.availableErrorMessage", results.errorMessage); 
                    }
                }
            }
        });
        $A.enqueueAction(action);
    },
    callGetTemplateByIdService : function(component, event, helper){
        var templateId = component.get("v.templateId");
        var action = component.get("c.fetchGetTemplateByIdService");
        action.setParams({templateId : templateId});
        action.setCallback(this,function(response){
            var state = response.getState();
            console.log('State value for callGetTemplateByIdService'+state);
            if (state === "SUCCESS") {
                var results = response.getReturnValue();
                if(!$A.util.isEmpty(results) && !$A.util.isUndefined(results)){
                    if(!$A.util.isEmpty(results.availableList) && !$A.util.isUndefined(results.availableList) && 
                       !$A.util.isEmpty(results.modalList) && !$A.util.isUndefined(results.modalList)){
                        component.set("v.availableChecklists", results.availableList);
                        component.set("v.modalChecklists", results.modalList);
                        
                        //	capturing request params for the first time saving flow
                        
                        console.log('builder assessment ID on load'+ results.builderAssessmentId);
                        component.set("v.builderAssessmentId", results.builderAssessmentId);
                        component.set("v.builderAssessmentVersionNumber", results.builderAssessmentVersionNumber);
                        component.set("v.assessmentTemplateID", results.assessmentTemplateID);
                        console.log('assessmentTemplateID : ', component.get("v.assessmentTemplateID"));
                    }
                    else if(!$A.util.isEmpty(results.errorMessage) && !$A.util.isUndefined(results.errorMessage)){
                        console.log('error message :::'+ results.errorMessage);
                        component.set("v.availableErrorMessage", results.errorMessage); 
                    }
                    else if($A.util.isEmpty(results.availableList) && $A.util.isUndefined(results.availableList)){
                            component.set("v.isInfoAvailableMessage", true);
                            component.set("v.availableErrorMessage", $A.get("$Label.c.ADB_CETNoAvailableChecklistMessage")); 
                    }
                }
            }
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },
    callSearchAssessmentListService : function(component, event, helper, isAvailableCL){
        if(isAvailableCL == 1) {	//if this is called from available checklist section
            var rectarget = event.currentTarget;
            var tasklabel = rectarget.getAttribute("data-conId");
            component.set("v.taskLabel", tasklabel);
        }
        var icueMemberId = component.get("v.icueMemberId");
        var assessmentTemplateID = component.get("v.assessmentTemplateID");
        var builderAssessmentID = component.get("v.builderAssessmentId");
        var builderAssessmentVersionNumber = component.get("v.builderAssessmentVersionNumber");
        component.set("v.showSpinner", true);
        var action = component.get("c.fetchSearchAssessmentListService");
        action.setParams({icueMemberId : icueMemberId,
                          assessmentTemplateID : assessmentTemplateID,
                          builderAssessmentID: builderAssessmentID,
                          builderAssessmentVersionNumber: builderAssessmentVersionNumber});
        action.setCallback(this,function(response){
            var state = response.getState();
            console.log('State value for SearchAssessmentListService '+JSON.stringify(response.getReturnValue()));
            if (state === "SUCCESS") {
                var results = response.getReturnValue();
                if(!$A.util.isEmpty(results) && !$A.util.isUndefined(results)){
                    if(!$A.util.isEmpty(results.assessmentID) && !$A.util.isUndefined(results.assessmentID)){
                        component.set("v.assessmentID", results.assessmentID);
                        helper.callGetAssessmentByIdService(component, event, helper, isAvailableCL);
                    }
                    if(!$A.util.isEmpty(results.errorMessage) && !$A.util.isUndefined(results.errorMessage)){
                        console.log('Error message completed'+ results.errorMessage);
                        if(results.errorMessage!='Conducted Assessments not found'){
                            component.set("v.popupCompErrorMessage", results.errorMessage);
                            component.set("v.isButtonActive", true);
                        }else{
                            console.log('error message inside complete'+ results.errorMessage);
                            component.set("v.completedErrorMessage", results.errorMessage);
                            if(isAvailableCL == 1) {	//if this is called from available checklist section
                                component.set("v.completedErrorMessage", '');
                                var keyName = component.get("v.taskLabel");
                                helper.setPopups(component, event, helper, keyName);
                                var saveRequestParams = {};
                                var builderAssessment = component.get("v.builderAssessmentId");
                                var builderVersion = component.get("v.builderAssessmentVersionNumber");
                                var templateId = component.get("v.assessmentTemplateID");
                                console.log('assessmentTemplateID '+ templateId);
                                saveRequestParams = {   "conductedByUserID": component.get("v.agentMSID"),
                                                     "conductedByUserName": component.get("v.agentMSID"),
                                                     "conductedByUserRoleText": "ACET Advocate Agent",
                                                     "changeUserName": component.get("v.agentMSID"),
                                                     "changeUserRoleText": "ACET Advocate Agent",
                                                     "assessmentTemplateID": templateId,
                                                     "totalScoreNumber": '0.0',
                                                     "assessmentStatusTypeID": '1',
                                                     "assessmentStatusReasonTypeID": "",
                                                     "deliveryMethodTypeID": '0',
                                                     "builderAssessmentID": builderAssessment,
                                                     "builderAssessmentVersionNumber": builderVersion,
                                                     "parentAssessmentID": '0',
                                                     "totalAvgQuestScore": '0',
                                                     "assessmentID" : '0',
                                                     "userID" : component.get("v.agentMSID"),
                                                     "sourceApplicationSubjectID" : component.get("v.icueMemberId"),
                                                     "completedCheckList" : component.get("v.completedChecklists")
                                                    };
                                console.log('saveRequestParams'+ JSON.stringify(saveRequestParams));
                                component.set("v.saveRequestDetails", saveRequestParams);
                            }
                        }
                    }
                }
            }
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },
    callGetAssessmentByIdService : function(component, event, helper, isAvailableCL){
        component.set("v.showSpinner", true);
        var assessment_Id = component.get("v.assessmentID");	//'297016'
        console.log('completed tasks $$$$$$$'+ assessment_Id);
        var saveRequestParams = {};        
        var action = component.get("c.fetchGetAssessmentByIdService");
        action.setParams({assessment_Id : assessment_Id});
        action.setCallback(this,function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var results = response.getReturnValue();
                if(!$A.util.isEmpty(results) && !$A.util.isUndefined(results)){
                    if(!$A.util.isEmpty(results.completedTasks) && !$A.util.isUndefined(results.completedTasks)){
                        component.set("v.completedChecklists", results.completedTasks);
                        console.log('completed tasks $$$$$$$'+ results.completedTasks);
                    }else if(component.get("v.showExistingChecklists") && $A.util.isEmpty(results.completedTasks) && $A.util.isUndefined(results.completedTasks)){
                        component.set("v.isInfoExistingMessage", true);
                        component.set("v.completedErrorMessage", $A.get("$Label.c.ADB_CETNoExistingChecklistMessage"));
                    }else if(!$A.util.isEmpty(results.errorMessage) && !$A.util.isUndefined(results.errorMessage)){
                        component.set("v.popupCompErrorMessage", results.errorMessage);
                        component.set("v.isButtonActive", true);
                    }
                    if(!$A.util.isEmpty(results.updatedDate) && !$A.util.isUndefined(results.updatedDate)){
                        var dateParts = results.updatedDate.split(' ')[0].split('-');
                        if(!$A.util.isEmpty(dateParts)) {
                            var lastUpdated = dateParts[0] + '/' + dateParts[1] + '/' + dateParts[2];
                        }
                        component.set("v.lastUpdated", lastUpdated);
                    }
                    if(!$A.util.isEmpty(results.updatedBy) && !$A.util.isUndefined(results.updatedBy)){
                        var name = results.updatedBy;
                        if(name.includes(",")) {
                            var nameParts = name.split(",");
                            name = nameParts[1] + ' ' + nameParts[0].charAt(0);
                        }
                        component.set("v.updatedBy", name);
                    }
                    saveRequestParams = {   "conductedByUserID": component.get("v.agentMSID"),//results.conductedByUserID,
                                         "conductedByUserName": component.get("v.agentMSID"),//results.updatedBy,
                                         "conductedByUserRoleText": "ACET Advocate Agent",//results.conductedByUserRoleText,
                                         "changeUserName": component.get("v.agentMSID"),//results.changeUserName,
                                         "changeUserRoleText": "ACET Advocate Agent",//results.changeUserRoleText,
                                         "assessmentTemplateID": results.assessmentTemplateID,
                                         "totalScoreNumber": results.totalScoreNumber,
                                         "assessmentStatusTypeID": results.assessmentStatusTypeID,
                                         "assessmentStatusReasonTypeID": results.assessmentStatusReasonTypeID,
                                         "deliveryMethodTypeID": results.deliveryMethodTypeID,
                                         "builderAssessmentID": results.builderAssessmentID,
                                         "builderAssessmentVersionNumber": results.builderAssessmentVersionNumber,
                                         "parentAssessmentID": results.parentAssessmentID,
                                         "totalAvgQuestScore": results.totalAvgQuestScore,
                                         "assessmentID" : assessment_Id,
                                         "userID" : component.get("v.agentMSID"),	//	"hrachako"
                                         "sourceApplicationSubjectID" : component.get("v.icueMemberId"),
                                         "completedCheckList" : component.get("v.completedChecklists")
                                        };
                    console.log('assessmenttemplateID get assesment ID'+ JSON.stringify(results.assessmentTemplateID));
                    console.log('saveRequestParams get assesment ID'+ JSON.stringify(saveRequestParams));
                    component.set("v.saveRequestDetails", saveRequestParams);
                    helper.buildExistingChecklist(component, event, helper);
                    if(isAvailableCL == 1){
                        var keyName = component.get("v.taskLabel");
                        helper.setPopups(component, event, helper, keyName);
                    }
                }
            }
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },
    buildExistingChecklist : function(component, event, helper){
        var completedChecklist = component.get("v.completedChecklists");
        var availableChecklists = component.get("v.availableChecklists"); 
        var modalList = component.get("v.modalChecklists");
        var existingList = [];
        var tasksTotalCount = 0;
        for(var key1 in modalList){
            var choiceLength = parseInt(modalList[key1].length);
            tasksTotalCount+=choiceLength;
        }
        for(var questionID in completedChecklist){
            for(var i in availableChecklists){
                if(completedChecklist[questionID].questionID == availableChecklists[i].questionID && 
                   !existingList.includes(availableChecklists[i].promptText)) {
                    existingList.push(availableChecklists[i].promptText);
                    break;
                }
            }
        }
        if($A.util.isEmpty(existingList) && component.get("v.showExistingChecklists")){
            component.set("v.isInfoExistingMessage", true);
            component.set("v.completedErrorMessage", $A.get("$Label.c.ADB_CETNoExistingChecklistMessage"));
        }
        component.set("v.existingChecklist", existingList);
        component.set("v.totalnoofChoices", tasksTotalCount);
    },
    setPopups : function(component, event, helper, keyName){
        var modalList = component.get("v.modalChecklists")[keyName];
        var completedTasks = component.get("v.completedChecklists");
        var newChecklistCombined = [];
        var completedCount = 0;
        for(var x in modalList ) {
            modalList[x].isNew = true;	// to avoid adding already completed choices again to save api
            if(!$A.util.isEmpty(completedTasks)) {
                for(var y in completedTasks) {
                    if(modalList[x].questionID == completedTasks[y].questionID && 
                       modalList[x].choiceID == completedTasks[y].choiceID) {
                        modalList[x].completed = true;
                        modalList[x].isNew = false;
                        completedCount++;
                        break;
                    }                
                }
            }
            newChecklistCombined.push(modalList[x]);
        }

        component.set("v.completedTasks", completedCount);
        var totalTasks = modalList.length;
        component.set("v.totalTasks", totalTasks);
        component.set("v.popUpTasks", newChecklistCombined);
        
        if(completedCount > 0){
            component.set("v.showExistingModal", true);            
        }
        component.set("v.showChecklistModal", true);
    },
    
    callSaveService : function(component, event, helper){
        component.set("v.showPopupSpinner", true);
        var completedTasks = component.get("v.completedChecklists");
        var totalChoices = component.get("v.totalnoofChoices");
        if($A.util.isEmpty(completedTasks)) {
            completedTasks = [];
        }
        //	collecting newly completed choices in the session
        var currPopupChoices = component.get("v.popUpTasks");
        currPopupChoices.forEach(function(currChoice, i){
            if(currChoice.completed == true && currChoice.isNew == true) {
                var newChoice = {};
                newChoice.choiceID = currChoice.choiceID;
                newChoice.questionID = currChoice.questionID;
                newChoice.choiceText = currChoice.choiceText;
                completedTasks.push(newChoice);
            }
        });
        var assessment_Id = component.get("v.assessmentID");
        var saveRequestDetails = component.get("v.saveRequestDetails");
        saveRequestDetails.completedCheckList = completedTasks;
        console.log('saveRequestDetails'+JSON.stringify(saveRequestDetails));
        
        var action = component.get("c.fetchSaveService");
        action.setParams({saveRequestDetails : JSON.stringify(saveRequestDetails),
                          totalChoices : totalChoices});
        action.setCallback(this,function(response){
            var state = response.getState();
            console.log('State value for callSaveService'+JSON.stringify(response.getError()));
            if (state === "SUCCESS") {
                var results = response.getReturnValue();
                if(!$A.util.isEmpty(results) && !$A.util.isUndefined(results)){
                    if(results == 'SUCCESS') {
                        //	Collapsing Existing checklist and closing popup
                        component.set("v.saveFailed", false);
                        component.set("v.showExistingChecklists", true);
                        component.set("v.showChecklistModal", false);
                        component.set("v.showExistingModal", false);
                    }
                    else{
                        component.set("v.saveFailed", true);
                        component.set("v.saveErrorMessage", results);
                    }
                }
            }
            component.set("v.showPopupSpinner", false);
        });
        $A.enqueueAction(action);
    },
})