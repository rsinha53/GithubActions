({
	navigatetoservicereqdetail : function(cmp, event, helper) {
		var extid = event.getParam('extid');
        var extidtype = event.getParam('extidtype');
		var memberId = cmp.get("v.memberid");
        var workspaceAPI = cmp.find("workspace");
        workspaceAPI.getEnclosingTabId().then(function (enclosingTabId) {
            workspaceAPI.openSubtab({
                parentTabId: enclosingTabId,
                pageReference: {
                    "type": "standard__component",
                    "attributes": {
                        "componentName": "c__ACET_ServiceRequestDetail"
                    },
                    "state": {
                        "c__caseId": extid,
                        "c__parentUniqueId": cmp.get("v.cmpUniqueId"),
                        "c__idType": extidtype,
                        "c__memberId": memberId
                        }
                    },
                    focus: true
                }).then(function (subtabId) {
                    workspaceAPI.setTabLabel({
                        tabId: subtabId,
                        label: extid
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

    doInit : function(cmp, event, helper) {
        var pageReference = cmp.get("v.pageReference");
        cmp.set("v.memberid", pageReference.state.c__memberid);
        cmp.set("v.alertProviderId",pageReference.state.c__alertProviderId);
        cmp.set("v.alertMemberId",pageReference.state.c__alertMemberId);
        cmp.set("v.alertGroupId",pageReference.state.c__alertGroupId);
        cmp.set("v.alertTaxId",pageReference.state.c__alertTaxId);
        cmp.set("v.policyGroupId",pageReference.state.c__policyGroupId);
        cmp.set("v.policyMemberId",pageReference.state.c__policyMemberId);
        cmp.set("v.interactionRecId",pageReference.state.c__interactionRecId);
        cmp.set("v.providerNotFound",pageReference.state.c__providerNotFound);
        cmp.set("v.noMemberToSearch",pageReference.state.c__noMemberToSearch);
        cmp.set("v.isProviderSearchDisabled",pageReference.state.c__isProviderSearchDisabled);
        cmp.set("v.houseHoldMemberId",pageReference.state.c__houseHoldMemberId);
        cmp.set("v.mnf",pageReference.state.c__mnf);
        cmp.set("v.FISourceCode",pageReference.state.c__FISourceCode);
        cmp.find("alertsAI").alertsMethodShapshots();
    },
})