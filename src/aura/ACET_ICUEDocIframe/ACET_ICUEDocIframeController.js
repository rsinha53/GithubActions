({
    doInit: function(cmp, event, helper) {
        var pageReference = cmp.get("v.pageReference");
        helper.getFocusedTabIdHelper(cmp, event);
        cmp.set('v.documentID',pageReference.state.docID);
        cmp.set('v.memberTabId',pageReference.state.memberTabId);
        cmp.set('v.businessFlow',pageReference.state.businessFlow);
        cmp.set('v.indexName',pageReference.state.indexName);
        //cmp.set('v.iframeUrl',pageReference.state.iframeUrl);   
        //var urlstring= window.location.href;
        //var baseURL = urlstring.substring(0,urlstring.indexOf("/s"));
        //console.log('=baseURL='+baseURL);
        //var iframURL = baseURL+;
        if(!$A.util.isUndefinedOrNull(cmp.get('v.businessFlow')) && !$A.util.isUndefinedOrNull(cmp.get('v.indexName'))) {
            var iframURL = '/apex/ACET_Doc360Iframe?DocId='+cmp.get("v.documentID")+'&businessFlow='+cmp.get("v.businessFlow")+'&indexName='+cmp.get("v.indexName");
        }else {
            var iframURL = '/apex/ACET_Doc360Iframe?DocId='+cmp.get("v.documentID");
        }
        console.log('==iframURL'+iframURL);
        cmp.set('v.iframeUrl',iframURL);
        var action = cmp.get('c.getICUEDoc');

        action.setCallback(this, function (response) {
            var state = response.getState(); // get the response state
            if (state == 'SUCCESS') {
                var result = response.getReturnValue();
                cmp.set("v.fileName",result.fileName);
                cmp.set("v.fileContent",result.responseBody);
                cmp.set("v.fileType",result.fileType);
                var iframesrc = "data:application/pdf;base64,"+result.responseBody;
                cmp.set("v.iframeSrc",iframesrc);
                cmp.set("v.contentLoaded",true);
                
                var addiFrame = cmp.get('c.addiFrame');
                //$A.enqueueAction(addiFrame);
                
                //if (result.statusCode == 200) {                    
                    //cmp.set("v.endPointEDMS",result.endPointURL);
                //console.log('result file: '+JSON.stringify(result));
               /* } else { //if (result.statusCode == 500 ) 
                    
                } */
            }
            
        });
        //$A.enqueueAction(action); 
        
    },
    
	onICUETabClosed : function(cmp, event, helper) {
        var closedTabId = event.getParam('tabId');
        if (closedTabId == cmp.get("v.currentTabId")) {
            var appEvent = $A.get("e.c:ACET_EDMSClosedTabEvent");
            let mapSubTabID = new Map();
            mapSubTabID.set(cmp.get('v.documentID'),closedTabId);
            console.log(mapSubTabID);
            if(appEvent != undefined){
                appEvent.setParams({
                    "memberTabId": cmp.get('v.memberTabId'),
                    "docID": cmp.get("v.documentID"),
                    "subTabID": closedTabId,
                    "documentTabID" : cmp.get("v.documentTabID")
                });
                appEvent.fire();
            }
        }
	},
    addiFrame : function(cmp, event, helper) {
        var iframe = document.createElement('iframe');
        document.getElementById("iframeDoc").appendChild(iframe);
        iframe.setAttribute("style","height:100%;width:100%;");
        iframe.setAttribute("src","data:application/pdf;base64,"+cmp.get("v.fileContent"));
        
        document.getElementById("docFrame").src = "data:application/pdf;base64,"+cmp.get("v.fileContent");
    }
})