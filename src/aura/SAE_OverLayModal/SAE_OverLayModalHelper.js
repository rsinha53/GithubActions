({
    getICUEURL : function(component, event, helper) {
        debugger;
        var ICUEURL = component.get("v.ICUEURL");
        console.log('icueURL New :: '+ICUEURL);  
        component.find("overlayLib").notifyClose();
        window.open(ICUEURL, 'ICUE', 'toolbars=0,width=1200,height=800,left=0,top=0,scrollbars=1,resizable=1');
    },
})