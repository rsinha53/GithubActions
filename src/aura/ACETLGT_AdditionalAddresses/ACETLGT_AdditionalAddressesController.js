({
	additionalAddressToggle : function(component,event,helper) {
         var accordianActive =  component.get("v.accordianactive");
         if(!accordianActive){
            component.set("v.accordianActive",true);
            var providerType = component.get("v.providerType");
            helper.getDataFromServer(component, event, helper,providerType);
         }else{
              component.set("v.accordianActive",false);
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
         var statusCode = data.addressStatusCode ? data.addressStatusCode : '';
        if(statusCode == 'A') {
            $(row).children().first().html('<div class="slds-icon_container_circle slds-icon-action-approval slds-icon_container"><img src="'+$A.get('$Resource.SLDS') + '/assets/icons/action/approval_60.png" style="max-width:14px;"></img></div>');
        }else if(statusCode == 'I') {
            $(row).children().first().html('<div class="slds-icon_container_circle slds-icon-action-close slds-icon_container"><img src="'+$A.get('$Resource.SLDS') + '/assets/icons/action/close_60.png" style="max-width:14px;"></img></div>');
        }    
    },
    handle_dt_pageNum_Event: function(component, event, helper) {
  var pgnum = event.getParam("pageNumber");
  //alert("====>>"+pgnum);
  component.set("v.page_Number", pgnum);
 }
})