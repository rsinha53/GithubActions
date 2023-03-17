({
	doInit : function(component,event,helper) {
		    if(screen.width < 500){
            component.set('v.isSmallScreen', true);
        }
        console.log(' isSmallScreen----'+component.get('v.isSmallScreen'));
        var selectFamId = component.get('v.familyId');
        console.log('care team selectFamId-----'+selectFamId);
        var action = component.get('c.getCareTeamMembers');
        action.setParams({
            "famAccId" : selectFamId  
        });
        action.setCallback(this, function(actionResult) {
             var stateResponse = actionResult.getState();
            if(stateResponse == 'SUCCESS') {
                var result = actionResult.getReturnValue();
               if(!result.ErrorOccured){
                    component.set('v.careTeamWrapperList', result.lstCareTeamWrap);
                    component.set('v.isFLAccOwner', result.isFLAccOwner);
                   console.log('pao check is'+JSON.stringify(component.get('v.isFLAccOwner')));
                    component.set('v.isFLAccOwnerCareTeamId', result.FLAccOwnerCtmId);
					component.set('v.flAccOwnerMemName', result.FLAccOwnerMemName);
					console.log('result.FLAccOwnerMemName='+result.FLAccOwnerMemName);
					console.log('result.FLAccOwnerMemName='+result.FLAccOwnerMemName);

                }else{
                    var urlEvent = $A.get("e.force:navigateToURL");
                    urlEvent.setParams({
                        "url": "/error"
                    });
                    urlEvent.fire(); 
                    
                }
            }
        });
        $A.enqueueAction(action); 
	},
    careTeamUpdate: function(component, event, helper){
       var careTeamId = component.get("v.careTeamId");
        var action = component.get("c.updateCareTeam");
        console.log('care team 11');
        action.setParams({
            "careTeamId" : careTeamId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                var responseVal =  response.getReturnValue();
                console.log('result'+responseVal);
                /*This below line checks whether an exception is caught in apex*/
                if(!responseVal.ErrorOccured){
                  helper.userUpdate(component, event, helper);
                } 
                else {
                  /*This Happens when a exception is caught in apex and redirects to error page*/
                  var urlEvent = $A.get("e.force:navigateToURL");
                  urlEvent.setParams({
                      "url": "/error"
                  });
                  urlEvent.fire();
                }
            }
        });
        $A.enqueueAction(action);
    },
    userUpdate : function(component,event,helper){
        var careTeamId = component.get("v.careTeamId");
        var careTeamMemId = component.get("v.careTeamMembId");
         var selectFamId = component.get('v.familyId');
        var action = component.get("c.updateUserRec");
        console.log('care team 11');
        action.setParams({
            "careTeamMemId" : careTeamMemId,
            "familyId" :selectFamId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                var responseVal =  response.getReturnValue();
                console.log('result'+responseVal);
                /*This below line checks whether an exception is caught in apex*/
                if(!responseVal.ErrorOccured){
                 component.set("v.isRemoveCnfrmModalOpen",false);
                 helper.doInit(component,event,helper);
                 var evt = $A.get("e.c:SNI_FL_RefreshView");
                 evt.fire();
                } 
                else {
                  /*This Happens when a exception is caught in apex and redirects to error page*/
                  var urlEvent = $A.get("e.force:navigateToURL");
                  urlEvent.setParams({
                      "url": "/error"
                  });
                  urlEvent.fire();
                }
            }
        });
        $A.enqueueAction(action);
    }
})