({
    doInit : function(component, event, helper) {
        // var tabledata = [];
        // var item1 = new Object();
        // item1.User = 'Sanka Dharmasena';
        // item1.isPublic = false;
        // item1.CreatedDate = '5/25/2020 12:28 AM';
        // item1.CommentValue = 'Sample Comment with dummy data.';
        // tabledata.push(item1);
        // component.set('v.tableData',tabledata);
        helper.getCaseComments(component, event, helper);
    },

    columnOptionsChange: function(component) {
        var selectedColumn = component.get('v.selectedColumn');
        var selectedOption = component.get('v.selectedOption');
        var columnOptions = component.get('v.columnOptions');
        columnOptions[selectedColumn] = selectedOption;
        component.set('v.columnOptions', columnOptions);
    },

    onRefresh : function(component, event, helper) {
        helper.getCaseComments(component, event, helper);
    },

    openModal : function(component, event, helper) {
        var newComment = new Object();
        newComment.CommentBody = '';
        newComment.IsPublic = false;
        component.set("v.newCaseComment", newComment);
        component.set("v.showNewPopup",true);
    },

    closeModel : function(component, event, helper) {
        component.set("v.showNewPopup",false);
    },

    charCount : function(component, event, helper) {
        component.set("v.showNewPopup",false);
    },

    submitDetails : function(component, event, helper) {
        // component.set("v.showNewPopup",false);
        var validExpense = component.find('commentform').reduce(function (validSoFar, inputCmp) {
            // Displays error messages for invalid fields
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        // If we pass error checking, do some real work
        if(validExpense){
            event.getSource().set("v.disabled", true);
            event.getSource().set("v.label", "Submitting...");
            helper.insertCaseComments(component, event, helper);
        }
    },
})