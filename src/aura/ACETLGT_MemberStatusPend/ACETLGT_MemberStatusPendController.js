({
    
   init: function(component, event, helper) {
      // for Display Model,set the "isOpen" attribute to "true"
      //component.set("v.isOpen", true);
      var grpId = component.get("v.groupNumber");
      var memId = component.get("v.memberId");
      console.log('~~~popup open open model'+grpId+'//'+memId);
      helper.getHoldRestrictions(component,event,helper,grpId,memId);
       
   },
 
   closeModal: function(component, event, helper) {
      component.set("v.openModal", false);
   },
   
   handleClick : function (cmp, event, helper) {
        console.log(cmp);
        console.log(event);
    }    
    
})