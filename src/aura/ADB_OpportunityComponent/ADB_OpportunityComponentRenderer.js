({
	//Added by Metallica
  afterRender : function(component, helper) {
  		this.superAfterRender();
         
        if(component.get("v.memberTypeId")== 'SKEY'){
        	console.log(">>>srk"+component.get("v.memberXrefId"));
        	helper.getRole(component, event, helper); 
        }  
	}
})