({
	afterRender : function(component, helper) {
  		this.superAfterRender();
        console.log("----2--------->"+component.get("v.srk"));
   		helper.showResults(component, helper);
	}
})