({
    initaitePagination: function(component, event, helper, result){
        console.log('inside initaitePagination');
        helper.assignTableColumns(component,helper);
        component.set("v.totalPages", Math.ceil(result.length/component.get("v.pageSize")));
        component.set("v.allData", result);
        component.set("v.currentPageNumber",1);
        helper.buildData(component, helper);
    },
    assignTableColumns: function(component, helper){
        console.log('inside assignTableColumns');
        var caseRecTypeName = component.get("v.caseRecordTypeName");
        if(caseRecTypeName == "Reactive Resolution" || caseRecTypeName == "Proactive Action"){
            component.set('v.columns', [            
                {
                    label: 'View',
                    type: "button", typeAttributes: {
                        iconName: 'action:preview',
                        label: null,
                        name: 'selectRecord',
                        title: 'selectRecord',
                        disabled: false,
                        value: 'test',
                        variant: {fieldName: 'variantValue'}
                    },
                    initialWidth:50
                },
                {
                    label: 'Create',
                    type: "button", typeAttributes: {
                        iconName: 'utility:new',
                        label: null,
                        name: 'CreateRP',
                        title: 'CreateRP',
                        disabled: false,
                        value: 'test',
                        variant: {fieldName: 'variantValue'}
                    },
                    initialWidth:60
                },
                
                /*{label: 'View', fieldName: 'linkName', type: 'url',
             typeAttributes: {label: { fieldName: 'Name' }, target: '_self'},initialWidth:75},*/
                {label: 'LOB', fieldName: 'LOB__c', type: 'text', initialWidth:75},
                {label: 'Category', fieldName: 'Category__c', type: 'text', initialWidth:175},
                {label: 'Sub Category', fieldName: 'Sub_Category__c', type: 'text', initialWidth:200},
                {label: 'CrossWalk Case Resoltion Partner - Impact', fieldName: 'CrossWalk_Case_RPI__c', type: 'text', initialWidth:350},
                {label: 'Case Resolution Partner Ticket Type', fieldName: 'Case_Resolution_Partner_Ticket_Type__c', type: 'text', initialWidth:300},
                {label: 'Type of Issues IN SCOPE', fieldName: 'Type_of_Issues_IN_SCOPE__c', type: 'text', initialWidth:250},
                {label: 'Type of Issues OUT of SCOPE', fieldName: 'Type_of_Issues_OUT_of_scope__c', type: 'text', initialWidth:250},
                {label: 'Investigation & Solutions Group SPO/Job Aid/ Intervention Scenario', fieldName: 'ARPI_scenario_Job_Aid__c', type: 'text', initialWidth:470},
                {label: 'Submission Channel', fieldName: 'Submission_Channel__c', type: 'text', initialWidth:200},
                {label: 'Submission Criteria', fieldName: 'Submission_Criteria__c', type: 'text', initialWidth:200},
                {label: 'Link to SOP/ Source of Truth', fieldName: 'SOP_Source_of_Truth__c', type: 'text', initialWidth:300},
                {label: 'Escalation Process', fieldName: 'Escalation_Process__c', type: 'text', initialWidth:200},
                {label: 'Leadership Contact (SMEs/ Mgmt. Only)', fieldName: 'Leadership_Contact__c', type: 'text', initialWidth:300},
                {label: 'Resolution Partner SLA', fieldName: 'Resolution_Partner_SLA__c', type: 'text', initialWidth:200},
                {label: 'Claim Platfrom', fieldName: 'Claim_Platform__c', type: 'text', initialWidth:200},
            ]);
                } else{
                component.set('v.columns', [            
                {
                label: 'View',
                type: "button", typeAttributes: {
                iconName: 'action:preview',
                label: null,
                name: 'selectRecord',
                title: 'selectRecord',
                disabled: false,
                value: 'test',
                variant: {fieldName: 'variantValue'}
                },
                initialWidth:50
                },
                {label: 'LOB', fieldName: 'LOB__c', type: 'text', initialWidth:75},
                {label: 'Category', fieldName: 'Category__c', type: 'text', initialWidth:175},
                {label: 'Sub Category', fieldName: 'Sub_Category__c', type: 'text', initialWidth:200},
                {label: 'CrossWalk Case Resoltion Partner - Impact', fieldName: 'CrossWalk_Case_RPI__c', type: 'text', initialWidth:350},
                {label: 'Case Resolution Partner Ticket Type', fieldName: 'Case_Resolution_Partner_Ticket_Type__c', type: 'text', initialWidth:300},
                {label: 'Type of Issues IN SCOPE', fieldName: 'Type_of_Issues_IN_SCOPE__c', type: 'text', initialWidth:250},
                {label: 'Type of Issues OUT of SCOPE', fieldName: 'Type_of_Issues_OUT_of_scope__c', type: 'text', initialWidth:250},
                {label: 'Investigation & Solutions Group SPO/Job Aid/ Intervention Scenario', fieldName: 'ARPI_scenario_Job_Aid__c', type: 'text', initialWidth:470},
                {label: 'Submission Channel', fieldName: 'Submission_Channel__c', type: 'text', initialWidth:200},
                {label: 'Submission Criteria', fieldName: 'Submission_Criteria__c', type: 'text', initialWidth:200},
                {label: 'Link to SOP/ Source of Truth', fieldName: 'SOP_Source_of_Truth__c', type: 'text', initialWidth:300},
                {label: 'Escalation Process', fieldName: 'Escalation_Process__c', type: 'text', initialWidth:200},
                {label: 'Leadership Contact (SMEs/ Mgmt. Only)', fieldName: 'Leadership_Contact__c', type: 'text', initialWidth:300},
                {label: 'Resolution Partner SLA', fieldName: 'Resolution_Partner_SLA__c', type: 'text', initialWidth:200},
                {label: 'Claim Platfrom', fieldName: 'Claim_Platform__c', type: 'text', initialWidth:200},
            ]);
        }
    },
    buildData: function(component, helper) {
        console.log('inside buildData');
        var data = [];
        var pageNumber = component.get("v.currentPageNumber");
        var pageSize = component.get("v.pageSize");
        var allData = component.get("v.allData");
        var x = (pageNumber-1)*pageSize;
        console.log('x==>'+x);
        //creating data-table data
        for(; x<=(pageNumber)*pageSize; x++){
            if(allData[x]){
                data.push(allData[x]);
            }
        }
        var dataVar = JSON.stringify(data);
        component.set("v.data", data);
        helper.generatePageList(component, pageNumber);
    },
    generatePageList: function(component, pageNumber){
        pageNumber = parseInt(pageNumber);
        var pageList = [];
        var totalPages = component.get("v.totalPages");
        if(totalPages > 1){
            if(totalPages <= 10){
                var counter = 2;
                for(; counter < (totalPages); counter++){
                    pageList.push(counter);
                } 
            } else{
                if(pageNumber < 5){
                    pageList.push(2, 3, 4, 5, 6);
                } else{
                    if(pageNumber>(totalPages-5)){
                        pageList.push(totalPages-5, totalPages-4, totalPages-3, totalPages-2, totalPages-1);
                    } else{
                        pageList.push(pageNumber-2, pageNumber-1, pageNumber, pageNumber+1, pageNumber+2);
                    }
                }
            }
        }
        var pList = JSON.stringify(pageList);
        console.log('pList==>'+pList);
        component.set("v.pageList", pageList);
    },
    showSpinner: function(component, event) {
        var spinner = component.find("dropdown-spinner");
        $A.util.removeClass(spinner, "slds-hide");
    },
    hideSpinner: function(component, event) {
        var spinner = component.find("dropdown-spinner");
        $A.util.addClass(spinner, "slds-hide");
    },
    showToast: function(component, event, title,type,message){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "type": type,
            "message": message,
        });
        toastEvent.fire();
    },
    openRecord: function(component, event, rowId){
        var caseRecTypeName = component.get("v.caseRecordTypeName");
        if(caseRecTypeName == "Reactive Resolution" || caseRecTypeName == "Proactive Action"){
            
            var workspaceAPI = component.find("workspace");
            workspaceAPI.getEnclosingTabId().then(function(enclosingTabId) {
                workspaceAPI.openSubtab({
                    parentTabId: enclosingTabId,
                    pageReference: {
                        "type": "standard__component",
                        "attributes": {
                            "componentName": "c__ACET_FAST_ProviderMatrixDetailCmp"
                        },
                        "state": {
                            "uid": "1",
                            "c__providerMatrixId": rowId,
                            "c__caseRecordId":component.get("v.recordId")
                        }
                    }
                }).then(function(subtabId) {
                    console.log("The new subtab ID is:" + subtabId);
                    workspaceAPI.setTabLabel({
                        tabId: subtabId,
                        label: "Provider Matrix"
                    });
                    workspaceAPI.setTabIcon({
                        tabId: subtabId, 
                        icon: "standard:channel_program_levels",
                        iconAlt: "Provider Matrix"
                    });
                    workspaceAPI.focusTab({tabId : enclosingTabId});
                    workspaceAPI.focusTab({tabId : subtabId}); 
                }).catch(function(error) {
                    console.log("error");
                });
            });
        } else {
            component.set("v.selectedItemId",rowId);
            var urlEvent = $A.get("e.force:navigateToURL");
            urlEvent.setParams({
                "url": '/lightning/r/Provider_Matrix__c/'+rowId+'/view'
            });
            urlEvent.fire();
        }
    },
    openPopOver: function(component, event, pMatrixId){
        component.set("v.rpRecordId",pMatrixId);
        component.set("v.showPopUp",true);
    },
    closePopUp: function(component, event){
        component.set("v.showPopUp",false);
    },
    openAction: function(component, event, rowId){
        this.showSpinner(component, event);
        component.set("v.rpRecordId","");
        var action = component.get("c.getRPId");
        action.setParams({"pMatrixId":rowId});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var result = response.getReturnValue();
                if(result!=undefined && result!=null && result!=''){
                    component.set("v.rpRecordId",result);
                    this.openPopOver(component, event);
                }else{
                    console.log("result==>"+JSON.stringify(result));
                    var message = "There is no RP record for the row please select a different row";
                    this.showToast(component, event, "Error", "error",message);   
                }
                this.hideSpinner(component, event);
            }else{
                this.hideSpinner(component, event);
                console.log("state==>"+state);
                var message = "There was an error while retrieving RP record please check with administrator";
                this.showToast(component, event, "Error", "error",message);
            }
        });
        $A.enqueueAction(action);
    }
})