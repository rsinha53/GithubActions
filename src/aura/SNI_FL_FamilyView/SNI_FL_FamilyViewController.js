({
    doInit : function(component, event, helper) {
        var userId = $A.get("$SObjectType.CurrentUser.Id");
        component.set('v.userIdValue', userId);

        var pageSize = component.get("v.pageSize");
        var pageNumber = component.get("v.pageNumber");
        var selectedFamilyId = component.get("v.selectedFamilyId");
        var selectedAccountName = component.get("v.SelectedAccountName");
        
		helper.getDirectMessages(component,userId,pageNumber,pageSize,selectedFamilyId);
		
		//Added by Eagles - Bobby Culbertson
		//if selectedFamilyIs is not null is first check because this is a bound attribute
		//connected to the SNI_FL_FamiliySelection component. If the selection is every changed
		//we want to prioritieze this attribute to get our family designations.     
        if(selectedFamilyId == null){
            if(selectedAccountName != null){
                helper.getDesignation(component, selectedAccountName); 
            } else {
                helper.getDesignation(component, null); 
            }
        } else {
            helper.getDesignation(component, selectedFamilyId); 
        }
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
        var selectedFamilyId = component.get("v.selectedFamilyId");

        helper.getDirectMessages(component,userId,pageNumber,pageSize,selectedFamilyId);     
        component.set('v.selectedDirectMessage',""); 
    },

    getDirectMessageForSelectedMessage:function(component,event,helper){
        
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

    //Change the message list when dropdown value changes
    //Author:Nanthu
    dropDownChange: function(component,event,helper){
        var userId = $A.get("$SObjectType.CurrentUser.Id");
        var pageSize = component.get("v.pageSize");
        var pageNumber = component.get("v.pageNumber");
        var selectedFamilyId = component.get("v.selectedFamilyId");
        helper.getDirectMessages(component,userId,pageNumber,pageSize,selectedFamilyId);   
        component.set('v.selectedDirectMessage',""); 
		
        //Added by Eagles - Bobby Culbertson
		//if selectedFamilyIs is not null is first check because this is a bound attribute
		//connected to the SNI_FL_FamiliySelection component. If the selection is every changed
		//we want to prioritieze this attribute to get our family designations.  
        var selectedAccountName = component.get("v.SelectedAccountName");
        if(selectedFamilyId == null){
            if(selectedAccountName != null){
                helper.getDesignation(component, selectedAccountName); 
            } else {
                helper.getDesignation(component, null); 
            }
        } else {
            helper.getDesignation(component, selectedFamilyId); 
        }
    }
})