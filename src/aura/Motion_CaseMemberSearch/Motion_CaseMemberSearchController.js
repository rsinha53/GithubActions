({
    doInit : function(component, event, helper) {   
        helper.sendParams(component, event, helper);
       var action = component.get("c.getTaskRecordTypeId");
        action.setParams({
            tType : "Motion_Task"
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                component.set('v.motionRecId',result);
            }
        }); 
        $A.enqueueAction(action);
    },
	clearComp : function (cmp,event,helper){
        cmp.set('v.showSearchResults', false);
    },
    handleShowResultEvent : function(cmp, event, helper){
        cmp.set("v.showSearchResults",true);
        var headerOptions 		= event.getParam('headerOptions');
        var tablebody 			= event.getParam('tablebody');
        var tablePaginations 	= event.getParam('tablePaginations');
        var interactType 		= event.getParam('interactType');
        var searchType 			= event.getParam('searchType');
		
        cmp.set("v.headerOptions", headerOptions);
        cmp.set("v.tablebody", tablebody);
        cmp.set("v.tablePaginations", tablePaginations);
        cmp.set("v.interactType", interactType);
        cmp.set("v.searchType", searchType);
        cmp.set("v.pageNumber", tablePaginations.startNumber);
        cmp.set("v.maxPageNumber", tablePaginations.noOfPages);
		var tableWithHeadersCmp = cmp.find("searchResultId");
        tableWithHeadersCmp.refreshTable();
    },
    handleTableEvent : function(cmp, event, helper){
        var pageNum = event.getParam('requestedPageNumber');
        cmp.set("v.pageNum",pageNum);
        var srchType = event.getParam('requestedSearchType');
        var resultEvent = $A.get("e.c:MOTION_tableResultEvent");
        resultEvent.setParams({
            "requestedPageNumber" : pageNum,
            "requestedSearchType" : srchType
        });
        resultEvent.fire();	  
    },
    handleCaseMemberEvent:function(component, event, helper){
		
        var firstname = event.getParam('FirstName');
        var lastname =event.getParam("LastName");
        var fullname =event.getParam("FullName");
        var iscasemember = event.getParam("isCsMbr");
        component.set("v.FullName", fullname);
        component.set("v.SubjectType", event.getParam('SubjectType'));			
        component.set("v.DOB", event.getParam('DOB'));					
        component.set("v.RegisterMemberId", event.getParam('RegisterMemberId'));	
        component.set("v.EligibleMemberId", event.getParam('EligibleMemberId'));
        component.set("v.GroupId", event.getParam('groupNumber'));
        component.set("v.GroupName", event.getParam('GroupName'));
        component.set("v.email",event.getParam("email"));
		component.set("v.phone",event.getParam("phone"));
        var originators = [            
            { value:  (firstname+' '+lastname), label: (firstname+' '+lastname) },
            { value:  ('Third Party'), label: ('Third Party') },
        ];
            component.set("v.FamilyMembersList", originators);
            var interactType = component.get('v.interactType');
            var conId 		 = component.get('v.conId');
            
            var action = component.get("c.searchAndCreateMotionPersonAccount");
            action.setParams({
            	dermID: 			event.getParam('RegisterMemberId'),
            	memberEligibleId: 	event.getParam('EligibleMemberId'),
            	firstName: 			event.getParam('FirstName'),
            	lastName: 			event.getParam("LastName"),
            	memberEmail: 		event.getParam("email"), 
            	memberDob:			event.getParam('DOB'),
            	interactType: 		interactType,
            phoneNo : event.getParam('phone')
            });
            
            action.setCallback(this, function(response){
            var state = response.getState();
                if (state === "SUCCESS") {
                    var intResponse = JSON.parse(JSON.stringify(response.getReturnValue()));
                    var result = response.getReturnValue();
                    component.set("v.interaction", intResponse);
            		component.set("v.interactionId",intResponse.Id);
					component.set("v.perAccId",result.Originator__r.AccountId);
            		
                        if(result != null){   
                        var intthpid =  result.Originator__c;                    
                        var intthpval;
                            if(!$A.util.isEmpty(result.Originator_Name__c)){
                            	intthpval = result.Originator_Name__c;
                            }else{
                            	intthpval = result.Contact_Name__c;
                            }
                        //component.set("v.originatorId", intthpid);        //Harkunal:07/1/2021:DE461144:Commnented this line to avoid calling hadleOptionSelected method from ACETLGT_OriginatorAndTopic.
                        component.set("v.subjectID",intthpid );
                        component.set("v.orgid",intthpid );
                        }
                }
            });
            $A.enqueueAction(action);
            component.set("v.selectedStep", "step2");
            component.set('v.openOriginator',true);
      },            
            
    
    handleTPEvent:function(component, event, helper){
        var lblThirdParty = $A.get("$Label.c.ACETThirdParty");
        var isModal = event.getParam("isTPModalOpen");
        component.set("v.isTPModalOpen", isModal);
        var orgi = event.getParam("originator");  
        component.set("v.originatorId", orgi);
        var tpRel = event.getParam("tpRelation");
        component.set("v.tpRelation",tpRel);
        var isOrgiNotPresent = true;
        var famlist = component.get("v.FamilyMembersList");
		component.set("v.tpName",event.getParam("originator"));    
        component.set("v.tpRelation",event.getParam("tpRelation"));
        if(orgi != undefined && orgi != null && orgi != ''){
            	if(famlist != undefined && famlist != null && famlist != '')
            		famlist.splice(famlist.length - 1, 1);
			 
            	if(famlist != undefined){
            		famlist.forEach(function(element) {
            			if(element.value == orgi  )
            				isOrgiNotPresent = false;
						 
            		});
        		if(isOrgiNotPresent){
        			famlist.push( { value: orgi , label: orgi} );      
        		}        
        }
        if (famlist.filter(function(e) { return e.value === lblThirdParty; }).length <= 0) {
        
        famlist.push( { value: lblThirdParty , label: lblThirdParty} );	
        }
        component.set("v.FamilyMembersList", famlist);
        component.set("v.originator", orgi);
        if (orgi != lblThirdParty && component.get("v.originatorId")!=null && !component.get("v.originatorId").startsWith('003') ){
        component.set("v.originatorId", orgi);
        component.set("v.tpRelation",null);
        }
        if (orgi == lblThirdParty) {
        component.set("v.originatorId", null);  
        component.set("v.originator", null); 
        component.set("v.tpRelation",null);
        }     
        
        }else{
        component.set("v.originatorId", null);  
        component.set("v.originator", null); 
        component.set("v.tpRelation",null);
        }
        component.set("v.FamilyMembersList",famlist);
        
    },
    AddIndiv:function(cmp, event, helper){
        cmp.set('v.addIndiv', event.getParam('addIndiv'));
		cmp.set('v.showSearchResults' , false);
    },
    openAddIndiv:function(component,event,helper){       
														 
		   
    },
    onCreateAddIndiv:function(component, event, helper){
        component.set('v.FlowAddIndiv', true);
        var firstname = event.getParam('FirstName');
        var lastname = event.getParam('LastName');
        component.set("v.isMemberNotFound",			event.getParam('isMemberNotFound'));
        component.set("v.membernotfoundfirstName",	event.getParam('FirstName'));
        component.set("v.membernotfoundlastName",	event.getParam('LastName'));
        component.set("v.membernotfoundemailaddress",event.getParam('email'));
        component.set("v.membernotfoundphone",		event.getParam('phone'));
        component.set("v.membernotfoundgropname",	event.getParam('GroupName'));
        component.set("v.membernotfoundgroupnumber",event.getParam('groupNumber'));
        component.set("v.membernotfounddob",		event.getParam('DOB'));
        component.set("v.membernotfoundstate",		event.getParam('state'));
        component.set("v.membernotfoundzip",		event.getParam('zipcode'));
        component.set("v.membernotfoundinttype",	event.getParam('interactType'));
        
        var originators = [            
            { value:  (firstname+' '+lastname), label: (firstname+' '+lastname) },
            
        ];
        component.set("v.FamilyMembersList", originators);
        component.set("v.fastrrackflow", 'yes');
        component.set("v.excFlow",'tpSelected');
		 var fullname = component.get("v.membernotfoundfirstName")+' '+component.get("v.membernotfoundlastName");
            component.set("v.orgid",fullname);
			component.set("v.tpName",fullname);
            
            var action = component.get("c.getThirdparty");
                action.setParams({
                    firstName:component.get("v.membernotfoundfirstName"),
                    lastName:component.get("v.membernotfoundlastName"),
                    emailaddress:component.get("v.membernotfoundemailaddress"),
                    phone:component.get("v.membernotfoundphone"),
                    groupname:component.get("v.membernotfoundgropname"),
                    groupnumber:component.get("v.membernotfoundgroupnumber"),
                    dob:component.get("v.membernotfounddob"),
                    state:component.get("v.membernotfoundstate"),
                    zip:component.get("v.membernotfoundzip"),
                    inttype:component.get("v.membernotfoundinttype"),
                });
        
                action.setCallback(this, function (response) {
                    var state = response.getState();
                    if (state === "SUCCESS") {
                        var mDetails = response.getReturnValue();
            			component.set("v.interactionId",mDetails.InteractionRecord.Id);
            			component.set("v.tpId",mDetails.InteractionRecord.Third_Party__c);
                    }
                });
                $A.enqueueAction(action);
        
        component.set('v.selectedStep','step2');
        component.set('v.openOriginator',true);
        
	},							   
    onOriginatorChange: function(cmp,event,helper){
        helper.onOriginatorChange(cmp,event,helper);    	
    },
    handleCancel:function(component, event, helper){
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function(response){
            var focusedTabId = response.tabId;
            workspaceAPI.closeTab({tabId: focusedTabId});
        });
    },									 
    goToStep3:function(component, event, helper){
            
         var originatorval = component.find('OriginatorAndTopic').find('selOrginator').get("v.value");
         var memFullName = component.get("v.FullName");
		 var tpName = component.get("v.tpName");            
            if((originatorval===memFullName || originatorval===tpName) && originatorval != null){ 
					 component.set('v.selectedStep','step3');
                }else{
            		component.set('v.showError',true);
                }
        
        var action = component.get("c.getcaseTypes");
        action.setParams({
            topic : "Motion Inquiry"
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                 var result = response.getReturnValue();
                if(!$A.util.isEmpty(result) && !$A.util.isUndefined(result)){
                    var lst = ['None'];
                    component.set('v.subtypeOptions', lst );
                    for(var i=0; i < result.length; i++){
                        if (result[i] != "None" && result[i]!="*")
                        	lst.push(result[i]);
                    }    
                    component.set('v.typeOptions', lst );
                }
            }
        });
        $A.enqueueAction(action);
    },
    onTypeChange:function(cmp, event, helper){
        var caseType = cmp.find('typeid').get('v.value');
        var action = cmp.get("c.getCaseSubTypes");
        
        
        action.setParams({
            topic : "Motion Inquiry",
            subtype : caseType
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                
                if(!$A.util.isEmpty(result) && !$A.util.isUndefined(result)){
                    var lst = ['None'];
                    for(var i=0; i < result.length; i++){
                        if (result[i] != "None" && result[i]!="*")
                        	lst.push(result[i]);
                    }    
                    cmp.set('v.subtypeOptions', lst );
                }
            }
        });
        $A.enqueueAction(action);
    },
    onSubTypeChange:function(cmp, event, helper){
         
    },
    updateCase:function(cmp, event, helper){
    	helper.updateCaseHelper(cmp, event, helper);
	},
    closeModel:function(component,event,helper){
        component.set("v.showpopup",false);
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getEnclosingTabId().then(function(tabId) {
        	workspaceAPI.closeTab({
        	tabId: tabId
        	});
        });
	},
})