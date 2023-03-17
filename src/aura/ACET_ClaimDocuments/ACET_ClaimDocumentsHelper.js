({
    openMisDirect: function (component, event, helper) {
        
        
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getEnclosingTabId().then(function (enclosingTabId) {
            if (enclosingTabId == false) {
                workspaceAPI.openTab({
                    pageReference: {
                        "type": "standard__component",
                        "attributes": {
                            "componentName": "c__SAE_MisdirectComponent"
                        },
                        "state": {}
                    },
                    focus: true
                }).then(function (response) {
                    workspaceAPI.getTabInfo({
                        tabId: response
                    }).then(function (tabInfo) {
                        
                        var focusedTabId = tabInfo.tabId;
                        workspaceAPI.setTabLabel({
                            tabId: focusedTabId,
                            label: "Misdirect"
                        });
                        workspaceAPI.setTabIcon({
                            tabId: focusedTabId,
                            icon: "standard:decision",
                            iconAlt: "Misdirect"
                        });
                    });
                }).catch(function (error) {
                    
                });
            } else {
                workspaceAPI.openSubtab({
                    parentTabId: enclosingTabId,
                    pageReference: {
                        "type": "standard__component",
                        "attributes": {
                            "componentName": "c__SAE_MisdirectComponent"
                        },
                        "state": {
                            "c__originatorName": component.get('v.originatorName'),
                            "c__originatorType": component.get('v.originatorType'),
                            "c__contactName": component.get('v.contactName'),
                            "c__subjectName": component.get('v.subjectName'),
                            "c__subjectType": component.get('v.subjectType'),
                            "c__subjectDOB": component.get('v.subjectDOB'),
                            "c__subjectID": component.get('v.subjectID'),
                            "c__subjectGrpID": component.get('v.subjectGrpID'),
                            "c__interactionID": component.get('v.contactUniqueId'),
                            "c__contactUniqueId": component.get('v.contactUniqueId'),
                            "c__focusedTabId": enclosingTabId
                        }
                    }
                }).then(function (subtabId) {
                    
                    workspaceAPI.setTabLabel({
                        tabId: subtabId,
                        label: "Misdirect" //set label you want to set
                    });
                    
                    workspaceAPI.setTabIcon({
                        tabId: subtabId,
                        icon: "standard:decision",
                        iconAlt: "Misdirect"
                    });
                }).catch(function (error) {
                });
            }
        });
    },
    getAttachments: function (component,event,helper,indexNameList) {
        var serviceList=[];
        for(var i=0;i<indexNameList.length;i++){
            console.log('TestList##-->'+indexNameList[i]);
            var provEob={};
            provEob.serviceName = 'LinkRelatedDocuments';
            provEob.docClass = indexNameList[i];
            provEob.inputParam = JSON.stringify(component.get("v.relatedDocData"));
            provEob.createJSONBody = true;
            provEob.outputFormat = 'Claim Documents';
            provEob.docName = 'Attachments';
            serviceList.push(provEob);
        }
        
        var action = component.get('c.startRequest');
        action.setParams({
            "serviceCalloutInput":JSON.stringify(serviceList)
        });
       action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state@@@' + state);
            if (state == "SUCCESS") {
                var data = response.getReturnValue();
                if(data != null && data.isSuccess){
                    console.log('data##-->'+JSON.stringify(data));
                    var AttachmentsList = component.get("v.AttachmentsList");
                    for(var i=0;i<data.AttachmentsData.length;i++){
                        AttachmentsList.push(data.AttachmentsData[i]);
                    }
                     component.set("v.AttachmentsList",AttachmentsList);
                    console.log('AttachmentsList@@@' + component.get("v.AttachmentsList"));
                    if(data.AttachmentsData.length != 0){
                        component.set("v.attachmentEmptyCheck",true);
                    }
                }
                else{
                    this.showToastMessage("We hit a snag.",data.errorMessage, "error", "dismissible", "30000");
                }
            }
            else if (state === "INCOMPLETE") {
                console.log("Failed to connect Salesforce!!");
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("ClaimLettersCheck error:"+errors[0].message);
                        }
                    }
                }
            this.hidettachmentSpinner(component,'attchmentspinner');
        });
        $A.enqueueAction(action);
    },
    getEDIClaimImages: function(component, event, helper){
        var relatedDocData = JSON.stringify(component.get("v.relatedDocData"));
        console.log('relatedDocDataClaimImages##-->'+relatedDocData);
        var action = component.get('c.getClaimsAutodoc');
        action.setParams({
            "Indexname":'u_edi_claim',
            "docInputs":relatedDocData
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state@@@' + state);
            if (state == "SUCCESS") {
                var data = response.getReturnValue();
                if(data != null && data.isSuccess){
                    console.log('data##-->'+JSON.stringify(data));
                    var claimimagelist = component.get("v.claimImagesList");
                    for(var i=0;i<data.AttachmentsData.length;i++){
                        claimimagelist.push(data.AttachmentsData[i]);
                    }
                    //component.set("v.claimImagesList",data.AttachmentsData);
                    component.set("v.claimImagesList",claimimagelist);
                    console.log('claimImagesList@@@' + component.get("v.claimImagesList"));
                    if(data.totalRecords != 0){
                        component.set("v.claimImagesEmptyCheck",true);
                    }
                }
                else{
                    this.showToastMessage("We hit a snag.",data.errorMessage, "error", "dismissible", "30000");
                }
            }
            else if (state === "INCOMPLETE") {
                console.log("Failed to connect Salesforce!!");
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("error :"+errors[0].message);
                        }
                    }
                }
            this.hidettachmentSpinner(component, 'claimImages');
        });
        $A.enqueueAction(action);
    },
    getKeyedClaimImages: function(component, event, helper){
        var relatedDocData = JSON.stringify(component.get("v.relatedDocData"));
        console.log('relatedDocDataClaimImages##-->'+relatedDocData);
        var action = component.get('c.getClaimsAutodoc');
        action.setParams({
            "Indexname":'u_keyed_claim',
            "docInputs":relatedDocData
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state@@@' + state);
            if (state == "SUCCESS") {
                var data = response.getReturnValue();
                if(data != null && data.isSuccess){
                    console.log('data##-->'+JSON.stringify(data));
                    var claimimagelist = component.get("v.claimImagesList");
                    for(var i=0;i<data.AttachmentsData.length;i++){
                        claimimagelist.push(data.AttachmentsData[i]);
                    }
                    //component.set("v.claimImagesList",data.AttachmentsData);
                    component.set("v.claimImagesList",claimimagelist);
                    console.log('claimImagesList@@@' + component.get("v.claimImagesList"));
                    if(data.totalRecords != 0){
                        component.set("v.claimImagesEmptyCheck",true);
                    }
                }
                else{
                    this.showToastMessage("We hit a snag.",data.errorMessage, "error", "dismissible", "30000");
                }
            }
            else if (state === "INCOMPLETE") {
                console.log("Failed to connect Salesforce!!");
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("error :"+errors[0].message);
                        }
                    }
                }
            this.hidettachmentSpinner(component, 'claimImages');
        });
        $A.enqueueAction(action);
    },
    getTOPSClaimImages: function(component, event, helper){
        var relatedDocData = JSON.stringify(component.get("v.relatedDocData"));
        console.log('relatedDocDataTopsClaimImages##-->'+relatedDocData);
        var TOPSinputs = {};
        TOPSinputs.MemberID = relatedDocData.MemberID;
        TOPSinputs.TIN = relatedDocData.TIN;
        TOPSinputs.policyNumber = relatedDocData.policyNumber;
        console.log('TOPSinputs'+TOPSinputs);
        var action = component.get('c.getClaimsAutodoc');
        action.setParams({
            "Indexname":'u_tops_purge',
            "docInputs":relatedDocData
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state@@@' + state);
            if (state == "SUCCESS") {
                var data = response.getReturnValue();
                if(data != null && data.isSuccess){
                    console.log('data##-->'+JSON.stringify(data));
                    var claimimagelist = component.get("v.claimImagesList");
                    for(var i=0;i<data.AttachmentsData.length;i++){
                        claimimagelist.push(data.AttachmentsData[i]);
                    }
                    //component.set("v.claimImagesList",data.AttachmentsData);
                    component.set("v.claimImagesList",claimimagelist);
                    console.log('claimImagesList@@@' + component.get("v.claimImagesList"));
                    if(data.totalRecords != 0){
                        component.set("v.claimImagesEmptyCheck",true);
                    }
                }
                else{
                    this.showToastMessage("We hit a snag.",data.errorMessage, "error", "dismissible", "30000");
                }
            }
            else if (state === "INCOMPLETE") {
                console.log("Failed to connect Salesforce!!");
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("error :"+errors[0].message);
                        }
                    }
                }
            this.hidettachmentSpinner(component,'claimImages');
        });
        $A.enqueueAction(action);
    },
    getCorrespondenceClaimImages: function(component, event, helper){
        var relatedDocData = JSON.stringify(component.get("v.relatedDocData"));
        console.log('relatedDocDataCorrespondenceClaimImages##-->'+relatedDocData);
        var TOPSinputs = {};
        TOPSinputs.MemberID = relatedDocData.MemberID;
        TOPSinputs.TIN = relatedDocData.TIN;
        TOPSinputs.policyNumber = relatedDocData.policyNumber;
        console.log('TOPSinputs'+TOPSinputs);
        var action = component.get('c.getClaimsAutodoc');
        action.setParams({
            "Indexname":'u_clm_corsp_lwso_doc',
            "docInputs":relatedDocData
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state@@@' + state);
            if (state == "SUCCESS") {
                var data = response.getReturnValue();
                if(data != null && data.isSuccess){
                    console.log('data##-->'+JSON.stringify(data));
                    var claimimagelist = component.get("v.claimImagesList");
                    for(var i=0;i<data.AttachmentsData.length;i++){
                        claimimagelist.push(data.AttachmentsData[i]);
                    }
                    //component.set("v.claimImagesList",data.AttachmentsData);
                    component.set("v.claimImagesList",claimimagelist);
                    console.log('claimImagesList@@@' + component.get("v.claimImagesList"));
                    if(data.totalRecords != 0){
                        component.set("v.claimImagesEmptyCheck",true);
                    }
                }
                else{
                    this.showToastMessage("We hit a snag.",data.errorMessage, "error", "dismissible", "30000");
                }
            }
            else if (state === "INCOMPLETE") {
                console.log("Failed to connect Salesforce!!");
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("error :"+errors[0].message);
                        }
                    }
                }
            this.hidettachmentSpinner(component,'claimImages');
        });
        $A.enqueueAction(action);
    },
    getProviderRemittanceAdvice : function(component, event, helper,Indexname){
        var relatedDocData = JSON.stringify(component.get("v.relatedDocData"));
        console.log('ProviderRemittanceAdvice##-->'+relatedDocData);
        var action = component.get('c.getClaimsAutodoc');
        action.setParams({
            "Indexname":Indexname,
            "docInputs":relatedDocData
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state@@@' + state);
            if (state == "SUCCESS") {
                var data = response.getReturnValue();
                if(data != null && data.isSuccess){
                    console.log('data##-->'+JSON.stringify(data));
                    var ProviderRemittanceAdviceList = component.get("v.ProviderRemittanceAdviceList");
                    for(var i=0;i<data.AttachmentsData.length;i++)
                    {
                        ProviderRemittanceAdviceList.push(data.AttachmentsData[i]);
                    }
                    
                    component.set("v.ProviderRemittanceAdviceList",ProviderRemittanceAdviceList);
                    console.log('ProviderRemittanceAdviceList@@@' + JSON.stringify(component.get("v.ProviderRemittanceAdviceList")));
                    if(data.totalRecords != 0){
                        component.set("v.praEmptyCheck",true);
                        console.log('test working here');
                    }
                }
                else{
                    this.showToastMessage("We hit a snag.",data.errorMessage, "error", "dismissible", "30000");
                }
            }
            else if (state === "INCOMPLETE") {
                console.log("Failed to connect Salesforce!!");
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("error :"+errors[0].message);
                        }
                    }
                }
            this.hidettachmentSpinner(component,'praspinner');
        });
        $A.enqueueAction(action);
    },
    showAttachmentSpinner: function (component,name) {
        var spinner = component.find(name);
        $A.util.removeClass(spinner, "slds-hide");
        $A.util.addClass(spinner, "slds-show");
    },
    hidettachmentSpinner: function (component,name) {
        var spinner = component.find(name);
        $A.util.removeClass(spinner, "slds-show");
        $A.util.addClass(spinner, "slds-hide");
    },
    
    showToastMessage: function (title, message, type, mode, duration) {
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
    getClaimImagesUNETGroup1: function (component,event,helper) {
        
        var serviceList=[];
        var topsPuerge={};
        topsPuerge.serviceName='LinkRelatedDocuments';
        topsPuerge.docClass='u_tops_purge';
        topsPuerge.inputParam=JSON.stringify(component.get("v.relatedDocData"));
        topsPuerge.createJSONBody=true;
        topsPuerge.outputFormat='Claim Documents';
        topsPuerge.docName='Claim Images';
        serviceList.push(topsPuerge);  
        
        var action = component.get('c.startRequest');
        action.setParams({
            "serviceCalloutInput":JSON.stringify(serviceList)
        });
        action.setCallback(this, function(response) {
            
            
            var state = response.getState();
            console.log('state@@@' + state);
            if (state == "SUCCESS") {
                var data = response.getReturnValue();
                if(data != null && data.isSuccess){
                    console.log('data##-->'+JSON.stringify(data));
                    var claimimagelist = component.get("v.claimImagesList");
                    for(var i=0;i<data.AttachmentsData.length;i++){
                        claimimagelist.push(data.AttachmentsData[i]);
                    }
                    //component.set("v.claimImagesList",data.AttachmentsData);
                    component.set("v.claimImagesList",claimimagelist);
                    console.log('claimImagesList@@@' + component.get("v.claimImagesList"));
                    if(data.totalRecords != 0){
                        component.set("v.claimImagesEmptyCheck",true);
                    }
                }
                else{
                    this.showToastMessage("We hit a snag.",data.errorMessage, "error", "dismissible", "30000");
                }
            }
            else if (state === "INCOMPLETE") {
                console.log("Failed to connect Salesforce!!");
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("error :"+errors[0].message);
                        }
                    }
                }
            this.hidettachmentSpinner(component,'claimImages');
        });
        $A.enqueueAction(action);
    },
    getClaimImagesUNETGroup2: function (component,event,helper) {
        
        var serviceList=[];
        var correspondenceClaimImages={};
        correspondenceClaimImages.serviceName='LinkRelatedDocuments';
        correspondenceClaimImages.docClass='u_clm_corsp_lwso_doc';
        correspondenceClaimImages.inputParam=JSON.stringify(component.get("v.relatedDocData"));
        correspondenceClaimImages.createJSONBody=true;
        correspondenceClaimImages.outputFormat='Claim Documents';
        correspondenceClaimImages.docName='Claim Images';
        serviceList.push(correspondenceClaimImages);
        
        
        var eDIClaimImages={};
        eDIClaimImages.serviceName='LinkRelatedDocuments';
        eDIClaimImages.docClass='u_edi_claim';
        eDIClaimImages.inputParam=JSON.stringify(component.get("v.relatedDocData"));
        eDIClaimImages.createJSONBody=true;
        eDIClaimImages.outputFormat='Claim Documents';
        eDIClaimImages.docName='Claim Images';
        serviceList.push(eDIClaimImages);
        
        var keyedClaimImages={};
        keyedClaimImages.serviceName='LinkRelatedDocuments';
        keyedClaimImages.docClass='u_keyed_claim';
        keyedClaimImages.inputParam=JSON.stringify(component.get("v.relatedDocData"));
        keyedClaimImages.createJSONBody=true;
        keyedClaimImages.outputFormat='Claim Documents';
        keyedClaimImages.docName='Claim Images';
        serviceList.push(keyedClaimImages);
        
        var action = component.get('c.startRequest');
        action.setParams({
            "serviceCalloutInput":JSON.stringify(serviceList),
            "docName":'Claim Images'
        });
        action.setCallback(this, function(response) {
            
            
            var state = response.getState();
            console.log('state@@@' + state);
            if (state == "SUCCESS") {
                var data = response.getReturnValue();
                if(data != null && data.isSuccess){
                    console.log('data##-->'+JSON.stringify(data));
                    var claimimagelist = component.get("v.claimImagesList");
                    for(var i=0;i<data.AttachmentsData.length;i++){
                        claimimagelist.push(data.AttachmentsData[i]);
                    }
                    //component.set("v.claimImagesList",data.AttachmentsData);
                    component.set("v.claimImagesList",claimimagelist);
                    console.log('claimImagesList@@@' + component.get("v.claimImagesList"));
                    if(data.totalRecords != 0){
                        component.set("v.claimImagesEmptyCheck",true);
                    }
                }
                else{
                    this.showToastMessage("We hit a snag.",data.errorMessage, "error", "dismissible", "30000");
                }
            }
            else if (state === "INCOMPLETE") {
                console.log("Failed to connect Salesforce!!");
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("error :"+errors[0].message);
                        }
                    }
                }
            this.hidettachmentSpinner(component,'claimImages');
        });
        $A.enqueueAction(action);
    },
    getClaimImagesOtherGroup1: function (component,event,helper) {
        
        var serviceList=[];
        var correspondenceClaimImages={};
        correspondenceClaimImages.serviceName='LinkRelatedDocuments';
        correspondenceClaimImages.docClass='u_clm_corsp_lwso_doc';
        correspondenceClaimImages.inputParam=JSON.stringify(component.get("v.relatedDocData"));
        correspondenceClaimImages.createJSONBody=true;
        correspondenceClaimImages.outputFormat='Claim Documents';
        correspondenceClaimImages.docName='Claim Images';
        serviceList.push(correspondenceClaimImages);
        
        
        var eDIClaimImages={};
        eDIClaimImages.serviceName='LinkRelatedDocuments';
        eDIClaimImages.docClass='u_edi_claim';
        eDIClaimImages.inputParam=JSON.stringify(component.get("v.relatedDocData"));
        eDIClaimImages.createJSONBody=true;
        eDIClaimImages.outputFormat='Claim Documents';
        eDIClaimImages.docName='Claim Images';
        serviceList.push(eDIClaimImages);
        
        var keyedClaimImages={};
        keyedClaimImages.serviceName='LinkRelatedDocuments';
        keyedClaimImages.docClass='u_keyed_claim';
        keyedClaimImages.inputParam=JSON.stringify(component.get("v.relatedDocData"));
        keyedClaimImages.createJSONBody=true;
        keyedClaimImages.outputFormat='Claim Documents';
        keyedClaimImages.docName='Claim Images';
        serviceList.push(keyedClaimImages);
        
        var action = component.get('c.startRequest');
        action.setParams({
            "serviceCalloutInput":JSON.stringify(serviceList)
        });
        action.setCallback(this, function(response) {
            
            
            var state = response.getState();
            console.log('state@@@' + state);
            if (state == "SUCCESS") {
                var data = response.getReturnValue();
                if(data != null && data.isSuccess){
                    console.log('data##-->'+JSON.stringify(data));
                    var claimimagelist = component.get("v.claimImagesList");
                    for(var i=0;i<data.AttachmentsData.length;i++){
                        claimimagelist.push(data.AttachmentsData[i]);
                    }
                    //component.set("v.claimImagesList",data.AttachmentsData);
                    component.set("v.claimImagesList",claimimagelist);
                    console.log('claimImagesList@@@' + component.get("v.claimImagesList"));
                    if(data.totalRecords != 0){
                        component.set("v.claimImagesEmptyCheck",true);
                    }
                }
                else{
                    this.showToastMessage("We hit a snag.",data.errorMessage, "error", "dismissible", "30000");
                }
            }
            else if (state === "INCOMPLETE") {
                console.log("Failed to connect Salesforce!!");
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("error :"+errors[0].message);
                        }
                    }
                }
            this.hidettachmentSpinner(component,'claimImages');
        });
        $A.enqueueAction(action);
    },
    getProviderRemittanceAdviceGroup1: function (component,event,helper,indexNameList){
        var serviceList=[];
        for(var i=0;i<indexNameList.length;i++){
            console.log('TestList##-->'+indexNameList[i]);
            var provEob={};
            provEob.serviceName = 'LinkRelatedDocuments';
            provEob.docClass = indexNameList[i];
            provEob.inputParam = JSON.stringify(component.get("v.relatedDocData"));
            provEob.createJSONBody = true;
            provEob.outputFormat = 'Claim Documents';
            provEob.docName = 'Provider Remittance Advice';
            serviceList.push(provEob);
        }
        
        var action = component.get('c.startRequest');
        action.setParams({
            "serviceCalloutInput":JSON.stringify(serviceList)
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state@@@' + state);
            if (state == "SUCCESS") {
                var data = response.getReturnValue();
                if(data != null && data.isSuccess){
                    console.log('data##-->'+JSON.stringify(data));
                    var ProviderRemittanceAdviceList = component.get("v.ProviderRemittanceAdviceList");
                    for(var i=0;i<data.AttachmentsData.length;i++){
                        ProviderRemittanceAdviceList.push(data.AttachmentsData[i]);
                    }
                    //component.set("v.claimImagesList",data.AttachmentsData);
                    component.set("v.ProviderRemittanceAdviceList",ProviderRemittanceAdviceList);
                    console.log('ProviderRemittanceAdviceList@@@' + component.get("v.ProviderRemittanceAdviceList"));
                    if(data.AttachmentsData.length != 0){
                        component.set("v.praEmptyCheck",true);
                    }
                }
                else{
                    this.showToastMessage("We hit a snag.",data.errorMessage, "error", "dismissible", "30000");
                }
            }
            else if (state === "INCOMPLETE") {
                console.log("Failed to connect Salesforce!!");
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("error :"+errors[0].message);
                        }
                    }
                }
            this.hidettachmentSpinner(component,'praspinner');
        });
        $A.enqueueAction(action);
        
    },
    getClaimLetters: function (component,event,helper,indexNameList){
        var serviceList=[];
        for(var i=0;i<indexNameList.length;i++){
            console.log('TestList##-->'+indexNameList[i]);
            var provEob={};
            provEob.serviceName = 'LinkRelatedDocuments';
            provEob.docClass = indexNameList[i];
            provEob.inputParam = JSON.stringify(component.get("v.relatedDocData"));
            provEob.createJSONBody = true;
            provEob.outputFormat = 'Claim Documents';
            provEob.docName = 'Claim Letters';
            serviceList.push(provEob);
        }
        
        var action = component.get('c.startRequest');
        action.setParams({
            "serviceCalloutInput":JSON.stringify(serviceList)
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state@@@' + state);
            if (state == "SUCCESS") {
                var data = response.getReturnValue();
                if(data != null && data.isSuccess){
                    console.log('data##-->'+JSON.stringify(data));
                    var ClaimLettersList = component.get("v.ClaimLettersList");
                    for(var i=0;i<data.AttachmentsData.length;i++){
                        ClaimLettersList.push(data.AttachmentsData[i]);
                    }
                    //component.set("v.claimImagesList",data.AttachmentsData);
                    component.set("v.ClaimLettersList",ClaimLettersList);
                    console.log('ClaimLettersList@@@' + component.get("v.ClaimLettersList"));
                    if(data.AttachmentsData.length != 0){
                        component.set("v.ClaimLettersCheck",true);
                    }
                }
                else{
                    this.showToastMessage("We hit a snag.",data.errorMessage, "error", "dismissible", "30000");
                }
            }
            else if (state === "INCOMPLETE") {
                console.log("Failed to connect Salesforce!!");
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("ClaimLettersCheck error:"+errors[0].message);
                        }
                    }
                }
            this.hidettachmentSpinner(component,'clspinner');
        });
        $A.enqueueAction(action);
        
    },
    getMemberEOB: function (component,event,helper,indexNameList){
        var serviceList=[];
        for(var i=0;i<indexNameList.length;i++){
            console.log('TestList##-->'+indexNameList[i]);
            var provEob={};
            provEob.serviceName = 'LinkRelatedDocuments';
            provEob.docClass = indexNameList[i];
            provEob.inputParam = JSON.stringify(component.get("v.relatedDocData"));
            provEob.createJSONBody = true;
            provEob.outputFormat = 'Claim Documents';
            provEob.docName = 'Member EOB';
            serviceList.push(provEob);
        }
        
        var action = component.get('c.startRequest');
        action.setParams({
            "serviceCalloutInput":JSON.stringify(serviceList)
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state@@@' + state);
            if (state == "SUCCESS") {
                var data = response.getReturnValue();
                if(data != null && data.isSuccess){
                    console.log('data##-->'+JSON.stringify(data));
                    var memberEOBList = component.get("v.memberEOBList");
                    for(var i=0;i<data.AttachmentsData.length;i++){
                        memberEOBList.push(data.AttachmentsData[i]);
                    }
                     component.set("v.memberEOBList",memberEOBList);
                    console.log('memberEOBList@@@' + component.get("v.memberEOBList"));
                    if(data.AttachmentsData.length != 0){
                        component.set("v.memberEOBCheck",true);
                    }
                }
                else{
                    this.showToastMessage("We hit a snag.",data.errorMessage, "error", "dismissible", "30000");
                }
            }
            else if (state === "INCOMPLETE") {
                console.log("Failed to connect Salesforce!!");
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("ClaimLettersCheck error:"+errors[0].message);
                        }
                    }
                }
            this.hidettachmentSpinner(component,'memspinner');
        });
        $A.enqueueAction(action);
        
    },
	navigateTodoc360GlobalURL: function (component,event,helper){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
           title : 'Warning',
            message:'You are being redirected to Doc360 to view your document.',
            duration:'20000',
            key: 'info_alt',
            type: 'warning',
           mode: "dismissible"
        });
        toastEvent.fire();
        
         var flnId = event.currentTarget.getAttribute("data-docId");
           var docType = event.currentTarget.getAttribute("data-document");
        var relatedDoc=[];
		var attchtypeext = '';														   
       
        if(docType=='attachment'){
           relatedDoc= component.get("v.AttachmentsList")[flnId];
			attchtypeext = ' Claim ' +docType+' was selected.';																				 
        }else if(docType=='image'){
            relatedDoc= component.get("v.claimImagesList")[flnId];
			attchtypeext = ' Claim ' +docType+' was selected.';																				  
        }else if(docType=='letter'){
            relatedDoc= component.get("v.ClaimLettersList")[flnId];
		attchtypeext = ' Claim ' +docType+' image was selected.';
        }else if(docType=='membereob'){
            relatedDoc= component.get("v.memberEOBList")[flnId];
            attchtypeext = ' Member EOB was selected.';
        }
        else if(docType=='providerremittance'){
            relatedDoc= component.get("v.ProviderRemittanceAdviceList")[flnId];
            attchtypeext = ' provider remittance advice image was selected.';
        }
        //AutoDoc
        var appEvent = $A.get("e.c:ACET_ClaimDocumentsAutoDocEvt");
                 appEvent.setParams({"attchName" : relatedDoc.DocID,
                                    "attchtypeext":attchtypeext});
                 appEvent.fire();
        
																 
        var action = component.get('c.generateDoc360URL');
        action.setParams({
            "doc360Input":JSON.stringify(relatedDoc)
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state == "SUCCESS") {
                var data = response.getReturnValue();
                if(data != null){
                    setTimeout(function(){
                    component.set("v.showWarning",true); 
                        window.open(data , '_blank');
                        }, 2500);
                }
                else{
                    this.showToastMessage("We hit a snag.",data.errorMessage, "error", "dismissible", "30000");
                }
            }
            else if (state === "INCOMPLETE") {
                console.log("Failed to connect Salesforce!!");
            }
                else if (state === "ERROR") {
                    
                }
            this.hidettachmentSpinner(component,'clspinner');
        });
        
        $A.enqueueAction(action);
    },

    getClaimImagesCNF: function (component,event,helper,indexNameList){
        var serviceList=[];
        for(var i=0;i<indexNameList.length;i++){
            var ClaimImages={};
            ClaimImages.serviceName = 'LinkRelatedDocuments';
            ClaimImages.docClass = indexNameList[i];
            ClaimImages.inputParam = JSON.stringify(component.get("v.relatedDocData"));
            ClaimImages.createJSONBody = true;
            ClaimImages.outputFormat = 'Claim Documents';
            ClaimImages.docName = 'Claim Images';
            serviceList.push(ClaimImages);
        }

        var action = component.get('c.startRequest');
        action.setParams({
            "serviceCalloutInput":JSON.stringify(serviceList)
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state@@@' + state);
            if (state == "SUCCESS") {
                var data = response.getReturnValue();
                if(data != null && data.isSuccess){
                    console.log('data##-->'+JSON.stringify(data));
                    var ClaimLettersList = component.get("v.claimImagesList");
                    for(var i=0;i<data.AttachmentsData.length;i++){
                        ClaimLettersList.push(data.AttachmentsData[i]);
                    }
                    component.set("v.claimImagesList",ClaimLettersList);
                    console.log('claimImagesList@@@' + component.get("v.claimImagesList"));
                    if(data.AttachmentsData.length != 0){
                        component.set("v.claimImagesEmptyCheck",true);
                    }
                }
                else{
                    //this.showToastMessage("We hit a snag.",data.errorMessage, "error", "dismissible", "30000");
                }
            }else if (state === "INCOMPLETE") {
                console.log("Failed to connect Salesforce!!");
            }else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("ClaimLettersCheck error:"+errors[0].message);
    }
                }
            }
        });
        $A.enqueueAction(action);

    },
})