({    
    getDirectMessages : function(component,event,userId,pageNumber,pageSize,selectedId) {
        var isUnread = component.get("v.isUnread");
        var proAffId = component.get("v.providerAffliationID");

        var action = component.get("c.getDirectMessageList");
        action.setParams({
            "isFamilyLevel":false,
            "agentID":userId,
            "familiyAccountID":proAffId,
            "pageNumber":pageNumber,
            "pageSize":pageSize,
            "isFlagged":false,
            "isBackupAgent":true,
            "isProviderMsgLevel":false,
            "selectedId":selectedId, // added by Nanthu to get FL related to selected messages
            "isUnread": isUnread, // added by Nanthu to get FL unread messages
            "isProvider": false // added by Vamsi to filter Provider messages in SENS UI
        });
        
        action.setCallback(this,function(response){
            
            if(response.getState()=='SUCCESS'){ 
               var lstOfDirectMessages = response.getReturnValue();

                if(!$A.util.isEmpty(lstOfDirectMessages)){  
                    
                    //added vamsi 
                    lstOfDirectMessages.forEach(function(record){
                        if(record.directMessageFeed.initiatedUser.profileName== 'Center for Health Navigation' || record.directMessageFeed.initiatedUser.profileName == 'System Administrator'  ){
                            record.directMessageFeed.initiatedUser.userLastName = record.directMessageFeed.initiatedUser.userLastName.substring(0,1);
                        }
                    })
                    
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
                    component.set("v.recordStart",0);
                    component.set("v.recordEnd",0);
                    component.set("v.totalPages",1);
                    component.set("v.pageNumber",1);
                    component.set("v.totalRecords",0);

                }
            }
        });
        $A.enqueueAction(action);
		
    },
    
    getSelectedDirectMessage : function(component,feedId){
        
        var userID = this.getSelectMessageInitiatedUserID(component,feedId);
        var action = component.get("c.getDirectMessageWrapperForFeedID");
        action.setParams({
            "feedID":feedId,
            "userID":userID,
            "isProviderMessage":true
        });
        action.setCallback(this,function(response){
            if(response.getState() == "SUCCESS"){
                var result = response.getReturnValue();
                //added vamsi
                result.lstDirectMessageComments.forEach(function(UserName){
                    if(UserName.commentedUser.profileName== 'AD' || UserName.commentedUser.profileName== 'AD'  ){
                        UserName.commentedUser.userLastName = UserName.commentedUser.userLastName.substring(0,1);
                    } 
                })
                result.lstDirectMessageUsers.forEach(function(UserName){
                    if(UserName.profileName== 'Center for Health Navigation' || UserName.profileName== 'System Administrator'  ){
                        UserName.userLastName = UserName.userLastName.substring(0,1);
                    } 
                })
                   
                if(result.directMessageFeed.initiatedUser.profileName== 'Center for Health Navigation' || result.directMessageFeed.initiatedUser.profileName == 'System Administrator'  ){
                    result.directMessageFeed.initiatedUser.userLastName = result.directMessageFeed.initiatedUser.userLastName.substring(0,1);
                }
                   
                if(result != null && result != undefined && result != ''){
                    var spinner = component.find("mySpinner");
                    $A.util.addClass(spinner, "slds-hide");

                    result.lstDirectMessageComments.reverse();
                    component.set("v.selectedDirectMessage",result);
                    component.set("v.isChatView", true);
                    
                    setTimeout(function () {
                        var child1 = component.find("msgContent");
                        child1.scrollToBottom();
                    }, 200);
                   
                } else {
                    var spinner = component.find("mySpinner");
                    $A.util.addClass(spinner, "slds-hide");
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": "Something went wrong",
                        "type": "error"
                    });
                    toastEvent.fire();
                }
            } else {
                var spinner = component.find("mySpinner");
                $A.util.addClass(spinner, "slds-hide");
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Something went wrong",
                    "type": "error"
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    },

    getSelectMessageInitiatedUserID:function(component,feedId){
        
        var lstDirectMessages = component.get("v.lstDirectMessages");
        
        for(var value in lstDirectMessages){
            
            if(feedId == lstDirectMessages[value].directMessageFeed.directMessageFeedID){
               return lstDirectMessages[value].directMessageFeed.initiatedUser.userID;
            }
            
        }
       
    }
})