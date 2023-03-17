({
	// Your renderer method overrides go here
	rerender : function(component, helper) {
      this.superRerender();
       // Write your custom code here. 
        
        /*if(component.get('v.responseData') != null && component.get('v.responseData').length == 1 && component.get('v.searchBtnFlag') == true){
            helper.openInteractionOverview(component, helper);	
        }
        component.set("v.searchBtnFlag",false);*/
    }
})