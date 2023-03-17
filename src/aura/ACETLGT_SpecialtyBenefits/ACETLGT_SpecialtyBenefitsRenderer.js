({
	afterRender : function(cmp, helper) {
        setTimeout(function(){ 
        	var covRecs = cmp.get("v.mydata");
            console.log('xxxx After renderer'+JSON.stringify(covRecs));
            if(covRecs.length > 0){
                for(var i=0; i < covRecs.length; i++){
                    
                    if(covRecs[i].isActive){
                        cmp.set("v.isToggled", true);
                        cmp.set("v.isInactiveOnly", false);
                        break;
                    }
                }
            } 
        }, 500);
        var specBen = cmp.get("v.specialtyBenefits");
        cmp.set("v.mydata", JSON.parse(specBen));
     
    }
})