({
    doInit : function(component, event, helper) {
        //US3150996 Non FedEx changes
        var notEligbileForChecklist;
        var policy = component.get("v.policy");
        if(policy == $A.get("$Label.c.ADBFedexPolicy")){
            notEligbileForChecklist = false;
            helper.callSearchTemplateListService(component, event, helper);
            helper.callIcueMemberId(component, event, helper);
        }else
            notEligbileForChecklist = true;
       component.set("v.notEligbileForChecklist", notEligbileForChecklist);
    },
    // Show existing checklists Card
    showCard : function(component, event, helper) {
        helper.callSearchAssessmentListService(component, event, helper, 0);
        component.set("v.showExistingChecklists", false);
    },
    // Hide existing checklists Card
    hideCard : function(component, event, helper) {
        component.set("v.showExistingChecklists", true);
    },
    // Show available checklists modal
    showAvailableModal : function(component, event, helper) {
        helper.callSearchAssessmentListService(component, event, helper, 1); 
    },
    closeModal : function(component, event, helper) {
        component.set("v.showChecklistModal", false);
        component.set("v.showExistingModal", false);
		var checklistbox = component.find("checklistbox");
        if(checklistbox && !checklistbox.length) {
            checklistbox = [checklistbox];
        }
        if(checklistbox) {
            // Uncheck all boxes //
            checklistbox.forEach(function(cmp){
                cmp.set("v.value", false);
            });
        }
    },
    
    //	open the checklist popup for the given category from existing checklist section
    openExistingDetail : function(component, event, helper) { 
        var keyName = event.getSource().get("v.name");
        component.set("v.taskLabel", keyName);
        component.set("v.showExistingModal", true);
        helper.setPopups(component, event, helper, keyName);
    },
    handleCheckbox : function(component, event, helper) {
        console.log('if this is odfddffffffffffffffff')
        var checkbox = event.getSource();
        console.log('check questionID'+checkbox.get("v.name"));
        var choiceID = checkbox.get("v.name");
        var popupsList = component.get("v.popUpTasks")[choiceID];
        component.set("v.saveRequestChoiceList", popupsList);
    },
    sendServiceDetails : function(component, event, helper) {
        helper.callSaveService(component, event, helper);
    },
})