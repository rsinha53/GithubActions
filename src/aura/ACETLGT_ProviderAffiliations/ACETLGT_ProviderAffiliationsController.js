({
	affiliationProvidersToggle : function(component,event,helper) {
       var accordianactive =  component.get("v.accordianactive");
        if(!accordianactive){
            component.set("v.accordianactive",true);
         var providerType = component.get("v.providerType");
         helper.getDataFromServer(component, event, helper,providerType);
        }
        else{
                        component.set("v.accordianactive",false);

        }
    },
     initComplete_Event : function(component, event, helper) {
        var settings = event.getParam("settings");
    },
    handledtcallbackevent : function(component, event, helper) {
        var settings = event.getParam("settings");
        var lgt_dt_table_ID = event.getParam("lgt_dt_table_ID");
        
    },
    handlecreatedRow_Event : function(component,event,helper) {
         var row = event.getParam("row");   
         var data = event.getParam("data");
    }
})