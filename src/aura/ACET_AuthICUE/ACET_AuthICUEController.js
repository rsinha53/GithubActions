({
    doInit: function(component, event, helper) {

        helper.showECAASpinner(component);
        helper.getFocusedTabIdHelper(component, event);
        helper.getMemberIdGroupIdAuthDtl(component);
        var pageReference = component.get("v.pageReference");
        component.set('v.interactionRec',JSON.parse(pageReference.state.c__interactionRec));
        component.set('v.SRN',pageReference.state.c__SRNICUE);
        var hipaaEndpointUrl = pageReference.state.c__hipaaEndpointUrl;
        component.set("v.hipaaEndpointUrl",hipaaEndpointUrl);
         var autodocUniqueId = pageReference.state.c__autodocUniqueId;
        component.set("v.autodocUniqueId",autodocUniqueId);
         var originatorType = pageReference.state.c__originatorType;
        component.set("v.originatorType",originatorType);
        component.set('v.memberTabId',pageReference.state.c__memberTabId); //US2433262 Avish
        
		var action = component.get('c.findICUE');
        action.setParams({
            "srnNumber": component.get("v.SRN")
        });
        action.setCallback(this, function (response) {
            var state = response.getState(); // get the response state
            if (state == 'SUCCESS') {
                var result = response.getReturnValue();
                if (result.statusCode == 200) {
                    //component.set('v.eccaObj', result.resultWrapper.ecaaletterResLst);
                    component.set('v.eccaObj', result.resultWrapper.icueletterResLst);
                    helper.hideECAASpinner(component);
                   
                    helper.fireToastMessage("We hit a snag.", result.message, "error", "dismissible", "30000");
                } else {
                    helper.hideECAASpinner(component);
                    helper.fireToastMessage("We hit a snag.", result.message, "error", "dismissible", "30000");
                }
            }else{
                helper.hideECAASpinner(component);
            }
        
        });
        $A.enqueueAction(action); 
    },

    navigateToDetail:function(component,event,helper){
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
                
            });
        }).catch(function(error) {
            console.log(error);
        });
        
        
        
    },

    openEDMS: function(cmp, event, helper){

        var elementID = event.currentTarget.getAttribute("data-docId") + 'link';
        if (!$A.util.isUndefinedOrNull(document.getElementById(elementID))) {
            document.getElementById(elementID).style.pointerEvents="none";
            document.getElementById(elementID).style.cursor="default";
            document.getElementById(elementID).style.color="black";
        }
        var titleDocID = event.currentTarget.getAttribute("data-docId");
        
        var docLst = cmp.get("v.docIdLst");
        if(docLst.length == 0){
            docLst.push(titleDocID);
        }else{
            for(var i =0; i<docLst.length;i++){
                if(docLst[i] != titleDocID){
                    docLst.push(titleDocID);
                }
            }
        }

        cmp.set("v.docIdLst",docLst);
        var docId = 'documentId=' + event.currentTarget.getAttribute("data-docId"); //'0902a771800d5f63'
        
        var encodedString = btoa(docId);
        //var encodedString = Base64.encode(docId);
        console.log(encodedString);
        //encodedString = 'ZG9jdW1lbnRJZD0wOTAyYjVlYzhiYzIwOGYy';
        //var URLToSend = 'https://edms-cdms.uhc.com/ecaa/resources/?viewDocument='+encodedString; //ZG9jdW1lbnRJZD0wOTAyYTc3MTgwMGQ1ZjYz
        var URLToSend = encodedString;
        var memberTabId = cmp.get("v.memberTabId");
        var workspaceAPI = cmp.find("workspace");
        
        workspaceAPI.getEnclosingTabId().then(function (enclosingTabId) {
            workspaceAPI.openSubtab({
                parentTabId: enclosingTabId,
                pageReference: {
                                "type": "standard__component",
                                "attributes": {
                                    "componentName": "c__ACET_ICUEDocIframe" // c__<comp Name>
                                },
                                "state": {
                                    "iframeUrl":URLToSend,
                                    "memberTabId" : memberTabId,
                                    "docID": titleDocID
                                }
                            },
                focus: true
            }).then(function (subtabId) {
                let mapSubTabID = new Map();
                mapSubTabID.set(titleDocID,subtabId);
                cmp.set("v.subTabMap",mapSubTabID);
                workspaceAPI.setTabLabel({
                    tabId: subtabId,
                    label: titleDocID
                });
                workspaceAPI.setTabIcon({                    
                    tabId: subtabId,
                    icon: "action:record",
                    iconAlt: titleDocID                   
                });
            }).catch(function (error) {
                console.log(error);
            });
        });
        
        /* Working COde with Labels*/
        /* workspaceAPI.getEnclosingTabId().then(function (enclosingTabId) {
              workspaceAPI.openSubtab({
                    url: '/apex/ACET_Doc360Iframe?DocId='+titleDocID,
                	focus: true
              }).then(function (subtabId) {
                    workspaceAPI.setTabLabel({
                        tabId: subtabId,
                        label: titleDocID
                    });
                    workspaceAPI.setTabIcon({
                        tabId: subtabId,
                        icon: "action:record",
                        iconAlt: titleDocID
                    });
                }).catch(function (error) {
                    console.log(error);
                });
         });*/
        
       /* workspaceAPI.openSubtab({
                url: '/apex/ACET_Doc360Iframe?DocId='+titleDocID,
                focus: true
        }).then(function(response) {
            workspaceAPI.getTabInfo({
                tabId: response
              
            }).then(function(tabInfo) {
                console.log('tabInfo vfpage: '+tabInfo);
                 workspaceAPI.setTabLabel({
                        tabId: tabId,
                        label: titleDocID
                    });
                    workspaceAPI.setTabIcon({
                        tabId: tabId,
                        icon: "action:record",
                        iconAlt: titleDocID
                    });
            });
        }).catch(function(error) {
            console.log(error);
        });*/
         
    },

    openMisdirectComp: function (component, event, helper) {
        helper.openMisDirect(component, event, helper);
    },
    handleHippaGuideLines : function(component, event, helper) {
		var hipaaEndPointUrl = component.get("v.hipaaEndpointUrl");
        if(!$A.util.isUndefinedOrNull(hipaaEndPointUrl) && !$A.util.isEmpty(hipaaEndPointUrl)){
            window.open(hipaaEndPointUrl, '_blank');
        }
        //component.set("v.isHippaInvokedInProviderSnapShot",true);

        
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
        _autodoc.setAutodoc(component.get("v.autodocUniqueId"), 0, cardDetails);
    },

    onTabClosed: function (cmp, event, helper) {
        var docLst = cmp.get("v.docIdLst");
		var delDocID = [];
		var tabDocIDUnique = event.getParam("documentTabID");
        if(cmp.get("v.memberTabId") == event.getParam("memberTabId")){
            for(var i =0; i<docLst.length;i++){
                if(docLst[i] == event.getParam("docID")){
                    var docID = event.getParam("docID") + 'link';
                    document.getElementById(docID).style.pointerEvents="auto";
                    document.getElementById(docID).style.cursor="pointer";
                    document.getElementById(docID).style.color= "#006dcc !important";
                    delDocID = docLst.splice(i, 1);
                    cmp.set("v.docIdLst",docLst);
                    break;
                }
            }
        }
    },
    closedAllTabs: function (cmp, event, helper) {
        var closedTabId = event.getParam('tabId');
        helper.closeSubTabs(cmp, event, helper,closedTabId); 
    },
      //US2554307: View Authorizations Details Page - Add Alerts Button
    setMmberIdGroupIdAuthDtl : function(component, event, helper) {
        var memberId = event.getParam("memberIdAuthDtl");
        var GroupId = event.getParam("groupIdAuthDtl");
        var taxId = event.getParam("alertTaxId");
        var providerId = event.getParam("alertProviderId");
        component.set("v.groupIdAuthDtl",GroupId);
        component.set("v.alertProviderId",providerId);
        component.set("v.alertTaxId",taxId);
        component.set("v.memberIdAuthDtl",memberId);


    },
    //US2554307: View Authorizations Details Page - Add Alerts Button
    getAlertsAuthDetails : function(component, event, helper) {
        component.find("alertsAI_AuthDetails").getAlertsOnAuthDetailsPage();
    }
})