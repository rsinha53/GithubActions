({  
    doInit: function(component, event, helper) {
        var loggedInUser = $A.get("$SObjectType.CurrentUser.Id");
        component.set("v.logedUserID",loggedInUser);
        helper.getUserPermissionSets(component,event,loggedInUser);
    },

    //US3304375 - 2021/24/2(sameera) updated by checking isprovidermessage
    openFamilyProfilePage : function(component, event, helper) {
        
        let selectedMessage = component.get('v.selectedDirectMessage');
        let recordId;

        if(component.get('v.isProviderMessage')){
            recordId =  selectedMessage.flMessage.member.id;   
        }else{
            recordId = selectedMessage.flMessage.familyAccountID;
        }

        var workspaceAPI = component.find("workspace");
        workspaceAPI.openTab({
            pageReference: {
                "type": "standard__recordPage",
                "attributes": {
                    "recordId": recordId,
                    "actionName":"view"
                },
                "state": {}
            },
            focus: true
        }).then(function(response) {
            workspaceAPI.getTabInfo({
                tabId: response
            })
        }).catch(function(error) {
            console.log(error);
        });
    },

    getToggleButtonValue : function(component, event, helper) {
        var isMarked = true;
        isMarked = event.getSource().get('v.value');
        var directMessage = component.get('v.selectedDirectMessage');
        var directMsg = component.get("v.lstDirectMessages");
        for(let i = 0; i < directMsg.length; i++){
            if(directMsg[i].directMessageFeed.directMessageFeedID == directMessage.flMessage.feedId){               
                directMsg[i].flMessage.marked = isMarked;
                var action = component.get("c.feedToggleMarked");
                action.setParams({
                    "flflag":isMarked,
                    "feedID":directMessage.flMessage.feedId
                });                
                action.setCallback(this,function(response){
                    var result = response.getReturnValue();
                    if(result != null) {
                        component.set("v.lstDirectMessages", directMsg);
                    }
                });
                
                $A.enqueueAction(action);
            }
        }         
    },
    
    //Retrieve next list of comments when scrolling
    getNextComments : function(component, event, helper) { 
      
        var pageNumber = component.get("v.commentPageNumber");
        var element = component.find("scroll").getElement();
        
        if(element.scrollTop == 0){
            helper.retrieveComments(component,event,pageNumber,element);
            pageNumber++;
            component.set("v.commentPageNumber",pageNumber);
        }      
    },

    postComments : function(component, event, helper) {
        var fileID = component.get("v.attachId");
        var msgText = component.get("v.replyValue");

        if(component.get("v.isFamilyLevel")){
            if(component.get("v.accountOwner") == component.get("v.logedUserID")){
                component.set("v.replyValue", "");

                if($A.util.isEmpty(msgText) && $A.util.isEmpty(fileID)){
                    
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                            "title": "Error!",
                            "message": "Please enter a message or attach a file to send."
                    });
                    toastEvent.fire();
                    
                    
                }else{
                    helper.postComments(component,event,msgText,fileID);
                }

            } else{
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    type: 'info',
                    key: 'info_alt',
                    message: "You must be the account owner to message with the family.",
                    mode: 'dismissible'
                });
                toastEvent.fire();  
            }
        } else{
            component.set("v.replyValue", "");

            if($A.util.isEmpty(msgText) && $A.util.isEmpty(fileID)){
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                        "title": "Error!",
                        "message": "Please enter a message or attach a file to send."
                });
                toastEvent.fire();
                
                
            }else{
                helper.postComments(component,event,msgText,fileID);
            }
        }
        
    },
    
    handleUploadFinishedNew : function(component, event, helper) {               
        var uploadedFiles = event.getParam("files");
        var documentId = uploadedFiles[0].documentId;
        var fileName = uploadedFiles[0].name;
                
        component.set("v.fileName", fileName);
        component.set("v.attachId", documentId);
          
        //var toastEvent = $A.get("e.force:showToast");
         for(var i = 1; i < uploadedFiles.length; i++){
             fileName = fileName + ','+''+ uploadedFiles[i].name;
         }
         if(uploadedFiles = "Success"){
             var toastEvent = $A.get("e.force:showToast");
             toastEvent.setParams({
                 "title": "Success!",
                 "message": "File(s) "+ fileName +" Uploaded successfully.",
                 "type" : "SUCCESS"
             });
         }else if(uploadedFiles = "Error"){
             var toastEvent = $A.get("e.force:showToast");
             toastEvent.setParams({
                 "title": "Error",
                 "message": "File(s) "+ fileName +" Uploaded failed.",
                 "type" : "error"
             });
         }
         toastEvent.fire();
    },

    scrollToBottom: function(cmp, event, helper){
        helper.scrollToBottom(cmp.find("scroll").getElement());
    },
    
    clearReplyBody: function(component, event, helper) {
        component.set("v.replyValue", null);
        component.set("v.fileName", "No File Selected..");
        
    }
    
})