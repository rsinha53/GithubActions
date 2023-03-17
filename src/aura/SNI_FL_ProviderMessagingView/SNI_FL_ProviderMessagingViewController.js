({
    doInit : function(component, event, helper) {
        
        var pageSize = component.get("v.pageSize");
        var pageNumber = component.get("v.pageNumber");
        var selectedId = component.get("v.selectedId");
        var userId = $A.get("$SObjectType.CurrentUser.Id");
        component.set('v.userIdValue', userId);
		helper.getDirectMessages(component,event,userId,pageNumber,pageSize,selectedId);
    },

    //Call doInit to retrieve all message again and update message list
    //Author:Sameera ACDC
    retrieveAllMessages:function(component,event,helper){
        var doInit = component.get("c.doInit");
        $A.enqueueAction(doInit);

        //Clear selected message from the commonmessage view
        component.set('v.selectedDirectMessage',"");
        component.set("v.isChatView",false);
    },

    backButtonEvt : function(component, event, helper){
        var chatHistory = component.find("commonMessagingView");
        $A.util.addClass(chatHistory, "mobileView");
        
        var msgList = component.find("messagingList");
        $A.util.removeClass(msgList, "mobileView");
    },
    
    //Handles paginations
    paginationHandler:function(component,event,helper){
        var userId = $A.get("$SObjectType.CurrentUser.Id");
        var pageSize = component.get("v.pageSize");
        var pageNumber = event.getParam("pageNumber");
        var selectedId = component.get("v.selectedId");

        helper.getDirectMessages(component,event,userId,pageNumber,pageSize,selectedId);     
        component.set('v.selectedDirectMessage',""); 
    },

    getDirectMessageForSelectedMessage:function(component,event,helper){
        component.set("v.commentPageSize",10);
        component.set("v.commentPageNumber",2);
        var feedID = event.getParam("directMessageFeedID");
        component.set('v.selectedFeedIdValue',feedID);
        
        helper.getSelectedDirectMessage(component,feedID);
    },

    //set the variable to true/false based on old value and passing to child
    //SNI_FL_FamilyMessagingList
    //Author:sameera
    clearSelectedMessageFromList:function(component,event,helper){
       
        if(component.get("v.isClearSelectedMessage")){
            component.set("v.isClearSelectedMessage",false);
        }else{
            component.set("v.isClearSelectedMessage",true);
        }
    },

    filterByRelatedTo:function(component,event,helper){
        var userId = $A.get("$SObjectType.CurrentUser.Id");
        var pageSize = component.get("v.pageSize");
        var pageNumber = 1;
        var selectedId = component.get("v.selectedId");
        helper.getDirectMessages(component,event,userId,pageNumber,pageSize,selectedId);   
        component.set('v.selectedDirectMessage',""); 
    },

    markUnreadHandler:function(component,event,helper){
        var userId = $A.get("$SObjectType.CurrentUser.Id");
        var pageSize = component.get("v.pageSize");
        var pageNumber = component.get("v.pageNumber");
        var selectedId = component.get("v.selectedId");
        helper.getDirectMessages(component,event,userId,pageNumber,pageSize,selectedId);   
        component.set('v.selectedDirectMessage',""); 
        component.set('v.markUnread',false); 
    },

    //Change the message list when dropdown value changes
    //Author:Nanthu
    dropDownChange: function(component,event,helper){
        var userId = $A.get("$SObjectType.CurrentUser.Id");
        var pageSize = component.get("v.pageSize");
        var pageNumber = component.get("v.pageNumber");
        var selectedId = component.get("v.selectedId");
        helper.getDirectMessages(component,event,userId,pageNumber,pageSize,selectedId);   
        component.set('v.selectedDirectMessage',""); 
    }
})