// US1938551 - Thanish - 19th Dec 2019
({
	// Purpose - Sets the status of the checked attribute
	handleToggle : function(cmp) {
		cmp.set("v.checked", !cmp.get("v.checked"));
	}
})