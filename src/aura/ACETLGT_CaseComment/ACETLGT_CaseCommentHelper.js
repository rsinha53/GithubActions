({
    callCommentAction: function(component, event, helper){
        var action = component.get("c.fetchCaseCommentsWrapper");
        var caseId = component.get("v.recordId");
        var issueId= component.get("v.issueId");
        console.log('issueId:'+issueId);
        action.setParams({
            "caseId":caseId,
            "issueId":issueId
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log(response.getReturnValue());
            if (state === "SUCCESS") {
                component.set("v.OrsResultWrapperVariable", response.getReturnValue());
                if(response.getReturnValue().statusCode!=200){
                    component.set("v.mode","view");
                    helper.fireToast(response.getReturnValue().message);
                }else{
                    component.set("v.mode","readonly");
                }

                setTimeout(function(){

                    $(document).ready(function() {
                    var table;
                    var tableid = ('#'+component.get('v.dataTblId'));
                    if ( $.fn.dataTable == undefined && ($.fn.dataTable != undefined && $.fn.dataTable.isDataTable( tableid ) )) {
						//$(tableid).DataTable().destroy();
                        table = $(tableid).DataTable();

                    }
                    else {
						//$(tableid).DataTable().destroy();
                        table = $(tableid).DataTable({
                            "columnDefs": [ {
                                "targets": [0,1,2,3,4,5],
                                "orderable": false
                            } ],
                            "order": [[0,"desc"]]
                        });
                    }
                    });

                }, 500);
            }
            else{
                component.set("v.OrsResultWrapperVariable", response.getReturnValue());//setting the blank wrapper
                //Throw error message for any error
            }
            helper.checkBoxEnablement(component, event, helper);
        });
        $A.enqueueAction(action);
    },

    checkBoxEnablement :function(component, event, helper){
        var action = component.get("c.checkBoxEnablement");
        var input = component.get("v.OrsResultWrapperVariable");
        var caseId = component.get("v.recordId");
        action.setParams({
            "caseId":caseId,
            "inputData" : input
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log(response.getReturnValue());
            if (state === "SUCCESS") {
                component.set("v.enableCheckbox", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    sendCommentToOrs : function(component, event, helper){
        var input = component.get("v.OrsResultWrapperVariable");
        var action = component.get("c.sendCommentORS");
        action.setParams({
            "inputData" : input
        });


        action.setCallback(this, function (response) {
            var state = response.getState(); // get the response state
            var result = response.getReturnValue();
            if (state == 'SUCCESS' && (result.statusCode == 200 || result.statusCode == 201)) {
                this.fireToastMessage("Success!", result.message.replace(". ", ". \n"), "success", "dismissible", "1000");
                this.refreshPage(component,event,helper);

            }
            else{
                this.fireToastMessage("Error!", result.message.replace(". ", ". \n"), "error", "dismissible", "10000");
            }
        });
        $A.enqueueAction(action);

    },
    saveComments : function(component, event, helper){
        var isPublic = component.get("v.isPublicComment")=='Public'?true:false;
        var input = component.get("v.OrsResultWrapperVariable");
        var action = component.get("c.saveNewComment");
        var caseId = component.get("v.recordId");
        action.setParams({
            "inputData" : input,
            "caseId" :caseId,
            "isPublic":isPublic
        });


        action.setCallback(this, function (response) {
            var state = response.getState(); // get the response state
            var result = response.getReturnValue();
            
            console.log('state='+state);
            if (state == 'SUCCESS') { //&& result as no return type of the method
                helper.refreshPage(component,event,helper);
            }
            else{
            }
        });
        $A.enqueueAction(action);
    },
    
    refreshPage: function(component,event,helper){
        location.reload();
        /* var tableid = ('#'+component.get('v.dataTblId'));
        if ($.fn.dataTable && $.fn.dataTable.isDataTable(tableid)) {
            console.log('destroy table');
            setTimeout(function(){ 
                $('#tableId').DataTable().clear().destroy();
                $A.get("e.force:refreshView").fire(); //DataTable initialisation error coming
            }, 500);
        }*/
    },

    fireToast: function (message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Error!",
            "message": message,
            "message": message,
            "type": "error",
            "mode": "sticky"
        });
        toastEvent.fire();
    },
    fireToastMessage: function (title, message, type, mode, duration) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type": type,
            "mode": mode,
            "duration": duration
        });
        toastEvent.fire();
    },
    errorMessage:function (component,errorCode, helper) {
        var action = component.get("c.getErrorMessage");
        action.setParams({
            "errorCode":errorCode
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log(response.getReturnValue());
            if (state === "SUCCESS") {
                helper.fireToast(response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    validationCheck : function(component, event, helper){
        var comment = component.find("commentSection").get("v.value");
        if(comment != ""){
            var titleField = component.find("commentValidity");
            $A.util.removeClass(titleField, 'slds-has-error');
            var validationmessage = component.find("commentValidationMessage");
            $A.util.removeClass(validationmessage, 'slds-visible');
            $A.util.addClass(validationmessage, 'none');
        }
    },
    onSubmitValidation : function(component, event, helper){
        var valid = true ;
        var comment = component.find("commentSection").get("v.value");
        if(comment == ""){
            valid= false;
            var titleField = component.find("commentValidity");
            $A.util.addClass(titleField, 'slds-has-error');
            var validationmessage = component.find("commentValidationMessage");
            $A.util.removeClass(validationmessage, 'none');
            $A.util.addClass(validationmessage, 'slds-visible');
        }
        return valid;
    }
});