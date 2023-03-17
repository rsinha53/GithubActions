({
	// Your renderer method overrides go here
	rerender : function(component, helper) {
      this.superRerender();
       // Write your custom code here. 
        
    	var contactVal = component.get('v.getContactVal');
        component.set('v.setContactVal',contactVal);
        console.log('>>>**Render**<<<<<' + component.get('v.responseData'));
        //if(component.get('v.responseData') != null && component.get('v.responseData').length == 1 && component.get('v.searchBtnFlag') == true){
        if(component.get('v.searchBtnFlag') == true){
            helper.openInteractionOverview(component, helper);	
            component.set("v.mnf",'');
        }else if(component.get('v.responseData') == undefined && component.get("v.invalidResultFlag")){
            console.log('>>>****<<<<<');
            console.log(component.get("v.displayMNFFlag"));
            if(component.get("v.showHideMemAdvSearch") == true && component.get("v.displayMNFFlag") == true){
            	component.set("v.mnf",'mnf');
       	 	}
        }
        component.set("v.searchBtnFlag",false);
    },
    
})