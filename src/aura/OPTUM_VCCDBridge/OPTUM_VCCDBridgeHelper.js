({
    /**
     * Acts as a helper for On Render Event Handler .
     *
     * @param objComponent To access dom elements.
     * @param objEvent To handle events.
     * @param objHelper To handle events.
     */
    onRenderHandler : function(objComponent, objEvent, objHelper) {
        if(($A.util.isUndefinedOrNull(objComponent.get("v.objUserRecord")) == true) ) {
            objHelper.getUserDetail(objComponent, objEvent, objHelper);
        }
    },

    /**
     * Acts as a helper for On Utility Info .
     *
     * @param objComponent To access dom elements.
     * @param objEvent To handle events.
     * @param objHelper To handle events.
     */
    getUtilityInfoHelper : function(objComponent, objEvent, objHelper) {
        const objUtilityAPI = objComponent.find("utilitybar");
        if(typeof objUtilityAPI !== "undefined" && objUtilityAPI !== null) {
            objUtilityAPI.getEnclosingUtilityId().then(function (strUtilityId) {
                objUtilityAPI.getUtilityInfo().then(function (objResponse) {
                    objUtilityAPI.setPanelHeight({
                        heightPX: 0
                    });
                    objUtilityAPI.disableUtilityPopOut({
                        disabled: true,
                        disabledText: "Pop-out is disabled"
                    });
                    objUtilityAPI.onUtilityClick({
                        eventHandler: function (objClickResponse) {
                            const objRecord = objComponent.get("v.objVCCDRecord");
                            if(($A.util.isUndefinedOrNull(objRecord) == false) && objRecord && objRecord.Id && objRecord.isActive__c === true) {
                                objUtilityAPI.setPanelHeight({
                                    heightPX: 200
                                });
                                objUtilityAPI.setPanelWidth({
                                    widthPX: 250
                                });
                            } else {
                                objUtilityAPI.setPanelHeight({
                                    heightPX: 500
                                });
                            }
                        }
                    });
                    if($A.get("$Label.c.OPTUMVCCDTrigger")!== "undefined" && $A.get("$Label.c.OPTUMVCCDTrigger")!== null && $A.get("$Label.c.OPTUMVCCDTrigger")== 'START' &&
                        $A.util.isUndefinedOrNull(objComponent.get("v.objUserRecord")) === false && objComponent.get("v.objUserRecord.User_Type__c") !== 'Development User') {
                        setInterval(function() {
                            try {
                                objHelper.getCurrentFocusedNavigationItem(objComponent, objEvent, objHelper);
                            } catch (exception) {
                                console.log(' exception ' + exception);
                            }
                        }, 5000);
                    }
                }).catch(function () {
                    //Do nothing.
                });
            }).catch(function () {
                //Do nothing.
            });
        }
    },

    /**
     * Gets the current focused navigation Item
     *
     * @param objComponent To access dom elements.
     * @param objEvent To handle events.
     * @param objHelper To handle events.
     */
    getCurrentFocusedNavigationItem : function(objComponent, objEvent, objHelper) {
        let objNavigationItemAPI = objComponent.find("navigationItem");
        if(typeof objNavigationItemAPI !== "undefined" && objNavigationItemAPI !== null) {
            objNavigationItemAPI.getSelectedNavigationItem().then(function(response) {
               
                if(typeof response !== "undefined" && response !== null) {

                    objHelper.pollApex(objComponent, objEvent, objHelper);
                }
            })
            .catch(function(error) {
                console.log(' Navigation Error ' + JSON.stringify(error));
            });
        }
    },
    /**
     * Acts as a helper for continous polling to Apex .
     *
     * @param objComponent To access dom elements.
     * @param objEvent To handle events.
     * @param objHelper To handle events.
     */
    pollApex : function(objComponent, objEvent, objHelper) {
        try {
            const objUtilityAPI = objComponent.find("utilitybar");
            console.log('### in polling ###');
            let action = objComponent.get("c.getVCCDData");
            action.setCallback(this, function(response) {
                let objResponse = response.getReturnValue();
               
                let objRecord = (objResponse != null ? objResponse.objVccdResponse : {});
                let objAttributeResponse = objComponent.get("v.objVCCDRecord");
                if(objResponse && objRecord && objRecord.Id && ($A.util.isUndefinedOrNull(objComponent.get("v.objVCCDRecord")) == true)) {
                    objComponent.set("v.objVCCDRecord", objRecord);
                    objHelper.handleResponse(objComponent, objEvent, objHelper);
                } else if (objResponse && objRecord && objRecord.Id && ($A.util.isUndefinedOrNull(objComponent.get("v.objVCCDRecord")) == false) && objRecord.Id != objAttributeResponse.Id) {
                    objComponent.set("v.objVCCDRecord", objRecord);
                    objHelper.handleResponse(objComponent, objEvent, objHelper);
                } else {
                    //Do Nothing
                }
            });
            $A.enqueueAction(action);
        }  catch (exception) {
            console.log(' exception ' + exception);
        }
    },

    /**
     * Used to Process the VCCD Response and fire the application event to pages.
     *
     * @param objComponent To access dom elements.
     * @param objEvent To handle events.
     * @param objHelper To handle events.
     */
    handleResponse : function(objComponent, objEvent, objHelper) {
        try {
            const objUtilityAPI = objComponent.find("utilitybar");
            let action = objComponent.get("c.updateCurrentRecordToInactive");
            if(objComponent.get("v.objVCCDRecord") == false && ($A.util.isUndefinedOrNull(objComponent.get("v.objVCCDRecord")) == true) ) {
                return;
            }
            action.setParams({"objVccdResponse": objComponent.get("v.objVCCDRecord")});
            action.setCallback(this, function(response) {
                try {
                    const state = response.getState();
                    if (state === 'SUCCESS') {

                        let strUtilityWidth, strCallToLength, strQuestionTypeLength;

                        objUtilityAPI.openUtility();

                        let objInterval = setInterval(function() {
                            try {
                                objUtilityAPI.getUtilityInfo().then(function(response) {
                                    if (response.utilityVisible) {
                                        strCallToLength = document.getElementById('idCallToInfo').offsetWidth;

                                        strQuestionTypeLength = document.getElementById('idQuestionTypeInfo').offsetWidth;

                                        strUtilityWidth = Math.max(strCallToLength, strQuestionTypeLength) + 80;

                                       objComponent.set("v.intWidth",strUtilityWidth);

                                        objUtilityAPI.setPanelHeight({
                                            heightPX: 200
                                        });

                                        objUtilityAPI.setPanelWidth({
                                            widthPX: strUtilityWidth
                                        });
                                    }

                                })
                                .catch(function(error) {
                                    console.log(error);
                                });
                            } catch(exception) {
                                clearInterval(objInterval);
                            }
                        }, 500);
                     
                        let objRecord = objComponent.get("v.objVCCDRecord");
                        let objMessage = {"isVCCD" : true , "objRecordData" : objRecord};
                        let appEvent = $A.get("e.c:OPTUM_VCCDRouting");
                        appEvent.setParams({"message" : JSON.stringify(objMessage)});
                        appEvent.fire();
                    }
                    if (state === 'ERROR') {
                        //Do Nothing
                    }
                } catch(exception) {
                    console.log('exception ' + exception);
                }
            });
            $A.enqueueAction(action);
        } catch(exception) {
            console.log(' Handle Response ' + exception);
        }
    },


    /**
     * Used to get Logged in user details.
     *
     * @param objComponent To access dom elements.
     */
    getUserDetail : function(objComponent, objEvent, objHelper) {
        let action = objComponent.get("c.getUserDetails");
        action.setCallback(this, function(response) {
            try {
                const state = response.getState();
                if(state === 'SUCCESS' &&  ($A.util.isUndefinedOrNull(response.getReturnValue()) == false)) {
                    objComponent.set("v.objUserRecord", response.getReturnValue());
                    objHelper.getUtilityInfoHelper(objComponent, objEvent, objHelper);
                }
            } catch (exception) {
                console.log(' User Info Exception ' + exeption);
            }
        });
        $A.enqueueAction(action);
    },


    openTab : function(component, event, helper,personAccId){
        var workspaceAPI = component.find("workspace");
        workspaceAPI.openTab({
            pageReference: {
                "type": "standard__recordPage",
                "attributes": {
                    "recordId":personAccId,
                    "actionName":"view"
                },
                "state": {
                }
            },
            focus: true
        }).then(function (response) {
            workspaceAPI.getTabInfo({
                tabId: response

            }).then(function (tabInfo) {
                var focusedTabId = tabInfo.tabId;
                var labelName = "Details-" + component.get("v.MemberDetails.member.lastName");
                workspaceAPI.setTabLabel({
                    tabId: focusedTabId,
                    label: labelName,
                });
                workspaceAPI.setTabIcon({
                    tabId: focusedTabId,
                    icon: "standard:contact_list",
                    iconAlt: "Member Overview"
                });
            });
        }).catch(function (error) {
            console.log(error);
        });

    } ,
    memberResults :function(objComponent, objEvent, objHelper) {
         var action = objComponent.get("c.getMemberDetails");
               action.setParams({
                 "faroId": objComponent.get("v.objVCCDRecord.FaroId__c")
                });
          action.setCallback(this, function(response) {
			   //Edited by Dimpy for DE446003 VCCD Component Error
                if(response!='' && !($A.util.isUndefinedOrNull(response)) && !($A.util.isUndefinedOrNull(response.getReturnValue()))){
            var state = response.getState(); //Checking response status
            var responseValue = JSON.parse(JSON.stringify(response.getReturnValue()));
            if ((state === "SUCCESS")&& (objComponent.isValid())){
                if(responseValue != null && !($A.util.isUndefinedOrNull(responseValue.result)) && !((Object.keys(responseValue.result).length)==0) && !($A.util.isUndefinedOrNull(responseValue.result.data)) && !((Object.keys(responseValue.result.data).length) == 0)) {
                    objComponent.set("v.MemberDetails", responseValue.result.data);
                    console.log("check response with Faro id",JSON.stringify(response.getReturnValue()));
                    //chnged by Dimpy
                    objHelper.addAccount(objComponent, objEvent, objHelper);
                }
            }   
        } });
      $A.enqueueAction(action);
     },
	 
	 addAccount: function (component, event, helper) {
        component.set("v.Spinner", true); 
        var action = component.get('c.addPersonAccount');
           action.setParams({
               "firstName": component.get("v.MemberDetails.member.firstName"),
               "lastName": component.get("v.MemberDetails.member.lastName"),
               "dob": component.get("v.MemberDetails.member.birthDate"),
               "eid": component.get("v.MemberDetails.member.faroId"),
			   "participantEmployeeExternalId":component.get("v.MemberDetails.accountDetails[0].accountId"),
               "participantEmployerCode":component.get("v.MemberDetails.accountDetails[0].accountAlias"),
               "participantAdminAlias":component.get("v.MemberDetails.accountDetails[0].employerAlias")

   
           });
   
           action.setCallback(this, function (response) {
               var state = response.getState(); // get the response state
                if (state == 'SUCCESS') {
                   var responseValue = JSON.parse(JSON.stringify(response.getReturnValue()));
                   var personAccId=responseValue.Id;// Added as part of US3329760 by Venkat
                   component.set("v.optumEID", component.get("v.MemberDetails.member.faroId"));
                   var actionAccount = component.get('c.createInteraction');
                   actionAccount.setParams({
                       "InteractionType": "Phone",
                       "OriginatorType": "Member",
                       "con": responseValue,
                       "Question": null,
                       "memberDetails":component.get("v.MemberDetails") // Added as part of US3329760 by Venkat
   
                   });
           actionAccount.setCallback(this, function (response) {
                       var state = response.getState(); // get the response state
   
                       if (state == 'SUCCESS') {
                        component.set("v.Spinner", false); 
                        var responseValue = JSON.parse(JSON.stringify(response.getReturnValue()));
                        component.set("v.optumInt", responseValue);
                        helper.openTab(component, event, helper,personAccId);// Added personAccId as part of US3329760 by Venkat
       }
               else if (state === "INCOMPLETE") {
                   alert("I am INCOMPLETE")
                   component.set("v.Spinner", false); 
               }
               else if (state === "ERROR") {
                   console.log("Unknown error");
                   component.set("v.Spinner", false); 
   
               }
           });
           $A.enqueueAction(actionAccount);
           }
           else if (state === "INCOMPLETE") {
                   alert("I am INCOMPLETE")
                   component.set("v.Spinner", false); 
               }
               else if (state === "ERROR") {
                   console.log("Unknown error");
                   component.set("v.Spinner", false); 
   
               }
                });
           $A.enqueueAction(action);
           
           }  
})