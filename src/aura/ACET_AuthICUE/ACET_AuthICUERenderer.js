({
	afterRender: function (cmp,  helper) {
		this.superAfterRender();
		helper.initEccaTable(cmp, helper);	
	}
})