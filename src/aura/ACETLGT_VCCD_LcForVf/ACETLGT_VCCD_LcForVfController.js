({
    onRender: function(component, event, helper) {
        let isCustomConsoleOpen = component.get("v.isCustomConsoleOpen");
        if(isCustomConsoleOpen){
        helper.pollApex(component, event, helper);
        }
    }
})