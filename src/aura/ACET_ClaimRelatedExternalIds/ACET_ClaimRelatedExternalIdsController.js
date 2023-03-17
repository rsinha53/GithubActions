({
	onInit : function(cmp, event, helper) {
		cmp.set("v.cmpUniqueId", new Date().getTime());
		helper.getClaimIssues(cmp);
	},

    // US3177995 - Thanish - 22nd Jun 2021
	onIdClick : function(cmp, event, helper) {
		var orsId = event.currentTarget.getAttribute("data-orsId");
		var objectId = event.currentTarget.getAttribute("data-objectId");
        var issueType = event.currentTarget.getAttribute("data-IdType");
        $A.util.addClass(event.currentTarget, "disableLink");
		
		if (issueType == "ORS") {
            helper.openORSDetail(cmp, event, orsId, issueType);
        } else if(issueType == "Purged ORS"){
			helper.openPurgedDetails(cmp, event, objectId, orsId); // US3667124 - Thanish - 6th Jul 2021
        } else {
            helper.openClaimDetail(cmp, event, orsId, issueType);
        }
	},

	handleServiceRequestDetailClose: function (cmp, event, helper) {
        if(event.getParam("parentUniqueId") == cmp.get("v.cmpUniqueId")){
			var closedTabId = event.getParam("closedTabId");
			var externalIdInfo = cmp.get("v.externalIdInfo");
			for(var info of externalIdInfo){
				if(info.tabId == closedTabId){
					info.class = "";
					info.tabId = "";
				}
			}
			cmp.set("v.externalIdInfo", externalIdInfo);
		}
    },

	// US3667124 - Thanish - 6th Jul 2021
	purgedCheckboxChange: function(cmp, event, helper){
		if(event.getParam('checked')){
			if(!cmp.get("v.purgedORSLoaded")){
				helper.getPurgedORSRecords(cmp);
			} else{
				helper.filterPurgedORSRecords(cmp, false);
			}
		} else{
			helper.filterPurgedORSRecords(cmp, true);
		}
	}

})