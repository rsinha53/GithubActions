({
	rerender : function (component, helper) {
		this.superRerender ();
		
		var tabKey = component.get("v.AutodocKey")+component.get("v.idValue");

		var toggval = component.get("v.showHide");
        if(toggval =="hide"){
		setTimeout(function(){
			//alert("Hello 1"+toggval);
			window.lgtAutodoc.initAutodoc(tabKey);
		},1);
        }
	}
})