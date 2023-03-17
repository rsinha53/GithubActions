({    
    getDirectMessages : function(component,userId,pageNumber,pageSize,selectedFamilyId) {
        var ept = 'empty';
        var action = component.get("c.getDirectMessageList");
        action.setParams({
            "isFamilyLevel":false,
            "agentID":userId,
            "familiyAccountID":selectedFamilyId,
            "pageNumber":pageNumber,
            "pageSize":pageSize,
            "isFlagged":false, // added by pavithra for flag filtering
            "isBackupAgent":true, // added by Nanthu for backup agent messages
            "isProviderMsgLevel":false, // added by Nanthu to track provider level messages
            "selectedId": ept, // added by Nanthu to track related to selected messages
            "isUnread": false, // added by Nanthu to get FL unread messages
            "isProvider": false // added by Vamsi to filter Provider messages in SENS UI
        });
        
        action.setCallback(this,function(response){
            
            if(response.getState()=='SUCCESS'){ 
               var lstOfDirectMessages = response.getReturnValue();
          
                if(!$A.util.isEmpty(lstOfDirectMessages)){  
                    //added vamsi 
                    lstOfDirectMessages.forEach(function(record){
                        if(record.directMessageFeed.initiatedUser.profileName== 'Center for Health Navigation' || record.directMessageFeed.initiatedUser.profileName == 'System Administrator' || record.directMessageFeed.initiatedUser.profileName == 'ACET Member'  ){
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
            "isProviderMessage":false //US3128862
        });
        action.setCallback(this,function(response){
            if(response.getState() == "SUCCESS"){
                var result = response.getReturnValue();
                this.setupNewMemeberAddedMessage(component,result);
                result.lstDirectMessageComments.forEach(function(UserName){
                    if(UserName.commentedUser.profileName== 'Center for Health Navigation' || UserName.commentedUser.profileName== 'System Administrator'  || UserName.commentedUser.profileName== 'ACET Member'  ){
                        UserName.commentedUser.userLastName = UserName.commentedUser.userLastName.substring(0,1);
                    } 
                })
                result.lstDirectMessageUsers.forEach(function(UserName){
                    if(UserName.profileName== 'Center for Health Navigation' || UserName.profileName== 'System Administrator' || UserName.profileName== 'ACET Member'){
                        UserName.userLastName = UserName.userLastName.substring(0,1);
                    } 
                })
                
                if(result.directMessageFeed.initiatedUser.profileName== 'Center for Health Navigation' || result.directMessageFeed.initiatedUser.profileName == 'System Administrator' || result.directMessageFeed.initiatedUser.profileName == 'ACET Member'  ){
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
       
    },

    setupNewMemeberAddedMessage:function(component,data){
        
        let {lstDirectMessageComments} = data;
 
        lstDirectMessageComments.find((val,index)=>{
        
        	if((!$A.util.isEmpty(val.commentBody)) && val.commentBody.includes('ACDC:')){
                
                    let contentPart = val.commentBody.substring(val.commentBody.indexOf('%')+1,val.commentBody.length);
                    
                    if(val.commentedUser.userFirstName && val.commentedUser.userLastName){
                        let message = val.commentedUser.userFirstName+' '+val.commentedUser.userLastName.substring(0,1)+' '+contentPart;
                        val.commentBody = message;
                        val.isNewUser = true;
                    }
                    else if(!val.commentedUser.userFirstName && val.commentedUser.userLastName){
                        let message = val.commentedUser.userLastName.substring(0,1)+' '+contentPart;
                        val.commentBody = message;
                        val.isNewUser = true;
                    }

                }
        });
    },
    //Added by Eagles - Bobby Culbertson US3278095 - Family Designation Conditional
    getDesignation: function(component, selectedFamilyId){
        var action = component.get("c.getFamilyOverviewDesignation");
        action.setParams({
            "familyAccountId":selectedFamilyId
        });

        action.setCallback(this,function(response){
            
            if(response.getState()=="SUCCESS"){
                var result = response.getReturnValue();
                if(result.length != 0){
                    component.set('v.familyDesignation', result);                    
                }
            }
        });
            
        $A.enqueueAction(action);
    }

})