({
	hideSpinner2: function(component, event, helper) {        
        component.set("v.Spinner", false);
        console.log('Hide');
        //setTimeout(function(){
        	//window.lgtAutodoc.initAutodoc();
        //},1);
    },
    // this function automatic call by aura:waiting event  
    showSpinner2: function(component, event, helper) {
        // make Spinner attribute true for display loading spinner 
        component.set("v.Spinner", true);
        console.log('show');
		}

})