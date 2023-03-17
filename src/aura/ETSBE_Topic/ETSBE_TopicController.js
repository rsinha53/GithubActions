({
	doInit : function(component, event, helper) {
		var action = component.get("c.getUser");
		action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
            	var storeResponse = response.getReturnValue();
                component.set("v.userInfo", storeResponse);
                component.set("v.directionSearchType", "Business Unit");
        		//helper.searchDirectionRecords(component,helper);
        		var dropdownOptions = [];
        		dropdownOptions.push({
                    label: "None",
                    value: "None"
                });
        		component.set('v.topicOptions', {label: "Special Instructions",value: "Special Instructions"});
        		component.set('v.topicSelected','Special Instructions');
        		component.set('v.typeOptions', dropdownOptions);
        		component.set('v.subtypeOptions', dropdownOptions);
            }
        });
        $A.enqueueAction(action);
	},
    selectBusinessUnit: function(component,event,helper){
		helper.showSpinner(component);
		var dropdownOptions = [];
		dropdownOptions.push({
            label: "None",
            value: "None"
        });
		component.set('v.topicOptions', dropdownOptions);
		component.set('v.topicSelected', "None");
		component.set('v.typeOptions', dropdownOptions);
		component.set('v.typeSelected', "None");
		component.set('v.subtypeOptions', dropdownOptions);
		component.set('v.subtypeSelected', "None");
		//helper.clearInfoFields(component,helper);
		component.set("v.directionSearchType", "Topic");
		//helper.searchDirectionRecords(component,helper);
		//helper.hideSpinner(component);
	},
	selectTopic: function(component,event,helper){
		//helper.showSpinner(component);
		var dropdownOptions = [];
		dropdownOptions.push({
            label: "None",
            value: "None"
        });
		component.set('v.typeOptions', dropdownOptions);
		component.set('v.typeSelected', "None");
		component.set('v.subtypeOptions', dropdownOptions);
		component.set('v.subtypeSelected', "None");
		//helper.clearInfoFields(component,helper);
		component.set("v.directionSearchType", "Type");
		//helper.searchDirectionRecords(component,helper);
		//helper.hideSpinner(component);
	},
	openTopic: function(component,event,helper){
		console.log('HERE IS THE PASSED MEMBER: ' + JSON.stringify(component.get('v.memberData')));
		var interactionRec = component.get("v.interactionRec");        
        console.log('test'+component.get("v.ContactId"));
        
        var houseHoldList = component.get("v.houseHoldData");
        var memberRelationship = '';
        if(houseHoldList != undefined && houseHoldList != null && houseHoldList.length > 0) {
            for(var i=0; i<houseHoldList.length; i++) {
                if(houseHoldList[i].isMainMember == true) {
                    memberRelationship = houseHoldList[i].relationship;
                    break;
                }
            }    
        }
        
		var workspaceAPI = component.find("workspace");       
        workspaceAPI.openSubtab({
            pageReference: {
                "type": "standard__component",
                "attributes": {
                    "componentName": "c__ETSBE_SpecialInstructions"
                },
                "state": {
                	"c__InteractionRecord": interactionRec,
                    "c__GroupData": component.get('v.groupData'),
                    "c__MemberData": component.get('v.memberData'),
                     "c__producerData":component.get("v.producerData"),
                    "c__CustomerAdminData": component.get('v.customerAdminData'),
                    "c__FlowType":component.get("v.FlowType"),
                    "c__ContactId":component.get("v.ContactId"),
                    "c__MemberSubjectCardData":component.get("v.memberSubjCardData"),
                    "c__MemberRelationship":memberRelationship,
                    "c__SpecialInstructionInfo":component.get("v.specialInstructionsInfo"),
                    "c__isHouseHoldMemClicked":component.get("v.isHouseHoldMemClicked"),
                    "c__UpdateCaseInfo": component.get("v.updateCaseInfo"),
                    "c__UHGRestricted":component.get("v.uhgAccess")
                }
            },
            focus: true
        }).then(function(response) {
            
            workspaceAPI.getTabInfo({
                tabId: response
                
            }).then(function(tabInfo) {
                
                workspaceAPI.setTabLabel({
                    tabId: tabInfo.tabId,
                    label: 'Special Instructions'
                });
                workspaceAPI.setTabIcon({
                    tabId: tabInfo.tabId,
                    icon: "standard:people",
                    iconAlt: "Member"
                });
              
            });
        }).catch(function(error) {
                console.log(error);
        });
	}
})