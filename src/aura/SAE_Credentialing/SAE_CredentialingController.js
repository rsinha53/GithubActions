({
    credentialsChange : function(cmp, event, helper) {
		setTimeout(function () {
            var tabKey = cmp.get("v.AutodocKey")+'credentialing';
            window.lgtAutodoc.initAutodoc(tabKey);
        }, 1);
		helper.hideCredentialSpinner(cmp);
    }
})