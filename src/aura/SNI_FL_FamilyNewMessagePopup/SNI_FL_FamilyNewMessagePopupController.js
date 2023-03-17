({
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
        
      
        var desktopViewMessage = component.get("v.newMessageBody");
        var mobileViewMessage = component.get("v.mobilenewMessageBody");
       
        var selectedToUsers = component.get('v.selectedUserLookUpRecords');
        var accId = component.get("v.SelectedFamilyAcoountName");

        if(accId != null && accId != undefined && accId != '') {
            
            if(selectedToUsers.length>0) {
                if((mobileViewMessage != null && mobileViewMessage.length > 131072) || (desktopViewMessage != null && desktopViewMessage.length > 131072)){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Warning!",
                        "message": "Limit Exceeded...!!"
                    });
                    toastEvent.fire();
                } else {
                    var spinner = component.find("mySpinner");
                    $A.util.removeClass(spinner, "slds-hide");

                    if($A.util.isUndefinedOrNull(desktopViewMessage)){
                        helper.saveNewMessage(component, event, helper,mobileViewMessage); 
                    }else{
                        helper.saveNewMessage(component, event, helper,desktopViewMessage); 
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
        component.set("v.SelectedFamilyAcoountName", message);
        if(message == undefined){
            console.log('MSG INSIDEX');
            var childCmp = component.find("multiPopID");
            childCmp.clearFunction();
           
        }
    },


    
})