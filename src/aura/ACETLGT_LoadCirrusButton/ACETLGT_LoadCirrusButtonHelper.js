({
	getCIRRUSURL : function(component, event, helper) {

        var cirrusURL = component.get("v.cirrusURL");
        console.log('cirrusURL New :: '+cirrusURL);
        
        window.open(cirrusURL, 'CIRRUS', 'toolbars=0,width=1200,height=800,left=0,top=0,scrollbars=1,resizable=1');
		
	}
})