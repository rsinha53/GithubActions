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
            objHelper.getUserDetails(objComponent);
        }
        const objUtilityAPI = objComponent.find("utilitybar");
        if(typeof objUtilityAPI !== "undefined" && objUtilityAPI !== null) {
            objUtilityAPI.getEnclosingUtilityId().then(function (strUtilityId) {
                objUtilityAPI.getUtilityInfo().then(function (objResponse) {
                    objUtilityAPI.setPanelHeight({
                        heightPX: 100
                    }); 
                     objUtilityAPI.setPanelWidth({
                                    widthPX: 250
                                });
                    objUtilityAPI.disableUtilityPopOut({
                        disabled: true,
                        disabledText: "Pop-out is disabled"
                    });
                    objUtilityAPI.onUtilityClick({
                        eventHandler: function (objClickResponse) {
                            const objRecord = objComponent.get("v.objRecord");
                            if(($A.util.isUndefinedOrNull(objRecord) == false) && objRecord && objRecord.Id && objRecord.isActive__c === true) {  
                                objUtilityAPI.setPanelHeight({
                                    heightPX: 200
                                });
                                objUtilityAPI.setPanelWidth({
                                    widthPX: 250
                                });
                            } else {
                                objUtilityAPI.setPanelHeight({
                                    heightPX: 100
                                }); 
                                      objUtilityAPI.setPanelWidth({
                                    widthPX: 250
                                });
                            }
                        }
                    });
                    if($A.get("$Label.c.ACETLGTVCCDTrigger")!== "undefined" && $A.get("$Label.c.ACETLGTVCCDTrigger")!== null && $A.get("$Label.c.ACETLGTVCCDTrigger")== 'START'){
                        setInterval(function() {
                            try {
                            var checkCmp = objComponent.find("tglbtn").get("v.checked");
                                if(checkCmp == true){
                                objHelper.getCurrentFocusedNavigationItem(objComponent, objEvent, objHelper);
                                }
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
                console.log('response.developerName--->'+response.developerName);
                if(typeof response !== "undefined" && response !== null && response.developerName == 'LGT_Member_Search') {
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
                let CallTopicID = (objResponse != null ? objResponse.CallTopicID : {});
                let objAttributeResponse = objComponent.get("v.objVCCDRecord");
                if(objResponse && objRecord && objRecord.Id && ($A.util.isUndefinedOrNull(objComponent.get("v.objVCCDRecord")) == true)) {
                     objHelper.processvccdresponce(objComponent,objRecord,CallTopicID);
                    objComponent.set("v.objVCCDRecord", objRecord);
                    objHelper.handleResponse(objComponent, objEvent, objHelper);
                } else if (objResponse && objRecord && objRecord.Id && ($A.util.isUndefinedOrNull(objComponent.get("v.objVCCDRecord")) == false) && objRecord.Id != objAttributeResponse.Id) {
                    objHelper.processvccdresponce(objComponent,objRecord,CallTopicID);
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
                                    console.log('response.utilityVisible--->'+response.utilityVisible);
                                    if (response.utilityVisible) {
                                        debugger;
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
                        debugger;
                        if(objComponent.get("v.objVCCDRecord") && objComponent.get("v.objVCCDRecord.CreatedDate")) {
                            let lstDates = objComponent.get("v.objVCCDRecord.CreatedDate").split('T');
                            objComponent.set("v.strDate",lstDates[0]);
                        }
                        debugger;
                        let objRecord = objComponent.get("v.vccdParams");
                     if(!$A.util.isUndefinedOrNull(objRecord)){
                         
                        let appEvent = $A.get("e.c:ACETLGT_VCCDBridgeSuppEvent");
                        appEvent.setParams({"VCCDResponceObj" : objRecord});
                        appEvent.fire();
                                      }
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
    getUserDetails : function(objComponent) {
        let action = objComponent.get("c.getUserDetails");
        action.setCallback(this, function(response) {
            try {
                const state = response.getState();
                if(state === 'SUCCESS' &&  ($A.util.isUndefinedOrNull(response.getReturnValue()) == false)) {
                    objComponent.set("v.objUserRecord", response.getReturnValue());
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
            "developerName": "LGT_Member_Search"
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
    },    
    processvccdresponce : function(objComponent,vccdobj,CallTopicID) {
        var vccdParams = new Object();
          if(!$A.util.isUndefinedOrNull(vccdobj.QuestionType__c)){
               /* if(vccdobj.QuestionTypeCode__c == 'EL')
                vccdParams.callTopic = 'View Member Eligibility';
                else if(vccdobj.QuestionTypeCode__c == 'BE')
                vccdParams.callTopic = 'Plan Benefits';
                else if(vccdobj.QuestionTypeCode__c == 'NO')
                vccdParams.callTopic = 'View Authorizations';
                else if(vccdobj.QuestionTypeCode__c == 'CL')
                vccdParams.callTopic = 'View Claims';
                else if(vccdobj.QuestionTypeCode__c == 'RF')
                vccdParams.callTopic = 'View PCP Referrals';
                else if(vccdobj.QuestionTypeCode__c == 'ID')
                vccdParams.callTopic = 'Request ID Cards';
                else if(vccdobj.QuestionTypeCode__c == 'FI')
                vccdParams.callTopic = 'Consumer Accounts';
                else if(vccdobj.QuestionTypeCode__c == 'BL' || vccdobj.QuestionTypeCode__c == 'PI' || vccdobj.QuestionTypeCode__c == 'RP' || vccdobj.QuestionTypeCode__c == 'LP')
                vccdParams.callTopic = 'View Billing';
                else if(vccdobj.QuestionTypeCode__c == 'BC')
                vccdParams.callTopic = 'Commissions';*/
              vccdParams.callTopic = vccdobj.QuestionType__c;
                            }
        if(!$A.util.isUndefinedOrNull(CallTopicID)){
             vccdParams.CallTopicID = CallTopicID;
        }
              
			  if(!$A.util.isUndefinedOrNull(vccdobj.Caller_Type__c)){
                if(vccdobj.Caller_Type__c == 'MM')
                    vccdParams.CallerType = 'Member';
                if(vccdobj.Caller_Type__c == 'PV')
                    vccdParams.CallerType = 'Provider';
                if(vccdobj.Caller_Type__c == 'BA')
                    vccdParams.CallerType = 'Group';
                if(vccdobj.Caller_Type__c == 'BR')
                    vccdParams.CallerType = 'Producer';
					}			
		    if(!$A.util.isUndefinedOrNull(vccdobj.Ani__c)){
	              vccdParams.phone = vccdobj.Ani__c;
				  }
				  if(!$A.util.isUndefinedOrNull( vccdobj.MemberId__c)){
				  vccdParams.memberId =  vccdobj.MemberId__c;
                    }	
					if(!$A.util.isUndefinedOrNull( vccdobj.SubjectDOB__c)){
				  vccdParams.MemberDOB =  vccdobj.SubjectDOB__c;
                    }	
					if(!$A.util.isUndefinedOrNull( vccdobj.DOB__c)){
				  vccdParams.dob =  vccdobj.DOB__c;
                    }
					if(!$A.util.isUndefinedOrNull( vccdobj.QuestionTypeCode__c)){
				  vccdParams.QuestionType =  vccdobj.QuestionTypeCode__c;
                    }
					if(!$A.util.isUndefinedOrNull( vccdobj.Caller_Type__c)){
				  vccdParams.CallerType =  vccdobj.Caller_Type__c;
                    }
					if(!$A.util.isUndefinedOrNull( vccdobj.TaxId__c)){
				  vccdParams.TaxID =  vccdobj.TaxId__c;
                    }
					if(!$A.util.isUndefinedOrNull( vccdobj.NPI__c)){
				  vccdParams.npi =  vccdobj.NPI__c;
                    }
					if(!$A.util.isUndefinedOrNull( vccdobj.TFN__c)){
				  vccdParams.TFN =  vccdobj.TFN__c;
                    }
					if(!$A.util.isUndefinedOrNull( vccdobj.ClaimId__c)){
				  vccdParams.ClaimID =  vccdobj.ClaimId__c;
                    }
					if(!$A.util.isUndefinedOrNull( vccdobj.producerID__c)){
				  vccdParams.producerId =  vccdobj.producerID__c;
                    }
					if(!$A.util.isUndefinedOrNull( vccdobj.groupID__c)){
				  vccdParams.groupId =  vccdobj.groupID__c;
                    }
                 if(!$A.util.isUndefinedOrNull(vccdParams)){
					objComponent.set("v.vccdParams",vccdParams);
				   }
               if(!$A.util.isUndefinedOrNull( vccdobj.Ani__c)){
				  vccdParams.CallerID =  vccdobj.Ani__c;
                    }
                console.log(vccdParams);

        debugger;
        
    }

})