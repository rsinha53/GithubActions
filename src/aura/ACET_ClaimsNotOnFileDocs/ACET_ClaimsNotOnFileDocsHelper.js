({
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
        
        var action = component.get('c.getClaimNotOnFileDoc');
        action.setParams({
            "serviceCalloutInput":JSON.stringify(serviceList),
            "isClaimNotOnFile":true
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state@@@' + state);
            this.getClaimNotOnFileDoc(component,event,helper)
            if (state == "SUCCESS") {
                var data = response.getReturnValue();
                if(data != null && data.isSuccess){
                    console.log('data##-->'+JSON.stringify(data));
                    var ClaimLettersList = component.get("v.ClaimLettersList");
                    for(var i=0;i<data.AttachmentsData.length;i++){
                        ClaimLettersList.push(data.AttachmentsData[i]);
                    }
                    component.set("v.ClaimLettersList",ClaimLettersList);
                    console.log('ClaimLettersList@@@' + component.get("v.ClaimLettersList"));
                    if(data.AttachmentsData.length != 0){
                        component.set("v.ClaimLettersCheck",true);
                    }
                }
                else{
                    this.showToastMessage("We hit a snag.",data.errorMessage, "error", "dismissible", "30000");
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
    getClaimNotOnFileDoc: function (component,event,helper) {
        var serviceList=[];
        //for(var i=0;i<indexNameList.length;i++){
            var provEob={};
            provEob.serviceName = 'LinkRelatedDocuments';
            provEob.docClass = 'u_prov_attch';
            provEob.inputParam = JSON.stringify(component.get("v.relatedDocData"));
            provEob.createJSONBody = true;
            provEob.outputFormat = 'Claim Documents';
            provEob.docName = 'Attachments';
            serviceList.push(provEob);
        //}
        
        var action = component.get('c.getClaimNotOnFileDoc');
        action.setParams({
            "serviceCalloutInput":JSON.stringify(serviceList),
            "isClaimNotOnFile":true
        });
       action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state@@@' + state);
            if (state == "SUCCESS") {
                var data = response.getReturnValue();
                if(data != null && data.isSuccess){
                    console.log('data##-->'+JSON.stringify(data));
                    var AttachmentsList = component.get("v.ClaimLettersList");
                    for(var i=0;i<data.AttachmentsData.length;i++){
                        AttachmentsList.push(data.AttachmentsData[i]);
                    }
                     component.set("v.ClaimLettersList",AttachmentsList);
                    //console.log('AttachmentsList@@@' + AttachmentsList);
                    if(data.AttachmentsData.length != 0){
                        //component.set("v.attachmentEmptyCheck",true);
                    }
                }
                else{
                    this.showToastMessage("We hit a snag.",data.errorMessage, "error", "dismissible", "30000");
                }
            }
            else if (state === "INCOMPLETE") {
                console.log("Failed to connect Salesforce!!");
            }else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("ClaimLettersCheck error:"+errors[0].message);
                    }
                }
            }
           this.createTableData(component);
            helper.hideSpinner(component, event, helper);
        });
        $A.enqueueAction(action);
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
        var data = event.getParam("selectedRows");
        var currentRowIndex = event.getParam("currentRowIndex");
        
        //var flnId = event.currentTarget.getAttribute("data-docId");
        //var docType = event.currentTarget.getAttribute("data-document");
        var relatedDoc=[];
        
        relatedDoc= component.get("v.ClaimLettersList")[currentRowIndex];
        
        /*if(docType=='attachment'){
            relatedDoc= component.get("v.AttachmentsList")[flnId];
        }else if(docType=='image'){
            relatedDoc= component.get("v.claimImagesList")[flnId];
        }else if(docType=='letter'){
            relatedDoc= component.get("v.ClaimLettersList")[flnId];
        }*/
        //AutoDoc
        /*var appEvent = $A.get("e.c:ACET_ClaimDocumentsAutoDocEvt");
        appEvent.setParams({
            "attchName" : relatedDoc.DocID,
            "attchtypeext":' Claim ' +docType+' was selected.'
        });
        appEvent.fire();*/
        
        
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
            }else if (state === "INCOMPLETE") {
                console.log("Failed to connect Salesforce!!");
            }else if (state === "ERROR") {
                console.log("ERROR on navigateTodoc360GlobalURL");
            }
            
            helper.hideSpinner(component, event, helper);
        });
        $A.enqueueAction(action);
    },
    // New AutoDoc
    createTableData: function (cmp) {
        var CNFDocsTableData = new Object();
        var currentIndexOfOpenedTabs = cmp.get("v.currentIndexOfOpenedTabs");
        var maxAutoDocComponents = cmp.get("v.maxAutoDocComponents");
        var claimNo=cmp.get("v.claimNo");
        CNFDocsTableData.type = 'table';
        
        CNFDocsTableData.componentOrder = 20;
        CNFDocsTableData.componentName = 'Documents: '+claimNo;
        CNFDocsTableData.autodocHeaderName = 'Documents: '+claimNo;
        
        CNFDocsTableData.tableHeaders = ['LETTER DATE',
                                       'FLN #/ DOC ID',
                                       'TYPE',
                                       'PAGE COUNT'
                                      ];
        CNFDocsTableData.caseItemsEnabled = false;
        CNFDocsTableData.hideResolveColumn = false;
        var selectedRows = [];
        CNFDocsTableData.selectedRows = selectedRows;
        var tableRows = [];
        var CNFDocsList = cmp.get("v.ClaimLettersList");
        var autodocSubId = cmp.get("v.autodocUniqueIdCmp");
        
        var autoCheck = false;
        var newrefferalNumber = cmp.get("v.newReferralNumber");
        var selectedRows = cmp.get("v.selectedRows");
        if(!$A.util.isUndefinedOrNull(CNFDocsList) && !$A.util.isEmpty(CNFDocsList)){
            CNFDocsList.forEach(pcpref => {
                var tableRow = new Object();
                tableRow.checked = false;
                tableRow.resolved = false;
                tableRow.uniqueKey = pcpref.DocID;
                tableRow.caseItemsExtId = pcpref.referralId;
                var rowColumnData = [];
                
                rowColumnData.push(setRowColumnData('outputText', !$A.util.isEmpty(pcpref.ReceivedDate) ? pcpref.ReceivedDate : '--' ));
                rowColumnData.push(setRowColumnData('link', !$A.util.isEmpty(pcpref.DocID) ? pcpref.DocID : '--' ));
                rowColumnData.push(setRowColumnData('outputText', !$A.util.isEmpty(pcpref.Type) ? pcpref.Type : '--' ));
                rowColumnData.push(setRowColumnData('outputText', !$A.util.isEmpty(pcpref.PageCount) ? pcpref.PageCount : '--' ));
                
                tableRow.rowColumnData = rowColumnData;
                
                tableRows.push(tableRow);
            });
            
            CNFDocsTableData.tableBody = tableRows;
        }else{
            var tableRow = new Object();
            tableRow.checked = false;
            tableRow.resolved = false;
            tableRow.uniqueKey = '';
            tableRow.caseItemsExtId = '';
            var rowColumnData = [];
            rowColumnData.push(setRowColumnData('outputText', ''));
            rowColumnData.push(setRowColumnData('outputText', 'No Recent Results Found'));
            rowColumnData.push(setRowColumnData('outputText',''));
            rowColumnData.push(setRowColumnData('outputText', ''));
            tableRow.rowColumnData = rowColumnData;
            tableRows.push(tableRow);
            CNFDocsTableData.tableBody = tableRows;
            autoCheck = true;
        }
        
        cmp.set("v.CNFDocsTableData", CNFDocsTableData);

        function setRowColumnData(ft, fv) {
            var rowColumnData = new Object();
            rowColumnData.fieldType = ft;
            rowColumnData.fieldValue = fv;
            if ('link' == ft) {
                rowColumnData.isLink = true;
            } else if ('outputText' == ft) {
                rowColumnData.isOutputText = true;
            } else if ('isStatusIcon' == ft) {
                rowColumnData.isIcon = true;
            } else {
                rowColumnData.isOutputText = true;
            }
            return rowColumnData;
        }
        
    },
    showSpinner: function (component, event, helper) {
        var spinner = component.find("lookup-spinner");
        $A.util.removeClass(spinner, "slds-hide");
        $A.util.addClass(spinner, "slds-show");
    },

    hideSpinner: function (component, event, helper) {
        var spinner = component.find("lookup-spinner");
        $A.util.removeClass(spinner, "slds-show");
        $A.util.addClass(spinner, "slds-hide");
    },
})