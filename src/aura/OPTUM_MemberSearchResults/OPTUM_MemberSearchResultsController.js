({
    checkFormat: function (component, event, helper) {
	 // Edited by Dimpy for US3135948 Tech Story: Fuzzy search API integration
        var evtValue = event.getParam("MemberDetails");
        var searchType = event.getParam("SearchType");
        component.set("v.MemberDetails", evtValue);
        component.set("v.searchType", searchType);
		if(typeof evtValue === "undefined" || evtValue === null || evtValue === ""){
            component.set("v.memeberList", "");
        }else{
        var memberSearchList = [];
        if (searchType == "Advance") {
            memberSearchList = component.get("v.MemberDetails.member");
        } else {
            memberSearchList = component.get("v.MemberDetails");
        }
        component.set("v.ssnFormated", $A.get("$e.c.ACETLGT_MaskSSNComponent"));
		helper.changeFormat(component, event, helper, memberSearchList, searchType);
        }

    },
    openNewTab: function (component, event, helper) {
        //Edited by Dimpy for DE384310: One member Account Details are displayed on another member
        var search = component.get("v.searchType");
		// Edited by Dimpy for US3135948 Tech Story: Fuzzy search API integration
        if (search == "Advance") {
            var faroId = event.target.id;
            helper.callSearchApi(component, event, helper , faroId);
        } else {
            helper.addPersonAndInteraction(component, event, helper);
        }
    }
})