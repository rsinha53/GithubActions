({
    doInit:function(component,event,helper){  
        helper.getMemberIdByFamilyId(component, event, helper);
        
    },

    closeModel : function(component, event, helper) {
        component.set("v.IsOpenNewMsg",false); 
        var removedUsers = component.get("v.removedCareTeamMember");
        var selectedUsers = component.get("v.selectedUserLookUpRecords");
        for(var i = 0; i < removedUsers.length; i++){
            selectedUsers.push(removedUsers[i]);
        }
        component.set("v.selectedUserLookUpRecords", selectedUsers);
        component.set("v.removedCareTeamMember", null);

        helper.deleteAttachment(component, event, helper);
    },
       
    handleUploadFinished : function(component, event, helper) { 

        component.set("v.fileName", '');
        component.set("v.attachId", null);
        var uploadFiles = event.getParam("files");
        var documentId = uploadFiles[0].documentId;
        var fileName = uploadFiles[0].name;
        
        var fileId = component.get("v.attachId");
        if(fileId != null && fileId != undefined && fileId != ''){
            helper.deleteAttachment(component, event, helper);
        }

        component.set("v.fileName", fileName);
        component.set("v.attachId", documentId);

        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "message": "File(s)" + fileName + "Uploaded Successfully",
            "type": "success"
        });
        toastEvent.fire();
    },
    
    sendMessage : function(component, event, helper) {   
        
        var selectedToUsers = component.get('v.selectedUserLookUpRecords');
        var isBackupAgentView = component.get("v.isBackupAgentView");
        var isFamilyLevel = component.get("v.isFamilyLevel");
        console.log('isFamilyLevel in contrl' + isFamilyLevel);
        var accId = '';
        if(component.get('v.isFamilyLevel')){
            accId = component.get("v.familyId");
        } else {
            accId = component.get("v.selectedFamilyRecord");
        }
        
        var limitCheck = component.find("number").get("v.value");
        if(accId != null && accId != undefined && accId != '') {
            if(selectedToUsers.length>0) {
                if(isFamilyLevel){
                    if(limitCheck != null && limitCheck.length > 131072){
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Warning!",
                            "message": "Limit Exceeded...!!"
                        });
                        toastEvent.fire();
                    } else {
                        var spinner = component.find("mySpinner");
                        $A.util.removeClass(spinner, "slds-hide");
                        helper.saveNewMessage(component, event, helper); 
                    }
                } else {
                    if(!isBackupAgentView){
                        if(selectedToUsers.length>1){
                            if(limitCheck != null && limitCheck.length > 131072){
                                var toastEvent = $A.get("e.force:showToast");
                                toastEvent.setParams({
                                    "title": "Warning!",
                                    "message": "Limit Exceeded...!!"
                                });
                                toastEvent.fire();
                            } else {
                                var spinner = component.find("mySpinner");
                                $A.util.removeClass(spinner, "slds-hide");
                                helper.saveNewMessage(component, event, helper); 
                            }
                        } else {
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                "title": "Error!",
                                "message": "Please select a user to send message"
                            });
                            toastEvent.fire();
                        }
                    } else {
                        if(limitCheck != null && limitCheck.length > 131072){
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                "title": "Warning!",
                                "message": "Limit Exceeded...!!"
                            });
                            toastEvent.fire();
                        } else {
                            var spinner = component.find("mySpinner");
                            $A.util.removeClass(spinner, "slds-hide");
                            helper.saveNewMessage(component, event, helper); 
                        }
                    }
                }
                
                
            } else {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Please select a user to send message"
                });
                toastEvent.fire();
            }
        } else {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "Please select a family"
            });
            toastEvent.fire();
        }
    },
    
    handleMulticmpEvent : function(component, event, helper) {
        
        var message = event.getParam("listOfSearchRecordsEvt");
        component.set("v.listOfSearchRecords", message);
        if(message == undefined){
            console.log('MSG INSIDEX');
            var childCmp = component.find("multiPopID");
            childCmp.clearFunction();
            childCmp.initFunction();
        }
    },
    handleShowCurtain: function(component, event, helper){
        component.set('v.showOnclickCurtain',event.getParam("showOnclickCurtain"));
    },
    hideDropdowns: function(component, event, helper){
        component.set('v.showOnclickCurtain',false);
    },
    /* onchildblur : function(component,event,helper) {
        
        component.find("name") ? component.find("name").childFamilyMethod() : '' ;
        //component.find("multiPopID") ? component.find("multiPopID").childMultiSelect() : '' ;
    },
    
    onblur : function(component,event,helper) {
        
      component.find("multiPopID") ? component.find("multiPopID").childMultiSelect() : '' ;
    },*/
    
    


    
})