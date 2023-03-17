({
    init : function(component, event, helper) {
        setTimeout(function() {
            var element = component.find("scroll").getElement();
            element.scrollTop = element.scrollHeight;
            window.scrollTo(0,document.body.scrollHeight); 
        }, 100);
        if(component.get('v.showMobileMessage') == true){
            setTimeout(function() {
                var element1 = component.find("scrollMobile").getElement();
                element1.scrollTop = element1.scrollHeight;
                window.scrollTo(0,document.body.scrollHeight); 
            }, 100);
        }
    },
    closeMessageModal : function(component,event,helper){
        component.set('v.personHistMsgs', []);
        component.set('v.showMobileMessage', false);
        var authName = component.get('v.listname');
        var cmpEvent = component.getEvent("SNI_FL_CloseProviderAffModalEvt");
        cmpEvent.setParams({
            ListauthorName : authName
        });
        cmpEvent.fire();
    }
})