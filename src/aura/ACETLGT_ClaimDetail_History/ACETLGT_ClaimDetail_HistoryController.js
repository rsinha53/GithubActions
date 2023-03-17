({
	doInit : function(component, event, helper) {
    setTimeout(function(){
      var claimId = component.get("v.claimIds");
       var importStatetemp = localStorage.getItem("ClaimEventData_"+claimId);
	  var importState =JSON.parse(importStatetemp);
    
   // var importState = component.get("v.pageReferenceobj");
    	if (importState) {
                component.set("v.pageReferenceobj",importState);
            component.set('v.claimID', importState.c__claimID);
            var claimID = component.get("v.claimID");
            component.set('v.claimType', importState.c__claimType);
            var claimType = component.get("v.claimType");
            component.set('v.cirrClaimID', importState.c__cirrClaimID);
            var cirrClaimID = component.get("v.cirrClaimID");
            component.set('v.phi', importState.c__phi);
            var phi = component.get("v.phi");
            component.set('v.taxID', importState.c__taxID);
            var taxID = component.get("v.taxID");
            component.set('v.provider', importState.c__provider);
            var provider = component.get("v.provider");
            component.set('v.network', importState.c__network);
            var network = component.get("v.network");
            component.set('v.dosStart', importState.c__dosStart);
            var dosStart = component.get("v.dosStart");
            component.set('v.dosEnd', importState.c__dosEnd);
            var dosEnd = component.get("v.dosEnd");
            component.set('v.charged', importState.c__charged);
            var charged = component.get("v.charged");
            component.set('v.paid', importState.c__paid);
            var paid = component.get("v.paid");
            component.set('v.deductible', importState.c__deductible);
            var deductible = component.get("v.deductible");
            component.set('v.patientResp', importState.c__patientResp);
            var patientResp = component.get("v.patientResp");
            component.set('v.statusDate', importState.c__statusDate);
            var statusDate = component.get("v.statusDate");
            component.set('v.status', importState.c__status);
            var status = component.get("v.status");
            component.set('v.eventType', importState.c__eventType);
            var eventType = component.get("v.eventType");
            component.set('v.primaryDX', importState.c__primaryDX);
            var primaryDX = component.get("v.primaryDX");
            component.set('v.memberID', importState.c__memberID);
            var memberID = component.get("v.memberID");
            var memid = importState.c__memberID;
		   var srk = importState.c__srk;
		   var eid  = importState.c__eid;
		   var hData = importState.c__hgltPanelData;  
		   component.set('v.memberid', memid);
			component.set("v.highlightPanel", hData);
            var ServiceStart = new Date (dosStart);
            var ServiceEnd = new Date (dosEnd);
	        if(hData!=null && hData!='undefined'){
	            var EffectiveDate = new Date(hData.EffectiveDate);
	            var EndDate = new Date(hData.EndDate);
	    		if(EffectiveDate!='Invalid Date' && EndDate!='Invalid Date'){
			         if(+EffectiveDate <= +ServiceStart && +EndDate >= +ServiceEnd) {
			            console.log('Claim DOS is inside of the selected coverage period.');
			        }else{
			        	component.set('v.DOSErrorMessage', true);
			        }
			    }
		    }
		    helper.queryClaimServices(component, event, helper,importState);
	    	}
                      },1);
	},
	
})