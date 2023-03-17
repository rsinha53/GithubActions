({
	myAction : function(component, event, helper) {
       helper.doInit(component,event,helper);
    },
	refreshCmp : function(component, event,helper) { 
       
       var isRefresh = event.getParam("isRefresh"); 
        console.log('isRefresh------'+isRefresh);
        if(isRefresh){
           helper.doInit(component,event,helper);
        }
        component.set("v.isAddFamilymemModalOpen",false);
        component.set("v.isInviteModalOpen",false);
        component.set("v.isEditInvite",false);
        component.set("v.isViewAuthFormModalOpen",false);
    },
	showCareTeamPopup : function(component, event, helper) {
		component.set("v.careTeamMembfrstName",null);
        component.set("v.careTeamMemblstName",null);
        component.set("v.careTeamMembId",null);
        component.set("v.careTeamMemDob",null);
        component.set("v.isAddFamilymemModalOpen",true);
    },
	showCareTeamPopuponEdit : function(component, event, helper){
        var dataEle = event.target.getAttribute("data-selected-Index");
        var careTeam = component.get("v.careTeamWrapperList");
        if(careTeam.length > 0){
            
           component.set("v.careTeamMembfrstName",careTeam[dataEle].membfrstname);
           component.set("v.careTeamMemblstName",careTeam[dataEle].memblstname);
           component.set("v.careTeamMembId",careTeam[dataEle].membId);
           component.set("v.careTeamMemDob",careTeam[dataEle].personDob);
        }
        component.set("v.isAddFamilymemModalOpen",true);
    },
	redirectToRoi: function(component, event,helper) { 
         var dataEle = event.getParam("ctMemDataIndex"); 
		 var userExist = event.getParam("userExist");
         var careTeam = component.get("v.careTeamWrapperList");
         component.set("v.careTeamMemberName",careTeam[dataEle].name);
         component.set("v.careTeamId",careTeam[dataEle].Id);
         component.set("v.isInvited",true); 
		 component.set("v.userExist",userExist);
         component.set("v.openSignAuth",true);
        
    },
    setCurrentFamily : function(component, event,helper) { 
	var selectFamId = event.getParam("familyAccId"); 
        component.set('v.familyId',selectFamId);
        helper.doInit(component,event,helper);
       // var selectFamId = event.getParam("familyAccId"); 
       // console.log('care team event ----'+selectFamId);
       /*
        var selectFamId = event.getParam("familyAccId"); 
       var action = component.get('c.getCareTeamMembers');
        action.setParams({
            "famAccId" : selectFamId  
        });
        action.setCallback(this, function(actionResult) {
            console.log('stateResponse--actionResult---'+actionResult);
            var stateResponse = actionResult.getState();
            console.log('stateResponse---'+stateResponse);
            if(stateResponse == 'SUCCESS') {
                var result = actionResult.getReturnValue();
                console.log('error occured value---'+result.ErrorOccured);
                if(!result.ErrorOccured){
                     console.log('care team list value---'+result.lstCareTeamWrap);
                 
                    component.set('v.careTeamWrapperList', result.lstCareTeamWrap);
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
        */
    },
    removeWarningPopUp : function(component, event, helper){
        var dataEle = event.target.getAttribute("data-selected-Index");
        var careTeam = component.get("v.careTeamWrapperList");
        for (var i = 0; i < careTeam.length; i++) {
            if(careTeam[i].primaryCaregiver){
                component.set("v.careTeamName",careTeam[i].name);
            }
        }
        console.log('log'+careTeam[dataEle].name);
        component.set("v.careTeamMemberName",careTeam[dataEle].name);
        component.set("v.careTeamId",careTeam[dataEle].Id);
        component.set("v.careTeamMembId",careTeam[dataEle].membId);
        component.set("v.isRemoveCnfrmModalOpen",true);
    },
    closeWarning :function(component, event,helper){
        component.set("v.isRemoveCnfrmModalOpen",false);
    },
    removeMember : function(component, event, helper){
       helper.careTeamUpdate(component, event, helper);
        
    },
    invitePopUp : function(component, event, helper){
        var dataEle = event.target.getAttribute("data-selected-Index");
        var careTeam = component.get("v.careTeamWrapperList");
        component.set("v.careTeamMemberName",careTeam[dataEle].name);
        component.set("v.careTeamId",careTeam[dataEle].Id);
        component.set("v.careTeamMembfrstName",careTeam[dataEle].membfrstname);
        component.set("v.careTeamMemblstName",careTeam[dataEle].memblstname);
        component.set("v.careTeamMembId",careTeam[dataEle].membId);
		component.set("v.ctEmail",'');
        component.set("v.typeOfInvite",'invite');
        component.set("v.isEditInvite",false);
        component.set("v.ctMemDataIndex",dataEle);
        component.set("v.isInviteModalOpen",true);
    },
    resendInvitePopUp : function(component, event, helper){
        var dataEle = event.target.getAttribute("data-selected-Index");
        var careTeam = component.get("v.careTeamWrapperList");
        component.set("v.careTeamMemberName",careTeam[dataEle].name);
        component.set("v.careTeamId",careTeam[dataEle].Id);
        component.set("v.careTeamMembfrstName",careTeam[dataEle].membfrstname);
        component.set("v.careTeamMemblstName",careTeam[dataEle].memblstname);
        component.set("v.careTeamMembId",careTeam[dataEle].membId);
        component.set("v.ctEmail",careTeam[dataEle].email);
        component.set("v.isEditInvite",true);
        component.set("v.typeOfInvite",'resendInvite');
        component.set("v.isInviteModalOpen",true);
        
    },
    editInvitePopUp : function(component, event, helper){
        var dataEle = event.target.getAttribute("data-selected-Index");
        var careTeam = component.get("v.careTeamWrapperList");
        component.set("v.careTeamMemberName",careTeam[dataEle].name);
        component.set("v.careTeamId",careTeam[dataEle].Id);
        component.set("v.careTeamMembfrstName",careTeam[dataEle].membfrstname);
        component.set("v.careTeamMemblstName",careTeam[dataEle].memblstname);
        component.set("v.careTeamMembId",careTeam[dataEle].membId);
        component.set("v.ctEmail",careTeam[dataEle].email);
        component.set("v.isEditInvite",true);
        component.set("v.typeOfInvite",'editInvite');
        component.set("v.ctMemDataIndex",dataEle);
        component.set("v.isInviteModalOpen",true);
    },
    openSignAuthUp : function(component, event, helper){
        var dataEle = event.target.getAttribute("data-selected-Index");
        var careTeam = component.get("v.careTeamWrapperList");
        component.set("v.careTeamMemberName",careTeam[dataEle].name);
        component.set("v.careTeamId",careTeam[dataEle].Id);
        component.set("v.careTeamperMemAdd",careTeam[dataEle].personMemID);
        component.set("v.careTeamMemDob",careTeam[dataEle].personDob);
        component.set("v.careTeamMemAdd",JSON.stringify(careTeam[dataEle].MailAdd));
        component.set("v.openSignAuth",true); 
    },
    viewAuthForm : function(component, event, helper){
        var dataEle = event.target.getAttribute("data-selected-Index");
        var careTeam = component.get("v.careTeamWrapperList");
        component.set("v.careTeamMemberName",careTeam[dataEle].name);
        component.set("v.careTeamId",careTeam[dataEle].Id);
		component.set("v.careTeamperMemAdd",careTeam[dataEle].personMemID);
        component.set("v.careTeamMemDob",careTeam[dataEle].personDob);
        component.set("v.careTeamMemAdd",JSON.stringify(careTeam[dataEle].MailAdd));
        component.set("v.isViewAuthFormModalOpen",true); 
    }
    
})