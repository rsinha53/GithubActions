({
	searchInstructionRecordsOnload: function(component,event){
		component.set("v.showSpinner", true);
        var spinner = component.find("dropdown-spinner");  
        $A.util.removeClass(spinner, "slds-hide");
        $A.util.addClass(spinner, "slds-show");
        var instructionSearchType = component.get("v.instructionSearchType");
        var businessUnit = component.get("v.businessUnitSelected");
        var topic = component.get("v.topicSelected");
        var type = component.get("v.typeSelected");
        var action = component.get("c.populateBusinessDropdown");
        var userRole = '';
        if(component.get("v.userInfo").Role_Name__c == "System Administrator"){
            userRole = component.get("v.userInfo").Role_Name__c;
        } else {
            userRole = component.get("v.userInfo").BEO_Specialty__c;
        }
        var userProfile = component.get("v.userInfo").Profile_Name__c;
        console.log("HERE IS  THE USER: " + JSON.stringify(component.get("v.userInfo")));
        console.log("HERE IS THE PROFILE: " + userProfile);
        var sendBusinessUnit = businessUnit;
        if(userRole != null && userRole != '' && userRole != undefined){
            action.setParams({
                searchType: instructionSearchType,
                searchBusinessUnit: sendBusinessUnit,
                searchTopic: topic,
                searchTypeSel: type,
                searchUser: userRole,
                searchProfile: userProfile,
                 searchfundingType :  component.get("v.fundingTypeText")
            });
            console.log('before callback');
            action.setCallback(this,function(response){
                var state = response.getState();
                console.log('STATE: ' + state);
                if(state == "SUCCESS"){
                    var storeResponse = response.getReturnValue();
                    console.log('RESULTS: ' + storeResponse);
                    var dropdownOptions = [];
                    dropdownOptions.push({
                        label: "None",
                        value: "None"
                    });
                    for (var i = 0; i < storeResponse.length; i++) {
                        dropdownOptions.push({
                            label: storeResponse[i],
                            value: storeResponse[i]
                        });
                    }
                    component.set('v.topicOptions', dropdownOptions);
                    
                    var specialInfo = component.get("v.pageReference").state.c__SpecialInstructionInfo;
                    console.log('PRESELECTED ISSUE CATEGORY: ' + specialInfo.businessUnit);
                    if(specialInfo.issueCategory != null && specialInfo.issueCategory != undefined && specialInfo.issueCategory.trim() != '' && specialInfo.issueCategory != 'None'){
                        console.log('FULL ISSUE CATEGORY LIST: ' + JSON.stringify(dropdownOptions));
                        for(var i = 0; i < dropdownOptions.length; i++){
                            if(dropdownOptions[i].label == specialInfo.issueCategory){
                                component.set("v.topicSelected",specialInfo.issueCategory);
                                component.set("v.topicText", specialInfo.issueCategory);
                                component.set("v.instructionSearchType", "Type");
                                var action2 = component.get("c.populateBusinessDropdown");
                                action2.setParams({
                                    searchType: "Type",
                                    searchBusinessUnit: sendBusinessUnit,
                                    searchTopic: specialInfo.issueCategory,
                                    searchTypeSel: type,
                                    searchUser: userRole,
                                    searchProfile: userProfile,
                                     searchfundingType :  component.get("v.fundingTypeText")
                                });
                                action2.setCallback(this,function(response){
                                    var state = response.getState();
                                    console.log('STATE: ' + state);
                                    if(state == "SUCCESS"){
                                        var storeResponse = response.getReturnValue();
                                        console.log('RESULTS: ' + storeResponse);
                                        var dropdownOptions = [];
                                        dropdownOptions.push({
                                            label: "None",
                                            value: "None"
                                        });
                                        for (var i = 0; i < storeResponse.length; i++) {
                                            dropdownOptions.push({
                                                label: storeResponse[i],
                                                value: storeResponse[i]
                                            });
                                        }
                                        
                                        component.set('v.typeOptions', dropdownOptions);
                                        
                                        var spinner2 = component.find("dropdown-spinner");
                                        $A.util.removeClass(spinner2, "slds-show");
                                        $A.util.addClass(spinner2, "slds-hide");
                                        component.set("v.showSpinner", false);
                                    }
                                });
                                $A.enqueueAction(action2);
                                break;
                            }
                        }
                    }
                    var spinner2 = component.find("dropdown-spinner");
                    $A.util.removeClass(spinner2, "slds-show");
                    $A.util.addClass(spinner2, "slds-hide");
                    component.set("v.showSpinner", false);
                }
            });
            $A.enqueueAction(action);
        } else {
            var dropdownOptions = [];
            dropdownOptions.push({
                label: "None",
                value: "None"
            });
            component.set('v.businessUnitOptions', dropdownOptions);
            component.set('v.topicOptions', dropdownOptions);
            var spinner2 = component.find("dropdown-spinner");
            $A.util.removeClass(spinner2, "slds-show");
            $A.util.addClass(spinner2, "slds-hide");
        }
		
		
		var specialInfo = component.get("v.pageReference").state.c__SpecialInstructionInfo;
		console.log('PRESELECTED ISSUE CATEGORY: ' + specialInfo.businessUnit);
		if(specialInfo.issueCategory != null && specialInfo.issueCategory != undefined && specialInfo.issueCategory.trim() != '' && specialInfo.issueCategory != 'None'){
			var icList = component.get("v.topicOptions");
			console.log('FULL ISSUE CATEGORY LIST: ' + JSON.stringify(icList));
			if(icList.includes(specialInfo.issueCategory)){
				console.log('FOUND ISSUE CATEGORY: ' + specialInfo.issueCategory);
				component.set("v.topicSelected",specialInfo.issueCategory);
		    	component.set("v.topicText", specialInfo.issueCategory);
				component.set("v.instructionSearchType", "Type");
		    	helper.resetFields(component,event);
				helper.clearInfoFields(component,event);
				helper.searchInstructionRecords(component,event);
			}
		}
	},
    searchInstructionRecords : function(component, event) {
        component.set("v.showSpinner", true);
        var spinner = component.find("dropdown-spinner");
        $A.util.removeClass(spinner, "slds-hide");
        $A.util.addClass(spinner, "slds-show");
        var instructionSearchType = component.get("v.instructionSearchType");
        var businessUnit = component.get("v.businessUnitSelected");
        var topic = component.get("v.topicSelected");
        var type = component.get("v.typeSelected");
        var action = component.get("c.populateBusinessDropdown");
        var userRole = '';
        if(component.get("v.userInfo").Role_Name__c == "System Administrator"){
            userRole = component.get("v.userInfo").Role_Name__c;
        } else {
            userRole = component.get("v.userInfo").BEO_Specialty__c;
        }
        var userProfile = component.get("v.userInfo").Profile_Name__c;
        console.log("HERE IS THE USER: " + JSON.stringify(component.get("v.userInfo")));
        console.log("HERE IS THE PROFILE: " + userProfile);
        var sendBusinessUnit = businessUnit;
        if(userRole != null && userRole != '' && userRole != undefined){
            action.setParams({
                searchType: instructionSearchType,
                searchBusinessUnit: sendBusinessUnit,
                searchTopic: topic,
                searchTypeSel: type,
                searchUser: userRole,
                searchProfile: userProfile,
                searchfundingType :  component.get("v.fundingTypeText")
            });
            console.log('before callback');
            action.setCallback(this,function(response){
                var state = response.getState();
                console.log('STATE: ' + state);
                if(state == "SUCCESS"){
                    var storeResponse = response.getReturnValue();
                    console.log('RESULTS: ' + storeResponse);
                    var dropdownOptions = [];
                    dropdownOptions.push({
                        label: "None",
                        value: "None"
                    });
                    for (var i = 0; i < storeResponse.length; i++) {
                        dropdownOptions.push({
                            label: storeResponse[i],
                            value: storeResponse[i]
                        });
                    }
                    if(instructionSearchType == "Business Unit"){
                        component.set('v.businessUnitOptions', dropdownOptions);
                    } else if(instructionSearchType == "Topic"){
                        component.set('v.topicOptions', dropdownOptions);
                    } else if(instructionSearchType == "Type"){
                        component.set('v.typeOptions', dropdownOptions);
                    } else if(instructionSearchType == "Subtype"){
                        component.set('v.subtypeOptions', dropdownOptions);
                    } 
                    
                    var isSpecInstDropDownFlag = component.get("v.isSpecInstDropDown");
                    isSpecInstDropDownFlag = (isSpecInstDropDownFlag != undefined && isSpecInstDropDownFlag != null) ? isSpecInstDropDownFlag : false;
                    var isNotChildCaseFlag = component.get("v.isNotChildCase");
                    isNotChildCaseFlag = (isNotChildCaseFlag != undefined && isNotChildCaseFlag != null) ? isNotChildCaseFlag : false;
                    if(isNotChildCaseFlag && isSpecInstDropDownFlag) {
                        component.set("v.instructionSearchType", "");
                        if(instructionSearchType == "Topic"){
                            component.set('v.topicFilter', component.get("v.topicOptions"));
                        } else if(instructionSearchType == "Type"){                        
                            component.set("v.typeFilter", component.get("v.typeOptions"));
                        } else if(instructionSearchType == "Subtype"){
                            component.set("v.subtypeFilter", component.get("v.subtypeOptions"));
                        } 
                    }  
                    
                    var spinner2 = component.find("dropdown-spinner");
                    $A.util.removeClass(spinner2, "slds-show");
                    $A.util.addClass(spinner2, "slds-hide");
                    component.set("v.showSpinner", false);
                }
            });
            $A.enqueueAction(action);
        } else {
            var dropdownOptions = [];
            dropdownOptions.push({
                label: "None",
                value: "None"
            });
            component.set('v.businessUnitOptions', dropdownOptions);
            component.set('v.topicOptions', dropdownOptions);
            var spinner2 = component.find("dropdown-spinner");
            $A.util.removeClass(spinner2, "slds-show");
            $A.util.addClass(spinner2, "slds-hide");
        }
    },
    searchForRecord:function(component,event){
        debugger;
        component.set("v.showSpinner", true);
        var spinner = component.find("dropdown-spinner");
        $A.util.removeClass(spinner, "slds-hide");
        $A.util.addClass(spinner, "slds-show");
        var businessUnit = component.get("v.businessUnitSelected");
        var topic = component.get("v.topicSelected");
        var type = component.get("v.typeSelected");
        var subtype = component.get("v.subtypeSelected");
        var userRole = '';
        if(component.get("v.userInfo").Role_Name__c == "System Administrator"){
            userRole = component.get("v.userInfo").Role_Name__c;
        } else {
            userRole = component.get("v.userInfo").BEO_Specialty__c;
        }
        var userProfile = component.get("v.userInfo").Profile_Name__c;
        
        var groupData = component.get("v.groupData");
        var groupDataToSearch = {};
        var policyNumber = '';
        var platform = '';
        var situsState = '';
        var businessMarketRegion = '';
        var agencyBrokerName = '';
        var groupNumber = '';
        
        if(groupData != undefined && groupData != null) {
            var groupDataJSON = JSON.stringify(groupData);
            var policyNumber = groupData.policyNumber;
            policyNumber = (policyNumber != undefined && policyNumber != null) ? policyNumber : '';
            var platform = groupData.platform;
            platform = (platform != undefined && platform != null) ? platform : '';
            var situsState = groupData.situsState;
            situsState = (situsState != undefined && situsState != null) ? situsState : '';
            var businessMarketRegion = groupData.businessMarketRegion;
            businessMarketRegion = (businessMarketRegion != undefined && businessMarketRegion != null) ? businessMarketRegion : '';
            var agencyBrokerName = groupData.brokerName;
            agencyBrokerName = (agencyBrokerName != undefined && agencyBrokerName != null) ? agencyBrokerName : '';
            var groupNumber = groupData.groupId;
            groupNumber = (groupNumber != undefined && groupNumber != null) ? groupNumber : '';
            groupDataToSearch = {
                "policyNumber": policyNumber,
                "platform": platform,
                "situsState": situsState,
                "region": businessMarketRegion,
                "AgencyBrokerName": agencyBrokerName,
                "groupNumber": groupNumber,
                "sourceCode": (groupData.sourceCode != undefined && groupData.sourceCode != null) ? groupData.sourceCode : ''
            };
        }       
        if(!$A.util.isUndefinedOrNull(component.get("v.parentCaseRec"))){
            console.log(JSON.stringify(component.get("v.parentCaseRec")));
            groupDataToSearch = {
                "policyNumber": component.get("v.parentCaseRec.Policy__c"),
                "platform": component.get("v.parentCaseRec.Platform__c"),
                "situsState": component.get("v.parentCaseRec.Situs__c"),
                "region": component.get("v.parentCaseRec.Region__c"),
                "AgencyBrokerName": component.get("v.parentCaseRec.Line_of_Business__c"),
                "groupNumber": component.get("v.parentCaseRec.Subject_Group_ID__c"),
                "sourceCode": component.get("v.parentCaseRec.SourceCode__c")
            };
        }        
        var groupDetailsJSON = '';
        if(groupDataToSearch != undefined && groupDataToSearch != null) {
            groupDetailsJSON = JSON.stringify(groupDataToSearch);
            groupDetailsJSON = (groupDetailsJSON != undefined && groupDetailsJSON != null) ? groupDetailsJSON : ''; 
        }               
        //var lineOfBusiness = groupData.lineOfBusiness;
        
        var action = component.get("c.processTTSResults");
        action.setParams({
            'groupDetailsJSON' : groupDetailsJSON,
            'searchBusinessUnit': businessUnit,
            'searchTopic': topic,
            'searchType': type,
            'searchSubtype': subtype,
            'searchUser': userRole,
            'searchProfile': userProfile          
        });
        console.log('before callback');
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state == "SUCCESS"){
                var specialInstructionData = response.getReturnValue();
                var storeResponse = specialInstructionData.specialInstruction;
                var internalContact;
                //jangi - starts
                if(!$A.util.isUndefinedOrNull(component.get("v.parentCaseRec")) && component.get("v.parentCaseRec.SourceCode__c") == 'NA'){
                    internalContact = component.get("v.CDXDataResultsNA");
                }else{
                    internalContact = specialInstructionData.internalContact;
                }
                
                component.set("v.CDXDataResultsNA", internalContact);   
                //jangi - ends
                if(!$A.util.isUndefined(storeResponse) && !$A.util.isEmpty(storeResponse)){
                    console.log("SPECIAL RESULTS: " + JSON.stringify(storeResponse));
                    
                    component.set("v.formLabel", "Click Here");
                    component.set("v.formURL", storeResponse.formLink);
                    component.set("v.urlField", storeResponse.urlEmail);
                    component.set("v.directionsField", storeResponse.directions);
                    component.set("v.slaDay", storeResponse.slaDay);
                    component.set("v.routingOptions", storeResponse.routingOptions);
                    component.set("v.departmentDesc", storeResponse.departmentDesc);
                    component.set("v.specialInstructionsID", storeResponse.sfId);
                    component.set("v.dosRequired", storeResponse.dosRequired);
                    component.set("v.queueName", storeResponse.queueName);
                    component.set("v.isCDX", storeResponse.isCDX);
                    component.set("v.MemberIDRequiredIndicator", storeResponse.MemberIDRequiredIndicator);
                    var FlowType = component.get("v.FlowType");
                    
                    var memberData = component.get("v.memberData");
                    if(storeResponse.MemberIDRequiredIndicator == 'Y' && component.get("v.isStandardFlag") &&
                       (memberData == '' || memberData == undefined || memberData == null)){
                        var toastMessage = component.get("v.stopPeocessingError");
                        this.displayMessage(component,event,toastMessage);
                    }
                    
                    var valOnRoutedAppl = storeResponse.valOnRoutedAppl;
                    valOnRoutedAppl = (valOnRoutedAppl != null && valOnRoutedAppl != undefined) ? valOnRoutedAppl : '';               
                    var routingApplDescVal = storeResponse.routingApplDesc;
                    if(valOnRoutedAppl != '' && routingApplDescVal != '') {
                        component.set("v.isRefIdReq", true);  
                    } else {
                        component.set("v.isRefIdReq", false);
                    }
                    component.set("v.valOnRoutedAppl", valOnRoutedAppl);                    
                }
                var spinner2 = component.find("dropdown-spinner");
                $A.util.removeClass(spinner2, "slds-show");
                $A.util.addClass(spinner2, "slds-hide");
                component.set("v.showSpinner", false);
            }
        });
        $A.enqueueAction(action);
    },
    
    displayMessage: function(component,event,toastMessage){
        var toastType = "Error"; 
        
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type":toastType,
            "message": toastMessage
        });
        toastEvent.fire();
    },
    
    clearInfoFields: function(component,event){
        component.set("v.formLabel", "");
        component.set("v.formURL", "");
        component.set("v.urlField", "");
        component.set("v.directionsField", "");
        component.set("v.slaDay", "");
        component.set("v.routingOptions", "");
        component.set("v.departmentDesc", "");
        component.set("v.subjectField", "");
        component.set("v.referenceID", "");
        component.set("v.rootCauseDetailsList","");
        component.set("v.isRootCauseTable",false);
        component.set("v.specialInstructionsID", "");
        var dosList = [{
            dateOfServiceStart: '',
            dateOfServiceEnd: ''
        }];
        component.set('v.dateOfServiceList', dosList);
        component.set('v.dosRequired', false);
        //component.set("v.descriptionField", "");  //DE380563:Commented Out
        /*component.set("v.oneAndDoneCheckbox",false);
		var oneNDone = component.find("oneAndDone");
		oneNDone.set("v.checked", false);*/
        component.set("v.eventType", "Standard");
        component.set("v.queueName", "");
       
       
        
    },
    saveCase: function(component,event){
        console.log('SAVECASE1: ');
        if(component.get("v.updateCaseBool") == true){
			let submitButton = component.find("updateButton");
			submitButton.set("v.disabled", true);
        } else {
	        let submitButton = component.find("submitButton");
	        submitButton.set("v.disabled", true);
        }
        var spinner = component.find("dropdown-spinner");
        $A.util.removeClass(spinner, "slds-hide");
        $A.util.addClass(spinner, "slds-show");
        var businessUnit = component.get("v.businessUnitSelected");
        var sendBusinessUnit = businessUnit;
        var caseId = '';
        var interaction = component.get("v.interactionRec");
                
        var parentCaseRecData = component.get("v.parentCaseRec");
        var parentCaseId = component.get("v.parentCaseRec.Id");
        parentCaseId = (parentCaseId != undefined && parentCaseId != null) ? parentCaseId : '';
        var groupName;
        var groupId;
        var groupStartDate;
        var situsState;
        var groupFundingArrangement;
        var groupPlatformType;
        var groupLineOfBusiness;
        var groupRegion;
        var groupSalesOffice;
        var groupPlanMajor;
        var groupPlanMinor;
        var groupPolicy;        
        var groupPolicyRenewalYear;
        var memberId;
        var otherAdminType;
        var groupSolarisId;
        var groupSourceCode; //jangi
        
        if(parentCaseId != '') {
            
            groupName = component.get("v.parentCaseRec.Group_Name__c");
            groupName = (groupName != null && groupName != undefined && groupName != '') ? groupName : 'General Inquiry';
            groupId = component.get("v.parentCaseRec.Group_ID__c");
            groupId = (groupId != null && groupId != undefined) ? groupId : '';
            groupStartDate = component.get("v.parentCaseRec.Policy_Year__c");
            groupStartDate = (groupStartDate != null && groupStartDate != undefined) ? groupStartDate : '';
            situsState = component.get("v.parentCaseRec.Situs__c");
            situsState = (situsState != null && situsState != undefined && situsState != '') ? situsState : 'XX';
            groupFundingArrangement = component.get("v.parentCaseRec.Funding_Type__c");
            groupFundingArrangement = (groupFundingArrangement != null && groupFundingArrangement != undefined && groupFundingArrangement != '') ? groupFundingArrangement : 'Multiple/Undefined';        
            groupPlatformType = component.get("v.parentCaseRec.Platform__c");
            groupPlatformType = (groupPlatformType != null && groupPlatformType != undefined && groupPlatformType != '') ? groupPlatformType : 'Prime';
            groupLineOfBusiness = component.get("v.parentCaseRec.Line_of_Business__c");
            groupLineOfBusiness = (groupLineOfBusiness != null && groupLineOfBusiness != undefined && groupLineOfBusiness != '') ? groupLineOfBusiness : 'Multiple/Undefined';
            groupRegion = component.get("v.parentCaseRec.Region__c");
            groupRegion = (groupRegion != null && groupRegion != undefined && groupRegion != '') ? groupRegion : 'XX';
            groupSalesOffice = component.get("v.parentCaseRec.Sales_Office__c");
            groupSalesOffice = (groupSalesOffice != null && groupSalesOffice != undefined && groupSalesOffice != '') ? groupSalesOffice : 'XX';
            groupPlanMajor = component.get("v.parentCaseRec.Health_Plan_Major__c");
            groupPlanMajor = (groupPlanMajor != null && groupPlanMajor != undefined && groupPlanMajor != '') ? groupPlanMajor : 'XX';
            groupPlanMinor = component.get("v.parentCaseRec.Health_Plan_Minor__c");
            groupPlanMinor = (groupPlanMinor != null && groupPlanMinor != undefined && groupPlanMinor != '') ? groupPlanMinor : 'XX';                                    
            otherAdminType = component.get("v.parentCaseRec.Originator_Relationship__c");
            otherAdminType = (otherAdminType != undefined && otherAdminType != null) ? otherAdminType : '';
            groupPolicy = component.get("v.parentCaseRec.Policy__c");
            groupPolicy = (groupPolicy != null && groupPolicy != undefined) ? groupPolicy : '';
            groupPolicyRenewalYear = component.get("v.parentCaseRec.Policy_Renewal_Year__c");
            groupPolicyRenewalYear = (groupPolicyRenewalYear != null && groupPolicyRenewalYear != undefined) ? groupPolicyRenewalYear : '';
            groupSolarisId = (component.get("v.parentCaseRec.Group_Solaris_ID__c") != null && component.get("v.parentCaseRec.Group_Solaris_ID__c") != undefined)?component.get("v.parentCaseRec.Group_Solaris_ID__c"):'';
            groupSourceCode = (component.get("v.parentCaseRec.SourceCode__c") != null)?component.get("v.parentCaseRec.SourceCode__c"):''; //jangi
            
        } else {
            
            groupName = component.get("v.groupData.groupName");
            groupName = (groupName != null && groupName != undefined && groupName != '') ? groupName : 'General Inquiry';
            groupId = component.get("v.groupData.groupId");
            groupId = (groupId != null && groupId != undefined) ? groupId : '';
            groupStartDate = component.get("v.groupData.policyNumber");
            groupStartDate = (groupStartDate != null && groupStartDate != undefined) ? groupStartDate : '';
            situsState = component.get("v.groupData.situsState");
            situsState = (situsState != null && situsState != undefined && situsState != '') ? situsState : 'XX';
            groupFundingArrangement = component.get("v.groupData.fundingType");
            groupFundingArrangement = (groupFundingArrangement != null && groupFundingArrangement != undefined && groupFundingArrangement != '') ? groupFundingArrangement : 'Multiple/Undefined';        
            groupPlatformType = component.get("v.groupData.platform");
            groupPlatformType = (groupPlatformType != null && groupPlatformType != undefined && groupPlatformType != '') ? groupPlatformType : 'Prime';
            groupLineOfBusiness = component.get("v.groupData.lineOfBusiness");
            groupLineOfBusiness = (groupLineOfBusiness != null && groupLineOfBusiness != undefined && groupLineOfBusiness != '') ? groupLineOfBusiness : 'Multiple/Undefined';
            groupRegion = component.get("v.groupData.businessMarketRegion");
            groupRegion = (groupRegion != null && groupRegion != undefined && groupRegion != '') ? groupRegion : 'XX';
            groupSalesOffice = component.get("v.groupData.salesOffice");
            groupSalesOffice = (groupSalesOffice != null && groupSalesOffice != undefined && groupSalesOffice != '') ? groupSalesOffice : 'XX';
            groupPlanMajor = component.get("v.groupData.businessMajorMarket");
            groupPlanMajor = (groupPlanMajor != null && groupPlanMajor != undefined && groupPlanMajor != '') ? groupPlanMajor : 'XX';
            groupPlanMinor = component.get("v.groupData.businessMinorMarket");
            groupPlanMinor = (groupPlanMinor != null && groupPlanMinor != undefined && groupPlanMinor != '') ? groupPlanMinor : 'XX'; 
            memberId = component.get("v.memberData.memberID");
            memberId = (memberId != null && memberId != undefined) ? memberId : ''; 
            otherAdminType = component.get("v.customerAdminData.otherAdminType");
            otherAdminType = (otherAdminType != undefined && otherAdminType != null) ? otherAdminType : '';
            groupPolicy = component.get("v.groupData.policyNumber");
            groupPolicy = (groupPolicy != null && groupPolicy != undefined) ? groupPolicy : '';
            groupPolicyRenewalYear = component.get("v.groupData.renewalEffectiveDate");
            groupPolicyRenewalYear = (groupPolicyRenewalYear != null && groupPolicyRenewalYear != undefined) ? groupPolicyRenewalYear : '';
            groupSolarisId  = (component.get("v.groupData.salesforceInternalId") != null)?component.get("v.groupData.salesforceInternalId"):'';
            groupSourceCode = (component.get("v.groupData.sourceCode") != null)?component.get("v.groupData.sourceCode"):''; //jangi
        }
        
        var slaDay = component.get("v.slaDay");
        slaDay = (slaDay != undefined && slaDay != null) ? slaDay : '';        
        var slaDayVal;
        if(slaDay != '') {
            slaDayVal = parseInt(slaDay);   
        } else {
            slaDayVal = 0;
        }
        //var emailURL = component.get("v.urlField");
        //var emailURL = event.getParam("cdxContactValue");
        var emailURL;
        if(component.get("v.isCDX")){
            emailURL = component.get("v.cdxContactValue");
        }else{
            emailURL = component.get("v.urlField");
        }
        
        emailURL = (emailURL != undefined && emailURL != null) ? emailURL : '';
        
        var dosList = component.get("v.dateOfServiceList");
        var newDosList = '';
        var newdosItem = '';
        if(dosList != null && dosList != '' && dosList != []){
            for(var i = 0; i < dosList.length; i++){
                if(dosList[i].dateOfServiceStart != null && dosList[i].dateOfServiceStart != '' && dosList[i].dateOfServiceEnd != null && dosList[i].dateOfServiceEnd != ''){
                    if(dosList[i].dateOfServiceStart == dosList[i].dateOfServiceEnd){
                        newdosItem = dosList[i].dateOfServiceStart.split("-")[1] + '/' + dosList[i].dateOfServiceStart.split("-")[2] + '/' + dosList[i].dateOfServiceStart.split("-")[0];
                    } else {
                        newdosItem = dosList[i].dateOfServiceStart.split("-")[1] + '/' + dosList[i].dateOfServiceStart.split("-")[2] + '/' + dosList[i].dateOfServiceStart.split("-")[0] + ' - ' + dosList[i].dateOfServiceEnd.split("-")[1] + '/' + dosList[i].dateOfServiceEnd.split("-")[2] + '/' + dosList[i].dateOfServiceEnd.split("-")[0];
                    }
                    if(newDosList != ''){
                        newdosItem = ',' + newdosItem;
                    }
                    newDosList = newDosList + newdosItem;
                }
            }
        }
        var subjectId = '';
        var subjectName = '';
        var subjectGroupId = '';
        var subjectType = '';
        var dosValForChildCase = '';
        var subjectMemberSSN = '';
        var subjectDOB = '';
        var brokerName = '';
        var brokerId = '';
        
        if(parentCaseId != '') {
           
            subjectId = component.get("v.parentCaseRec.ID__c");
            subjectId = (subjectId != null && subjectId != undefined) ? subjectId : '';
            subjectName = component.get("v.parentCaseRec.Subject_Name__c");
            subjectName = (subjectName != null && subjectName != undefined) ? subjectName : '';
            subjectGroupId = component.get("v.parentCaseRec.Subject_Group_ID__c");
            subjectGroupId = (subjectGroupId != null && subjectGroupId != undefined) ? subjectGroupId : '';
            subjectType = component.get("v.parentCaseRec.Subject_Type__c");
            subjectType = (subjectType != null && subjectType != undefined) ? subjectType : '';
            dosValForChildCase = component.get("v.parentCaseRec.Date_of_Service__c");
            dosValForChildCase = (dosValForChildCase != null && dosValForChildCase != undefined) ? dosValForChildCase : '';
            if(dosValForChildCase.includes('\n')){
                dosValForChildCase = dosValForChildCase.split('\n').join("");
            }
            subjectMemberSSN = component.get("v.parentCaseRec.Member_SSN__c");
            subjectMemberSSN = (subjectMemberSSN != null && subjectMemberSSN != undefined) ? subjectMemberSSN : '';
            subjectDOB = component.get("v.parentCaseRec.DOB__c");
            subjectDOB = (subjectDOB != null && subjectDOB != undefined) ? subjectDOB : '';
            brokerName = component.get("v.parentCaseRec.Broker_Name__c");
            brokerName = (brokerName != undefined && brokerName != null) ? brokerName : '';
            brokerId = component.get("v.parentCaseRec.Broker_ID__c");
            brokerId = (brokerId != undefined && brokerId != null) ? brokerId : '';
            
        } else {
            
            subjectType = component.get("v.FlowType");
            
            if(memberId != '') {
                subjectId = memberId;
            } 
            subjectGroupId = groupId;
            var producerData = component.get("v.producerData");
            var groupData = component.get("v.groupData");
            var memberData = component.get("v.memberData");
                   
            if(producerData.producerType == 'I'){
            	brokerName = producerData.producerIndividualName.firstName + ' ' + producerData.producerIndividualName.lastName;
        	} else {
        		brokerName = producerData.producerCompanyName;
        	}
            if(producerData != null && producerData != undefined && producerData != ""){
            	if(producerData.producerType == 'I'){
                	brokerName = producerData.producerIndividualName.firstName + ' ' + producerData.producerIndividualName.lastName;
            	} else {
            		brokerName = producerData.producerCompanyName;
            	}
            	brokerId = producerData.producerID;
                brokerId = (brokerId != undefined && brokerId != null) ? brokerId : '';                            	 
            	subjectName = brokerName;
            	subjectId = producerData.producerID;
            }
            brokerName = (brokerName != undefined && brokerName != null) ? brokerName : '';
            if(groupData != null && groupData!= undefined && groupData != ""){
                subjectName = component.get("v.groupData.groupName");
                subjectName = (subjectName != undefined && subjectName != null) ? subjectName : '';
                subjectId = groupId;
            }
            if(memberData != null && memberData!= undefined && memberData != ""){
                var lastname = component.get("v.memberData.lastName");
                var firstname = component.get("v.memberData.firstName");
                subjectName = firstname+' '+lastname;
                subjectId = component.get("v.memberData.memberID");                
                subjectDOB = component.get("v.memberData.DOB");
            	subjectDOB = (subjectDOB != null && subjectDOB != undefined) ? subjectDOB : '';  
            	//subjectMemberSSN = component.get("v.memberData.SSN");
                //situsState = component.get("v.memberData.");
                //situsState = (situsState != null && situsState != undefined) ? situsState : '';               
                if(component.get("v.memberSubjCardData") != undefined && component.get("v.memberSubjCardData") != null && component.get("v.memberSubjCardData") != '') {  
                    //console.log('SSN Stuff1: ' );
                    subjectMemberSSN = component.get("v.memberSubjCardData.SSN");
                    subjectMemberSSN = (subjectMemberSSN != null && subjectMemberSSN != undefined) ? subjectMemberSSN : '';
                } else if(memberData != null && memberData != undefined && memberData.SSN != null){
                    //console.log('SSN Stuff2: ' );
                    subjectMemberSSN = (memberData.SSN != null)?memberData.SSN:'';
                }
            }
            
        }        
        var updateCaseId = '';
        if(component.get("v.updateCaseBool") == true){
            var caseInfo = component.get("v.updateCaseInfo");
            console.log('PASS CASE INFO: ' + JSON.stringify(caseInfo));
            if(caseInfo.Id != null && caseInfo.Id != undefined && caseInfo.Id != ''){
                updateCaseId = caseInfo.Id;
            }
        }
        /* Hard coded values for reporting purposes, if the fields are blank, reports are broken
           rather than slowing down the call and having the user look up a random group and give wrong info
           we just have a value that shows that there is no wrong info, but we don't leave it blank
           US2595142 - TECH: Hardcode Values on Broker Only Cases 
        if(subjectType == 'Producer'){
            groupName = 'General Inquiry';
            groupPlatformType = 'Prime';
            groupPlanMajor = 'XX';
            groupPlanMinor = 'XX';
            groupLineOfBusiness = 'Multiple/Undefined';
            groupRegion = 'XX';
            groupFundingArrangement = 'Multiple/Undefined';
            situsState = 'XX';
            groupSalesOffice = 'XX';
        }*/
        console.log('UPDATE CASE ID: ' + updateCaseId);
        var department = component.get("v.departmentDesc");
        department = (department != undefined && department != null) ? component.get("v.departmentDesc").split('\"').join('\\"')  : '';
        var strWrapper = '{"providerNotFound":false,"specialInstructions":"' + component.get("v.specialInstructionsID") + '",'
        + '"specialInstructionsBusinessUnit":"' + sendBusinessUnit.split('\"').join('\\"') + '",'
        + '"issueCategoryDesc":"' + component.get("v.topicSelected").split('\"').join('\\"') + '",'
        + '"taskCategoryTypeDesc":"' + component.get("v.typeSelected").split('\"').join('\\"') + '",'
        + '"taskCategorySubtypeDesc":"' + component.get("v.subtypeSelected").split('\"').join('\\"') + '",'
        + '"specialInstructionsSubject":"' + component.get("v.subjectField").split('\"').join('\\"') + '",'
        + '"specialInstructionsDescription":"' + '' + '",'
        + '"specialInstructionsReferenceID":"' + component.get("v.referenceID") + '",'
        + '"specialInstructionsDateOfService":"' + newDosList + '",'
        + '"specialInstructionsQueue":"' + component.get("v.queueName") + '",'
        + '"department":"' + department + '",'
        //+ '"groupName":"' + groupName.split('\"').join('\\"') + '",'
        + '"groupId":"' + groupId + '",'
        + '"SubjectSitus":"' + situsState.split('\"').join('\\"') + '",'
        + '"groupFundingType":"' + component.get("v.fundingTypeSelected") + '",'
        + '"groupPlatform":"' + groupPlatformType + '",'
        + '"groupLineOfBusiness":"' + groupLineOfBusiness + '",'
        + '"groupRegion":"' + groupRegion + '",'
        + '"groupSalesOffice":"' + groupSalesOffice + '",'
        + '"groupHelathPlanMajor":"' + groupPlanMajor + '",'
        + '"groupHelathPlanMinor":"' + groupPlanMinor + '",'
        + '"groupPolicyRenewalYear":"' + groupPolicyRenewalYear + '",'
        + '"groupSolarisId":"' + groupSolarisId + '",' 
        + '"groupSourceCode":"' + groupSourceCode + '",' //jangi
        + '"groupPolicy":"' + groupPolicy + '",'
        + '"brokerName":"' + brokerName + '",'
        + '"brokerId":"' + brokerId + '",'
        + '"updateCaseId":"' + updateCaseId + '",'
        + '"SubjectId":"' + subjectId + '",'
        //+ '"SubjectName":"'+subjectName.split('\"').join('\\"')+'",'
        + '"SubjectGroupId":"' + subjectGroupId + '",'        
        + '"SubjectDOB":"' + subjectDOB + '",'
        + '"SubjectMemberSSN":"' + subjectMemberSSN + '",'
        + '"slaDay":"' + slaDayVal + '",'
        //+ '"emailURL":"' + emailURL.split('\"').join('\\"') + '",'
        + '"otherAdminType":"' + otherAdminType + '",'
        + '"parentCaseId":"' + parentCaseId + '",'
        + '"dosVal":"' + dosValForChildCase + '",'
        + '"Interaction":"' + interaction.Id + '",'
        + '"memberRelationship":"' + component.get("v.memberRelationship") + '",'
        + '"isCloned":' + component.get("v.isCloneCase") + ','
        + '"AddInfoTopic":"",'
        + '"AddInfoOrginType":"",'
        + '"AddInfoOrginSubType":"",'
        + '"ttsType":"",'
        + '"ttsSubType":"",'
        + '"uhgRestriction":"' + component.get('v.uhgAccess') + '",'
        + '"noProviderToSearch":true,"isOtherSearch":false,"mnf":"","providerId":"","TaxId":"","noMemberToSearch":false,"OriginatorName":"","OriginatorType":"Member","OriginatorRelationship":"","OriginatorContactName":"John Smith","OriginatorPhone":"","OriginatorEmail":"--","SubjectType":"Member","memberContactId":"","Status":"Open","PolicyCount":2,"CaseCreationFrom":"Member_Snapshot_Policies","AutoDoc":"","AutoDocCaseItems":""}';
        console.log('SAVECASE2: ' + strWrapper);
        console.log('ContactIdContactId: ' + component.get("v.ContactId"));
        //console.log('oneAndDoneCheckbox: ' + component.get("v.oneAndDoneCheckbox"));
        
        var action = component.get("c.saveTTSCase");
        action.setParams({
            'strRecord': strWrapper,
            'isProvider': false,
            'flowType': subjectType,
            'contactID':component.get("v.ContactId"),
            'eventType':component.get("v.eventType"),
            'specialInstructionsDescription':component.get("v.descriptionField"),
            'emailURL':emailURL.split('\"').join('\\"'),
            'groupName':groupName,
            'subjectName':subjectName         
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('SAVECASE3: ' + state);
            if (state === "SUCCESS") {
                console.log('SAVECASE4: ');
                // component.set('v.IsCaseSaved', false);
                var response = response.getReturnValue();
                console.log('SAVECASE5: ' + response);
                caseId = response;
                //SUBMIT ROOT CAUSES HERE
                
                var rootListJSON = JSON.stringify(component.get("v.rootCauseDetailsList"));
                console.log("ROOT CAUSE JSON: " + rootListJSON);
                var action = component.get("c.submitRootCauseAnalysis");
                action.setParams({
                    'rootDetailsJson': rootListJSON,
                    'caseId': response
                });
                action.setCallback(this, function(response) {
                    var state = response.getState();
                    console.log('SAVECASE3: ' + state);
                    if (state === "SUCCESS") {
                        //create case code here
                        //alert(response);
                        /* var navEvt = $A.get("e.force:navigateToSObject");
		                navEvt.setParams({
		                  "recordId": response,
		                  "slideDevName": "Detail"
		                });
		                navEvt.fire();*/
                        //US1851066	Pilot - Case - Save Button & Case Creation Validations - 15/10/2019 - Sarma
                        //let cmpEvent = component.getEvent("closeModalBox"); 
                        //cmpEvent.fire();
                        
                        //DE273498 - Closing tts modal box - 23/10/2019 - Sarma
                        //component.set("v.isModalOpen", false); 
                        
                        // US2037798	Pilot - Create Additional  TTS for View Member Eligibility - 23/10/2019 - Sarma
                        //component.set('v.isButtonDisabled',false);
                        console.log('SAVECASE6: ');
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Success!",
                            "message": "The case record has been created successfully.",
                            "type": "success"
                        });
                        console.log('SAVECASE7: ');
                        //US2038277 - Autodoc Integration - Sanka
                        localStorage.removeItem("rowCheckHold");
                        console.log('SAVECASE8: ');
                        //US1921739
                        if(!$A.util.isEmpty(response)){
                            toastEvent.fire();
                        }
                        console.log('SAVECASE9: ');
                        var workspaceAPI = component.find("workspace");
                        console.log('SAVECASE10: ' + JSON.stringify(workspaceAPI));
						 //Change Uncomment Line:DE404606
                        workspaceAPI.openTab({
		                    url: '#/sObject/'+caseId+'/view',
		                    focus: true
		                });
                        if(component.get("v.updateCaseBool") == true){
                        	workspaceAPI.getTabInfo().then(function (tabInfo) {
	                        	var focusedTabId = tabInfo.tabId;
	                        	workspaceAPI.openTab({
                                    url: '#/sObject/'+caseId+'/view',
                                    focus: true
                                }); 
	                        	if(tabInfo.isSubtab){
	                        		workspaceAPI.closeTab({tabId:tabInfo.parentTabId});
	                        	} else {
	                        		workspaceAPI.closeTab({tabId:focusedTabId});
	                        	}
	                        	
                        	});
                        } else {
	                        var isSubtab;
	                        workspaceAPI.getTabInfo().then(function (tabInfo) {
	                        	var focusedTabId = tabInfo.tabId;
		                        workspaceAPI.getFocusedTabInfo().then(function(response) {
		                            workspaceAPI.isSubtab({
		                                tabId: response.tabId
		                            }).then(function(response) {
		                                if (response) {
		                                    console.log("This tab is a subtab.");
		                                    isSubtab = true;
		                                }
		                                else {
		                                    console.log("This tab is not a subtab.");
		                                    isSubtab = false;
		                                }
		                                var focusedSubtabID = response.tabId;
		                                if(parentCaseId != '') {
		                                    workspaceAPI.openTab({
		                                        parentTabId: focusedTabId,
		                                        url: '#/sObject/'+caseId+'/view',
		                                        focus: true
		                                    });                                
		                                } else {
		                                	console.log('ENTERED IF: ' + isSubtab);
		                            		if(isSubtab){
		    		                            workspaceAPI.openSubtab({
		    		                                parentTabId: focusedTabId,
		    		                                url: '#/sObject/'+caseId+'/view',
		    		                                focus: true
		    		                            });
		                            		} else {
		                            			workspaceAPI.openTab({
		    	                                    url: '#/sObject/'+caseId+'/view',
		    	                                    focus: true
		    	                                }); 
		                            		}
		                                }
		                                workspaceAPI.closeTab({tabId:focusedSubtabID});
		                            });
		                        });
	                        });
                        }
                        /*
                        workspaceAPI.getTabInfo().then(function (tabInfo) {
                            var focusedSubtabID = '';
                            workspaceAPI.getFocusedTabInfo().then(function(subtabInfo){
                            	console.log('HELPINGA: ' + subtabInfo.tabId);
                                console.log('HELPINGA: ' + JSON.stringify(subtabInfo.tabId));
                            	focusedSubtabID = subtabInfo.tabId;
                            	console.log('HELPINGB: ' + focusedSubtabID);
                                console.log('HELPINGB: ' + JSON.stringify(focusedSubtabID));
                            });
                            console.log('HELPING1: ' + tabInfo);
                            console.log('HELPING2: ' + JSON.stringify(tabInfo));
                            console.log('HELPING3: ' + focusedSubtabID);
                            console.log('HELPING4: ' + JSON.stringify(focusedSubtabID));
                            var focusedTabId = tabInfo.tabId;
                            if(parentCaseId != '') {
                                workspaceAPI.openTab({
                                    parentTabId: focusedTabId,
                                    url: '#/sObject/'+caseId+'/view',
                                    focus: true
                                });                                
                            } else {
                        		console.log('ENTERED IF: ' + isSubtab);
                        		if(isSubtab){
		                            workspaceAPI.openSubtab({
		                                parentTabId: focusedTabId,
		                                url: '#/sObject/'+caseId+'/view',
		                                focus: true
		                            }).catch(function(error){
		                            	console.log('ERROR! ' + error);
		                            	if(error.includes('Could not open subtab.')){
		                            		console.log('Try Opening Tab: ' + caseId);
		                            		workspaceAPI.openTab({
			                                    url: '#/sObject/'+caseId+'/view',
			                                    focus: true
			                                }); 
		                            	}
		                            }); 
                        		} else {
                        			workspaceAPI.openTab({
	                                    url: '#/sObject/'+caseId+'/view',
	                                    focus: true
	                                }); 
                        		}
                            	
                            }           
                            console.log('HELPINGC: ' + focusedSubtabID);
                            console.log('HELPINGC: ' + JSON.stringify(focusedSubtabID));
                            workspaceAPI.closeTab({tabId:focusedSubtabID});
                        });*/
                        console.log('SAVECASE11: ');
                    }
                });
                $A.enqueueAction(action);
                
                //END ROOT CAUSES
                
                
            } else if (state === "INCOMPLETE") {
                
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
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
                if(component.get("v.updateCaseBool") == true){
        			let submitButton = component.find("updateButton");
        			submitButton.set("v.disabled", false);
                } else {
        	        let submitButton = component.find("submitButton");
        	        submitButton.set("v.disabled", false);
                }
            }
        });
        $A.enqueueAction(action);
    },
    checkButtonsBoolean: function(component, event){
        var businessUnit = component.get("v.businessUnitSelected");
        var fundingType = component.get("v.fundingTypeSelected");
        //alert(fundingType);
        
        var topic = component.get("v.topicSelected");
        var type = component.get("v.typeSelected");
        var subtype = component.get("v.subtypeSelected");
        var subject = component.get("v.subjectField");
        var description = component.get("v.descriptionField");
        var referenceId = component.get("v.referenceID");
        referenceId = (referenceId != undefined && referenceId != null) ? referenceId : '';
        var valOnRoutedAppl = component.get("v.valOnRoutedAppl");
        valOnRoutedAppl = (valOnRoutedAppl != null && valOnRoutedAppl != undefined) ? valOnRoutedAppl : '';   
        var isRefIdReqVal = component.get("v.isRefIdReq");
        var isRefIdValidation = true;
        if(isRefIdReqVal) {
            isRefIdValidation = false; 
        }     
        var dosReq = component.get("v.dosRequired");
        //let rootButton = component.find("rootCauseButton");
        let rootNAButton = component.find("rootCauseNAButton");
        
        /* US2389710 -> (Special Instructions Topic Page - Reference ID - Make it a Required Field) START - Yogitha */
        
        if(referenceId != '' && valOnRoutedAppl != '' && isRefIdReqVal) {
            
            var valOnRouApplArray = valOnRoutedAppl.match(/[a-z]+|[^a-z]+/gi);
            var noOfCharacters = '';
            var numOralNum = '';
            if(valOnRouApplArray != null) {
                if(valOnRouApplArray.length == 1) { 
                    numOralNum = valOnRouApplArray[0].trim();
                } else {
                    noOfCharacters = valOnRouApplArray[0].trim();
                    numOralNum = valOnRouApplArray[1].trim();
                }
            } 
            
            var regExpPat = /^(?=.*[a-zA-Z])(?=.*[0-9])/;
            
            if(numOralNum == 'alphanumeric') {
                
                if(regExpPat.test(referenceId)) {
                    if(noOfCharacters == '') {
                        isRefIdValidation = true;
                        var referenceIdDiv = component.find("referenceId");
                        $A.util.addClass(referenceIdDiv, "slds-hide");
                    } else {
                        if(referenceId.toString().length == noOfCharacters) {
                            isRefIdValidation = true;
                            var referenceIdDiv = component.find("referenceId");
                            $A.util.addClass(referenceIdDiv, "slds-hide");
                        } else {
                            isRefIdValidation = false;
                            var referenceIdDiv = component.find("referenceId");
                            $A.util.removeClass(referenceIdDiv, "slds-hide"); 
                            component.set("v.refIdValidationMsg", "Reference Id should be exactly "+valOnRoutedAppl+" characters in length");
                        }
                    }       
                } else {
                    
                    isRefIdValidation = false;
                    var referenceIdDiv = component.find("referenceId");
                    $A.util.removeClass(referenceIdDiv, "slds-hide");
                    component.set("v.refIdValidationMsg", "Reference Id should be "+valOnRoutedAppl+" characters");
                }
                
            } else if(numOralNum == 'numeric') {
                
                if(isNaN(referenceId)) {
                    
                    isRefIdValidation = false;
                    var referenceIdDiv = component.find("referenceId");
                    $A.util.removeClass(referenceIdDiv, "slds-hide"); 
                    component.set("v.refIdValidationMsg", "Reference Id should be "+valOnRoutedAppl+" values");
                    
                } else {
                    
                    if(noOfCharacters == '') {
                        isRefIdValidation = true;
                        var referenceIdDiv = component.find("referenceId");
                        $A.util.addClass(referenceIdDiv, "slds-hide");
                    } else {
                        if(referenceId.toString().length == noOfCharacters) {
                            isRefIdValidation = true;
                            var referenceIdDiv = component.find("referenceId");
                            $A.util.addClass(referenceIdDiv, "slds-hide");
                        } else {
                            isRefIdValidation = false;
                            var referenceIdDiv = component.find("referenceId");
                            $A.util.removeClass(referenceIdDiv, "slds-hide"); 
                            component.set("v.refIdValidationMsg", "Reference Id should be exactly "+valOnRoutedAppl+" characters in length");
                        }
                    }                    
                }
            }            	                            
            
        } else if(referenceId == '' && valOnRoutedAppl == '' && isRefIdReqVal == false) {
            isRefIdValidation = true;
            var referenceIdDiv = component.find("referenceId");
            $A.util.addClass(referenceIdDiv, "slds-hide");
        }      
        
        /* US2389710 -> (Special Instructions Topic Page - Reference ID - Make it a Required Field) END - Yogitha */
        
        var dosListIsEmpty = true;
        if(dosReq == true){
            var dosList = component.get("v.dateOfServiceList");
            for(var i = 0; i < dosList.length; i++){
                if(dosList[i].dateOfServiceStart != null && dosList[i].dateOfServiceStart != '' && dosList[i].dateOfServiceEnd != null && dosList[i].dateOfServiceEnd != ''){
                    dosListIsEmpty = false;
                    break;
                }
            }
        }
        
        if(businessUnit != "None" && topic != "None" && type != "None" && subtype != "None"){
            if(subject != null && subject.length <= 90 && subject != '' && description != null && description != '' && isRefIdValidation && (dosReq == false || (dosReq == true && dosListIsEmpty == false))){
                //Jangi
                if(component.get("v.isCDX")){
                    if((subject.trim() != '' && description.trim() != '' && component.get("v.selectedCDXRow") && isRefIdValidation)){
                        for(var i=1; i<4; i++) {
                            var rootButton = component.find("rootCauseButton"+i);
                            if(rootButton != undefined && rootButton != null) {
                                rootButton.set("v.disabled", false);
                            }                        
                        }
                        if(rootNAButton != undefined && rootNAButton != null) {
                            rootNAButton.set("v.disabled", false);
                        }
                        //add code to check if at least one root cause was submitted
                        if(component.get("v.rootCauseDetailsList") != null && component.get("v.rootCauseDetailsList") != ''){
                        	if(component.get("v.updateCaseBool") == true){
                    			let submitButton = component.find("updateButton");
                    			submitButton.set("v.disabled", false);
                            } else {
                    	        let submitButton = component.find("submitButton");
                    	        submitButton.set("v.disabled", false);
                            }
                        }
                    } //Jangi Ends
                }else if((component.get("v.displayFTLabel")==false && subject.trim() != '' && description.trim() != '' && isRefIdValidation) ||
                    (fundingType != 'None' && component.get("v.displayFTLabel")==true && subject.trim() != '' && description.trim() != '' && isRefIdValidation)){	                    
                    for(var i=1; i<4; i++) { 
                        var rootButton = component.find("rootCauseButton"+i);
                        if(rootButton != undefined && rootButton != null) {
                           rootButton.set("v.disabled", false);
                        }                        
                    }
                    if(rootNAButton != undefined && rootNAButton != null) {
                        rootNAButton.set("v.disabled", false);
                    }
                    //add code to check if at least one root cause was submitted
                    if(component.get("v.rootCauseDetailsList") != null && component.get("v.rootCauseDetailsList") != ''){
                    	if(component.get("v.updateCaseBool") == true){
                			let submitButton = component.find("updateButton");
                			submitButton.set("v.disabled", false);
                        } else {
                	        let submitButton = component.find("submitButton");
                	        submitButton.set("v.disabled", false);
                        }
                    }
                } else {
                    for(var i=1; i<4; i++) {
                        var rootButton = component.find("rootCauseButton"+i);
                        if(rootButton != undefined && rootButton != null) {
                           rootButton.set("v.disabled", true); 
                        }                        
                    }
                    if(rootNAButton != undefined && rootNAButton != null) {
                        rootNAButton.set("v.disabled", true);
                    }
                    if(component.get("v.updateCaseBool") == true){
            			let submitButton = component.find("updateButton");
            			submitButton.set("v.disabled", true);
                    } else {
            	        let submitButton = component.find("submitButton");
            	        submitButton.set("v.disabled", true);
                    }
                }
            } else {
                for(var i=1; i<4; i++) {
                    var rootButton = component.find("rootCauseButton"+i);
                    if(rootButton != undefined && rootButton != null) {
                        rootButton.set("v.disabled", true); 
                    }                        
                } 
                if(rootNAButton != undefined && rootNAButton != null) {
                    rootNAButton.set("v.disabled", true);
                }
                if(component.get("v.updateCaseBool") == true){
        			let submitButton = component.find("updateButton");
        			submitButton.set("v.disabled", true);
                } else {
        	        let submitButton = component.find("submitButton");
        	        submitButton.set("v.disabled", true);
                }
            }
        } else {
            for(var i=1; i<4; i++) {
                var rootButton = component.find("rootCauseButton"+i);
                if(rootButton != undefined && rootButton != null) {
                    rootButton.set("v.disabled", true); 
                }                        
            } 
            if(rootNAButton != undefined && rootNAButton != null) {
                rootNAButton.set("v.disabled", true);
            }
            if(component.get("v.updateCaseBool") == true){
    			let submitButton = component.find("updateButton");
    			submitButton.set("v.disabled", true);
            } else {
    	        let submitButton = component.find("submitButton");
    	        submitButton.set("v.disabled", true);
            }
        }
    },
    filterBusinessUnits: function(component, event, helper){
        var typeText = component.get('v.businessUnitText');
        var dataList = component.get("v.businessUnitOptions");
        if (typeText == undefined || typeText == '') {
            component.set('v.businessUnitFilter', dataList);
            component.set('v.displayBU', false);
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
            component.set('v.businessUnitFilter', dataListFilter);
            component.set('v.displayBU', true);
        } else {
            component.set('v.businessUnitFilter', dataList);
        }
    },
    filterFundingTypes: function(component, event, helper){
        var typeText = component.get('v.fundingTypeText');
        var dataList = component.get("v.fundingTypeOptions");
        if (typeText == undefined || typeText == '') {
            component.set('v.fundingTypeFilter', dataList);
            component.set('v.displayFT', false);
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
            component.set('v.fundingTypeFilter', dataListFilter);
            component.set('v.displayFT', true);
        } else {
            component.set('v.fundingTypeFilter', dataList);
        }
    },
    resetFields: function(component,event,helper){
        component.set("v.displayBU", false);
        component.set("v.displayFT", false);
        component.set("v.displayTopic", false);
        component.set("v.displayType", false);
        component.set("v.displaySubtype", false);
        component.set("v.isCDXClicked",false); //Jangi
        component.set("v.isCDX",false); //Jangi
        component.set("v.selectedCDXRow",false);
        var dropdownOptions = [];
        dropdownOptions.push({
            label: "None",
            value: "None"
        });
        var getSearchType = component.get("v.instructionSearchType");
        if(getSearchType == "Topic"){
            component.set('v.topicOptions', dropdownOptions);
            component.set('v.topicSelected', "None");
            component.set('v.topicText', "None");
            component.set('v.typeOptions', dropdownOptions);
            component.set('v.typeSelected', "None");
            component.set('v.typeText', "None");
            component.set('v.subtypeOptions', dropdownOptions);
            component.set('v.subtypeSelected', "None");
            component.set('v.subtypeText', "None");
        } else if(getSearchType == "Type"){
            component.set('v.typeOptions', dropdownOptions);
            component.set('v.typeSelected', "None");
            component.set('v.typeText', "None");
            component.set('v.subtypeOptions', dropdownOptions);
            component.set('v.subtypeSelected', "None");
            component.set('v.subtypeText', "None");
        } else if(getSearchType == "Subtype"){
            component.set('v.subtypeOptions', dropdownOptions);
            component.set('v.subtypeSelected', "None");
            component.set('v.subtypeText', "None");
        }
    },
    filterTopics: function(component, event, helper){
        var typeText = component.get('v.topicText');
        var dataList = component.get("v.topicOptions");
        if (typeText == undefined || typeText == '') {
            component.set('v.topicFilter', dataList);
            component.set('v.displayTopic', false);
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
            component.set('v.topicFilter', dataListFilter);
            component.set('v.displayTopic', true);
        } else {
            component.set('v.topicFilter', dataList);
        }
    },
    filterTypes: function(component, event, helper){
        var typeText = component.get('v.typeText');
        var dataList = component.get("v.typeOptions");
        if (typeText == undefined || typeText == '') {
            component.set('v.typeFilter', dataList);
            component.set('v.displayType', false);
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
            component.set('v.typeFilter', dataListFilter);
            component.set('v.displayType', true);
        } else {
            component.set('v.typeFilter', dataList);
        }
    },
    filterSubtypes: function(component, event, helper){
        var typeText = component.get('v.subtypeText');
        var dataList = component.get("v.subtypeOptions");
        if (typeText == undefined || typeText == '') {
            component.set('v.subtypeFilter', dataList);
            component.set('v.displaysubtype', false);
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
            component.set('v.subtypeFilter', dataListFilter);
            component.set('v.displaySubtype', true);
        } else {
            component.set('v.subtypeFilter', dataList);
        }
    },
    closeAllDropdownsHelper:function(component,event,helper){
        component.set("v.displayBU", false);
        component.set("v.displayTopic", false);
        component.set("v.displayType", false);
        component.set("v.displayFT", false);
        component.set("v.displaySubtype", false);
        component.set("v.isRefIdReq", false);
		component.set("v.eventType", "Standard");
        if(component.get("v.businessUnitText") == ""){
            component.set("v.businessUnitText", "None");
        }
        if(component.get("v.topicText") == ""){
            component.set("v.topicText", "None");
        }
        if(component.get("v.typeText") == ""){
            component.set("v.typeText", "None");
        }
        if(component.get("v.subtypeText") == ""){
            component.set("v.subtypeText", "None");
        }
    },
    
    validationsBeforeSubmit : function(component,event,helper) {
        
        var eventTypeVal = component.get("v.eventType");
        var eventTypeCmp = component.find("eventType");
        var eventTypeErrorCmp = component.find("eventTypeError");
        if(eventTypeVal != undefined && eventTypeVal != null && eventTypeVal != '') {
            $A.util.removeClass(eventTypeCmp, "slds-has-error");
            if(eventTypeErrorCmp != undefined && eventTypeErrorCmp != null) {
            	eventTypeErrorCmp.set("v.errors", null);    
            }            
            return true;
        } else {
            $A.util.addClass(eventTypeCmp, "slds-has-error");
            if(eventTypeErrorCmp != undefined && eventTypeErrorCmp != null) {
            	eventTypeErrorCmp.set("v.errors", [{message:"Complete this field"}]);    
            }            
            return false;
        }
    },
    
    updateCase : function(component,event) {
        var spinner = component.find("dropdown-spinner");
        $A.util.removeClass(spinner, "slds-hide");
        
        var interaction = component.get("v.interactionRec");
        
        var caseId = component.get("v.parentCaseRec.Id");
        //var subjectName = component.get("v.parentCaseRec.Subject_Name__c"); //DE387468:Fix:for subject Name
       
        caseId = (caseId != undefined && caseId != null) ? caseId : '';
        
        var slaDay = component.get("v.slaDay");
        slaDay = (slaDay != undefined && slaDay != null) ? slaDay : '';        
        var slaDayVal;
        if(slaDay != '') {
            slaDayVal = parseInt(slaDay);   
        } else {
        	slaDayVal = 0;
        }
        
        var dosList = component.get("v.dateOfServiceList");
        var newDosList = '';
        var newdosItem = '';
        if(dosList != null && dosList != '' && dosList != []){
            for(var i = 0; i < dosList.length; i++){
                if(dosList[i].dateOfServiceStart != null && dosList[i].dateOfServiceStart != '' && dosList[i].dateOfServiceEnd != null && dosList[i].dateOfServiceEnd != ''){
                    if(dosList[i].dateOfServiceStart == dosList[i].dateOfServiceEnd){
                        newdosItem = dosList[i].dateOfServiceStart.split("-")[1] + '/' + dosList[i].dateOfServiceStart.split("-")[2] + '/' + dosList[i].dateOfServiceStart.split("-")[0];
                    } else {
                        newdosItem = dosList[i].dateOfServiceStart.split("-")[1] + '/' + dosList[i].dateOfServiceStart.split("-")[2] + '/' + dosList[i].dateOfServiceStart.split("-")[0] + ' - ' + dosList[i].dateOfServiceEnd.split("-")[1] + '/' + dosList[i].dateOfServiceEnd.split("-")[2] + '/' + dosList[i].dateOfServiceEnd.split("-")[0];
                    }
                    if(newDosList != ''){
                        newdosItem = ',' + newdosItem;
                    }
                    newDosList = newDosList + newdosItem;
                }
            }
        }
        
        var emailURL = component.get("v.urlField");
        emailURL = (emailURL != undefined && emailURL != null) ? emailURL : '';
        
        var strWrapper = '{"specialInstructions":"' + component.get("v.specialInstructionsID") + '",'
        + '"specialInstructionsBusinessUnit":"' + component.get("v.businessUnitSelected") + '",'
        + '"issueCategoryDesc":"' + component.get("v.topicSelected") + '",'
        + '"taskCategoryTypeDesc":"' + component.get("v.typeSelected") + '",'
        + '"taskCategorySubtypeDesc":"' + component.get("v.subtypeSelected") + '",'
        + '"specialInstructionsSubject":"' + component.get("v.subjectField") + '",'
        + '"specialInstructionsReferenceID":"' + component.get("v.referenceID") + '",'
        + '"specialInstructionsDateOfService":"' + newDosList + '",'
        + '"specialInstructionsQueue":"' + component.get("v.queueName") + '",'
        + '"department":"' + component.get("v.departmentDesc") + '",'
        + '"groupFundingType":"' + component.get("v.fundingTypeSelected") + '",'
        + '"slaDay":"' + slaDayVal + '",'
        + '"emailURL":"' + emailURL + '",'
        // + '"SubjectName":"'+subjectName.split('\"').join('\\"')+'",'       //DE387468:Fix:for Subject Name://DE385766
        + '"Interaction":"' + interaction.Id + '"}';
        
        
        var descriptionField = component.get("v.descriptionField");
        console.log('DESCRIPTION SET2: ' + descriptionField);
        var action = component.get("c.updateTTSCase");        
        action.setParams({
            'strWrapperData' : strWrapper,
            'descriptionFieldName' : '',
            'caseId' : descriptionField,
            'realCaseId': caseId
        });
        action.setCallback(this, function(response) {
            
            var state = response.getState();

            if (state === "SUCCESS") {

                var updatedCaseId = response.getReturnValue();
                caseId = response;
                var rootListJSON = JSON.stringify(component.get("v.rootCauseDetailsList"));
                console.log("ROOT CAUSE JSON: " + rootListJSON);
                var action = component.get("c.submitRootCauseAnalysis");
                action.setParams({
                    'rootDetailsJson': rootListJSON,
                    'caseId': updatedCaseId
                });                
                action.setCallback(this, function(response) {
                    var state = response.getState();
                    if (state === "SUCCESS") {                        
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Success!",
                            "message": "The case record has been updated successfully.",
                            "type": "success"
                        });                       
                        if(!$A.util.isEmpty(response)){
                            toastEvent.fire();
                        }
                        var workspaceAPI = component.find("workspace");
                        workspaceAPI.getFocusedTabInfo().then(function(response) {
                            var focusedTabId = response.tabId;
							setTimeout(function(){ $A.get('e.force:refreshView').fire(); }, 1000);
							setTimeout(function(){ $A.get('e.force:refreshView').fire(); }, 1000);
                            workspaceAPI.closeTab({tabId: focusedTabId});
                            //$A.get('e.force:refreshView').fire();                                                        
                        })
                        .catch(function(error) {
                            console.log(error);
                        }); 
                        
                    }
                });
                $A.enqueueAction(action);               
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }                
                var toastType = "Error";
                var toastMessage = "Issue while updating the Case from Standard to One&Done.";
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":toastType,
                    "message": toastMessage
                });
                toastEvent.fire();
                if(component.get("v.updateCaseBool") == true){
        			let submitButton = component.find("updateButton");
        			submitButton.set("v.disabled", false);
                } else {
        	        let submitButton = component.find("submitButton");
        	        submitButton.set("v.disabled", false);
                }
            }
            var spinner2 = component.find("dropdown-spinner");
            $A.util.addClass(spinner2, "slds-hide");
        });
        $A.enqueueAction(action);
    },
    
    getTopicOrTypeOrSubTypeValues : function(component,event,helper,instSearchTypeVal) {
        component.set("v.isSpecInstDropDown", true);
        var isNotChildCaseFlag = component.get("v.isNotChildCase");
        if(isNotChildCaseFlag != undefined && isNotChildCaseFlag != null && isNotChildCaseFlag) {
            component.set("v.instructionSearchType", instSearchTypeVal);
            this.searchInstructionRecords(component,event);  
        }
    },
    
    getContactIdForHouseHoldMember : function(component,event,helper) {
        
        var spinner = component.find("dropdown-spinner");
        $A.util.removeClass(spinner, "slds-hide");
        
        var memberData = component.get("v.memberData");
        if(memberData != null && memberData!= undefined && memberData != '') {
            
            var memberLastName = component.get("v.memberData.lastName");
            var memberFirstName = component.get("v.memberData.firstName");
            var memberId = component.get("v.memberData.memberID");                
            var memberDOB = component.get("v.memberData.DOB");
            var searchType = 'Member';
            var uniqueId = memberFirstName + memberLastName + memberDOB + memberId;
            var uhgAccess = component.get("v.uhgAccess");
            var action = component.get("c.getContactIdForHouseHoldMember");
            action.setParams({
                "searchType" : searchType,
                "firstName": memberFirstName,
                "lastName" : memberLastName,
                "uniqueId" : uniqueId,
                "dob" : memberDOB,
                "uhgAccess" : uhgAccess
            });
            action.setCallback(this, function(response) {            
                var state = response.getState();
                if(state === "SUCCESS") {
                    var contactId = response.getReturnValue();
                    console.log('contactId-'+contactId);
                    component.set("v.ContactId",contactId);            
                } else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }                
                    var toastType = "Error";
                    var toastMessage = "Issue with case creation.";
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type":toastType,
                        "message": toastMessage
                    });
                    toastEvent.fire();
                    if(component.get("v.updateCaseBool") == true){
            			let submitButton = component.find("updateButton");
            			submitButton.set("v.disabled", false);
                    } else {
            	        let submitButton = component.find("submitButton");
            	        submitButton.set("v.disabled", false);
                    }
                }
                var spinner2 = component.find("dropdown-spinner");
                $A.util.addClass(spinner2, "slds-hide");
            });
            $A.enqueueAction(action);
        }        
    },
   
    deleteRootcause:function(component,event,helper){
        var row = event.getParam('row');       
       var rows = component.get('v.rootCauseDetailsList');
	    var rowIndex = rows.indexOf(row);
        console.log(rowIndex);
        rows.splice(rowIndex, 1);
        component.set('v.rootCauseDetailsList', rows);

         if(rows.length==0){
            
            if(component.get("v.updateCaseBool") == true){
                let submitButton = component.find("updateButton");
                submitButton.set("v.disabled", true);
            } 
            else {
                
                let submitButton = component.find("submitButton");
                submitButton.set("v.disabled", true);
            }
        }
        if(row.defectType =='Maintenance'){
           component.find("rootCauseButton1").set("v.disabled", false); 
        }
        if(row.defectType =='Inquiry'){
        component.find("rootCauseButton2").set("v.disabled", false); 
        }
        if(row.defectType =='N/A'){
             component.find("rootCauseNAButton").set("v.disabled", false);  
        }
            
    }
})