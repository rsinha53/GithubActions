({
	afterRender: function (component, helper) {
        this.superAfterRender();
        var tabKey = component.get("v.AutodocKey") + component.get("v.GUIkey");
        setTimeout(function(){
            
            
            //alert('********'+tabKey);
            if(window.lgtAutodoc != undefined)
            	window.lgtAutodoc.initAutodoc(tabKey);
            component.set("v.Spinner", false);

        },1);
    }
})