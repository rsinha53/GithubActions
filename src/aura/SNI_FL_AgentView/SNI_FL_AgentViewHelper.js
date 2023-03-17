({
    //Added By:Sameera De Silva
    //Retrieves  direct messages from the controller and set pagination attributes
    getListOfDirectMessages : function(component,event,familyID,pageSize,pageNumber,isFamilyLevel,agentID,isBackupAgent) {
       
        var isFlagged = component.get("v.isFlagged");
        var isProviderMsgLevel = component.get("v.isProviderMsgLevel");
        var selectedId = "empty";
        var isUnread = false;
        var isProvider = component.get("v.isProvider");;
        var action = component.get("c.getDirectMessageList");
        action.setParams({
            "isFamilyLevel":isFamilyLevel,
            "agentID":agentID,
            "familiyAccountID":familyID,
            "pageNumber":pageNumber,
            "pageSize":pageSize,
            "isFlagged":isFlagged, // added by pavithra for flag filtering
            "isBackupAgent":isBackupAgent, // added by Nanthu for backup agent messages
            "isProviderMsgLevel":isProviderMsgLevel, // added by Nanthu to track provider level messages
            "selectedId": selectedId, // added by Nanthu to track related to selected messages
            "isUnread": isUnread, // added by Nanthu to get FL unread messages
            "isProvider": isProvider // added by Vamsi to filter Provider messages in SENS UI
        });
        
        action.setCallback(this,function(response){
            
            if(response.getState()=='SUCCESS'){
                var lstOfDirectMessages = response.getReturnValue();

                if(!$A.util.isEmpty(lstOfDirectMessages)){
                    //component.set("v.selectedDirectMessage",lstOfDirectMessages[0]);//added by sameera
                    component.set("v.lstDirectMessages",lstOfDirectMessages);
                    component.set("v.recordStart",lstOfDirectMessages[0].recordStart);
                    component.set("v.totalRecords",lstOfDirectMessages[0].totalRecords);
                    component.set("v.pageNumber",pageNumber);
                    if(lstOfDirectMessages[0].recordEnd > lstOfDirectMessages[0].totalRecords){
                        component.set("v.recordEnd", lstOfDirectMessages[0].totalRecords);
                    } else {
                        component.set("v.recordEnd", lstOfDirectMessages[0].recordEnd);
                    }
                    component.set("v.totalPages", Math.ceil(lstOfDirectMessages[0].totalRecords / pageSize));
                    
                }else{
                    component.set("v.lstDirectMessages",null);
                }
                
            }
            
        });
        $A.enqueueAction(action);
    },
    
    //Retrieving directMessageWrapper by passing feedID
    getDirectMessage:function(component,feedID){
        var userID = this.getSelectMessageInitiatedUserID(component,feedID);
        var isProviderMessage = this.getSelectedMessageProviderMessageStatus(component,feedID);
        component.set("v.isProviderMessage",isProviderMessage);
        var action = component.get("c.getDirectMessageWrapperForFeedID");
        action.setParams({
            "feedID":feedID,
            "userID":userID,
            "isProviderMessage":isProviderMessage //US3128862
        });
        action.setCallback(this,function(response){
            if(response.getState() == "SUCCESS"){
                var data = response.getReturnValue();
                data.lstDirectMessageComments.reverse();
                this.setupNewMemeberAddedMessage(component,data);
                component.set("v.selectedDirectMessage",data);
                setTimeout(function () {
                    var child1 = component.find("msgContent");
                    child1.scrollToBottom();
                }, 200);
                
            }
        });
        $A.enqueueAction(action);
    },
    
    setupNewMemeberAddedMessage:function(component,data){
        
        let {lstDirectMessageComments} = data;
 
        lstDirectMessageComments.find((val,index)=>{
            
        
            if(val.commentBody != undefined && val.commentBody.includes('ACDC:')){
                
                    let contentPart = val.commentBody.substring(val.commentBody.indexOf('%')+1,val.commentBody.length);
                    
                    if(val.commentedUser.userFirstName && val.commentedUser.userLastName){
                        let message = val.commentedUser.userFirstName+' '+val.commentedUser.userLastName+' '+contentPart;
                        val.commentBody = message;
                        val.isNewUser = true;
                    }
                    else if(!val.commentedUser.userFirstName && val.commentedUser.userLastName){
                        let message = val.commentedUser.userLastName+' '+contentPart;
                        val.commentBody = message;
                        val.isNewUser = true;
                    }

                }
        });
    },

    getSelectMessageInitiatedUserID:function(component,feedId){
        
        var lstDirectMessages = component.get("v.lstDirectMessages");
        
        for(var value in lstDirectMessages){
            
            if(feedId == lstDirectMessages[value].directMessageFeed.directMessageFeedID){
               return lstDirectMessages[value].directMessageFeed.initiatedUser.userID;
            }
            
        }
       
    },
    
    getSelectedMessageProviderMessageStatus:function(component,feedId){
        
        var lstDirectMessages = component.get("v.lstDirectMessages");
        
        for(var value in lstDirectMessages){
            
            if(feedId == lstDirectMessages[value].directMessageFeed.directMessageFeedID){
               return lstDirectMessages[value].flMessage.isProviderMessage;
            }
            
        }
       
    } 
    
})