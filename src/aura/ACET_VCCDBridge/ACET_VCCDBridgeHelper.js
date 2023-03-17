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
                                    heightPX: 0
                                });
                            }
                        }
                    });
                    if($A.get("$Label.c.ACETVCCDEngineTrigger")!== "undefined" && $A.get("$Label.c.ACETVCCDEngineTrigger")!== null && $A.get("$Label.c.ACETVCCDEngineTrigger")== 'START' &&
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
                if(typeof response !== "undefined" && response !== null && response.developerName !== objComponent.get("v.strNavigationBarLabel")) {
                    objComponent.set("v.strNavigationBarLabel",response.developerName);
                    objComponent.set("v.objVCCDRecord", null);
                }
                if(typeof response !== "undefined" && response !== null && response.developerName == 'Explore') {

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
                    objComponent.set("v.strQuestionType",objResponse.strCallTopicType);
                    objHelper.handleResponse(objComponent, objEvent, objHelper);
                } else if (objResponse && objRecord && objRecord.Id && ($A.util.isUndefinedOrNull(objComponent.get("v.objVCCDRecord")) == false) && objRecord.Id != objAttributeResponse.Id) {
                    objComponent.set("v.objVCCDRecord", objRecord);
                    objHelper.handleResponse(objComponent, objEvent, objHelper);
                    objComponent.set("v.strQuestionType",objResponse.strCallTopicType);
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
                        if(objComponent.get("v.objVCCDRecord") && objComponent.get("v.objVCCDRecord.CreatedDate")) {
                            let lstDates = objComponent.get("v.objVCCDRecord.CreatedDate").split('T');
                            objComponent.set("v.strDate",lstDates[0]);
                        }
                        let objRecord = objComponent.get("v.objVCCDRecord");
                        let objMessage = {"isVCCD" : true , "objRecordData" : objRecord};
                        let appEvent = $A.get("e.c:ACET_VCCDInBoundRouting");
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


    /**
     * Used to Set setSelectedNavigationItem Explore.
     *
     * @param objComponent To access dom elements.
     */
    setSelectedNavigationItemHelper : function(objComponent) {
        let navigationItemAPI = objComponent.find("navigationItem");
        navigationItemAPI.setSelectedNavigationItem({
            "developerName": "Explore"
       }).then(function(response) {
            navigationItemAPI.focusNavigationItem().then(function(response) {
                console.log(response);
            })
            .catch(function(error) {
                console.log(error);
            });
        })
        .catch(function(error) {
            console.log(error);
        });
    }
})