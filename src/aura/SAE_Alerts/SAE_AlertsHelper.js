({
    getAlertsFromObject_old: function (component, event, helper) {
        var taxId = component.get("v.taxId");
        var providerId = component.get("v.providerId");
        var memberId = component.get("v.memberId");
        var groupId = component.get("v.groupId");
        var noProvider = component.get("v.isProviderSearchDisabled");
        var noMember = component.get("v.noMemberToSearch");
        var pnf  = component.get("v.providerNotFound");
        var mnf = component.get("v.memberNotFound");
        var isOther = component.get("v.isOtherSearch");
        
        var tempArray = [];
        
        var action = component.get("c.getAlertsData");
        action.setCallback(this, function(a) {
            var result = a.getReturnValue();
            for(var i in result){
                console.log('Type::'+result[i].Type__c);
                if(result[i].Type__c == 'Provider' || result[i].Type__c == 'Provider Group'){
                    if(!$A.util.isEmpty(result[i].Effective_Date__c) && !$A.util.isEmpty(result[i].End_Date__c)){
                        if(result[i].Effective_Date__c < result[i].End_Date__c){
                            if((!$A.util.isEmpty(taxId) && taxId == result[i].Group_Number__c) || (!$A.util.isEmpty(providerId) && providerId == result[i].ID_Number__c)) {
                                tempArray.push(result[i]);                                
                            } 
                        }
                    } 
                }
            }
            component.set('v.getAlertsData', tempArray);
            component.set("v.alertsSize", tempArray.length);
            if(tempArray.length > 0){
                this.createInteractionAlertHelper(component,tempArray);
                if(noProvider){
                    component.set("v.isMemberAlertModalOpen",false);
                }else if(isOther){
                    component.set("v.isMemberAlertModalOpen",false);
                } else {
                    component.set("v.isMemberAlertModalOpen", true);
                }
            }
        });
        $A.enqueueAction(action);
    },

    // Optimized Function
    getAlertsFromObject: function (component, event, helper) {
        var taxId = component.get("v.taxId");
        var providerId = component.get("v.providerId");
        var noProvider = component.get("v.isProviderSearchDisabled");
        var isOther = component.get("v.isOtherSearch");

        var action = component.get("c.getAlertsIO");
        action.setParams({
            "groupNumber": taxId,
            "providerId": providerId

        });
        action.setCallback(this, function (a) {
            var tempArray = a.getReturnValue();
            component.set('v.getAlertsData', tempArray);
            component.set("v.alertsSize", tempArray.length);
            if (tempArray.length > 0) {
                if (noProvider) {
                    component.set("v.isMemberAlertModalOpen", false);
                } else if (isOther) {
                    component.set("v.isMemberAlertModalOpen", false);
                } else {
                        component.set("v.isMemberAlertModalOpen",true);
                    }  
                this.createInteractionAlertHelper(component, tempArray);
            }
        });
        $A.enqueueAction(action);
    },

    getAlertOnClickPolicy_old: function (component, event) {
        var policyMemberId = component.get("v.policyMemberId");
        var taxId = component.get("v.taxId");
        var providerId = component.get("v.providerId");
        var policyGroupId = component.get("v.policyGroupId");
        var lastGroupNo = component.get("v.lastGroupNo");
        var groupId = component.get("v.groupId");
        if(groupId != policyGroupId){
            component.set("v.groupId",policyGroupId);
            component.set("v.taxId",taxId);
            component.set("v.providerId",providerId);
            component.set("v.lastGroupNo",policyGroupId);
            var isProvider = component.get("v.isProvider");
            var isProviderSnapshot = component.get("v.isProviderSnapshot");
            var isMemberSnapshot = component.get("v.isMemberSnapshot");
            var noMember = component.get("v.noMemberToSearch");
            var alertsSize = component.get("v.alertsSize");
           
            var mnf = component.get("v.memberNotFound");
            
            var tempArray = [];
            
            var action = component.get("c.getAlertsData");
            action.setCallback(this, function(a) {
                var result = a.getReturnValue();
                for(var i in result){
                    if(!$A.util.isEmpty(result[i].Effective_Date__c) && !$A.util.isEmpty(result[i].End_Date__c)){
                        if(result[i].Effective_Date__c < result[i].End_Date__c){
                            if ((!$A.util.isEmpty(policyMemberId) && policyMemberId == result[i].ID_Number__c) ||
                                (!$A.util.isEmpty(taxId) && taxId == result[i].Group_Number__c) ||
                                (!$A.util.isEmpty(providerId) && providerId == result[i].ID_Number__c) ||
                                (!$A.util.isEmpty(policyGroupId) && policyGroupId == result[i].Group_Number__c)) {
                                tempArray.push(result[i]);
                                console.log('policyMemberId---'+policyMemberId);
                            } 
                        }
                    }
                    
                }
                component.set('v.getAlertsData', tempArray);
                component.set("v.alertsSize", tempArray.length);
                if(tempArray.length >0){
                    this.createInteractionAlertHelper(component,tempArray);
                    if(isProvider){
                        component.set("v.isMemberAlertModalOpen",false);
                    }
                    else if(isMemberSnapshot && mnf != 'mnf'){
                        for(var i in result){
                            if(result[i].Effective_Date__c < result[i].End_Date__c){
                                if((!$A.util.isEmpty(policyMemberId) && policyMemberId == result[i].ID_Number__c) || (!$A.util.isEmpty(policyGroupId) && policyGroupId == result[i].Group_Number__c)){
                                    component.set("v.isMemberAlertModalOpen",true);
                                    return false;
                                }else{
                                    component.set("v.isMemberAlertModalOpen",false);
                                } 
                            }
                        } 
                    }else {
                        component.set("v.isMemberAlertModalOpen",false);
                    }
                }
            });
            $A.enqueueAction(action);
        }
    },

    // Optimized Function
    getAlertOnClickPolicy: function (component, event) {
        var policyMemberId = component.get("v.policyMemberId");
        var taxId = component.get("v.taxId");
        var providerId = component.get("v.providerId");
        var policyGroupId = component.get("v.policyGroupId");
        var groupId = component.get("v.groupId");
        if (groupId != policyGroupId) {
            component.set("v.groupId", policyGroupId);
            component.set("v.taxId", taxId);
            component.set("v.providerId", providerId);
            component.set("v.lastGroupNo", policyGroupId);
            var isProvider = component.get("v.isProvider");
            var isMemberSnapshot = component.get("v.isMemberSnapshot");
            var mnf = component.get("v.memberNotFound");

            var tempArray = [];
            var action = component.get("c.policyAlerts");
            action.setParams({
                "policyMemberId": policyMemberId,
                "taxtId": taxId,
                "providerId": providerId,
                "policyGroupId": policyGroupId

            });
            action.setCallback(this, function (a) {
                tempArray = a.getReturnValue().alerts;
                component.set('v.getAlertsData', tempArray);
                component.set("v.alertsSize", tempArray.length);
                if (tempArray.length > 0) {
                    this.createInteractionAlertHelper(component, tempArray);
                    if (isProvider) {
                        component.set("v.isMemberAlertModalOpen", false);
                    } else if (isMemberSnapshot && mnf != 'mnf') {
                        component.set("v.isMemberAlertModalOpen", a.getReturnValue().openDialog);
                    } else {
                        component.set("v.isMemberAlertModalOpen", false);
                    }
                }
            });
            $A.enqueueAction(action);
        }
    },

    getAlertsOnShapShotpage_old: function (component, event) {
        var policyGroupId = component.get("v.policyGroupId");

            var isProvider = component.get("v.isProvider");
            var isProviderSnapshot = component.get("v.isProviderSnapshot");
            var isMemberSnapshot = component.get("v.isMemberSnapshot");
            var noMember = component.get("v.noMemberToSearch");
            var alertsSize = component.get("v.alertsSize");
            
            var houseHoldGroupId = component.get("v.houseHoldGroupId");
            var houseHoldMemberId = component.get("v.houseHoldMemberId");
            var taxId = component.get("v.taxId");
            var providerId = component.get("v.providerId");
            var memberId = component.get("v.memberId");
            var groupId = component.get("v.groupId");
            var mnf = component.get("v.memberNotFound");
            
            var tempArray = [];
            
            var action = component.get("c.getAlertsData");
            action.setCallback(this, function(a) {
                var result = a.getReturnValue();
                for(var i in result){
                   console.log('Type::'+result[i].Type__c);
                if(!$A.util.isEmpty(result[i].Effective_Date__c) && !$A.util.isEmpty(result[i].End_Date__c)){
                    if(result[i].Effective_Date__c < result[i].End_Date__c){
                        if ((!$A.util.isEmpty(taxId) && taxId == result[i].Group_Number__c) || (!$A.util.isEmpty(providerId) && providerId == result[i].ID_Number__c) ||
                            (!$A.util.isEmpty(memberId) && memberId == result[i].ID_Number__c) || (!$A.util.isEmpty(groupId) && groupId == result[i].Group_Number__c) ||
                            (!$A.util.isEmpty(policyGroupId) && policyGroupId == result[i].Group_Number__c) ||
                            (!$A.util.isEmpty(houseHoldMemberId) && houseHoldMemberId == result[i].ID_Number__c) ||
                            (!$A.util.isEmpty(houseHoldGroupId) && houseHoldGroupId == result[i].Group_Number__c)) {
                            tempArray.push(result[i]);
                        } 
                    }
                }
                
            }
            component.set('v.getAlertsData', tempArray);
            component.set("v.alertsSize", tempArray.length);
            if(tempArray.length >0){
                this.createInteractionAlertHelper(component,tempArray);
                if(isProvider){
                    component.set("v.isMemberAlertModalOpen",false);
                }
                else if(isMemberSnapshot && mnf != 'mnf'){
                    for(var i in result){
                        if(result[i].Effective_Date__c < result[i].End_Date__c){
                            if((!$A.util.isEmpty(memberId) && memberId == result[i].ID_Number__c) || (!$A.util.isEmpty(groupId) && groupId == result[i].Group_Number__c)){
                                 component.set("v.isMemberAlertModalOpen",true);
                                return false;
                            }else{
                                component.set("v.isMemberAlertModalOpen",false);
                            } 
                        }
                    } 
                } else {
                    component.set("v.isMemberAlertModalOpen", false);
                }
            }
        });
        $A.enqueueAction(action);

    },

    // Optimized Function
    getAlertsOnShapShotpage: function (component, event) {
        var policyGroupId = component.get("v.policyGroupId");
        var isProvider = component.get("v.isProvider");
        var isMemberSnapshot = component.get("v.isMemberSnapshot");
        var houseHoldGroupId = component.get("v.houseHoldGroupId");
        var houseHoldMemberId = component.get("v.houseHoldMemberId");
        var taxId = component.get("v.taxId");
        var providerId = component.get("v.providerId");
        var memberId = component.get("v.memberId");
        var groupId = component.get("v.groupId");
        var mnf = component.get("v.memberNotFound");

        var tempArray = [];
        var action = component.get("c.snapshotAlerts");
        action.setParams({
            "memberId": memberId,
            "taxtId": taxId,
            "providerId": providerId,
            "policyGroupId": policyGroupId,
            "groupId": groupId,
            "houseHoldMemberId": houseHoldMemberId,
            "houseHoldGroupId": houseHoldGroupId
        });
        action.setCallback(this, function (a) {
            tempArray = a.getReturnValue().alerts;
            component.set('v.getAlertsData', tempArray);
            component.set("v.alertsSize", tempArray.length);
            if (tempArray.length > 0) {
                this.createInteractionAlertHelper(component, tempArray);
                if (isProvider) {
                    component.set("v.isMemberAlertModalOpen", false);
                } else if (isMemberSnapshot && mnf != 'mnf') {
                    component.set("v.isMemberAlertModalOpen", a.getReturnValue().openDialog);
                }else {
                    component.set("v.isMemberAlertModalOpen",false);
                }
            }
        });
            $A.enqueueAction(action);
        
    },
    
    createInteractionAlertHelper : function(component,alertData){
        
        var interactionRec = component.get("v.interactionRecId");
        var taxId = component.get("v.taxId");
        var providerId = component.get("v.providerId");
        var memberId = component.get("v.memberId");
        var groupId = component.get("v.groupId");
        var action = component.get("c.createInteractionAlert");
        action.setParams({
            "alerts" : alertData,
            "interactionRec":interactionRec
            
        });
        $A.enqueueAction(action);
        
    },
    //US2554307: View Authorizations Details Page - Add Alerts Button
    getAlertOnAuthDetailsPage_old: function (component, event) {
        var policyMemberId = component.get("v.policyMemberId");
        var taxId = component.get("v.taxId");
        var providerId = component.get("v.providerId");
        var policyGroupId = component.get("v.policyGroupId");
        var lastGroupNo = component.get("v.lastGroupNo");
        var groupId = component.get("v.groupId");
        if(groupId != policyGroupId){
            component.set("v.groupId",policyGroupId);
            component.set("v.taxId",taxId);
            component.set("v.providerId",providerId);
            component.set("v.lastGroupNo",policyGroupId);
            var isProvider = component.get("v.isProvider");
            var isProviderSnapshot = component.get("v.isProviderSnapshot");
            var isMemberSnapshot = component.get("v.isMemberSnapshot");
            var noMember = component.get("v.noMemberToSearch");
            var alertsSize = component.get("v.alertsSize");

            var mnf = component.get("v.memberNotFound");

            var tempArray = [];

            var action = component.get("c.getAlertsData");
            action.setCallback(this, function(a) {
                var result = a.getReturnValue();
                for(var i in result){
                    if(!$A.util.isEmpty(result[i].Effective_Date__c) && !$A.util.isEmpty(result[i].End_Date__c)){
                        if(result[i].Effective_Date__c < result[i].End_Date__c){
                            if ((!$A.util.isEmpty(policyMemberId) && policyMemberId == result[i].ID_Number__c) ||
                                (!$A.util.isEmpty(taxId) && taxId == result[i].Group_Number__c) ||
                                (!$A.util.isEmpty(providerId) && providerId == result[i].ID_Number__c) ||
                                (!$A.util.isEmpty(policyGroupId) && policyGroupId == result[i].Group_Number__c)) {
                                tempArray.push(result[i]);
                                console.log('policyMemberId---'+policyMemberId);
                            }
                        }
                    }

                }
                component.set('v.getAlertsData', tempArray);
                component.set("v.alertsSize", tempArray.length);
                if(tempArray.length >0){
                    this.createInteractionAlertHelper(component,tempArray);
                    if(isProvider){
                        component.set("v.isMemberAlertModalOpen",false);
                    }
                    else if(isMemberSnapshot && mnf != 'mnf'){
                        for(var i in result){
                            if(result[i].Effective_Date__c < result[i].End_Date__c){
                                if((!$A.util.isEmpty(policyMemberId) && policyMemberId == result[i].ID_Number__c) || (!$A.util.isEmpty(policyGroupId) && policyGroupId == result[i].Group_Number__c)){
                                    //component.set("v.isMemberAlertModalOpen",true);
                                    return false;
                                }else{
                                    component.set("v.isMemberAlertModalOpen",false);
                                }
                            }
                        }
                    }else {
                        component.set("v.isMemberAlertModalOpen",false);
                    }
                }
            });
            $A.enqueueAction(action);
        }
    },

    // Optimized function
    getAlertOnAuthDetailsPage: function (component, event) {
        var policyMemberId = component.get("v.policyMemberId");
        var taxId = component.get("v.taxId");
        var providerId = component.get("v.providerId");
        var policyGroupId = component.get("v.policyGroupId");
        var groupId = component.get("v.groupId");
        if (groupId != policyGroupId) {
            component.set("v.groupId", policyGroupId);
            component.set("v.taxId", taxId);
            component.set("v.providerId", providerId);
            component.set("v.lastGroupNo", policyGroupId);
            var tempArray = [];
            var action = component.get("c.policyAlerts");
            action.setParams({
                "policyMemberId": policyMemberId,
                "taxtId": taxId,
                "providerId": providerId,
                "policyGroupId": policyGroupId

            });
            action.setCallback(this, function (a) {
                tempArray = a.getReturnValue().alerts;
                component.set('v.getAlertsData', tempArray);
                component.set("v.alertsSize", tempArray.length);
                if (tempArray.length > 0) {
                    this.createInteractionAlertHelper(component, tempArray);
                    component.set("v.isMemberAlertModalOpen", false);
                }
            });
            $A.enqueueAction(action);
        }
    },

     getAlertOnCreateReferralPage: function (component, event) {
        var policyMemberId = component.get("v.policyMemberId");
        var taxId = component.get("v.taxId");
        var providerId = component.get("v.providerId");
        var policyGroupId = component.get("v.policyGroupId");
        var groupId = component.get("v.groupId");
        if (groupId != policyGroupId) {
            component.set("v.groupId", policyGroupId);
            component.set("v.taxId", taxId);
            component.set("v.providerId", providerId);
            component.set("v.lastGroupNo", policyGroupId);
            var tempArray = [];
            var action = component.get("c.policyAlerts");
            action.setParams({
                "policyMemberId": policyMemberId,
                "taxtId": taxId,
                "providerId": providerId,
                "policyGroupId": policyGroupId

            });
            action.setCallback(this, function (a) {
                tempArray = a.getReturnValue().alerts;
                component.set('v.getAlertsData', tempArray);
                component.set("v.alertsSize", tempArray.length);
                if (tempArray.length > 0) {
                    this.createInteractionAlertHelper(component, tempArray);
                    component.set("v.isMemberAlertModalOpen", false);
                }
            });
            $A.enqueueAction(action);
        }
    },

    //US2876410 ketki 9/15:  Launch Claim Detail Page
    getAlertOnClaimDetailsPage: function (component, event) {
        var policyMemberId = component.get("v.policyMemberId");
        var taxId = component.get("v.taxId");
        var providerId = component.get("v.providerId");
        var policyGroupId = component.get("v.policyGroupId");
        var groupId = component.get("v.groupId");
        if (groupId != policyGroupId) {
            component.set("v.groupId", policyGroupId);
            component.set("v.taxId", taxId);
            component.set("v.providerId", providerId);
            component.set("v.lastGroupNo", policyGroupId);
            var tempArray = [];
            var action = component.get("c.policyAlerts");
            action.setParams({
                "policyMemberId": policyMemberId,
                "taxtId": taxId,
                "providerId": providerId,
                "policyGroupId": policyGroupId

            });
            action.setCallback(this, function (a) {
                tempArray = a.getReturnValue().alerts;
                component.set('v.getAlertsData', tempArray);
                component.set("v.alertsSize", tempArray.length);
                if (tempArray.length > 0) {
                    this.createInteractionAlertHelper(component, tempArray);
                    component.set("v.isMemberAlertModalOpen", false);
                }
            });
            $A.enqueueAction(action);
        }
    },
    // US3480373: Service Request Detail Page Alignment - Krish - 5 May 2021 Start
    getAlertsOnServiceRequestDetail : function(cmp){
        var caseId = cmp.get('v.caseRecordId');
        var taxId = cmp.get("v.taxId");
        var providerId = cmp.get("v.providerId");
        var memberId = cmp.get("v.memberId");
        var groupId = cmp.get("v.groupId");
        var isProvider = cmp.get("v.isProvider");
        var isMemberSnapshot = cmp.get("v.isMemberSnapshot");
        var mnf = cmp.get("v.memberNotFound");
        var tempArray = [];
        var action = cmp.get('c.serviceRequestDetailAlerts');
        action.setParams({
            caseId: caseId,
            memberId : memberId,
            taxId : taxId,
            providerId : providerId,
            groupId : groupId
        });
        action.setCallback(this, function (response) {
            tempArray = response.getReturnValue().alerts;
            cmp.set('v.getAlertsData', tempArray);
            cmp.set("v.alertsSize", tempArray.length);
            if (tempArray.length > 0) {
                this.createInteractionAlertHelper(cmp, tempArray);
                if (isProvider) {
                    cmp.set("v.isMemberAlertModalOpen", false);
                } else if (isMemberSnapshot && mnf != 'mnf') {
                    cmp.set("v.isMemberAlertModalOpen", response.getReturnValue().openDialog);
                }else {
                    cmp.set("v.isMemberAlertModalOpen",false);
    }
            }
        });
        $A.enqueueAction(action);
    }
})