({
    afterRender: function(component, helper) {
        //if(component.get("v.afterRenderedFired") != true){
            this.superAfterRender();
			
//            var intId = component.get("v.intId");
//            //alert('----In renderer----->'+intId);
//            if(intId != undefined ){
//                var childCmp = component.find("cComp");
//                var memID = component.get("v.memId");
//                var GrpNum = component.get("v.grpNum");
//                var bundleId = component.get("v.bundleId");
//                childCmp.childMethodForAlerts(intId,memID,GrpNum,'Detail',bundleId);
//                //alert('---1---'+intId +'-----'+memID +'-----'+GrpNum );
//            }
        //}
        
    }
    /**,
    afterRender: function(component, helper) {
    	this.superAfterRender();
        
        var intId = component.get("v.intId");
        //alert('----In renderer 2----->'+intId);
        if(intId != undefined){
            var childCmp = component.find("cComp");
            var memID = component.get("v.memId");
            var GrpNum = component.get("v.grpNum");
            //alert('---1---'+intId +'-----'+memID +'-----'+GrpNum );
            childCmp.childMethodForAlerts(intId,memID,GrpNum);
            component.set("v.afterRenderedFired", true);
        }
    }**/
})