({
    onLoad : function(component, event, helper) {
        let error = new Object();
        error.message = "";
        error.topDescription = "";
        error.bottomDescription = "";
        error.descriptionList = [];
        component.set("v.error", error);
        component.set("v.Claiminputs", helper.initializeClaimInputsDetails(component));
		component.set("v.onLoad",true);
        //helper.searchClaims(component, event, helper);

        setTimeout(function() {
            var doSearch = component.get("c.doSearch");
            $A.enqueueAction(doSearch);
        }, 100);
    },


    handleChange: function (component, event) {
        // This will contain the string of the "value" attribute of the selected option

        var selectedOptionValue = event.getParam("value");
        console.log('selectedOptionValue'+selectedOptionValue);
        if(selectedOptionValue=='AllIntial'||selectedOptionValue=='All'||selectedOptionValue=='all'){
            component.set("v.Claiminputs.ClaimType","A");
        }
        if(selectedOptionValue=='hospital'){
            component.set("v.Claiminputs.ClaimType","H");
        }
        if(selectedOptionValue=='physician'){
            component.set("v.Claiminputs.ClaimType","P");
        }
    },



    allowOnlyNumbers: function(component, event, helper){
        var dateCode = (event.which) ? event.which : event.keyCode;
        if( dateCode > 31 && (dateCode < 48 || dateCode > 57)){
            if(event.preventDefault){
                event.preventDefault();
            }else{
                event.returnValue = false;
            }
        }
    },
    // US1918629: Venkat -17th Sep 2020 Start
    AuthClaimTypeDisable: function (component, event, helper) {
         var tDate=component.find("ToDate");
         var claimInputs = component.get("v.Claiminputs");
         tDate.setCustomValidity("");
         tDate.reportValidity();
         component.set("v.isValidTo", false);
        if (!tDate.checkValidity()){
         tDate.setCustomValidity("     ");
         tDate.reportValidity();
         component.set("v.isValidTo", true);
        }
       if(claimInputs.claimNumber.length>3 ||$A.util.isEmpty(claimInputs.claimNumber)){
           component.find("ClaimNumber").setCustomValidity("");
           component.find("ClaimNumber").reportValidity();
               }
       if(claimInputs.taxId.length>8 || $A.util.isEmpty(claimInputs.taxId)){
           component.find("taxId").setCustomValidity("");
           component.find("taxId").reportValidity();
                 }
        var ClaimNumberVal = component.find("ClaimNumber").get("v.value");
        var TaxVal = component.find("taxId").get("v.value");
        var FromDateval = component.find("FromDate").get("v.value");
        var TodateVal = component.find("ToDate").get("v.value");
        //   if (!$A.util.isEmpty(ClaimNumberVal)) {
        if ((!$A.util.isEmpty(ClaimNumberVal)) &&  (!$A.util.isEmpty(TaxVal)) && (!$A.util.isEmpty(FromDateval)) && (!$A.util.isEmpty(TodateVal))) {

            component.set("v.disableClaimAuth", true);
        }
        else {
            component.set("v.disableClaimAuth", false);
        }




    },
    //US1918629: Venkat -15th Sep 2020 End

    doSearch: function (component, event, helper) {
        var showClaimResults = helper.validateInputs(component,event);
        console.log('showClaimResults'+showClaimResults);
        component.set('v.showClaimResults', false);
        //US3415625 - Sravan - Start
        var isAdvanceSearchPerformed = component.get("v.isAdvanceSearchPerformed");
        //US3415625 - Sravan - End

        //helper.showClaimSpinner(component);
        //helper.searchClaims(component, event, helper);
        if(showClaimResults){
            //US3415625 - Sravan - Start

                helper.searchClaims(component, event, helper);

             //US3415625 - Sravan - End
        }
    },

    onAdvInpChange: function(cmp,event,helper){
        var selectedFilter = cmp.get("v.selectedFilter");
        if(!$A.util.isEmpty(selectedFilter)){
            if(selectedFilter == 'Authorization #' || (selectedFilter == 'CPT/HCPC Code' || selectedFilter == 'Remark Code' || selectedFilter == 'Revenue Code')){
                var advInput = cmp.find("advInputFieldVal");
                advInput.checkValidity();
                advInput.reportValidity();
            }
        }

    },

    onAdvCombChange : function(cmp,event,helper){
        var selectedFilter = cmp.get("v.selectedFilter");
        if(!$A.util.isEmpty(selectedFilter)){
            if(selectedFilter == 'Claim Level Cause Code' || selectedFilter == 'Code Range'){
                var advCombInput = cmp.find("advFilterComboValue");
                if (  advCombInput.get("v.value") == '' || advCombInput.get("v.value") == null || advCombInput.get("v.value") == undefined) {
                    advCombInput.setCustomValidity('Complete this field.');
                    advCombInput.reportValidity();
                }
                else{
                    advCombInput.setCustomValidity('');
                    advCombInput.reportValidity();
                }

            }
        }

    },

    doAdvSearch: function(cmp,event,helper){
    var errCount = 0;
    var filter= cmp.find("selectFilter");
    if (  filter.get("v.value") == '' || filter.get("v.value") == null || filter.get("v.value") == undefined) {
        filter.setCustomValidity('Complete this field.');
        errCount = errCount+1;
        filter.reportValidity();
    }
    else{
        filter.setCustomValidity('');
        filter.reportValidity();
    }
    var selectedFilter = cmp.get("v.selectedFilter");
    if(!$A.util.isEmpty(selectedFilter)){
        if(selectedFilter == 'Authorization #' || (selectedFilter == 'CPT/HCPC Code' || selectedFilter == 'Remark Code' || selectedFilter == 'Revenue Code')){
            var advInput = cmp.find("advInputFieldVal");
            advInput.checkValidity();
            advInput.reportValidity();
        }
        else if(selectedFilter == 'Claim Level Cause Code' || selectedFilter == 'Code Range'){
            var advCombInput = cmp.find("advFilterComboValue");
            if (  advCombInput.get("v.value") == '' || advCombInput.get("v.value") == null || advCombInput.get("v.value") == undefined) {
                advCombInput.setCustomValidity('Complete this field.');
                errCount = errCount+1;
                advCombInput.reportValidity();
            }
            else{
                advCombInput.setCustomValidity('');
                advCombInput.reportValidity();
            }

        }
    }


    if( errCount == 0){
        var selectedFilter = cmp.get("v.selectedFilter");
        var inpValue = cmp.get("v.advFilterInputValue");
        if( !$A.util.isEmpty(selectedFilter)  ){
            var advClaimInput = {
                'selectedFilter':selectedFilter,
                'inpValue':inpValue,
                'isAdvanceSearch': false
            };
            if( ( selectedFilter != 'Applied to OOP' && selectedFilter != 'Deductible Only' && !$A.util.isEmpty(inpValue) )){
                advClaimInput.isAdvanceSearch = true;
                cmp.set('v.advClaimInput',advClaimInput);
            }
            else if(selectedFilter == 'Applied to OOP' || selectedFilter == 'Deductible Only'){
                advClaimInput.isAdvanceSearch = true;
                cmp.set('v.advClaimInput',advClaimInput);

            }

        }
    }
    //US3415625 - Sravan - Start
    cmp.set("v.isAdvanceSearchPerformed",true);
    //US3415625 - Sravan - End
    },

    doAdvanceShow: function (cmp, event, helper) {
        cmp.set("v.openAdvanceSearch",!cmp.get("v.openAdvanceSearch"));
    },
    onSelectedFilter: function(cmp,event,helper){
        var selectedFilter = cmp.get("v.selectedFilter");
        console.log('=@#SelectedFilter'+cmp.get("v.selectedFilter"));
        cmp.set("v.advFilterInputValue","");
        cmp.set("v.showAdvInpField",false);
        if(!$A.util.isEmpty(selectedFilter)){
            var filter= cmp.find("selectFilter");
            filter.setCustomValidity('');
            filter.reportValidity();
            if(selectedFilter == 'Authorization #'){
                cmp.set("v.placeHold",'Enter SRN#');
                cmp.set("v.showAdvInpField",true);
            }
            else if(selectedFilter == 'CPT/HCPC Code' || selectedFilter == 'Remark Code' || selectedFilter == 'Revenue Code'){
                cmp.set("v.placeHold",'Code');
                cmp.set("v.showAdvInpField",true);
            }
            else if(selectedFilter == 'Claim Level Cause Code'){
                var CCOptions = [
                    {'label': 'Select', 'value': ''},
                    {'label': 'A - Accident', 'value': 'A - Accident'},
                    {'label': '0 - General Illness', 'value': '0 - General Illness'},
                    {'label': '1 - Psychiatric', 'value': '1 - Psychiatric'},
                    {'label': '2 - Normal Maternity', 'value': '2 - Normal Maternity'},
                    {'label': '3 - Emergency Illness', 'value': '3 - Emergency Illness'},
                    {'label': '4 - Routine', 'value': '4 - Routine'},
                    {'label': '5 - Complications of Pregnancy', 'value': '5 - Complications of Pregnancy'},
                    {'label': '6 - Alcohol / Substance Abuse', 'value': '6 - Alcohol / Substance Abuse'},
                    ];
                cmp.set("v.dynOptions",CCOptions);
            }
            else if(selectedFilter == 'Code Range'){
                var CROptions = [
                    {'label': 'Select', 'value': ''},
                    {'label': '00100 - 01999 Anesthesia', 'value': '00100 - 01999 Anesthesia'},
                    {'label': '10000 - 69999 Surgery', 'value': '10000 - 69999 Surgery'},
                    {'label': '70000 - 79999 Radiology', 'value': '70000 - 79999 Radiology'},
                    {'label': '80000 - 89999 Pathology and Laboratory', 'value': '80000 - 89999 Pathology and Laboratory'},
                    {'label': '90701 - 99199 Medicine', 'value': '90701 - 99199 Medicine'},
                    {'label': '99201 - 99499 Evaluation and Management', 'value': '99201 - 99499 Evaluation and Management'},
                    ];
                cmp.set("v.dynOptions",CROptions);
            }
        }
        else{
        }

    },

    resetAdvFilter: function(cmp,event,helper){
        cmp.set("v.advFilterInputValue","");
        cmp.set("v.selectedFilter","");
        cmp.set("v.showAdvInpField",false);
    },

    doClear: function(component,event){
        var options = [
            { value: "all", label: "All" },
            { value: "hospital", label: "Hospital" },
            { value: "physician", label: "Physician" },];
            //component.set('v.showClaimResults', false);
            component.set('v.Claiminputs.claimNumber','');
            component.set('v.Claiminputs.taxId','');
            component.set('v.Claiminputs.FromDate','');
            component.set('v.Claiminputs.ToDate','');
            component.set('v.Claiminputs.ClaimTypeOptions',options);
            component.set('v.Claiminputs.ClaimType','All');
            component.set('v.selectedop','all');
            component.set('v.Claiminputs.AuthId','');
            component.set("v.disableClaimAuth", false);
            // US1918629: Venkat -15th Sep 2020

            //var compEvent = component.getEvent("claimSearchEvent");
            //compEvent.setParams({"claimSearchResult":0});
            let error = {};
            error.message = "";
            error.topDescription = " ";

            error.bottomDescription = "";
            component.set("v.error", error);
            component.set("v.showErrorMessage",false);
            // expand the error popup
            setTimeout(function() {
            component.find("errorPopup").showPopup();
            }, 100);
            var claimNum = component.find("ClaimNumber");
            claimNum.setCustomValidity("");
            claimNum.reportValidity();
            var taxId = component.find("taxId");
            taxId.setCustomValidity("");
            taxId.reportValidity();
            var authId = component.find("AuthId");
            if(!$A.util.isUndefinedOrNull(authId)){
            authId.setCustomValidity("");
            authId.reportValidity();
            }

            var FromDate = component.find("FromDate");
            FromDate.setCustomValidity("");
            FromDate.reportValidity();
            var ToDate = component.find("ToDate");
            ToDate.setCustomValidity("");
            ToDate.reportValidity();
            //compEvent.fire();
            //ketki clear using acetClaimSearch Event
            var compEvent = component.getEvent("acetClaimSearchEvent");
            var claimInput=  component.get("v.Claiminputs");
            //KJ clear button functionality
            compEvent.setParams({"claimInput":'',"isEvent":true});
            console.log("firing acetClaimSearchEvent ");
            compEvent.fire();
            //ketki clear using acetClaimSearch Event end
            },

            onDateChange :function(component, event, helper) {
            var fDate=component.find("FromDate");
            var tDate=component.find("ToDate");
             fDate.setCustomValidity("");
            fDate.reportValidity();
            component.set("v.isValidFrom",false);
            if (!fDate.checkValidity()){
            fDate.setCustomValidity("     ");
            fDate.reportValidity();
            component.set("v.isValidFrom", true);
            }
            if(fDate.get("v.value")!=null){
            var frmDate = new Date(component.get("v.Claiminputs.FromDate"));
            var fromDate= new Date(frmDate);
            console.log("the from date is: "+fromDate);
            //var dd = new Date();
            var fromDateone = component.get("v.Claiminputs.FromDate");
            var arrDate = fromDateone.split("-");
            var yyyy = arrDate[0];
            var mm = arrDate[1];
            var dd = arrDate[2];
            var mmValue = parseInt(mm);
            mmValue = mmValue - 1;
            var todaynewtemp = new Date(yyyy,mmValue,dd,'00','01','00','000');
            todaynewtemp.setDate(todaynewtemp.getDate()+89);
            //fromDate.setDate(fromDate.getDate()+89);
            var msFromDate =todaynewtemp.getTime();
            console.log("the msFromDate is: "+msFromDate);

            var newToDate = new Date(msFromDate) ;
            console.log ("new To Date:"+newToDate);

            var toDateStr=$A.localizationService.formatDate(newToDate,"yyyy-MM-dd");
            component.set("v.Claiminputs.ToDate",toDateStr);
            // US1918629: Venkat -17th Sep 2020 Start

            var ClaimNumberVal = component.find("ClaimNumber").get("v.value");
            var TaxVal = component.find("taxId").get("v.value");
            var FromDateval = component.find("FromDate").get("v.value");
            var TodateVal = component.find("ToDate").get("v.value");
             tDate.setCustomValidity("");
            tDate.reportValidity();
            //   if (!$A.util.isEmpty(ClaimNumberVal)) {
            if ((!$A.util.isEmpty(ClaimNumberVal)) &&  (!$A.util.isEmpty(TaxVal)) && (!$A.util.isEmpty(FromDateval)) && (!$A.util.isEmpty(TodateVal))) {

            component.set("v.disableClaimAuth", true);
            }
            else {
            component.set("v.disableClaimAuth", false);
            }
            }
            // US1918629: Venkat -17th Sep 2020 End
            },

            dateCheck :function(component, event, helper) {
            var dateCode = (event.which) ? event.which : event.keyCode;
            if(dateCode != 47 && dateCode !=46 && dateCode > 31 && (dateCode < 48 || dateCode > 57)){
            if(event.preventDefault){
            event.preventDefault();
            }else{
            event.returnValue = false;
            }
            }
            },
            claimCheck :function(component, event, helper) {
            var textnumCode = (event.which) ? event.which : event.keyCode;
            if(textnumCode === 32){
            event.preventDefault();
            }
            if(textnumCode > 31 && (textnumCode < 48 || textnumCode > 57) && (textnumCode <65 || textnumCode > 90) &&
            (textnumCode < 97 || textnumCode >= 123) && textnumCode !=32){
            if(event.preventDefault){
            event.preventDefault();
            }else{
            event.returnValue = false;
            }
            }
            },

            claimSearchRefresh : function(component, event, helper){
				var uniqueTabId = event.getParam("uniqueTabID");
        	var memberId=component.get("v.memberTabId");
            if(!$A.util.isUndefinedOrNull(uniqueTabId) && (memberId!=uniqueTabId))
            return false;
            component.set("v.ClaiminputFromLastClaim",null);
            var selectedPolicy= event.getParams("selectedPolicy");
            console.log("selected policy coming on claim search controller:"+selectedPolicy);
            var frmDate = component.find("FromDate");
            console.log('frmdata',frmDate);
            var todate = component.find("ToDate");
            let error = new Object();
            error.message = "";
            error.topDescription = "";
            error.bottomDescription = "";
            error.descriptionList = [""];
        component.set("v.error", error);
        component.set("v.showErrorMessage", false);
        frmDate.setCustomValidity("");
        frmDate.reportValidity();
        todate.setCustomValidity("");
        todate.reportValidity();
        component.set("v.Claiminputs", helper.initializeClaimInputsDetails(component));
        component.set("v.disableClaimAuth", false);

        //Ketki Remove Autodoc when policy changes begin

        var autoDocToBeDeleted= event.getParam("autoDocToBeDeleted");
        if( autoDocToBeDeleted.doNotRetainAutodDoc){
            _autodoc.deleteAutodoc(component.get("v.autodocUniqueId"), autoDocToBeDeleted.selectedPolicyKey );
        }
        //Ketki Remove Autodoc when policy changese end

        //$A.util.addClass(frmDate, "frmdatehide");
        //Added by mani 11/20/2020 US3031152--Start
        var a = component.get('c.doSearch');
        $A.enqueueAction(a);
        //Added by Mani -- End
    },


     //US3415625 - Sravan - Start
     enableAdvanceSearch : function(component,event,helper){
         component.set("v.showAdvanceSerchCriteriaPopup",false);
         if (event.getSource().get("v.label") == "No") {
                component.set("v.isAdvanceSearchPerformed",false);
                component.set("v.showAdvanceSearch",false);
                component.set("v.selectedFilter",'');
                component.set("v.openAdvanceSearch",!component.get("v.openAdvanceSearch"));
                helper.searchClaims(component, event, helper);
         }
         else{
            component.doAdvanceSearch();
         }
     },
    //US3415625 - Sravan - End

    enablePopup: function(component, event, helper){
    	 //US3415625 - Sravan - Start
        var isAdvanceSearchPerformed = component.get("v.isAdvanceSearchPerformed");
        if(isAdvanceSearchPerformed){
        	component.set("v.showAdvanceSerchCriteriaPopup",true);
        }
        //US3415625 - Sravan - End
    },
    onClickOfEnter : function(cmp,event, helper) {
        if (event.keyCode === 13 && event.target.className != 'linkField') {
            event.preventDefault();
            var doSearch = cmp.get("c.doSearch");
            $A.enqueueAction(doSearch);
        }
    },

})