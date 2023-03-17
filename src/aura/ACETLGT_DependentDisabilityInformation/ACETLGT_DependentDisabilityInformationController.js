({
	doInit : function(cmp, event, helper) {
        setTimeout(function(){
            var tabKey = cmp.get("v.AutodocKey");
            window.lgtAutodoc.initAutodoc(tabKey);
        },1);
    }
})