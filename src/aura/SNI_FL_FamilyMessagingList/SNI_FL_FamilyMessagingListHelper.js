({
    //Retrieving directMessageWrapper by passing feedID
    getDirectMessage : function(component,feedId){
        var userID = $A.get("$SObjectType.CurrentUser.Id");
        var action = component.get("c.getDirectMessageWrapperForFeedID");
        action.setParams({
            "feedID":feedId,
            "userID":userID,
            "isProviderMessage":false //US3128862
        });
        action.setCallback(this,function(response){
            if(response.getState() == "SUCCESS"){
                var result = response.getReturnValue();
                if(result != null && result != undefined && result != ''){
                    var spinner = component.find("mySpinner");
                    $A.util.addClass(spinner, "slds-hide");
                    component.set("v.selectedDirectMessage",response.getReturnValue());
                    component.set("v.isChatView", true);
                    helper.sendSelectedFeedID(component,feedId);
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
    
    //Added by Sameera
	firePaginationEvent : function(component,pageNumber) {
		
        var paginationEvt = component.getEvent("pagination");
        paginationEvt.setParams({
            "pageNumber":pageNumber,
        });
        paginationEvt.fire();
        
    },

    sendSelectedFeedID:function(component,event,feedID){   
            
        var selectedMessageEvt = component.getEvent("selectedFamilyLinkMessage");
        selectedMessageEvt.setParams({
            "directMessageFeedID":feedID
        });
        selectedMessageEvt.fire();

    }
})