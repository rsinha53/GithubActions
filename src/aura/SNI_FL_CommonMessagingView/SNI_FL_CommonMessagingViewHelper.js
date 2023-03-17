({
    
    //Retrieving comments
    retrieveComments : function(component,event,pageNumber,element) {
        
        var pageSize = component.get("v.commentPageSize");
        var feedID = component.get("v.selectedDirectMessage").directMessageFeed.directMessageFeedID;
        var action = component.get("c.getPaginatedFeedComments");
        action.setParams({
            "feedID":feedID,
            "pageNumber":pageNumber,
            "pageSize":pageSize
        });
        action.setCallback(this,function(response){
            if(response.getState()=="SUCCESS"){
                
                var result = response.getReturnValue();
                result.reverse();
                if(result.length != 0){

                    var selectedMsg = JSON.parse(JSON.stringify(component.get("v.selectedDirectMessage")));
                    var comments = selectedMsg.lstDirectMessageComments;
                    var newResult = [];

                    result.forEach(function(value,index,array){
                        newResult.push(result[index]);
                    });
                    comments.forEach(function(value,index,array){
                        newResult.push(comments[index]);
                    });

                    component.set('v.selectedDirectMessage.lstDirectMessageComments', newResult );	
                    var newElement = component.find("scroll").getElement();

                    newElement.scrollTop = newElement.scrollHeight-(element.scrollHeight-element.clientHeight);

                }
            }
        });
        
        $A.enqueueAction(action);
    },

    postComments:function(component,event,msgText,fileID){
            var feedID = component.get("v.selectedFeedIdValue");
            var action = component.get('c.validatepostNewCommentAttachment'); 
            action.setParams({ 
                "msgText" : msgText,
                "feedElementId" : feedID,
                "fileId":fileID
            });
           
            action.setCallback(this, function(a){			
                var state = a.getState(); // get the response state   
                if(state == 'SUCCESS') {
                    this.changeReplyMessageStatus(component,event,feedID);
                    var selectedMessageEvt = component.getEvent("selectedMessage");
                    selectedMessageEvt.setParams({
                        "directMessageFeedID":feedID
                    });
                    selectedMessageEvt.fire();
                    component.set("v.attachId",'');
                    component.set("v.fileName",'No File Selected..'); 
                }
            });
            $A.enqueueAction(action);
        
    },
    
    //Executes when a new reply is sending for the existing message thread and 
    //updates the status based on the number of participants
    //Author: Sameera De Silva(ACDC)
    changeReplyMessageStatus:function(component,event,feedID){        
        var action = component.get("c.changeMessageStatusWhenReplying");
        action.setParams({
            "DirectMessageFeedID":feedID
        });
        action.setCallback(this,function(response){

            if(response.getState()=='SUCCESS'){
                
            }else if(response.getState()=='ERROR'){
                var errors = response.getError();
                console.log("Error Message "+errors[0].message);
            }
        });

        $A.enqueueAction(action);
    },

    getUserPermissionSets:function(component,event,loggedInUser){
        var action = component.get("c.getCurrentUserPermissionSet");
        action.setParams({
            userId: loggedInUser
        });
        action.setCallback(this, function(result){
            if(result.getState() == 'SUCCESS'){
                component.set("v.isPermissionSetAssigned", result.getReturnValue());

            } else if(result.getState()=='ERROR'){
                var errors = result.getError();
                console.log("Error Message "+errors[0].message);
            }
        });
        $A.enqueueAction(action);

    },

    scrollToBottom : function(element){
        element.scrollTop = element.scrollHeight-element.clientHeight;
    },
    
})