({
	openCheckImg: function (cmp, event, helper) {
        var dataset = event.target.dataset;
        var seriesDesignator = event.currentTarget.getAttribute("data-series-designator");
        var checkNumber =  event.currentTarget.getAttribute("data-check-number");
        helper.openCheckImgWindow(cmp, event, helper, seriesDesignator, checkNumber);
        
    },
    
    initAutodocAfterPaymentLoad: function (cmp, event, helper){
    	var tabKey = cmp.get("v.AutodocKey") + cmp.get("v.GUIkey");
        setTimeout(function() {
            if (window.lgtAutodoc != undefined){
                window.lgtAutodoc.initAutodoc(tabKey);
                }
    
        }, 1000);
    },
    
    
    Onclickpaymentnum:function(component,event,helper){
        var seriesDesignator = event.currentTarget.getAttribute("data-SeriesDesignator"); 
        var paymentnum = event.currentTarget.getAttribute("data-Paymentnum");
        var workspaceAPI = component.find("workspace");
        
//        var pagerefaranceobj = component.get("v.pageReference");
                    var p = component.get("v.parent");
                    
        var pagerefaranceobj = p.get("v.pageReference");
        console.log(JSON.stringify(pagerefaranceobj));
        
        workspaceAPI.getEnclosingTabId().then(function (enclosingTabId) {
            workspaceAPI.openSubtab({
                parentTabId: enclosingTabId,
                pageReference: {
                    "type": "standard__component",
                    "attributes": {
                        "componentName": "c__ACETLGT_PaymentSearch"
                    },
                    "state": {
                        "uid": "1",
                        "c__callTopic" : "View Payments",
                        "c__interaction": pagerefaranceobj.state.c__int,
                        "c__intId":pagerefaranceobj.state.c__intId,
                        "c__srk":pagerefaranceobj.state.c__srk,
                        "c__Id":pagerefaranceobj.state.c__memberID,
                        "c__gId":pagerefaranceobj.state.c__gId,
                        "c__fname": pagerefaranceobj.state.c__fname,
                        "c__lname": pagerefaranceobj.state.c__lname,
                        "c__va_dob": pagerefaranceobj.state.c__va_dob,
                        "c__originatorval": pagerefaranceobj.state.c__originatorval,
                        "c__userInfo":pagerefaranceobj.state.c__userInfo,
                        "c__hgltPanelData":pagerefaranceobj.state.c__hgltPanelData,
                        "c__hgltPanelDataString":pagerefaranceobj.state.c__hgltPanelDataString,
                        "c__paymentNum":paymentnum,
                        "c__seriesDesignator":seriesDesignator,
                        "c__memberid": p.get("v.memberID"),
                        "c__eid": p.get("v.eid"),
						"c__int": p.get("v.int"),
                        "c__fromClaimDetail":true,
                                "c__AutodocKey": component.get("v.AutodocKey")
                    }
                }
            }).then(function(response) {
                workspaceAPI.getTabInfo({
                    tabId: response
                }).then(function(tabInfo) {
                    workspaceAPI.setTabLabel({
                        tabId: tabInfo.tabId,
                        label: "View Payments"
                    });
                    workspaceAPI.setTabIcon({
                        tabId: tabInfo.tabId,
                        icon: "standard:people",
                        iconAlt: "Member"
                    });
                });
            }).catch(function(error) {
                console.log(error);
            });
        }); 
    }
    
})