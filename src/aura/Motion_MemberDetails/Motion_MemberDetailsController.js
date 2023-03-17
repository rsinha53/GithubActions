({
   doInit : function(component, event, helper) {  
        var nonAvailMember=false;
        if (component.get("v.pageReference") != null){  
            var state = component.get("v.pageReference").state;
            var isCsMbr = state.c__isCaseMember;
            var elgmbrId = state.c__eligibleMemberId;
            var regmbrId=state.c__registeredMemberId;
            var tabname = state.c__name;
            var actionBtnFlag = state.c__actionFlag;
            if(actionBtnFlag == undefined){
                actionBtnFlag = false;
            }
            var intTp = state.c__interactionType;
            if(intTp == "Email" || intTp == "Web"){
                actionBtnFlag = true;
            }
            component.set("v.actionBtnFlag", actionBtnFlag);
            if(isCsMbr){
                component.set("v.isCsMbr", isCsMbr);
                component.set("v.showSave", false);
    			var workspaceAPI = component.find("workspace");
                        		
                workspaceAPI.getFocusedTabInfo().then(function(response) {
                var focusedTabId = response.tabId;
                workspaceAPI.setTabLabel({                                
                                label: tabname
                            });
        		})
            } 
            
            if((isCsMbr)&&((elgmbrId==null || elgmbrId=='')&& (regmbrId==null || regmbrId==''))) {
                nonAvailMember=true;
                component.set("v.showpopup",true);                
                component.set("v.showMemberDetailPage", false);
            }
            
        }
        if (component.get("v.pageReference") != null){            
            var importState = component.get("v.pageReference").state;
            component.set('v.isMemberNotFound',importState.c__isMemberNotFound);
            var memberNotFound=component.get('v.isMemberNotFound');
            var isCsMbr = component.get('v.isCsMbr');
            if(memberNotFound){
                component.set("v.fastrrackflow", 'yes');
            }
            component.set('v.intrecord',importState.c__interactionRec);           
            //component.set('v.interaction',importState.c__interactionRec);
            if((!memberNotFound || isCsMbr === true)&& nonAvailMember==false){                
                //var spinner = component.find("Spinner");
                //$A.util.removeClass(spinner, "slds-hide");
                component.set('v.fullName',importState.c__name);
                component.set('v.firstName',importState.c__firstName);
                component.set('v.lastName',importState.c__lastName);
                component.set('v.registeredMemberId',importState.c__registeredMemberId);
                component.set('v.eligibleMemberId',importState.c__eligibleMemberId);
                component.set('v.memberEmail',importState.c__memberEmail);
                component.set('v.memberDob',importState.c__memberDob);
                component.set('v.interactType',importState.c__interactionType); 
                component.set('v.showhighlightpanel',true);
                component.set('v.showdigitalpanel',true);
                component.set('v.showdeviceInfopanel',true);
                component.set('v.showdemographicsInfopanel',true);
                component.set('v.showPlanWaiverInfopanel',true);
                component.set('v.groupName',importState.c__groupName);
                component.set('v.groupNo',importState.c__groupNo);
                component.set('v.phoneNo',importState.c__phoneNo);
				
                //Originator component details
                var originators = [            
                    { value:  (component.get("v.firstName"))+' '+(component.get("v.lastName")), label: (component.get("v.firstName"))+' '+(component.get("v.lastName")) },
                    { value:  ('Third Party'), label: ('Third Party') },
                ];
                    var action = component.get("c.featchMemberInformation");
                    var dermId=component.get('v.registeredMemberId');
                    var eligiblememberId=component.get('v.eligibleMemberId');
                    var memberEmail=component.get('v.memberEmail');
                    var memberDob=component.get('v.memberDob');
                    var interactType=component.get('v.interactType');
					var phoneNo = component.get('v.phoneNo');
					if(interactType === 'Phone'){
                    interactType = 'Phone Call';
                    }							 
                    var lastName=component.get('v.lastName');
                    var firstName=component.get('v.firstName');
                    
                    //action for create account and interaction
                    var actionInt = component.get("c.searchAndCreateMotionPersonAccount");
                    actionInt.setParams({
                    dermID:dermId,
                    memberEligibleId:eligiblememberId,
                    firstName: firstName,
                    lastName: lastName,
                    memberEmail:memberEmail,
                    memberDob:memberDob,            
                    interactType:interactType,
					phoneNo:phoneNo					
                    });
                    actionInt.setCallback(this, function (response) {
                        var state = response.getState();
                        if (state === "SUCCESS") {
                        
                        //$A.util.addClass(spinner, "slds-hide");                        
                        var intResponse = JSON.parse(JSON.stringify(response.getReturnValue()));
                        var result = response.getReturnValue();                       
                        component.set("v.interaction", intResponse);
                        component.set("v.intName", intResponse.Name);
                        component.set("v.memberId", intResponse.Originator__r.AccountId);
                        //var famlist =[];
                        if(result != null){                        
                            var intthpid =  result.Originator__c;                    
                            var intthpval;
                            if(!$A.util.isEmpty(result.Originator_Name__c)){
                                intthpval = result.Originator_Name__c;
                            }else{
                                intthpval = result.Contact_Name__c;
                            }
                            // famlist.push( { value: intthpval , label: intthpval } );
                            //component.set("v.FamilyMembersList", famlist);
                            component.set("v.originatorId", intthpid);
                            component.set("v.subjectID",intthpid );
                            component.set("v.orgid",intthpid );
                            //component.set("v.originator", intthpid);
							//component.set('v.originatorReal',intthpval);
							component.set('v.originatorReal',intthpval);
                        }  
                        
                        } else if (state === "INCOMPLETE") {
                        // do something
                        } else if (state === "ERROR") {
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
				
    			var acBtnFg = component.get("v.actionBtnFlag");
    			//action for API call
    			action.setParams({
    				dermID:dermId,
    				memeligibleID:eligiblememberId,
    				lastName: lastName,
    				firstName: firstName,
    				interactType:interactType,
    				memberEmail:memberEmail,
    				memberDob:memberDob,
    				isCheckboxDisabled : acBtnFg
    			});              
    			action.setCallback(this, function (response) {
    				var state = response.getState();
    				if (state === "SUCCESS") {
    					//$A.util.addClass(spinner, "slds-hide");
    					var pDetails = response.getReturnValue();
    					component.set("v.cardDetails", pDetails.digitalThermoticesdetails);
    					component.set("v.DeviceInfocardDetails", pDetails.diviceInfodetails);
    					component.set("v.DemographicsInfocardDetails", pDetails.demographicdetails);
    					component.set("v.HighlightsInfocardDetails", pDetails.Hightpaneldetails);
    					if(!isCsMbr){
    					    component.set("v.showOriginator",true);
    					}
    					console.log('pDetails.Hightpaneldetails:'+JSON.stringify(pDetails.Hightpaneldetails));
        
    					component.set("v.PlanWaiverInfocardDetails", pDetails.PlanWaiverDetails);                  
        
    				} else if (state === "INCOMPLETE") {
    					// do something
    				} else if (state === "ERROR") {
    					var errors = response.getError();
    					if (errors) {
    						if (errors[0] && errors[0].message) {
    							console.log("Error message: " + errors[0].message);
    						}
    					} else {
        					console.log("Unknown error");
        				}
        			}
    
        		});
        		if(!component.get('v.isCsMbr')){
        			$A.enqueueAction(actionInt);
        		}
        		$A.enqueueAction(action);
        		var autodockey = regmbrId + elgmbrId + Date.now();
        		component.set('v.autodocUniqueId',autodockey); 

	}else{
    
    //var interactionrec=component.get('v.intrecord');
    component.set('v.firstName', importState.c__firstName);
    component.set('v.lastName',importState.c__lastName);
    component.set('v.membernotfoundfirstName',importState.c__firstName);
    component.set('v.membernotfoundlastName',importState.c__lastName);
    component.set('v.membernotfoundemailaddress',importState.c__emailaddress);
    component.set('v.membernotfoundphone',importState.c__phone);
    component.set('v.membernotfoundgropname',importState.c__groupname);
    component.set('v.membernotfoundgroupnumber',importState.c__groupnumber);
    component.set('v.membernotfounddob',importState.c__dob);
    component.set('v.membernotfoundstate',importState.c__state);
    component.set('v.membernotfoundzip',importState.c__zipcode);
    component.set('v.membernotfoundinttype',importState.c__inttype);
	component.set('v.groupNo',importState.c__groupnumber);
    component.set('v.groupName',importState.c__groupname);
    
    //Originator component details
    var originators = [            
        { value:  (component.get("v.firstName"))+' '+(component.get("v.lastName")), label: (component.get("v.firstName"))+' '+(component.get("v.lastName")), },                    
    ];        
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
        
                //$A.util.addClass(spinner, "slds-hide");
                //helper.hideSpinner(component);
                var mDetails = response.getReturnValue();
                
                component.set("v.intrecord",mDetails.InteractionRecord);
                console.log('Interaction record for mbr not found:'+JSON.stringify(mDetails.InteractionRecord));
                //var fullName = JSON.stringify(component.get("v.intrecord"));
                //fullName = fullName.Third_Party__r.First_Name__c + ' ' + fullName.Third_Party__r.LastName__c;                    	
                component.set("v.memberNotFoundHighlightsPanel", mDetails.highlightsPanelMemberNotFound);
                component.set("v.memberNotFoundGeneralInfoPanel", mDetails.generalInfoPanelMemberNotFound);
                component.set("v.highlightHeader",mDetails.highlightsHeader);                        
                component.set("v.isMemberNotFound",true);                        
                component.set("v.orgid", mDetails.InteractionRecord.Originator_Name__c);
                component.set("v.showOriginator",true);
         	}
        
        });
        $A.enqueueAction(action);
        //new code
        var autodockey = regmbrId + elgmbrId + Date.now();
		component.set('v.autodocUniqueId',autodockey);
		}
        }
        
        component.set("v.FamilyMembersList", originators);              
        },
		
        handleShowOriginatorErrstop: function(component,event,helper){
        	console.log('Inside handleShowOriginatorErrstop of Member details');
        	//component.set("v.showOriginatorErrorFired",true);
        	//alert('oroignator val'+ component.get('v.originatorval'));
        
        	if(component.get("v.originatorval") != null && component.get("v.originatorval") != undefined && component.get("v.originatorval")!='Third Party'){
        		component.set("v.isOrigSelected", true);
        	}
        	else{
        		component.set("v.isOrigSelected",false);
        		component.set("v.originatorval",undefined);
        	}	
        	if(component.get("v.isOrigSelected")=== false){
        		component.set("v.originatorError", "This field is required.");
        	}
        },
        
        onOriginatorChange: function(cmp,event,helper){
		helper.onOriginatorChange(cmp,event,helper);           
		},
        //Added to Create New Case
        handleOriginatorChangeEvent: function (cmp, event, helper) {
        // component.set("v.originatorId", event.getParam("valueSelected"));
        helper.onOriginatorChange(cmp,event,helper);
        
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
        onClickOfEnter : function(component,event, helper) {
        	if (event.which == 13){
        		console.log('hits :: '+component.find('GlobalAutocomplete').get("v.listOfSearchRecords"));      
        	}
        },
        openNewTab: function(component, event, helper){
        helper.openTab(component , event ,helper);
        },
        
        handleCaseEvent : function(cmp, event) {
        var isModal = event.getParam("isModalOpen");
        console.log("===>>>==3==>>>---"+ isModal);
        cmp.set("v.isModalOpen", isModal);
        },
        handleTPEvent : function(cmp, event) {
            var lblThirdParty = $A.get("$Label.c.ACETThirdParty");
            console.log('third party : ', lblThirdParty);
            var isModal = event.getParam("isTPModalOpen");
            var orgi = event.getParam("originator");
            var tpRel = event.getParam("tpRelation");
			var orginRealVal = cmp.get("v.originatorReal");										   
            console.log("===>>>==3==>>>---"+ isModal);
            console.log('orgi 1::tprel>>> '+orgi+tpRel);
            cmp.set("v.tpRelation",tpRel);
            cmp.set("v.isTPModalOpen", isModal);
            var isOrgiNotPresent = true;
            var famlist = cmp.get("v.FamilyMembersList");
            if(orgi != undefined && orgi != null && orgi != ''){
            	if(famlist != undefined && famlist != null && famlist != '')
            		famlist.splice(famlist.length - 1, 1);
            	if(famlist != undefined){
            		famlist.forEach(function(element) {
            			console.log('-----FULLNAME---->>'+element.value+'---orgi---->'+orgi);
            			if(element.value == orgi  )
            				isOrgiNotPresent = false;
                        //if(!element.value.startsWith('003')){
                        //    famlist.pop();
                        //}
						else{
                        //if(!element.value.startsWith('003')){
                        //    famlist.pop();
                        //}
                    	if(element.value != orginRealVal){
                            famlist.pop();
                        }
                    }
            	});								   
        		console.log('-----isOrgiNotPresent---->>'+isOrgiNotPresent);
        		if(isOrgiNotPresent){
        			famlist.push( { value: orgi , label: orgi} );      
        		}        
        }
        if (famlist.filter(function(e) { return e.value === lblThirdParty; }).length <= 0) {
        
        famlist.push( { value: lblThirdParty , label: lblThirdParty} );	
        }
        console.log('+++++++++++++ '+ famlist);
        console.log("v.originatorId +++++ "+ cmp.get("v.originatorId"));
        cmp.set("v.FamilyMembersList", famlist);
        cmp.set("v.originator", orgi);
        
        if (orgi != lblThirdParty && cmp.get("v.originatorId")!=null && !cmp.get("v.originatorId").startsWith('003') ){
        cmp.set("v.originatorId", orgi);
        cmp.set("v.tpRelation",null);
        }
        
        //Observation : 
        console.log('orgi :: '+orgi);
        if (orgi == lblThirdParty) {
        console.log('orgi 2:: '+orgi);
        cmp.set("v.originatorId", null);  
        cmp.set("v.originator", null); 
        cmp.set("v.tpRelation",null);
        }     
        
        console.log('originator and Id :: '+ cmp.get("v.originator") + ' :: '+cmp.get("v.originatorId"));
        //cmp.set("v.originatorId", orgi);
        }else{
        cmp.set("v.originatorId", null);  
        cmp.set("v.originator", null); 
        cmp.set("v.tpRelation",null);
        
        }
        },
        getResults : function(component,event,helper) {
      
        if(component.get('v.pagechange')==false){
        var pageNum = event.getParam('requestedPageNumber');
        component.set("v.pageNumbers",pageNum);        
        if(!$A.util.isEmpty(pageNum)) {                         
        helper.fetchPlanWaiverRecords(component, event, helper); 
        }
       
        } 
        component.set('v.pagechange',false);
    },
    setpage:function(component,event,helper){
        var changePage=event.getParam('pagechange');
        
        component.set("v.pagechange", changePage);
    }

})