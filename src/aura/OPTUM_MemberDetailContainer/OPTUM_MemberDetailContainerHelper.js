({
    fireEvent: function (component, event, helper) {
        var appEvent = $A.get("e.c:OPTUM_SelectedEventChild");
        appEvent.setParams({
            "accountList": component.get("v.accountList"),
            "index": component.get("v.rowIndex"), "accountType": component.get("v.accountType"),
            "autodocUniqueId": component.get("v.autodocUniqueId"), "autodocUniqueIdCmp":component.get("v.autodocUniqueIdCmp")
        });
        appEvent.fire();
    },
	openTab: function(component, event, helper) {
        var origVal = component.get("v.originatorval");
        var topicVal = component.get("v.selectedLookUpRecords");
		var workspaceAPI = component.find("workspace");
        if ((origVal == undefined) && (topicVal.length < 1)) {
            component.set("v.topicError", "Error: You must select a Topic.");
            component.set("v.showOriginatorErrorFired",true);
        }else if (origVal == undefined) {
            component.set("v.showOriginatorErrorFired",true);
        } else if (topicVal.length < 1) {
            component.set("v.topicError", "Error: You must select a Topic.");
        } else if ((origVal != undefined) && (topicVal.length > 0)) {
		//Added by Prasad-US3130966: Add 'Debit Cards' Topic in Originator section	
			 var GlobalAutocomplete = component.find('GlobalAutocomplete');
             var selectedTopicList = GlobalAutocomplete.get('v.lstSelectedRecords');
             var x;
             var topicArray = [];
           for(x in selectedTopicList){
                    topicArray[x] = selectedTopicList[x].Name;
                    if(selectedTopicList[x].Name === $A.get("$Label.c.ACETCallTopicViewClaims")){
			if(component.get("v.int.Originator__c") == undefined) {
            workspaceAPI.getEnclosingTabId().then(function (enclosingTabId) {
            workspaceAPI.openSubtab({
                parentTabId: enclosingTabId,
                pageReference: {
                    "type": "standard__component",
                    "attributes": {
                        "componentName": "c__OPTUM_NotionalClaimTransactions" // c__<comp Name>
                    },
                    "state": {
                        "c__acctType": component.get("v.accountList"),
                        "c__colorPalette": component.get("v.colorPalette"),
                        "c__memberDetail": component.get("v.memberDetails"),
			            "c__optumEID" : component.get("v.optumEID"),
                        "c__optumInt": component.get("v.optumInt"),
                        "c__userInfo" : component.get("v.userInfo"),
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
                        label: "Claims"
                    });
                    workspaceAPI.setTabIcon({
                        tabId: focusedTabId,
                        icon: "utility:description",
                        iconAlt: "Description"
                    });
                });
            }).catch(function(error) {
            });
            });
         }
         else {
            var tabUniqueKey = component.get("v.memberDetails.member.firstName")+ "ViewClaims";
            var foundTab = new Object();
            foundTab.tabId = '';
            foundTab.tabUrl = '';

            workspaceAPI.getAllTabInfo().then(function (response) {
                for (var i = 0; i < response.length; i++) {
                    var subtabArray = response[i].subtabs;
                    for (var j = 0; j < subtabArray.length; j++) {
                        var item = subtabArray[j];
                        if (item.pageReference.state.c__tabUniqueKey == tabUniqueKey) {
                            foundTab.tabId = subtabArray[j].tabId;
                            foundTab.tabUrl = subtabArray[j].url;
                            break;
                        }
                    }
                }
				if ( foundTab.tabId == '') {
				workspaceAPI.getEnclosingTabId().then(function (enclosingTabId) {
           		workspaceAPI.openSubtab({
                parentTabId: enclosingTabId,
                pageReference: {
                    "type": "standard__component",
                    "attributes": {
                        "componentName": "c__OPTUM_NotionalClaimTransactions" // c__<comp Name>
                    },
                    "state": {
                        "c__acctType": component.get("v.accountList"),
                        "c__colorPalette": component.get("v.colorPalette"),
                        "c__memberDetail": component.get("v.memberDetails"),
			            "c__optumEID" : component.get("v.optumEID"),
                        "c__optumInt": component.get("v.int"),
                        "c__userInfo" : component.get("v.userInfo"),
                         "c__tabUniqueKey": tabUniqueKey,
                    }
                },
                focus: true
            }).then(function(subtabId) {
                workspaceAPI.getTabInfo({
                    tabId: subtabId
                }).then(function(tabInfo) {
                    var focusedTabId = tabInfo.tabId;
                    workspaceAPI.setTabLabel({
                        tabId: subtabId,
                        label: "Claims"
                    });
                    workspaceAPI.setTabIcon({
                        tabId: subtabId,
                        icon: "utility:description",
                        iconAlt: "Description"
                    });
                });
            }).catch(function(error) {
            });
          	});
				  }else{
				   workspaceAPI.openSubtab({
                        url: foundTab.tabUrl,
                    }).then(function (response) {
                        workspaceAPI.focusTab({
                            tabId: foundTab.tabId
                        });
                    })
                    .catch(function (error) {
                    });
					}
            	});
            }
        }
		//Added by Prasad-US3130966: Add 'Debit Cards' Topic in Originator section	
		if(selectedTopicList[x].Name === $A.get("$Label.c.OptumCallTopicDebitCards")){
			    if(component.get("v.int.Originator__c") == undefined) {
            workspaceAPI.getEnclosingTabId().then(function (enclosingTabId) {
            workspaceAPI.openSubtab({
                parentTabId: enclosingTabId,
                pageReference: {
                    "type": "standard__component",
                    "attributes": {
                        "componentName": "c__OPTUM_ViewAllCards" // c__<comp Name>
                    },
                    "state": {
                        "c__acctType": component.get("v.accountList"),
                        "c__colorPalette": component.get("v.colorPalette"),
                        "c__memberDetail": component.get("v.memberDetails"),
			            "c__optumEID" : component.get("v.optumEID"),
                        "c__optumInt": component.get("v.optumInt"),
                        "c__userInfo" : component.get("v.userInfo"),
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
                        label: "Debit Cards"
                    });
                    workspaceAPI.setTabIcon({
                        tabId: focusedTabId,
                        icon: "custom:custom40",
                        iconAlt: "Debit Cards"
                    });
                });
            }).catch(function(error) {
            });
            });
         }
            else {
            var tabUniqueKeyDebitCard = component.get("v.memberDetails.member.firstName") + "DebitCards";
            var foundTabDebitCards = new Object();
            foundTabDebitCards.tabId = '';
            foundTabDebitCards.tabUrl = '';

            workspaceAPI.getAllTabInfo().then(function (response) {
                for (var i = 0; i < response.length; i++) {
                    var subtabArray = response[i].subtabs;
                    for (var j = 0; j < subtabArray.length; j++) {
                        var item = subtabArray[j];
                        if (item.pageReference.state.c__tabUniqueKey == tabUniqueKeyDebitCard) {
                            foundTabDebitCards.tabId = subtabArray[j].tabId;
                            foundTabDebitCards.tabUrl = subtabArray[j].url;
                            break;
                        }
                    }
                }
				if ( foundTabDebitCards.tabId == '') {
				workspaceAPI.getEnclosingTabId().then(function (enclosingTabId) {
           		workspaceAPI.openSubtab({
                parentTabId: enclosingTabId,
                pageReference: {
                    "type": "standard__component",
                    "attributes": {
                        "componentName": "c__OPTUM_ViewAllCards" // c__<comp Name>
                    },
                    "state": {
                        "c__acctType": component.get("v.accountList"),
                        "c__colorPalette": component.get("v.colorPalette"),
                        "c__memberDetail": component.get("v.memberDetails"),
			            "c__optumEID" : component.get("v.optumEID"),
                        "c__optumInt": component.get("v.int"),
                        "c__userInfo" : component.get("v.userInfo"),
                         "c__tabUniqueKey": tabUniqueKeyDebitCard,
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
                        label: "Debit Cards"
                    });
                    workspaceAPI.setTabIcon({
                        tabId: focusedTabId,
                        icon: "custom:custom40",
                        iconAlt: "Debit Cards"
                    });
                });
            }).catch(function(error) {
            });
            });
        	}else{
				   workspaceAPI.openSubtab({
                        url: foundTabDebitCards.tabUrl,
                    }).then(function (response) {
                        workspaceAPI.focusTab({
                            tabId: foundTabDebitCards.tabId
                        });
                    })
                    .catch(function (error) {
                    });
				}
            });
			}
          }
		}
	 }
    },

    fetchInteraction: function (component, event, helper) {
        var actionint = component.get('c.queryInteraction');
        actionint.setParams({
            InteractionId: component.get("v.optumInt.Id")

        });
        actionint.setCallback(this, function (response) {
            var state = response.getState(); // get the response state
            if (state == 'SUCCESS') {
                var responseValue = JSON.parse(JSON.stringify(response.getReturnValue()));
                var result = response.getReturnValue();
                component.set("v.int", responseValue);
                if (result != null)
                    component.set("v.intId", result.Id);
                var famlist = [];
                if (result != null) {

                    // var intthpid =  result.Originator__c; 
                    var intthpid = result.Third_Party__c;

                    var intthpval;
                    if (!$A.util.isEmpty(result.Originator_Name__c)) {
                        intthpval = result.Originator_Name__c;
                    } else {
                        intthpval = result.Contact_Name__c;
                    }
                    // famlist.push( { value: intthpval , label: intthpval } );
                    famlist.push({ value: intthpid, label: intthpval });
                   // component.set("v.OriginatorId", intthpid);

                }
            }
            else if (state === "INCOMPLETE") {
                alert("I am INCOMPLETE")
            }
            else if (state === "ERROR") {
                console.log("Unknown error");

            }

        });
        $A.enqueueAction(actionint);
    },
	//Added by Dimpy US2904971: Create New Case
     getUserInfo: function (component, event, helper) {
        var action = component.get("c.getUser");
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                component.set("v.userInfo", storeResponse);
            }
        });
        $A.enqueueAction(action);
    },
    //Added by Iresh DE411196: To fix the space between Middle name and Last name
     getMiddleName: function (component, event, helper) {
     	var middleName = (component.get("v.memberDetails.member.middleName"));
        if (typeof middleName !== "undefined" || middleName != null || !middleName ==="") {
        	component.set("v.middleName",middleName+" ");
         }
    },
	     
})