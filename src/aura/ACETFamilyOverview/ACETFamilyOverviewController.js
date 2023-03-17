({
   HideMe: function(component, event, helper) {
    //  component.set("v.ShowModule", false);
   },
   ShowModuleBox: function(component, event, helper) {
      component.set("v.ShowModule", true);
   },
   handleOnSubmit: function(component, event, helper) {
     component.set("v.ShowModule",false);
     $A.get('e.force:refreshView').fire();
   },
   handleOnError: function(component, event, helper) {
     helper.fireToast('This is a globally restricted group. You are not able to change owner to this user.');
     component.set("v.ShowModule",false);
   },
   doInit: function(component, event, helper) {
         console.log('family over view entered--------------');
         var action1 = component.get("c.getAccountFamilyOverview");
        action1.setParams({
             "accId": component.get("v.recordId")
        });
        action1.setCallback(this, function(response1) {
            var state1 = response1.getState();
             console.log('family over view state1--------------'+state1);
            if(state1 == 'SUCCESS') {
                var result1 = response1.getReturnValue();
                console.log('family over view result1--------------'+result1);
                if(result1 != '' && result1){
                    console.log('family over view--------------');
                    component.set("v.famOverId",result1);
                    component.set("v.ShowModule",true);
                    
                }
            }
        });
       $A.enqueueAction(action1);
   }
})