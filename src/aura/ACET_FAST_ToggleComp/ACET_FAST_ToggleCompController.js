({
    getToggleButtonValue:function(component,event,helper){
        component.set("v.chkboxvalue",event.getSource().get("v.checked"));
    }
})