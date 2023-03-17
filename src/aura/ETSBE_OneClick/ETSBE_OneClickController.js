({

  
    
    
    //US3072104||DE386538:Change
    dateTimeValidation:function(component, event, helper){
        helper.validatedateTime(component, event, helper);           
    },
    
     
    memberDateUpdate : function(component, event, helper) {
        
        var today = new Date();        
        var dd = today.getDate();
        var mm = today.getMonth() + 1; //January is 0!
        var yyyy = today.getFullYear();
        // if date is less then 10, then append 0 before date   
        if(dd < 10){
            dd = '0' + dd;
        } 
        // if month is less then 10, then append 0 before date    
        if(mm < 10){
            mm = '0' + mm;
        }
        
        var todayFormattedDate = yyyy+'-'+mm+'-'+dd;
        if(component.get("v.searchMemberDOB") != '' && component.get("v.searchMemberDOB") > todayFormattedDate){
            component.set("v.memberDOBValidationError" , true);
        }else{
            component.set("v.memberDOBValidationError" , false);
        }
        
    },
    
    doInit: function(component, event, helper) {       
        //Logic to set current time based on timezone:US2582573//
        var format = $A.get("$Locale.timeFormat");
        format = format.replace(":ss", "");
        var langLocale = $A.get("$Locale.langLocale");
        var timezone = $A.get("$Locale.timezone");
        var d = new Date();
        console.log("time in ===== "+timezone+" is "+d);       
        console.log('SET DATE1: ' + d);
        var month = d.getMonth() + 1;
        var day = d.getDate();
        if(month < 10){
            month = '0' + month;
        }
        if(day < 10){
            day = '0' + day;
        }
        var newDate = d.getFullYear() + '-' + month + '-' + day;
        console.log('SET DATE2: ' + newDate);
        component.set('v.eventReceivedDate',newDate);
        var hours = d.getHours();
        var mins = d.getMinutes();
        if(hours < 10){
            hours = '0' + hours;
        }
        if(mins < 10){
            mins = '0' + mins;
        }
        var newTime = hours + ':' + mins +':00.000Z';
        console.log('SET DATE3: ' + newTime);
        var eventTime = component.find("eventTime");
        eventTime.set("v.value",newTime);
        
        helper.fetchMockStatus(component);
        console.log('inside doinit');
        component.set("v.createdCaseSFID", "");
        component.set("v.createdCaseID", "");
        component.set("v.createdInteractionSFID", "");
        component.set("v.createdInteractionID", "");
        component.set("v.filesList", "");
        component.set("v.uhgAccess", "No");
        console.log(component.getElements());
        var action = component.get("c.getUser");
		action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('get user state' + state);
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                console.log('inside getuser oncomplete');
                component.set("v.userInfo", storeResponse);
                var userCheckList = ["CSO CSP","CSO CSP - Central","CSO CSP - Northeast","CSO CSP - Southeast","CSO CSP - West",
                                    "CSO Rapid Responder"];
                console.log('USER ROLE: ' + storeResponse.BEO_Specialty__c);
                console.log('USER LIST: ' + JSON.stringify(userCheckList));
                if(userCheckList.includes(storeResponse.BEO_Specialty__c)){
                    component.set("v.isCSOUser", true);
                } else {
                    component.set("v.isCSOUser", false);
                }
                console.log('USER BOOL: ' + component.get("v.isCSOUser"));
                component.set("v.instructionSearchType", "Business Unit");
        		helper.searchInstructionRecords(component,helper);
        		var dropdownOptions = [];
        		dropdownOptions.push({
                    label: "None",
                    value: "None"
                });
        		component.set('v.topicOptions', dropdownOptions);
        		if(storeResponse.Profile_Name__c == "ACET ETS-BE Research User"){
                	component.set('v.isResearchUser', true);
                    component.set("v.isCreateCase", true);
                } else {
                	component.set('v.isResearchUser', false);
                    component.set('v.isCreateCase', false);
                }
                var interactionTypeResearchOptions = [];
                interactionTypeResearchOptions.push({label: "Research",value: "Research"});
                component.set('v.interactionTypeResearchOptions', interactionTypeResearchOptions);
            }
        });
		$A.enqueueAction(action);
        var currentDate = new Date();
		var maxDate = currentDate.getFullYear() + "-" + (currentDate.getMonth() + 1) + "-" + currentDate.getDate();
		component.set('v.maxEventReceivedDate', maxDate);
        var interactionTypeOptionsArray = ["None", "Phone Call", "Email", "Fax", "Mail", "Meeting"];
        var interactionTypeOptions = [];
        for (var i = 0; i < interactionTypeOptionsArray.length; i++) {
            interactionTypeOptions.push({
                label: interactionTypeOptionsArray[i],
                value: interactionTypeOptionsArray[i]
            });
        }
        component.set('v.interactionTypeOptions', interactionTypeOptions);
        var adminTypeList = ["None","Agency/Broker","General Agent","Group Contact","Internal UHG Employee","Other Originator"];
        var adminTypeOptions = [];
        for (var i = 0; i < adminTypeList.length; i++) {
        	adminTypeOptions.push({
                label: adminTypeList[i],
                value: adminTypeList[i]
            });
        }
        component.set('v.originatorTypeOptions', adminTypeOptions);
        var action = component.get("c.getOtherOriginatorDropdown");
        action.setCallback(this, function(response){
    		var state = response.getState();
    		if(state == "SUCCESS"){
    			var storeResponse = response.getReturnValue();
    			var otherAdminTypeOptions = [];
    			otherAdminTypeOptions.push({
	                label: "None",
	                value: "None"
	            });
    	        for (var i = 0; i < storeResponse.length; i++) {
    	        	otherAdminTypeOptions.push({
    	                label: storeResponse[i],
    	                value: storeResponse[i]
    	            });
    	        }
    	        component.set('v.otherOriginatorTypeOptions', otherAdminTypeOptions);
    		}
        });
        $A.enqueueAction(action);
        helper.fetchExlusionMdtData(component);
        if(!$A.util.isUndefinedOrNull(component.get("v.pageReference").state.c__InteractionRecord) && !$A.util.isUndefinedOrNull(component.get("v.pageReference").state.c__CaseRecord)){
            component.set("v.updateCaseInteractionInfo",component.get("v.pageReference").state.c__InteractionRecord);
            console.log('HERE IS INTERACTION: ' + JSON.stringify(component.get("v.updateCaseInteractionInfo")));
            component.set("v.updateCaseInfo",component.get("v.pageReference").state.c__CaseRecord);
            console.log('HERE IS PARENT CASE DATA: ' + JSON.stringify(component.get("v.updateCaseInfo")));
            component.set("v.updateCaseBool",true);
            var ondToggle = component.find("oneAndDoneToggle");
            var caseInfo = component.get("v.updateCaseInfo");
            var interactionInfo = component.get("v.updateCaseInteractionInfo");
        	component.set("v.oneAndDoneBool",true);
        	component.find("oneAndDoneToggle").set("v.value", true);
            //populate originator
            	//Originator_name__c, OriginatorPhone__c (check format), Originator_Type__c, OriginatorEmail__c
            if(caseInfo.Originator_name__c != null && caseInfo.Originator_name__c != undefined && caseInfo.Originator_name__c != ''){
            	//search for originator
            	var action = component.get("c.findOriginatorUpdate");
	            action.setParams({
	                origName: caseInfo.Originator_name__c,
	                origType: caseInfo.Originator_Type__c,
	                origPhone: caseInfo.OriginatorPhone__c,
	                origEmail: caseInfo.OriginatorEmail__c,
                    origSFID: interactionInfo.Originator_SFID__c
	            });
				action.setCallback(this,function(response){
	                var state = response.getState();
	                console.log('STATE: ' + state);
	                if(state == "SUCCESS"){
	                    var storeResponse = response.getReturnValue();
	                    console.log('ORIG RESULTS: ' + JSON.stringify(storeResponse));
	                    var dropdownOptions = [];
	                    if(storeResponse.length == 1){
	                    	component.set("v.originatorSelected",storeResponse[0]);
	                    	if(storeResponse[0].Originator_Type__c == 'Other Originator'){
	                    		component.set("v.originatorText",storeResponse[0].Other_Originator_Type__c + '   ' + storeResponse[0].Last_Name__c + ', ' + storeResponse[0].First_Name__c + '   ' + storeResponse[0].Phone_Number__c + '   ' + storeResponse[0].Email__c);
	                    	} else {
	                    		component.set("v.originatorText",storeResponse[0].Originator_Type__c + '   ' + storeResponse[0].Last_Name__c + ', ' + storeResponse[0].First_Name__c + '   ' + storeResponse[0].Phone_Number__c + '   ' + storeResponse[0].Email__c);
	                    	}
	                        component.set("v.enableEditButton", true);
	                        component.set("v.validateOriginator", true);
	                    }
	                }
	            });
	            $A.enqueueAction(action);
            }
            //populate group
            if(caseInfo.Subject_Group_ID__c != null && caseInfo.Subject_Group_ID__c != undefined && caseInfo.Subject_Group_ID__c != ''){
            	component.set("v.searchGroupPolicyNum", caseInfo.Subject_Group_ID__c);
            }
            //populate member
            if(caseInfo.Subject_Type__c == 'Member' && caseInfo.ID__c != null && caseInfo.ID__c != undefined && caseInfo.ID__c != ''){
            	component.set("v.searchMemberIdSSN", caseInfo.ID__c);
            }
            //populate broker
            if(caseInfo.Broker_ID__c != null && caseInfo.Broker_ID__c != undefined && caseInfo.Broker_ID__c != ''){
            	component.set("v.searchBroker", caseInfo.Broker_ID__c);
            }
            //populate interaction type
            if(caseInfo.Interaction__r.Interaction_Type__c != null && caseInfo.Interaction__r.Interaction_Type__c != undefined && caseInfo.Interaction__r.Interaction_Type__c != ''){
            	component.set("v.interactionType", caseInfo.Interaction__r.Interaction_Type__c);
            	if(caseInfo.Status == "BOT"){
            		var intType = component.find("searchInteractionType");
            		intType.set("v.disabled", true);
            	}
            }
            //populate event received date/time
            if(caseInfo.Event_Received_Date_Time__c != null && caseInfo.Event_Received_Date_Time__c != undefined && caseInfo.Event_Received_Date_Time__c != ''){
            	console.log('CORRECTING TIME1: ' + caseInfo.Event_Received_Date_Time__c);
            	//caseInfo.Event_Received_Date_Time__c = $A.localizationService.formatDateTime(caseInfo.Event_Received_Date_Time__c, "yyyy-MM-dd\'T\'HH:mm:ss.SSSZ");
            	var actionDate = component.get("c.correctTimezone");
            	actionDate.setParams({
            		eventDate: caseInfo.Event_Received_Date_Time__c
            	});
            	actionDate.setCallback(this,function(response){
            		console.log('RETURNED DATETIME: ' + response.getReturnValue());
            		caseInfo.Event_Received_Date_Time__c = response.getReturnValue();
                	if(caseInfo.Event_Received_Date_Time__c.includes('\'T\'')){
                		var eventDate = caseInfo.Event_Received_Date_Time__c.split('\'T\'')[0];
                		console.log('DATE CHECK1: ' + eventDate);
                		component.set("v.eventReceivedDate", eventDate);
                		var eventTime = caseInfo.Event_Received_Date_Time__c.split('\'T\'')[1];
                		console.log('TIME CHECK1: ' + eventTime);
                		if(caseInfo.Event_Received_Date_Time__c.includes('-')){
                			caseInfo.Event_Received_Date_Time__c = caseInfo.Event_Received_Date_Time__c.split('-')[0];
                		} else if(caseInfo.Event_Received_Date_Time__c.includes('+')){
                			caseInfo.Event_Received_Date_Time__c = caseInfo.Event_Received_Date_Time__c.split('+')[0];
                		}
                		console.log('TIME CHECK2: ' + eventTime);
                		component.set("v.eventReceivedTime", eventTime);
                		
                	} else if(caseInfo.Event_Received_Date_Time__c.includes('T')){
                		var eventDate = caseInfo.Event_Received_Date_Time__c.split('T')[0];
                		console.log('DATE CHECK1: ' + eventDate);
                		component.set("v.eventReceivedDate", eventDate);
                		var eventTime = caseInfo.Event_Received_Date_Time__c.split('T')[1];
                		console.log('TIME CHECK1: ' + eventTime);
                		if(caseInfo.Event_Received_Date_Time__c.includes('-')){
                			caseInfo.Event_Received_Date_Time__c = caseInfo.Event_Received_Date_Time__c.split('-')[0];
                		} else if(caseInfo.Event_Received_Date_Time__c.includes('+')){
                			caseInfo.Event_Received_Date_Time__c = caseInfo.Event_Received_Date_Time__c.split('+')[0];
                		}
                		console.log('TIME CHECK2: ' + eventTime);
                		component.set("v.eventReceivedTime", eventTime);
                		
                	}
            	});
            	$A.enqueueAction(actionDate);
            	
            }
            //resolution field
            if(caseInfo.Special_Instructions_Description__c != null && caseInfo.Special_Instructions_Description__c != undefined && caseInfo.Special_Instructions_Description__c != ''){
            	component.set("v.searchResolution", caseInfo.Special_Instructions_Description__c);
            }
            if(caseInfo.Special_Instructions_Business_Unit__c != null && caseInfo.Special_Instructions_Business_Unit__c != undefined && caseInfo.Special_Instructions_Business_Unit__c != ''){
            	component.set("v.businessUnitText", caseInfo.Special_Instructions_Business_Unit__c);
            	component.set("v.businessUnitSelected",caseInfo.Special_Instructions_Business_Unit__c);
        		if(caseInfo.Issue_Category_Desc__c != null && caseInfo.Issue_Category_Desc__c != undefined && caseInfo.Issue_Category_Desc__c != ''){
                	component.set("v.topicSelected",caseInfo.Issue_Category_Desc__c);
                	component.set("v.topicText", caseInfo.Issue_Category_Desc__c);
                }
            }
            
        } else if(!$A.util.isUndefinedOrNull(component.get("v.pageReference").state.c__InteractionRecord)){
        	component.set("v.updateCaseInteractionInfo",component.get("v.pageReference").state.c__InteractionRecord);
            console.log('HERE IS INTERACTION: ' + JSON.stringify(component.get("v.updateCaseInteractionInfo")));
            component.set('v.createCaseFromIntBool', true);
            var interactionInfo = component.get("v.updateCaseInteractionInfo");
            if(interactionInfo.Current_Status__c != null && interactionInfo.Current_Status__c != undefined && interactionInfo.Current_Status__c != '' && interactionInfo.Current_Status__c != 'New') {
            	component.set('v.createCaseFromIntBoolNotNew', true);       
            }
            //need to get originator info
            if(interactionInfo.Originator_Name__c != null && interactionInfo.Originator_Name__c != undefined && interactionInfo.Originator_Name__c != ''){
            	//search for originator
            	var action = component.get("c.findOriginatorUpdate");
	            action.setParams({
	                origName: interactionInfo.Originator_Name__c,
	                origType: interactionInfo.Originator_Type__c,
	                origPhone: interactionInfo.Originator_Phone__c,
	                origEmail: interactionInfo.Originator_Email__c,
                    origSFID: interactionInfo.Originator_SFID__c
	            });
				action.setCallback(this,function(response){
	                var state = response.getState();
	                console.log('STATE: ' + state);
	                if(state == "SUCCESS"){
	                    var storeResponse = response.getReturnValue();
	                    console.log('ORIG RESULTS: ' + JSON.stringify(storeResponse));
	                    var dropdownOptions = [];
	                    if(storeResponse.length == 1){
	                    	component.set("v.originatorSelected",storeResponse[0]);
	                    	if(storeResponse[0].Originator_Type__c == 'Other Originator'){
	                    		component.set("v.originatorText",storeResponse[0].Other_Originator_Type__c + '   ' + storeResponse[0].Last_Name__c + ', ' + storeResponse[0].First_Name__c + '   ' + storeResponse[0].Phone_Number__c + '   ' + storeResponse[0].Email__c);
	                    	} else {
	                    		component.set("v.originatorText",storeResponse[0].Originator_Type__c + '   ' + storeResponse[0].Last_Name__c + ', ' + storeResponse[0].First_Name__c + '   ' + storeResponse[0].Phone_Number__c + '   ' + storeResponse[0].Email__c);
	                    	}
	                        component.set("v.enableEditButton", true);
	                        component.set("v.validateOriginator", true);
	                    }
	                }
	            });
	            $A.enqueueAction(action);
            }
          //populate interaction type
            if(interactionInfo.Interaction_Type__c != null && interactionInfo.Interaction_Type__c != undefined && interactionInfo.Interaction_Type__c != ''){
            	component.set("v.interactionType", interactionInfo.Interaction_Type__c);
            }
            //populate event received date/time
            if(interactionInfo.Evt_Recvd_Dt_Time__c != null && interactionInfo.Evt_Recvd_Dt_Time__c != undefined && interactionInfo.Evt_Recvd_Dt_Time__c != ''){
            	var actionDate = component.get("c.correctTimezone");
            	actionDate.setParams({
            		eventDate: interactionInfo.Evt_Recvd_Dt_Time__c
            	});
            	actionDate.setCallback(this,function(response){
            		interactionInfo.Evt_Recvd_Dt_Time__c = response.getReturnValue();
	            	if(interactionInfo.Evt_Recvd_Dt_Time__c.includes('\'T\'')){
	            		var eventDate = interactionInfo.Evt_Recvd_Dt_Time__c.split('\'T\'')[0];
	            		console.log('DATE CHECK1: ' + eventDate);
	            		component.set("v.eventReceivedDate", eventDate);
	            		var eventTime = interactionInfo.Evt_Recvd_Dt_Time__c.split('\'T\'')[1];
	            		console.log('TIME CHECK1: ' + eventTime);
	            		if(interactionInfo.Evt_Recvd_Dt_Time__c.includes('-')){
	            			interactionInfo.Evt_Recvd_Dt_Time__c = interactionInfo.Evt_Recvd_Dt_Time__c.split('-')[0];
	            		} else if(interactionInfo.Evt_Recvd_Dt_Time__c.includes('+')){
	            			interactionInfo.Evt_Recvd_Dt_Time__c = interactionInfo.Evt_Recvd_Dt_Time__c('+')[0];
	            		}
	            		console.log('TIME CHECK2: ' + eventTime);
	            		component.set("v.eventReceivedTime", eventTime);
	            		
	            	} else if(interactionInfo.Evt_Recvd_Dt_Time__c.includes('T')){
	            		var eventDate = interactionInfo.Evt_Recvd_Dt_Time__c.split('T')[0];
	            		console.log('DATE CHECK1: ' + eventDate);
	            		component.set("v.eventReceivedDate", eventDate);
	            		var eventTime = interactionInfo.Evt_Recvd_Dt_Time__c.split('T')[1];
	            		console.log('TIME CHECK1: ' + eventTime);
	            		if(interactionInfo.Evt_Recvd_Dt_Time__c.includes('-')){
	            			interactionInfo.Evt_Recvd_Dt_Time__c = interactionInfo.Evt_Recvd_Dt_Time__c.split('-')[0];
	            		} else if(interactionInfo.Evt_Recvd_Dt_Time__c.includes('+')){
	            			interactionInfo.Evt_Recvd_Dt_Time__c = interactionInfo.Evt_Recvd_Dt_Time__c('+')[0];
	            		}
	            		console.log('TIME CHECK2: ' + eventTime);
	            		component.set("v.eventReceivedTime", eventTime);
	            		
	            	}
            	});
            	$A.enqueueAction(actionDate);
            }
            //business unit field moved to helper
        }

        
	
    

    },
    
    clearAll: function(component,event,helper){
        helper.clear(component,event);
    },
    getNewOriginatorType: function(cmp, event, helper){
                
        if(cmp.get('v.isResearchUser')) {
        	cmp.set("v.isCreateCase", true);    
        } else {
            cmp.set("v.isToggle", false);
            cmp.set("v.isCreateCase", false);
        }        
    	var newAdmin = cmp.get("v.originatorSelectedAdd");
    	var admType = newAdmin.Originator_Type__c;
    	if(admType == "None"){
	        newAdmin.First_Name__c = "";
	        newAdmin.Last_Name__c = "";
	        newAdmin.Phone_Number__c = "";
	        newAdmin.Phone_Ext__c = "";
	        newAdmin.Email__c = "";
    	}
        newAdmin.Agency_Broker_Name__c = "";
        newAdmin.Reward_Account_Number__c = "";
        newAdmin.General_Agency__c = "";
        newAdmin.Franchise_Code__c = "";
        newAdmin.Group_Name__c = "";
        newAdmin.Group_Number__c = "";
        newAdmin.Policy_Number__c = "";
        newAdmin.Other_Originator_Type__c = "None";
        cmp.set("v.originatorSelectedAdd", newAdmin);
    },
    toggleOneAndDone: function(component, event, helper){
        var checkCmp = component.find("oneAndDoneToggle").get("v.value");
        component.set("v.oneAndDoneBool",checkCmp);
        if(component.get("v.updateCaseBool") == true && component.get('v.oneAndDoneBool') == false){
            component.set("v.instructionSearchType", "Topic");
      		helper.searchInstructionRecords(component,event);
        }
    },
    
    editOriginator: function(component,event,helper){
        console.log('PREV EDIT: ' + JSON.stringify(component.get("v.originatorSelectedEdit")));
		var phone = component.get("v.originatorSelected").Phone_Number__c;
        console.log('PHONE: ' + phone);
        if(phone != null && phone != '' && phone.length == 10){
            if(!phone.includes('-')){
                phone = phone.substring(0,3) + '-' + phone.substring(3,6) + '-' + phone.substring(6,phone.length);
            }
        }      
        console.log('PHONE: ' + phone);
        var editOrig = {
        	Id: component.get("v.originatorSelected").Id,
            First_Name__c: component.get("v.originatorSelected").First_Name__c,
            Last_Name__c: component.get("v.originatorSelected").Last_Name__c,
            Phone_Number__c: phone,
            Phone_Ext__c: component.get("v.originatorSelected").Phone_Ext__c,
            Email__c: component.get("v.originatorSelected").Email__c,
            Originator_Type__c: component.get("v.originatorSelected").Originator_Type__c,
            Agency_Broker_Name__c: component.get("v.originatorSelected").Agency_Broker_Name__c,
            Reward_Account_Number__c: component.get("v.originatorSelected").Reward_Account_Number__c,
            General_Agency__c: component.get("v.originatorSelected").General_Agency__c,
            Franchise_Code__c: component.get("v.originatorSelected").Franchise_Code__c,
            Group_Name__c: component.get("v.originatorSelected").Group_Name__c,
            Group_Number__c: component.get("v.originatorSelected").Group_Number__c,
            Policy_Number__c: component.get("v.originatorSelected").Policy_Number__c,
            Other_Originator_Type__c : component.get("v.originatorSelected").Other_Originator_Type__c
        }
        component.set("v.originatorSelectedEdit", editOrig);
        if(editOrig.Originator_Type__c == 'Agency/Broker' || editOrig.Originator_Type__c == 'General Agent' || editOrig.Originator_Type__c == 'Group Contact'){
        	component.set("v.updateEditOriginatorTableBool", false);
        	component.set("v.editOriginatorTableBool", false);
            component.set("v.editOriginatorTableData", "");
            component.set("v.editOriginatorTableMessage", "");
        	helper.searchSolarisOriginatorEdit(component,event,helper);
    	}
        component.set("v.isContactModal", true);
        component.set("v.isEditContactModal", true);
        component.set("v.isNewContactModal", false);
    },
    
    submitEditContactDetails: function(component,event,helper){
        var trimEdit = component.get("v.originatorSelectedEdit");
        trimEdit.First_Name__c = (trimEdit.First_Name__c != null && trimEdit.First_Name__c != '')?trimEdit.First_Name__c.trim():'';
        trimEdit.Last_Name__c = (trimEdit.Last_Name__c != null && trimEdit.Last_Name__c != '')?trimEdit.Last_Name__c.trim():'';
        trimEdit.Phone_Number__c = (trimEdit.Phone_Number__c != null && trimEdit.Phone_Number__c != '')?trimEdit.Phone_Number__c.trim():'';
        trimEdit.Email__c = (trimEdit.Email__c != null && trimEdit.Email__c != '')?trimEdit.Email__c.trim():'';
        component.set("v.originatorSelectedEdit", trimEdit);
        if(helper.validateEditContact(component,event,helper)){
        	var origEdit = component.get("v.originatorSelectedEdit");
        	if(origEdit.Originator_Type__c ==  "Agency/Broker" || origEdit.Originator_Type__c ==  "General Agent" || origEdit.Originator_Type__c ==  "Group Contact"){
        		//helper.searchSolarisOriginatorEdit(component,event,helper);
        		console.log('TABLE BOOL: ' + component.get('v.updateEditOriginatorTableBool'));
        		/* US2623754 - Originator - Remove Validation
                 * remove functionality to stop user from creating a case without having valid information compared to Solaris (reward account number, franchise code, group/policy number)
                 * temporarily removed until solaris data is more complete
        		if(component.get('v.updateEditOriginatorTableBool') == true){
        		*/
                    component.set("v.originatorSelected", component.get("v.originatorSelectedEdit"));
                    var selCon = component.get("v.originatorSelected");
                    var selLabel = '';
                    if(selCon.Originator_Type__c == 'Other Originator'){
                        selLabel = selCon.Other_Originator_Type__c + '   ' + selCon.Last_Name__c + ', ' + selCon.First_Name__c + '   ' + selCon.Phone_Number__c + '   ' + selCon.Email__c;
                    } else {
                        selLabel = selCon.Originator_Type__c + '   ' + selCon.Last_Name__c + ', ' + selCon.First_Name__c + '   ' + selCon.Phone_Number__c + '   ' + selCon.Email__c;
                    }
                    helper.submitEditCustomerAdmin(component, event, helper);
                    component.set("v.originatorText", selLabel);
                    var origField = component.find("originatorField");
                    $A.util.removeClass(origField, "slds-has-error");  
                    component.find("validateOriginatorError").set("v.errors", null);
                    component.set("v.validateOriginator", true);
                    helper.closeModal(component,event);
                    /* US2623754 - Originator - Remove Validation
                     * remove functionality to stop user from creating a case without having valid information compared to Solaris (reward account number, franchise code, group/policy number)
                     * temporarily removed until solaris data is more complete
                    } else {
                	console.log('INSIDE TOAST ELSE');
                    helper.fireToast('Update Originator with valid information.', "10000");
                }*/
        	} else {
	        	component.set("v.originatorSelected", component.get("v.originatorSelectedEdit"));
	            var selCon = component.get("v.originatorSelected");
	            var selLabel = '';
	            if(selCon.Originator_Type__c == 'Other Originator'){
	            	selLabel = selCon.Other_Originator_Type__c + '   ' + selCon.Last_Name__c + ', ' + selCon.First_Name__c + '   ' + selCon.Phone_Number__c + '   ' + selCon.Email__c;
	            } else {
	            	selLabel = selCon.Originator_Type__c + '   ' + selCon.Last_Name__c + ', ' + selCon.First_Name__c + '   ' + selCon.Phone_Number__c + '   ' + selCon.Email__c;
	            }
	            helper.submitEditCustomerAdmin(component, event, helper);
	            component.set("v.originatorText", selLabel);
	            var origField = component.find("originatorField");
                $A.util.removeClass(origField, "slds-has-error");  
                component.find("validateOriginatorError").set("v.errors", null);
                component.set("v.validateOriginator", true);
	            helper.closeModal(component,event);
        	}
    	}
    },
    
    addOriginator: function(component,event,helper){
        var addOrig = {
            First_Name__c: "",
            Last_Name__c: "",
            Phone_Number__c: "",
            Phone_Ext__c: "",
            Email__c: "",
            Originator_Type__c: "None",
            Agency_Broker_Name__c: "",
            Reward_Account_Number__c: "",
            General_Agency__c: "",
            Franchise_Code__c: "",
            Group_Name__c: "",
            Group_Number__c: "",
            Policy_Number__c: "",
            Other_Originator_Type__c: "None"
        };
        component.set("v.originatorSelectedAdd", addOrig);
        if(addOrig.Originator_Type__c == 'Agency/Broker' || addOrig.Originator_Type__c == 'General Agent' || addOrig.Originator_Type__c == 'Group Contact'){
        	component.set("v.updateAddOriginatorTableBool", false);
        	component.set("v.addOriginatorTableBool", false);
            component.set("v.addOriginatorTableData", "");
            component.set("v.addOriginatorTableMessage", "");
    	}
        component.set("v.isContactModal", true);
        component.set("v.isEditContactModal", false);
        component.set("v.isNewContactModal", true);
    },
    
    submitAddContactDetails: function(component,event,helper){
    	var trimEdit = component.get("v.originatorSelectedAdd");
        trimEdit.First_Name__c = trimEdit.First_Name__c.trim();
        trimEdit.Last_Name__c = trimEdit.Last_Name__c.trim();
        trimEdit.Phone_Number__c = trimEdit.Phone_Number__c.trim();
        trimEdit.Email__c = trimEdit.Email__c.trim();
        component.set("v.originatorSelectedAdd", trimEdit);
        if(helper.validateAddContact(component,event,helper)){
        	var origAdd = component.get("v.originatorSelectedAdd");
        	if(origAdd.Originator_Type__c ==  "Agency/Broker" || origAdd.Originator_Type__c ==  "General Agent" || origAdd.Originator_Type__c ==  "Group Contact"){
        		//helper.searchSolarisOriginatorEdit(component,event,helper);
        		/* US2623754 - Originator - Remove Validation
                 * remove functionality to stop user from creating a case without having valid information compared to Solaris (reward account number, franchise code, group/policy number)
                 * temporarily removed until solaris data is more complete
        		if(component.get('v.updateAddOriginatorTableBool') == true){
        		*/
		            component.set("v.originatorSelected", component.get("v.originatorSelectedAdd"));
		            
		            var selCon = component.get("v.originatorSelected");
		            var selLabel = '';
		            if(selCon.Originator_Type__c == 'Other Originator'){
		            	selLabel = selCon.Other_Originator_Type__c + '   ' + selCon.Last_Name__c + ', ' + selCon.First_Name__c + '   ' + selCon.Phone_Number__c + '   ' + selCon.Email__c;
		            } else {
		            	selLabel = selCon.Originator_Type__c + '   ' + selCon.Last_Name__c + ', ' + selCon.First_Name__c + '   ' + selCon.Phone_Number__c + '   ' + selCon.Email__c;
		            }
		            console.log('BEFORE SUBMIT');
		            helper.submitAddCustomerAdmin(component, event, helper);
		            component.set("v.originatorText", selLabel);
		            component.set("v.enableEditButton", true);
		            var origField = component.find("originatorField");
                    $A.util.removeClass(origField, "slds-has-error");  
                    component.find("validateOriginatorError").set("v.errors", null);
                    component.set("v.validateOriginator", true);
		            helper.closeModal(component,event);
	            /* US2623754 - Originator - Remove Validation
	             * remove functionality to stop user from creating a case without having valid information compared to Solaris (reward account number, franchise code, group/policy number)
	             * temporarily removed until solaris data is more complete
        		} else {
                    helper.fireToast('Update Originator with valid information.', "10000");
                }
                */
        	} else {
	        	component.set("v.originatorSelected", component.get("v.originatorSelectedAdd"));
	            var selCon = component.get("v.originatorSelected");
	            var selLabel = '';
	            if(selCon.Originator_Type__c == 'Other Originator'){
	            	selLabel = selCon.Other_Originator_Type__c + '   ' + selCon.Last_Name__c + ', ' + selCon.First_Name__c + '   ' + selCon.Phone_Number__c + '   ' + selCon.Email__c;
	            } else {
	            	selLabel = selCon.Originator_Type__c + '   ' + selCon.Last_Name__c + ', ' + selCon.First_Name__c + '   ' + selCon.Phone_Number__c + '   ' + selCon.Email__c;
	            }
	            helper.submitAddCustomerAdmin(component, event, helper);
	            component.set("v.originatorText", selLabel);
	            component.set("v.enableEditButton", true);
	            var origField = component.find("originatorField");
                $A.util.removeClass(origField, "slds-has-error");  
                component.find("validateOriginatorError").set("v.errors", null);
                component.set("v.validateOriginator", true);
	            helper.closeModal(component,event);
        	}
        }
    },

    closeContactModal: function(component,event,helper){
        console.log('CLOSE EDIT: ' + JSON.stringify(component.get("v.originatorSelectedEdit")));
        console.log('GET ORIG: ' + JSON.stringify(component.get("v.originatorSelected")));
        component.set("v.originatorSelectedEdit", "");
        component.set("v.originatorSelectedAdd", "");
        component.set("v.isContactModal", false);
        component.set("v.isEditContactModal", false);
        component.set("v.isNewContactModal", false);
        component.set("v.updateEditOriginatorTableBool", false);
        component.set("v.editOriginatorTableBool", false);
        component.set("v.editOriginatorTableData", "");
        component.set('v.editOriginatorTableMessage', "");
        component.set("v.updateAddOriginatorTableBool", false);
    	component.set('v.addOriginatorTableBool',false);
		component.set('v.addOriginatorTableData','');
		component.set('v.addOriginatorTableMessage', "");
    },
    
    validateNames: function(component,event,helper){
        var keyCode = event.keyCode;
    	var str = String.fromCharCode(keyCode);
    	//check for dash and apostrophe
    	if(keyCode == 45 || keyCode == 39){
    		return true;
    	} else if(/^[a-zA-Z ]+$/.test(str)){
    		return true;
    	} else {
    		event.preventDefault();
    		return false;
    	}
    },
    
    validatePhone: function(component, event, helper){
    	var keyCode = event.keyCode;
    	var str = String.fromCharCode(keyCode);
    	//check for dash and apostrophe
    	if(keyCode == 45){
    		return true;
    	} else if(/^[0-9]/g.test(str)){
    		return true;
    	} else {
    		event.preventDefault();
    		return false;
    	}
    },
    validateNumeric: function(cmp, event, helper){
    	var keyCode = event.keyCode;
    	var str = String.fromCharCode(keyCode);
    	//check for dash and apostrophe
    	if(/^[0-9]/g.test(str)){
    		return true;
    	} else {
    		event.preventDefault();
    		return false;
    	}
    },
    validateAlphaNumeric: function(cmp, event, helper){
    	var keyCode = event.keyCode;
    	var str = String.fromCharCode(keyCode);
    	//check for dash and apostrophe
    	if(/^[A-Za-z0-9]/g.test(str)){
    		return true;
    	} else {
    		event.preventDefault();
    		return false;
    	}
    },
    validateEmailAddress : function(cmp, event, helper) {
         var custEmail = cmp.find("newEmail");
         var custEmailVal = '';
         var errorAuraId = '';
         if(custEmail != undefined && custEmail != null) {
            custEmailVal = custEmail.get("v.value"); 
            errorAuraId = 'newEmailError';
         } else {
            custEmail = cmp.find("editEmail");
             if(custEmail != undefined && custEmail != null) {
             	custEmailVal = custEmail.get("v.value"); 
            	errorAuraId = 'emailError';    
             }            
         }
         if(custEmailVal != undefined && custEmailVal != null && custEmailVal != '') {
             var regExpEmailformat = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/; 
             if(!(custEmail.get("v.value").match(regExpEmailformat))) {
                 $A.util.addClass(custEmail, "slds-has-error");
                 cmp.find(errorAuraId).set("v.errors", [{message:"You have entered an invalid format."}]);
                 return false;
             }
         } else {
         	return true;    
         }         
     },
    
    addHyphen : function (cmp, event, helper) {        
        // formatting the phone number into xxx-xxx-xxxx while typing
        var fieldValue = cmp.get("v.originatorSelectedEdit.Phone_Number__c");
        fieldValue = fieldValue.replace(/\D/g,'');
        var newValue = '';
        var count = 0;
        while(fieldValue.length > 3) {
            if(count < 2) {
                newValue += fieldValue.substr(0, 3) + '-';
                fieldValue = fieldValue.substr(3);
                count++;
            }
            if(count == 2) {
                break;
            }			
        }
        newValue += fieldValue;
        if(newValue.length > 12){
        	newValue = newValue.substr(0,12);
    	}
        cmp.set("v.originatorSelectedEdit.Phone_Number__c",newValue);         
    },
    
    addNewHyphen : function (cmp, event, helper) {        
        // formatting the phone number into xxx-xxx-xxxx while typing
        var fieldValue = cmp.get("v.originatorSelectedAdd.Phone_Number__c");
        fieldValue = fieldValue.replace(/\D/g,'');
        var newValue = '';
        var count = 0;
        while(fieldValue.length > 3) {
            if(count < 2) {
                newValue += fieldValue.substr(0, 3) + '-';
                fieldValue = fieldValue.substr(3);
                count++;
            }
            if(count == 2) {
                break;
            }			
        }
        newValue += fieldValue;
        if(newValue.length > 12){
        	newValue = newValue.substr(0,12);
    	}
        cmp.set("v.originatorSelectedAdd.Phone_Number__c",newValue);         
    },
    
    searchOriginatorOnEnter: function(component, event, helper){
        var isEnterKey = event.keyCode === 13;
        var isBackspaceKey = event.keyCode === 8;
        if (isEnterKey) {
        	var filterList = component.get("v.originatorFilter");
        	if(filterList != null && filterList != [] && filterList.length > 0 && filterList[0] != undefined){
	        	component.set("v.originatorSelected",JSON.parse(filterList[0].value));
	        	component.set("v.originatorText",filterList[0].label);
	        	component.set("v.displayOriginator", false);
                component.set("v.enableEditButton", true);
                var origField = component.find("originatorField");
                $A.util.removeClass(origField, "slds-has-error");  
                component.find("validateOriginatorError").set("v.errors", null);
                var selOrig = component.get('v.originatorSelected');
                if(selOrig.Originator_Type__c == 'Agency/Broker' || selOrig.Originator_Type__c == 'General Agent' || selOrig.Originator_Type__c == 'Group Contact'){
                	helper.validateSolarisOriginator(component,event,helper);
                } else {
                	component.set("v.validateOriginator", true);
                }
        	}
        } else if(isBackspaceKey){
            component.set("v.originatorSelected","");
            component.set("v.displayOriginator", false);
            component.set("v.enableEditButton", false);
        }
    },
    clickOriginator: function(component, event, helper){
        helper.closeAllDropdownsHelper(component,event);
        //component.set("v.originatorFilter", component.get("v.originatorOptions"));
        if(component.get('v.originatorFilter').length > 0){
            component.set("v.displayOriginator", true);
        }
    },
    originatorTextChange: function(component, event, helper){
        helper.filterOriginators(component, event, helper);
    },
    getOriginatorInfo: function(component, event, helper){
        var selLabel = event.currentTarget.getAttribute("data-label");
        var selValue = JSON.parse(event.currentTarget.getAttribute("data-value"));
    	component.set("v.originatorSelected",selValue);
    	component.set("v.originatorText", selLabel);
        component.set("v.originatorFilter", []);
        component.set("v.displayOriginator", false);
        component.set("v.enableEditButton", true);
        var origField = component.find("originatorField");
        $A.util.removeClass(origField, "slds-has-error");  
        component.find("validateOriginatorError").set("v.errors", null);
        var selOrig = component.get('v.originatorSelected');
        //Change:US2605764
        var policyNum=component.get("v.searchGroupPolicyNum");     
        component.set("v.searchGroupPolicyNum",[]);
        if(selOrig.Originator_Type__c == 'Agency/Broker' || selOrig.Originator_Type__c == 'General Agent' || selOrig.Originator_Type__c == 'Group Contact'){
            helper.validateSolarisOriginator(component,event,helper);
             //Change:US2605764
           if(selOrig.Originator_Type__c == 'Group Contact'){ 
               var stringArray = selLabel.split(',');    
               component.set("v.searchGroupPolicyNum",stringArray[1]);
           }
            
        } else {
        	component.set("v.validateOriginator", true);
        }
    },
    changeIntType: function(component,event,helper){
    	console.log('INT TYPE: ' + component.get('v.interactionType'));
    	console.log('EVENT DATE IN: ' + component.get('v.eventReceivedDate'));
    	console.log('EVENT TIME IN: ' + component.get('v.eventReceivedTime'));
        if(component.get('v.isResearchUser')) {
        	component.set("v.isCreateCase", true);    
        } else {
            component.set("v.isToggle", false);
            component.set("v.isCreateCase", false);
        } 
    	if(component.get('v.oneAndDoneBool') == false && component.get('v.interactionType') == 'Phone Call'){
    		var d = new Date();
    		console.log('SET DATE1: ' + d);
    		var month = d.getMonth() + 1;
    		var day = d.getDate();
    		if(month < 10){
    			month = '0' + month;
    		}
    		if(day < 10){
    			day = '0' + day;
    		}
    		var newDate = d.getFullYear() + '-' + month + '-' + day;
    		console.log('SET DATE2: ' + newDate);
    		component.set('v.eventReceivedDate',newDate);
    		var hours = d.getHours();
    		var mins = d.getMinutes();
            if(hours < 10){
                hours = '0' + hours;
            }
    		if(mins < 10){
    			mins = '0' + mins;
    		}
    		var newTime = hours + ':' + mins +':00.000';
    		console.log('SET DATE3: ' + newTime);
    		component.set('v.eventReceivedTime',newTime);
    	}
    	console.log('EVENT DATE OUT: ' + component.get('v.eventReceivedDate'));
    	console.log('EVENT TIME OUT: ' + component.get('v.eventReceivedTime'));
    }, 
    searchPlatformonEnter: function(component, event, helper){
    	var isEnterKey = event.keyCode === 13;
        if (isEnterKey) { 
        	var filterList = component.get("v.platformFilter");
        	if(filterList != null && filterList != [] && filterList[0] != undefined){
	        	component.set("v.platformSelected",filterList[0].value);
	        	component.set("v.platformText",filterList[0].label);
                component.set("v.displayPlatform", false);
        	}
        }
    },
    clickPlatform: function(component, event, helper){
    	component.set("v.platformFilter", component.get("v.platformOptions"));
    	if(component.get("v.platformText") == "None"){
    		component.set("v.platformText", "");
    	}
         component.set("v.displayPlatform", true);
         component.find("focus:platform").focus();//US2594886
    },
    platformTextChange: function(component, event, helper){
    	var typeText = component.get('v.platformText');
        var dataList = component.get("v.platformOptions");
        if (typeText == undefined || typeText == '') {
            component.set('v.platformFilter', dataList);
            component.set('v.displayPlatform', false);
            return;
        }
        typeText = typeText.toLowerCase();
        var dataListFilter = [];
        for (var i = 0; i < dataList.length; i++) {
            if ((dataList[i].value.toLowerCase().indexOf(typeText) != -1) || (dataList[i].label.toLowerCase().indexOf(typeText) != -1)) {
                dataListFilter.push(dataList[i]);
            }
        }
        if (dataListFilter.length > 0) {
            component.set('v.platformFilter', dataListFilter);
            component.set('v.displayPlatform', true);
        } else {
            component.set('v.platformFilter', dataList);
        }
    },
    getPlatformInfo: function(component, event, helper){
    	var selLabel = event.currentTarget.getAttribute("data-label");
    	var selValue = event.currentTarget.getAttribute("data-value");
    	component.set("v.platformSelected",selValue);
    	component.set("v.platformText", selLabel);
        component.set('v.displayPlatform', false);
        component.find("focus:platform").focus();//US2594886
    },
    clickBusinessUnit: function(component, event, helper){

        if(component.get('v.isResearchUser')) {
        	component.set("v.isCreateCase", true);    
        } else {
            component.set("v.isToggle", false);
            component.set("v.isCreateCase", false);
        } 
    	helper.closeAllDropdownsHelper(component,event);
    	component.set("v.businessUnitFilter", component.get("v.businessUnitOptions"));
    	if(component.get("v.businessUnitText") == "None"){
    		component.set("v.businessUnitText", "");
    	}
        component.set("v.displayBU", true);   
    },
    businessUnitTextChange: function(component, event, helper){
    	component.set("v.instructionSearchType", "Topic");
    	//helper.resetFields(component,event);
    	if(component.get('v.isResearchUser')) {
        	component.set("v.isCreateCase", true);    
        } else {
            component.set("v.isToggle", false);
            component.set("v.isCreateCase", false);
        } 
    	helper.filterBusinessUnits(component, event, helper);
    },
    searchBUonEnter: function(component, event, helper){
    	var isEnterKey = event.keyCode === 13;
        if (isEnterKey) {
        	var filterList = component.get("v.businessUnitFilter");
        	if(filterList != null && filterList != [] && filterList[0] != undefined){
	        	component.set("v.businessUnitSelected",filterList[0].label);
	        	component.set("v.businessUnitText",filterList[0].label);
	        	component.set("v.instructionSearchType", "Topic");
	        	helper.resetFields(component,event);
	    		helper.searchInstructionRecords(component,event);
        	}
        }
    },
    getBusinessUnitInfo: function(component, event, helper){
    	var selLabel = event.currentTarget.getAttribute("data-label");
    	component.set("v.businessUnitSelected",selLabel);
    	component.set("v.businessUnitText", selLabel);
    	component.set("v.instructionSearchType", "Topic");
    	helper.resetFields(component,event);
		helper.searchInstructionRecords(component,event);
         if(component.find(("focus:businesUNIT"))!=undefined){
           component.find("focus:businesUNIT").focus();      //US2594886        
         }
        if(component.find(("focus:businesunit"))!=undefined){ 
            component.find("focus:businesunit").focus();   //DE380576
        }
        component.set("v.displayBU", false);     
    },
	clickTopic: function(component, event, helper){
      
        if(component.get('v.isResearchUser')) {
        	component.set("v.isCreateCase", true);    
        } else {
            component.set("v.isToggle", false);
            component.set("v.isCreateCase", false);
        }
    	helper.closeAllDropdownsHelper(component,event);
    	component.set("v.topicFilter", component.get("v.topicOptions"));
    	if(component.get("v.topicText") == "None"){
    		component.set("v.topicText", "");
    	}
       
        component.set("v.displayTopic", true);
        
    },
    topicTextChange:function(component, event, helper){
    	component.set("v.instructionSearchType", "Type");
        if(component.get('v.isResearchUser')) {
        	component.set("v.isCreateCase", true);    
        } else {
            component.set("v.isToggle", false);
            component.set("v.isCreateCase", false);
        }
    	helper.resetFields(component,event);
    	helper.filterTopics(component, event, helper);
    },
    searchTopiconEnter: function(component, event, helper){
    	var isEnterKey = event.keyCode === 13;
        if (isEnterKey) {
        	var filterList = component.get("v.topicFilter");
        	if(filterList != null && filterList != [] && filterList[0] != undefined){
	        	component.set("v.topicSelected",filterList[0].label);
	        	component.set("v.topicText",filterList[0].label);
	        	component.set("v.instructionSearchType", "Type");
	        	helper.resetFields(component,event);
	    		helper.searchInstructionRecords(component,event);
        	}
        }
    },
    getTopicInfo: function(component, event, helper){
    	var selLabel = event.currentTarget.getAttribute("data-label");
    	component.set("v.topicSelected",selLabel);
    	component.set("v.topicText", selLabel);
		component.set("v.instructionSearchType", "Type");
    	helper.resetFields(component,event);
        helper.searchInstructionRecords(component,event);
        if(component.find("focus:IC")!=undefined){
          component.find("focus:IC").focus();  //US2594886
        }
        if(component.find("focus:ICat")!=undefined){
            component.find("focus:ICat").focus();  //DE380576
        }
    },
    clickGroup: function(component, event, helper){
        helper.closeAllDropdownsHelper(component,event);
    },
    clickBroker: function(component, event, helper){
        helper.closeAllDropdownsHelper(component,event);
    },
    clickMember: function(component, event, helper){
        helper.closeAllDropdownsHelper(component,event);
    },
    getGroupInfo: function(component, event, helper){
        var selLabel = event.currentTarget.getAttribute("data-label");
        var selValue = JSON.parse(event.currentTarget.getAttribute("data-value"));
    	component.set("v.groupSelected",selValue);
    	component.set("v.searchGroupPolicyNum", selLabel);
        component.set("v.groupSearchResults", []);
        component.set("v.displayGroup", false);
    },
    getBrokerInfo: function(component, event, helper){
        var selLabel = event.currentTarget.getAttribute("data-label");
        var selValue = JSON.parse(event.currentTarget.getAttribute("data-value"));
    	component.set("v.producerSelected",selValue);
    	component.set("v.searchBroker", selLabel);
        component.set("v.brokerList", []);
        component.set("v.displayBroker", false);
    },
    getMemberInfo: function(component, event, helper) {
    var spinner = component.find("dropdown-spinner2");
    $A.util.removeClass(spinner, "slds-hide");
    $A.util.addClass(spinner, "slds-show");
    if (component.get("v.platformSelected") != "None") {
      component.set("v.displayMember", false);
      var selLabel = event.currentTarget.getAttribute("data-label");
      var selValue = JSON.parse(event.currentTarget.getAttribute("data-value"));
      var memId = component.get("v.searchMemberIdSSN");
      var memberData = {
        sourceCode: selValue.sourceSysCode,
        Name: selValue.fullName,
        DOB: selValue.birthDate,
        firstName: selValue.firstName,
        lastName: selValue.lastName,
        memberID: memId.trim(),
        payerID: selValue.payerID,
        groupNumber: selValue.groupNumber,
        searchOption: "MemberIDDateOfBirth",
        SSN: selValue.SSN
      };
      var newLabel1 = memberData.memberID + " - " + selLabel;

      component.set("v.searchMemberIdSSN", newLabel1);
      var formatDate = memberData.DOB;
      component.set("v.memberSelected", memberData);

      if (formatDate.includes("/")) {
        formatDate =
          formatDate.split("/")[2] +
          "-" +
          formatDate.split("/")[0] +
          "-" +
          formatDate.split("/")[1];
      }
      let lstExclusions = component.get("v.lstExlusions");
      //alert(lstExclusions.length);
      let mapExclusions = new Map();
      //mapExclusions.set('903797');
      for (let i = 0; lstExclusions.length > i; i++) {
        mapExclusions.set(
          lstExclusions[i].MasterLabel,
          lstExclusions[i].MasterLabel
        );
      }

      //US1761826 - UHC/Optum Exclusion UI : END
      var action;
      var isCallout = true;
      if (component.get("v.isMockEnabled")) {
        action = component.get("c.getElibilityMockData");
      } else {
        action = component.get("c.getMemberDetails");
      }
      var payerId = component.get("v.platformSelected");
      var memberDOBVar = component.get("v.memberDOB");
      var memberDOB = "";
      if (!$A.util.isEmpty(memberDOBVar)) {
        var memberDOBArray = memberDOBVar.split("/");
        memberDOB =
          memberDOBArray[2] + "-" + memberDOBArray[0] + "-" + memberDOBArray[1];
      }

      /*** US3076045 - End **/
      action.setParams({
        transactionId: null,
        memberId: memId,
        memberDOB: formatDate,
        firstName: memberData.firstName,
        lastName: memberData.lastName,
        groupNumber: "",
        searchOption: "MemberIDNameDateOfBirth",
        payerID: payerId
      });

      action.setCallback(this, function(response) {
        var state = response.getState();
        
        var result = response.getReturnValue();
       
        console.log(response.getReturnValue());
        

        if (state == "SUCCESS") {
          if (result.statusCode == 200) {
            if (
              result.resultWrapper != null &&
              result.resultWrapper != undefined &&
              result.resultWrapper.subjectCard != null &&
              result.resultWrapper.subjectCard != undefined
            ) {
              memberData.memberID =
                result.resultWrapper.subjectCard.memberId != null
                  ? result.resultWrapper.subjectCard.memberId
                  : memberData.memberID;
              console.log("UPDATED MEMBER: " + JSON.stringify(memberData));
              var gropnumber = result.resultWrapper.subjectCard.groupNumber;
              
                var isRestricted = false;
              if (mapExclusions.has(gropnumber)) {
                component.set("v.uhgAccess", "Yes");
                //DE414377
                if (component.get("v.userInfo").UHG_Access__c == "No") {
                  isRestricted = true;
                  var spinner2 = component.find("dropdown-spinner2");
                  $A.util.removeClass(spinner2, "slds-show");
                  $A.util.addClass(spinner2, "slds-hide");
                  component.set("v.memberSelected", "{}");
                  var newLabel = memberData.memberID + " - " + selLabel;

                  component.set(
                    "v.searchMemberIdSSN",
                    component.get("v.searchMemberIdSSNdata")
                  );
                  helper.fireToast(
                    $A.get("$Label.c.UHG_Restriction_Validation")
                  );
                  component.set("v.displayMember", false);
                  component.set("v.memberList", []);
                  return;
                }
              }
              var spinner2 = component.find("dropdown-spinner2");
              $A.util.removeClass(spinner2, "slds-show");
              $A.util.addClass(spinner2, "slds-hide");
              component.set("v.memberSelected", memberData);
              var newLabel = memberData.memberID + " - " + selLabel;
              component.set("v.searchMemberIdSSN", newLabel);
            }
			else{
                var spinner2 = component.find("dropdown-spinner2");
              $A.util.removeClass(spinner2, "slds-show");
              $A.util.addClass(spinner2, "slds-hide");
                 var newLabel = memberData.memberID + " - " + selLabel;

                  component.set(
                    "v.searchMemberIdSSN",
                    newLabel
                  );
            }
          }
            else {
                var spinner2 = component.find("dropdown-spinner2");
                $A.util.removeClass(spinner2, "slds-show");
                $A.util.addClass(spinner2, "slds-hide");
                component.set("v.isMemberNotFound", true);
                component.set("v.searchMemberFirstName", "");
                component.set("v.searchMemberLastName", "");
                component.set("v.searchMemberDOB", "");
                
                component.set("v.searchMemberIdSSN", component.get("v.searchMemberIdSSNdata"));
                //result.message = null;
                if(result != null && result.message != null && result.message != ''){
                    helper.fireToast(result.message.replace(". ", ". \n"),"10000");
                } else if(result != null && result.message == '' ){
                    helper.fireToast("No Results Found.", "10000");
                } else {
                    helper.fireToast("Unexpected Error Occurred. Please Try Again.", "10000");
                }
            }
        }
      });
      $A.enqueueAction(action);
    } else if (component.get("v.platformSelected") == "None") {
      var spinner2 = component.find("dropdown-spinner2");
      $A.util.removeClass(spinner2, "slds-show");
      $A.util.addClass(spinner2, "slds-hide");
      helper.fireToast("Choose a Platform and Try Again.", "10000");
    }
  },
    closeAllDropdowns:function(component,event,helper){
		helper.closeAllDropdownsHelper(component,event);

	},
    /* keyCheck : function(cmp,event,helper){  //DE386008:Commented Out
        if(event.keyCode != 9){
            //event.preventDefault();//Commented to allow users to enter Date Manually:US2582573
            return false;
        }
    },*/
    searchForGroup: function(cmp,event,helper){
    	cmp.set("v.groupAPIResults", '');
    	cmp.set("v.groupDBResults", '');
        var groupId = cmp.get("v.searchGroupPolicyNum");
        if(groupId != null && groupId != undefined){
            //groupId = groupId.trim();
        }
        if(cmp.get('v.isResearchUser')) {
        	cmp.set("v.isCreateCase", true);    
        } else {
            cmp.set("v.isToggle", false);
            cmp.set("v.isCreateCase", false);
        }
        cmp.set("v.isGroupSearch", true);
        if(groupId != null && groupId != undefined && groupId != '' && !groupId.includes('-')){
        	var groupSearchAPIBool = false;
        	var groupSearchDBBool = false;
        	console.log('1. groupSearchAPIBool == ' + groupSearchAPIBool + '|||||' + 'groupSearchDBBool == ' + groupSearchDBBool);
        	setTimeout(function(){
        		var action = cmp.get("c.searchGroup");
	            action.setParams({
	                groupId : groupId
	            });
	            action.setCallback(this,function(response){
	                var state = response.getState();
	                console.log('STATE: ' + state);
	                if (state === "SUCCESS") {
	                	console.log('2. groupSearchAPIBool == ' + groupSearchAPIBool + '|||||' + 'groupSearchDBBool == ' + groupSearchDBBool);
	                	groupSearchAPIBool = true;
	                	console.log('3. groupSearchAPIBool == ' + groupSearchAPIBool + '|||||' + 'groupSearchDBBool == ' + groupSearchDBBool);
	                    if(!$A.util.isUndefinedOrNull(response.getReturnValue())) {
		                    if(response.getReturnValue().length>0){
		                    	console.log('API RESULTS: ' + response.getReturnValue());
		                        var results = JSON.parse(response.getReturnValue());
		                        if(!$A.util.isUndefinedOrNull(results)){
		                        	 cmp.set("v.groupAPIResults", results);
		                        }
		                    }
	                    }
                        if(groupSearchAPIBool == true){
                           
                            
                            var apiResult = cmp.get("v.groupAPIResults");

                            results = [];
                            /*if(dbResult != null && dbResult != undefined && dbResult != ''){
                                results = results.concat(dbResult);
                            }*/
	                    	if(apiResult != null && apiResult != undefined && apiResult != ''){
	                    		results = results.concat(apiResult);
	                    	}
	                    	console.log('results: ' + JSON.stringify(results));
	                    	console.log('results size: ' + results.length);
	                    	if(!$A.util.isUndefinedOrNull(results)){
	                    		var dropdownOptions = [];
	                            for (var i = 0; i < results.length; i++) {
	                                dropdownOptions.push({
                                        label: results[i].sourceCode + ' - ' + results[i].policyNumber + ' - ' + results[i].groupName + ' - ' + results[i].groupId+' - ' + results[i].platform,
                                        value: JSON.stringify(results[i])
	                                });
	                            }
	                    		
	                            if(results.length==0){
	                                var toastEvent = $A.get("e.force:showToast");
	                                toastEvent.setParams({
	                                    "type":"Error",
	                                    "message": "Search criteria returned no matches."
	                                });
	                                toastEvent.fire();
	                                cmp.set("v.displayGroup",false);
	                            	cmp.set("v.groupSearchResults", []);
	                            }
	                           
	                            else if(results.length>15){
	                                var toastEvent = $A.get("e.force:showToast");
	                                toastEvent.setParams({
	                                    "type":"Error",
	                                    "message": "Criteria has yielded more than 15 results.  Refine your search criteria"
	                                });
	                                toastEvent.fire();
	                                cmp.set("v.displayGroup",false);
	                            	cmp.set("v.groupSearchResults", []);
	                            } if(results.length>1){
	                            	console.log('DROPDOWN: ' + JSON.stringify(dropdownOptions));
	                            	cmp.set("v.displayGroup",true);
	                            	cmp.set("v.groupSearchResults", dropdownOptions);
	                            } else if(results.length == 1){
	                            	cmp.set("v.displayGroup",false);
	                            	cmp.set("v.groupSearchResults", []);
	                                if(results.length > 0){
	                                    cmp.set("v.groupSelected", results[0]);
	                                    if(results[0].groupId != null && results[0].groupName != null){
	                                        var groupLabel = '';
                                            groupLabel = results[0].sourceCode + ' - ' + results[0].policyNumber + ' - ' + results[0].groupName + ' - ' + results[0].groupId+' - ' + results[0].platform;
                                            cmp.set("v.searchGroupPolicyNum", groupLabel);
	                                    }
	                                }
	                                cmp.set("v.isGroupSearch", false);
	                            }
	                        }else{
	                            var toastEvent = $A.get("e.force:showToast");
	                            toastEvent.setParams({
	                                "type":"Error",
	                                "message": "Search criteria returned no matches."
	                            });
	                            toastEvent.fire();
	                            cmp.set("v.displayGroup",false);
	                        }
	                    }
	                }                
	            });
	            $A.enqueueAction(action);
        	},1);
            

            
            
            /* THIS IS A BACKUP FOR WHEN SBAM/SOLARIS MERGE AND WHEN THERE IS AN API FOR MERIT RATHER THAN STORING THE GROUP RECORD IN SALESFORCE
            var action = cmp.get("c.searchGroup");
            action.setParams({
                groupId : groupId
            });
            action.setCallback(this,function(response){
                var state = response.getState();
                console.log('STATE: ' + state);
                if (state === "SUCCESS") {
                    if(!$A.util.isUndefinedOrNull(response.getReturnValue())) {
                    if(response.getReturnValue().length>0){
                         cmp.set("v.displaygroupTable",true);
                        var results = JSON.parse(response.getReturnValue());
                        if(!$A.util.isUndefinedOrNull(results)){
                            if(results.length==0){
                                var toastEvent = $A.get("e.force:showToast");
                                toastEvent.setParams({
                                    "type":"Error",
                                    "message": "Search criteria returned no matches."
                                });
                                toastEvent.fire();
                                cmp.set("v.displaygroupTable",false);
                            }
                           
                            else if(results.length>15){
                                var toastEvent = $A.get("e.force:showToast");
                                toastEvent.setParams({
                                    "type":"Error",
                                    "message": "Criteria has yielded more than 15 results.  Refine your search criteria"
                                });
                                toastEvent.fire();
                                cmp.set("v.displaygroupTable",false);
                            }
                            else{
                                cmp.set("v.groupSearchResults",JSON.parse(response.getReturnValue()));
                                var groupVar = JSON.parse(response.getReturnValue());
                                if(groupVar.length > 0){
                                    cmp.set("v.groupSelected", groupVar[0]);
                                    if(groupVar[0].groupId != null && groupVar[0].groupName != null){
                                        var groupLabel = '';
                                        groupLabel = groupVar[0].groupId + ' - ' + groupVar[0].groupName;
                                        cmp.set("v.searchGroupPolicyNum", groupLabel);
                                    }
                                }
                                cmp.set("v.isGroupSearch", false);
                            }
                        }else{
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                "type":"Error",
                                "message": "Search criteria returned no matches."
                            });
                            toastEvent.fire();
                            cmp.set("v.displaygroupTable",false);
                        }
                    }else{
                        cmp.set("v.displaygroupTable",false);
                    }
                    }
                    
                   
                }                
            });
            $A.enqueueAction(action);
            */
        } else if(groupId == null || groupId == undefined || groupId == ''){
            cmp.set("v.groupSelected",null);
            cmp.set("v.isGroupSearch", false);
        }
    },
    searchForMember: function(component,event,helper){   
    	var spinner = component.find("dropdown-spinner2");
        $A.util.removeClass(spinner, "slds-hide");
        $A.util.addClass(spinner, "slds-show");
    	component.set("v.displayMember", false);
    	component.set("v.isMemberNotFound", false);
        component.set("v.displayMemberSection",false); //US2773499:Change
    	component.set("v.uhgAccess", "No");
        var memId = component.get("v.searchMemberIdSSN");

        if(memId != null && memId != undefined){
            memId = memId.trim();
        }
        if(component.get('v.isResearchUser')) {
        	component.set("v.isCreateCase", true);    
        } else {
            component.set("v.isToggle", false);
            component.set("v.isCreateCase", false);
        } 
        component.set("v.isMemberSearch", true);
        console.log('SELECTED PLATFORM: ' + component.get('v.platformSelected'));
        if((memId != null && memId != undefined && memId != '' && !memId.includes('-') && memId.length >= 9) && component.get("v.platformSelected") != 'None'){
            var searchOptionVal ='';
            var action = component.get('c.searchMembers');
            component.set("v.searchMemberIdSSNdata",memId); 
            var memberDetails = {
                "memberId": memId,
                "memberDOB": '',
                "firstName": '',
                "lastName": '',
                "groupNumber": '',
                "searchOption": '',
                "payerID":   '', //"87726", US1944108 - Accommodate Multiple Payer ID's 
                "providerFlow": "Other"
            };
            var memberDetailsJSON = JSON.stringify(memberDetails);
            action.setParams({
                "memberDetails": memberDetailsJSON
            });
            action.setCallback(this, function (response) {
    
                var state = response.getState(); // get the response state
                if (state == 'SUCCESS') {
                    var result = response.getReturnValue();
                    //console.log('##RESP:'+JSON.stringify(result));
                    console.log('code?>>>> ' + result.statusCode);
                    if (result.statusCode == 200) {
                        var storeResponse = result.resultWrapper.lstSAEMemberStandaloneSearch;
                        if(storeResponse != null && storeResponse != undefined && storeResponse.length > 0){
                        	var dropdownOptions = [];
                            for (var i = 0; i < storeResponse.length; i++) {
                                dropdownOptions.push({
                                    label: storeResponse[i].sourceSysCode + '   ' + storeResponse[i].fullName + '   ' + storeResponse[i].birthDate,
                                    value: JSON.stringify(storeResponse[i])
                                });
                            }
                            if (dropdownOptions.length >= 1) {
                                component.set('v.memberList', dropdownOptions);
                                component.set('v.displayMember', true);
                                component.set("v.isMemberSearch", false);
                                var spinner2 = component.find("dropdown-spinner2");
            	                $A.util.removeClass(spinner2, "slds-show");
            	                $A.util.addClass(spinner2, "slds-hide");
                            } 
                            
                            else if(dropdownOptions.length == 1){
                                var selLabel = dropdownOptions[0].label;
                                var selValue = JSON.parse(dropdownOptions[0].value);
                                var memId = component.get("v.searchMemberIdSSN");
                                var memberData = {
                                    "sourceCode": selValue.sourceSysCode,
                                    "Name": selValue.fullName,
                                    "DOB": selValue.birthDate,
                                    "firstName": selValue.firstName,
                                    "lastName": selValue.lastName,
                                    "memberID": memId.trim(),
                                    "payerID":selValue.payerID,
                                    "groupNumber":selValue.groupNumber,
                                    "searchOption":'MemberIDDateOfBirth',
                                    "SSN":selValue.SSN
                                }
                        		
                                var formatDate = memberData.DOB;
	                            if(formatDate.includes('/')){
	                            	formatDate = formatDate.split('/')[2] + '-' + formatDate.split('/')[0] + '-' + formatDate.split('/')[1];	                            
	                            }
	                            let lstExclusions = component.get("v.lstExlusions");
	                            //alert(lstExclusions.length);
	                            let mapExclusions = new Map();
	                            //mapExclusions.set('706577', '706577');
	                            for(let i=0; lstExclusions.length > i; i++) {
	                                mapExclusions.set(lstExclusions[i].MasterLabel,lstExclusions[i].MasterLabel);
	                            }
                                
                                var action;
      var isCallout = true;
      if (component.get("v.isMockEnabled")) {
        action = component.get("c.getElibilityMockData");
      } else {
        action = component.get("c.getMemberDetails");
      }
      var payerId = component.get("v.platformSelected");
      var memberDOBVar = component.get("v.memberDOB");
      var memberDOB = "";
      if (!$A.util.isEmpty(memberDOBVar)) {
        var memberDOBArray = memberDOBVar.split("/");
        memberDOB =
          memberDOBArray[2] + "-" + memberDOBArray[0] + "-" + memberDOBArray[1];
      }

      /*** US3076045 - End **/
      action.setParams({
        transactionId: null,
        memberId: memId,
        memberDOB: formatDate,
        firstName: memberData.firstName,
        lastName: memberData.lastName,
        groupNumber: "",
        searchOption: "MemberIDNameDateOfBirth",
        payerID: payerId
      });

      action.setCallback(this, function(response) {
        var state = response.getState();
        
        var result = response.getReturnValue();
       
        
        

        if (state == "SUCCESS") {
          if (result.statusCode == 200) {
            if (
              result.resultWrapper != null &&
              result.resultWrapper != undefined &&
              result.resultWrapper.subjectCard != null &&
              result.resultWrapper.subjectCard != undefined
            ) {
              memberData.memberID =
                result.resultWrapper.subjectCard.memberId != null
                  ? result.resultWrapper.subjectCard.memberId
                  : memberData.memberID;
              
              var gropnumber = result.resultWrapper.subjectCard.groupNumber;
              
                var isRestricted = false;
              if (mapExclusions.has(gropnumber)) {
                component.set("v.uhgAccess", "Yes");
                //DE414377
                if (component.get("v.userInfo").UHG_Access__c == "No") {
                  isRestricted = true;
                  var spinner2 = component.find("dropdown-spinner2");
                  $A.util.removeClass(spinner2, "slds-show");
                  $A.util.addClass(spinner2, "slds-hide");
                  component.set("v.memberSelected", "{}");
                  var newLabel = memberData.memberID + " - " + selLabel;

                  component.set(
                    "v.searchMemberIdSSN",
                    component.get("v.searchMemberIdSSNdata")
                  );
                  helper.fireToast(
                    $A.get("$Label.c.UHG_Restriction_Validation")
                  );
                  component.set("v.displayMember", false);
                  component.set("v.memberList", []);
                  return;
                }
              }
              var spinner2 = component.find("dropdown-spinner2");
              $A.util.removeClass(spinner2, "slds-show");
              $A.util.addClass(spinner2, "slds-hide");
              component.set("v.memberSelected", memberData);
              var newLabel = memberData.memberID + " - " + selLabel;
              component.set("v.searchMemberIdSSN", newLabel);
            }else{
                var spinner2 = component.find("dropdown-spinner2");
              $A.util.removeClass(spinner2, "slds-show");
              $A.util.addClass(spinner2, "slds-hide");
                
                 var newLabel = memberData.memberID + " - " + selLabel;

                  component.set(
                    "v.searchMemberIdSSN",
                    newLabel
                  );
            }
          }
            else {
                var spinner2 = component.find("dropdown-spinner2");
                $A.util.removeClass(spinner2, "slds-show");
                $A.util.addClass(spinner2, "slds-hide");
                component.set("v.isMemberNotFound", true);
                component.set("v.searchMemberFirstName", "");
                component.set("v.searchMemberLastName", "");
                component.set("v.searchMemberDOB", "");
                
                component.set("v.searchMemberIdSSN", component.get("v.searchMemberIdSSNdata"));
                //result.message = null;
                if(result != null && result.message != null && result.message != ''){
                    helper.fireToast(result.message.replace(". ", ". \n"),"10000");
                } else if(result != null && result.message == '' ){
                    helper.fireToast("No Results Found.", "10000");
                } else {
                    helper.fireToast("Unexpected Error Occurred. Please Try Again.", "10000");
                }
            }
        }
      });
      $A.enqueueAction(action);
	                            
                            } 
                               else {
                                component.set('v.displayMember', false);
                                component.set('v.memberList', []);
                                var spinner2 = component.find("dropdown-spinner2");
            	                $A.util.removeClass(spinner2, "slds-show");
            	                $A.util.addClass(spinner2, "slds-hide");
                            }
                            component.set("v.memberList", dropdownOptions);
                            console.log('testing findIndividual....');
                            console.log(component.get("v.responseData"));
                            console.log('**********');
                            console.log(component.get("v.memberList"));
                            if (component.get('v.responseData') == undefined) {
                                component.set('v.invalidResultFlag', true);
                            } else {
                                component.set('v.invalidResultFlag', false);
                            }
                            
	                        
                        } else {
                            component.set("v.isMemberNotFound", true);
                            component.set("v.searchMemberFirstName", "");
                            component.set("v.searchMemberLastName", "");
                            component.set("v.searchMemberDOB", "");
                            var spinner2 = component.find("dropdown-spinner2");
        	                $A.util.removeClass(spinner2, "slds-show");
        	                $A.util.addClass(spinner2, "slds-hide");
                            if(result != null && result.message != null && result.message != ''){
                                helper.fireToast(result.message.replace(". ", ". \n"),"10000");
                            } else if(result != null && result.message == '' ){
								helper.fireToast("No Results Found.", "10000");
							} else {
                                helper.fireToast("Unexpected Error Occurred. Please Try Again.", "10000");
                            }
                        }
                    } else if (result.statusCode == 400 && (searchOptionVal == "NameDateOfBirth" || searchOptionVal == "MemberIDDateOfBirth")) {
                        //this.fireToastMessage("Error!", result.message, "dismissible", "5000");
                    	component.set("v.isMemberNotFound", true);
                    	component.set("v.searchMemberFirstName", "");
                        component.set("v.searchMemberLastName", "");
                        component.set("v.searchMemberDOB", "");
                        var spinner2 = component.find("dropdown-spinner2");
    	                $A.util.removeClass(spinner2, "slds-show");
    	                $A.util.addClass(spinner2, "slds-hide");
                        if(result != null && result.message != null && result.message != ''){
                        	helper.fireToast(result.message.replace(". ", ". \n"),"10000");
                        } else if(result != null && result.message == '' ){
							helper.fireToast("No Results Found.", "10000");
						} else {
                        	helper.fireToast("Unexpected Error Occurred. Please Try Again.", "10000");
                        }
                    } else if (result.statusCode == 404 ) {
                        //this.fireToastMessage("Error!", result.message, "dismissible", "5000");
                        if(result.message != undefined){
                        	component.set("v.isMemberNotFound", true);
                        	component.set("v.searchMemberFirstName", "");
                            component.set("v.searchMemberLastName", "");
                            component.set("v.searchMemberDOB", "");
                            var spinner2 = component.find("dropdown-spinner2");
        	                $A.util.removeClass(spinner2, "slds-show");
        	                $A.util.addClass(spinner2, "slds-hide");
                            if(result != null && result.message != null && result.message != ''){
                            	helper.fireToast(result.message.replace(". ", ". \n"),"10000");
                            } else if(result != null && result.message == '' ){
								helper.fireToast("No Results Found.", "10000");
							} else {
                            	helper.fireToast("Unexpected Error Occurred. Please Try Again.", "10000");
                            }
                        } else {
                        	var spinner2 = component.find("dropdown-spinner2");
        	                $A.util.removeClass(spinner2, "slds-show");
        	                $A.util.addClass(spinner2, "slds-hide");
        	                helper.fireToast("Unexpected Error Occurred. Please Try Again.", "10000");
                        }
    
                    } else {
                        //var responseMsg = result.message;
                        //var jsonString = JSON.parse(responseMsg);
                        component.set('v.showServiceErrors', true);
                        if (component.get("v.showHideMemAdvSearch") == true && component.get("v.displayMNFFlag") == true) {
                            component.set("v.mnf", 'mnf');
                            component.set("v.checkFlagmeberCard",false); //Added By Avish on 07/25/2019
                        }
                        //component.set('v.serviceMessage',jsonString.message);
                        // US1813580 - Error Message Translation
                        component.set('v.serviceMessage', result.message);
                        // If need
                        component.set("v.isMemberNotFound", true);
                        component.set("v.searchMemberFirstName", "");
                        component.set("v.searchMemberLastName", "");
                        component.set("v.searchMemberDOB", "");
                        var spinner2 = component.find("dropdown-spinner2");
    	                $A.util.removeClass(spinner2, "slds-show");
    	                $A.util.addClass(spinner2, "slds-hide");
                        if(result != null && result.message != null && result.message != ''){
                        	helper.fireToast(result.message,"10000");
                        } else if(result != null && result.message == '' ){
							helper.fireToast("No Results Found.", "10000");
						} else {
                        	helper.fireToast("Unexpected Error Occurred. Please Try Again.", "10000");
                        }
                    } 
                } else {
                	component.set("v.isMemberNotFound", true);
                	component.set("v.searchMemberFirstName", "");
                    component.set("v.searchMemberLastName", "");
                    component.set("v.searchMemberDOB", "");
                    var spinner2 = component.find("dropdown-spinner2");
	                $A.util.removeClass(spinner2, "slds-show");
	                $A.util.addClass(spinner2, "slds-hide");
                    if(result != null && result.message != null && result.message != ''){
                    	helper.fireToast(result.message.replace(". ", ". \n"),"10000");
                    } else if(result != null && result.message == '' ){
                    	helper.fireToast("No Results Found.", "10000");
				    } else { 
                    	helper.fireToast("Unexpected Error Occurred. Please Try Again.", "10000");
                    }
                }

            });
            $A.enqueueAction(action);
        } else if(memId == null || memId == undefined || memId == ''){
        	var spinner2 = component.find("dropdown-spinner2");
            $A.util.removeClass(spinner2, "slds-show");
            $A.util.addClass(spinner2, "slds-hide");
            component.set("v.memberSelected",'');
            component.set("v.isMemberSearch", false);
        } else if(component.get("v.platformSelected") == 'None'){
            var spinner2 = component.find("dropdown-spinner2");
            $A.util.removeClass(spinner2, "slds-show");
            $A.util.addClass(spinner2, "slds-hide");
        	helper.fireToast("Choose a Platform and Try Again.", "10000");
        } else {
        	var spinner2 = component.find("dropdown-spinner2");
            $A.util.removeClass(spinner2, "slds-show");
            $A.util.addClass(spinner2, "slds-hide");
        }
    },
	       
    /*searchForMember: function(component,event,helper){   
        var spinner = component.find("dropdown-spinner2");
        $A.util.removeClass(spinner, "slds-hide");
        $A.util.addClass(spinner, "slds-show");
        
        component.set("v.displayMember", false);
        component.set("v.isMemberNotFound", false);
        component.set("v.displayMemberSection",false); //US2773499:Change
        component.set("v.uhgAccess", "No");
        var memId = component.get("v.searchMemberIdSSN");
        if(memId != null && memId != undefined){
            memId = memId.trim();
        }
        if(component.get('v.isResearchUser')) {
            component.set("v.isCreateCase", true);    
        } else {
            component.set("v.isToggle", false);
            component.set("v.isCreateCase", false);
        } 
        component.set("v.isMemberSearch", true);
        console.log('SELECTED PLATFORM: ' + (component.get("v.platformSelected")));
        if((memId != null && memId != undefined && memId != '' && !memId.includes('-') && memId.length >= 9) && component.get("v.platformSelected") != 'None'){           
            var searchOptionVal ='';
            var action = component.get('c.searchMembers');
            var memberDetails = {
                "memberId": memId,
                "memberDOB": '',
                "firstName": '',
                "lastName": '',
                "groupNumber": '',
                "searchOption": '',
                "payerID":   '',
                "providerFlow": "Other"
                
            };
            var memberDetailsJSON = JSON.stringify(memberDetails);
            console.log(JSON.stringify(memberDetails.payerID));
            action.setParams({
                "memberDetails": memberDetailsJSON
            });
            action.setCallback(this, function (response) {
                
                var state = response.getState();
                if (state == 'SUCCESS') {  
                    var result = response.getReturnValue();
                    console.log('code?>>>> ' + result.statusCode);
                    if (result.statusCode == 200) {   
                        var storeResponse = result.resultWrapper.lstSAEMemberStandaloneSearch;
                        if(storeResponse != null && storeResponse != undefined && storeResponse.length > 0){							 
                            //DE395117:Change
                            var memberData1 = {
                                "sourceCode": storeResponse[0].sourceSysCode,
                                "Name": storeResponse[0].fullName,
                                "DOB": storeResponse[0].birthDate,
                                "firstName": storeResponse[0].firstName,
                                "lastName": storeResponse[0].lastName,
                                "memberID": memId.trim(),
                                "payerID":storeResponse[0].payerID,
                                "groupNumber":storeResponse[0].groupNumber,
                                "searchOption":storeResponse[0].searchOption,
                                "SSN":storeResponse[0].SSN
                            };
                            
                            let lstExclusions = component.get("v.lstExlusions");
                            let mapExclusions = new Map();
                            for(let i=0; lstExclusions.length > i; i++) {
                                mapExclusions.set(lstExclusions[i].MasterLabel,lstExclusions[i].MasterLabel);
                            }
                            var formatDate = memberData1.DOB.split('/')[2] + '-' + memberData1.DOB.split('/')[0] + '-' + memberData1.DOB.split('/')[1];
                            
                            var action3;
                            if(component.get("v.isMockEnabled")) {
                                action3 = component.get("c.getMockData");
                            } else{
                                action3 = component.get('c.fetchData');   
                            }
                            
                            action3.setParams({
                                transactionId : null,
                                "memberId": memId.trim(),
                                "memberDOB": formatDate,
                                "firstName": memberData1.firstName,
                                "lastName": memberData1.lastname,
                                "groupNumber": '',
                                "searchOption": 'MemberIDDateOfBirth',
                                "payerID" : '87726'
                            });
                            action3.setCallback(this, function(response){
                                var state = response.getState();   
                                if (state == 'SUCCESS') {
                                    var result = response.getReturnValue();
                                    result = JSON.parse(result);
                                    if (result.statusCode == 200) {
                                        var coverageLines = result.resultWrapper.CoverageLines;
                                        var isRestricted = false;
                                        component.set('v.uhgAccess', 'No');
                                       
                                        if(isRestricted == false){ 
                                            var dropdownOptions = [];
                                            for (var i = 0; i < storeResponse.length; i++) {
                                                dropdownOptions.push({
                                                    label: storeResponse[i].sourceSysCode + '   ' + storeResponse[i].fullName + '   ' + storeResponse[i].birthDate,
                                                    value: JSON.stringify(storeResponse[i])
                                                });
                                            }
                                            if (dropdownOptions.length >= 1) {
                                                component.set('v.memberList', dropdownOptions);
                                                component.set('v.displayMember', true);
                                                component.set("v.isMemberSearch", false);
                                                var spinner2 = component.find("dropdown-spinner2");
                                                $A.util.removeClass(spinner2, "slds-show");
                                                $A.util.addClass(spinner2, "slds-hide");                    
                                                
                                            } else {
                                                component.set('v.displayMember', false);
                                                component.set('v.memberList', []);
                                                var spinner2 = component.find("dropdown-spinner2");
                                                $A.util.removeClass(spinner2, "slds-show");
                                                $A.util.addClass(spinner2, "slds-hide");
                                            }
                                            component.set("v.memberList", dropdownOptions);
                                            console.log(component.get("v.responseData"));
                                            console.log(component.get("v.memberList"));
                                            if (component.get('v.responseData') == undefined) {
                                                component.set('v.invalidResultFlag', true);
                                            } else {
                                                component.set('v.invalidResultFlag', false);
                                            }
                                            
                                        }
                                        else{
                                            helper.fireToast($A.get("$Label.c.UHG_Restriction_Validation"));
                                            var spinner2 = component.find("dropdown-spinner2");
                                            $A.util.removeClass(spinner2, "slds-show");
                                            $A.util.addClass(spinner2, "slds-hide");
                                        }
                                    }
                                }
                            });
                            $A.enqueueAction(action3);
                            
                        } else {
                            component.set("v.isMemberNotFound", true);
                            component.set("v.searchMemberFirstName", "");
                            component.set("v.searchMemberLastName", "");
                            component.set("v.searchMemberDOB", "");
                            var spinner2 = component.find("dropdown-spinner2");
                            $A.util.removeClass(spinner2, "slds-show");
                            $A.util.addClass(spinner2, "slds-hide");
                            if(result != null && result.message != null && result.message != ''){
                                helper.fireToast(result.message.replace(". ", ". \n"),"10000");
                            } else if(result != null && result.message == '' ){
                                helper.fireToast("No Results Found.", "10000");
                            } else {
                                helper.fireToast("Unexpected Error Occurred. Please Try Again.", "10000");
                            }
                        }
                    }
                    else if (result.statusCode == 400 && (searchOptionVal == "NameDateOfBirth" || searchOptionVal == "MemberIDDateOfBirth")) {
                        component.set("v.isMemberNotFound", true);
                        component.set("v.searchMemberFirstName", "");
                        component.set("v.searchMemberLastName", "");
                        component.set("v.searchMemberDOB", "");
                        var spinner2 = component.find("dropdown-spinner2");
                        $A.util.removeClass(spinner2, "slds-show");
                        $A.util.addClass(spinner2, "slds-hide");
                        if(result != null && result.message != null && result.message != ''){
                            helper.fireToast(result.message.replace(". ", ". \n"),"10000");
                        } else if(result != null && result.message == '' ){
                            helper.fireToast("No Results Found.", "10000");
                        } else {
                            helper.fireToast("Unexpected Error Occurred. Please Try Again.", "10000");
                        }
                    } else if (result.statusCode == 404 ) {
                        if(result.message != undefined){
                            component.set("v.isMemberNotFound", true);
                            component.set("v.searchMemberFirstName", "");
                            component.set("v.searchMemberLastName", "");
                            component.set("v.searchMemberDOB", "");
                            var spinner2 = component.find("dropdown-spinner2");
                            $A.util.removeClass(spinner2, "slds-show");
                            $A.util.addClass(spinner2, "slds-hide");
                            if(result != null && result.message != null && result.message != ''){
                                helper.fireToast(result.message.replace(". ", ". \n"),"10000");
                            } else if(result != null && result.message == '' ){
                                helper.fireToast("No Results Found.", "10000");
                            } else {
                                helper.fireToast("Unexpected Error Occurred. Please Try Again.", "10000");
                            }
                        } else {
                            var spinner2 = component.find("dropdown-spinner2");
                            $A.util.removeClass(spinner2, "slds-show");
                            $A.util.addClass(spinner2, "slds-hide");
                            helper.fireToast("Unexpected Error Occurred. Please Try Again.", "10000");
                        }
                        
                    } else {
                        component.set('v.showServiceErrors', true);
                        if (component.get("v.showHideMemAdvSearch") == true && component.get("v.displayMNFFlag") == true) {
                            component.set("v.mnf", 'mnf');
                            component.set("v.checkFlagmeberCard",false);
                        }
                        
                        // US1813580 - Error Message Translation
                        component.set('v.serviceMessage', result.message);
                        component.set("v.isMemberNotFound", true);
                        component.set("v.searchMemberFirstName", "");
                        component.set("v.searchMemberLastName", "");
                        component.set("v.searchMemberDOB", "");
                        var spinner2 = component.find("dropdown-spinner2");
                        $A.util.removeClass(spinner2, "slds-show");
                        $A.util.addClass(spinner2, "slds-hide");
                        if(result != null && result.message != null && result.message != ''){
                            helper.fireToast(result.message,"10000");
                        } else if(result != null && result.message == '' ){
                            helper.fireToast("No Results Found.", "10000");
                        } else {
                            helper.fireToast("Unexpected Error Occurred. Please Try Again.", "10000");
                        }
                    } 
                }							
                else {
                    component.set("v.isMemberNotFound", true);
                    component.set("v.searchMemberFirstName", "");
                    component.set("v.searchMemberLastName", "");
                    component.set("v.searchMemberDOB", "");
                    var spinner2 = component.find("dropdown-spinner2");
                    $A.util.removeClass(spinner2, "slds-show");
                    $A.util.addClass(spinner2, "slds-hide");
                    if(result != null && result.message != null && result.message != ''){
                        helper.fireToast(result.message.replace(". ", ". \n"),"10000");
                    } else if(result != null && result.message == '' ){
                        helper.fireToast("No Results Found.", "10000");
                    } else { 
                        helper.fireToast("Unexpected Error Occurred. Please Try Again.", "10000");
                    }
                }
                
            });
            $A.enqueueAction(action);
        } 
        
        else if(memId == null || memId == undefined || memId == ''){
            var spinner2 = component.find("dropdown-spinner2");
            $A.util.removeClass(spinner2, "slds-show");
            $A.util.addClass(spinner2, "slds-hide");
            component.set("v.memberSelected",'');
            component.set("v.isMemberSearch", false);
        } else if(component.get("v.platformSelected") == 'None'){
            var spinner2 = component.find("dropdown-spinner2");
            $A.util.removeClass(spinner2, "slds-show");
            $A.util.addClass(spinner2, "slds-hide");
            helper.fireToast("Choose a Platform and Try Again.", "10000");
        } else {
            var spinner2 = component.find("dropdown-spinner2");
            $A.util.removeClass(spinner2, "slds-show");
            $A.util.addClass(spinner2, "slds-hide");
        }
    },*/
    
    //US2773499:Change   
   setMemberSection:function(cmp,event,helper){
        cmp.set("v.displayMemberSection",true);       
        cmp.set("v.isMemberNotFound", true);
        cmp.set("v.displayMember", false);       
    },
    
    
    searchForMemberMNF: function(component,event,helper){   
    	var spinner = component.find("dropdown-spinner");
        $A.util.removeClass(spinner, "slds-hide");
        $A.util.addClass(spinner, "slds-show");
    	component.set("v.displayMember", false);
    	component.set("v.uhgAccess", "No");
        var memId = component.get("v.searchMemberIdSSN");
        if(memId != null && memId != undefined){
            memId = memId.trim();
        }
        if(component.get('v.isResearchUser')) {
        	component.set("v.isCreateCase", true);    
        } else {
            component.set("v.isToggle", false);
            component.set("v.isCreateCase", false);
        } 

        component.set("v.isMemberSearch", true);
        if((memId != null && memId != undefined && memId != '' && !memId.includes('-') && memId.length >= 9) && component.get("v.platformSelected") != 'None'){
        	component.set('v.searchMemberFirstName',component.get('v.searchMemberFirstName').trim());
        	component.set('v.searchMemberLastName',component.get('v.searchMemberLastName').trim());
        	if(component.get('v.searchMemberFirstName') == null || component.get('v.searchMemberFirstName') == undefined || component.get('v.searchMemberFirstName') == ''){
        		helper.fireToast("Enter Member's First Name","10000");
	            var spinner2 = component.find("dropdown-spinner");
	            $A.util.removeClass(spinner2, "slds-show");
	            $A.util.addClass(spinner2, "slds-hide");
	            
        	} else if(component.get('v.searchMemberLastName') == null || component.get('v.searchMemberLastName') == undefined || component.get('v.searchMemberLastName') == ''){
        		helper.fireToast("Enter Member's Last Name","10000");
	            var spinner2 = component.find("dropdown-spinner");
	            $A.util.removeClass(spinner2, "slds-show");
	            $A.util.addClass(spinner2, "slds-hide");
        	} else if(component.get('v.searchMemberDOB') == null || component.get('v.searchMemberDOB') == undefined || component.get('v.searchMemberDOB') == ''){
        		helper.fireToast("Enter Member's DOB","10000");
	            var spinner2 = component.find("dropdown-spinner");
	            $A.util.removeClass(spinner2, "slds-show");
	            $A.util.addClass(spinner2, "slds-hide");
        	} else {
	            var searchOptionVal ='';
	            var action = component.get('c.searchMembers');
	            var payerId = component.get('v.platformSelected');
	            var memberDetails = {
	                "memberId": memId,
	                "memberDOB": component.get('v.searchMemberDOB'),
	                "firstName": component.get('v.searchMemberFirstName'),
	                "lastName": component.get('v.searchMemberLastName'),
	                "groupNumber": '',
	                "searchOption": 'MemberIDDateOfBirth',
	                "payerID":   payerId, //"87726", US1944108 - Accommodate Multiple Payer ID's 
	                "providerFlow": "Other"
	            };
	            var memberDetailsJSON = JSON.stringify(memberDetails);
	            action.setParams({
	                "memberDetails": memberDetailsJSON
	            });
	            action.setCallback(this, function (response) {
	                var state = response.getState(); // get the response state
	                if (state == 'SUCCESS') {
	                    var result = response.getReturnValue();
	                    //console.log('##RESP:'+JSON.stringify(result));
	                    console.log('code?>>>> ' + result.statusCode);
	                    if (result.statusCode == 200) {
	                        var storeResponse = result.resultWrapper.subjectCard;
	                        console.log('CHECKING UHG1: ' + JSON.stringify(storeResponse));
	                      //CHECK UHG MEMBER
	                        if(storeResponse != null && storeResponse != undefined && storeResponse != ''){
		                        /*var memberData1 = {
		                            "sourceCode": storeResponse[0].sourceSysCode,
		                            "Name": storeResponse[0].fullName,
		                            "DOB": storeResponse[0].birthDate,
		                            "firstName": storeResponse[0].firstName,
		                            "lastName": storeResponse[0].lastName,
		                            "memberID": memId.trim(),
		                            "payerID":storeResponse[0].payerID,
		                            "groupNumber":storeResponse[0].groupNumber,
		                            "searchOption":storeResponse[0].searchOption,
		                            "SSN":storeResponse[0].SSN
		                        };*/
	                        	var memberData1 = {
			                            "sourceCode": '',
			                            "Name": storeResponse.memberName,
			                            "DOB": storeResponse.memberDOB,
			                            "firstName": storeResponse.firstName,
			                            "lastName": storeResponse.lastName,
			                            "memberID": storeResponse.memberId,
			                            "payerID":'',
			                            "groupNumber":storeResponse.groupNumber,
			                            "searchOption":'',
			                            "SSN":storeResponse.SSN
			                        };
		                        console.log('CHECKING UHG2: ' + JSON.stringify(memberData1));
		                        if(memberData1 != '') { 
		                        	let lstExclusions = component.get("v.lstExlusions");
		                            //alert(lstExclusions.length);
		                            let mapExclusions = new Map();
		                            //mapExclusions.set('706577', '706577');
		                            for(let i=0; lstExclusions.length > i; i++) {
		                                mapExclusions.set(lstExclusions[i].MasterLabel,lstExclusions[i].MasterLabel);
		                            }
		                            var formatDate = memberData1.DOB;
		                            if(formatDate.includes('/')){
		                            	formatDate = formatDate.split('/')[2] + '-' + formatDate.split('/')[0] + '-' + formatDate.split('/')[1];	                            
		                            }
	                                //mockData
	                                var action3;
	                                if(component.get("v.isMockEnabled")) {
	                                    action3 = component.get("c.getMockData");
	                                } else{
	                                    action3 = component.get('c.fetchData');   
	                                }
	                                //Ends mockData
	                                var payerId = component.get('v.platformSelected');
	                                action3.setParams({
	                                    transactionId : null,
	                                    "memberId": memberData1.memberID,
		                                "memberDOB": formatDate,
		                                "firstName": memberData1.firstName,
		                                "lastName": memberData1.lastname,
		                                "groupNumber": '',
		                                "searchOption": 'MemberIDDateOfBirth',
	                                    "payerID" : payerId
	                                });
		                            var handleCallout = false;
	                                console.log('CALLING CASE CREATOR D0');
	                                action3.setCallback(this, function(response){
	                                	console.log('CALLING CASE CREATOR D HAPPENS TWICE');
	                                	var state1 = response.getState();
	                                    console.log('FETCHDATA STATE: ' + state1);
	                                    if(handleCallout==false){
	                                        handleCallout = true;
	                                    var state = response.getState();   
	                                    if (state == 'SUCCESS') {
	                                    	var result = response.getReturnValue();
	                                    	console.log('FETCH RESPONSE: ' + JSON.stringify(result));
	                                        result = JSON.parse(result);
	                                       // console.log("FETCH DATA: " + JSON.stringify(result));
	                                       // console.log("UHG ACCESS: " + result.hasAccess);
	                                        //console.log("HAS UHG ACCESS: " + component.get('v.userInfo').UHG_Access__c);
	                                        if (result.statusCode == 200) {
	                                        	var coverageLines = result.resultWrapper.CoverageLines;
	                                        	var isRestricted = false;
	                                        	console.log('COVERAGES: ' + JSON.stringify(coverageLines));
	                                        	console.log('MAPEXCLUSIONS: ' + mapExclusions);
	                                        	component.set('v.uhgAccess', 'No');
	                                        	for(var i = 0; i < coverageLines.length; i++){
	                                    			console.log('CHECK GROUP: ' + coverageLines[i].GroupNumber);
	                                        		if(mapExclusions.has(coverageLines[i].GroupNumber)) {
	                                        			component.set('v.uhgAccess', 'Yes');
	                                        			console.log('FOUND RESTRICTED: ' + coverageLines[i].GroupNumber);
	                                        			if(!result.hasAccess){
		                                        			console.log('IS UHG RESTRICTED BY USER: ' + coverageLines[i].GroupNumber);
		                                        			isRestricted = true;
	                                                        break;
	                                        			}
	                                        		}
	                                        	}
	                                        	console.log('SETTING UHGACCESS: ' + component.get('v.uhgAccess'));
	                                            if(isRestricted == false){
	                                            	//CHECK UHG HERE THROUGH 
	                                                var dropdownOptions = [];
                                                    dropdownOptions.push({
                                                        label: storeResponse.memberName + '   ' + storeResponse.memberDOB,
                                                        value: JSON.stringify(storeResponse)
                                                    });
	                                                
	                                                if (dropdownOptions.length > 1) {
	                                                    component.set('v.memberList', dropdownOptions);
	                                                    component.set('v.displayMember', true);
	                                                    component.set("v.isMemberSearch", false);
	                                                } else if(dropdownOptions.length == 1){
	                                                    var selLabel = dropdownOptions[0].label;
	                                                    var selValue = JSON.parse(dropdownOptions[0].value);
	                                                    var memId = component.get("v.searchMemberIdSSN");
	                                                    console.log('DROPDOWN VAL: ' + JSON.stringify(dropdownOptions[0]));
	                                                    var memberData = {
	                                                        "sourceCode": selValue.sourceSysCode,
	                                                        "Name": selValue.memberName,
	                                                        "DOB": selValue.memberDOB,
	                                                        "firstName": selValue.firstName,
	                                                        "lastName": selValue.lastName,
	                                                        "memberID": selValue.memberId,
	                                                        "payerID":'',
	                                                        "groupNumber":selValue.groupNumber,
	                                                        "searchOption":'MemberIDDateOfBirth',
	                                                        "SSN":selValue.SSN
	                                                    }
	                                            		component.set("v.memberSelected",memberData);
	                                                    var newLabel1 = memberData.memberID + ' - ' + selLabel;
	                                                    component.set("v.searchMemberIdSSN", newLabel1);
	                                                    component.set("v.isMemberNotFound", false);
	                                                    component.set("v.searchMemberFirstName", "");
	                                                    component.set("v.searchMemberLastName", "");
	                                                    component.set("v.searchMemberDOB", "");
	                                                    component.set("v.platformText", "None");
	                                                    component.set("v.platformSelected", "None");
	                                                } else {
	                                                    component.set('v.displayMember', false);
	                                                    component.set('v.memberList', []);
	                                                    var spinner2 = component.find("dropdown-spinner");
	                                	                $A.util.removeClass(spinner2, "slds-show");
	                                	                $A.util.addClass(spinner2, "slds-hide");
	                                                }
	                                                component.set("v.memberList", dropdownOptions);
	                                                console.log('testing findIndividual....');
	                                                console.log(component.get("v.responseData"));
	                                                console.log('**********');
	                                                console.log(component.get("v.memberList"));
	                                                if (component.get('v.responseData') == undefined) {
	                                                    component.set('v.invalidResultFlag', true);
	                                                } else {
	                                                    component.set('v.invalidResultFlag', false);
	                                                }
	                                                var spinner2 = component.find("dropdown-spinner");
	                            	                $A.util.removeClass(spinner2, "slds-show");
	                            	                $A.util.addClass(spinner2, "slds-hide");
	
	                                            } else {
	                                            	var spinner2 = component.find("dropdown-spinner");
	                            	                $A.util.removeClass(spinner2, "slds-show");
	                            	                $A.util.addClass(spinner2, "slds-hide");
	                                            	helper.fireToast($A.get("$Label.c.UHG_Restriction_Validation"));
	                                            }
	
	                                        } else {
	                                        	if(result != null && result.message != null && result.message != ''){
	                                            	helper.fireToast(result.message.replace(". ", ". \n"),"10000");
	                                            } else if(result != null && result.message == '' ){
	                                            	helper.fireToast("No Results Found.", "10000");
											    } else {
	                                            	helper.fireToast("Unexpected Error Occurred. Please Try Again.", "10000");
	                                            }
	                                        }
	                                    } else {
	                                    	if(result != null && result.message != null && result.message != ''){
	                                        	helper.fireToast(result.message.replace(". ", ". \n"),"10000");
	                                        } else {
	                                        	helper.fireToast("Unexpected Error Occurred. Please Try Again.", "10000");
	                                        }
	                                    }
	                                    }	
	                                });
	                                console.log('CALLING CASE CREATOR D1');
	                                $A.enqueueAction(action3);
	                                console.log('CALLING CASE CREATOR D2');
	                                var spinner2 = component.find("dropdown-spinner");
	            	                $A.util.removeClass(spinner2, "slds-show");
	            	                $A.util.addClass(spinner2, "slds-hide");
	
		                        }
	                        }
	                    } else if (result.statusCode == 400 && (searchOptionVal == "NameDateOfBirth" || searchOptionVal == "MemberIDDateOfBirth")) {
	                        //this.fireToastMessage("Error!", result.message, "dismissible", "5000");
	                    	component.set("v.isMemberNotFound", true);
	                    	if(result != null && result.message != null && result.message != ''){
	                        	helper.fireToast(result.message.replace(". ", ". \n"),"10000");
	                        } else if(result != null && result.message == '' ){
					helper.fireToast("No Results Found.", "10000");
				} else {
	                        	helper.fireToast("Unexpected Error Occurred. Please Try Again.", "10000");
	                        }
	                    } else if (result.statusCode == 404 ) {
	                        //this.fireToastMessage("Error!", result.message, "dismissible", "5000");
	                        if(result.message != undefined){
	                        	component.set("v.isMemberNotFound", true);
	                        	if(result != null && result.message != null && result.message != ''){
	                            	helper.fireToast(result.message.replace(". ", ". \n"),"10000");
	                            } else if(result != null && result.message == '' ){
					helper.fireToast("No Results Found.", "10000");
				    } else {
	                            	helper.fireToast("Unexpected Error Occurred. Please Try Again.", "10000");
	                            }
	                        }
	    
	                    } else {
	                        //var responseMsg = result.message;
	                        //var jsonString = JSON.parse(responseMsg);
	                        component.set('v.showServiceErrors', true);
	                        if (component.get("v.showHideMemAdvSearch") == true && component.get("v.displayMNFFlag") == true) {
	                            component.set("v.mnf", 'mnf');
	                            component.set("v.checkFlagmeberCard",false); //Added By Avish on 07/25/2019
	                        }
	                        //component.set('v.serviceMessage',jsonString.message);
	                        // US1813580 - Error Message Translation
	                        component.set('v.serviceMessage', result.message);
	                        // If need
	                        component.set("v.isMemberNotFound", true);
	                        helper.fireToast('No Results Found',"10000");
	                    } 
	                    var spinner2 = component.find("dropdown-spinner");
		                $A.util.removeClass(spinner2, "slds-show");
		                $A.util.addClass(spinner2, "slds-hide");
	                } else {
	                	component.set("v.isMemberNotFound", true);
	                	if(result != null && result.message != null && result.message != ''){
                        	helper.fireToast(result.message.replace(". ", ". \n"),"10000");
                        } else if(result != null && result.message == '' ){
                            helper.fireToast("No Results Found.", "10000");
                        } else {
                        	helper.fireToast("Unexpected Error Occurred. Please Try Again.", "10000");
                        }
	                }
	                var spinner2 = component.find("dropdown-spinner");
	                $A.util.removeClass(spinner2, "slds-show");
	                $A.util.addClass(spinner2, "slds-hide");
	            });
	            $A.enqueueAction(action);
	        }
        } else if(memId == null || memId == undefined || memId == ''){
        	var spinner2 = component.find("dropdown-spinner");
            $A.util.removeClass(spinner2, "slds-show");
            $A.util.addClass(spinner2, "slds-hide");
            component.set("v.memberSelected",'');
            component.set("v.isMemberSearch", false);
        } else if(component.get("v.platformSelected") == 'None'){
            var spinner2 = component.find("dropdown-spinner2");
            $A.util.removeClass(spinner2, "slds-show");
            $A.util.addClass(spinner2, "slds-hide");
        	helper.fireToast("Choose a Platform and Try Again.", "10000");
        }else {
        	var spinner2 = component.find("dropdown-spinner");
            $A.util.removeClass(spinner2, "slds-show");
            $A.util.addClass(spinner2, "slds-hide");
        }
    },
    searchForBroker: function(cmp,event,helper){
    	cmp.set("v.displayBroker",false);
        var brokerId = cmp.get("v.searchBroker");
        if(brokerId != null && brokerId != undefined){
            brokerId = brokerId.trim();
        }
        if(cmp.get('v.isResearchUser')) {
        	cmp.set("v.isCreateCase", true);    
        } else {
            cmp.set("v.isToggle", false);
            cmp.set("v.isCreateCase", false);
        }
        cmp.set("v.isBrokerSearch", true);
        if(brokerId != null && brokerId != undefined && brokerId != '' && !brokerId.includes('-') && brokerId.length >= 6){            
        	var action = cmp.get("c.searchBroker");
            action.setParams({
                producerId : brokerId
            });
            action.setCallback(this,function(response){
                var state = response.getState();
                console.log('STATE: ' + state);
                if (state === "SUCCESS") {
                    if(!$A.util.isUndefinedOrNull(response.getReturnValue())) {
                    	console.log('PRODUCER RESPONSE: ' + JSON.stringify(response.getReturnValue()));
                    	if(response.getReturnValue().length>0){
	                           //cmp.set("v.displaygroupTable",true);
	                           var results = JSON.parse(response.getReturnValue());
	                           if(!$A.util.isUndefinedOrNull(results)){
	                               if(results.length==0){
	                                   var toastEvent = $A.get("e.force:showToast");
	                                   toastEvent.setParams({
	                                       "type":"Error",
	                                       "message": "Search criteria returned no matches."
	                                   });
	                                   toastEvent.fire();
	                                   //cmp.set("v.displaygroupTable",false);
	                               } else if(results.length>15){
	                                   var toastEvent = $A.get("e.force:showToast");
	                                   toastEvent.setParams({
	                                       "type":"Error",
	                                       "message": "Criteria has yielded more than 15 results.  Refine your search criteria"
	                                   });
	                                   toastEvent.fire();
	                                   //cmp.set("v.displaygroupTable",false);
	                               } else{
	                                   var brokerVar = JSON.parse(response.getReturnValue());
	                                   var dropdownOptions = [];
	                                   for (var i = 0; i < brokerVar.length; i++) {
	                                	   var brokerLabel = brokerVar[0].producerID;
                                           if(brokerVar[i].producerIndividualName != null && brokerVar[i].producerIndividualName.firstName != null && brokerVar[i].producerIndividualName.firstName != '' && brokerVar[i].producerIndividualName.lastName != null && brokerVar[i].producerIndividualName.lastName != ''){
                                               brokerLabel = brokerLabel + ' - ' + brokerVar[i].producerIndividualName.firstName + ' ' + brokerVar[i].producerIndividualName.lastName;
                                           }
                                           if(brokerVar[i].producerCompanyName != null && brokerVar[i].producerCompanyName != ''){
                                               brokerLabel = brokerLabel + ' - ' + brokerVar[i].producerCompanyName;
                                           }
	                                       dropdownOptions.push({
	                                           label: brokerLabel,
	                                           value: JSON.stringify(brokerVar[i])
	                                       });
	                                   }
                                	   if (dropdownOptions.length > 1) {
                                           cmp.set('v.brokerList', dropdownOptions);
                                           cmp.set('v.displayBroker', true);
                                       } else if(dropdownOptions.length == 1){
                                    	   var selLabel = dropdownOptions[0].label;
                                           var selValue = JSON.parse(dropdownOptions[0].value);
                                           cmp.set("v.searchBroker", selLabel);
	                                       cmp.set("v.producerSelected", selValue);
	                                       cmp.set("v.displayBroker", false);
	                                       cmp.set('v.brokerList', []);
	                                   }
	                               }
                                   cmp.set("v.isBrokerSearch", false);
	                           }else{
	                               var toastEvent = $A.get("e.force:showToast");
	                               toastEvent.setParams({
	                                   "type":"Error",
	                                   "message": "Search criteria returned no matches."
	                               });
	                               toastEvent.fire();
	                               cmp.set("v.displayBroker",false);
	                           }
                        }
                    } else{
                    	var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "type":"Error",
                            "message": "Search criteria returned no matches."
                        });
                        toastEvent.fire();
                        cmp.set("v.displayBroker",false);
                    }
                }                
           });
           $A.enqueueAction(action);
        } else if(brokerId == null || brokerId == undefined || brokerId == ''){
            cmp.set("v.producerSelected",'');
            cmp.set("v.isBrokerSearch", false);
        }
    },
    //US2564216 || US2564216 changes
    handleUploadFinished: function (cmp, event, helper) {     
        helper.uploadfilesList(cmp, event, helper);      
    },
    //US2564216 || US2564216 changes
    handleRemoveItem : function(component, event, helper) {
        var self = this;       
        var index = event.target.dataset.index;
        helper.removeItem(component, index, event);
    },
    
    createCaseOneNDone: function(component,event,helper){
        if(helper.validateCreateCase(component, event, helper)){
            var documentId=component.get("v.fileIds");  //US2564216 || US2564216 changes
            var spinner = component.find("dropdown-spinner");
            $A.util.removeClass(spinner, "slds-hide");
            $A.util.addClass(spinner, "slds-show");
            component.set("v.createdCaseSFID", "");
        	component.set("v.createdCaseID", "");
            component.set("v.createdInteractionSFID", "");
            component.set("v.createdInteractionID", "");
            component.set("v.filesList",""); //US:US2564216         
            component.set("v.fileIds", "");//US:US2564216
            
            var selOrig = component.get("v.originatorSelected");
            console.log('Originator info: ' + JSON.stringify(selOrig));
            var interactionType = 'Phone';
            var eventDate = null;
            var eventTime = '';
            if(component.get('v.isCSOUser') == false){
                interactionType = component.get('v.interactionType');
                eventDate = component.get('v.eventReceivedDate');
                eventTime = component.get('v.eventReceivedTime');
            } else if(component.get("v.isResearchUser") == true){
            	interactionType = "Research";
            }
            console.log('AFTER DATE TIME: ' + eventDate + ',' + eventTime);
            var typeText = component.get('v.originatorText');
            typeText = typeText.trim();
            var memberFirstName = '';
            var memberLastName = '';
            var memberDOB = '';
            var memberId = '';
            var originatorId = '';
            var memberRelationship = '';
            
            //Member Not Found
            if(component.get('v.isMemberNotFound')){
            	component.set('v.searchMemberFirstName',component.get('v.searchMemberFirstName').trim());
            	component.set('v.searchMemberLastName',component.get('v.searchMemberLastName').trim());
	            var memberData = {
	                "sourceCode": '',
	                "Name": component.get('v.searchMemberFirstName') + ' ' + component.get('v.searchMemberLastName'),
	                "DOB": component.get('v.searchMemberDOB'),
	                "firstName": component.get('v.searchMemberFirstName'),
	                "lastName": component.get('v.searchMemberLastName'),
	                "memberID": component.get('v.searchMemberIdSSN'),
	                "payerID":'',
	                "groupNumber":'',
	                "searchOption":'MemberIDDateOfBirth',
	                "SSN":''
	            }
	            component.set("v.memberSelected",memberData);
            }
            
            component.set("v.isCreateCase", true);    
			component.set("v.isToggle", true);            
            
        	if(typeText.toLowerCase() == 'member') {
                
                var memberData = (component.get("v.memberSelected") != null && component.get("v.memberSelected") != undefined) ? component.get("v.memberSelected") : '';
                
                memberFirstName = component.get("v.memberSelected.firstName");
                memberFirstName = (memberFirstName != undefined && memberFirstName != null) ? memberFirstName : '';
                memberLastName = component.get("v.memberSelected.lastName");
                memberLastName = (memberLastName != undefined && memberLastName != null) ? memberLastName : '';
                memberDOB = component.get("v.memberSelected.DOB");
                memberDOB = (memberDOB != undefined && memberDOB != null) ? memberDOB : '';
                memberId = component.get("v.memberSelected.memberID");
                memberId = (memberId != undefined && memberId != null) ? memberId : '';
                
            } else {
                originatorId = selOrig.Id;
            }
            //create interaction
        	var action;
        	if(component.get("v.updateCaseBool") == true || component.get("v.createCaseFromIntBool") == true){
	            action = component.get("c.updateInteractionOneNDone");
	            var updateInteraction = component.get("v.updateCaseInteractionInfo");
	            action.setParams({
	                origSfId: originatorId,
	                interactionType: interactionType,
	                eventDate: eventDate,
	                eventTime: eventTime,
	                memberFirstName: memberFirstName,
	                memberLastName: memberLastName,
	                memberDOB: memberDOB,
	                memberId: memberId,
	                updateIntId: updateInteraction.Id
	            });
        	} else {
        		action = component.get("c.createInteractionOneNDone");
	            action.setParams({
	                origSfId: originatorId,
	                interactionType: interactionType,
	                eventDate: eventDate,
	                eventTime: eventTime,
	                memberFirstName: memberFirstName,
	                memberLastName: memberLastName,
	                memberDOB: memberDOB,
	                memberId: memberId
	            });
        	}
            action.setCallback(this, function(response) {
                var state = response.getState();
                if(state == "SUCCESS"){
                    var storeResponse = response.getReturnValue();
                    console.log('INTERACTION TO PASS THROUGH: ' + JSON.stringify(storeResponse));
                    
                    var businessUnit = component.get("v.businessUnitSelected");
                    var caseId = '';
                    
                    var interaction = storeResponse.Id;
                    component.set("v.createdInteractionID",storeResponse.Name);
                     component.set("v.createdInteractionSFID",storeResponse.Id);
                    var groupName = (component.get("v.groupSelected.groupName") != null && component.get("v.groupSelected.groupName") != undefined && component.get("v.groupSelected.groupName") != '') ? component.get("v.groupSelected.groupName") : 'General Inquiry';
                    var groupId = (component.get("v.groupSelected.groupId") != null && component.get("v.groupSelected.groupId") != undefined) ? component.get("v.groupSelected.groupId") : '';
                    var producerId = (component.get("v.producerSelected.producerID") != null & component.get("v.producerSelected.producerID") != undefined)?component.get("v.producerSelected.producerID"): '';
                    var producerData = (component.get("v.producerSelected") != null & component.get("v.producerSelected") != undefined)?component.get("v.producerSelected"): '';
                    var groupStartDate = (component.get("v.groupSelected.renewalEffectiveDate") != null && component.get("v.groupSelected.renewalEffectiveDate") != undefined) ? component.get("v.groupSelected.renewalEffectiveDate") : '';
                    var groupstate = (component.get("v.groupSelected.situsState") != null && component.get("v.groupSelected.situsState") != undefined && component.get("v.groupSelected.situsState") != '') ? component.get("v.groupSelected.situsState") : 'XX';
                    var groupFundingArrangement = (component.get("v.groupSelected.fundingType") != null && component.get("v.groupSelected.fundingType") != undefined && component.get("v.groupSelected.fundingType") != '') ? component.get("v.groupSelected.fundingType") : 'Multiple/Undefined';
                    var groupPlatformType = (component.get("v.groupSelected.platform") != null && component.get("v.groupSelected.platform") != undefined && component.get("v.groupSelected.platform") != '') ? component.get("v.groupSelected.platform") : 'Prime';
                    var groupLineOfBusiness = (component.get("v.groupSelected.lineOfBusiness") != null && component.get("v.groupSelected.lineOfBusiness") != undefined && component.get("v.groupSelected.lineOfBusiness") != '')?component.get("v.groupSelected.lineOfBusiness"):'Multiple/Undefined';
            		var groupRegion = (component.get("v.groupSelected.businessMarketRegion") != null && component.get("v.groupSelected.businessMarketRegion") != undefined && component.get("v.groupSelected.businessMarketRegion") != '')?component.get("v.groupSelected.businessMarketRegion"):'XX';
					var groupSalesOffice = (component.get("v.groupSelected.salesOffice") != null && component.get("v.groupSelected.salesOffice") != undefined && component.get("v.groupSelected.salesOffice") != '')?component.get("v.groupSelected.salesOffice"):'XX';
					var groupPlanMajor = (component.get("v.groupSelected.businessMajorMarket") != null && component.get("v.groupSelected.businessMajorMarket") != undefined && component.get("v.groupSelected.businessMajorMarket") != '')?component.get("v.groupSelected.businessMajorMarket"):'XX';
					var groupPlanMinor = (component.get("v.groupSelected.businessMinorMarket") != null && component.get("v.groupSelected.businessMinorMarket") != undefined && component.get("v.groupSelected.businessMinorMarket") != '')?component.get("v.groupSelected.businessMinorMarket"):'XX';
					var groupPolicy = (component.get("v.groupSelected.policyNumber") != null)?component.get("v.groupSelected.policyNumber"):'';
                    var groupPolicyRenewalYear  = (component.get("v.groupSelected.renewalEffectiveDate") != null)?component.get("v.groupSelected.renewalEffectiveDate"):'';
                    var groupSolarisId  = (component.get("v.groupSelected.salesforceInternalId") != null)?component.get("v.groupSelected.salesforceInternalId"):'';
                    var groupSourceCode = (component.get("v.groupSelected.sourceCode") != null)?component.get("v.groupSelected.sourceCode"):''; //jangi
                    //SSN is returned, member is not, maybe run that second service from member detail? Or just take the input text??
                    var memberId = (component.get("v.memberSelected.memberID") != null && component.get("v.memberSelected.memberID") != undefined) ? component.get("v.memberSelected.memberID") : '';
                    var memberData = (component.get("v.memberSelected") != null && component.get("v.memberSelected") != undefined) ? component.get("v.memberSelected") : '';
                    var slaDay = '';//skip because no special instruction selected
                    var slaDayVal = '';
                    if(slaDay != '') {
                        slaDayVal = parseInt(slaDay);   
                    }
                    var emailURL = '';//skip because no special instruction selected
                    var otherAdminType = '';//skip because no special instruction selected
                    var newDosList = '';//skip because no special instruction selected
                    var subjectId = '';
                    var subjectName = '';
                    var subjectDOB = '';
                    var subjectMemberSSN = '';                    
                    var brokerName = '';
                    var brokerId = '';
                    if(producerData != null && producerData != undefined && producerData != ""){
                    	if(producerData.producerType == 'I'){
                        	brokerName = producerData.producerIndividualName.firstName + ' ' + producerData.producerIndividualName.lastName;
                    	} else {
                    		brokerName = producerData.producerCompanyName;
                    	}
                    	brokerId = producerData.producerID;
                    }
                    if(memberId != null && memberData != undefined && memberData!= ''){
                       var  lastname = memberData.lastName;
                       var firstname = memberData.firstName;
                       subjectName = firstname+' '+lastname;
                       subjectId = memberId;
                        subjectDOB = memberData.DOB;
                        subjectMemberSSN = memberData.SSN;
                       var formatDate = memberData.DOB.split('/')[2] + '-' + memberData.DOB.split('/')[0] + '-' + memberData.DOB.split('/')[1];                        
                    } else if(groupId != '' && groupName != ''){
                        subjectName = groupName;
                        subjectId = groupId;
                    } else if(producerId != '' && producerData != ''){
                		subjectName = brokerName;
                		subjectId = brokerId;
                    }
             
                    var subjectGroupId = groupId;
                    var flowType = '';
                    if(producerId != null && producerId != ''){
                    	flowType = 'Producer';
                    }
                    if(groupId != null && groupId != ''){
                        flowType = 'Group/Employer';
                    }
                    if(memberId != null && memberId != ''){
                        flowType = 'Member';
                    }
                    var SIDescription = '';
                    if(component.get("v.searchResolution") != null && component.get("v.searchResolution") != undefined){
                        SIDescription = component.get("v.searchResolution");
                        SIDescription = SIDescription.trim();
                    }
                    
                    var firstname = '';
                    var SearchType = '';
                    var lastname = '';
                    var uniqueId = '';
                    var groupinfo = component.get("v.groupSelected");
                    if(producerData != null && producerData != undefined && producerData != ''){
                    	if(producerData.producerType == 'I'){
                    		firstname = producerData.producerIndividualName.firstName;
                    		lastname = producerData.producerIndividualName.lastName;
                    	} else {
                    		lastname = producerData.producerCompanyName;
                    	}
                    	SearchType = 'Producer';
                    	uniqueId = producerData.producerID;
                    }
                    if(groupinfo != null && groupinfo!= undefined && groupinfo!= ''){
                        if(groupinfo.groupName.length<=80){
                           
                            firstname = '';
                            lastname = groupinfo.groupName;
                        } else if(groupinfo.groupName.length>80 && groupinfo.groupName.length<=120){
                           
                            firstname = groupinfo.groupName.substring(0,40);
                            lastname = groupinfo.groupName.substring(40,groupinfo.groupName.length);
                        }
                            else if(groupinfo.groupName.length>120){
                                firstname = groupinfo.groupName.substring(0,40);
                                lastname = groupinfo.groupName.substring(40,120);
                            }
                         SearchType = 'Group/Employer';
                            uniqueId = groupinfo.groupId;
                    }
                    if(memberData != null && memberData!= undefined && memberData != ''){
                        lastname = memberData.lastName;
                        firstname = memberData.firstName;
                        SearchType = 'Member';
                        uniqueId = memberData.firstName + memberData.lastName + memberData.DOB + memberData.memberID;
                    }
                    if((firstname == undefined || firstname == null || firstname == '') && (lastname == undefined || lastname == null || lastname == '')) {
                        firstname = 'General';
                        lastname = 'Inquiry';
                    }
                    /* Hard coded values for reporting purposes, if the fields are blank, reports are broken
                      rather than slowing down the call and having the user look up a random group and give wrong info
                      we just have a value that shows that there is no wrong info, but we don't leave it blank
                      US2595142 - TECH: Hardcode Values on Broker Only Cases 
                    if(flowType == 'Producer'){
                    	groupName = 'General Inquiry';
                    	groupPlatformType = 'Prime';
                    	groupPlanMajor = 'XX';
                    	groupPlanMinor = 'XX';
                    	groupLineOfBusiness = 'Multiple/Undefined';
                    	groupRegion = 'XX';
                    	groupFundingArrangement = 'Multiple/Undefined';
                    	groupstate = 'XX';
                    	groupSalesOffice = 'XX';
                    }*/
                    console.log('CALLING CASE CREATOR G');
                    var uhgAccess = component.get('v.uhgAccess');
                    var isMemberNotFound = component.get('v.isMemberNotFound');
                    console.log('UHG ACCESS FOR PERSON ACCT: ' + uhgAccess);
                    var accountaction = component.get("c.createPersonAccount");
                    accountaction.setParams({"SearchType" :SearchType, 
                                             "firstName": firstname,"lastName":lastname,
                                             "uniqueId":uniqueId,"dob":memberData.DOB,"uhgAccess":uhgAccess });
                    accountaction.setCallback(this,function(response){
                        var state = response.getState();
                        if(state == "SUCCESS"){
                            console.log('CALLING CASE CREATOR F');
                            console.log('Person Account ID: ' + response.getReturnValue());
                            var contactid = response.getReturnValue();
                            
                            console.log('MEMBER Relationship: ' + memberRelationship);
                            component.set("v.FlowType",SearchType);
                            component.set("v.ContactId",contactid); 
                            
                            var strWrapper = '{"providerNotFound":false,"specialInstructions":"",'
                            + '"specialInstructionsBusinessUnit":"' + businessUnit + '",'
                            + '"issueCategoryDesc":"' + component.get("v.topicSelected") + '",'
                            + '"taskCategoryTypeDesc":"",'
                            + '"taskCategorySubtypeDesc":"",'
                            + '"specialInstructionsSubject":"XX",'
                            + '"specialInstructionsDescription":"",'
                            + '"specialInstructionsReferenceID":"",'
                            + '"specialInstructionsDateOfService":"' + newDosList + '",'
                            + '"specialInstructionsQueue":"",'
                            + '"groupSolarisId":"' + groupSolarisId + '",'
                            + '"groupSourceCode":"' + groupSourceCode + '",' //jangi
                            //+ '"groupName":"' +groupName.split('\"').join('\\"')  + '",'
                            + '"groupId":"' + groupId + '",'
                            + '"groupPolicyYear":"' + groupStartDate + '",'
                            + '"SubjectSitus":"' + groupstate + '",'
                            + '"groupFundingType":"' + groupFundingArrangement + '",'
                            + '"groupPlatform":"' + groupPlatformType + '",'
                            + '"groupLineOfBusiness":"' + groupLineOfBusiness + '",'
                            + '"groupRegion":"' + groupRegion + '",'
                            + '"groupSalesOffice":"' + groupSalesOffice + '",'
                            + '"groupHelathPlanMajor":"' + groupPlanMajor + '",'
                            + '"groupHelathPlanMinor":"' + groupPlanMinor + '",'
                            + '"groupPolicyRenewalYear":"' + groupPolicyRenewalYear + '",'
                            + '"groupPolicy":"' + groupPolicy + '",'
                            + '"brokerName":"' + brokerName + '",'
                            + '"brokerId":"' + brokerId + '",'
                            + '"SubjectId":"' + subjectId + '",'
                           // + '"SubjectName":"' + unescape(subjectName.split('\"').join('\\"')) + '",'    //DE385766:Change
                            + '"SubjectDOB":"' + subjectDOB + '",'
                            + '"SubjectGroupId":"' + subjectGroupId + '",'
                            + '"SubjectMemberSSN":"' + subjectMemberSSN + '",'
                            + '"uhgRestriction":"' + component.get('v.uhgAccess') + '",';
                            //+ '"slaDay":"' + slaDayVal + '",'
                            strWrapper = strWrapper + '"emailURL":"' + emailURL + '",'
                            + '"otherAdminType":"' + otherAdminType + '",'
                            + '"Interaction":"' + interaction + '",'
                            +'"memberRelationship":"'+component.get('v.relationShip')+'",'
                         
                            //Get the Member Relationship
                            
                            helper.createOneNDoneCase(component, event, originatorId, strWrapper, flowType, SIDescription, documentId,groupName,subjectName);     //US2564216 || US2564216 || DE385766 :changes
                            
                            
                        }
                    });
                    $A.enqueueAction(accountaction);
                    
                } else {
                    var spinner2 = component.find("dropdown-spinner");
                    $A.util.removeClass(spinner2, "slds-show");
                    $A.util.addClass(spinner2, "slds-hide");
                    var toastType = "Error";
                    var toastMessage = "Issue with case creation.";
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type":toastType,
                        "message": toastMessage
                    });
                    toastEvent.fire();
                }
            });
            $A.enqueueAction(action);
        }
    },
    openNewOneClick: function(component,event,helper){
        var workspaceAPI = component.find("workspace"); 
        workspaceAPI.openTab({
            pageReference: {
                "type": "standard__component",
                "attributes": {
                    "componentName": "c__ETSBE_OneClick"
                },
                "state": {
                    
                }
            },
            focus: true
        }).then(function(response) {
            
            workspaceAPI.getTabInfo({
                tabId: response
                
            }).then(function(tabInfo) {
                
                workspaceAPI.setTabLabel({
                    tabId: tabInfo.tabId,
                    label:"BEO Explore"
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
    },
    /*   openAttachFile: function(component,event,helper){
        component.set("v.isAttachFileModal",true);
    },
    closeAttachFile: function(component,event,helper){
        component.set("v.isAttachFileModal",false);
    },*/
    /*  handleUploadFinished: function (cmp, event, helper) {
        // This will contain the List of File uploaded data and status
        var uploadedFiles = event.getParam("files");
        console.log("Files uploaded : " + uploadedFiles.length);
        console.log('Files: ' + JSON.stringify(uploadedFiles));
        cmp.set("v.isFilesList", true);
        var filesStr = cmp.get("v.filesList");
        for(var i = 0; i < uploadedFiles.length; i++){
            if(filesStr == ''){
                filesStr = uploadedFiles[i].name;
            } else {
                filesStr = filesStr + ', ' + uploadedFiles[i].name;
            }
        }
        console.log('FILES STUFF: ' + cmp.get("v.isFilesList") + ',,,' + filesStr);
        cmp.set("v.filesList", filesStr);
    },*/
    openDetailPage: function(component,event,helper){
        if(helper.validateContinueBtn(component, event, helper)){
    		helper.navigateToGeneral(component,event);
    	}
    },
    openCasePage: function(component,event,helper){
        //window.open('/' + component.get('v.createdCaseSFID'));  
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
          "recordId": component.get('v.createdCaseSFID')
        });
        navEvt.fire();
    },
    openIntPage: function(component,event,helper){
        
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
          "recordId": component.get('v.createdInteractionSFID')
        });
        navEvt.fire();
    },
    openTopicPage: function(component,event,helper){
    	component.set("v.createdCaseSFID", "");
    	component.set("v.createdCaseID", "");
        component.set("v.createdInteractionSFID", "");
    	component.set("v.createdInteractionID", "");
    	component.set("v.filesList", "");
        if(helper.validateContinueBtn(component, event, helper)){
        	var spinner = component.find("dropdown-spinner");
            $A.util.removeClass(spinner, "slds-hide");
            $A.util.addClass(spinner, "slds-show");
            //Member Not Found
            if(component.get('v.isMemberNotFound')){
            	component.set('v.searchMemberFirstName',component.get('v.searchMemberFirstName').trim());
            	component.set('v.searchMemberLastName',component.get('v.searchMemberLastName').trim());
	            var memberData = {
	                "sourceCode": '',
	                "Name": component.get('v.searchMemberFirstName') + ' ' + component.get('v.searchMemberLastName'),
	                "DOB": component.get('v.searchMemberDOB'),
	                "firstName": component.get('v.searchMemberFirstName'),
	                "lastName": component.get('v.searchMemberLastName'),
	                "memberID": component.get('v.searchMemberIdSSN'),
	                "payerID":'',
	                "groupNumber":'',
	                "searchOption":'MemberIDDateOfBirth',
	                "SSN":''
	            }
	            component.set("v.memberSelected",memberData);
            }
            var memberResultinfo = component.get("v.memberSelected");
            if(memberResultinfo == null){
                memberResultinfo = '';
            }
            var custmrAdmininfo = component.get("v.originatorSelected");
            var producerinfo = component.get("v.producerSelected");
            var groupinfo = component.get("v.groupSelected");
            console.log('HERE IS CUSTOMER ADMIN FOR PASSING: ' + JSON.stringify(custmrAdmininfo));
            if(custmrAdmininfo == null || custmrAdmininfo == undefined){
                custmrAdmininfo = {"adminType":"Member"};
                console.log('HERE IS CUSTOMER ADMIN FOR PASSING2: ' + JSON.stringify(custmrAdmininfo));
            }
            var firstname;
            var SearchType;
            var lastname;
            var uniqueId;
            var dob;
            if(producerinfo != null && producerinfo != undefined && producerinfo != ''){
            	if(producerinfo.producerType == 'I'){
            		firstname = producerinfo.producerIndividualName.firstName;
            		lastname = producerinfo.producerIndividualName.lastName;
            	} else {
            		lastname = producerinfo.producerCompanyName;
            	}
            	SearchType = 'Producer';
            	uniqueId = producerinfo.producerID;
            }
            console.log('MEMDETAIL: ' + JSON.stringify(memberResultinfo));
            if(groupinfo != null && groupinfo!= undefined && groupinfo != ""){
                  if(groupinfo.groupName.length<=80){
                            firstname = '';
                            lastname = groupinfo.groupName;
                        } else if(groupinfo.groupName.length>80 && groupinfo.groupName.length<=120){
                            firstname = groupinfo.groupName.substring(0,40);
                            lastname = groupinfo.groupName.substring(40,groupinfo.groupName.length);
                       	
                            
                        }
                else if( groupinfo.groupName.length>120){
                            firstname = groupinfo.groupName.substring(0,40);
                            lastname = groupinfo.groupName.substring(40,120);
                       	
                            
                        }
                
                         SearchType = 'Group/Employer';
                            uniqueId = groupinfo.groupId;
                    
            }
            if(memberResultinfo != null && memberResultinfo!= undefined && memberResultinfo != ""){
                lastname = memberResultinfo.lastName;
                firstname = memberResultinfo.firstName;
                SearchType = 'Member';
                uniqueId = memberResultinfo.firstName + memberResultinfo.lastName + memberResultinfo.DOB + memberResultinfo.memberID;
            }
            if((firstname == undefined || firstname == null || firstname == ''||firstname>=80 ) && (lastname == undefined || lastname == null || lastname == ''||lastname >=80)) {
                firstname = 'General';
                lastname = 'Inquiry';
            }
            var uhgAccess = component.get('v.uhgAccess');
            var isMemberNotFound = component.get('v.isMemberNotFound');
            console.log('UHG ACCESS FOR PERSON ACCT: ' + uhgAccess);
            var accountaction = component.get("c.createPersonAccount");
            accountaction.setParams({"SearchType" :SearchType, 
                                     "firstName": firstname,"lastName":lastname,
                                     "uniqueId":uniqueId,"dob":memberResultinfo.DOB,"uhgAccess":uhgAccess});
            accountaction.setCallback(this,function(response){
                var state = response.getState();
                if(state == "SUCCESS"){
                    console.log('Person Account ID: ' + response.getReturnValue());
                    var contactid = response.getReturnValue();
                    
                    
                    component.set("v.FlowType",SearchType);
                    component.set("v.ContactId",contactid);
                    
                }
            });
            $A.enqueueAction(accountaction);
            
            var memberRelationship = '';
                     
            var selOrig = component.get("v.originatorSelected");
            //create interaction
            
            var interactionRec = '';
            var typeText = component.get('v.originatorText');
            typeText = typeText.trim();
            var memberFirstName = '';
            var memberLastName = '';
            var memberDOB = '';
            var memberId = '';
            var originatorId = '';
        	if(typeText.toLowerCase() == 'member'){
            	var memberData = component.get('v.memberSelected');
                memberFirstName = memberData.firstName;
                memberLastName = memberData.lastName;
                memberDOB = memberData.DOB;
                memberId = memberData.memberID;
            } else {
                originatorId = selOrig.Id;
            }
        	var intType = '';
            if(component.get("v.isResearchUser") == true){
            	intType = "Research";
            } else {
            	intType = component.get("v.interactionType");
            }
            var updateInteraction = component.get("v.updateCaseInteractionInfo");
            if(updateInteraction != null && updateInteraction != undefined && updateInteraction != '' && updateInteraction.Id != ''){
            	var action1 = component.get("c.updateInteractionStandard");
	            action1.setParams({
	                origSfId: originatorId,
	                interactionType: intType,
	                eventReceivedDate: component.get("v.eventReceivedDate"),
	                eventReceivedTime: component.get("v.eventReceivedTime"),
	                memberFirstName: memberFirstName,
	                memberLastName: memberLastName,
	                memberDOB: memberDOB,
	                memberId: memberId,
	                updateIntId: updateInteraction.Id
	            });
	            action1.setCallback(this, function(response) {
	                var state = response.getState();
	                console.log('INTERACTION STATE: ' + state);
	                if(state == "SUCCESS") {
	                    var storeResponse = response.getReturnValue();
	                    console.log('INTERACTION TO PASS THROUGH: ' + JSON.stringify(storeResponse));
	                    var interactionRec = storeResponse;                    
	                    var toProceedToCreateTheCase = true;
	                    if(interactionRec != undefined && interactionRec != null) {
	                        var interactStatus = interactionRec.Current_Status__c;
	                        interactStatus = (interactStatus != undefined && interactStatus != null) ? interactStatus : '';
	                        if(interactStatus == 'Closed') {
	                            var interactResDate = interactionRec.Resolution_Date__c;
	                            interactResDate = (interactResDate != undefined && interactResDate != null) ? interactResDate : '';
	                            if(interactResDate != '') {
	                                interactResDate = interactResDate.substring(0, interactResDate.indexOf("T"));
	                                var d = new Date(interactResDate);                            
	                                var compareDate = new Date(d.getFullYear(), d.getMonth(), d.getDate());
	                                var diff = Math.ceil(new Date() - compareDate);
	                                var noOfDays = Math.floor(diff/(1000 * 60 * 60 * 24));
	                                if(noOfDays != undefined && noOfDays != null && noOfDays > 90) {
	                                    toProceedToCreateTheCase = false;
	                                }
	                            }                        
	                        }
	                    }
	                    if(toProceedToCreateTheCase) {
	                        
	                        var producerId = (component.get("v.producerSelected.producerID") != null && component.get("v.producerSelected.producerID") != undefined) ? component.get("v.producerSelected.producerID") : '';
	                        var groupId = (component.get("v.groupSelected.groupId") != null && component.get("v.groupSelected.groupId") != undefined) ? component.get("v.groupSelected.groupId") : '';
	                        //SSN is returned, member is not, maybe run that second service from member detail? Or just take the input text??
	                        var memberId = (component.get("v.memberSelected.memberID") != null && component.get("v.memberSelected.memberID") != undefined) ? component.get("v.memberSelected.memberID") : '';
	                        var flowType = '';
	                        if(producerId != null && producerId != ''){
	                            flowType = 'Producer';
	                        }
	                        if(groupId != null && groupId != ''){
	                            flowType = 'Group/Employer';
	                        }
	                        if(memberId != null && memberId != ''){
	                            flowType = 'Member';
	                        }
	                        var resolution = '';
	                        var businessUnit = '';
	                        var issueCategory = '';
	                        if(component.get("v.searchResolution") != null && component.get("v.searchResolution") != undefined && component.get("v.searchResolution") != ''){
	                            resolution = component.get("v.searchResolution");
	                            resolution = resolution.trim();
	                        }
	                        if(component.get("v.businessUnitSelected") != null && component.get("v.businessUnitSelected") != undefined && component.get("v.businessUnitSelected") != '' && component.get("v.businessUnitSelected") != 'None'){
	                            businessUnit = component.get("v.businessUnitSelected");
	                        }
	                        if(component.get("v.topicSelected") != null && component.get("v.topicSelected") != undefined && component.get("v.topicSelected") != '' && component.get("v.topicSelected") != 'None'){
	                            issueCategory = component.get("v.topicSelected");
	                        }
	                        var specialInstructionsInfo = {
	                            "resolution":resolution,
	                            "businessUnit":businessUnit,
	                            "issueCategory":issueCategory,
                                "oneAndDoneFlag" : component.get('v.oneAndDoneBool')
	                        };
                            var updateCase = component.get('v.updateCaseInfo');
                            helper.navigateToSpecInsPage(component, event, interactionRec, flowType, component.get("v.relationShip"), specialInstructionsInfo,updateCase);
	                    }  else {
	                        var toastType = "Error";
	                        var toastMessage = "Case can only be opened within 90 days of Interaction Closed";
	                        var toastEvent = $A.get("e.force:showToast");
	                        toastEvent.setParams({
	                            "type":toastType,
	                            "message": toastMessage
	                        });
	                        toastEvent.fire();
	                        var spinner2 = component.find("dropdown-spinner");
	                        $A.util.removeClass(spinner2, "slds-show");
	                        $A.util.addClass(spinner2, "slds-hide");
	                    }                                      
	                }
	            });
	            $A.enqueueAction(action1);
            } else {
	            var action = component.get("c.createInteractionStandard");
	            action.setParams({
	                origSfId: originatorId,
	                interactionType: intType,
	                eventReceivedDate: component.get("v.eventReceivedDate"),
	                eventReceivedTime: component.get("v.eventReceivedTime"),
	                memberFirstName: memberFirstName,
	                memberLastName: memberLastName,
	                memberDOB: memberDOB,
	                memberId: memberId
	            });
	            action.setCallback(this, function(response) {
	                var state = response.getState();
	                if(state == "SUCCESS") {
	                    var storeResponse = response.getReturnValue();
	                    console.log('INTERACTION TO PASS THROUGH: ' + JSON.stringify(storeResponse));
	                    var interactionRec = storeResponse;                    
	                    var toProceedToCreateTheCase = true;
	                    if(interactionRec != undefined && interactionRec != null) {
	                        var interactStatus = interactionRec.Current_Status__c;
	                        interactStatus = (interactStatus != undefined && interactStatus != null) ? interactStatus : '';
	                        if(interactStatus == 'Closed') {
	                            var interactResDate = interactionRec.Resolution_Date__c;
	                            interactResDate = (interactResDate != undefined && interactResDate != null) ? interactResDate : '';
	                            if(interactResDate != '') {
	                                interactResDate = interactResDate.substring(0, interactResDate.indexOf("T"));
	                                var d = new Date(interactResDate);                            
	                                var compareDate = new Date(d.getFullYear(), d.getMonth(), d.getDate());
	                                var diff = Math.ceil(new Date() - compareDate);
	                                var noOfDays = Math.floor(diff/(1000 * 60 * 60 * 24));
	                                if(noOfDays != undefined && noOfDays != null && noOfDays > 90) {
	                                    toProceedToCreateTheCase = false;
	                                }
	                            }                        
	                        }
	                    }
	                    if(toProceedToCreateTheCase) {
	                        
	                        var producerId = (component.get("v.producerSelected.producerID") != null && component.get("v.producerSelected.producerID") != undefined) ? component.get("v.producerSelected.producerID") : '';
	                        var groupId = (component.get("v.groupSelected.groupId") != null && component.get("v.groupSelected.groupId") != undefined) ? component.get("v.groupSelected.groupId") : '';
	                        //SSN is returned, member is not, maybe run that second service from member detail? Or just take the input text??
	                        var memberId = (component.get("v.memberSelected.memberID") != null && component.get("v.memberSelected.memberID") != undefined) ? component.get("v.memberSelected.memberID") : '';
	                        var flowType = '';
	                        if(producerId != null && producerId != ''){
	                            flowType = 'Producer';
	                        }
	                        if(groupId != null && groupId != ''){
	                            flowType = 'Group/Employer';
	                        }
	                        if(memberId != null && memberId != ''){
	                            flowType = 'Member';
	                        }
	                        var resolution = '';
	                        var businessUnit = '';
	                        var issueCategory = '';
	                        if(component.get("v.searchResolution") != null && component.get("v.searchResolution") != undefined && component.get("v.searchResolution") != ''){
	                            resolution = component.get("v.searchResolution");
	                            resolution = resolution.trim();
	                        }
	                        if(component.get("v.businessUnitSelected") != null && component.get("v.businessUnitSelected") != undefined && component.get("v.businessUnitSelected") != '' && component.get("v.businessUnitSelected") != 'None'){
	                            businessUnit = component.get("v.businessUnitSelected");
	                        }
	                        if(component.get("v.topicSelected") != null && component.get("v.topicSelected") != undefined && component.get("v.topicSelected") != '' && component.get("v.topicSelected") != 'None'){
	                            issueCategory = component.get("v.topicSelected");
	                        }
	                        var specialInstructionsInfo = {
	                            "resolution":resolution,
	                            "businessUnit":businessUnit,
	                            "issueCategory":issueCategory,
                                "oneAndDoneFlag" : component.get('v.oneAndDoneBool')
	                        };
	                        var updateCase = component.get('v.updateCaseInfo');
	                        helper.navigateToSpecInsPage(component, event, interactionRec, flowType, component.get("v.relationShip"), specialInstructionsInfo,updateCase);
	                        //Get the Member Relationship
	                        /*if(memberResultinfo != null && memberResultinfo!= undefined && memberResultinfo != "") {
	                            
	                            var formatDate = memberResultinfo.DOB.split('/')[2] + '-' + memberResultinfo.DOB.split('/')[0] + '-' + memberResultinfo.DOB.split('/')[1];
	                            
	                            var action3 = component.get('c.fetchData');
	                            action3.setParams({
	                                transactionId : null,
	                                memberId : memberResultinfo.Id,
	                                memberDOB : formatDate,
	                                memberFN : memberResultinfo.firstName,
	                                memberLN : memberResultinfo.lastName,
	                                memberGrpN : '',
	                                searchOption : memberResultinfo.searchOption,
	                                payerID : '87726'
	                            });
	                            action3.setCallback(this, function(response){
	                                var state = response.getState();                          
	                                if (state == 'SUCCESS') {
	                                    var transactionId = '';
	                                    var result = response.getReturnValue();
	                                    result = JSON.parse(result);
	                                    console.log("FETCH DATA: " + JSON.stringify(result));
	                                    if (result.statusCode == 200) {
	                                        var coverageLines = result.resultWrapper.CoverageLines;                                    
	                                        for(var i = 0; i < coverageLines.length; i++) {
	                                            if(coverageLines[i].highlightedPolicy == true) {
	                                                transactionId = coverageLines[i].transactionId;
	                                            }
	                                        }
	                                    }
	                                    
	                                    if(transactionId != undefined && transactionId != null && transactionId !== '') {
	                                        
	                                        var action4 = component.get("c.returnHouseHoldData");        
	                                        action4.setParams({
	                                            "transactionId": transactionId                        
	                                        });
	                                        action4.setCallback(this, function(response) {            
	                                            var state = response.getState();
	                                            if(state == 'SUCCESS') {
	                                                var result = response.getReturnValue();                                
	                                                console.log('HS list::'+result.resultWrapper.houseHoldList);
	                                                var houseHoldList = result.resultWrapper.houseHoldList;
	                                                if(houseHoldList != undefined && houseHoldList != null && houseHoldList.length > 0) {
	                                                    for(var i=0; i<houseHoldList.length; i++) {
	                                                        if(houseHoldList[i].isMainMember == true) {
	                                                            memberRelationship = houseHoldList[i].relationship;
	                                                            break;
	                                                        }
	                                                    }    
	                                                }
	                                                console.log('memberRelationship-'+memberRelationship);
	                                                helper.navigateToSpecInsPage(component, event, interactionRec, flowType, memberRelationship, specialInstructionsInfo);
	                                            }            
	                                        });                                    
	                                        $A.enqueueAction(action4);                                  
	                                    }
	                                }
	                            });
	                            $A.enqueueAction(action3);                        
	                        } else {                        
	                            helper.navigateToSpecInsPage(component, event, interactionRec, flowType, memberRelationship, specialInstructionsInfo);
	                        }*/
	                    }  else {
	                        var toastType = "Error";
	                        var toastMessage = "Case can only be opened within 90 days of Interaction Closed";
	                        var toastEvent = $A.get("e.force:showToast");
	                        toastEvent.setParams({
	                            "type":toastType,
	                            "message": toastMessage
	                        });
	                        toastEvent.fire();
	                        var spinner2 = component.find("dropdown-spinner");
	                        $A.util.removeClass(spinner2, "slds-show");
	                        $A.util.addClass(spinner2, "slds-hide");
	                    }                                      
	                }
	            });
	            $A.enqueueAction(action);
            }
        }
    },
    checkResolutionLength: function(component,event,helper) {
        
        if(component.get('v.isResearchUser')) {
        	component.set("v.isCreateCase", true);    
        } else {
            component.set("v.isToggle", false);
            component.set("v.isCreateCase", false);
        }
    	var resolution = component.find("searchResolution");
    	$A.util.removeClass(resolution, "slds-has-error");  
		component.find("resolutionError").set("v.errors", null);
    	var res = component.get("v.searchResolution");
    	if(res.length == 8000){
    		console.log('CHARACTER LIMIT REACHED');
    		$A.util.addClass(resolution, "slds-has-error");
    		component.find("resolutionError").set("v.errors", [{message:"Max characters for Resolution has been reached."}]);
    		
    	}
    },
    handleClickAgencyBroker: function(component,event,helper){
    	var htmlcmp = event.currentTarget;
    	var selectedRowIndex = htmlcmp.getAttribute("data-index");
    	var rewAccNum = event.currentTarget.getAttribute("data-rewAccNum");
    	var rewAccName = event.currentTarget.getAttribute("data-rewAccName");
    	console.log('ONCLICK EVENT: ' + rewAccNum +','+rewAccName);
    	component.set("v.originatorSelectedEdit.Agency_Broker_Name__c",rewAccName);
    	component.set("v.originatorSelectedEdit.Reward_Account_Number__c",rewAccNum);
    	component.set("v.updateEditOriginatorTableBool", true);
    	component.set('v.editOriginatorTableBool',false);
		component.set('v.editOriginatorTableData','');
		component.set('v.editOriginatorTableMessage', "");
    },
    handleClickGeneralAgency: function(component,event,helper){
    	var htmlcmp = event.currentTarget;
    	var selectedRowIndex = htmlcmp.getAttribute("data-index");
    	var franchiseCode = event.currentTarget.getAttribute("data-franchiseCode");
    	var genAgency = event.currentTarget.getAttribute("data-genAgency");
    	console.log('ONCLICK EVENT: ' + franchiseCode +','+genAgency);
    	component.set("v.originatorSelectedEdit.General_Agency__c",genAgency);
    	component.set("v.originatorSelectedEdit.Franchise_Code__c",franchiseCode);
    	component.set("v.updateEditOriginatorTableBool", true);
    	component.set('v.editOriginatorTableBool',false);
		component.set('v.editOriginatorTableData','');
		component.set('v.editOriginatorTableMessage', "");
    },
    handleClickGroupContact: function(component,event,helper){
    	var htmlcmp = event.currentTarget;
    	var selectedRowIndex = htmlcmp.getAttribute("data-index");
    	var groupName = event.currentTarget.getAttribute("data-groupName");
    	var groupNumber = event.currentTarget.getAttribute("data-groupNumber");
        var policyNumber = event.currentTarget.getAttribute("data-policyNumber");
    	console.log('ONCLICK EVENT: ' + groupName +','+groupNumber+','+policyNumber);
    	component.set("v.originatorSelectedEdit.Group_Name__c",groupName);
    	component.set("v.originatorSelectedEdit.Group_Number__c",groupNumber);
        component.set("v.originatorSelectedEdit.Policy_Number__c",policyNumber);
    	component.set("v.updateEditOriginatorTableBool", true);
    	component.set('v.editOriginatorTableBool',false);
		component.set('v.editOriginatorTableData','');
		component.set('v.editOriginatorTableMessage', "");
    },
    searchForSolarisOriginator: function(component,event,helper){
        component.set('v.updateEditOriginatorTableBool',false);
        component.set('v.editOriginatorTableBool',false);
    	component.set("v.editOriginatorTableMessage", "");
        var selOrig = component.get("v.originatorSelectedEdit");
        if(selOrig.Originator_Type__c == 'Agency/Broker' && ((component.get('v.originatorSelectedEdit.Reward_Account_Number__c') == null || component.get('v.originatorSelectedEdit.Reward_Account_Number__c') == undefined || component.get('v.originatorSelectedEdit.Reward_Account_Number__c') == '') 
			|| (component.get('v.originatorSelectedEdit.Agency_Broker_Name__c') == null || component.get('v.originatorSelectedEdit.Agency_Broker_Name__c') == undefined || component.get('v.originatorSelectedEdit.Agency_Broker_Name__c') == ''))){
            component.set('v.editOriginatorTableMessage', "Enter a valid Rewards Account Number and Agency/Broker Name.");
        } else if(selOrig.Originator_Type__c == 'General Agent' && (component.get('v.originatorSelectedEdit.Franchise_Code__c') == null || component.get('v.originatorSelectedEdit.Franchise_Code__c') == undefined || component.get('v.originatorSelectedEdit.Franchise_Code__c') == '')){
            component.set('v.editOriginatorTableMessage', "Enter a valid Franchise Code.");
        } else if(selOrig.Originator_Type__c == 'Group Contact' && ((component.get('v.originatorSelectedEdit.Group_Number__c') == null || component.get('v.originatorSelectedEdit.Group_Number__c') == undefined || component.get('v.originatorSelectedEdit.Group_Number__c') == '') 
			|| (component.get('v.originatorSelectedEdit.Policy_Number__c') == null || component.get('v.originatorSelectedEdit.Policy_Number__c') == undefined || component.get('v.originatorSelectedEdit.Policy_Number__c') == ''))){
            component.set('v.editOriginatorTableMessage', "Enter a valid Group Number or Policy Number.");
        }
    	if((component.get('v.originatorSelectedEdit.Reward_Account_Number__c') != null && component.get('v.originatorSelectedEdit.Reward_Account_Number__c') != undefined && component.get('v.originatorSelectedEdit.Reward_Account_Number__c') != '')
           || (component.get('v.originatorSelectedEdit.Agency_Broker_Name__c') != null && component.get('v.originatorSelectedEdit.Agency_Broker_Name__c') != undefined && component.get('v.originatorSelectedEdit.Agency_Broker_Name__c') != '') 
           || (component.get('v.originatorSelectedEdit.Franchise_Code__c') != null && component.get('v.originatorSelectedEdit.Franchise_Code__c') != undefined && component.get('v.originatorSelectedEdit.Franchise_Code__c') != '') 
          || (component.get('v.originatorSelectedEdit.Group_Number__c') != null && component.get('v.originatorSelectedEdit.Group_Number__c') != undefined && component.get('v.originatorSelectedEdit.Group_Number__c') != '') 
          || (component.get('v.originatorSelectedEdit.Policy_Number__c') != null && component.get('v.originatorSelectedEdit.Policy_Number__c') != undefined && component.get('v.originatorSelectedEdit.Policy_Number__c') != '')){
    		helper.searchSolarisOriginatorEdit(component,event,helper);
    	}
    },
    handleClickAgencyBrokerAdd: function(component,event,helper){
    	var htmlcmp = event.currentTarget;
    	var selectedRowIndex = htmlcmp.getAttribute("data-index");
    	var rewAccNum = event.currentTarget.getAttribute("data-rewAccNum");
    	var rewAccName = event.currentTarget.getAttribute("data-rewAccName");
    	console.log('ONCLICK EVENT: ' + rewAccNum +','+rewAccName);
    	component.set("v.originatorSelectedAdd.Agency_Broker_Name__c",rewAccName);
    	component.set("v.originatorSelectedAdd.Reward_Account_Number__c",rewAccNum);
    	component.set("v.updateAddOriginatorTableBool", true);
    	component.set('v.addOriginatorTableBool',false);
		component.set('v.addOriginatorTableData','');
		component.set('v.addOriginatorTableMessage', "");
    },
    handleClickGeneralAgencyAdd: function(component,event,helper){
    	var htmlcmp = event.currentTarget;
    	var selectedRowIndex = htmlcmp.getAttribute("data-index");
    	var franchiseCode = event.currentTarget.getAttribute("data-franchiseCode");
    	var genAgency = event.currentTarget.getAttribute("data-genAgency");
    	console.log('ONCLICK EVENT: ' + franchiseCode +','+genAgency);
    	component.set("v.originatorSelectedAdd.General_Agency__c",genAgency);
    	component.set("v.originatorSelectedAdd.Franchise_Code__c",franchiseCode);
    	component.set("v.updateAddOriginatorTableBool", true);
    	component.set('v.addOriginatorTableBool',false);
		component.set('v.addOriginatorTableData','');
		component.set('v.addOriginatorTableMessage', "");
    },
    handleClickGroupContactAdd: function(component,event,helper){
    	var htmlcmp = event.currentTarget;
    	var selectedRowIndex = htmlcmp.getAttribute("data-index");
    	var groupName = event.currentTarget.getAttribute("data-groupName");
    	var groupNumber = event.currentTarget.getAttribute("data-groupNumber");
        var policyNumber = event.currentTarget.getAttribute("data-policyNumber");
    	console.log('ONCLICK EVENT: ' + groupName +','+groupNumber+','+policyNumber);
    	component.set("v.originatorSelectedAdd.Group_Name__c",groupName);
    	component.set("v.originatorSelectedAdd.Group_Number__c",groupNumber);
        component.set("v.originatorSelectedAdd.Policy_Number__c",policyNumber);
        component.set("v.updateAddOriginatorTableBool", true);
    	component.set('v.addOriginatorTableBool',false);
		component.set('v.addOriginatorTableData','');
		component.set('v.addOriginatorTableMessage', "");
    },
    searchForSolarisOriginatorAdd: function(component,event,helper){
        component.set('v.updateAddOriginatorTableBool',false);
        component.set('v.addOriginatorTableBool',false);
    	component.set("v.addOriginatorTableMessage", "");
        var selOrig = component.get("v.originatorSelectedAdd");
        if(selOrig.Originator_Type__c == 'Agency/Broker' && ((component.get('v.originatorSelectedAdd.Reward_Account_Number__c') == null || component.get('v.originatorSelectedAdd.Reward_Account_Number__c') == undefined || component.get('v.originatorSelectedAdd.Reward_Account_Number__c') == '') 
			|| (component.get('v.originatorSelectedAdd.Agency_Broker_Name__c') == null || component.get('v.originatorSelectedAdd.Agency_Broker_Name__c') == undefined || component.get('v.originatorSelectedAdd.Agency_Broker_Name__c') == ''))){
            component.set('v.addOriginatorTableMessage', "Enter a valid Rewards Account Number and Agency/Broker Name.");
        } else if(selOrig.Originator_Type__c == 'General Agent' && (component.get('v.originatorSelectedAdd.Franchise_Code__c') == null || component.get('v.originatorSelectedAdd.Franchise_Code__c') == undefined || component.get('v.originatorSelectedAdd.Franchise_Code__c') == '')){
            component.set('v.addOriginatorTableMessage', "Enter a valid Franchise Code.");
        } else if(selOrig.Originator_Type__c == 'Group Contact' && ((component.get('v.originatorSelectedAdd.Group_Number__c') == null || component.get('v.originatorSelectedAdd.Group_Number__c') == undefined || component.get('v.originatorSelectedAdd.Group_Number__c') == '') 
			|| (component.get('v.originatorSelectedAdd.Policy_Number__c') == null || component.get('v.originatorSelectedAdd.Policy_Number__c') == undefined || component.get('v.originatorSelectedAdd.Policy_Number__c') == ''))){
            component.set('v.addOriginatorTableMessage', "Enter a valid Group Number or Policy Number.");
        }
    	if((component.get('v.originatorSelectedAdd.Reward_Account_Number__c') != null && component.get('v.originatorSelectedAdd.Reward_Account_Number__c') != undefined && component.get('v.originatorSelectedAdd.Reward_Account_Number__c') != '')
           || (component.get('v.originatorSelectedAdd.Agency_Broker_Name__c') != null && component.get('v.originatorSelectedAdd.Agency_Broker_Name__c') != undefined && component.get('v.originatorSelectedAdd.Agency_Broker_Name__c') != '') 
           || (component.get('v.originatorSelectedAdd.Franchise_Code__c') != null && component.get('v.originatorSelectedAdd.Franchise_Code__c') != undefined && component.get('v.originatorSelectedAdd.Franchise_Code__c') != '') 
          || (component.get('v.originatorSelectedAdd.Group_Number__c') != null && component.get('v.originatorSelectedAdd.Group_Number__c') != undefined && component.get('v.originatorSelectedAdd.Group_Number__c') != '') 
          || (component.get('v.originatorSelectedAdd.Policy_Number__c') != null && component.get('v.originatorSelectedAdd.Policy_Number__c') != undefined && component.get('v.originatorSelectedAdd.Policy_Number__c') != '')){
    		helper.searchSolarisOriginatorAdd(component,event,helper);
    	}
    },
    enableCreateCaseBtn : function(component, event) {
        
        if(component.get('v.isResearchUser')) {
        	component.set("v.isCreateCase", true);    
        } else {
            component.set("v.isToggle", false);
            component.set("v.isCreateCase", false);
        }
    }
})