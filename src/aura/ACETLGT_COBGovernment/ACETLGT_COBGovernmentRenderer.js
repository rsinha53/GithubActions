({
	rerender : function (component, helper) {
		this.superRerender ();
		//alert('Test 2 ');
		var tabKey = component.get("v.AutodocKey")+component.get("v.idValue");
        var toggval = component.get("v.toggleGov");
        if(toggval !="slds-show"){
        setTimeout(function(){
            //alert('===='+tabKey);
			window.lgtAutodoc.initAutodoc(tabKey);
		},1);
        }
	},
	
})