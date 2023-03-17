({
	doInit:function(component,event,helper){
        component.set("v.logedUserID",$A.get("$SObjectType.CurrentUser.Id"));
    },

	postComments : function(component, event, helper) {
        //Added by Eagles - Bobby Culbertson US3278491 - Family Designation Conditional
		var famDesignation = component.get("v.familyDesignation");
        if(famDesignation != 'Dormant'){
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
        } else {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Account Has Expired",
                "message": "Thank you for reaching out, unfortunately your account has expired. Please call the number on the back of your insurance card for immediate assistance.",
                "type": "info",
                "duration":"10000"
            });
            toastEvent.fire();

        }
		
	},

	postCommentsMobile:function(component,event,helper){
        //Added by Eagles - Bobby Culbertson US3278491 - Family Designation Conditional
        var famDesignation = component.get("v.familyDesignation");
        if(famDesignation != 'Dormant'){
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
        } else {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Account Has Expired",
                "message": "Thank you for reaching out, unfortunately your account has expired. Please call the number on the back of your insurance card for immediate assistance.",
                "type": "info",
                "duration":"10000"
            });
            toastEvent.fire();
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
    
    clearReplyBody: function(component, event, helper) {

        component.set("v.replyValue", null);
        component.set("v.replyValueMobile", null);
    	
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
    }

})