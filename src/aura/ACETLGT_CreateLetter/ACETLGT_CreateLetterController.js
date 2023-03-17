({
    doInit: function(component, event, helper) {
        var fulfillmentId = component.get('v.recordId');
        if (fulfillmentId != null && fulfillmentId != 'undefined') {
            component.set('v.letterCreated', true);
            var action = component.get("c.getFulfillmentInfo");
            action.setParams({
                fulfillmentId: fulfillmentId
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var storeResponse = response.getReturnValue();
                    var letter = JSON.parse(storeResponse.letter);
                    component.set('v.letter', letter);

                    var action2 = component.get("c.getCaseFromId");
                    action2.setParams({
                        caseId: letter.Case__c
                    });
                    action2.setCallback(this, function(response) {
                        var state = response.getState();
                        if (state === "SUCCESS") {
                            component.set("v.record", response.getReturnValue());
                        }
                    });
                    $A.enqueueAction(action2);
                    if (letter.Letter_Status__c == 'Canceled') {
                        component.set('v.letterCancelled', true);
                    } else if (letter.Letter_Status__c == 'Submitted') {
                        component.set('v.letterSubmitted', true);
                    } else if (letter.Letter_Status__c == 'Pending Fulfillment') {
                        component.set('v.letterReviewed', true);
                    }
                    component.set('v.Template_Name', letter.Letter_Name__c);
                    component.set('v.Delivery_Method_1', letter.Delivery_Method_1__c);
                    component.set('v.Delivery_Method_2', letter.Delivery_Method_2__c);
                    component.set('v.First_Name', letter.Recipient_Name__c);
                    component.set('v.Middle_Name', letter.Recipient_MI__c);
                    component.set('v.Last_Name', letter.Recipient_Last_Name__c);
                    component.set('v.Suffix', letter.Recipient_Suffix__c);
                    component.set('v.Modified_By', storeResponse.modifiedBy);
                    component.set('v.Submitted_By', storeResponse.submittedBy);
                    //                    alert(storeResponse.letter);

                }
            });
            $A.enqueueAction(action);
        } else {


            if (component.get("v.pageReference") != null) {
                var pagereference = component.get("v.pageReference");
                var caseId = pagereference.state.c__caseId;
                component.set("v.caseId", caseId);
                var action = component.get("c.getCaseFromId");
                action.setParams({
                    caseId: caseId
                });
                action.setCallback(this, function(response) {
                    var state = response.getState();
                    if (state === "SUCCESS") {
                        component.set("v.record", response.getReturnValue());
                      helper.templatenamesHelper(component,event,helper,response.getReturnValue().ServiceLevel__c);
                    }
                });
                $A.enqueueAction(action);
            }
        }
    },
    onChange_Delivery_Method: function(component, event, helper) {
        var delivery1 = component.get('v.Delivery_Method_1');
        var delivery2 = component.get('v.Delivery_Method_2');
               if(delivery2 != null && delivery2.length > 0 && delivery2 != delivery1){
       
var deliveryMethodform = component.find('deliveryMethodform');
 var deliveryMethodrequired = component.find('deliveryMethodrequired');
 var deliveryMethodmessageelement = component.find('deliveryMethodmessageelement');
            if(!$A.util.isEmpty(deliveryMethodform)){
                debugger;
                $A.util.removeClass(deliveryMethodform, 'slds-has-error');
                $A.util.removeClass(deliveryMethodrequired, 'slds-required');
                $A.util.addClass(deliveryMethodmessageelement, 'slds-hide');
            } 
            var deliveryMethod2form = component.find('deliveryMethod2form');
 var deliveryMethod2required = component.find('deliveryMethod2required');
 var deliveryMethod2messageelement = component.find('deliveryMethod2messageelement');
            if(!$A.util.isEmpty(deliveryMethod2form)){
                $A.util.removeClass(deliveryMethod2form, 'slds-has-error');
                $A.util.removeClass(deliveryMethod2required, 'slds-required');
                $A.util.addClass(deliveryMethod2messageelement, 'slds-hide');
            } 
            
        }
    },
    onclick_Create: function(component, event, helper) {
        var templateName;
        var Template_Name_temp = component.find("templateName").get("v.value")
        if(!$A.util.isUndefinedOrNull(Template_Name_temp)){
            templateName = Template_Name_temp;
        }else{
            templateName = component.get('v.Template_Name');
        }
        var delivery1 = component.get('v.Delivery_Method_1');
        var delivery2 = component.get('v.Delivery_Method_2');
        var firstName = component.get('v.First_Name');
        var middleName = component.get('v.Middle_Name');
        var lastName = component.get('v.Last_Name');
        var suffix = component.get('v.Suffix');
        var caseRecord = component.get("v.record");
        if(delivery2 != null && delivery2.length > 0 && delivery2 == delivery1){
       
var deliveryMethodform = component.find('deliveryMethodform');
 var deliveryMethodrequired = component.find('deliveryMethodrequired');
 var deliveryMethodmessageelement = component.find('deliveryMethodmessageelement');
            if(!$A.util.isEmpty(deliveryMethodform)){
                debugger;
                $A.util.addClass(deliveryMethodform, 'slds-has-error');
                $A.util.addClass(deliveryMethodrequired, 'slds-required');
                $A.util.removeClass(deliveryMethodmessageelement, 'slds-hide');
            } 
            var deliveryMethod2form = component.find('deliveryMethod2form');
 var deliveryMethod2required = component.find('deliveryMethod2required');
 var deliveryMethod2messageelement = component.find('deliveryMethod2messageelement');
            if(!$A.util.isEmpty(deliveryMethod2form)){
                $A.util.addClass(deliveryMethod2form, 'slds-has-error');
                $A.util.addClass(deliveryMethod2required, 'slds-required');
                $A.util.removeClass(deliveryMethod2messageelement, 'slds-hide');
            } 
            
        }
        else if (templateName != null && templateName.length > 0 && firstName != null && firstName.length > 0 && delivery1 != null && delivery1.length > 0 && lastName != null && lastName.length > 0) {
            component.set("v.Loadingspinner", true);
            if (delivery2 == null || delivery2 == '') {
                delivery2 = '--None--';
            }
            if (delivery1 == 'US Mail') {
                delivery1 = 'Mail';
            }
            if (delivery2 == 'US Mail') {
                delivery2 = 'Mail';
            }
            var action = component.get("c.createLetter");
            action.setParams({
                caseId: caseRecord.Id,
                templateName: templateName,
                deliveryMethod1: delivery1,
                deliveryMethod2: delivery2,
                firstName: firstName,
                middleName: middleName,
                lastName: lastName,
                suffix: suffix
            });
            action.setCallback(this, function(response) {
                component.set("v.Loadingspinner", false);
                var state = response.getState();
                console.log('............CreateLetter state ' + state)
                if (state === "SUCCESS") {
                    var storeResponse = response.getReturnValue();
                    if (storeResponse.result != null) {
                        var result = JSON.parse(storeResponse.result);
                        console.log(JSON.stringify(result));
                        if (result.Success == true) {
                            var letter = JSON.parse(storeResponse.letter);
                            console.log(JSON.stringify(letter));
                            component.set('v.letter', letter);
                            component.set('v.letterCreated', true);
                            helper.refreshCaseSubtab(component, event, helper);
                        } else {
                            helper.toastmessagehelper(component, event, helper, 'Error',storeResponse.errorMessage, 'error');
                        }
                    }
                } else {
                    helper.toastmessagehelper(component, event, helper, 'Error', 'Unexpected error occurred. Please try again. If problem persists, please contact the help desk.', 'error');
                }
            });
            component.set("v.Loadingspinner", true);
            $A.enqueueAction(action);
        } else {
       
var templateName = component.find('templateName');
            if(!$A.util.isEmpty(templateName)){
                            templateName.focus();
            }
            var deliveryMethod1 =  component.find('deliveryMethod1');
            if(!$A.util.isEmpty(deliveryMethod1)){
                          deliveryMethod1.focus(); 
            }
            var firstName =   component.find('firstName');
            if(!$A.util.isEmpty(firstName)){
                           firstName.focus(); 
            }
            var lastName =  component.find('lastName');
            if(!$A.util.isEmpty(lastName)){
                          lastName.focus();
            }
            var createLetter =  component.find('createLetter');
            if(!$A.util.isEmpty(createLetter)){
                           createLetter.focus();
            }
        }
    },

    onclick_Review_Edit: function(component, event, helper) {
        var letterid = component.get("v.letter").Id;
        var action = component.get("c.getEngageOneUrl");
        action.setParams({
            letterid: letterid
        });
        action.setCallback(this, function(response) {
            component.set("v.Loadingspinner", false);
            var state = response.getState();
            console.log('............CreateLetter state ' + state)
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                console.log(storeResponse.letter);
                console.log(storeResponse.modifiedBy);
                console.log(storeResponse.engageOneUrl);
                if (storeResponse.letter != null) {
                    component.set('v.letter', JSON.parse(storeResponse.letter));
                    component.set('v.Modified_By', storeResponse.modifiedBy);
                    component.set('v.engageOneUrl', storeResponse.engageOneUrl);
                    helper.openEngageOne(component, event, helper);
                    component.set('v.letterReviewed', true);
                }
            } else {
                helper.toastmessagehelper(component, event, helper, 'Error', 'Unexpected error occurred. Please try again. If problem persists, please contact the help desk.', 'error');
            }
        });
        component.set("v.Loadingspinner", true);
        $A.enqueueAction(action);
    },

    onclick_Cancel: function(component, event, helper) {
        var letterid = component.get("v.letter").Id;
        var action = component.get("c.cancelLetter");
        action.setParams({
            letterid: letterid
        });
        action.setCallback(this, function(response) {
            component.set("v.Loadingspinner", false);
            var state = response.getState();
            console.log('............CreateLetter state ' + state)
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                
                if (storeResponse.cancelResult == 'true') {
                    component.set('v.letter', JSON.parse(storeResponse.letter));
                    component.set('v.letterCancelled', true);
                    helper.refreshCaseSubtab(component, event, helper);
                    var workspaceAPI = component.find("workspace");
                    setTimeout(function() {
                        //                    alert('closing letters');
                        workspaceAPI.getFocusedTabInfo().then(function(response) {
                            var focusedTabId = response.tabId;
                            workspaceAPI.closeTab({
                                tabId: focusedTabId
                            });
                        });
                    }, 30);

                } else {
                    var errorMessage = storeResponse;
                    helper.toastmessagehelper(component, event, helper, 'Error',errorMessage.errorMessage, 'error');
                }
            } else {
                helper.toastmessagehelper(component, event, helper, 'Error', 'Unexpected error occurred. Please try again. If problem persists, please contact the help desk.', 'error');
            }
        });
        component.set("v.Loadingspinner", true);
        $A.enqueueAction(action);
    },

    onclick_Submit: function(component, event, helper) {
        var letterid = component.get("v.letter").Id;
        var action = component.get("c.submitLetter");
        action.setParams({
            letterid: letterid
        });
        action.setCallback(this, function(response) {
            component.set("v.Loadingspinner", false);
            var state = response.getState();
            console.log('............CreateLetter state ' + state)
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                console.log(storeResponse.letter);
                if (storeResponse.submitResult == 'true') {
                    component.set('v.letter', JSON.parse(storeResponse.letter));
                    component.set('v.Submitted_By', storeResponse.submittedBy);
                    //                    var result = JSON.parse(storeResponse.result);
                    //                    helper.toastmessagehelper(component, event, helper, 'Success', result.Message, 'success');
                    component.set('v.letterSubmitted', true);
                    helper.refreshCaseSubtab(component, event, helper);
                    var workspaceAPI = component.find("workspace");
                    setTimeout(function() {
                        //                    alert('closing letters');
                        workspaceAPI.getFocusedTabInfo().then(function(response) {
                            var focusedTabId = response.tabId;
                            workspaceAPI.closeTab({
                                tabId: focusedTabId
                            });
                        });
                    }, 30);
                } else {
                  debugger;
                   var errorMessage = storeResponse;
                    helper.toastmessagehelper(component, event, helper, 'Error', errorMessage.errorMessage, 'error');
                }
            } else {
                helper.toastmessagehelper(component, event, helper, 'Error', 'Unexpected error occurred. Please try again. If problem persists, please contact the help desk.', 'error');
            }
        });
        component.set("v.Loadingspinner", true);
        $A.enqueueAction(action);
    }

})