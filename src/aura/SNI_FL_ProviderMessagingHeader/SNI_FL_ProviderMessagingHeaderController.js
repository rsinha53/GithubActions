({
    createNewMessage : function(component, event, helper) {
       
        component.set("v.IsOpenNewMsg",true);
    },

    

    goBackToMsgList : function(component, event, helper) {
        var backButton = component.find("backButton");
        $A.util.addClass(backButton, "slds-hide");
        component.set("v.isChatView", false);
        component.set("v.replyValueMobile", null);
        component.set("v.fileName","No File Selected..");

        //After firing this event SNI_FL_FamilyMessaginglist event handle this and 
        //clears the selected message css
        var evt = component.getEvent('clearSelectedMessageEvent');
        evt.fire();
    },

    handleFilterChange : function(component,event,helper){
        var selectedOptionValue = event.getParam("value");
        if(selectedOptionValue === 'Unread'){
            component.set("v.isUnread", true);
        }else{
            component.set("v.isUnread", false);
        }
        helper.loadDirectMessageList(component,event,helper);
        component.set('v.selectedDirectMessage',""); 
    },

    selectFilterOption :function(component,event,helper){      
        
        var selectedItem= component.find("select").get("v.value");
        if(selectedItem === 'Unread'){
            component.set("v.isUnread", true);
        }else{
            component.set("v.isUnread", false);
        }
        helper.loadDirectMessageList(component,event,helper);
        component.set('v.selectedDirectMessage',""); 
    },

    //DE409699 added providerAffliationID attribute
    itemsChange :function(component,event,helper){
        if(!component.get("v.isChatView")){
            helper.getAffliationName(component,event); 
            helper.checkHistoricMessages(component,event,helper);
        }
    },
    init: function(component,event,helper){
        helper.checkHistoricMessages(component,event,helper);
    },
    decideHist:function(component, event, helper){
        var selectID = component.get("v.selectedId");
        if(selectID != 'empty'){
            component.set("v.typeAheadFlow",true);
            component.set("v.histMessageEnabled",false);
            if(component.get('v.searchedMemberName')!= false 
               && component.get('v.searchedMemberId') != false
               && component.get('v.searchedMemberName') === component.get('v.selectedLabel')){
                var act = component.get('c.getMemAffHistSwitch');
                act.setParams({
                    "memberAff" : component.get('v.searchedMemberId') 
                });
                act.setCallback(this,function(resp){
                    var ste = resp.getState();
                    if(ste === 'SUCCESS'){
                        component.set("v.histMessageEnabled", resp.getReturnValue());
                        component.set("v.histMemberAffId",component.get('v.searchedMemberId'));
                    }
                });
                $A.enqueueAction(act);
            } else{ 
                var action = component.get('c.getMemAffHistEnabled');
                action.setParams({
                    "providerAff":component.get('v.providerAffliationID'),
                    "personId":component.get('v.selectedId')
                });
                action.setCallback(this,function(response){
                    var state = response.getState();
                    if (state === 'SUCCESS') {
                        var res = response.getReturnValue();
                        var parsed = res.split('-');
                        component.set("v.histMessageEnabled",parsed[1]);
                        if(parsed[1]){
                            component.set("v.histMemberAffId",parsed[0]);
                        }
        }
                });
                $A.enqueueAction(action);
            }
        }else{
            component.set("v.histMessageEnabled",component.get("v.histMessagePrevious"));
            component.set("v.histMemberAffId",' ');
            component.set("v.typeAheadFlow",false);
            component.set("v.searchedMemberId","");
        }
    },
    openhistpage:function(component,event,helper){
        var personid = component.get("v.providerAffliationID");
        var navService = component.find("navService");
        var pageReference = {
            type: 'comm__namedPage',
            attributes: {
                pageName: "Older-Messages"
            },
            state: {
                personID : personid,
                isProvider : true
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
    openMemAffhistpage:function(component,event,helper){
        var personid = component.get("v.histMemberAffId");
        var navService = component.find("navService");
        var pageReference = {
            type: 'comm__namedPage',
            attributes: {
                pageName: "Older-Messages"
            },
            state: {
                personID : personid,
                isProvider : true,
                isMemAff : true
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
})