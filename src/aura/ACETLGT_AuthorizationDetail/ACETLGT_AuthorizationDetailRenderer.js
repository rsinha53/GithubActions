({
    rerender: function(component, helper) {
        //if(component.get("v.afterRenderedFired") != true){
            this.superRerender();
			
            var intId = component.get("v.intId");
            if(intId != undefined ){
                var childCmp = component.find("cComp");
                var memID = component.get("v.memberId");
                var GrpNum = component.get("v.groupId");
                
                childCmp.childMethodForAlerts(intId,memID,GrpNum,'','');
                //alert('---1---'+intId +'-----'+memID +'-----'+GrpNum );
            }
        //}
        
    }
})