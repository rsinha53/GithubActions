({
	doInit : function(component, event, helper) {
        var pageReference = component.get("v.pageReference");
        if(pageReference != undefined || pageReference != null){
            component.set('v.groupData',pageReference.state.c__GroupData);
        }
        
        var action = component.get("c.getUser");
		action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
            	var storeResponse = response.getReturnValue();
                component.set("v.userInfo", storeResponse);
                component.set("v.instructionSearchType", "Business Unit");
        		helper.searchInstructionRecords(component,helper);
        		var dropdownOptions = [];
        		dropdownOptions.push({
                    label: "None",
                    value: "None"
                });
        		component.set('v.topicOptions', dropdownOptions);
        		component.set('v.typeOptions', dropdownOptions);
        		component.set('v.subtypeOptions', dropdownOptions);
        		var dosList = [{
        			dateOfServiceStart: '',
        			dateOfServiceEnd: ''
        		}];
        		component.set('v.dateOfServiceList', dosList);
        		
        		component.set("v.rootCauseColumns", [
					{label:"Issue Category", fieldName:"issueCategory", type:"text"},
		    		{label:"Defect Type", fieldName:"defectType", type:"text"},
		    		{label:"Root Cause Issue Category", fieldName:"rootCauseIssueCategory", type:"text"},
		    		{label:"Root Cause", fieldName:"rootCause", type:"text"},
		    		{label:"Brief Description", fieldName:"briefDesc", type:"text"},
		    		{label:"Service Impact Date", fieldName:"serviceImpactDate", type:"text"},
		    		{label:"Business Unit", fieldName:"businessUnit", type:"text"},
                    {type: 'button-icon',fixedWidth:30, typeAttributes: { iconName: 'utility:delete',  label:'Action',
                                                                         variant: 'border-filled',
                                                                         name: 'Delete',
                                                                         title: 'Delete',
                                                                         disabled: false,
                                                                         value: 'Delete',
                                                                         iconPosition: 'left'
                                                                        }},
                    
                    {type: 'button-icon',fixedWidth:30, typeAttributes: { iconName:{ fieldName: 'displayiconname' },
                                                                         label:'Action',
                                                                         
                                                                         name: 'Edit',
                                                                         title: 'Edit',
                                                                         disabled:{ fieldName: 'disablebutton' } ,
                                                                         value: 'Edit',
                                                                         iconPosition: 'left'
                                                                        }}]);
                
                component.set("v.eventTypeOptions", [
                    {label:"Standard", value:"Standard"},
                    {label:"One & Done", value:"One & Done"}		    		
                ]);
                component.set('v.eventType', 'Standard');
                component.set("v.fundingTypeOptions", [
                    {label:"None", value:"None"},
                    {label:"ASO", value:"ASO"},
                    {label:"Fully Insured", value:"Fully Insured"},
                    {label:"ASO/FI Split", value:"ASO/FI Split"}
                ]);
                if(!$A.util.isUndefinedOrNull(component.get("v.pageReference").state.c__InteractionRecord)){
                    component.set("v.interactionRec",component.get("v.pageReference").state.c__InteractionRecord);
                    console.log('HERE IS INTERACTION: ' + JSON.stringify(component.get("v.interactionRec")));
                }
                if(!$A.util.isUndefinedOrNull(component.get("v.pageReference").state.c__GroupData)){
                    component.set("v.displayFTLabel",true);
                    component.set("v.groupData",component.get("v.pageReference").state.c__GroupData);
                    console.log('HERE IS GROUP DATA: ' + JSON.stringify(component.get("v.groupData")));
                }
                else{
                    component.set("v.displayFTLabel",false);
                }
                
                //jangi start
                if(!$A.util.isUndefinedOrNull(component.get("v.pageReference").state.c__InternalContacts)){
                    component.set("v.CDXDataResultsNA",component.get("v.pageReference").state.c__InternalContacts);
                }
                //Jangi ends
                
                if(!$A.util.isUndefinedOrNull(component.get("v.pageReference").state.c__producerData)){
                    component.set("v.producerData",component.get("v.pageReference").state.c__producerData);
                    console.log('HERE IS Producer DATA: ' + JSON.stringify(component.get("v.producerData")));
                }
                if(!$A.util.isUndefinedOrNull(component.get("v.pageReference").state.c__MemberData)){
                    component.set("v.memberData",component.get("v.pageReference").state.c__MemberData);
                    console.log('HERE IS MEMBER DATA: ' + JSON.stringify(component.get("v.memberData")));
                } 
                if(!$A.util.isUndefinedOrNull(component.get("v.pageReference").state.c__CustomerAdminData)){
                    component.set("v.customerAdminData",component.get("v.pageReference").state.c__CustomerAdminData);
                    console.log('HERE IS CUSTOMER ADMIN DATA: ' + JSON.stringify(component.get("v.customerAdminData")));
                } 
                component.set('v.uhgAccess', 'No');
                if(!$A.util.isUndefinedOrNull(component.get("v.pageReference").state.c__CaseRecord)){
                    component.set("v.parentCaseRec",component.get("v.pageReference").state.c__CaseRecord);
                    console.log('HERE IS PARENT CASE DATA: ' + JSON.stringify(component.get("v.parentCaseRec")));
                    component.set('v.uhgAccess',component.get('v.parentCaseRec').UHG_Restriction__c);
                }
                if(!$A.util.isUndefinedOrNull(component.get("v.pageReference").state.c__IsCloneCase)){
                    component.set("v.isCloneCase",component.get("v.pageReference").state.c__IsCloneCase);
                    console.log('CLONE CASE: ' + JSON.stringify(component.get("v.isCloneCase")));
                }
                
                if(!$A.util.isUndefinedOrNull(component.get("v.pageReference").state.c__UHGRestricted)){
                    component.set("v.uhgAccess",component.get("v.pageReference").state.c__UHGRestricted);
                    console.log('UHG RESTRICTED: ' + JSON.stringify(component.get("v.uhgAccess")));
                }
                if(!$A.util.isUndefinedOrNull(component.get("v.pageReference").state.c__MemberSubjectCardData)){
                    component.set("v.memberSubjCardData",component.get("v.pageReference").state.c__MemberSubjectCardData);
                    console.log('HERE IS Member Subject Card DATA: ' + JSON.stringify(component.get("v.memberSubjCardData")));
                }
                if(!$A.util.isUndefinedOrNull(component.get("v.pageReference").state.c__isNotChildCase)){
                    component.set("v.isNotChildCase",component.get("v.pageReference").state.c__isNotChildCase);
                    component.set("v.businessUnitSelected", component.get("v.parentCaseRec.Special_Instructions_Business_Unit__c"));
                    component.set("v.topicSelected", component.get("v.parentCaseRec.Issue_Category_Desc__c"));
                    component.set("v.descriptionField", component.get("v.parentCaseRec.Special_Instructions_Description__c"));
                    component.set("v.businessUnitText", component.get("v.parentCaseRec.Special_Instructions_Business_Unit__c"));
                    component.set("v.topicText", component.get("v.parentCaseRec.Issue_Category_Desc__c"));
                    console.log('IS NOT CHILD CASE: ' + JSON.stringify(component.get("v.isNotChildCase")));
                }
                if(!$A.util.isUndefinedOrNull(component.get("v.pageReference").state.c__MemberRelationship)){
                    component.set("v.memberRelationship",component.get("v.pageReference").state.c__MemberRelationship);
                    console.log('HERE IS Member Relationship: ' + JSON.stringify(component.get("v.memberRelationship")));
                }
                if(!$A.util.isUndefinedOrNull(component.get("v.pageReference").state.c__isHouseHoldMemClicked)){
                    component.set("v.isHouseHoldMemClicked",component.get("v.pageReference").state.c__isHouseHoldMemClicked);
                    console.log('isHouseHoldMemClicked: ' + JSON.stringify(component.get("v.isHouseHoldMemClicked")));
                    if(component.get("v.isHouseHoldMemClicked")) {
                        helper.getContactIdForHouseHoldMember(component, event, helper);
                    }
                }
                console.log('BEFORE UPDATECASE: ' + component.get("v.pageReference").state.c__UpdateCaseInfo);
                if(!$A.util.isUndefinedOrNull(component.get("v.pageReference").state.c__UpdateCaseInfo)){
                    component.set("v.updateCaseInfo",component.get("v.pageReference").state.c__UpdateCaseInfo);
                    console.log('updateCaseInfo: ' + JSON.stringify(component.get("v.updateCaseInfo")));
                    component.set("v.updateCaseBool",true);
                }
                if(!$A.util.isUndefinedOrNull(component.get("v.pageReference").state.c__SpecialInstructionInfo)){
                	var specialInfo = component.get("v.pageReference").state.c__SpecialInstructionInfo;
                    if(specialInfo.resolution != null && specialInfo.resolution != undefined && specialInfo.resolution.trim() != ''){
                    	component.set("v.descriptionField",specialInfo.resolution);
                    }
                    if(specialInfo.oneAndDoneFlag){
                        component.set("v.isStandardFlag",specialInfo.oneAndDoneFlag);
                    }
                    
                    console.log('PRESELECTED BUSINESS UNIT: ' + specialInfo.businessUnit);
                    if(specialInfo.businessUnit != null && specialInfo.businessUnit != undefined && specialInfo.businessUnit.trim() != '' && specialInfo.businessUnit != 'None'){
            		console.log('FOUND BUSINESS UNIT: ' + specialInfo.businessUnit);
            		component.set("v.businessUnitText",specialInfo.businessUnit);
                	component.set("v.businessUnitSelected",specialInfo.businessUnit);
                	component.set("v.instructionSearchType", "Topic");
                	helper.resetFields(component,event);
            		helper.clearInfoFields(component,event);
            		helper.searchInstructionRecordsOnload(component,event);
                    }
                }
                component.set("v.ContactId",component.get("v.pageReference").state.c__ContactId);
                console.log(component.get("v.pageReference").state.c__ContactId);
                component.set("v.FlowType",component.get("v.pageReference").state.c__FlowType);
            }
        });
        $A.enqueueAction(action);
	},
	/*toggleOneAndDone:function(component, event, helper){
		var source = event.getSource();
		component.set("v.oneAndDoneCheckbox",source.get('v.checked'));
	},*/    
    fetchcontactid:function(component, event, helper){
        component.set("v.ContactId",event.getParam("ContactID"));
        component.set("v.FlowType",event.getParam("FlowType"));
    },
	clearFields: function(component, event, helper){
		helper.clearInfoFields(component,event);
		var dropdownOptions = [];
		dropdownOptions.push({
            label: "None",
            value: "None"
        });
        component.set('v.businessUnitSelected', "None");
        component.set('v.businessUnitText', "None");
        component.set('v.fundingTypeText', "None");
        component.set('v.topicOptions', dropdownOptions);
        component.set('v.topicSelected', "None");
        component.set('v.topicText', "None");
        component.set('v.typeOptions', dropdownOptions);
        component.set('v.typeSelected', "None");
        component.set('v.typeText', "None");
        component.set('v.subtypeOptions', dropdownOptions);
        component.set('v.subtypeSelected', "None");	
        component.set('v.subtypeText', "None");
        /*** Jangi ***/
        component.set('v.isCDXClicked', false);
        component.set('v.isCDX', false);
        component.set('v.CDXDataResults', "");
        /*** Jangi Ends ***/
		helper.checkButtonsBoolean(component,event);
	},
	checkButtonsBool: function(component,event,helper){
		helper.checkButtonsBoolean(component,event);
	},
	openRootCause: function(component, event, helper){
		var businessUnit = component.get("v.businessUnitSelected");
		component.set("v.sendBusinessUnitSelected",businessUnit);
		component.set("v.isRootCauseDefect", true);
		component.set("v.isRootCause", true);
	},
	openRootCauseNA: function(component, event, helper){
		var businessUnit = component.get("v.businessUnitSelected");
		component.set("v.sendBusinessUnitSelected",businessUnit);
		component.set("v.isRootCauseDefect", false);
		component.set("v.isRootCause", true);
		
	},
	closeRootCauseModal: function(component, event, helper){
		

        if(component.get("v.isCDX") == event.getParam("cdxFlag")){
            component.set("v.selectedCDXRow", event.getParam("cdxFlag"));
            component.set("v.isCDXClicked", event.getParam("isRootCause"));
            component.set("v.cdxContactValue", event.getParam("cdxContactValue"));
            component.set("v.firstName", event.getParam("firstName"));
            component.set("v.lastName", event.getParam("lastName"));
            component.set("v.Role", event.getParam("role"));
            component.set("v.urlField", event.getParam("cdxContactValue"));
            helper.checkButtonsBoolean(component,event);
        }else{
            component.set("v.selectedCDXRow", event.getParam("isRootCause"));
            component.set("v.isRootCause", event.getParam("isRootCause"));
            component.set("v.isCDXClicked", event.getParam("isRootCause"));
        }
	},
	saveRootCauseDetails: function(component, event, helper){
		
        var rootDetails;
        var dmltype;
        var lastColumn=[];
        lastColumn= component.get("v.rootCauseColumns");
        var normaltext ={type: 'button-icon',fixedWidth:30, typeAttributes: { iconName: 'utility:edit',  label:'Action',
                                                                             
                                                                             name: 'Edit',
                                                                             title: 'Edit',
                                                                             disabled: false,
                                                                             value: 'Edit',
                                                                             iconPosition: 'left',
                                                                             style:'visibility:hidden'
                                                                            }}
        
        var editcolumn={type: 'button-icon',fixedWidth:30, typeAttributes: { iconName: 'utility:edit',  label:'Action',
                                                                            
                                                                            name: 'Edit',
                                                                            title: 'Edit',
                                                                            disabled: false,
                                                                            value: 'Edit',
                                                                            iconPosition: 'left'
                                                                           }}
        
        var ctarget = event.currentTarget;
        if(ctarget != undefined && ctarget != null) {
            
            var rootCauseBtnVal = '';
            
            rootCauseBtnVal = ctarget.dataset.value;
            console.log(rootCauseBtnVal);
            if(rootCauseBtnVal == '') {
                rootCauseBtnVal = component.find("rootCauseNAButton").get("v.value");  
            }
            if(rootCauseBtnVal == "Maintenance") {
                rootDetails = {
                    issueCategory: component.get("v.topicSelected"),
                    defectType: "Maintenance",
                    rootCauseIssueCategory: "Maintenance",
                    rootCause: "DEFAULT",
                    briefDesc: "",
                    serviceImpactDate: "",
                    businessUnit: component.get("v.businessUnitSelected")
                    
                };
                rootDetails.displayiconname = '';
                rootDetails.disablebutton=true;
                component.find("rootCauseButton1").set("v.disabled", true);  
            } else if(rootCauseBtnVal == "Inquiry") {
                rootDetails = {
                    issueCategory: component.get("v.topicSelected"),
                    defectType: "Inquiry",
                    rootCauseIssueCategory: "Inquiry",
                    rootCause: "DEFAULT",
                    briefDesc: "",
                    serviceImpactDate: "",
                    businessUnit: component.get("v.businessUnitSelected")
                };
                rootDetails.displayiconname = '';
                rootDetails.disablebutton=true;
                component.find("rootCauseButton2").set("v.disabled", true); 
            } else if(rootCauseBtnVal == "NA") {
                rootDetails = {
                    issueCategory: component.get("v.topicSelected"),
                    defectType: "N/A",
                    rootCauseIssueCategory: "N/A",
                    rootCause: "DEFAULT",
                    briefDesc: "",
                    serviceImpactDate: "",
                    businessUnit: component.get("v.businessUnitSelected")
                };
                rootDetails.displayiconname = '';
                rootDetails.disablebutton=true;
                component.find("rootCauseNAButton").set("v.disabled", true); 
            }  
            
        } 
        else {
            rootDetails = event.getParam("rootCauseDetails");
            rootDetails = event.getParam("rootCauseDetails");
            rootDetails.displayiconname = 'utility:edit';
            rootDetails.disablebutton=false;
           
            component.set("v.rootCauseDefect",rootDetails);
            dmltype = event.getParam("update");
        }
        
        var rootList = [];
        var defect= component.get("v.isdefectType");
        if(component.get("v.rootCauseDetailsList") != '' && component.get("v.rootCauseDetailsList") != []){
            rootList = component.get("v.rootCauseDetailsList");
        };
        var defect= component.get("v.isdefectType");
        var count = 0;
        var existDetails;
        if(rootList.length>0){
            
            var i=component.get("v.rowindex");
            if(dmltype == true){
                count=count+1;
                var existDetails = rootList[i-1];
                rootList[i-1] = rootDetails;  
                component.set("v.rowindex",0);
                
            }else{
                rootList.push(rootDetails); 
            }
        }
        else{
            rootList.push(rootDetails);
        }
        component.set("v.rootCauseDetailsList",rootList);
        if(rootList.length>0){
            /* let submitButton = component.find("submitButton");
                submitButton.set("v.disabled", false);
        }*/
            if(component.get("v.updateCaseBool") == true){
                let submitButton = component.find("updateButton");
                submitButton.set("v.disabled", false);
            } 
            else {
                
                let submitButton = component.find("submitButton");
                submitButton.set("v.disabled", false);
            }
        }
        component.set("v.isRootCauseTable",true);
    },
    openModal: function(component, event, helper){
        //can add proper code later
        var MemberIDRequiredIndicator = component.get("v.MemberIDRequiredIndicator");
        var FlowType = component.get("v.FlowType");
        
        var memberData = component.get("v.memberData");
        var groupData = component.get("v.groupData");
        var firstname;
         var lastname;
       var  subjectName;
        
        //DE386094 Clone Case component Error
        if(!$A.util.isUndefinedOrNull(groupData)){
			subjectName = groupData.groupName;
        }
        if(MemberIDRequiredIndicator == 'Y' && component.get("v.isStandardFlag") &&
           (memberData == '' || memberData == undefined || memberData == null)){
            var toastMessage = component.get("v.stopPeocessingError");
            helper.displayMessage(component,event,toastMessage);
        }else{
            var isvalidateOnSubmit = false;
            isvalidateOnSubmit = helper.validationsBeforeSubmit(component, event,helper);
            if(isvalidateOnSubmit) {            
                var isNotChildCase = component.get("v.isNotChildCase");
                if(isNotChildCase != undefined && isNotChildCase != null && isNotChildCase) {
                    helper.updateCase(component,event);   
                } else {
                    helper.saveCase(component,event);   
                }        	  
            } 
        }
    },
    clickBusinessUnit: function(component, event, helper){
        helper.closeAllDropdownsHelper(component,event);
        component.set("v.businessUnitFilter", component.get("v.businessUnitOptions"));
        if(component.get("v.businessUnitText") == "None"){
            component.set("v.businessUnitText", "");
        }
        component.set("v.displayBU", true);
        component.find("focus:BU").focus();
    },
        
    businessUnitTextChange: function(component, event, helper){
    	component.set("v.instructionSearchType", "Topic");
    	helper.resetFields(component,event);
    	helper.clearInfoFields(component,event);
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
	        	helper.clearInfoFields(component,event);
	    		helper.searchInstructionRecords(component,event);
	    		helper.checkButtonsBoolean(component,event);
        	}
        }
    },
    searchFTonEnter: function(component, event, helper){
        var isEnterKey = event.keyCode === 13;
        if (isEnterKey) {
            var filterList = component.get("v.fundingTypeFilter");
            if(filterList != null && filterList != [] && filterList[0] != undefined){
            	component.set("v.fundingTypeSelected",filterList[0]);
                component.set("v.fundingTypeFilter",filterList[0].label);
                component.set("v.fundingTypeText",filterList[0].label);
                component.set("v.instructionSearchType", "Topic");
                helper.resetFields(component,event);
                helper.clearInfoFields(component,event);
                helper.searchInstructionRecords(component,event);
                helper.checkButtonsBoolean(component,event);
            }
        }
    },
    clickFundingType: function(component, event, helper){
        helper.closeAllDropdownsHelper(component,event);
        component.set("v.fundingTypeFilter", component.get("v.fundingTypeOptions"));
        if(component.get("v.fundingTypeText") == "None"){
            component.set("v.fundingTypeText", "");
        }
        component.set("v.displayFT", true);
        component.find("focus:FT").focus();
    },
    filterFundingType: function(component, event, helper){
    	component.set("v.instructionSearchType", "Topic");
        helper.clearInfoFields(component,event);
        helper.filterFundingTypes(component, event, helper);
    },
    getFundingTypeInfo: function(component, event, helper){
         var selLabel = event.currentTarget.getAttribute("data-label");
       //helper.resetFields(component,event);
        
        component.set("v.fundingTypeSelected",selLabel);
        component.set("v.fundingTypeText", selLabel);
        component.set("v.displayFT",false);
        component.set("v.instructionSearchType", "Topic");
         helper.resetFields(component,event);
        helper.clearInfoFields(component,event);
        helper.searchInstructionRecords(component,event);
        helper.checkButtonsBoolean(component,event);
        component.find("focus:FT").focus();//US2594886
        component.set("v.displayFT", false);
        
    },
    getBusinessUnitInfo: function(component, event, helper){
    	var selLabel = event.currentTarget.getAttribute("data-label");
    	component.set("v.businessUnitSelected",selLabel);
    	component.set("v.businessUnitText", selLabel);
    	component.set("v.instructionSearchType", "Topic");
    	helper.resetFields(component,event);
		helper.clearInfoFields(component,event);
		helper.searchInstructionRecords(component,event);
		helper.checkButtonsBoolean(component,event);
        component.find("focus:BU").focus();//US2594886
        component.set("v.displayBU",false);
    },
    clickTopic: function(component, event, helper){
    	helper.closeAllDropdownsHelper(component,event);
    	component.set("v.topicFilter", component.get("v.topicOptions"));
    	if(component.get("v.topicText") == "None"){
    		component.set("v.topicText", "");
    	}
    	component.set("v.displayTopic", true);
        var topicsList = component.get("v.topicOptions");
        if(topicsList == undefined || topicsList == null || (topicsList.length == 0 || topicsList.length == 1)) {
        	helper.getTopicOrTypeOrSubTypeValues(component,event,helper,'Topic');   
        }        
        component.find("focus:IC").focus();//US2594886
    },
    topicTextChange:function(component, event, helper){
    	component.set("v.instructionSearchType", "Type");
    	helper.resetFields(component,event);
    	helper.clearInfoFields(component,event);
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
	        	helper.clearInfoFields(component,event);
	    		helper.searchInstructionRecords(component,event);
	    		helper.checkButtonsBoolean(component,event);
        	}
        }
    },
    getTopicInfo: function(component, event, helper){
    	var selLabel = event.currentTarget.getAttribute("data-label");
    	component.set("v.topicSelected",selLabel);
    	component.set("v.topicText", selLabel);
		component.set("v.instructionSearchType", "Type");
    	helper.resetFields(component,event);
		helper.clearInfoFields(component,event);
		helper.searchInstructionRecords(component,event);
		helper.checkButtonsBoolean(component,event);
        component.find("focus:IC").focus();//US2594886
        component.set("v.displayTopic",false);
    },
    clickType: function(component, event, helper){
    	helper.closeAllDropdownsHelper(component,event);
    	component.set("v.typeFilter", component.get("v.typeOptions"));
    	if(component.get("v.typeText") == "None"){
    		component.set("v.typeText", "");
    	}
    	component.set("v.displayType", true);
        var typesList = component.get("v.typeOptions");
        if(typesList == undefined || typesList == null || (typesList.length == 0 || typesList.length == 1)) {
        	helper.getTopicOrTypeOrSubTypeValues(component,event,helper,'Type');   
        }        
       component.find("focus:TCT").focus();//US2594886
    },
    typeTextChange:function(component, event, helper){
    	component.set("v.instructionSearchType", "Subtype");
    	helper.resetFields(component,event);
    	helper.clearInfoFields(component,event);
    	helper.filterTypes(component, event, helper);
    },
    searchTypeonEnter: function(component, event, helper){
    	var isEnterKey = event.keyCode === 13;
        if (isEnterKey) {
        	var filterList = component.get("v.typeFilter");
        	if(filterList != null && filterList != [] && filterList[0] != undefined){
	        	component.set("v.typeSelected",filterList[0].label);
	        	component.set("v.typeText",filterList[0].label);
	        	component.set("v.instructionSearchType", "Subtype");
	        	helper.resetFields(component,event);
	        	helper.clearInfoFields(component,event);
	    		helper.searchInstructionRecords(component,event);
	    		helper.checkButtonsBoolean(component,event);
        	}
        }
    },
    getTypeInfo: function(component, event, helper){
    	var selLabel = event.currentTarget.getAttribute("data-label");
    	component.set("v.typeSelected",selLabel);
    	component.set("v.typeText", selLabel);
    	component.set("v.instructionSearchType", "Subtype");
    	helper.resetFields(component,event);
		helper.clearInfoFields(component,event);
		helper.searchInstructionRecords(component,event);
		helper.checkButtonsBoolean(component,event);
        component.find("focus:TCT").focus();
        component.set("v.displayType",false);//US2594886
    },
    clickSubtype: function(component, event, helper){
    	helper.closeAllDropdownsHelper(component,event);
    	component.set("v.subtypeFilter", component.get("v.subtypeOptions"));
    	if(component.get("v.subtypeText") == "None"){
    		component.set("v.subtypeText", "");
    	}
    	component.set("v.displaySubtype", true);
        var subTypesList = component.get("v.subtypeOptions")
        if(subTypesList == undefined || subTypesList == null || (subTypesList.length == 0 || subTypesList.length == 1)) {
        	helper.getTopicOrTypeOrSubTypeValues(component,event,helper,'Subtype');   
        }        
        component.find("focus:TCS").focus();//US2594886
    },
    subtypeTextChange:function(component, event, helper){
    	helper.clearInfoFields(component,event);
    	helper.filterSubtypes(component, event, helper);
    },
    searchSubtypeonEnter: function(component, event, helper){
    	var isEnterKey = event.keyCode === 13;
        if (isEnterKey) {
        	var filterList = component.get("v.subtypeFilter");
        	if(filterList != null && filterList != [] && filterList[0] != undefined){
	        	component.set("v.subtypeSelected",filterList[0].label);
	        	component.set("v.subtypeText",filterList[0].label);
	        	component.set("v.displayBU", false);
	        	component.set("v.displayTopic", false);
	        	component.set("v.displayType", false);
	        	component.set("v.displaySubtype", false);
	        	helper.clearInfoFields(component,event);
	    		helper.searchForRecord(component,event);
	    		helper.checkButtonsBoolean(component,event);
        	}
        }
    },
    processTTSDropdowns: function(component,event,helper){
		var selLabel = event.currentTarget.getAttribute("data-label");
        component.set("v.isCDXClicked",false);
        component.set("v.isCDX",false);
    	component.set("v.displayBU", false);
    	component.set("v.displayTopic", false);
    	component.set("v.displayType", false);
    	component.set("v.displaySubtype", false);
    	component.set("v.subtypeSelected",selLabel);
    	component.set("v.subtypeText", selLabel);
    	helper.clearInfoFields(component,event);
    	helper.searchForRecord(component,event);
		helper.checkButtonsBoolean(component,event);
        component.find("focus:TCS").focus();//US2594886
        component.set("v.displaySubtype",false);
	},
	closeAllDropdowns:function(component,event,helper){
		helper.closeAllDropdownsHelper(component,event);

	},
	navigateToInteraction: function(component, event, helper){
    	console.log('interaction clicked');
        var intId = event.currentTarget.getAttribute("data-intId");
        console.log(intId);

        var workspaceAPI = component.find("workspace");
        workspaceAPI.openSubtab({
            pageReference: {
                type: 'standard__recordPage',
                attributes: {
                    actionName: 'view',
                    objectApiName: 'Interaction__c',
                    recordId : intId
                },
            },
            focus: true
        }).then(function(response) {
            workspaceAPI.getTabInfo({
                tabId: response

            }).then(function(tabInfo) {
                /*workspaceAPI.setTabLabel({
                        tabId: tabInfo.tabId,
                        label: 'Detail-'+lastName
                    });
                    workspaceAPI.setTabIcon({
                        tabId: tabInfo.tabId,
                        icon: "standard:people",
                        iconAlt: "Member"
                    });*/
            });
        }).catch(function(error) {
            console.log(error);
        });
    },
    noManualEntry: function(component,event,helper){
		event.preventDefault();
        return false;
	},
	removeDateRow: function(component,event,helper){
		var dateList = component.get('v.dateOfServiceList');
		var selectedItem = event.currentTarget;
        var dateIndex = selectedItem.dataset.record;
		dateList.splice(dateIndex,1);
		component.set('v.dateOfServiceList', dateList);
		helper.checkButtonsBoolean(component,event);
	},
	getDateChange: function(component,event,helper){
        var index = event.getSource().get("v.name");
        var dateList = component.get('v.dateOfServiceList');
        if(dateList[index].dateOfServiceStart != null){
            dateList[index].dateOfServiceEnd = dateList[index].dateOfServiceStart;
            component.set('v.dateOfServiceList', dateList);
            helper.checkButtonsBoolean(component,event,helper);
        }
            
	},
	addDateRow: function(component,event,helper){
		var dateList = component.get('v.dateOfServiceList');
		var dateRow = {
			dateOfServiceStart: '',
			dateOfServiceEnd: ''
		};
		dateList.push(dateRow);
		component.set('v.dateOfServiceList', dateList);
	},
    checkForAlphanumeric : function(component,event,helper) {
        var referenceId = component.get("v.referenceID");
        referenceId = (referenceId != null && referenceId != undefined) ? referenceId : '';
        var regExp = /^[a-z0-9]+$/i;        
        if(referenceId.toString().match(regExp)) {           
        	return true;                           
        } else {
            component.set("v.referenceID", referenceId.substring(0,referenceId.length-1));
        }        
    },
    
    updateEventType : function(component, event, helper) {
		component.set("v.eventType", event.getParam("value"));
        helper.validationsBeforeSubmit(component, event, helper);
	},
    
    validationForEventType : function(component, event, helper) {
        helper.validationsBeforeSubmit(component, event, helper);
    },
    checkDescriptionLength: function(component,event,helper){
    	var description = component.find("specinsdesc");
    	$A.util.removeClass(description, "slds-has-error");  
		component.find("descriptionError").set("v.errors", null);
    	var res = component.get("v.descriptionField");
    	if(res.length == 8000){
    		console.log('CHARACTER LIMIT REACHED');
    		$A.util.addClass(description, "slds-has-error");
    		component.find("descriptionError").set("v.errors", [{message:"Max characters for Description has been reached."}]);
    		
    	}
    },
    //jangi - starts
    getCDXContacts: function(component,event,helper){
        debugger;
        component.set("v.isCDXClicked",true);
        if(component.get("v.isCDX")){ 
            var groupData = component.get("v.groupData");
            var CDXContactData; 
            if(groupData != null && groupData != undefined){
                if(groupData.sourceCode != 'NA'){
                    CDXContactData = groupData.groupTeamMembers;
                }else{
                    CDXContactData = component.get("v.CDXDataResultsNA");
                }
            }else if(!$A.util.isUndefinedOrNull(component.get("v.parentCaseRec")) && component.get("v.parentCaseRec.SourceCode__c") == 'NA'){
                if(!$A.util.isEmpty(component.get("v.CDXDataResultsNA"))){
                    CDXContactData = component.get("v.CDXDataResultsNA");
                }
            }
            
            console.log(component.get("v.CDXDataResults"));
            
            var contactLst = [];
            
            for (var key in CDXContactData) {
                if(CDXContactData.hasOwnProperty(key)){
                    console.log(CDXContactData[key]);
                    contactLst.push(CDXContactData[key])
                }
            }
            console.log(contactLst);
            component.set("v.CDXDataResults", contactLst);
            var childComponent = component.find("callChild");
       
        var message = childComponent.childMessageMethod(contactLst);
            
        }
    },
    //rootcause maintanance delete action
    handleRowAction:function(component, event, helper) {
        
        var actionName = event.getParam('action').name;
        var rootdetails ;
        if ( actionName == 'Edit' ) {
            
            component.set("v.isRootCause", true);
            var row = event.getParam('row');
            rootdetails =row;
            var rows = component.get('v.rootCauseDetailsList');
            var rowIndex = rows.indexOf(row);
            component.set("v.rootCauseDefect",row);
            component.set("v.subTopic", rootdetails.rootCauseIssueCategory);
            component.set("v.date", rootdetails.serviceImpactDate);
            component.set("v.EditbriefDesc",rootdetails.briefDesc);
            component.set("v.rowindex",rowIndex+1);
        } else if ( actionName == 'Delete') {
            helper.deleteRootcause(component, event,helper);
        }
    },
    
    
    //subject field validation  
    CheckLength : function(component, event, helper) {
        let submitButton = component.find("submitButton");
        var Subjectvalue = component.find("Subject");
        var len = Subjectvalue.get("v.value");
        if(len.length > 90){
            Subjectvalue.setCustomValidity("The subject field needs to have less than 90 characters");
            
        }else{
            Subjectvalue.setCustomValidity("");
        }
        Subjectvalue.reportValidity();
    }
})