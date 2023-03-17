({
    createNewMessage : function(component, event, helper) {
        //Added by Eagles - Bobby Culbertson US3278095 - Family Designation Conditional
        var famDesignation = component.get("v.familyDesignation");
        if(famDesignation != 'Dormant'){
            component.set("v.IsOpenNewMsg",true);
            console.log('IsOpenNewMsg'+component.get('v.IsOpenNewMsg'));
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
    
    msgSelectedEvt : function(component, event, helper) {
        console.log('msg select evt fired from header');
        var backButton = component.find("backButton");
        $A.util.removeClass(backButton, "slds-hide");
        $A.util.addClass(backButton, "slds-show");
    },

    goBackToMsgList : function(component, event, helper) {
        var backButton = component.find("backButton");
        $A.util.addClass(backButton, "slds-hide");
        component.set("v.isChatView", false);

        //After firing this event SNI_FL_FamilyMessaginglist event handle this and 
        //clears the selected message css
        //Author:sameera
        var evt = component.getEvent('clearSelectedMessageEvent');
        evt.fire();
    },
    
    post:function(component,event,helper){
    	console.log('owrking');
        var action=component.get("c.sendNewMsg");
        action.setCallback(this,function(response){
           console.log(response); 
        });
        
        $A.enqueueAction(action);
	},
    openhistpage:function(component,event,helper){
        var personid = component.get("v.histPersonId");
        var navService = component.find("navService");
        var pageReference = {
            type: 'comm__namedPage',
            attributes: {
                pageName: "Older-Messages"
            },
            state: {
                personID : personid
	}
        };
         event.preventDefault();
         window.name = "parent";
         navService.generateUrl(pageReference)
            .then($A.getCallback(function(url) {
                var newWindow = window.open(url,'_blank','');
            }), $A.getCallback(function(error) {
                alert('error');
            }));
    },
    init: function(component,event,helper){
        var action = component.get('c.getHistoryEnabled');
        action.setCallback(this,function(response){
           var state = response.getState();
            if (state === 'SUCCESS') {
                var res = response.getReturnValue();
                var parsed = res.split('-');
                component.set("v.histMessageEnabled",parsed[1]);
                component.set("v.histPersonId",parsed[0]);
            }
        });
        $A.enqueueAction(action);
    }
})