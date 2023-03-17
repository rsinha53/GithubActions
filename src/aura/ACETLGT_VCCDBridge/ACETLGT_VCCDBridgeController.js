({
    /**
     * On Render Event Handler .
     *
     * @param objComponent To access dom elements.
     * @param objEvent To handle events.
     * @param objHelper To handle events.
     */
    onRender : function(objComponent, objEvent, objHelper) {
        console.log('VCCD Bridge open ');
        objHelper.onRenderHandler(objComponent, objEvent, objHelper); 
        objComponent.find("tglbtn").set("v.checked",true);

    }, 

    /**
     * Set the Selected NavigationItem .
     *
     * @param objComponent To access dom elements.
     * @param objEvent To handle events.
     * @param objHelper To handle events.
     */
    setSelectedNavigationItem : function(objComponent, objEvent, objHelper) {
        objHelper.setSelectedNavigationItemHelper(objComponent);
    },
     getToggleButtonValue:function(component,event,helper){
        var checkCmp = component.find("tglbtn").get("v.checked");
        component.set("v.chkboxvalue",checkCmp);
    }
})