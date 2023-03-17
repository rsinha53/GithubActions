({
    sendParams : function(component, event, helper) {
        component.set("v.selectedStep" , "step1");
        
        var workspaceAPI = component.find("workspace");
        workspaceAPI.setTabLabel({                            
            label: 'Member Search'
        });
        
       
        var state = component.get("v.pageReference").state;
        var isCsMbr = state.c__isCaseMember;
        var origin=state.c__CaseOrigin;
        var email=state.c__CaseEmail;            
        var dermId=state.c__DermID;
        var caseId=state.c__recordId;
        var conId = state.c__conId;
		 var originEmail = state.c__originEmail;									   
        component.set('v.caseId',caseId);
        component.set('v.iscaserecord', isCsMbr);
        component.set('v.conId', conId);
        
        if(origin=="Phone" || origin=="Phone Call"){
        	component.set('v.showpopup', true);
            component.set("v.errorMessage", "Search Member is only available for email and web cases");
        }else{
        if(isCsMbr){  
            component.set('v.interactType',origin);
            if(origin == 'Email'){
                component.set('v.email', email);
                component.set('v.defaultValue',origin);
            }else if(origin == 'Web'){
			if(dermId != undefined && dermId != null && dermId != ""){
                   component.set('v.memberId',dermId); 
                }else if(originEmail != undefined && originEmail != null && originEmail != ""){
                   component.set('v.email', originEmail); 
                }   				
                component.set('v.defaultValue',origin);
            }
            
            component.set('v.defaultValue',origin);
        }else{
            component.set('v.defaultValue','Phone'); 
        }          
		  
        component.set("v.showAdvancedSearch", true);
        component.set("v.searchTypeLabel", 'Hide Advanced Search');
        component.set("v.searchStatus",true); 
           
                var intrecId = state.c__interaction;                
                
                }
    },
    onOriginatorChange: function(cmp,event,helper){
        var originatorval = cmp.find('OriginatorAndTopic').find('selOrginator').get("v.value");
		cmp.set('v.showError',false);
        var memFullName = cmp.get("v.FullName");
        if(originatorval==memFullName){
        	cmp.set("v.excFlow",'memberOrigin');
        }else{
            cmp.set("v.excFlow",'tpSelected');
        }
        
        if(!$A.util.isEmpty(originatorval)){
            cmp.set("v.originatorval",originatorval);
            cmp.set("v.originator", originatorval);   
        } else {            
            cmp.set("v.originator", "");	 
        }
    },
    updateCaseHelper : function(cmp,event,helper){
        var caseId = cmp.get("v.caseId");
        var topic = "Motion Inquiry";
        var caseTypeValue = cmp.find('typeid').get('v.value');
        var caseSubTypeValue = cmp.find('subtypeid').get('v.value');
        var typeid = cmp.find("typeid");
        var subtypeid = cmp.find("subtypeid");
        var subType = cmp.find('subtypeid').get('v.value');
        var typeOps = cmp.get("v.typeOptions");
        var subtypeOps = cmp.get("v.subtypeOptions");
        var followup = cmp.get("v.flwupRequired");
        var complaintChecked = cmp.get("v.complaintRequired");
        var migIssueChecked = cmp.get("v.migIssueRequired");
        var escalatedChecked = cmp.get("v.escalatedRequired");
        var disasterEpidemicValue = cmp.get('v.disasterEpidemicValue'); 
        var motionRecId = cmp.get('v.motionRecId');
		var tpRelation = cmp.get('v.tpRelation');
		var phone = cmp.get('v.phone');
        //call server action to update the case
        var action = cmp.get("c.updatedCase");
        action.setParams({
			FlowAddIndiv: cmp.get('v.FlowAddIndiv'),
			perAccId: cmp.get('v.perAccId'),
            phone : cmp.get('v.phone'),
            originator: cmp.get('v.originator'),
            tpId : cmp.get('v.tpId'),
			tpRelation: cmp.get('v.tpRelation'),									
            excFlow : cmp.get('v.excFlow'),
            interactionId: cmp.get('v.interactionId'),
            caseId : caseId,
            topic : topic,
            caseType : caseTypeValue,
            subtype: caseSubTypeValue,
            migIssueChecked : migIssueChecked,
            escalatedChecked : escalatedChecked,
            complaintChecked : complaintChecked,
            disasterEpidemicValue : disasterEpidemicValue,
            fullName : cmp.get('v.FullName'),
            SubjectType : cmp.get('v.SubjectType'),
            DOB : cmp.get('v.DOB'),
            email : cmp.get('v.email'),
            RegisterMemberId : cmp.get('v.RegisterMemberId'),
            EligibleMemberId : cmp.get('v.EligibleMemberId'),
            GroupName : cmp.get('v.GroupName'),
            GroupId : cmp.get('v.GroupId')
        });
       
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                
				  
                }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
        var conId = cmp.get('v.conId');
		var caseId = cmp.get('v.caseId');
        var workspaceAPI = cmp.find("workspace");
        
            if(!followup){
				workspaceAPI.getFocusedTabInfo().then(function(response){
                    var focusedTabId = response.tabId;
					workspaceAPI.closeTab({tabId: focusedTabId});
                });
				location.replace("/lightning/r/Case/"+caseId+"/view");
            }else{
                workspaceAPI.getEnclosingTabId().then(function(tabId) {
                if(conId==''){
					var url = "/lightning/o/Task/new?defaultFieldValues=WhatId="+caseId+"&recordTypeId="+motionRecId;
                    location.replace(url);					
                    /*workspaceAPI.openSubtab({
                        parentTabId: tabId,
                        url: '/lightning/o/Task/new?defaultFieldValues=WhatId='+caseId+'&recordTypeId='+motionRecId,
                        focus: true
                    });*/
                }else{
					var url = "/lightning/o/Task/new?defaultFieldValues=WhoId="+conId+",WhatId="+caseId+"&recordTypeId="+motionRecId;
                    location.replace(url);
                    /*workspaceAPI.openSubtab({
                        parentTabId: tabId,
                        url: '/lightning/o/Task/new?defaultFieldValues=WhoId='+conId+',WhatId='+caseId+'&recordTypeId='+motionRecId,
                        focus: true
                    });*/
                }
                workspaceAPI.getFocusedTabInfo().then(function(response){
                    var focusedTabId = response.tabId;
                    workspaceAPI.closeTab({tabId: focusedTabId});
                });
				 });
            }
    },
})