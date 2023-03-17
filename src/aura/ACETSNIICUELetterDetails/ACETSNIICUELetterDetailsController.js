({
	 opendoc: function(cmp, event, helper){
        var elementID = event.currentTarget.getAttribute("data-docId") + 'link';
        if (!$A.util.isUndefinedOrNull(document.getElementById(elementID))) {
            document.getElementById(elementID).style.pointerEvents="none";
            document.getElementById(elementID).style.cursor="default";
            document.getElementById(elementID).style.color="black";
        }
        var titleDocID = event.currentTarget.getAttribute("data-docId");
        var businessFlow = event.currentTarget.getAttribute("data-flow");
        var indexName = event.currentTarget.getAttribute("data-indexName");
        var letterId = event.currentTarget.getAttribute("data-letterId");
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
                                    "docID": titleDocID,
                                    "businessFlow": businessFlow,
                                    "indexName":indexName
                                }
                            },
                focus: true
            }).then(function (subtabId) {
                let mapSubTabID = new Map();
                mapSubTabID.set(titleDocID,subtabId);
                cmp.set("v.subTabMap",mapSubTabID);
                workspaceAPI.setTabLabel({
                    tabId: subtabId,
                    label: letterId
                });
                workspaceAPI.setTabIcon({                    
                    tabId: subtabId,
                    icon: "action:record",
                    iconAlt: letterId                   
                });
            }).catch(function (error) {
                console.log(error);
            });
        });
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
    }
})