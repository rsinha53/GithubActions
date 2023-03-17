({
	
	fetchPlanWaiverRecords : function(component, event, helper){
		
		var dermId=component.get('v.registeredMemberId');
		var eligiblememberId=component.get('v.eligibleMemberId');
        var pageNum = component.get("v.pageNumbers");
        var actBtnFlag = component.get("v.actionBtnFlag")
        console.log('pageNum::'+pageNum);
        var action = component.get("c.fetchMemberPlainWaiverRecords");
		action.setParams({
			dermID:dermId,
			memberEligibleID:eligiblememberId,
           	reqPageNum:pageNum,
            isCheckboxDisabled : actBtnFlag
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
                console.log('state inside plan waiver'+ state);
				var pDetails = response.getReturnValue();                
                component.set("v.showPlanWaiverInfopanel",true);
                component.set("v.PlanWaiverInfocardDetails", pDetails);
				
				
			} else if (state === "INCOMPLETE") {
                console.log('state inside plan waiver'+ state);
				// do something
			} else if (state === "ERROR") {
                console.log('state inside plan waiver'+ state);
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
	},
    openTab: function(component, event, helper) {
        var origVal = component.get("v.originatorval");
        var topicVal = component.get("v.selectedLookUpRecords");
        var nmbr = component.get("v.isMemberNotFound");        
        if(nmbr){
            component.set("v.interaction", component.get("v.intrecord"));
            component.set("v.HighlightsInfocardDetails",component.get("v.memberNotFoundHighlightsPanel"));
            component.set("v.fullName", origVal);
            component.set("v.orgid",component.get("v.interaction").Id);
            console.log("org id for mbr not found"+component.get("v.orgid"));
        }        
        console.log('HighlightsInfocardDetails before open tab:'+ JSON.stringify(component.get("v.HighlightsInfocardDetails")));
        
        if ((origVal == undefined) && (topicVal.length < 1)) {
            component.set("v.topicError", "This field is required.");
            component.set("v.originatorError", "This field is required.");
        } else if (origVal == undefined) {
            component.set("v.originatorError", "This field is required.");
        } else if (topicVal.length < 1) {
            component.set("v.topicError", "This field is required.");
        } else if ((origVal != undefined) && (topicVal.length > 0)) {
            var workspaceAPI = component.find("workspace");
            workspaceAPI.openSubtab({
                pageReference: {
                    "type": "standard__component",
                    "attributes": {
                        "componentName": "c__MOTION_MemberInquiryTopicDetails"
                    },
                    "state": {                        
                        "c__HighlightsInfocardDetails": JSON.stringify(component.get("v.HighlightsInfocardDetails")),
                        "c__interaction": JSON.stringify(component.get("v.interaction")),
                        "c__fullName": component.get("v.fullName"),
                        "c__memberId": component.get("v.memberId"),
                        "c__originatorId":component.get("v.originatorId"),
                        "c__orgid" : component.get("v.orgid"),
                        "c__originator":component.get("v.originator"),
                        "c__isMemberNotFound":component.get("v.isMemberNotFound"),
                        "c__DermID":component.get("v.registeredMemberId"),
						"c__groupName":component.get("v.groupName"),
                    	"c__groupNo": component.get("v.groupNo"),
                    }
                },
                focus: true
            }).then(function(response) {
                console.log("tabid" + response);
                workspaceAPI.getTabInfo({
                    tabId: response
                }).then(function(tabInfo) {
                    var focusedTabId = tabInfo.tabId;
                    workspaceAPI.setTabLabel({
                        tabId: focusedTabId,
                        label: "Motion Inquiry"
                    });
                    workspaceAPI.setTabIcon({
                        tabId: focusedTabId,
                        icon: "",
                        //iconAlt: "Description"
                    });
                });
            }).catch(function(error) {
            });
        }
    },
	
    onOriginatorChange: function(cmp,event,helper){
	 var originatorPreVal = cmp.get("v.originator");
        var originatorVal = cmp.find('OriginatorAndTopic').find('selOrginator').get("v.value");
        
        if(originatorVal != null && originatorVal != undefined && originatorVal != "Third Party" && originatorPreVal != originatorVal){
			
            var interaction = cmp.get("v.interaction");
            var intId = null;
            if(interaction != null && interaction != undefined){
            	var intId = interaction.Id;
            }                        
            var orginRealVal = cmp.get("v.originatorReal");
            var memId = cmp.get("v.orgid");
            var subjectId = cmp.get("v.subjectID");

            if(originatorVal == orginRealVal && intId != null){
                var action = cmp.get("c.setMemInteractions");
            	action.setParams({
                	"intId": intId,
                	"memId": memId
            	});
            
            	action.setCallback(this, function(response) {
                	var state = response.getState();
                	if (state === "SUCCESS") {
                		var result = response.getReturnValue();
                    	console.log('Result: '+JSON.stringify(result));            
                	}
            	});
            	$A.enqueueAction(action);
                    
            } 
            else if(originatorVal != orginRealVal && intId != null){
                var action = cmp.get("c.setTPInteractions");
            	action.setParams({
                	"intId": intId,
                    "subjectId": subjectId,
                    "origVal": originatorVal
            	});
            
            	action.setCallback(this, function(response) {
                	var state = response.getState();
                	if (state === "SUCCESS") {
                		var result = response.getReturnValue();
                    	console.log('Result: '+JSON.stringify(result));            
                	}
            	});
            	$A.enqueueAction(action);
                               
        	} 
        }
             
        if(!$A.util.isEmpty(originatorVal)){ 
            cmp.set("v.originatorval",originatorVal);
            cmp.set("v.originator", originatorVal);
        } else {            
            cmp.set("v.originator", "");
        }        
		
    }

})