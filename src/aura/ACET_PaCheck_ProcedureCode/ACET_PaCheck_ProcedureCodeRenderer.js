({

	// US2894783
	afterRender: function (cmp, helper) {
		this.superAfterRender();
		helper.addRaw(cmp, null, null);
	}

})