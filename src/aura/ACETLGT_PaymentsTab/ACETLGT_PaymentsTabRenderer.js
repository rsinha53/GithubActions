({
    afterRender: function(cmp, helper) {
        this.superAfterRender();
        var queryDone = cmp.get("v.paymentQueryDone");
//        alert('here' + queryDone);
        if (!queryDone) {
//        alert('here1');
            var p = cmp.get("v.parent");
//            alert('here2' + p);
            p.queryPaymentsFromChild();
//            var tabKey = cmp.get("v.AutodocKey") + cmp.get("v.GUIkey");
//            setTimeout(function() {
////            	alert('here3');
//                if (window.lgtAutodoc != undefined)
//                    window.lgtAutodoc.initAutodoc(tabKey);
////                cmp.set("v.Spinner", false);
//
//            }, 1);
        }
    }
})