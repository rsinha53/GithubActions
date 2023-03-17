({
    doInit: function(component, event, helper) {
        if (component.get("v.pageReference") != null) {
            var pagereference = component.get("v.pageReference");
            var memid = component.get("v.pageReference").state.c__memberid;
            var srk = component.get("v.pageReference").state.c__srk;
            var eid = component.get("v.pageReference").state.c__eid;
            var callTopic = component.get("v.pageReference").state.c__callTopic;
            var interaction = component.get("v.pageReference").state.c__interaction;
            var intId = component.get("v.pageReference").state.c__intId;
            var groupId = component.get("v.pageReference").state.c__gId;
            var uInfo = component.get("v.pageReference").state.c__userInfo;
            var hData = component.get("v.pageReference").state.c__hgltPanelData;
            var tabuniqueid = component.get("v.pageReference").state.c__tabuniqueid;
            component.set('v.parentPEOId',component.get("v.pageReference").state.c__parentPEOId);
            component.set("v.tabuniqueid", tabuniqueid);
            var bookOfBusinessTypeCode = '';
            if(component.get("v.pageReference").state.c__bookOfBusinessTypeCode != undefined){
                bookOfBusinessTypeCode = component.get("v.pageReference").state.c__bookOfBusinessTypeCode;
            }
            console.log('bookOfBusinessTypeCode',bookOfBusinessTypeCode);
            component.set('v.bookOfBusinessTypeCode',bookOfBusinessTypeCode);
             if(component.get("v.pageReference").state.c__bobcode != undefined){
               component.set("v.bobcode",component.get("v.pageReference").state.c__bobcode);  
             }
            var searchByClaimNumber = component.get("v.pageReference").state.c__searchByClaimNumber;
            if (searchByClaimNumber != null && searchByClaimNumber == true) {
                component.set("v.ChangeSearch", true);
                component.set("v.Claim_Number", component.get("v.pageReference").state.c__claimNumber);
            }
             var len = 10;
        var buf = [],
            chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789',
            charlen = chars.length,
            length = len || 32;
            
        for (var i = 0; i < length; i++) {
            buf[i] = chars.charAt(Math.floor(Math.random() * charlen));
        }
        var GUIkey = buf.join('');
        component.set("v.GUIkey",GUIkey);
            component.set('v.AutodocKey', GUIkey + 'viewClaims');
            
            component.set('v.grpNum', groupId);
            component.set('v.int', interaction);
            component.set('v.intId', intId);
            component.set('v.eid', eid);
            component.set('v.memberid', memid);
            component.set('v.srk', srk);
            console.log('hData :: ' + hData);
            console.log('hData 2:: ' + JSON.stringify(hData));
            console.log('===>@@@ ' +  interaction );
            component.set("v.usInfo", uInfo);
           
            var hghString = pagereference.state.c__hgltPanelDataString;
            hData = JSON.parse(hghString);
            component.set("v.highlightPanel", hData);
            helper.getuserinfo(component,event,helper);
        }
        document.onkeypress = function(event) {
            if (event.key === "Enter") {}
        };
        if (intId != undefined) {
            var childCmp = component.find("cComp");
            var memID = component.get("v.memberid");
            var GrpNum = component.get("v.grpNum");
            var bundleId = hData.benefitBundleOptionId;
            childCmp.childMethodForAlerts(intId, memID, GrpNum, '', bundleId);
        }
        var action = component.get('c.getDocTypes');
        console.log('hData.originatorRel' + hData.originatorRel);
        if (hData.originatorRel != null || hData.originatorRel != '' || hData.originatorRel != undefined) {
            var relationship = hData.originatorRel;
        } else {
            var relationship = '';
        }
        action.setParams({
            flow: "Member",
            isMemberFocus: true,
            relationship: relationship
        });
        // Set up the callback
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                //if successful stores query results in ipRecordTypes
                var docTypes = response.getReturnValue();
                console.log('getDocTypes returned: ' + docTypes);
                component.set('v.docTypeList', response.getReturnValue());
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
        });
        $A.enqueueAction(action);
        component.set("v.planEffEndLabel", $A.get("$Label.c.ACETDocumentPlanEffectiveEndDate"));
        component.set("v.planEffEndLabelOHM", $A.get("$Label.c.ACETDocumentPlanEffectiveEndDateOHM"));
        component.set("v.planEffEndLabelSBC", $A.get("$Label.c.ACETDocumentPlanEffectiveEndDateSBC"));
    },

    changeSearchFilters: function(component, event, helper) {
        component.set('v.displaySearchFields', false);
        helper.changeSearchFilters(component, event, helper);
    },

    onclick_Clear: function(component, event, helper) {
        helper.changeSearchFilters(component, event, helper);
        setTimeout(function() {
            var lsf = component.get('v.listSearchFilter');
            for (var i = 0; i < lsf.length; i++) {
                if (!lsf[i].Disabled__c) {
                    lsf[i].value = '';
                }
            }
            component.set('v.listSearchFilter', lsf);
            component.set('v.showResults', false);
        }, 50);
    },

    onclick_BulkResend: function(component, event, helper) {
        //fetch doc id from checked rows
        var checkedList = [];
        component.set("v.selectedDocIDs", checkedList)
        var checkedList = [];
        $("tbody").find("input.autodoc[type='checkbox']:checked").each(function(index) {
            checkedList.push($(this).parent().parent().find("#lnkDocId").text());
        });
        component.set("v.selectedDocIDs", checkedList);
        component.set("v.displayResendPopup", true);
    },
    onclick_Search: function(component, event, helper) {
        var docType = component.get('v.docTypeSelected');
        var fieldList = component.get('v.listSearchFilter');
        for (var i = 0; i < fieldList.length; i++) {
            if ((docType == 'Oxford SBC' || docType == 'Oxford Member Handbook') && fieldList[i].Document_Type_Field__r.Field_Type__c == 'Date' && (fieldList[i].value == null || fieldList[i].value == '')) {
                var inputCmp;
                var dateFlds = component.find('dateauraid');
                for (var j = 0; j < dateFlds.length; j++) {
                    inputCmp = dateFlds[j];
                    inputCmp.reportValidity();
                }
            }
        }
        var fieldType = component.get('v.listSearchFilter')
        var parameters = [];
        var textField = '';
        var dateField = '';
        var pickField = '';
        var requiredEmpty = false;
        for (var i = 0; i < fieldType.length; i++) {
            if (fieldType[i].Required__c == true && (fieldType[i].value == undefined || fieldType[i].value == null || fieldType[i].value == '')) {
                requiredEmpty = true;
                
            }
            if (fieldType[i].Document_Type_Field__c != null) {
                if (fieldType[i].Document_Type_Field__r.Field_Type__c == 'Text' || fieldType[i].Document_Type_Field__r.Field_Type__c == 'Alphanumeric_Special_Characters' || fieldType[i].Document_Type_Field__r.Field_Type__c == 'Alphanumeric') {
                    if (!$A.util.isEmpty(fieldType[i].value) && !$A.util.isUndefined(fieldType[i].value)) {
                        var parentPEOId = component.get('v.parentPEOId');
                        if(parentPEOId && fieldType[i].Document_Type_Field__r.Label=='Group Number' && 
                          (docType == 'Group Handbook' || docType == 'Member Handbook')){
                            textField = component.find(fieldType[i].Document_Type_Field__r.HP_Field_Name__c).get('v.value');
                        }
                        else{
                            textField = fieldType[i].value.replace(',', '{comma}');
                        }
                        if (!$A.util.isUndefined(fieldType[i].Document_Type_Field__r.WS_Field_Name__c)) {
                            textField += ',' + fieldType[i].Document_Type_Field__r.WS_Field_Name__c;
                        } else {
                            textField += ',';
                        }
                        if (!$A.util.isUndefined(fieldType[i].Document_Type_Field__r.Data_Type__c)) {
                            textField += ',' + fieldType[i].Document_Type_Field__r.Data_Type__c;
                        } else {
                            textField += ',';
                        }
                        if (!$A.util.isUndefined(fieldType[i].Document_Type_Field__r.Operator__c)) {
                            textField += ',' + fieldType[i].Document_Type_Field__r.Operator__c;
                        } else {
                            textField += ',';
                        }
                        parameters.push(textField);
                    }
                }
                if (fieldType[i].Document_Type_Field__r.Field_Type__c == 'Date' || fieldType[i].Document_Type_Field__r.Field_Type__c == 'Number') {
                    if ((!$A.util.isEmpty(fieldType[i].value) && !$A.util.isUndefined(fieldType[i].value))) {
                        dateField = fieldType[i].value;
                        if (!$A.util.isUndefined(fieldType[i].Document_Type_Field__r.WS_Field_Name__c)) {
                            dateField += ',' + fieldType[i].Document_Type_Field__r.WS_Field_Name__c;
                        } else {
                            dateField += ',';
                        }
                        if (!$A.util.isUndefined(fieldType[i].Document_Type_Field__r.Data_Type__c)) {
                            dateField += ',' + fieldType[i].Document_Type_Field__r.Data_Type__c;
                        } else {
                            dateField += ',';
                        }
                        if (!$A.util.isUndefined(fieldType[i].Document_Type_Field__r.Operator__c)) {
                            dateField += ',' + fieldType[i].Document_Type_Field__r.Operator__c;
                        } else {
                            dateField += ',';
                        }
                        parameters.push(dateField);
                    }
                }
                if (fieldType[i].Document_Type_Field__r.Field_Type__c == 'Picklist') {
                    if (!$A.util.isEmpty(fieldType[i].value) && !$A.util.isUndefined(fieldType[i].value)) {
                        if (fieldType[i].value != 'All') {
                            pickField = fieldType[i].value;
                            if (!$A.util.isUndefined(fieldType[i].Document_Type_Field__r.WS_Field_Name__c)) {
                                pickField += ',' + fieldType[i].Document_Type_Field__r.WS_Field_Name__c;
                            } else {
                                pickField += ',';
                            }
                            if (!$A.util.isUndefined(fieldType[i].Document_Type_Field__r.Data_Type__c)) {
                                pickField += ',' + fieldType[i].Document_Type_Field__r.Data_Type__c;
                            } else {
                                pickField += ',';
                            }
                            if (!$A.util.isUndefined(fieldType[i].Document_Type_Field__r.Operator__c)) {
                                pickField += ',' + fieldType[i].Document_Type_Field__r.Operator__c;
                            } else {
                                pickField += ',';
                            }
                            parameters.push(pickField);
                        }
                    }
                }
            }
        }

        if (requiredEmpty == false) {
            component.set('v.showResults', true);
            var params = JSON.stringify(parameters);
            console.log('SEARCHPARAMS>>>>>>' + params);
            helper.showResults(component, event, helper, docType, params);
        }else{
        	var dateFlds = component.find('dateauraid');
                for (var j = 0; j < dateFlds.length; j++) {
                    inputCmp = dateFlds[j];
                    inputCmp.reportValidity();
                }
                var nondateFlds = component.find('nondateauraid');
                for (var j = 0; j < nondateFlds.length; j++) {
                    inputCmp = nondateFlds[j];
                    inputCmp.reportValidity();
                }
        }
    },

    checkNumericFields: function(component, event, helper) {
        var fieldList = component.get('v.listSearchFilter');
        for (var i = 0; i < fieldList.length; i++) {
            if (fieldList[i].Document_Type_Field__r.Field_Type__c == 'Number') {
                if (fieldList[i].value != null) {
                    fieldList[i].value = fieldList[i].value.replace(/\D/g, '');
                }
            }
        }
        component.set('v.listSearchFilter', fieldList);
    },

    checkAlphanumericFields: function(component, event, helper) {
        var fieldList = component.get('v.listSearchFilter');
        for (var i = 0; i < fieldList.length; i++) {
            if (fieldList[i].Document_Type_Field__r.Field_Type__c == 'Alphanumeric' && fieldList[i].value != null) {
                var iChars = "~`!#$%^&*+=-[]\\\';,/{}|\":<>?";
                if (iChars.indexOf(fieldList[i].value.charAt(i)) == -1) {
                    fieldList[i].value = '';
                }
                //    fieldList[i].value = fieldList[i].value.replace(/[~`!#$%\^&*+=\-\[\]\\';,/{}|\\":<>\?]/,'');
            }
        }
    },

    handle_dt_initComplete_Event: function(component, event, helper) {
        var settings = event.getParam("settings");
                var userinfo = component.get("v.usInfo");
        if(userinfo.Profile.Name !='Research User'){
        setTimeout(function() {
            $("input.autodoc[type='checkbox']").click(function() {
                setTimeout(function() {
                    var numChecked = $("tbody").find("input.autodoc[type='checkbox']:checked").length;
                    if (numChecked > 1 ) {
                        component.set("v.disableBulkResend", false);
                    } else {
                        component.set("v.disableBulkResend", true);
                    }
                }, 30);
            });
        }, 30);
}
    },

    handle_dt_callback_Event: function(component, event, helper) {
        var settings = event.getParam("settings");
        var lgt_dt_table_ID = event.getParam("lgt_dt_table_ID");
    },

    handle_dt_createdRow_Event: function(component, event, helper) {
        var row = event.getParam("row");
        var data = event.getParam("data");
        var dataIndex = event.getParam("dataIndex");
        var docType = component.get('v.docTypeSelected');
        var docId;
        var docContentType;
        var docName;
        var docsize;
        var isDocSizeMoreThanOneMB;
        var srk = component.get("v.srk");
        var memID = component.get("v.memberID");
        if (data != null) {
            docId = data["DocumentId"];
            docContentType = data["cmis:contentStreamMimeType"];
            docName = data["cmis:contentStreamFileName"];
            docsize = parseInt(data["cmis:contentStreamLength"]);
            if (docsize) {
                isDocSizeMoreThanOneMB = (docsize / (1024 * 1024) >= 1 ? true : false);
            }
            var tableData = component.get('v.tableData');
            tableData.push(JSON.stringify(data));
        }
        console.log(data);
        $(row).children().first().html("<a id='lnkDocId' href='#'>" + docId + "</a>");
        $(row).children().first().on('click', function(e) {
            var workspaceAPI = component.find("workspace");
            var tabuniqueid = component.get("v.tabuniqueid"); 
            var pageReferenceobj = component.get("v.pageReference").state;
            workspaceAPI.getEnclosingTabId().then(function(enclosingTabId) {
                workspaceAPI.openSubtab({
                    parentTabId: enclosingTabId,
                    pageReference: {
                        "type": "standard__component",
                        "attributes": {
                            "componentName": "c__ACETLGT_Document"
                        },
                        "state": {
                            "c__docId": docId,
                            "c__docType": docType,
                            "c__docContentType": docContentType,
                            "c__docName": docName,
                            "c__docSize": docsize,
                            "c__isDocSizeMoreThanOneMB": isDocSizeMoreThanOneMB,
                            "c__performAction": "0",
                            "c__srk": srk,
                            "c__memberID": memID,
                            "c__userInfo": component.get("v.userInfo"),
                            "c__hgltPanelData": component.get("v.highlightPanelData"),
                            "c__selecteddoctype":component.get("v.selecteddoctype"),
                            "c__tabuniqueid":tabuniqueid,
                            "c__interaction":pageReferenceobj.c__interaction,
                            "c__intId":pageReferenceobj.c__intId,
                            "c__gId":pageReferenceobj.c__gId,
                            "c__eid":pageReferenceobj.c__eid,
                            "c__userInfo":pageReferenceobj.c__userInfo,
                            "c__fname":pageReferenceobj.c__fname,
                            "c__lname":pageReferenceobj.c__lname,
                            "c__va_dob":pageReferenceobj.c__va_dob,
                            "c__originatorval":pageReferenceobj.c__originatorval,
                            "c__hgltPanelDataString":pageReferenceobj.c__hgltPanelDataString,
                            "c__tabuniqueid":pageReferenceobj.c__tabuniqueid,
                            "c__callTopic":pageReferenceobj.c__callTopic,
                            "c__bookOfBusinessTypeCode":pageReferenceobj.c__bobcode
                        }
                    }
                }).then(function(response) {
                    workspaceAPI.getTabInfo({
                        tabId: response
                    }).then(function(tabInfo) {
                        workspaceAPI.setTabLabel({
                            tabId: tabInfo.tabId,
                            label: "Document - " + docId
                        });
                        workspaceAPI.setTabIcon({
                            tabId: tabInfo.tabId,
                            icon: "standard:display_text",
                            iconAlt: "Document"
                        });
                    });
                }).catch(function(error) {
                    console.log(error);
                });
            });
        });
    },

    handle_dt_pageNum_Event: function(component, event, helper) {},

    closeModal: function(component, event, helper) {
        //        component.set("v.displayResendPopup", false);
        helper.closeModal(component, event, helper);
    },

    fireRedeliverService: function(component, event, helper) {
        //TODO build redeliver event -- send memberAdd obj and addressTypeSelected to redelivery service
        var memberAdd = component.get("v.memberAdd");
        var addTypeSelected = component.get("v.addressTypeSelected");
        var action = component.get("c.resendSelectedDocs");
        var personEncoded = JSON.stringify(memberAdd);
        var docIds = component.get("v.selectedDocIDs");
        var docType = component.get("v.selecteddoctype");
        var bobcode = component.get("v.bobcode");
        //    	alert(docIds);
        action.setParams({
            docIds: docIds,
            AddOnFilePersonWrapString: personEncoded,
            selectAddress: addTypeSelected,
            documentClass: docType,
            bookOfBusinessTypeCode:bobcode
        });
        action.setCallback(this, function(response) {
            helper.closeModal(component, event, helper);
            component.set("v.Loadingspinner", false);
            var state = response.getState();
            //			alert(state);
            if (state === "SUCCESS") {
                //				alert(response.getReturnValue());
                //TODO add message for if resultList is empty, and regular result handling messages
                var messageList = JSON.parse(response.getReturnValue());
                //				alert(response.getReturnValue());
                //				alert(messageList);
                if (messageList == null || messageList.length == 0) {
                    helper.toastmessagehelper(component, event, helper, 'Error', 'Unexpected error occurred. Please try again. If problem persists, please contact the help desk.', 'error');
                } else {
                    for (var i = 0; i < messageList.length; i++) {
                        if (messageList[i].includes('Problem with Document Delivery Webservice')) {
                            helper.toastmessagehelper(component, event, helper, 'Error', messageList[i], 'error');
                        } else {
                            helper.toastmessagehelper(component, event, helper, 'Success', messageList[i], 'success');
                        }
                    }
                }
            } else {
                console.log(response.getError()[0].message);
                helper.toastmessagehelper(component, event, helper, 'Error', 'Unexpected error occurred. Please try again. If problem persists, please contact the help desk.', 'error');
            }
        });
        component.set("v.Loadingspinner", true);
        $A.enqueueAction(action);
    },
    handledocsupportevent: function(component, event, helper) {
        var docId = event.getParam("docId");
            component.set("v.selectedDocIDs", docId);
                component.set("v.displayResendPopup",true);
    }
})