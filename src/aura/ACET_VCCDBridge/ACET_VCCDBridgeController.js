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
})