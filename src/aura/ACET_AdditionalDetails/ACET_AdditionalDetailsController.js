({
	myAction : function(component, event, helper) {
		
	},
     //Swapna
     selectAll: function (cmp, event) {
       var checked = event.getSource().get("v.checked");
        var cardDetails = cmp.get("v.additionalDetails");
        var cardData = cardDetails.cardData;
        for (var i of cardData) {
            if (i.showCheckbox && !i.defaultChecked) {
                i.checked = checked;
            }
	}
        cmp.set("v.additionalDetails", cardDetails);
        //_autodoc.setAutodoc(cmp.get("v.autodocUniqueId"), cardDetails);
        _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"),cmp.get("v.autodocUniqueIdCmp"), cardDetails);
    }
    //Swapna
})