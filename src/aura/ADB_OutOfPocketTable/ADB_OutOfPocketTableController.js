({
    handleOutofPocketEvent: function(component, event, helper){
        var displayPops = event.getParam("displayPops");
        if(displayPops.inMetYtdAmount != null && displayPops.inMetYtdAmount != ''){
            component.set("v.inAmount",parseFloat(displayPops.inMetYtdAmount).toFixed(2));
        }else{
            component.set("v.inAmount", '0.00'); 
        }
        if(displayPops.outMetYtdAmount != null && displayPops.outMetYtdAmount != ''){
            component.set("v.outAmount", parseFloat(displayPops.outMetYtdAmount).toFixed(2));
        }else{
            component.set("v.outAmount", '0.00'); 
        }
        if(displayPops.preMetYtdAmount != null && displayPops.preMetYtdAmount != ''){
            component.set("v.preAmount", parseFloat(displayPops.preMetYtdAmount).toFixed(2));
        }else{
            component.set("v.preAmount", '0.00'); 
        }
        component.set('v.showSpinner',false);
    },
    
    handleMouseOverTopic : function(component, event, helper){
        component.set("v.togglehovertopic",true);
    },
    
    handleMouseOutTopic : function(component, event, helper){
        component.set("v.togglehovertopic",false);
    }
})