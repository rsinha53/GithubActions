({
    openCommentsBox : function (cmp, event) {
        cmp.set("v.showComments",true);
        let button = event.getSource();
        button.set('v.disabled',true);
    },
    
    togglePopup : function(cmp, event) {
        let showPopup = event.currentTarget.getAttribute("data-popupId");
        cmp.find(showPopup).toggleVisibility();
    },
    
    handleKeyup : function(cmp) {
        var inputCmp = cmp.find("commentsBoxId");
        var value = inputCmp.get("v.value");
        var max = 2000;
        var remaining = max - value.length;
        cmp.set('v.charsRemaining', remaining);
        var errorMessage = 'Error!  You have reached the maximum character limit.  Add additional comments in Case Details as a new case comment.';
        if (value.length >= 2000) {
            inputCmp.setCustomValidity(errorMessage);
            inputCmp.reportValidity();
        } else {
            inputCmp.setCustomValidity('');
            inputCmp.reportValidity();
        }
    },
	
    doInit: function(cmp, event, helper) {
        let today = new Date();
        cmp.set("v.authTableClsName", 'authRes'+today.getTime());
        cmp.set("v.btnClsName", 'ibaag'+today.getTime()); 
        cmp.set("v.btnAutodocId", 'btnAutodoc'+today.getTime());
        //US2718111: View Authorizations - Switching Policies and Auto Doc  - Praveen - 6th Jul 2020
        var caseNotSavedTopics = cmp.get("v.caseNotSavedTopics");
        if(!caseNotSavedTopics.includes("View Authorizations")){
            caseNotSavedTopics.push("View Authorizations");
        }
        cmp.set("v.caseNotSavedTopics", caseNotSavedTopics);
        // DE373867 - Thanish - 8th Oct 2020
        if(cmp.get("v.isHippaInvokedInProviderSnapShot")){
            var cardDetails = new Object();
            cardDetails.componentName = "HIPAA Guidelines";
            cardDetails.componentOrder = 0;
            cardDetails.noOfColumns = "slds-size_1-of-1";
            cardDetails.type = "card";
            cardDetails.allChecked = false;
            cardDetails.cardData = [
                {
                    "checked": true,
                    "disableCheckbox": true,
                    "fieldName": "HIPAA Guidelines",
                    "fieldType": "outputText",
                    "fieldValue": "Accessed"
                }
            ];
            _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"), cmp.get("v.autodocUniqueId") + 0, cardDetails);
        }

        helper.setDefaultAutodoc(cmp, true); // DE492464 - Thanish 23rd Sept 2021
     },

    handleAuthStatus: function(cmp, event, helper) {


        var authstatusId = event.currentTarget.getAttribute("data-auth-status");

        var authStatusList = cmp.get("v.authStatusList");
        var IsFound = false;
        for (var i = 0; i < authStatusList.length; i++) {
            if (authStatusList[i].get('v.compName') != undefined && authStatusList[i].get('v.compName') != null
            && authStatusList[i].get('v.compName') == authstatusId) {
                IsFound = true;
                break;
            }
        }

        if(!IsFound){

            // US2271237 - View Authorizations - Update Policies in Auto Doc : Kavinda
            helper.showAuthResultSpinner(cmp);
            cmp.set('v.AutodocPageFeatureMemberDtl', cmp.get('v.AutodocPageFeature'));
            // US2442658
            cmp.set("v.AutodocKeyMemberDtl", cmp.get("v.AutodocKey"));

            helper.getAuthStatusDetails(cmp, event, helper, authstatusId);

            // US2618180
            helper.fireCallTopicAutodoc(cmp, event, helper);
        }
    },

    tblSearchTextChange: function(cmp, event, helper) {
        var tblSearchText = cmp.get('v.tblSearchText');
        var dataTblId = ('#' + cmp.get('v.dataTblId'));
        var table = $(dataTblId).DataTable();
        table.search(tblSearchText).draw();

        // DE301355
        if (tblSearchText ==  undefined || tblSearchText == '' || tblSearchText.length == 0){
            $('.authstatuslink').addClass('resetLinks');
        }

    },

    //TTS Modal Case Creation : US1852201 : START
    openModal: function(component, event, helper) {
        // US2536127 - Avish
        helper.handleSaveModal(component, event, helper);
    },

    // US2536127 - Avish
    handleSavePopUp: function(component, event, helper) {
        debugger;
        if(event.getParam("memberTabId") == component.get("v.memberTabId") && event.getParam("showPopUp")) {
            helper.handleSaveModal(component, event, helper);
        }
    },

    closeModal: function(component, event, helper) {
        // Set isModalOpen attribute to false
        component.set("v.isModalOpen", false);

    },

    // US2263100 - View Authrizations and Notifications - Results and Status Wrap Text UI
    handleAuthorizationStatusClose: function(cmp, event, helper) {
        var memberTabId = cmp.get('v.memberTabId');
        var tabId = event.getParam("tabId");
        var authCompId = event.getParam("authCompId");
        if(memberTabId == tabId){
            helper.removeStatusComponent(cmp, event, helper, authCompId);
            helper.handleLinkEnable(cmp,authCompId);

            // DE32622
            // $('#' + authCompId + 'link').closest("tr").removeClass('highlight');

            // // DE301355
            // if (!$A.util.isUndefinedOrNull(document.getElementById(authCompId + 'link'))) {
            //     document.getElementById(authCompId + 'link').style.pointerEvents = "auto";
            //     document.getElementById(authCompId + 'link').style.cursor = "pointer";
            //     document.getElementById(authCompId + 'link').style.color = "#006dcc";
            // }
        }
    },

    columnOptionsChange: function(cmp, event) {
        var selectedColumn = cmp.get('v.selectedColumn');
        var selectedOption = cmp.get('v.selectedOption');
        var columnOptions = cmp.get('v.columnOptions');
        columnOptions[selectedColumn] = selectedOption;
        cmp.set('v.columnOptions', columnOptions);
    },

    policyDataChange: function (cmp, event, helper) {
        cmp.set('v.isBtnAutodoc','true');
        //US2253899
        // US2619791 Performance Improvement - View Authorizations - Sarma - 10/06/2020
        cmp.set('v.isInitialCall',true);
        cmp.set('v.isAllActive',false);
        cmp.set('v.isAllAuthReceived',false);
        // US2683494 Performance Improvement - View Authorizations Results - Switching Policies
        cmp.set('v.isNoRecordsFound',false);
        cmp.set('v.isNoRecordsFoundTemp',false);

        helper.showAuthResultSpinner(cmp);
        let authStatusList = cmp.get("v.authStatusList");
        authStatusList = [];

        helper.findAuthorizationResults(cmp, helper);
        helper.setDefaultAutodoc(cmp, true); // DE492464 - Thanish 23rd Sept 2021


        var ACET_AuthResultAutoDocActivation = $A.get("e.c:ACET_AuthResultAutoDocActivation");
        ACET_AuthResultAutoDocActivation.fire();

        // US2566675 FF - Create SRN Button Functionality with Error ICUE is Down - Enhancements - Sarma
        helper.getDowntimFormDetails(cmp, helper);

    },
/*
    // US2536127 - Avish
    createAuth:function(cmp,event,helper){

        // Create SRN Clicked
        var srnCard = new Object();
        srnCard.type = 'card';
        srnCard.componentName = 'Create SRN';
        srnCard.noOfColumns = 'slds-size_6-of-12';
        srnCard.componentOrder = 2.5;
        var cardData = [];
        cardData.push(new fieldDetails(true,false,true,'Create SRN','Accessed','outputText'));
        srnCard.cardData = cardData;
        var autodocSubId = cmp.get("v.autodocUniqueId") + cmp.get("v.policySelectedIndex");
        _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"),autodocSubId, srnCard);
        function fieldDetails(c, dc, sc, fn, fv, ft) {
            this.checked = c;
            this.defaultChecked = dc;
            this.showCheckbox = sc;
            this.fieldName = fn;
            this.fieldValue = fv;
            this.fieldType = ft;
            this.isReportable = true; // US2808753 - Thanish - 12th Oct 2020
        }
        // End

        cmp.get("v.memberId");
        cmp.get("v.FirstName");
        cmp.get("v.LastName");

        // Moving Icue opening codes to helper
        // New Public group for Create Auth Pilot - Sarma - 28/10/2020
        helper.showAuthResultSpinner(cmp);
        if(cmp.get("v.SRNFlag")){
            helper.handleShowModal(cmp,event.getSource().get("v.name"),true);
            helper.hideAuthResultSpinner(cmp);
        }else{
            helper.openICUE(cmp,helper);
        }

    },*/
    // US2423798 Preview Auto Doc Before Save Case - View Authorizations - Sarma - 27/4/2020
    openPreview: function (component, event, helper) {
        var defaultAutoDoc = helper.getAutoDocObject(component);
        component.set("v.tableDetails_prev",defaultAutoDoc);
        component.set("v.isPreviewOpen", true);
    },

    // DE322503 - Resetting button autodoc during case save - Sarma
    resetBtnAutodoc: function (cmp,event) {
        // var originPage = event.getParam("AutodocPageFeature");
        // if (originPage == cmp.get('v.AutodocPageFeature')) {
        //     var authTableClsName = cmp.get("v.authTableClsName");
        //     var btnClsName = cmp.get("v.btnClsName");
        //     var btnAutodocId = cmp.get("v.btnAutodocId");
        //     document.getElementsByClassName(btnClsName)[0].removeAttribute("data-auto-doc-section-key");
        //     document.getElementsByClassName(authTableClsName)[0].setAttribute("data-auto-doc-section-key", 'Authorization Results');
        //     document.getElementById(btnAutodocId).getElementsByTagName('input')[0].checked = false;
        //     cmp.set("v.isCreateSrnBtnClicked", false);
        //     cmp.set('v.enableAutodocWarningMessage', true);
        // }
    },

    // DE32622
    selectRow: function (cmp, event) {
        var row = event.currentTarget.getAttribute("data-row-index");
        $('#tr'+row).find('input:checkbox').each(function() {
            if (this.className == 'autodoc') {
                this.checked = (!this.checked);
                if(this.checked){
                    $(event.target).closest("tr").addClass('highlight');
                } else {
                    $(event.target).closest("tr").removeClass('highlight');
                }
            }
        });
    },
    // US2619791 Performance Improvement - View Authorizations - Sarma - 10/06/2020
    // US2683494 Performance Improvement - View Authorizations Results - Switching Policies - Updating logic
    activateAllAuth: function (cmp, event , helper) {
        if(!cmp.get('v.isInitialCall')){
            if(!cmp.get('v.isAllAuthReceived')){
                helper.showAuthResultSpinner(cmp);

                helper.findAuthorizationResults(cmp, helper);

                cmp.set('v.isAllAuthReceived', true);
            }
            else{

                    helper.showAuthResultSpinner(cmp);
                    // variables for swapping auth details
                    var authResults = cmp.get('v.authResults');
                    var authResultsTemp = cmp.get('v.authResultsTemp');

                    // swapping auth details
                    var temp = new Array();
                    temp = authResults;
                    authResults = authResultsTemp;
                    authResultsTemp = temp;
                    cmp.set('v.authResults', authResults);
                    cmp.set('v.authResultsTemp', authResultsTemp);
                    // swapping no Records found bool vals
                    var temp2 = cmp.get('v.isNoRecordsFound');
                    cmp.set('v.isNoRecordsFound', cmp.get('v.isNoRecordsFoundTemp'));
                    cmp.set('v.isNoRecordsFoundTemp', temp2);

                helper.createTableData(cmp);

                    // callinf init auth table & hiding spinner
                // helper.initAuthTable(cmp, helper);
            }

        }
    },
    //US2718111: View Authorizations - Switching Policies and Auto Doc - Praveen
        handleACETCaseCreated: function (cmp, event) {
            var caseNotSavedTopics = cmp.get("v.caseNotSavedTopics");
            var index = caseNotSavedTopics.indexOf("View Authorizations");
            if(index >= 0){
                caseNotSavedTopics.splice(index, 1);
            }
            cmp.set("v.caseNotSavedTopics", caseNotSavedTopics);
        },
        //US2718111: View Authorizations - Switching Policies and Auto Doc - Praveen
            handlePolicySwithchAuthDetailsClose: function (cmp, event) {
                var memtabuniqueId = event.getParam("memberTabId");

                if(memtabuniqueId === cmp.get('v.memberTabId')){
                    var authStatusList = cmp.get("v.authStatusList");
                    authStatusList = [];
                    cmp.set("v.authStatusList", authStatusList);

                    var workspaceAPI = cmp.find("workspace");
                    workspaceAPI.getAllTabInfo().then(function(response) {
                        var mapOpenedTabs = cmp.get('v.TabMap');

                        if ($A.util.isUndefinedOrNull(mapOpenedTabs)) {
                            mapOpenedTabs = new Map();
                        }

                        if (!$A.util.isUndefinedOrNull(response)) {
                            for (let i = 0; i < response.length; i++) {
                                if (!$A.util.isUndefinedOrNull(response[i].subtabs.length) && response[i].subtabs.length > 0) {
                                    for (let j = 0; j < response[i].subtabs.length; j++) {
                                        let uniqueMemberId = response[i].subtabs[j].pageReference.state.c__srnTabUnique;
                                        let subTabResponse = response[i].subtabs[j];
                                        mapOpenedTabs.set(uniqueMemberId, subTabResponse);
                                    }
                                }
                            }
                        }
                        var authIdsOpened = cmp.get('v.authIds');
                        for(var i in authIdsOpened){
                            let srnTabUniqueId = cmp.get('v.memberTabId') + authIdsOpened[i];
                            if (mapOpenedTabs.has(srnTabUniqueId)) {
                                let tabResponse = mapOpenedTabs.get(srnTabUniqueId);
                                workspaceAPI.closeTab({tabId: tabResponse.tabId});
                            }
                        }



                    })
                    .catch(function(error) {
                        console.log("tab info erro "+error);
                    });
                }
    },

    openStatusCard: function (cmp, event, helper) {
        // Handle event
        var selectedRows = event.getParam("selectedRows");
        if (!$A.util.isUndefinedOrNull(selectedRows)) {
            helper.setDefaultAutodoc(cmp, false); // DE492464 - Thanish 23rd Sept 2021
            var additionalDetails = selectedRows.additionalData;
            var authstatusId = additionalDetails.authStatusId;

            var authStatusList = cmp.get("v.authStatusList");
            var IsFound = false;
            for (var i = 0; i < authStatusList.length; i++) {
                if (authStatusList[i].get('v.compName') != undefined && authStatusList[i].get('v.compName') != null &&
                    authStatusList[i].get('v.compName') == authstatusId) {
                    IsFound = true;
                    break;
                }
            }

            if (!IsFound) {
                helper.showAuthResultSpinner(cmp);
                // US3476822
                helper.getAuthStatusDetails(cmp, event, helper, authstatusId, additionalDetails, false);
                helper.fireCallTopicAutodoc(cmp, event, helper);
            }
        }

        event.stopPropagation();
    },

     // US2891146	Create SRN - Warning Message
     checkPolicyStatus: function (cmp, event, helper){

        if(cmp.get("v.SRNFlag")){
            // addinng 3rd param - New Public group for Create Auth Pilot - Sarma - 28/10/2020
            helper.handleShowModal(cmp,'Create SRN',true);
        }else{
            helper.openCreateAuthTab(cmp, event, helper);
        }
    },
    // US2891146	Create SRN - Warning Message
    gotoCreateAuth: function (cmp, event, helper){

        var evt_memberTabId = event.getParam("memberTabId");
        var memberTabId = cmp.get('v.memberTabId');
        if(!$A.util.isUndefinedOrNull(evt_memberTabId)){
            if(evt_memberTabId != memberTabId){
                return false;
    }
        }

        helper.openCreateAuthTab(cmp, event, helper);
    },
    // US2566675 FF - Create SRN Button Functionality with Error ICUE is Down - Enhancements - Sarma
    navigateToDowntimeForm: function (cmp, event, helper) {
        var downtimeFormUrl = cmp.get('v.downtimeFormUrl');
        window.open(downtimeFormUrl, downtimeFormUrl);

    },

    // DE373867 - Thanish - 8th Oct 2020
    onHippaChanged: function (cmp) {
        if(cmp.get("v.isHippaInvokedInProviderSnapShot")){
            var cardDetails = new Object();
            cardDetails.componentName = "HIPAA Guidelines";
            cardDetails.componentOrder = 0;
            cardDetails.noOfColumns = "slds-size_1-of-1";
            cardDetails.type = "card";
            cardDetails.allChecked = false;
            cardDetails.cardData = [
                {
                    "checked": true,
                    "disableCheckbox": true,
                    "fieldName": "HIPAA Guidelines",
                    "fieldType": "outputText",
                    "fieldValue": "Accessed"
                }
            ];
            _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"), cmp.get("v.autodocUniqueId") + 0, cardDetails);
        }
    },

     // US2819909
    afterCreateSRNRecord: function (cmp, event, helper){

        // US3026437
        var memberTabId = cmp.get('v.memberTabId');
        var memberTabIdEvent = event.getParam("memberTabId");
		var isReferral = event.getParam("isReferral");
        if(isReferral){
            return;
        }
        if(memberTabId != memberTabIdEvent){
            return;
        }

        if(!$A.util.isUndefinedOrNull(event.getParam("SRNNumber")) && (!$A.util.isEmpty(event.getParam("SRNNumber")))){
            cmp.set('v.SRNNumber', event.getParam("SRNNumber"));

            // Preview Autodoc - US2819895
            cmp.set("v.createdAutodoc",event.getParam("autoDocString"));

            // DE383890
            cmp.set('v.isInitialCall', true);
            cmp.set('v.isAllAuthReceived', false);
            //DE443004
            cmp.set('v.isNoRecordsFound', false);
            cmp.set('v.isNoRecordsFoundTemp', false);
            cmp.set('v.isAllActive',false);

            helper.findAuthorizationResults(cmp, helper);
        }else{
            // Preview Autodoc - US2819895
            var autodocSubId = cmp.get("v.autodocUniqueId") + cmp.get("v.policySelectedIndex");
            var selectedAutodoc = JSON.parse(event.getParam("autoDocString"));
            selectedAutodoc.forEach(element => {
                _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"), autodocSubId, element);
            });
        }

    },

    //New Public group for Create Auth Pilot - Sarma - 28/10/2020
      goToIcue: function (cmp,event,helper) {
          if(cmp.get('v.memberTabId')==event.getParam('memberTabId'))
          {
              if(event.getParam("isSrnClick"))
              {
                  helper.setClickData(cmp,2.99,'Create SRN','ICUE has been accessed');
                  helper.openICUE(cmp,helper);
              }else if(event.getParam("isGTClick"))
              {
                  helper.setClickData(cmp,2.98,'Genetic Testing','URL has been selected');
              }else
              {
          helper.openICUE(cmp,helper);
              }
          }
      },
      handleAutodocRefresh: function (cmp, event, helper) {
              if (event.getParam("autodocUniqueId") == cmp.get("v.autodocUniqueId")) {
                  _autodoc.resetAutodoc(cmp.get("v.autodocUniqueId"));
                  helper.setDefaultAutodoc(cmp, true); // DE492464 - Thanish 23rd Sept 2021
                  var caseWrapper = cmp.get("v.caseWrapper");
                  caseWrapper.savedAutodoc = '';
                  caseWrapper.caseItems = [];
                  cmp.set("v.caseWrapper", caseWrapper);
              }
          },

     //ketki - 12/22 closing of auth detail tab from claim detail page
     onTabClosed: function (cmp, event,helper) {
        debugger;
        let tabFromEvent = event.getParam("tabId");
        if( !$A.util.isUndefinedOrNull(tabFromEvent)){
            let mapOpenedTabs = cmp.get('v.TabMap');
            let mapEntryToRemove =null ;
            if(!$A.util.isUndefinedOrNull(mapOpenedTabs)){
            	for (let elem of mapOpenedTabs.entries()) {

                	if(tabFromEvent === elem[1] ){
                    	mapEntryToRemove = elem[0];
                        let authStatusId = mapEntryToRemove.split("_")[1];
                        helper.handleLinkEnable(cmp,authStatusId);
                    	break;
                		}
            	}
            	if( !$A.util.isUndefinedOrNull(mapEntryToRemove)){
                	mapOpenedTabs.delete(mapEntryToRemove);
                	cmp.set('v.TabMap', mapOpenedTabs);
            	}
           	 }
         }
     },
    // Save Case Consolidation - US3424763
    checkCaseWrapper: function(cmp, event, helper) {
        // DE482674 - Thanish - 1st Sep 2021
        var authTableData = cmp.get("v.authTableData");
        if(authTableData.selectedRows.length > 0){
            helper.setDefaultAutodoc(cmp, false); // DE492464 - Thanish 23rd Sept 2021
        } else{
            helper.setDefaultAutodoc(cmp, true); // DE492464 - Thanish 23rd Sept 2021
        }

        helper.handleSaveModal(cmp, event, helper);
    },

})