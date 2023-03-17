({
    rerender: function(component, helper) {
        //if(component.get("v.afterRenderedFired") != true){
            this.superRerender();
			
            var intId = component.get("v.intId");
            //alert('----In renderer----->'+intId);
            if(intId != undefined ){
                var childCmp = component.find("cComp");
                var memID = component.get("v.memId");
                var GrpNum = component.get("v.grpNum");
                var hData = component.get("v.highlightPanel");
				childCmp.childMethodForAlerts(intId,memID,GrpNum,'',hData.benefitBundleOptionId);
                //alert('---1---'+intId +'-----'+memID +'-----'+GrpNum );
                
            }
        
        /*
        console.log('renderer val ::'+component.get("v.startDateValue"));
        console.log('renderer val type::'+component.get("v.authType"));
        console.log('renderer val status::'+component.get("v.authStatus"));
        console.log('renderer val status::'+component.get("v.enddateValue"));
        console.log('renderer val status auth No::'+component.get("v.authNo"));
		*/

        //if (!$A.util.isEmpty(component.get("v.startDateValue")))
        //component.find("filterButton").focus();  
        //}
        
    }
})