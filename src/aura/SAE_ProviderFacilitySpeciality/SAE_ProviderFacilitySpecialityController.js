({
	specialityRecsChange : function(cmp,event,helper){
		setTimeout(function () {
            var tabKey = cmp.get("v.AutodocKey")+'facilityspeciality';
            window.lgtAutodoc.initAutodoc(tabKey);
        }, 1);
        helper.hidespecialitySpinner(cmp);
	}
})