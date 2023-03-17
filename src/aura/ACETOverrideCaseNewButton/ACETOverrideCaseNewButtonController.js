({
    init : function(component, event, helper) {
		
        // Start - Cherry - for Feature flag to display Case Origin field
		var action1 = component.get("c.showComponent");
        action1.setParams({
            "featureName": 'DisplayCaseOrigin'
        });
        action1.setCallback(this,function(response1){
            var state1 = response1.getState();
            if(state1 === "SUCCESS"){
            	component.set("v.showCaseOrigin", response1.getReturnValue());
                console.log('ff---'+ response1.getReturnValue());
            }
        });
        $A.enqueueAction(action1);  
        // Stop - Cherry - for Feature flag to display Case Origin field
        
        /*Get the record Id and assign it to corresponding case object fields as default values*/
        var parentRef =component.get("v.pageReference").state.additionalParams;
        var base64Context = component.get("v.pageReference").state.inContextOfRef;
         
        var addressableContext;
        var parentrecId;
        if(typeof base64Context !== 'undefined'){            
             if (base64Context.startsWith("1\.")) {
                base64Context = base64Context.substring(2);
                addressableContext = JSON.parse(window.atob(base64Context));
                parentrecId = addressableContext.attributes.recordId;
            }
            if(typeof parentrecId !== 'undefined'){
                if(parentrecId.startsWith("003")){
                   component.set("v.contactId", parentrecId);
                }else if(parentrecId.startsWith("500")){
                  component.set("v.parentId", parentrecId);  
                }else if(parentrecId.startsWith("001")){
                  component.set("v.accId", parentrecId);    
                  helper.getContId(component, event, helper); 
                }
            }
            
        }else{
            var parentRef =component.get("v.pageReference").state.defaultFieldValues;
            var supportCheck =component.get("v.pageReference").state.defaultFieldValues;//vishal change
            if(typeof parentRef !== 'undefined'){
           		var parentRefs =parentRef.split("=");
            	parentrecId = parentRefs[1];
          		
            }
            if(typeof parentrecId !== 'undefined'){
                if(parentrecId.startsWith("003")){
                   component.set("v.contactId", parentrecId);
                }else if(parentrecId.startsWith("500")){
                  component.set("v.parentId", parentrecId);  
                }else if(parentrecId.startsWith("001")){
                  component.set("v.accId", parentrecId);    
                    console.log('-------accid------'+parentrecId);
                  helper.getContId(component, event, helper); 
                }
            }
        }
        //Implementation for multiple case record types 
        var recordTypeId = component.get("v.pageReference").state.recordTypeId;	
        
        if (typeof recordTypeId !== 'undefined'){
	    component.set("v.selectedRecordId", recordTypeId);
        var action = component.get("c.GetAvailableRecordTypeAccount");
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var returning = [];
                var recordTypes = response.getReturnValue();
                component.set("v.recordTypesMap",recordTypes);
                console.log(recordTypes[recordTypeId]);
                if((typeof recordTypeId !== 'undefined') && recordTypes[recordTypeId] === "ECM"){
                    component.set("v.showCaseLayout",true);
                }else if((typeof recordTypeId !== 'undefined') && recordTypes[recordTypeId] === "Support Request"  || (typeof supportCheck !== 'undefined')){
                    component.set("v.showSupportLayout",true);
                    helper.getTopicTypeSubtypeValues(component, event, helper);
                }else{

                    // use the force:createRecord event here
                    var createRecordEvent = $A.get("e.force:createRecord");
                    createRecordEvent.setParams({
                        "entityApiName": "Case",
                        "recordTypeId":recordTypeId,
                        "defaultFieldValues": {
                              "ParentId" : component.get("v.parentId"),
                              "ContactId" : component.get("v.contactId")
                         }
                    });
                    createRecordEvent.fire();
                }
            }
            else{
                //alert("Temporary Error: There is a problem getting the Record Types.");// Temporary, Will be changed to ToastError.
            }
        });
        $A.enqueueAction(action);
        }else{        
            //Implementation for default case record type
            if(typeof parentrecId !== 'undefined' && !parentrecId.startsWith("001")){
				var createRecordEvent = $A.get("e.force:createRecord");
                createRecordEvent.setParams({
                        "entityApiName": "Case",
                        "defaultFieldValues": {
                              "ParentId" : component.get("v.parentId"),
                              "ContactId" : component.get("v.contactId")
                         }
                   });
                    createRecordEvent.fire();
            }else{
                var createRecordEvent = $A.get("e.force:createRecord");
                    createRecordEvent.setParams({
                        "entityApiName": "Case"
                   });
                    createRecordEvent.fire();
            }
        }
        // US2526182: SNI Core - Select Policy when creating a new case - Vishal Yelisetti|4/45/2020
        if(!($A.util.isEmpty(parentRef))){
           helper.getMemberId(component, event, helper);
        }
    },
    handleLoad: function(cmp, event, helper) {
        cmp.set('v.showSpinner', false);
        var objectInfo = event.getParams();
        console.log(objectInfo);
        $A.util.removeClass(cmp.find("caseName"), "none");
        $A.util.removeClass(cmp.find("priority"), "none");
        $A.util.removeClass(cmp.find("oppCategory"), "none");
        $A.util.removeClass(cmp.find("memberid"), "none");
        $A.util.removeClass(cmp.find("caseTopicSelected"), "none");
        $A.util.removeClass(cmp.find("csetype"), "none");
    },
    handleSupportSubmit: function(cmp, event, helper) {
        cmp.set('v.disabled', true);
        cmp.set('v.showSpinner', true);
        event.preventDefault(); // stop form submission
        var parentId = cmp.get("v.parentId");
        console.log(parentId);
        var initialTopic = cmp.find("caseTopicSelected").get("v.value");
        var callType = cmp.get("v.cseType");
        var callSubType = cmp.get("v.cseSubtype");
        console.log('callSubType...'+callSubType)
        var eventFields = event.getParam('fields');
        eventFields.Topic__c = initialTopic;
        eventFields.Original_Type__c = callType;
        eventFields.Type__c = callType;
        if(callSubType !== "None"){
            eventFields.Original_Subtype__c = callSubType;
        }
        if(callSubType !== "None"){
            eventFields.Subtype__c = callSubType;
        }
		//US2964058  start	
	    var parentId = cmp.get("v.parentId");
        var action = cmp.get("c.getAccountInfo");
        action.setParams({
            "caseId": parentId
        });
        action.setCallback(this, function(response1) {
            var state = response1.getState();
            if(state == 'SUCCESS') {
                var result = response1.getReturnValue();
                if(result != '' && result){
                    eventFields.Product_Type__c= result.Product_Type__c;
				    eventFields.Line_of_Business__c= result.Line_of_Business__c;
					eventFields.Service_Group__c= result.Service_Group__c;
                    cmp.find('supportCaseForm').submit(eventFields);
                }
            }else{
             cmp.find('supportCaseForm').submit(eventFields);   
            }
        });
        $A.enqueueAction(action);
		//cmp.find('supportCaseForm').submit(eventFields);
		//US2964058 end

    },
    handleSubmit: function(cmp, event, helper) {

        event.preventDefault(); // stop form submission
        var valid = helper.onSubmitValidation(cmp, event, helper);
        if(valid){
            cmp.set('v.disabled', true);
            cmp.set('v.showSpinner', true);
            var memPolID = cmp.get("v.selectedmemberidValue");
            //var initialTopic = cmp.find("caseTopicSelected").get("v.value");
            var callType = cmp.get("v.cseType");
            var callSubType = cmp.get("v.cseSubtype");
            var eventFields = event.getParam('fields');
            console.log('callSubType...'+callSubType);
            console.log('callType...'+callType);
            //console.log('initialTopic...'+initialTopic);
            //eventFields.Topic__c = initialTopic;
            //eventFields.Original_Type__c = callType;
            /*if(callSubType !== "None"){
                eventFields.Original_Subtype__c = callSubType;
            }
			eventFields.Type__c = callType;*/
            // US2526182: SNI Core - Select Policy when creating a new case - Vishal Yelisetti|04/25/2020
            if(memPolID != "--None--"){
                var memPolIDarray = memPolID.split(" - ");
            	var memberid = memPolIDarray[0];
            	var policyid = memPolIDarray[1];
                eventFields.ID__c = memberid;
                var action1 = cmp.get("c.getGroupId");
                action1.setParams({
                    "memberID": memberid,
                    "policyID": policyid
                });
                action1.setCallback(this, function(response1) {
                    var state1 = response1.getState();
                    if(state1 == 'SUCCESS') {
                        var result1 = response1.getReturnValue();
                        if(result1 && result1 != ''){
                            console.log("Result1 = " + result1);
                            //eventFields.Subject_Group_ID__c = result1; //code commented by Chandan -US2556134
                            console.log('Subject_Group_ID__c='+result1.Policy_ID__c);
                            console.log('Owner='+result1.Owner.Name);
                            eventFields.Subject_Group_ID__c = result1.Policy_ID__c;//code Modified by Chandan to accomodate change for above line
                            eventFields.Product_Type__c= result1.Product_Type__c;//US2964058
							eventFields.Line_of_Business__c= result1.Line_of_Business__c;//US2964058
							eventFields.Service_Group__c= result1.Service_Group__c;//US2964058
                            if(result1.Owner.Name!='Unassigned') //Code Added by Chandan -US2556134
                                eventFields.OwnerId=result1.OwnerId; //Code Added by Chandan -US2556134

                            // Getting the case page and sending the group Id
                            cmp.find('caseForm').submit(eventFields);
                        }
                    }
                });
                $A.enqueueAction(action1);
            }
        } else {
            return false;
        }
    },
    handleError: function(cmp, event, helper) {
        // errors are handled by lightning:inputField and lightning:messages
        // so this just hides the spinner

        //event.setParam('message','You do not have access to create a UHG restricted SENS Case');
        var error = event.getParam('message');
        console.log('standard message='+error);
        var status=event.getParam('detail');
        console.log('custom message='+status);
        var showCaseLayout = cmp.get("v.showCaseLayout");
        console.log('showCaseLayout:'+showCaseLayout);
        if(showCaseLayout)
          cmp.find('OppMessage').setError(status);
        cmp.set('v.showSpinner', false);
    },
    handleSuccess: function(cmp, event, helper) {
      cmp.set('v.showSpinner', false);
      cmp.set('v.saved', true);
      if(event.getParams().response != undefined && event.getParams().response.id != undefined && event.getParams().response.id != null){
      	var recordId = event.getParams().response.id;
	  var workspaceAPI = cmp.find("workspace");
          workspaceAPI.getAllTabInfo().then(function(responseTab) {

                    workspaceAPI.closeTab({tabId: responseTab.parentTabId});
                });
                     workspaceAPI.getFocusedTabInfo().then(function(responseTab) {
                         workspaceAPI.openSubtab({
                             parentTabId : responseTab.tabId,
                             url:'/'+ recordId,
                             focus: true
                         })
                     });

      }else{
          var jsonStr = JSON.stringify(event.getParams().response);
      var casenumStartIndx = jsonStr.indexOf('CaseNumber') + 42;
      var caseNum = jsonStr.substring(casenumStartIndx,casenumStartIndx + 8);
      console.log('---caseNum-->'+ caseNum);
      if(event.getParams().response.fields != null && event.getParams().response.fields != undefined){
          console.log('---0.1----->'+ JSON.stringify(event.getParams().response.fields.CaseNumber));

      }
      var action = cmp.get("c.getCaseId");
        action.setParams({ caseNum : caseNum });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var recordId = response.getReturnValue();
            if (state === "SUCCESS") {

                var workspaceAPI = cmp.find("workspace");
                workspaceAPI.getAllTabInfo().then(function(responseTab) {
                    workspaceAPI.closeTab({tabId: responseTab.parentTabId});
                });
                     workspaceAPI.getFocusedTabInfo().then(function(responseTab) {
                         workspaceAPI.openSubtab({
                             parentTabId : responseTab.tabId,
                             url:'/'+ recordId,
                             focus: true
                         })
                     });
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
            else if (state === "ERROR") {
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

      }
    },
    onTopicSelection : function(component, event, helper) {
        var recordTypeId =  component.get("v.selectedRecordId");
        var recordTypes = component.get("v.recordTypesMap");
        if(recordTypes[recordTypeId] === "ECM"){
        helper.validationCheck(component, event, helper);
        }
        helper.loadTtsTopics(component, event, helper);
    },
    onTypeChange : function(component, event, helper) {
        var recordTypeId =  component.get("v.selectedRecordId");
        var recordTypes = component.get("v.recordTypesMap");
        if(recordTypes[recordTypeId] === "ECM"){
        helper.validationCheck(component, event, helper);
        }
        helper.loadSubType(component, event, helper);
    },
    openModel: function(component, event, helper) {
        // for Display Model,set the "isOpen" attribute to "true"
        component.set("v.isOpen", true);
    },

    closeModel: function(component, event, helper) {
        // for Hide/Close Model,set the "isOpen" attribute to "Fasle"
        component.set("v.isOpen", false);
        component.set("v.showCaseLayout",false);
        component.set("v.showSupportLayout",false);
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getAllTabInfo().then(function(response) {
            console.log(response.parentTabId );
            workspaceAPI.closeTab({tabId: response.parentTabId});

        })
    },
    OnClickValidation : function(component, event, helper){
        helper.validationCheck(component, event, helper);
    }


})