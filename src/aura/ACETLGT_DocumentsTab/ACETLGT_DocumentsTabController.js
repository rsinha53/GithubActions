({
	initMemberEOBTable: function (cmp, event, helper) {
        if(cmp.get("v.MemberEOBDTWrapper")==null){
            helper.initMemberEOBTable(cmp, event, helper);
        }
        else{
        	var docTable = cmp.find("MemberEOBDocTable_auraid");
        docTable.clearTable_event();
        docTable.tableinit();
        }
        
    },
    
    initProviderRATable: function (cmp, event, helper) {
        if(cmp.get("v.ProviderRADTWrapper")==null){
            helper.initProviderRATable(cmp, event, helper);
        }
        else{
        	var docTable = cmp.find("ProviderRADocTable_auraid");
        docTable.clearTable_event();
        docTable.tableinit();
        }
    },
    
    initClaimLetterTable: function (cmp, event, helper) {
            	if(cmp.get("v.ClaimLetterDTWrapper")==null){
        helper.initClaimLetterTable(cmp, event, helper);
            	}
        else{
        	var docTable = cmp.find("ClaimLetterDocTable_auraid");
        docTable.clearTable_event();
        docTable.tableinit();
        }
    },
    
    initPhysicalHealthLetterTable: function (cmp, event, helper) {

        if(cmp.get("v.PhysicalHealthLetterDTWrapper")==null){
            helper.initPhysicalHealthLetterTable(cmp, event, helper);
        }
        else{
        	var docTable = cmp.find("PhysicalHealthLetterDocTable_auraid");
        docTable.clearTable_event();
        docTable.tableinit();
        }
    },
    handlecreatedRow_Event:function(component, event, helper) {
        var row = event.getParam("row");
        var data = event.getParam("data");
        var dataIndex = event.getParam("dataIndex");
        var docType = "";
        var  table_id = event.getParam("lgt_dt_table_ID");
        if(table_id!=null && table_id!= "undefined"){
            if(table_id.includes("#ClaimLetterTable_lgt_dt_table_ID")){
                docType = "Claim Letter";
            }else if(table_id.includes("#MemberEOBTable_lgt_dt_table_ID")){
                docType = "Member EOB";
            }else if(table_id.includes("#ProviderRATable_lgt_dt_table_ID")){
                docType = "Provider RA";
            }else if(table_id.includes("#PhysicalHealthLetterTable_lgt_dt_table_ID")){
                docType = "Physical Health Letter";
            }
        }
        console.log('tableId: ' + table_id);
        var docId;
        var docContentType;
        var docName;
        var docsize;
        var isDocSizeMoreThanOneMB;
        var srk = component.get("v.srk");
        var memID = component.get("v.memberID");
        if(data!=null){
            docId = data["DocumentId"];
            docContentType = data["cmis:contentStreamMimeType"];
            docName = data["cmis:contentStreamFileName"];
            docsize = parseInt(data["cmis:contentStreamLength"]);
            if(docsize){
                isDocSizeMoreThanOneMB = (docsize/(1024*1024) >= 1 ? true : false);                    
            }       }
        console.log(data);
        $(row).children().first().html("<a id='lnkClaimId' href='#'>" + docId + "</a>");        
        $(row).children().first().on('click', function(e){ 
            
            var workspaceAPI = component.find("workspace");
            workspaceAPI.getEnclosingTabId().then(function (enclosingTabId) {
                workspaceAPI.openSubtab({
                    parentTabId: enclosingTabId,
                    pageReference: {
                        "type": "standard__component",
                        "attributes": {
                            "componentName": "c__ACETLGT_Document"
                        },
                        "state": {
                            "c__docId" : docId,
                            "c__docType" : docType,
                            "c__docContentType": docContentType,
                            "c__docName": docName,
                            "c__docSize": docsize,
                            "c__isDocSizeMoreThanOneMB": isDocSizeMoreThanOneMB,
                            "c__performAction": "1",
                            "c__srk": srk,
                            "c__memberID": memID,
                            "c__userInfo":component.get("v.userInfo"),
                            "c__hgltPanelData":component.get("v.highlightPanelData"),
                            "c__bookOfBusinessTypeCode":component.get("v.bookOfBusinessTypeCode")
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
    }
})