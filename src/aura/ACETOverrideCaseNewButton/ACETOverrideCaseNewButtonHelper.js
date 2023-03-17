({
    loadTtsTopics:function(component, event, helper) {
        let initialTopic = component.find("caseTopicSelected").get("v.value");
        let lstTypes = ['--None--'];
        var calltopicstr = initialTopic;
        var calltypestr = component.get("v.cseType");
        if (! $A.util.isEmpty(calltopicstr) ||  calltopicstr != undefined ||  calltopicstr != null) {
        var action = component.get("c.getTTSFilterMapKeyStr");
        action.setParams({
            "callTopic": calltopicstr.replace(/_/g," ")
        });
       action.setCallback(this, function(a) {
            var state = a.getState();
            if(state == "SUCCESS"){
                var result = a.getReturnValue();
                if(!$A.util.isEmpty(result) && !$A.util.isUndefined(result)) {
                    var lst = [];
                    for(var i=0; i < result.length; i++) {
                        lstTypes.push(result[i]);
                    }
                    lstTypes = lstTypes.sort();
                    component.set('v.typeOptions', lstTypes);
                }
            }

        });
        $A.enqueueAction(action);
        }
    },
    loadSubType : function(component, event, helper) {
        let initialTopic = component.find("caseTopicSelected").get("v.value");
        var calltopicstr = initialTopic;
        var calltypestr = component.get("v.cseType");
        var lstSubtype = ['--None--'];
        if (! $A.util.isEmpty(calltopicstr) ||  calltopicstr != undefined ||  calltopicstr != null) {
        var action = component.get("c.getTTSFilterMapValueStr");
        action.setParams({
            "callTopic": calltopicstr.replace(/_/g," "),
            "keystr": calltypestr
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
            if(state == "SUCCESS"){
                var result = a.getReturnValue()
                // US2091974 - Sanka - Case Creation
                if (!$A.util.isUndefined(result)) {
                    if (!$A.util.isEmpty(result)) {
                        for(var i=0; i < result.length; i++) {
                            console.log('result[i].....'+result[i]);
                            if(result[i] !== 'None') {
                                lstSubtype.push(result[i]);
                            }
                        }
                    }
                    lstSubtype = lstSubtype.sort();
                    if(lstSubtype.length > 0){
                        component.set('v.subtypeOptions',lstSubtype);
                    }else{
                        component.set('v.subtypeOptions','');
                    }
                }
            }
        });
        $A.enqueueAction(action);
        }
    },
    getTopicTypeSubtypeValues : function(component, event, helper) {
        var parentId = component.get("v.parentId");
        var action1 = component.get("c.getParentCaseFields");
        action1.setParams({
            "caseId": parentId
        });
        action1.setCallback(this, function(response1) {
            var state1 = response1.getState();
            console.log('family over view state1--------------'+state1);
            if(state1 == 'SUCCESS') {
                var result1 = response1.getReturnValue();
                console.log('family over view result1--------------'+result1);
                if(result1 != '' && result1){
                    component.find("caseTopicSelected").set("v.value",result1[0]);
                    helper.loadTtsTopics(component, event, helper);
                    component.set("v.cseType",result1[1]);
                    helper.loadSubType(component, event, helper);
                    component.set("v.cseSubtype",result1[2]);
                }
            }
        });
        $A.enqueueAction(action1);
    },
    // US2526182: SNI Core - Select Policy when creating a new case - Vishal Yelisetti|4/45/2020
    getMemberId : function(component, event, helper) {
        var parentId = component.get("v.parentId");
        var action1 = component.get("c.getMemberIDs");
        action1.setParams({
            "caseId": parentId
        });
        action1.setCallback(this, function(response1) {
            var state1 = response1.getState();
            console.log('state2--------------'+state1);
            if(state1 == 'SUCCESS') {
                var result1 = response1.getReturnValue();
                console.log('result2--------------'+parentId);
                if(result1 != '' && result1){
                    component.set("v.memberidoptions", result1);
                    // if memberIds are only 1, default it to single member id, else show entire list
                    if (result1.length == 2){
                        component.set("v.selectedmemberidValue", result1[1]);
                    }
                }
            }
        });
        $A.enqueueAction(action1);
    },
    onSubmitValidation : function(component, event, helper){
        var valid = true ;
         var caseName = component.find("caseName").get("v.value");
         var priority = component.find("priority").get("v.value");
         var oppCategory = component.find("oppCategory").get("v.value");
        var memberid = component.find("memberid").get("v.value");
        var showCaseOrigin = component.get("v.showCaseOrigin");
        if (showCaseOrigin == true) {
        	var origin = component.find("origin").get("v.value");
        }
        // var topic = component.find("caseTopicSelected").get("v.value");
       //  var type = component.find("csetype").get("v.value");
        var ownerid = component.find("ownerid").get("v.value");
        // US2526182: SNI Core - Bug Fix - complete this field error message - Missing Message on Fields - Vishal Yelisetti, Charnkiat Sukpanichnant|05/07/2020
        if(ownerid == null || ownerid == undefined){
            valid = this.showErrorMessage(component, "owneridValidity", "OwnerIDValidationMessage");
        }
        if(caseName == null || caseName == '' || caseName == undefined){
            valid = this.showErrorMessage(component, "caseNameValidity", "caseNameValidationMessage");
        }
        if(priority == null || priority == '' || priority == 'None' || priority == '--None--'|| priority == undefined) {
            valid = this.showErrorMessage(component, "priorityValidity", "priorityValidationMessage");
        }
        if (showCaseOrigin == true) {
            if(origin == null || origin == '' || origin == 'None' || origin == '--None--'|| origin == undefined) {
                valid = this.showErrorMessage(component, "originValidity", "originValidationMessage");
            }
        }
        if(oppCategory == '' || oppCategory == 'None' || oppCategory == null || oppCategory == '--None--' || oppCategory == undefined){
            valid = this.showErrorMessage(component, "oppCategoryValidity", "oppCategoryValidationMessage");
        }
        if (memberid == 'undefined' || memberid == '--None--' || memberid == undefined) {
            valid = this.showErrorMessage(component, "memberIDValidity", "memberIDValidationMessage");
        }
       /* if(topic == '' || topic == 'None' || topic == null || topic == '--None--' || topic == undefined){
            valid = this.showErrorMessage(component, "topicValidity", "topicValidationMessage");
        }
        if(type == 'None' || type == '' || type == null || type == '--None--' || type == undefined){
            valid = this.showErrorMessage(component, "typeValidity", "typeValidationMessage");
        } */
        return valid;
    },
    validationCheck : function(component, event, helper){
        var caseName = component.find("caseName").get("v.value");
        var priority = component.find("priority").get("v.value");
        var oppCategory = component.find("oppCategory").get("v.value");
        var memberid = component.find("memberid").get("v.value");
         var showCaseOrigin = component.get("v.showCaseOrigin");
        if (showCaseOrigin == true) {
            var origin = component.find("origin").get("v.value");
        }
        //var topic = component.find("caseTopicSelected").get("v.value");
        //var type = component.find("csetype").get("v.value");
        var ownerid = component.find("ownerid").get("v.value");
        // US2526182: SNI Core - Bug Fix - complete this field error message - Missing Message on Fields - Vishal Yelisetti, Charnkiat Sukpanichnant|05/07/2020
        if(ownerid != null && ownerid != undefined){
            this.hideErrorMessage(component, "owneridValidity", "OwnerIDValidationMessage");
        }
        if(caseName != null && caseName != '' && caseName != undefined) {
            this.hideErrorMessage(component, "caseNameValidity", "caseNameValidationMessage");
        }
        if(priority != null && priority != '' && priority != undefined){
            this.hideErrorMessage(component, "priorityValidity", "priorityValidationMessage");
        }
        if (showCaseOrigin == true) {
            if(origin != null && origin != '' && origin != undefined){
                this.hideErrorMessage(component, "originValidity", "originValidationMessage");
            }
        }
        if(memberid != 'undefined' && memberid != '--None--' && memberid != undefined){
            this.hideErrorMessage(component, "memberIDValidity", "memberIDValidationMessage");
        }
        if(oppCategory != '' && oppCategory != null && oppCategory != undefined ){
            this.hideErrorMessage(component, "oppCategoryValidity", "oppCategoryValidationMessage");
        }
       /* if(topic != '' && topic != 'None' && topic != null && topic != '--None--' && topic != undefined){
            this.hideErrorMessage(component, "topicValidity", "topicValidationMessage");
        }
        if(type != 'None' && type != '' && type != null && type != '--None--' && type != undefined){
            this.hideErrorMessage(component, "typeValidity", "typeValidationMessage");
        } */
    },
    // US2526182: SNI Core - Select Policy when creating a new case - Vishal Yelisetti|4/45/2020 - Refactored to reduce clutter
    showErrorMessage : function(component, validityID, validityMessageID) {
        var titleField = component.find(validityID);
        $A.util.addClass(titleField, 'slds-has-error');
        var validationmessage = component.find(validityMessageID);
        $A.util.removeClass(validationmessage, 'err');
        $A.util.addClass(validationmessage, 'slds-visible');
        return false
    },
    hideErrorMessage : function(component, validityID, validityMessageID){
        var titleField = component.find(validityID);
        $A.util.removeClass(titleField, 'slds-has-error');
        var validationmessage = component.find(validityMessageID);
        $A.util.removeClass(validationmessage, 'slds-visible');
        $A.util.addClass(validationmessage, 'err');
    },
    getContId:function(component, event, helper) {
        var accId = component.get("v.accId");
        var action = component.get("c.getContactId");
        
        action.setParams({
            "accId": accId
        });
       action.setCallback(this, function(a) {
            var state = a.getState();
            
            if(state == "SUCCESS"){
                var result = a.getReturnValue();
                if(!$A.util.isUndefinedOrNull(result)) {
                   component.set("v.contactId", result);
                    var recordTypeId = component.get("v.pageReference").state.recordTypeId;
                    if(typeof recordTypeId == 'undefined'){
                        var createRecordEvent = $A.get("e.force:createRecord");
                        createRecordEvent.setParams({
                            "entityApiName": "Case",
                            "defaultFieldValues": {
                                  "ParentId" : component.get("v.parentId"),
                                  "ContactId" : component.get("v.contactId")
                             }
                       });
                       createRecordEvent.fire(); 
                    }
                }
            }

        });
        $A.enqueueAction(action);
    }
})