({
    initCall : function(component, event, helper) {
                /*This below line checks whether an exception is caught in apex*/
                    
        helper.doInit(component, event, helper);
                  /*This Happens when a exception is caught in apex and redirects to error page*/
    },
    onChangeFamily :function(component, event, helper){
        helper.onChangeFamily(component, event, helper);
    },
    RefreshComponent : function(component, event, helper){
        helper.doInit(component, event, helper);
    }
    
    
    
})