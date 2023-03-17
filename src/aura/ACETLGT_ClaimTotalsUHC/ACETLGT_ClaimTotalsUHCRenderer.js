({
	afterRender: function (cmp, helper) {
        this.superAfterRender();
        var tabKey = cmp.get("v.AutodocKey") + cmp.get("v.GUIkey");
        setTimeout(function(){
            
            if(window.lgtAutodoc != undefined)
            	window.lgtAutodoc.initAutodoc(tabKey);
            cmp.set("v.Spinner", false);

        },1);
    }
})