({
    doInit: function(component, event, helper) {

        helper.showECAASpinner(component);
        helper.getFocusedTabIdHelper(component, event);
        var pageReference = component.get("v.pageReference");
        component.set('v.interactionRec',JSON.parse(pageReference.state.c__interactionRec));
        component.set('v.SRN',pageReference.state.c__SRN);
        component.set('v.memberTabId',pageReference.state.c__memberTabId); //US2433262 Avish
        
		var action = component.get('c.findECAA');
        action.setParams({
            "srnNumber": component.get("v.SRN")
        });
        action.setCallback(this, function (response) {
            var state = response.getState(); // get the response state
            if (state == 'SUCCESS') {
                var result = response.getReturnValue();
                if (result.statusCode == 200) {
                    component.set('v.eccaObj', result.resultWrapper.ecaaletterResLst);
                    helper.hideECAASpinner(component);
                    // US2445831
                    helper.fireToastMessage("We hit a snag.", result.message, "error", "dismissible", "30000");
                } else {
                    // US2445831
                    helper.hideECAASpinner(component);
                    helper.fireToastMessage("We hit a snag.", result.message, "error", "dismissible", "30000");
                }
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
                                    "componentName": "c__ACET_EDMSIframe" // c__<comp Name>
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
                    iconAlt: "Service Request Detail"                    
                });
            }).catch(function (error) {
                console.log(error);
            });
        });
         
    },

    openMisdirectComp: function (component, event, helper) {
        helper.openMisDirect(component, event, helper);
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
})