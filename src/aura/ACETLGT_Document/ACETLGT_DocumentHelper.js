({
    fetchDoc: function(component, event, helper) {
        //build action to query global error handling component
        var action = component.get("c.fetchDoc");
        if (component.get("v.performAction") == "1") {
            action.setParams({
                docId: component.get("v.docId"),
                docContentType: component.get("v.docContentType"),
                docName: component.get("v.docName"),
                docSize: component.get("v.docSize"),
                isDocSizeMoreThanOneMB: component.get("v.isDocSizeMoreThanOneMB"),
                isIdCard: 'true'
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
//                alert(state);
                if (state === "SUCCESS") {
//                alert(response.getReturnValue());
                    var urlString = response.getReturnValue();
                    component.set("v.docUrl", urlString);
                }
            });
            $A.enqueueAction(action);
        }
          var action = component.get("c.getdoc360Url"); //Modified by Team-Styx Raviteja on June 11 2021
          if( component.get("v.performAction") == "0")  {             
                action.setParams({
                    documentId : component.get("v.docId"),
                    doctypeWSName: component.get("v.selecteddoctype")
                });
                action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var urlString = response.getReturnValue();
                    component.set("v.edmsurl", urlString);
                    //window.open(urlString, 'EDMS', 'toolbars=0,width=1200,height=800,left=0,top=0,scrollbars=1,resizable=1');
                  }
                });
             
            $A.enqueueAction(action);
          }
    },

    toastmessagehelper: function(component, event, helper, title, message, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type": type,
            "mode": 'sticky'
        });
        toastEvent.fire();
    },

    closeModal: function(component, event, helper) {
        component.set("v.displayResendPopup", false);
         var iframedivcmp = component.find('iframediv');
        $A.util.addClass(iframedivcmp, 'slds-show');
        $A.util.removeClass(iframedivcmp, 'slds-hide'); 
    },
    resendButtonClickhelper: function(component, event, helper) {
         var pageReferenceobj =  component.get("v.pageReference").state;
  var tabuniqueid = pageReferenceobj.c__tabuniqueid;     
        var matchingTabs = [];
        var tabIndex;
                var workspaceAPI = component.find("workspace");
        workspaceAPI.getAllTabInfo().then(function (response){
if (!$A.util.isEmpty(response)){
                for (var i=0; i < response.length; i++){      
                   var subtabsarray = response[i].subtabs;
                 
                   for(var k =0;k<subtabsarray.length;k++){
                        var tabUniqueId = subtabsarray[k].pageReference.state.c__tabuniqueid;
                                   if (tabUniqueId == tabuniqueid){   
                        matchingTabs.push(subtabsarray[k]);
                        tabIndex = i;
                        break;
                    } 
 
                    }             

                }                

            }

               workspaceAPI.getFocusedTabInfo().then(function(response) {
            var focusedTabId = response.tabId;
            workspaceAPI.closeTab({tabId: focusedTabId});
       })
        .catch(function(error) {
            console.log(error);
        });
            workspaceAPI.focusTab({tabId: matchingTabs[0].tabId});   
                var appEvent = $A.get("e.c:ACETLGT_Document_Support_event");
        appEvent.setParams({
            "docId" : pageReferenceobj.c__docId,
            "docType":pageReferenceobj.c__docType,
            "docContentType":pageReferenceobj.docContentType
        });
        appEvent.fire();
})
        
    }

})