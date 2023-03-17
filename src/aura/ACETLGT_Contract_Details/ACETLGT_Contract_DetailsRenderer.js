({
	// Your renderer method overrides go here
	afterRender: function (component, helper) {
        this.superAfterRender();
        // interact with the DOM here
        setTimeout(function(){
            var tabKey = component.get("v.AutodocKey")+'C';
            //alert(tabKey);
            window.lgtAutodoc.initAutodoc(tabKey);
        },1); 
    }
})