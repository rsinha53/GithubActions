({
	helperMethod : function() {
		
	}
    /*,
    getWODetails : function (cmp, event, helper) {
       
        console.log('--------init---helper-----');
        console.log('-------recordId--------'+cmp.get("v.recordId"));
        //alert(cmp.get("v.recordId"));
        var action = cmp.get("c.getWODetails");
        action.setParams({ woId : cmp.get("v.recordId") });
        action.setCallback(this, function (response) {
            var state = response.getState();
            alert(state);
            if (state == "SUCCESS") {
                var val = response.getReturnValue();
                alert(val);
                console.log(val);
                cmp.set("c.hostSysDate",val);
            }
        })
        }
        */
})