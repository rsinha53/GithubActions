({
	postComments:function(component,event,msgText,fileID){
		var feedID = component.get("v.selectedDirectMessage").directMessageFeed.directMessageFeedID;
		var action = component.get('c.validatepostNewCommentAttachment'); 
		
		action.setParams({ 
			"msgText" : msgText,
			"feedElementId" : feedID,
			"fileId":fileID
		});
	   
		action.setCallback(this, function(response){			
			
			if(response.getState() == 'SUCCESS') {
				this.changeReplyMessageStatus(component,event,feedID);
				var selectedMessageEvt = component.getEvent("selectedFamilyLinkMessage");
				selectedMessageEvt.setParams({
					"directMessageFeedID":feedID
				});
				selectedMessageEvt.fire();

				component.set("v.attachId",'');
				component.set("v.fileName",'No File Selected..'); 

			}else{
				var errors = response.getError();
				console.log('Error Occured ' +errors[0].message);
			}
		});
        $A.enqueueAction(action);
    },

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

    scrollToBottom : function(element){
        element.scrollTop = element.scrollHeight-element.clientHeight;
    },

    markUnreadCtrl: function(cmp,feedId){
        var action = cmp.get("c.markAsUnread");
        action.setParams({
            "feedId":feedId
        });
        action.setCallback(this,function(response){

            if(response.getState()=='SUCCESS'){
                var result = response.getReturnValue();
                if(result == true){
                    var bool = true;
                    cmp.set("v.markUnread", bool); 
                }
            } else if(response.getState()=='ERROR'){
                var errors = response.getError();
                console.log("Error Message "+errors[0].message);
            }
        });

        $A.enqueueAction(action);
    }
    
})