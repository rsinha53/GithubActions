({
	doInit : function(component, event, helper) {	

        var roiId = component.get("v.recordId");
        if(roiId != undefined && roiId !=''){
             component.set("v.isCTM",false);
             component.set("v.recid",roiId);
         }
        var createUserAction = component.get('c.getCommunityInfo');
        createUserAction.setCallback(this, function(response) {
            var state = response.getState();
            if (state == "SUCCESS") {
                component.set("v.isCommunity", response.getReturnValue());
                var iscom = response.getReturnValue();
                var recid = component.get("v.recid");
                var isctm = component.get("v.isCTM");
                var iframeurl;
                if(iscom==true){
                    iframeurl='/myfamilylink/apex/Family_Link?recid='+recid+'&isctm='+isctm;
                } else if(iscom==false){
                    iframeurl='/apex/Family_Link?recid='+recid+'&isctm='+isctm;
                }
                component.set("v.iframeurl", iframeurl);
            }
         });
        $A.enqueueAction(createUserAction); 

	},
    closeWarning :function(component, event,helper){
        component.set("v.editMode",false);
        var roievtFire = $A.get("e.c:SNI_FL_ViewAuth");
        roievtFire.fire();
    }


})