({
    showAuthStatusSpinner: function (cmp) {
        var spinner = cmp.find("asdasd");
      
        $A.util.removeClass(spinner, "slds-hide");
        
    },
    hideAuthStatusSpinner: function (cmp) {
        var spinner = cmp.find("asdasd");
        
        $A.util.addClass(spinner, "slds-hide");
    },
    getICUEURL: function (component, event, helper) {
        var ICUEURL = component.get("v.ICUEURL");
       
        component.set("v.spinnerFlag",false);
        //this.hideAuthStatusSpinner(component);
        window.open(ICUEURL, 'ICUE', 'toolbars=0,width=1200,height=800,left=0,top=0,scrollbars=1,resizable=1');
    },
    getAuthStatusDetails: function (cmp, event, helper) {
        var action = cmp.get("c.getAuthorizationStatus");
        var requestParams = {
            AUTH_ID: cmp.get('v.authID'), // '156627064',
            XREF_ID: cmp.get('v.xrefID') // '625871210'
        };
        action.setParams({ requestObject: requestParams });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state == "SUCCESS") {
                var data = response.getReturnValue();
                if (data.statusCode == 200) {
                    cmp.set('v.authStatusDetails', data.resultWrapper);
                }
            } else if (state === "INCOMPLETE") {

            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {

                    }
                } else {

                }
            }
        });
        $A.enqueueAction(action);
    },

    /*** DE334279 - Avish **/
    openSRNTab: function(cmp, event){

        var uniqueSRNLst = cmp.get('v.uniqueSRN');
        if(!$A.util.isEmpty(cmp.get('v.SRN'))){
            if(uniqueSRNLst.length == 0){
                uniqueSRNLst.push(cmp.get('v.SRN'));
            }else{
                for (var i = 0; i < uniqueSRNLst.length; i++) {
                    if(cmp.get('v.SRN') != uniqueSRNLst[i]){
                        uniqueSRNLst.push(cmp.get('v.SRN'));
                        break;
                    }
                }
            } 
            cmp.set('v.uniqueSRN',uniqueSRNLst);
        }
        
        var workspaceAPI = cmp.find("workspace");
        workspaceAPI.openSubtab({
            pageReference: {
                "type": "standard__component",
                "attributes": {
                    "componentName": "c__ACET_AuthECAA"
                }, "state": {
                    "c__interactionRec": JSON.stringify(cmp.get('v.interactionRec')),
                    "c__SRN": cmp.get('v.SRN')
                }
            },
            focus: true
        }).then(function (tabId) {
            workspaceAPI.setTabLabel({
                tabId: tabId,
                label: "ECAA " + cmp.get('v.SRN')
            });
            workspaceAPI.setTabIcon({
                tabId: tabId
            });
        })
    },
    
    focusSRNTab: function(cmp, event,srnUnique){
        var workspaceAPI = cmp.find("workspace");
        var focusedTabId;
        var url;
        workspaceAPI.getAllTabInfo().then(function (response) {
            if (!$A.util.isEmpty(response)) {
                for (var i = 0; i < response.length; i++) {
                    for (var k = 0; k < response[i].subtabs.length; k++) {
                        if (srnUnique == response[i].subtabs[k].pageReference.state.c__SRN) {
                            url = response[i].subtabs[k].url;
                            focusedTabId = response[i].subtabs[k].tabId;
                            break;
                        }
                    }
                    
                }
                workspaceAPI.openTab({
                    url: url
                }).then(function (response) {
                    workspaceAPI.focusTab({
                        tabId: focusTabId
                    });
                }).catch(function (error) {
                    console.log(error);
                });
            }
        })
        .catch(function (error) {
            console.log(error);
        });
    },
    /*** DE334279 - Avish **/
})