({
    showClaimSpinner: function (component) {
        var spinner = component.find("claimSearch-spinner");
        $A.util.removeClass(spinner, "slds-hide");
        $A.util.addClass(spinner, "slds-show");
    },
    hideClaimSpinner: function (component) {
        var spinner = component.find("claimSearch-spinner");
        $A.util.removeClass(spinner, "slds-show");
        $A.util.addClass(spinner, "slds-hide");
    },
    /*checkLeapYear :function(component, year) {
        return year % 100 === 0 ? year % 400 === 0 : year % 4 === 0;
    },*/
    initializeClaimInputsDetails: function (component) {

        // US1918629: Venkat -15th Sep 2020
	    var interactionTaxValue=component.get("v.interactionCard.taxId");
        var memberSnap=component.get("v.memberCardSnap");
        console.log('Interaction Inputs Tax :: ',interactionTaxValue);
		var isVCCD=component.get("v.isVCCD");
		let claimNumber="";
        if(isVCCD){
            var iVRDetails=component.get("v.iVRDetails");
            console.log("iVRDetails "+iVRDetails);
            claimNumber=iVRDetails.ClaimId__c;
        }
        //US2969925 - Display most recent claims: Tilak
        /*var today = new Date();
        var dd = String(today.getDate()).padStart(2, '0');
        var mm = String(today.getMonth() + 1).padStart(2, '0'); //January is 0
        var yyyy = today.getFullYear();
        today = yyyy + '-' + mm + '-' + dd;
        var fromdt = new Date(today);
        console.log('start date before :: ',fromdt);
        var msFromDate =fromdt.getTime()-7689600000; //2708160000
        console.log("the msFromDate is: "+msFromDate);
        var newToDate = new Date(msFromDate) ;
        console.log ("new To Date:"+newToDate);*/
        /*var toDateStr=$A.localizationService.formatDate(newToDate,"MM-dd-yyyy");
        console.log ("new To Date:"+toDateStr);*/
        var intialClaimsVar=component.set("v.initailClaims", true);
        /*var today = new Date();
        var dd = String(today.getDate()).padStart(2, '0');
        var mm = String(today.getMonth() + 1).padStart(2, '0'); //January is 0
        var yyyy = today.getFullYear();
        today =yyyy + '-' + mm + '-' + dd;
		var fromdt = new Date(today);
        console.log('start date before :: ',fromdt);
        var msFromDate =fromdt.getTime()-7689600000;//2505600000
        console.log("the msFromDate is: "+msFromDate);
        var newToDate = new Date(msFromDate) ;
        console.log ("new To Date:"+newToDate);
        var toDateStr=$A.localizationService.formatDate(newToDate,"yyyy-MM-dd");
        console.log ("new To Date:"+toDateStr);
        var fromDateRequest=toDateStr;
        var toDateRequest=today;*/

        var today = new Date();
                var dd = new Date();
                dd.setDate(dd.getDate()-89);
                var msFromDate =dd.getTime();
                var newFromDate = new Date(msFromDate) ;
                var newFromDateStr = $A.localizationService.formatDate(newFromDate,"yyyy-MM-dd");
                var fromDateRequest = newFromDateStr;
                var toDateRequest = $A.localizationService.formatDate(today,"yyyy-MM-dd");
		        
        if(isVCCD){
            var iVRDetails=component.get("v.iVRDetails");
            console.log("iVRDetails "+iVRDetails);            
            claimNumber=(!$A.util.isEmpty(iVRDetails.ClaimId__c)) ? iVRDetails.ClaimId__c:"";
            console.log("iVRDetails.ClaimsDOSMD__c>>>"+iVRDetails.ClaimsDOSMD__c);
            if(!$A.util.isEmpty(iVRDetails.ClaimsDOSMD__c)){
             var tempfromDate=new Date(iVRDetails.ClaimsDOSMD__c);
            fromDateRequest=$A.localizationService.formatDate(tempfromDate,"yyyy-MM-dd");
            tempfromDate.setDate(tempfromDate.getDate()+89)
        	 toDateRequest=$A.localizationService.formatDate(tempfromDate,"yyyy-MM-dd");
            }
            else{
                fromDateRequest = newFromDateStr;
                toDateRequest = $A.localizationService.formatDate(today,"yyyy-MM-dd");
            }
        }
        
        var ClaiminputFromLastClaim = component.get("v.ClaiminputFromLastClaim");
        if( !$A.util.isEmpty(ClaiminputFromLastClaim) ){
            fromDateRequest ="";
            toDateRequest="";
            claimNumber = ClaiminputFromLastClaim.claimNumber;
            interactionTaxValue =ClaiminputFromLastClaim.taxId;
        }

        component.set("v.selectedop",'all');
        //US2969925 - end here
      //  if(!$A.util.isEmpty(eligibleDate)){
        var Claiminputs = {
            "claimNumber": claimNumber,
            "taxId":interactionTaxValue,
            "ClaimType": "All",
            "FromDate":fromDateRequest,
            "ToDate": toDateRequest,
            "AuthId": "",
            "sourceCode":"all",
            "selectedop":"All",
            "startDateCompare":fromDateRequest,
            "payerId":( !$A.util.isUndefinedOrNull(memberSnap) ? memberSnap.searchQueryPayerId : "87726" )
        }; // US3701717: Swapnil
        return Claiminputs;
      //  }
    },
    validateInputs : function(component, event) {

        var claimInputs = component.get("v.Claiminputs");
        var frmDate = component.find("FromDate");
        var toDate = component.find("ToDate");
        var claimNumber = component.find("ClaimNumber");
        var taxID = component.find("taxId");
        var authId = component.find("AuthId");

        var eligibleDate = component.get("v.eligibleDate").split(" - ");

         var startDate = new Date(eligibleDate[0]);
        var startDateStr=$A.localizationService.formatDate(startDate,"yyyy-MM-dd");
         var endDate = new Date(eligibleDate[1]);
        var endDateStr=$A.localizationService.formatDate(endDate,"yyyy-MM-dd");
        if(!$A.util.isEmpty(claimInputs.FromDate))
        claimInputs.FromDate=$A.localizationService.formatDate(claimInputs.FromDate,"yyyy-MM-dd");
        if(!$A.util.isEmpty(claimInputs.ToDate))
        claimInputs.ToDate=$A.localizationService.formatDate(claimInputs.ToDate,"yyyy-MM-dd");
        if(claimInputs.FromDate=="Invalid Date")
         component.set("v.Claiminputs.FromDate", null);
         if(claimInputs.ToDate=="Invalid Date")
         component.set("v.Claiminputs.ToDate", null);
         if (!frmDate.checkValidity() || !toDate.checkValidity() ){
             if (component.get("v.isValidFrom")){
             frmDate.setCustomValidity("Your entry does not match the allowed format mm/dd/yyyy.");
             frmDate.reportValidity();
             }
             if (component.get("v.isValidTo")){
             toDate.setCustomValidity("Your entry does not match the allowed format mm/dd/yyyy.");
             toDate.reportValidity();
             }
			 var isVCCD=component.get("v.isVCCD");
			if(!isVCCD)
            return false;
              }
         if(!$A.util.isEmpty(claimInputs.claimNumber)){
            let error = {};
            if(claimInputs.claimNumber.length <4){
                error.message = "We hit a snag.";
                error.topDescription = "Review the following fields";
                error.descriptionList = ["Claim Number"];
                error.bottomDescription = "";
                component.set("v.error", error);
                component.set("v.showErrorMessage", true);
                // expand the error popup
                setTimeout(function() {
                    component.find("errorPopup").showPopup();
                }, 5);
                claimNumber.setCustomValidity("Enter at least four characters");
                claimNumber.reportValidity();
                return false;
            }
        }
        	if(!$A.util.isEmpty(claimInputs.taxId) && claimInputs.taxId.length < 9) {
            // populate error
            let error = {};
            error.message = "We hit a snag.";
            error.topDescription = "Review the following fields";
            error.descriptionList = ["Tax ID "];
            error.bottomDescription = "";
            component.set("v.error", error);
            component.set("v.showErrorMessage", true);
            // expand the error popup
            setTimeout(function() {
                component.find("errorPopup").showPopup();
            }, 5);
            taxID.setCustomValidity("Enter nine digits");
            taxID.reportValidity();
            return false;
        }
		 if(($A.util.isEmpty(claimInputs.taxId) && !$A.util.isEmpty(claimInputs.claimNumber))|| ($A.util.isEmpty(claimInputs.FromDate) && !$A.util.isEmpty(claimInputs.ToDate))||(!$A.util.isEmpty(claimInputs.FromDate) && $A.util.isEmpty(claimInputs.ToDate))||
             (!$A.util.isEmpty(claimInputs.taxId) && $A.util.isEmpty(claimInputs.claimNumber) && $A.util.isEmpty(claimInputs.FromDate) && $A.util.isEmpty(claimInputs.ToDate) && $A.util.isEmpty(claimInputs.AuthId)) ||($A.util.isEmpty(claimInputs.taxId) && $A.util.isEmpty(claimInputs.claimNumber) && $A.util.isEmpty(claimInputs.FromDate) && $A.util.isEmpty(claimInputs.ToDate) && $A.util.isEmpty(claimInputs.AuthId)) || ( !$A.util.isEmpty(claimInputs.claimNumber) && $A.util.isEmpty(claimInputs.taxId) && $A.util.isEmpty(claimInputs.FromDate) && $A.util.isEmpty(claimInputs.ToDate) && $A.util.isEmpty(claimInputs.AuthId)) || (!$A.util.isEmpty(claimInputs.AuthId) && $A.util.isEmpty(claimInputs.claimNumber) && $A.util.isEmpty(claimInputs.taxId) && $A.util.isEmpty(claimInputs.FromDate) && $A.util.isEmpty(claimInputs.ToDate) ) ){
           
           let error = {};
                        error.message = "We hit a snag.";
                        error.topDescription = "Search criteria must include ";
                        error.descriptionList = ["From + To","Claim Number + Tax ID"];
                        error.bottomDescription = "";
                        component.set("v.error", error);
                        component.set("v.showErrorMessage", true);
                        // expand the error popup
                        setTimeout(function() {
                            component.find("errorPopup").showPopup();
                        }, 5);
                        return false;
 
           }


       /* if(!$A.util.isEmpty(claimInputs.claimNumber) && claimInputs.taxId.length >= 9 && ($A.util.isEmpty(claimInputs.FromDate) || $A.util.isEmpty(claimInputs.ToDate))){
            let error = {};
            error.message = "We hit a snag.";
            error.topDescription = "Search criteria must include ";
            error.descriptionList = ["Tax ID + From + To","Claim Number + Tax ID + From + To"];
            error.bottomDescription = "";
            component.set("v.error", error);
            component.set("v.showErrorMessage", true);
            // expand the error popup
            setTimeout(function() {
                component.find("errorPopup").showPopup();
            }, 5);
            return false;
        }*/
        if(!$A.util.isEmpty(claimInputs.FromDate) && !$A.util.isEmpty(claimInputs.ToDate) && !$A.util.isEmpty(claimInputs.taxId)) {
                // populate error
                var totaldays = (new Date(claimInputs.ToDate) - new Date(claimInputs.FromDate))/(1000*60*60*24);
                if(claimInputs.FromDate > claimInputs.ToDate){
                    let error = {};
                    error.message = "We hit a snag.";
                    error.topDescription = "Review the following fields";
                    error.descriptionList = ["From","To"];
                    error.bottomDescription = "";
                    component.set("v.error", error);
                    component.set("v.showErrorMessage", true);
                    // expand the error popup
                    setTimeout(function() {
                        component.find("errorPopup").showPopup();
                    }, 100);
                    frmDate.setCustomValidity("Enter a date before the To date");
                    frmDate.reportValidity();
                    return false;
                }
        }
        if(!$A.util.isEmpty(claimInputs.claimNumber) || $A.util.isEmpty(claimInputs.taxId)){

            if(!$A.util.isEmpty(claimInputs.FromDate) && !$A.util.isEmpty(claimInputs.ToDate) || !$A.util.isEmpty(claimInputs.taxId)) {
                // populate error
                if(!$A.util.isEmpty(claimInputs.FromDate) && !$A.util.isEmpty(claimInputs.ToDate)){
                var totaldays = (new Date(claimInputs.ToDate) - new Date(claimInputs.FromDate))/(1000*60*60*24);
                if(claimInputs.FromDate > claimInputs.ToDate){
                    let error = {};
                    error.message = "We hit a snag.";
                    error.topDescription = "Review the following fields";
                    error.descriptionList = ["From","To"];
                    error.bottomDescription = "";
                    component.set("v.error", error);
                    component.set("v.showErrorMessage", true);
                    // expand the error popup
                    setTimeout(function() {
                        component.find("errorPopup").showPopup();
                    }, 100);
                    frmDate.setCustomValidity("Enter a date before the To date");
                    frmDate.reportValidity();
                    return false;
                }

            if(!(claimInputs.FromDate >= startDateStr && claimInputs.FromDate <= endDateStr) && !(claimInputs.ToDate >= startDateStr && claimInputs.ToDate <= endDateStr)){//US3528544 - Sravan
                let error = {};
                error.message = "We hit a snag.";
                error.topDescription = "Review the following fields";
                error.descriptionList = ["From","To"];
                error.bottomDescription = "";
                component.set("v.error", error);
                component.set("v.showErrorMessage", true);
                // expand the error popup
                setTimeout(function() {
                    component.find("errorPopup").showPopup();
                }, 100);
                if(!(claimInputs.FromDate >= startDateStr && claimInputs.FromDate <= endDateStr)){
                frmDate.setCustomValidity("From date is beyond the Policy Start date");
                frmDate.reportValidity();
                }

                if(!(claimInputs.ToDate >= startDateStr && claimInputs.ToDate <= endDateStr)){
                    toDate.setCustomValidity("To date is beyond the Policy End date");
                    toDate.reportValidity();
                }
                return false;
 }
                /*
               if(claimInputs.ToDate > endDateStr){
                let error = {};
                error.message = "We hit a snag.";
                error.topDescription = "Review the following fields";
                error.descriptionList = ["From","To"];
                error.bottomDescription = "";
                component.set("v.error", error);
                component.set("v.showErrorMessage", true);
                // expand the error popup
                setTimeout(function() {
                    component.find("errorPopup").showPopup();
                }, 100);
                toDate.setCustomValidity("Date(s) outside the selected policy eligible dates");
                toDate.reportValidity();
                return false;
 }*/

                if(Math.round(totaldays) > 365){
                    let error = {};
                    error.message = "We hit a snag.";
                    error.topDescription = "Review the following fields";
                    error.descriptionList = ["To"];
                    error.bottomDescription = "";
                    component.set("v.error", error);
                    component.set("v.showErrorMessage", true);
                    // expand the error popup
                    setTimeout(function() {
                        component.find("errorPopup").showPopup();
                    }, 5);
                    toDate.setCustomValidity("Enter a date within 365 days from the From date");
                    toDate.reportValidity();
                    return false;
                }}
                else if($A.util.isEmpty(claimInputs.taxId) && !$A.util.isEmpty(claimInputs.claimNumber)){
                   console.log("claim# and taxId is empty validation");
            let error = {};
            error.message = "We hit a snag.";
            error.topDescription = "Search criteria must include ";
             error.descriptionList = ["From + To","Claim Number + Tax ID"];
            error.bottomDescription = "";
            component.set("v.error", error);
            component.set("v.showErrorMessage", true);
            // expand the error popup
            setTimeout(function() {
                component.find("errorPopup").showPopup();
            }, 5);
            return false;
        }
                else if(claimInputs.taxId.length > 8 && claimInputs.claimNumber.length >3 ){
                    component.set("v.error", "");
                    component.set("v.showErrorMessage", false);
                    var ToDate = component.find("ToDate");
                    ToDate.setCustomValidity("");
                    ToDate.reportValidity();
                    return true;
                }

            }
        }

       /* if(!$A.util.isEmpty(claimInputs.claimNumber) && $A.util.isEmpty(claimInputs.taxId) && !$A.util.isEmpty(claimInputs.FromDate) && !$A.util.isEmpty(claimInputs.ToDate)){
            let error = {};
            error.message = "We hit a snag.";
            error.topDescription = "Search criteria must include ";
            error.descriptionList = ["Tax ID + From + To","Claim Number + Tax ID + From + To"];
            error.bottomDescription = "";
            component.set("v.error", error);
            component.set("v.showErrorMessage", true);
            // expand the error popup
            setTimeout(function() {
                component.find("errorPopup").showPopup();
            }, 5);
            return false;
        }*/
        /*if(!$A.util.isEmpty(claimInputs.claimNumber) && claimInputs.claimNumber.length >4 && $A.util.isEmpty(claimInputs.taxId) && $A.util.isEmpty(claimInputs.FromDate) && $A.util.isEmpty(claimInputs.ToDate)){
            let error = {};
            error.message = "We hit a snag.";
            error.topDescription = "Search criteria must include ";
            error.descriptionList = ["Tax ID + From + To","Claim Number + Tax ID + From + To"];
            error.bottomDescription = "";
            component.set("v.error", error);
            component.set("v.showErrorMessage", true);
            // expand the error popup
            setTimeout(function() {
                component.find("errorPopup").showPopup();
            }, 5);
            return false;
        }*/
        if($A.util.isEmpty(claimInputs.claimNumber) && $A.util.isEmpty(claimInputs.taxId) && $A.util.isEmpty(claimInputs.FromDate) && $A.util.isEmpty(claimInputs.ToDate) && !$A.util.isEmpty(claimInputs.AuthId) && claimInputs.AuthId.length < 10){
            // populate error
            let error = {};
            error.message = "We hit a snag.";
            error.topDescription = "Review the following fields";
            error.descriptionList = ["Auth / Referral Number"];
            error.bottomDescription = "";
            component.set("v.error", error);
            component.set("v.showErrorMessage", true);
            // expand the error popup
            setTimeout(function() {
                component.find("errorPopup").showPopup();
            }, 5);
            authId.setCustomValidity("Enter ten characters");
            authId.reportValidity();

            return false;

        }
        /*if($A.util.isEmpty(claimInputs.claimNumber) && $A.util.isEmpty(claimInputs.taxId) && $A.util.isEmpty(claimInputs.FromDate) && $A.util.isEmpty(claimInputs.ToDate)){
            let error = {};
            error.message = "We hit a snag.";
            error.topDescription = "Search criteria must include ";
            error.descriptionList = ["Tax ID + From + To","Claim Number + Tax ID + From + To"];
            error.bottomDescription = "";
            component.set("v.error", error);
            component.set("v.showErrorMessage", true);
            // expand the error popup
            setTimeout(function() {
                component.find("errorPopup").showPopup();
            }, 5);
            return false;
        }*/
        if(!$A.util.isEmpty(claimInputs.taxId) && claimInputs.taxId.length >= 9){
                if($A.util.isEmpty(claimInputs.FromDate)&&$A.util.isEmpty(claimInputs.ToDate)){
                    let error = {};
                    error.message = "We hit a snag.";
                    error.topDescription = "Search criteria must include ";
                    error.descriptionList = ["Tax ID + From + To","Claim Number + Tax ID + From + To"];
                    error.bottomDescription = "";
                    component.set("v.error", error);
                    component.set("v.showErrorMessage", true);
                    // expand the error popup
                    setTimeout(function() {
                        component.find("errorPopup").showPopup();
                    }, 5);
                    return false;
                }
                else if(!(claimInputs.FromDate >= startDateStr && claimInputs.FromDate <= endDateStr) && !(claimInputs.ToDate >= startDateStr && claimInputs.ToDate <= endDateStr)){//US3528544 - Sravan

                    let error = {};
                    error.message = "We hit a snag.";
                    error.topDescription = "Review the following fields";
                    error.descriptionList = ["From","To"];
                    error.bottomDescription = "";
                    component.set("v.error", error);
                    component.set("v.showErrorMessage", true);
                    // expand the error popup
                    setTimeout(function() {
                        component.find("errorPopup").showPopup();
                    }, 100);
                    if(!(claimInputs.FromDate >= startDateStr && claimInputs.FromDate <= endDateStr)){
                    frmDate.setCustomValidity("From date is beyond the Policy Start date");
                    frmDate.reportValidity();
                    }

                    if(!(claimInputs.ToDate >= startDateStr && claimInputs.ToDate <= endDateStr)){
                        toDate.setCustomValidity("To date is beyond the Policy End date");
                        toDate.reportValidity();
                    }
                    return false;
                }
                    /*else if(claimInputs.ToDate > endDateStr){
                        let error = {};
                        error.message = "We hit a snag.";
                        error.topDescription = "Review the following fields";
                        error.descriptionList = ["From","To"];
                        error.bottomDescription = "";
                        component.set("v.error", error);
                        component.set("v.showErrorMessage", true);
                        // expand the error popup
                        setTimeout(function() {
                            component.find("errorPopup").showPopup();
                        }, 100);
                        toDate.setCustomValidity("Date(s) outside the selected policy eligible dates");
                        toDate.reportValidity();
                        return false;
                    }*/
               else if(!$A.util.isEmpty(claimInputs.FromDate) && !$A.util.isEmpty(claimInputs.ToDate)) {
                     var totaldays = (new Date(claimInputs.ToDate) - new Date(claimInputs.FromDate))/(1000*60*60*24);
                     /*var fDate = claimInputs.FromDate;
                     var tDate = claimInputs.ToDate;
                     var frmYear = fDate.substring(0,4);
                     var toYear = tDate.substring(0,4);
                     var checkfrmDate=$A.localizationService.formatDate( new Date(frmYear,1,28),"yyyy-MM-dd");
                     var checktoDate=$A.localizationService.formatDate( new Date(toYear,1,28),"yyyy-MM-dd");
                     var leapyearcheck = false;
                     if(fDate<=checkfrmDate && this.checkLeapYear(component,frmYear)){
                         leapyearcheck= true;
                     }
                     else if(tDate > checktoDate && this.checkLeapYear(component,toYear)){
                         leapyearcheck = true;
                     }*/
                     if((Math.round(totaldays) >=365)){
                        let error = {};
                        error.message = "We hit a snag.";
                        error.topDescription = "Review the following fields";
                        error.descriptionList = ["To"];
                        error.bottomDescription = "";
                        component.set("v.error", error);
                        component.set("v.showErrorMessage", true);
                        // expand the error popup
                        setTimeout(function() {
                            component.find("errorPopup").showPopup();
                        }, 5);
                        toDate.setCustomValidity("Enter a date within 365 days from the From date");
                        toDate.reportValidity();
                        return false;
                    }
                   else{
                       component.set("v.error", "");
                       component.set("v.showErrorMessage", false);
                        var ToDate = component.find("ToDate");
            			ToDate.setCustomValidity("");
            			ToDate.reportValidity();
                       return true;
                   }
                }

            }
        if(!$A.util.isEmpty(claimInputs.FromDate) && !$A.util.isEmpty(claimInputs.ToDate)) {
                    // populate error
                    var totaldays = (new Date(claimInputs.ToDate) - new Date(claimInputs.FromDate))/(1000*60*60*24);
                    if(claimInputs.FromDate > claimInputs.ToDate){
                        let error = {};
                        error.message = "We hit a snag.";
                        error.topDescription = "Review the following fields";
                        error.descriptionList = ["From","To"];
                        error.bottomDescription = "";
                        component.set("v.error", error);
                        component.set("v.showErrorMessage", true);
                        // expand the error popup
                        setTimeout(function() {
                            component.find("errorPopup").showPopup();
                        }, 100);
                        frmDate.setCustomValidity("Enter a date before the To date");
                        frmDate.reportValidity();
                        return false;
                    }

                    if(!(claimInputs.FromDate >= startDateStr && claimInputs.FromDate <= endDateStr) && !(claimInputs.ToDate >= startDateStr && claimInputs.ToDate <= endDateStr)){//US3528544 - Sravan
                        let error = {};
                        error.message = "We hit a snag.";
                        error.topDescription = "Review the following fields";
                        error.descriptionList = ["From","To"];
                        error.bottomDescription = "";
                        component.set("v.error", error);
                        component.set("v.showErrorMessage", true);
                        // expand the error popup
                        setTimeout(function() {
                            component.find("errorPopup").showPopup();
                        }, 100);
                        if((claimInputs.FromDate >= startDateStr && claimInputs.FromDate <= endDateStr)){
                        frmDate.setCustomValidity("From date is beyond the Policy Start date");
                        frmDate.reportValidity();
                        }
                        if(!(claimInputs.ToDate >= startDateStr && claimInputs.ToDate <= endDateStr)){
                            toDate.setCustomValidity("To date is beyond the Policy End date");
                            toDate.reportValidity();
                        }
                        return false;
                    }
                   /* if(claimInputs.ToDate > endDateStr){
                        let error = {};
                        error.message = "We hit a snag.";
                        error.topDescription = "Review the following fields";
                        error.descriptionList = ["From","To"];
                        error.bottomDescription = "";
                        component.set("v.error", error);
                        component.set("v.showErrorMessage", true);
                        // expand the error popup
                        setTimeout(function() {
                            component.find("errorPopup").showPopup();
                        }, 100);
                        toDate.setCustomValidity("Date(s) outside the selected policy eligible dates");
                        toDate.reportValidity();
                        return false;
                    }*/

                   /* var fDate = claimInputs.FromDate;
                    var tDate = claimInputs.ToDate;
                    var frmYear = fDate.substring(0,4);
                    var toYear = tDate.substring(0,4);
                    var checkfrmDate=$A.localizationService.formatDate( new Date(frmYear,1,28),"yyyy-MM-dd");
                    var checktoDate=$A.localizationService.formatDate( new Date(toYear,1,28),"yyyy-MM-dd");
                    var leapyearcheck = false;
                    if(fDate<=checkfrmDate && this.checkLeapYear(component,frmYear)){
                        leapyearcheck= true;
                    }
                    else if(tDate > checktoDate && this.checkLeapYear(component,toYear)){
                        leapyearcheck = true;
                    }*/
                            if((Math.round(totaldays) >=365)){
                        let error = {};
                        error.message = "We hit a snag.";
                        error.topDescription = "Review the following fields";
                        error.descriptionList = ["To"];
                        error.bottomDescription = "";
                        component.set("v.error", error);
                        component.set("v.showErrorMessage", true);
                        // expand the error popup
                        setTimeout(function() {
                            component.find("errorPopup").showPopup();
                        }, 5);
                        toDate.setCustomValidity("Enter a date within 365 days from the From date");
                        toDate.reportValidity();
                        return false;
                    } else{
                       component.set("v.error", "");
                       component.set("v.showErrorMessage", false);
                        var ToDate = component.find("ToDate");
            			ToDate.setCustomValidity("");
            			ToDate.reportValidity();
                       return true;
                    }

                  /*  if($A.util.isEmpty(claimInputs.taxId) && !$A.util.isEmpty(claimInputs.AuthId) && claimInputs.AuthId.length == 10){
                        let error = {};
                        error.message = "We hit a snag.";
                        error.topDescription = "Search criteria must include ";
                        error.descriptionList = ["Tax ID + From + To","Claim Number + Tax ID + From + To"];
                        error.bottomDescription = "";
                        component.set("v.error", error);
                        component.set("v.showErrorMessage", true);
                        // expand the error popup
                        setTimeout(function() {
                            component.find("errorPopup").showPopup();
                        }, 5);
                        return false;

                    }*/
                    /*if($A.util.isEmpty(claimInputs.taxId)){
                        let error = {};
                        error.message = "We hit a snag.";
                        error.topDescription = "Search criteria must include ";
                        error.descriptionList = ["Tax ID + From + To","Claim Number + Tax ID + From + To"];
                        error.bottomDescription = "";
                        component.set("v.error", error);
                        component.set("v.showErrorMessage", true);
                        // expand the error popup
                        setTimeout(function() {
                            component.find("errorPopup").showPopup();
                        }, 5);
                        return false;

                    }*/
                }
        if(!$A.util.isEmpty(claimInputs.AuthId) && claimInputs.AuthId.length < 10) {
                        // populate error
                        let error = {};
                        error.message = "We hit a snag.";
                        error.topDescription = "Review the following fields";
                        error.descriptionList = ["Auth / Referral Number"];
                        error.bottomDescription = "";
                        component.set("v.error", error);
                        component.set("v.showErrorMessage", true);
                        // expand the error popup
                        setTimeout(function() {
                            component.find("errorPopup").showPopup();
                        }, 5);
                        authId.setCustomValidity("Enter ten characters");
                        authId.reportValidity();

                        return false;
                    }
         if(claimInputs.AuthId >= 10){
                            if($A.util.isEmpty(claimInputs.claimNumber) && $A.util.isEmpty(claimInputs.taxId) && $A.util.isEmpty(claimInputs.FromDate) && $A.util.isEmpty(claimInputs.ToDate)){
                                let error = {};
                                error.message = "We hit a snag.";
                                error.topDescription = "Search criteria must include ";
                                error.descriptionList = ["Tax ID + From + To","Claim Number + Tax ID + From + To"];
                                error.bottomDescription = "";
                                component.set("v.error", error);
                                component.set("v.showErrorMessage", true);
                                // expand the error popup
                                setTimeout(function() {
                                    component.find("errorPopup").showPopup();
                                }, 5);
                                return false;

                            }
                        }

    },
    //ketki - 8/31
    searchClaims : function(component,event,helper) {

        //component.set('v.showClaimResults', true);
        //var claimtypeTemp = component.get("v.Claiminputs.selectedop");
        var ClaimNumberVal = component.find("ClaimNumber").get("v.value");
        component.set("v.Claiminputs.claimNumber",ClaimNumberVal.toUpperCase());
        console.log('clmnum'+ClaimNumberVal);
        var claimtypeTemp = component.get("v.Claiminputs.ClaimType");
        //console.log('type0p'+claimtypeTemp);
        console.log('type'+claimtypeTemp);
       	if(claimtypeTemp=='AllIntial'||claimtypeTemp=='All'){
            component.set("v.Claiminputs.ClaimType","A");
        }
        if(claimtypeTemp=='hospital'){
            component.set("v.Claiminputs.ClaimType","H");
        }
        if(claimtypeTemp=='physician'){
            component.set("v.Claiminputs.ClaimType","P");
        }
        var claimInput=  component.get("v.Claiminputs");

        //ketki get member based on policy change
        var memberCardData =  component.get("v.memberCardData");
        var policySelectedIndex =  component.get("v.policySelectedIndex");
        claimInput.memberId = memberCardData.CoverageLines[policySelectedIndex].patientInfo.MemberId;
        claimInput.memberDOB = memberCardData.CoverageLines[policySelectedIndex].patientInfo.dobVal;
        console.log("ketki log 10/24 claimInput value: "+  JSON.stringify(claimInput));
		var compEvent = component.getEvent("acetClaimSearchEvent");
        compEvent.setParams({
			"claimInput":claimInput,
			"isEvent":true
			});
        
		var isVCCD=component.get("v.isVCCD");
		var onLoad = component.get("v.onLoad");
        this.validateInputs(component,event);
		if(onLoad){
           component.set("v.onLoad",false);
		if(isVCCD){
	       var showClaimResults = this.validateInputs(component,event);
	       if(showClaimResults)        
        compEvent.fire();

		}else
		compEvent.fire();
	}else{ 
	component.set("v.claimInput2",claimInput);
      }
        //debugger;
        /*var claimtypeTemp = component.get("v.Claiminputs.selectedop");
        console.log('type'+claimtypeTemp);
       	if(claimtypeTemp=='All'){
            component.set("v.Claiminputs.ClaimType","A");
        }
        if(claimtypeTemp=='hospital'){
            component.set("v.Claiminputs.ClaimType","H");
        }
        if(claimtypeTemp=='physician'){
            component.set("v.Claiminputs.ClaimType","P");
        }
        var action = component.get('c.getClaimsAutodoc');
        var payerId = '87726';
        action.setParams({
            "claimInputs":component.get("v.Claiminputs")
        });
        action.setCallback(this, function(response) {
            var state = response.getState(); // get the response state
            console.log('state@@@' + state);
            var result = response.getReturnValue();
            console.log('Msg>>> ' + JSON.stringify(result));
            component.set("v.autodocClaimResult",result);
            //Ketki temp

            if(result != null && result != undefined ){
                component.set('v.showClaimResults', true);
                var compEvent = component.getEvent("acetClaimSearchEvent");
                //compEvent.setParams({"claimSearchResult":result});
                compEvent.setParams({"claimInput":claim});
                console.log("firing acetClaimSearchEvent ");
                compEvent.fire();
            }

            //Ketki temp
        });
        $A.enqueueAction(action);*/
    },
    /*searchClaims : function(component,event,helper) {
        //debugger;
        var action = component.get('c.searchClaims');
        var payerId = '87726';
        action.setParams({
            "claimInputs":component.get("v.Claiminputs")
        });
        action.setCallback(this, function(response) {
            var state = response.getState(); // get the response state
            console.log('state@@@' + state);

            if(state == 'SUCCESS') {
                var result = response.getReturnValue();
                console.log('Msg>>> ' + JSON.stringify(result));
                if (result.statusCode == 200) {
                    component.set("v.errorMsgClaimSearch",'');
                    component.set("v.noClaimSearchResultFlag",false);
                    var dataRes = result.responseDataToReturn.claimResultLst;
                    var mapData = result.responseDataToReturn.mapClaimDetails;
                    if(dataRes != null && dataRes != undefined && dataRes.length > 0){
                        component.set('v.showClaimResults', true);
                        var compEvent = component.getEvent("claimSearchEvent");
                        compEvent.setParams({"claimSearchResult":dataRes});
                        compEvent.setParams({"mapClaimDetails":mapData});
                        compEvent.fire();
                    }
                }else{
                    if (result.statusCode == 400) {
                        var errorMsg = result.message;
                        console.log('error>>>>'+ errorMsg);
                        component.set("v.errorMsgClaimSearch",errorMsg);
                        component.set("v.noClaimSearchResultFlag",true);
                    }
                    else{
                        var errorMsg = result.message;
                        console.log('error>>>>'+ errorMsg);
                        component.set("v.errorMsgClaimSearch",errorMsg);
                        component.set("v.noClaimSearchResultFlag",true);
                    }
                }
                this.hideClaimSpinner(component);
            }
        });
        $A.enqueueAction(action);
    },*/


})