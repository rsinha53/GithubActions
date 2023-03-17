({
	doInit:function(component,event,helper){
        component.set("v.logedUserID",$A.get("$SObjectType.CurrentUser.Id"));
        component.set("v.isDisplayFileName", false);
    },

    postComments : function(component, event, helper) {
		var msgText = component.get("v.replyValue");
        var fileID = component.get("v.attachId");
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
		
	},

	postCommentsMobile:function(component,event,helper){
        
        var msgText = component.get("v.replyValueMobile");
        var fileID = component.get("v.attachId");
        component.set("v.replyValueMobile", "");
        
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
	},
    
    clearSelectedMessageFromList:function(component,event,helper){
       
        if(component.get("v.isClearSelectedMessage")){
            component.set("v.isClearSelectedMessage",false);
        }else{
            component.set("v.isClearSelectedMessage",true);
        }
       
    },
    
    fileUploadClick: function(component, event, helper) {
        component.set("v.fileName", '');
    },

    handleUploadFinishedNew : function(component, event, helper) {
        component.set("v.fileName", '');
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
            component.set("v.isDisplayFileName", true);
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Success!",
                "message": "File(s) "+ fileName +" Uploaded successfully.",
                "type" : "SUCCESS"
            });
        }else if(uploadedFiles = "Error"){
            component.set("v.isDisplayFileName", false);
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error",
                "message": "File(s) "+ fileName +" Uploaded failed.",
                "type" : "error"
            });
        }
         toastEvent.fire();
    },
    
    clearReplyBody: function(component, event, helper) {
        component.set("v.replyValue", null);
        component.set("v.replyValueMobile", null);
        component.set("v.fileName","No File Selected..");
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

    scrollToBottom: function(cmp, event, helper){
        helper.scrollToBottom(cmp.find("scroll").getElement());
    },

    goBackToMsgList : function(component, event, helper) {
        component.set("v.isChatView", false);
        component.set("v.replyValueMobile", null);
        component.set("v.fileName","No File Selected..");
        //After firing this event SNI_FL_FamilyMessaginglist event handle this and 
        //clears the selected message css
       
        var evt = component.getEvent('clearSelectedMessageEvent');
        evt.fire();
        
    },

    markUnreadCtrl: function(cmp, evt, hpr){
        var loggedInUser = cmp.get("v.logedUserID");
        
        var feedComments = cmp.get('v.selectedDirectMessage').lstDirectMessageComments;
        var len = feedComments.length;
        var check = false;
        var i;
        for (i = 0; i < len; i++) {
            if(feedComments[i].commentedUser.userID != loggedInUser){
                check = true;
            }
        }
        if(check == true){
            var feedId = cmp.get('v.selectedDirectMessage.directMessageFeed.directMessageFeedID');
            hpr.markUnreadCtrl(cmp,feedId);
            var goBackToMsgList = cmp.get("c.goBackToMsgList");
            $A.enqueueAction(goBackToMsgList);
        } else {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                type: 'info',
                key: 'info_alt',
                message: "Only messages that have a response can be marked as unread.",
                mode: 'dismissible'
            });
            toastEvent.fire();  
        }
    }
})