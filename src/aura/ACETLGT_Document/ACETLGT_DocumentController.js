({
    doInit: function(component, event, helper) {
        component.set('v.docUrl',null);
        if (component.get("v.pageReference") != null) {
            var importState = component.get("v.pageReference").state;
            component.set('v.docId', importState.c__docId);
            component.set('v.docType', importState.c__docType);
            component.set('v.docContentType', importState.c__docContentType);
            component.set('v.docName', importState.c__docName);
            component.set('v.docSize', importState.c__docSize);
            component.set('v.isDocSizeMoreThanOneMB', importState.c__isDocSizeMoreThanOneMB);
            component.set('v.performAction', importState.c__performAction);
            component.set('v.memberID', importState.c__memberID);
            component.set('v.srk', importState.c__srk);
            component.set("v.isIdCard", importState.c__isIdCard);
            component.set("v.selecteddoctype", importState.c__selecteddoctype);
            component.set("v.bookOfBusinessTypeCode",importState.c__bookOfBusinessTypeCode);
            var uInfo = component.get("v.pageReference").state.c__userInfo;
            
            var hData = component.get("v.pageReference").state.c__hgltPanelData;
            console.log('hData :: ' + hData);
            console.log('hData 2:: ' + JSON.stringify(hData));
            if(uInfo != null){
                component.set("v.usInfo", uInfo);
            }
            if(hData != null){
                component.set("v.highlightPanel", hData);
            }
            if (importState.c__docType != null) {
                var docType = importState.c__docType;
                if (docType == 'Renewal Letter' || docType == 'Renewal Package' || docType == 'Employer Letter' || docType == 'Summary Plan Description') {
                    component.set('v.displayResendBtn', false);
                }
                if (docType == 'Member EOB') {
                    component.set('v.subOnly', true);
                }
            }
            helper.fetchDoc(component, event, helper);
        }
        if (component.get('v.memberID') != null || component.get('v.srk') != null) {
            var action = component.get("c.findMemberInfo");
            action.setParams({
                memberId: component.get('v.memberID'),
                SRK: component.get('v.srk'),
                documentType: component.get('v.docType')
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    component.set("v.memberAdd", JSON.parse(response.getReturnValue()));
                    var addInfo = component.get("v.memberAdd");
                    //if address wrap comes back empty, show not found message
                    if ((addInfo.personFirstName == null || addInfo.personFirstName == '') && (addInfo.personMiddleName == null || addInfo.personMiddleName == '') && (addInfo.personLastName == null || addInfo.personLastName == '') && (addInfo.personSuffix == null || addInfo.personSuffix == '') && (addInfo.personAddOne == null || addInfo.personAddOne == '') && (addInfo.personAddTwo == null || addInfo.personAddTwo == '') && (addInfo.personCity == null || addInfo.personCity == '') && (addInfo.personState == null || addInfo.personState == '') && (addInfo.personZipCode == null || addInfo.personZipCode == '') && (addInfo.personOrganization == null || addInfo.personOrganization == '')) {
                        component.set("v.notFoundMessage", true);
                    }
                    if(addInfo.userprofilename =='Research User'){
                        component.set("v.disableResend",true);                
                    }
                    //Set Middle Intial
                    if((addInfo.personMiddleName != null || addInfo.personMiddleName != '')){
                    var pMiddleName = (addInfo.personMiddleName.length > 1) ? addInfo.personMiddleName.charAt(0) : addInfo.personMiddleName;
                    component.set("v.personMiddleIntial", pMiddleName);
                    }
                    if((addInfo.personMiddleNameAA != null || addInfo.personMiddleNameAA != '')){
                    var pMiddleNameAA = (addInfo.personMiddleNameAA.length > 1) ? addInfo.personMiddleNameAA.charAt(0) : addInfo.personMiddleNameAA;
                    component.set("v.personMiddleIntialAA", pMiddleNameAA);
                    }
                } else {
                    component.set("v.notFoundMessage", true);
                }
            });
            $A.enqueueAction(action);
            
            /*var workspaceAPI = component.find("workspace");
            workspaceAPI.getFocusedTabInfo().then(function(response) {
                var focusedTabId = response.tabId;
                workspaceAPI.setTabLabel({
                    tabId: focusedTabId,
                    label: "Document - " + component.get('v.docId')
                });
                workspaceAPI.setTabIcon({
                    tabId: focusedTabId,
                    icon: "standard:display_text",
                    iconAlt: "Document"
                });
            });*/
            
        }
    },
    resendButtonClick: function(component, event, helper) {
        
        var pageReferenceobj =  component.get("v.pageReference").state;
        if(pageReferenceobj.c__callTopic =='Communications'){
            helper.resendButtonClickhelper(component, event, helper);
        }else{
            component.set("v.displayResendPopup", true);
            var iframedivcmp = component.find('iframediv');
            $A.util.addClass(iframedivcmp, 'slds-hide');
            $A.util.removeClass(iframedivcmp, 'slds-show'); 
            
        }
    },
    
    closeModal: function(component, event, helper) {
        helper.closeModal(component, event, helper);
    },
    
    fireRedeliverService: function(component, event, helper) {
        //TODO build redeliver event -- send memberAdd obj and addressTypeSelected to redelivery service
        var memberAdd = component.get("v.memberAdd");
        var addTypeSelected = component.get("v.addressTypeSelected");
        var action = component.get("c.resendSelectedDocs");
        var personEncoded = JSON.stringify(memberAdd);
        action.setParams({
            AddOnFilePersonWrapString: personEncoded,
            documentId: component.get("v.docId"),
            selectAddress: addTypeSelected,
            documentClass: component.get("v.selecteddoctype"),
            bookOfBusinessTypeCode:component.get("v.bookOfBusinessTypeCode")
        });
        action.setCallback(this, function(response) {
            helper.closeModal(component, event, helper);
            component.set("v.Loadingspinner", false);
            var state = response.getState();
            //			alert(state);
            if (state === "SUCCESS") {
                //                alert(response.getReturnValue());
                var resp = response.getReturnValue();
                
                if (resp.includes('Problem with Document Delivery Webservice')) {
                    helper.toastmessagehelper(component, event, helper, 'Error', resp, 'error');
                } else {
                    helper.toastmessagehelper(component, event, helper, 'Success', resp, 'success');
                }
            } else {
                alert(response.getError()[0].message);
                //				console.error(response.getError()[0].message);
                helper.toastmessagehelper(component, event, helper, 'Error', 'Unexpected error occurred. Please try again. If problem persists, please contact the help desk.', 'error');
            }
        });
        component.set("v.Loadingspinner", true);
        $A.enqueueAction(action);
    }
    
})