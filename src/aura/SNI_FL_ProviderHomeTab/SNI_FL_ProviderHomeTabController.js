({
    doInit : function(component, event, helper) {
        
      /*  if(screen.width < 600){
            component.set('v.isSmallScreen', true);
        } else if (screen.width < 992) {
            component.set('v.isTabletScreen', true);
        }*/
        
    },
    
    getValueFromApplicationEvent : function(component, event) {
         
        var ShowResultValue = event.getParam("Pass_Result"); 
        console.log('ShowResultValue : '+ShowResultValue);
        var action = component.get('c.memberdata');
        action.setParams({
            programname : ShowResultValue
        });
        action.setCallback(this,function(response){
            if (response.getState() === "SUCCESS") {
                var conlst = response.getReturnValue();
                console.log('tab'+conlst);
                if(conlst != null){
                    component.set("v.providerList",conlst); // Nanthu(AC/DC) - Changed to sync with wrapper
                    // component.set("v.providerList",conlst.memberData); // Nanthu(AC/DC) - Changed to sync with wrapper
                    // component.set("v.messageList",conlst.messageData); // Nanthu(AC/DC) - Added for recent activity page messages
                    component.set("v.Providersize",true);
                }else{

                    component.set('v.Providersize',false);
                }
            }
            
        })
        $A.enqueueAction(action);
    },
    
    ShowPopUP : function(component,event, helper) {
        var recid=event.target.id;
         component.set("v.memberId", recid);
        component.set("v.isModalOpen", true);
    },
    
    handleSNI_FL_MemberModelCloseEvt : function(component,event, helper) {
      component.set("v.isModalOpen", event.getParam("message"));  
    },
    changeToMessages: function(component, event, helper){
        var memName=event.target.id;
        var memId =event.target.getAttribute('data-memberid');
        var cmpEvent = component.getEvent("SNI_FL_RedirectToViewMessagesEvt");
        cmpEvent.setParams({
            memberName : memName,
            memberId : memId });
        cmpEvent.fire();
    },
})