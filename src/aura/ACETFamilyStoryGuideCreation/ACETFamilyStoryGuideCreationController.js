({
    init : function(component, event, helper) {
        
        helper.doInit(component, event, helper);
        helper.getUserProfile(component, event, helper);
        var action = component.get("c.getUhgOnshoreRestriction");
         var recordId = component.get("v.recordId");
        console.log("record id in init "   +recordId);
         action.setParams({
                "accountId" :recordId
            });
        action.setCallback(this, function(response){
            var stateResponse = response.getState();
            if(stateResponse == 'SUCCESS') {
                
                var result = response.getReturnValue(); 
                console.log("Result in COntroller Init" + result);
                if(result != '' && result){
                    component.set("v.userRestriction",result);
                }
            }
        });
        $A.enqueueAction(action);
        
    },
    handleReviewClick: function(component, event, helper) {
        var popval = component.get("v.statusVal");
        if(popval != '' && popval == 'showPopup'){
            component.set("v.ShowModule", true);
        }
        else{
         var fsgRecordId = component.get("v.fsgRecordId");
         var evt = $A.get("e.force:navigateToComponent");
             evt.setParams({
                componentDef : "c:ACETFamilyStoryGuideUI",
                componentAttributes: {    
                    fsgId : fsgRecordId
                }
             });
             evt.fire();
        }
    },
    handleSaveChanges : function(component, event, helper) {
        console.log('handleSaveChanges ---------');
        var selVal = component.get("v.selValue");
        var fsgRecordId = component.get("v.fsgRecordId");
        //console.log('selVal ---------'+selVal);
        var recordId = component.get("v.recordId");
		if(selVal){
			if(selVal == 'No' || selVal == 'Later'){
				var action = component.get("c.createFSG"); 
				action.setParams({
					"selectVal": selVal,
					"accountId" :recordId,
					"fsgRecordId" : fsgRecordId
				});
				action.setCallback(this, function(response1) {
					//console.log('handleSaveChanges ----success-----');
					component.set("v.ShowModule", false);
					$A.get('e.force:refreshView').fire();
					
				});
			   helper.doInit(component, event, helper);
			   $A.get('e.force:refreshView').fire(); 
			   $A.enqueueAction(action); 
			}
			else{
				component.set("v.ShowModule", false);
			   // $A.get('e.force:refreshView').fire();
				 var evt = $A.get("e.force:navigateToComponent");
				 evt.setParams({
					componentDef : "c:ACETFamilyStoryGuideUI",
					componentAttributes: {    
						fsgId : fsgRecordId
					}
				 });
				 evt.fire();
					
			}
		}
    },
    handleCancel : function(component, event, helper) {
        // component.set("v.ShowModule", false);
        //  $A.get('e.force:refreshView').fire();
    },
    /*
    handleYes : function(component, event, helper) {
         component.set("v.ShowModule", false);   
        // $A.get('e.force:refreshView').fire();
    },
    handleNo : function(component, event, helper) {
      component.set("v.ShowModule", false);
       //  $A.get('e.force:refreshView').fire();
    },
    handleLater : function(component, event, helper) {
      component.set("v.ShowModule", false);
       //  $A.get('e.force:refreshView').fire();
    }
    */
    handleClick : function(component, event, helper){
        component.set("v.ShowModule", true);
    },
    
    closeModal : function(component, event, helper){
		component.set("v.selValue", '');
        component.set("v.ShowModule", false);
    },
    handleSubmit : function(component, event, helper){
        var eventFields = event.getParam('fields');
        component.find('fsgForm').submit(eventFields);
    },
    handleLoad : function(component, event, helper){
        
    },
    isRefreshed: function(component, event, helper) {
        location.reload();
    }
})