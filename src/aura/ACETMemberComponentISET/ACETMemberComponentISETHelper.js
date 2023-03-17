({
    callHouseHoldWS : function(component,event,helper) {
        var transactionId=component.get("v.tranId");
        if(transactionId){
            var action = component.get("c.getHouseHoldData");
            action.setParams({
                "transactionId": transactionId
            });
            action.setCallback(this, function(response) {
                var state = response.getState(); // get the response state
                if(state == 'SUCCESS') {
                    var result = response.getReturnValue();
                    console.log(result);
                    if(result.statusCode == 200){
                        helper.checkUhgAccess(component, event, helper, result);
                        //  helper.sniEligibilityCall(component, event, helper, result);
                    }else {
                        component.set('v.showServiceErrors', true);
                        if (component.get("v.showHideMemAdvSearch") == true && component.get("v.displayMNFFlag") == true) {
                            component.set("v.mnf", 'mnf');
                            component.set("v.checkFlagmeberCard",false); //Added By Avish on 07/25/2019
                        }
                        component.set('v.serviceMessage', result.message);
                        // If need
                        helper.fireToast(result.message);
                        helper.hideGlobalSpinner(component);// US2021959 :Code Added By Chandan
                    }
                } else {
                    helper.hideGlobalSpinner(component); // US2021959 :Code Added By Chandan
                }
            });
            
            $A.enqueueAction(action);
            
        }
        else{//Logic to display no active medical coverage
            helper.hideGlobalSpinner(component); // US2021959 :Code Added By Chandan
        }
    },
    checkUhgAccess: function (component, event, helper, result) {
        console.log('checkUhgAccess-------------');
        var plcId = '';
        for(var i=0; i< result.houseHoldResultWrapper.houseHoldList.length;i++){
            if(result.houseHoldResultWrapper.houseHoldList[i].isMainMember == true) {
                plcId = result.houseHoldResultWrapper.houseHoldList[i].policyId;
            }
        }
        // plcId = '0700416';
        var checkUhgAction = component.get("c.checkUHGaccess");
        checkUhgAction.setParams({"policyId" :plcId});
        checkUhgAction.setCallback(this, function(response1) {
            var state1 = response1.getState();
            if(state1 == 'SUCCESS') {
                var resultVal = response1.getReturnValue();
                if(resultVal){
                    helper.sniEligibilityCall(component, event, helper, result);
                }
                else{
                    component.set('v.showServiceErrors', true);
                    if (component.get("v.showHideMemAdvSearch") == true && component.get("v.displayMNFFlag") == true) {
                        component.set("v.mnf", 'mnf');
                        component.set("v.checkFlagmeberCard",false);
                    }
                    component.set('v.serviceMessage', 'You do not have access to view UHG policy member');
                    helper.fireToast('You do not have access to view UHG policy member');
                    helper.hideGlobalSpinner(component);
                }
            }
            else{
                var errMsg = 'Unexpected error occurred. Please try again.';
                component.set('v.showServiceErrors', true);
                if (component.get("v.showHideMemAdvSearch") == true && component.get("v.displayMNFFlag") == true) {
                    component.set("v.mnf", 'mnf');
                    component.set("v.checkFlagmeberCard",false);
                }
                component.set('v.serviceMessage', errMsg);
                helper.fireToast(errMsg);
                helper.hideGlobalSpinner(component);
            }
        })
        $A.enqueueAction(checkUhgAction);
        
    },
    sniEligibilityCall: function (component, event, helper, result) {
        console.log('sniEligibilityCall func starts-----');
        var houseDetail = component.find('house');
        var memberDOBVal;
        var memberIdVal;
        var memberFNVal;
        var memberLNVal;
        var action1 = component.get("c.findSNIDetails");
        var householdlist = result.houseHoldResultWrapper.houseHoldList.length;
        var plcId = '';
        console.log(result.houseHoldResultWrapper.houseHoldList);
        for(var i=0; i< result.houseHoldResultWrapper.houseHoldList.length;i++){
            
            if(result.houseHoldResultWrapper.houseHoldList[i].isMainMember == true) {
                plcId = result.houseHoldResultWrapper.houseHoldList[i].policyId;
                memberFNVal = result.houseHoldResultWrapper.houseHoldList[i].firstName;
                memberLNVal = result.houseHoldResultWrapper.houseHoldList[i].lastName;
                memberDOBVal = result.houseHoldResultWrapper.houseHoldList[i].dob;
                memberIdVal = result.houseHoldResultWrapper.houseHoldList[i].memberId;
            }
        }
        
        //console.log('memberIdVal---- '+memberIdVal+';plcId---- '+plcId+';memberFNVal-----'+memberFNVal+';memberLNVal---- '+memberLNVal+';inputMemberDOB----- '+memberDOBVal);
        if(plcId && memberIdVal && memberDOBVal && memberFNVal && memberLNVal)	{
            
            var policyIdVar;
            plcId = plcId.toString();
            if (plcId.length < 9) {
                policyIdVar = ('0000000000' + plcId).slice(-9);
            }
            else{
                policyIdVar = plcId;
            }
            action1.setParams({
                "memberId": memberIdVal,
                "policyId" :policyIdVar,
                "firstName": memberFNVal,
                "lastName": memberLNVal,
                "memDob": memberDOBVal
            });
            
            action1.setCallback(this, function(response1) {
                var state1 = response1.getState();
                if(state1 == 'SUCCESS') {
                    var result1 = response1.getReturnValue();
                    if(result1.statusCode == 200){
                        var sniEligible = result1.SNIresultWrapper.sniEligibility;
                        var advFullName = result1.SNIresultWrapper.advisorFullName;
                        var assignedToVal = result1.SNIresultWrapper.assignedTo;
                        console.log('assignedToVal----------'+assignedToVal);
                        //if(sniEligible != null && sniEligible != '' && typeof sniEligible != 'undefined' && sniEligible != 'not eligible' ){ //add one more condition here
                        if(sniEligible){
                            houseDetail.createAccount(result.houseHoldResultWrapper.houseHoldList,memberDOBVal,memberIdVal,advFullName,sniEligible,policyIdVar,plcId,assignedToVal);
                        }
                         // US2216710 :Code Added By Chandan-start
                        if(sniEligible && sniEligible=='not eligible'){
                            component.set("v.showSpinner",false);
                            component.set("v.houseHoldData",result.houseHoldResultWrapper.houseHoldList);
                            console.log("v.houseHoldData in sniEligibilityCall");
                            console.log(component.get("v.houseHoldData"));
                            component.set("v.advFullName",advFullName);
                            component.set("v.assignedToVal",assignedToVal);
                        }
                        // US2216710 :Code Added By Chandan-End
                         component.set("v.showSpinner",false);
                    }
                    else {
                        
                        component.set('v.showServiceErrors', true);
                        if (component.get("v.showHideMemAdvSearch") == true && component.get("v.displayMNFFlag") == true) {
                            component.set("v.mnf", 'mnf');
                            component.set("v.checkFlagmeberCard",false);
                        }
                        component.set('v.serviceMessage', result1.message);
                        helper.fireToast(result1.message);
                        helper.hideGlobalSpinner(component);  // US2021959 :Code Added By Chandan-start
                    }
                    
                }else{
                    helper.hideGlobalSpinner(component); // US2021959 :Code Added By Chandan
                }
            });
        }
        else{
            
            var errMsg = 'Unexpected error occurred. Please try again.';
            component.set('v.showServiceErrors', true);
            if (component.get("v.showHideMemAdvSearch") == true && component.get("v.displayMNFFlag") == true) {
                component.set("v.mnf", 'mnf');
                component.set("v.checkFlagmeberCard",false);
            }
            component.set('v.serviceMessage', errMsg);
            helper.fireToast(errMsg);
            helper.hideGlobalSpinner(component); // US2021959 :Code Added By Chandan
        }
        console.log('SNI Action starts-----');
        $A.enqueueAction(action1);
        
    },
    fireToast: function (message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Error!",
            "message": message,
            "message": message,
            "type": "error",
            "mode": "sticky"
        });
        toastEvent.fire();
    },
    fireToastMessage: function (title, message, type, mode, duration) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type": type,
            "mode": mode,
            "duration": duration
        });
        toastEvent.fire();
    },
    // US2021959 :Code Added By Chandan -Start
    // Show Spinner method
    showGlobalSpinner: function (component) {
        var spinner = component.find("global-spinner");
        $A.util.removeClass(spinner, "slds-hide");
        $A.util.addClass(spinner, "slds-show");
        component.set("v.showSpinner",true);
    },//Hide Spinner method
    hideGlobalSpinner: function (component) {
        var spinner = component.find("global-spinner");
        $A.util.removeClass(spinner, "slds-show");
        $A.util.addClass(spinner, "slds-hide");
        component.set("v.showSpinner",false);
        var workspaceAPI = component.find("workspace");
                
                workspaceAPI.getAllTabInfo().then(function(response) {
                console.log('tab response=');
                console.log(response);
                console.log('tab title='+response[0].title);
                if(response.length>0){
                for(var i=0; i< response.length;i++){
                 if(response[i].title == 'Loading...') {
                     workspaceAPI.closeTab({
                        tabId: response[i].tabId
                    });
                  }
                 }
                }
                }).catch(function(error) {
                         console.log(error);
                })
        //return null;
    }
})