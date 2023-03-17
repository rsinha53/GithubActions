({
	// Your renderer method overrides go here
	// 
	rerender : function (component, helper) {
        this.superRerender();
        if(component.get("v.isModalOpen") == true){
            if(component.find("csetype") != undefined){
                component.find("csetype").focus();
            }
        }
        	
    }
})