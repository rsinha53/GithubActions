({
	doInit : function(component, event, helper) {
      var cseId = component.get("v.recordId");
      var action = component.get("c.getrecorddata");
        var error;
        action.setParams({ cseId : cseId });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
               var caseobj = response.getReturnValue().caseobj;
                var Interaction = response.getReturnValue().Interaction;
                var ThirdParty = response.getReturnValue().ThirdParty;
                var invalidcase = response.getReturnValue().invalidcase;
                 error = response.getReturnValue().error;  
                var oUser = response.getReturnValue().oUser;
                var CoveragesresultWrapper = response.getReturnValue().CoveragesresultWrapper;
                
                if(!CoveragesresultWrapper){
                    error = 'Unexpected Error Occured. Please Try Agin.';
                }                                       
                var resultresp = JSON.parse(response.getReturnValue().result);
                if(error){
                    debugger;
                   component.set("v.errorincase",true);
                    component.set("v.loderspinner",false);
                }
                component.set("v.caseobj",caseobj);
                component.set("v.Interaction",Interaction);
                component.set("v.ThirdParty",ThirdParty);
                component.set("v.error",error);

                if(invalidcase=='true'){
                   component.set("v.loderspinner",false);
                    component.set("v.issubdetailavil",true);
                }

                if(resultresp && CoveragesresultWrapper !=undefined){
                   // component.set("v.resultresp",resultresp);

                   helper.openmemberdetailpage(component,event,helper,resultresp,caseobj,Interaction,oUser,CoveragesresultWrapper);
                }

            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } 
            }
        });
        $A.enqueueAction(action);
      
        

	},
    closeModel: function(component, event, helper) {
    //  component.set("v.isOpen", false);
    $A.get("e.force:closeQuickAction").fire();
   }
})