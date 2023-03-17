({
	doInit : function(component, event, helper) {	
        
        //Page Reference
		var pageReference = component.get("v.pageReference");
		
        var cseTopic = pageReference.state.c__callTopic;
        var srk = pageReference.state.c__srk;
        var int = pageReference.state.c__interaction;
        var intId = pageReference.state.c__intId;
        var memId = pageReference.state.c__Id;
        var grpNum = pageReference.state.c__gId;  
        var CPTIN = window.atob(pageReference.state.c__CPTIN);
        
        var bookOfBusinessTypeCode = '';
        if(component.get("v.pageReference").state.c__bookOfBusinessTypeCode != undefined){
            bookOfBusinessTypeCode = component.get("v.pageReference").state.c__bookOfBusinessTypeCode;
        }
        console.log('bookOfBusinessTypeCode',bookOfBusinessTypeCode);
        component.set('v.bookOfBusinessTypeCode',bookOfBusinessTypeCode);
        
        component.set("v.AutodocKey", intId+memId+'HSA');
        //String Highlight panel data
        var hghString = pageReference.state.c__hgltPanelDataString;
        component.set("v.hgltPanelDataString", hghString);
        //
        
        var hpi = JSON.parse(hghString);


        component.set("v.cseTopic", cseTopic);
        component.set("v.srk", srk);
        component.set("v.int", int);
        component.set("v.intId", intId);
        component.set("v.memId", memId);
        component.set("v.grpNum", grpNum);
		component.set("v.highlightPanel", hpi);
		component.set("v.CPTIN", CPTIN);

        var intId = component.get("v.intId");

        if(intId != undefined ){
            var childCmp = component.find("cComp");
            var memID = component.get("v.memId");
            var GrpNum = component.get("v.grpNum");
			var bundleId = hpi.benefitBundleOptionId;
            childCmp.childMethodForAlerts(intId,memID,GrpNum,'',bundleId);
        }

        helper.loadHSAValues(component,helper);

    },


    handleBankAuthSectionToggle: function (component, event, helper)  {
        var openSections = event.getParam('Bank_Authentication');
    },

    handleAccountInfoSectionToggle: function (component, event, helper)  {
        var openSections = event.getParam('Account_Info');
    },



    openAccInfoDetail : function(component, event, helper) {
        
        //Set Tab Value for each Account
        var accId = event.currentTarget.getAttribute("data-caseId");
        var accNo = event.currentTarget.getAttribute("data-accNo");
        var tabValue = accId.substr(accId.length-4,accId.length);
        var uniqueKey = accNo;
        
        var hsaId = event.currentTarget.getAttribute("data-hsaId");
        var autodockey = component.get("v.AutodocKey");

        var workspaceAPI = component.find("workspace");
        
        workspaceAPI.getEnclosingTabId().then(function (enclosingTabId) {
            
            workspaceAPI.openSubtab({
                parentTabId: enclosingTabId,
                pageReference: {
                    "type": "standard__component",
                    "attributes": {
                        "componentName": "c__ACETLGT_HSATransactions"
                    },
                    "state": {
                        "uid": uniqueKey,
                        "c__srk":component.get("v.srk"),
                        "c__intId":component.get("v.intId"),
                        "c__mId": component.get("v.memId"),
                        "c__gId": component.get("v.grpNum"),
                        "c__hgltPanelDataString": component.get("v.hgltPanelDataString"),
                        "c__CPTIN": window.btoa(component.get("v.CPTIN")),
                        "c__AutodocKey": autodockey,
                        "c__hsaId": hsaId
                        
                    }
                }
            }).then(function(response) {
                workspaceAPI.getTabInfo({
                    tabId: response
                }).then(function(tabInfo) {
                                        
                    workspaceAPI.setTabLabel({                        
                        tabId: tabInfo.tabId,
                        label: "HSA - "+tabValue 
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
        
        
	},





})