({
	doInit : function(component, event, helper) {
		var sPageURL = decodeURIComponent(window.location.search.substring(1));
        var sURLVariables = sPageURL.split('&');
        var sParameterName;
        var i;
           sParameterName = sURLVariables[0].split('=');          
            var claimId = sParameterName[1] === undefined ? true : sParameterName[1];
            component.set("v.claimIds",claimId);
			/*alert("ClaimEventData_"+localStorage.getItem("ClaimEventData_"+claimId));
            var pageReferenceobj= localStorage.getItem("ClaimEventData_"+claimId);
			if(pageReferenceobj != null || pageReferenceobj !=''  || pageReferenceobj !=undefined){
               component.set("v.pageReferenceobj",pageReferenceobj);
			 }*/
	}
})