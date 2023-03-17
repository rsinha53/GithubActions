({
    
	itemsChange : function(component, event, helper) {
		var strname=[];
        var headervals = [];
        headervals = event.getParam("value");
         console.log(headervals);
        console.log(headervals.reportFields);
        for (var i = 0; i < headervals.reportFields.length; i++) {
           strname.push(headervals[i].fieldLabel);
        }
        component.set("v.columns",strname);
        alert(strname);
	}
})