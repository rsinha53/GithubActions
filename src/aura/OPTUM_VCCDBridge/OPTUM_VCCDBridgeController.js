({
    /**
     * On Render Event Handler .
     *
     * @param objComponent To access dom elements.
     * @param objEvent To handle events.
     * @param objHelper To handle events.
     */
    onRender : function(objComponent, objEvent, objHelper) {
        objHelper.onRenderHandler(objComponent, objEvent, objHelper); 
        
    }, 

    openNewTab: function(component, event, helper){
	  //Edited by Dimpy for DE384310: One member Account Details are displayed on another member
	  //Edited by Dimpy for DE446003 VCCD Component Error
        if(!($A.util.isUndefinedOrNull(component.get("v.objVCCDRecord.FaroId__c"))))
        helper.memberResults(component, event, helper);
       
    },
})