({
    // US3305963 - Thanish - 18th Mar 2021
    pcpReferralsErrorMessage: "Unexpected Error Occurred in the Referral Results Card. Please try again. If problem persists please contact the help desk",

    //US2856421-Creating a Case for View PCP Referrals for ACET- UI
    handleSaveModal: function (component, event, helper) {
        var cmpid = component.get('v.componentId');
        var caseWrapper = component.get('v.caseWrapper');
        var selectedPolicy = component.get('v.policy');
        if(!$A.util.isUndefinedOrNull(selectedPolicy) &&  !$A.util.isUndefinedOrNull(selectedPolicy.resultWrapper) &&
           !$A.util.isUndefinedOrNull(selectedPolicy.resultWrapper.policyRes) && !$A.util.isUndefinedOrNull(selectedPolicy.resultWrapper.policyRes)){
            caseWrapper.policyNumber = selectedPolicy.resultWrapper.policyRes.policyNumber;
            
            if( !$A.util.isUndefinedOrNull(selectedPolicy.resultWrapper.policyRes.sourceCode) ){
                //US2862033 - No need  to Create ORS Casefor AP, PA Policies but  need to create for CO and CS Policies
                if(selectedPolicy.resultWrapper.policyRes.sourceCode == 'AP' || selectedPolicy.resultWrapper.policyRes.sourceCode == 'PA') {

                    caseWrapper.createORSCase = false;
                } else {
                    // if other than C&S member, ORS case will be created and Currently making false as part of US2856421
                    caseWrapper.createORSCase = true;//US2862033
                }
            }
        }

        // Save Case Consolidation - US3424763
        // var defaultAutoDoc = this.getAutoDocObject(component);
        // var jsString = JSON.stringify(defaultAutoDoc);
        // caseWrapper.savedAutodoc = jsString;

        component.set("v.caseWrapper", caseWrapper);
        // component.set("v.isModalOpen", true);
    },
     initHanlder : function(component,event,helper){
        this.processInputRequest(component,event,helper);
    },

    processInputRequest : function(component,event,helper){
         var inpRequest = {
            "memberId": "",
            "policyNumber": "",
            "firstName":"",
            "dateOfBirth": "",
            "firstDateOfService": "",
            "lastDateOfService": "",
            "payerId": "",
            "alloff":"0",
            "newReferralNumber": ""
        };
        component.set("v.showCreateNewCaseButton",false);
        var memberData = component.get("v.memberCardSnap");
        var memberDOBVar = component.get("v.memberDOB");
        if (!$A.util.isUndefinedOrNull(memberData) && !$A.util.isEmpty(memberData)) {
            if(!$A.util.isUndefinedOrNull(memberData.firstName)  && !$A.util.isEmpty(memberData.firstName) ){
                inpRequest.firstName = memberData.firstName;
            }
            else if(!$A.util.isUndefinedOrNull(component.get("v.memberFN")) && !$A.util.isEmpty(component.get("v.memberFN"))  ) {
                inpRequest.firstName = component.get("v.memberFN");
            }
            if(!$A.util.isUndefinedOrNull(memberData.memberDOB)  && !$A.util.isEmpty(memberData.memberDOB) ){
                var memberDOBArray  = memberData.memberDOB.split("/");
                inpRequest.dateOfBirth = memberDOBArray[2] + '-' + memberDOBArray[0] + '-' + memberDOBArray[1];
            }
            else if(!$A.util.isUndefinedOrNull(memberDOBVar) && !$A.util.isEmpty(memberDOBVar) ){
                var memberDOBArray  = memberDOBVar.split("/");
                inpRequest.dateOfBirth = memberDOBArray[2] + '-' + memberDOBArray[0] + '-' + memberDOBArray[1];
            }
            if(!$A.util.isUndefinedOrNull(memberData.memberId) && !$A.util.isEmpty(memberData.memberId) ){
                inpRequest.memberId = memberData.memberId;
            }
            else if (!$A.util.isUndefinedOrNull(component.get("v.houseHoldMemberId")) && !$A.util.isEmpty(component.get("v.houseHoldMemberId")) ) {
                inpRequest.memberId = component.get("v.houseHoldMemberId");
            }
        }
        if (!$A.util.isUndefinedOrNull(component.get("v.policyNumber")) && !$A.util.isEmpty(component.get("v.policyNumber"))) {
                inpRequest.policyNumber = component.get("v.policyNumber");
            }
        var memberPolicies = component.get("v.memberPolicies");
        var memberCardDetailData = component.get("v.memberCardData");
        var currentTranscationId = '';
        var currentRefferalStatus = '';

        if(!$A.util.isUndefinedOrNull(memberCardDetailData) && !$A.util.isEmpty(memberCardDetailData) &&
           !$A.util.isUndefinedOrNull(component.get("v.policySelectedIndex")) && !$A.util.isEmpty(component.get("v.policySelectedIndex")) )
        {
            currentTranscationId = memberCardDetailData.CoverageLines[component.get("v.policySelectedIndex")].transactionId;
            var patientInfo =  memberCardDetailData.CoverageLines[component.get("v.policySelectedIndex")].patientInfo;
            currentRefferalStatus =  memberCardDetailData.CoverageLines[component.get("v.policySelectedIndex")].referral;
            if(!$A.util.isUndefinedOrNull(patientInfo) && !$A.util.isEmpty(patientInfo)){
                if(!$A.util.isUndefinedOrNull(patientInfo.MemberId) && !$A.util.isEmpty(patientInfo.MemberId)){
                    inpRequest.memberId = patientInfo.MemberId;
                }
               /* if(!$A.util.isUndefinedOrNull(patientInfo.fullName) && !$A.util.isEmpty(patientInfo.fullName)){
                    var namelist  = patientInfo.fullName.split(" ");
                     inpRequest.firstName = namelist[0];
                }*/

                if (!$A.util.isUndefinedOrNull(patientInfo.firstName) && !$A.util.isEmpty(patientInfo.firstName)) {
                    inpRequest.firstName = patientInfo.firstName;
                }
                if(!$A.util.isUndefinedOrNull(patientInfo.dobVal) && !$A.util.isEmpty(patientInfo.dobVal)){
                     var memberDOBValArray  = patientInfo.dobVal.split("/");
                	inpRequest.dateOfBirth = memberDOBValArray[2] + '-' + memberDOBValArray[0] + '-' + memberDOBValArray[1];
                }
            }
        }
        console.log(JSON.parse(JSON.stringify(inpRequest)));

        if(!$A.util.isUndefinedOrNull(memberPolicies) && !$A.util.isEmpty(memberPolicies) &&
           !$A.util.isUndefinedOrNull(component.get("v.policySelectedIndex")) && !$A.util.isEmpty(component.get("v.policySelectedIndex"))){
            var relatdPolicy= memberPolicies[component.get("v.policySelectedIndex")];
            // Added to Store Newly created Referral Number 
            var policyNewReferralMap = component.get("v.policyWithNewReferralMap");
            if(!$A.util.isUndefinedOrNull(policyNewReferralMap[component.get("v.policySelectedIndex")]) && 
               !$A.util.isEmpty(policyNewReferralMap[component.get("v.policySelectedIndex")])){
                 inpRequest.newReferralNumber = policyNewReferralMap[component.get("v.policySelectedIndex")];
                component.set("v.newReferralNumber", policyNewReferralMap[component.get("v.policySelectedIndex")]);
            }
            else if(!$A.util.isUndefinedOrNull(component.get("v.newReferralNumber")) && !$A.util.isEmpty(component.get("v.newReferralNumber"))){
                policyNewReferralMap[component.get("v.policySelectedIndex")] = component.get("v.newReferralNumber");
                component.set("v.policyWithNewReferralMap",policyNewReferralMap);
            }
            //End
            currentTranscationId = memberCardDetailData.CoverageLines[component.get("v.policySelectedIndex")].transactionId;
            if(!$A.util.isUndefinedOrNull(relatdPolicy.GroupNumber) ){
                inpRequest.policyNumber = relatdPolicy.GroupNumber;
            }
            if(!$A.util.isUndefinedOrNull(relatdPolicy) && !$A.util.isUndefinedOrNull(relatdPolicy.eligibleDates)){
                var datesArray  = relatdPolicy.eligibleDates.split("-");
                var startDate = datesArray[0].trim().split('/');
                var endDate = datesArray[1].trim().split('/');
                inpRequest.firstDateOfService = startDate[2] + '-' + startDate[0] + '-' + startDate[1];
                inpRequest.lastDateOfService = endDate[2] + '-' + endDate[0] + '-' + endDate[1];
            }

        }

        var memberData = component.get("v.memberCardSnap");
        var memberDOBVar = component.get("v.memberDOB");
        if (!$A.util.isUndefinedOrNull(memberData) && !$A.util.isEmpty(memberData)) {
            //PayerId
            if(!$A.util.isUndefinedOrNull(memberData.policyandPayerMap) && !$A.util.isEmpty(memberData.policyandPayerMap) &&
               !$A.util.isUndefinedOrNull(memberData.searchQueryPayerId) && !$A.util.isEmpty(memberData.searchQueryPayerId)){
                helper.getPayerId(component,memberData.policyandPayerMap,component.get("v.isDependent"),memberData.searchQueryPayerId,currentTranscationId);
            }else if(!$A.util.isUndefinedOrNull(memberData.searchQueryPayerId) && !$A.util.isEmpty(memberData.searchQueryPayerId)){
                component.set("v.currentPayerId",memberData.searchQueryPayerId);
            }else{
                component.set("v.currentPayerId","87726");
            }

            if($A.util.isEmpty(inpRequest.firstName) && !$A.util.isUndefinedOrNull(memberData.firstName)  && !$A.util.isEmpty(memberData.firstName) ){
                inpRequest.firstName = memberData.firstName;
            }
            else if($A.util.isEmpty(inpRequest.firstName) && !$A.util.isUndefinedOrNull(component.get("v.memberFN")) && !$A.util.isEmpty(component.get("v.memberFN"))  ) {
                inpRequest.firstName = component.get("v.memberFN");
            }
            if($A.util.isEmpty(inpRequest.dateOfBirth) && !$A.util.isUndefinedOrNull(memberData.memberDOB)  && !$A.util.isEmpty(memberData.memberDOB) ){
                var memberDOBArray  = memberData.memberDOB.split("/");
                inpRequest.dateOfBirth = memberDOBArray[2] + '-' + memberDOBArray[0] + '-' + memberDOBArray[1];
            }
            else if($A.util.isEmpty(inpRequest.dateOfBirth) && !$A.util.isUndefinedOrNull(memberDOBVar) && !$A.util.isEmpty(memberDOBVar) ){
                var memberDOBArray  = memberDOBVar.split("/");
                inpRequest.dateOfBirth = memberDOBArray[2] + '-' + memberDOBArray[0] + '-' + memberDOBArray[1];
            }
            if($A.util.isEmpty(inpRequest.memberId) && !$A.util.isUndefinedOrNull(memberData.memberId) && !$A.util.isEmpty(memberData.memberId) ){
                inpRequest.memberId = memberData.memberId;
            }
            else if ($A.util.isEmpty(inpRequest.memberId) && !$A.util.isUndefinedOrNull(component.get("v.houseHoldMemberId")) && !$A.util.isEmpty(component.get("v.houseHoldMemberId")) ) {
                inpRequest.memberId = component.get("v.houseHoldMemberId");
            }
        }


        if(!$A.util.isUndefinedOrNull(component.get("v.currentPayerId")) && !$A.util.isEmpty(component.get("v.currentPayerId"))){
            inpRequest.payerId = component.get("v.currentPayerId");
        }

		if(component.get("v.isClaim")){
        	component.set("v.isOnlyActive", true);     
        }											
        if(!component.get("v.isOnlyActive")){
            inpRequest.alloff = "0";
            var today = new Date();
            var dd = String(today.getDate()).padStart(2, '0');
            var mm = String(today.getMonth() + 1).padStart(2, '0');
            var yyyy = today.getFullYear();
            today = mm + '/' + dd + '/' + yyyy;
            var todayToFormat = yyyy + '-' + mm + '-' + dd;
            const getDaysInMonth = (year, month) => new Date(year, month, 0).getDate()

            const addMonths = (input, months) => {
                const date = new Date(input)
                date.setDate(1)
                date.setMonth(date.getMonth() + months)
                date.setDate(Math.min(input.getDate(), getDaysInMonth(date.getFullYear(), date.getMonth()+1)))
                return date
            }

            startDate = addMonths(new Date(today), -6);

            let dt = new Date(startDate),
                month = '' + (dt.getMonth() + 1),
                day = '' + dt.getDate(),
                year = dt.getFullYear();

            if (month.length < 2)
                month = '0' + month;
            if (day.length < 2)
                day = '0' + day;
            startDate = year + '-' + month + '-' + day;
             inpRequest.firstDateOfService = startDate;
             inpRequest.lastDateOfService = todayToFormat;
            //component.set("v.offCalloutDone",true);
            //chandra start
            // If startdate and end date are sent, replace them
            var claimStartDate = component.get("v.serviceFromDate");
            var claimEndDate   = component.get("v.serviceToDate");

            if (!$A.util.isUndefinedOrNull(claimStartDate) && !$A.util.isUndefinedOrNull(claimEndDate))
            {

             inpRequest.firstDateOfService = claimStartDate;
             inpRequest.lastDateOfService = claimEndDate;

            }
            //chandra End
        }
        else{
            inpRequest.alloff = "1";
           // component.set("v.onCalloutDone",true);
        }
		
        if(!$A.util.isUndefinedOrNull(component.get("v.newReferralNumber")) && !$A.util.isEmpty(component.get("v.newReferralNumber"))){
            inpRequest.newReferralNumber = component.get("v.newReferralNumber");
        }
        
        console.log(JSON.parse(JSON.stringify(inpRequest)));
        component.set("v.inpRequest",inpRequest);
        if(component.get("v.isClaim")){
         this.getPolicyReferrals(component,event,helper);
        }
        var selectedPolicy = component.get("v.policy");
        if(!$A.util.isUndefinedOrNull(selectedPolicy) &&  !$A.util.isUndefinedOrNull(selectedPolicy.resultWrapper) &&
           !$A.util.isUndefinedOrNull(selectedPolicy.resultWrapper.policyRes) && !$A.util.isUndefinedOrNull(selectedPolicy.resultWrapper.policyRes)){
            if(!$A.util.isEmpty(currentRefferalStatus) && currentRefferalStatus == 'Yes' &&  !$A.util.isUndefinedOrNull(selectedPolicy.resultWrapper.policyRes.sourceCode) &&
              (selectedPolicy.resultWrapper.policyRes.sourceCode == 'CO' || selectedPolicy.resultWrapper.policyRes.sourceCode == 'CS' || selectedPolicy.resultWrapper.policyRes.sourceCode == 'AP')){
                component.set("v.showCreateNewCaseButton",true);
                component.set("v.selectedSourceCode",selectedPolicy.resultWrapper.policyRes.sourceCode);
            }
            if($A.util.isEmpty(inpRequest.policyNumber) &&  !$A.util.isUndefinedOrNull(selectedPolicy.resultWrapper.policyRes.groupNumber) ){
                var policynumber = selectedPolicy.resultWrapper.policyRes.groupNumber;
                inpRequest.policyNumber = policynumber;
            }
            if( !$A.util.isUndefinedOrNull(selectedPolicy.resultWrapper.policyRes.sourceCode) && selectedPolicy.resultWrapper.policyRes.sourceCode != 'PA' ){
                if(!$A.util.isEmpty(inpRequest.memberId) &&
                   !$A.util.isEmpty(inpRequest.firstName) && !$A.util.isEmpty(inpRequest.dateOfBirth) && !$A.util.isEmpty(inpRequest.firstDateOfService)
                    && !$A.util.isEmpty(inpRequest.lastDateOfService) && !$A.util.isEmpty(inpRequest.payerId)) {
                    this.getPolicyReferrals(component,event,helper);
                    if(!component.get("v.isOnlyActive")){
                         component.set("v.offCalloutDone",true);
                    }
                    else{
                        component.set("v.onCalloutDone",true);
                    }

                }
                else{
                    helper.showToastMessage("Error!","Refferal - Required fields are missing", "error", "dismissible", "10000");
                    component.set("v.lstofViewPCPReferrals", null);
                    helper.createTableData(component);
                    helper.hidePolicySpinner(component);
            }
    }
            else{
                component.set("v.lstofViewPCPReferrals", null);
                helper.createTableData(component);
                helper.hidePolicySpinner(component);
            }

        }

    },
    getPayerId: function(component,policymap,isDependent,searchQueryPayerId,currentTranscationId){
        var isActiveFound =false;
        var strDependentActiveValue='';
        if(currentTranscationId != '' && policymap != null && !$A.util.isEmpty(policymap) ){
            for(var key in policymap){
                var currentPayerIdValue = policymap[key].split(';;');
                if(key == currentTranscationId){
                    isActiveFound = true;
                    component.set("v.currentPayerId",currentPayerIdValue[0]);
                }
                if(currentPayerIdValue[1] == 'T'){
                    strDependentActiveValue = currentPayerIdValue[0];
                }
            }
            if(isActiveFound == false ){
                if(isDependent && strDependentActiveValue != '' ){
                    component.set("v.currentPayerId",strDependentActiveValue);
                }
                else if(searchQueryPayerId){
                    component.set("v.currentPayerId",searchQueryPayerId);
                }

            }
        }
        else if(searchQueryPayerId!= ''){
            component.set("v.currentPayerId",searchQueryPayerId);
        }
    },
    getPolicyReferrals : function(component,event,helper){

        var inpRequest = component.get("v.inpRequest");
        console.log(JSON.parse(JSON.stringify(inpRequest)));
        var action = component.get("c.getPolicyInfo");
        action.setParams({
            "inputRequest": inpRequest
        });

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state == 'SUCCESS') {
                var result = response.getReturnValue();
                if (result.isSuccess) {
                    if (result.statusCode == 200) {
                        console.log(JSON.parse(JSON.stringify(result.response)));
                        var lstofViewPCPReferrals = [];
                        lstofViewPCPReferrals.push.apply(lstofViewPCPReferrals, result.response);
                        if (!$A.util.isEmpty(lstofViewPCPReferrals)) {
                            component.set("v.lstofViewPCPReferrals", lstofViewPCPReferrals);
                            if(!component.get("v.isOnlyActive")){
                                component.set("v.offlstofViewPCPReferrals", lstofViewPCPReferrals);
                            }
                            else{
                                component.set("v.onlstofViewPCPReferrals", lstofViewPCPReferrals);
                            }
                        } else {
                            component.set("v.lstofViewPCPReferrals", null);
                        }
                        this.hidePolicySpinner(component);
                    }
                    else{
                        component.set("v.lstofViewPCPReferrals", null);
                        this.showToastMessage("We hit a snag.", this.pcpReferralsErrorMessage, "error", "dismissible", "30000");// US3305963 - Thanish - 18th Mar 2021
                        this.hidePolicySpinner(component);
                    }
                }
                else{
                    component.set("v.lstofViewPCPReferrals", null);
                    this.showToastMessage("We hit a snag.", this.pcpReferralsErrorMessage, "error", "dismissible", "30000");// US3305963 - Thanish - 18th Mar 2021
                    this.hidePolicySpinner(component);
                }
            }
            else if (state == 'ERROR') {
                component.set("v.lstofViewPCPReferrals", null);
                this.showToastMessage("We hit a snag.", this.pcpReferralsErrorMessage, "error", "dismissible", "30000");// US3305963 - Thanish - 18th Mar 2021
                this.hidePolicySpinner(component);
            }

            helper.createTableData(component);
        });
        $A.enqueueAction(action);

    },

    showPolicySpinner: function (component) {
         component.set("v.isSpinnerShow",true);
    },
    hidePolicySpinner: function (component) {
        component.set("v.isSpinnerShow",false);
    },
    showToastMessage: function (title, message, type, mode, duration) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type": type,
            "mode": mode,
            "duration": duration
        });
        toastEvent.fire();
    },

    // New AutoDoc
    createTableData: function (cmp) {
        var referralsTable = new Object();
        var currentIndexOfOpenedTabs = cmp.get("v.currentIndexOfOpenedTabs");
        var maxAutoDocComponents = cmp.get("v.maxAutoDocComponents");
        var claimNo=cmp.get("v.claimNo");
        referralsTable.type = 'table';
        if(cmp.get("v.isClaim")){
        referralsTable.componentOrder =19 + (maxAutoDocComponents*currentIndexOfOpenedTabs);
        referralsTable.componentName = 'Referral Results: '+claimNo;
        referralsTable.autodocHeaderName = 'Referral Results: '+claimNo;
            // US3653575
            referralsTable.reportingHeader = 'Referral Results';
        } else {
        referralsTable.componentOrder = 3;
        referralsTable.componentName = 'Referral Results';
        referralsTable.autodocHeaderName = 'Referral Results';
            // US3653575
            referralsTable.reportingHeader = 'Referral Results';
        }
        referralsTable.tableHeaders = ['REFERRAL #',
            'SERVICE DATES', 'DX CODES', 'REFERRED BY PROVIDER', 'REFERRED TO PROVIDER', 'ALLOWED', 'REMAINING',
            'INTAKE/APPROVAL DATE', 'LAST UPDATED'
        ];
        referralsTable.caseItemsEnabled = true;
        referralsTable.hideResolveColumn = true;
        var selectedRows = [];
        referralsTable.selectedRows = selectedRows;
        var tableRows = [];
        var referralsData = cmp.get("v.lstofViewPCPReferrals");
        //US2573718 - Auto Doc When No Results Are Displayed - Sravan
        console.log('Sravan #'+ JSON.stringify(cmp.get("v.autodocUniqueId")));
        console.log('Sravan #'+ JSON.stringify(cmp.get("v.policySelectedIndex")));
         var autodocSubId;
         if(cmp.get("v.isClaim")){
              autodocSubId = cmp.get("v.autodocUniqueIdCmp");
         }
        else{
          autodocSubId = cmp.get("v.autodocUniqueId") + cmp.get("v.policySelectedIndex");
        }
        var extPcpTable = _autodoc.getAutodocComponent(cmp.get("v.autodocUniqueId"),autodocSubId,'Referral Results');
        console.log('Old Pcp Data'+ JSON.stringify(extPcpTable));
        if(!$A.util.isEmpty(extPcpTable)){
         var selectedR = extPcpTable.selectedRows;
            referralsTable.selectedRows = selectedR;
            cmp.set("v.selectedRows",selectedR);
        }else{
            cmp.set("v.selectedRows",[]);
        }
        var autoCheck = false;
        var newrefferalNumber = cmp.get("v.newReferralNumber");
        var selectedRows = cmp.get("v.selectedRows");
        if(!$A.util.isUndefinedOrNull(referralsData) && !$A.util.isEmpty(referralsData)){
                    referralsData.forEach(pcpref => {
            var tableRow = new Object();
            tableRow.checked = false;
            tableRow.resolved = false;
            tableRow.uniqueKey = pcpref.referralId;//auth.AuthId;
            //tableRow.authStatusId = 'authstatus' + auth.SRN + auth.AuthId;
                // US3653575
                tableRow.caseItemsExtId = cmp.get("v.isClaim") ? claimNo : pcpref.referralId;
            var rowColumnData = [];
            rowColumnData.push(setRowColumnData('outputText', !$A.util.isEmpty(pcpref.referralId) ? pcpref.referralId : '--' ));
            rowColumnData.push(setRowColumnData('outputText', !$A.util.isEmpty(pcpref.serviceDates) ? pcpref.serviceDates : '--' ));
            rowColumnData.push(setRowColumnData('outputText', !$A.util.isEmpty(pcpref.dxCodes) ? pcpref.dxCodes : '--' ));

            // US2917434, US3208169
            var refByProvdier = setRowColumnData('link', !$A.util.isEmpty( pcpref.referByProvider) ?  pcpref.referByProvider : '--' );
            refByProvdier.cellData = pcpref.searchParamsByProvider;
            rowColumnData.push(refByProvdier);
            var refToProvdier = setRowColumnData('link', !$A.util.isEmpty(pcpref.referredToProvider) ? pcpref.referredToProvider : '--' );
            refToProvdier.cellData = pcpref.searchParamsToProvider;
            rowColumnData.push(refToProvdier);
            // End

            //rowColumnData.push(setRowColumnData('outputText', !$A.util.isEmpty( pcpref.referByProvider) ?  pcpref.referByProvider : '--' ));
            //rowColumnData.push(setRowColumnData('outputText', !$A.util.isEmpty(pcpref.referredToProvider) ? pcpref.referredToProvider : '--' ));
            rowColumnData.push(setRowColumnData('outputText', !$A.util.isEmpty(pcpref.allowed) ? pcpref.allowed : '--' ));
            rowColumnData.push(setRowColumnData('outputText', !$A.util.isEmpty(pcpref.remaining) ? pcpref.remaining : '--' ));
            rowColumnData.push(setRowColumnData('outputText', !$A.util.isEmpty(pcpref.intakeORApporvalDate) ? pcpref.intakeORApporvalDate : '--' ));
            rowColumnData.push(setRowColumnData('outputText', !$A.util.isEmpty(pcpref.LastUpdated) ? pcpref.LastUpdated : '--' ));
            if(pcpref.referralId == newrefferalNumber){
                        
                        var selectedAuthIndex = selectedRows.findIndex(function(row){
                        return newrefferalNumber == row.rowColumnData[0].fieldValue;
                    })
					 
                    if(selectedAuthIndex < 0){
                        tableRow.checked = true;
                        tableRow.resolved = true;
                        selectedRows.push(tableRow);
                    }
                        //tableRow.checked = true;
                        //tableRow.resolved = true;
                        //selectedRows.push(tableRow);
             }            
            tableRow.rowColumnData = rowColumnData;

            // Additional Details
            /*
            var additionalDetails = new Object();
            additionalDetails.authId = auth.AuthId;
            additionalDetails.authType = auth.Type;
            additionalDetails.srn = auth.SRN;
            additionalDetails.lofstay = auth.LengthOfStay;
            additionalDetails.authStatusId = 'authstatus' + auth.SRN + auth.AuthId;
            tableRow.additionalData = additionalDetails;*/

            tableRows.push(tableRow);
        });

        referralsTable.tableBody = tableRows;
         
        referralsTable.selectedRows = selectedRows;
        autoCheck = false;//Added as part  of US2573718 - Sravan
        }
        else{
            var tableRow = new Object();
            tableRow.checked = false;
            tableRow.resolved = false;
            tableRow.uniqueKey = '';//auth.AuthId;
            //tableRow.authStatusId = 'authstatus' + auth.SRN + auth.AuthId;
            var message = '';
                if(cmp.get("v.isOnlyActive")){
                    message = 'No Referral Results Found';
                } else{
                    message = 'No Referral Results in the Last 6 Months';
                }
            tableRow.caseItemsExtId = '';
            var rowColumnData = [];
            rowColumnData.push(setRowColumnData('outputText', ''));
            rowColumnData.push(setRowColumnData('outputText', ''));
            rowColumnData.push(setRowColumnData('outputText',''));
            rowColumnData.push(setRowColumnData('outputText', ''));
            rowColumnData.push(setRowColumnData('outputText', message));//Changed as part  of US2573718 - Sravan
            rowColumnData.push(setRowColumnData('outputText',''));
            rowColumnData.push(setRowColumnData('outputText', ''));
            rowColumnData.push(setRowColumnData('outputText',''));
            rowColumnData.push(setRowColumnData('outputText',''));
            tableRow.rowColumnData = rowColumnData;
            tableRow.caseItemsExtId = cmp.get("v.isClaim") ? claimNo : message; // US3125332 - Thanish - 7th Jan 2021
            tableRows.push(tableRow);
            referralsTable.tableBody = tableRows;
            autoCheck = true;//Added as part  of US2573718 - Sravan
        }
		
		console.log('==referraldta'+JSON.stringify(referralsTable));
        cmp.set("v.referralsTableData", referralsTable);
        // DE482674 - Thanish - 1st Sep 2021 this.setDefaultAutodoc(cmp,referralsTable);

        function setRowColumnData(ft, fv) {
            var rowColumnData = new Object();
            rowColumnData.fieldType = ft;
            rowColumnData.fieldValue = fv;
            rowColumnData.isReportable = true;
            if ('link' == ft) {
                rowColumnData.isLink = true;
            } else if ('outputText' == ft) {
                rowColumnData.isOutputText = true;
            } else if ('isStatusIcon' == ft) {
                rowColumnData.isIcon = true;
            } else {
                rowColumnData.isOutputText = true;
            }
            return rowColumnData;
        }
        //US2573718 - Auto Doc When No Results Are Displayed - Sravan
        //cmp.set("v.selectedRows",[]);
        if(autoCheck){
            cmp.set("v.autoCheck",!cmp.get("v.autoCheck"));
        }


    },

    setDefaultAutodoc: function(cmp, hideInPreview){ // DE492618 - Thanish - 23rd Sept 2021
        var defaultAutoDocPolicy = _autodoc.getAutodocComponent(cmp.get("v.memberautodocUniqueId"),cmp.get("v.policySelectedIndex"),'Policies');
        var defaultAutoDocMember = _autodoc.getAutodocComponent(cmp.get("v.memberautodocUniqueId"),cmp.get("v.policySelectedIndex"),'Member Details');
        /*
        var filteredFields = defaultAutoDocMember.cardData.filter(function(el){
            return el.defaultChecked = true;
       });
        defaultAutoDocMember.cardData = filteredFields;*/

        if(!$A.util.isEmpty(defaultAutoDocPolicy) && !$A.util.isEmpty(defaultAutoDocMember)){
            var memberAutodoc = new Object();
            memberAutodoc.type = 'card';
            memberAutodoc.componentName = "Member Details";
            memberAutodoc.autodocHeaderName = "Member Details";
            memberAutodoc.noOfColumns = "slds-size_6-of-12";
            memberAutodoc.componentOrder = 2;
            memberAutodoc.hideInPreview = hideInPreview; // DE492618 - Thanish - 23rd Sept 2021
            var cardData = [];
            cardData = defaultAutoDocMember.cardData.filter(function(el){
                if(!$A.util.isEmpty(el.defaultChecked) && el.defaultChecked) {
                    return el;
                }
            });
            memberAutodoc.cardData = cardData;
            //memberAutodoc.ignoreAutodocWarningMsg = true;
            var autodocSubId;
             if(cmp.get("v.isClaim")){
                  autodocSubId = cmp.get("v.autodocUniqueIdCmp");
             }
            else{
              autodocSubId = cmp.get("v.autodocUniqueId") + cmp.get("v.policySelectedIndex");
            }
            // DE456923 - Thanish - 30th Jun 2021
            var policyAutodoc = new Object();
            policyAutodoc.type = "table";
            policyAutodoc.autodocHeaderName = "Policies";
            policyAutodoc.componentName = "Policies";
            policyAutodoc.tableHeaders = ["GROUP #", "SOURCE", "PLAN", "TYPE", "PRODUCT", "COVERAGE LEVEL", "ELIGIBILITY DATES", "STATUS", "REF REQ", "PCP REQ", "RESOLVED"]; // // US2928520: Policies Card - updated with "TYPE"
            policyAutodoc.tableBody = defaultAutoDocPolicy.tableBody;
            policyAutodoc.selectedRows = defaultAutoDocPolicy.selectedRows;
            policyAutodoc.callTopic = 'View Member Eligibility';
            policyAutodoc.componentOrder = 0;
            policyAutodoc.hideInPreview = hideInPreview; // DE492618 - Thanish - 23rd Sept 2021
            // policyAutodoc.ignoreAutodocWarningMsg = true;
           _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"), autodocSubId, policyAutodoc);
            _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"), autodocSubId, memberAutodoc);
            // _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"), autodocSubId, referralsTable);

            // US3804847 - Krish - 26th August 2021
            var interactionCard = cmp.get("v.interactionCard");
            var providerFullName = '';
            var providerComponentName = '';
            if(!$A.util.isUndefinedOrNull(interactionCard) && !$A.util.isEmpty(interactionCard)){
                providerFullName = interactionCard.firstName + ' ' + interactionCard.lastName;
                providerComponentName = 'Provider: '+ ($A.util.isEmpty(providerFullName) ? "" : providerFullName);
            }
            var defaultAutoDocProvider = _autodoc.getAutodocComponent(cmp.get("v.memberautodocUniqueId"), cmp.get("v.policySelectedIndex"), providerComponentName);
            if(!$A.util.isUndefinedOrNull(defaultAutoDocProvider) && !$A.util.isEmpty(defaultAutoDocProvider)){
                // DE492618 - Thanish - 23rd Sept 2021
                var providerAutodoc = new Object();
                providerAutodoc.componentName = defaultAutoDocProvider.componentName;
                providerAutodoc.componentOrder = 0.25;
                providerAutodoc.noOfColumns = defaultAutoDocProvider.noOfColumns;
                providerAutodoc.type = defaultAutoDocProvider.type;
                providerAutodoc.caseItemsExtId = defaultAutoDocProvider.caseItemsExtId;
                providerAutodoc.allChecked = defaultAutoDocProvider.allChecked;
                providerAutodoc.cardData = defaultAutoDocProvider.cardData;
            	providerAutodoc.hideInPreview = hideInPreview;
                providerAutodoc.ignoreClearAutodoc = false;
                providerAutodoc.ignoreAutodocWarningMsg = true;
                _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"), autodocSubId, providerAutodoc);
            }
            this.deleteAutoDoc(cmp);
        }
    },

    // DE482674 - Thanish - 1st Sep 2021
    deleteDefaultAutodoc: function(cmp){
        var autodocSubId;
        if(cmp.get("v.isClaim")){
            autodocSubId = cmp.get("v.autodocUniqueIdCmp");
        }
        else{
            autodocSubId = cmp.get("v.autodocUniqueId") + cmp.get("v.policySelectedIndex");
        }
        _autodoc.deleteAutodocComponent(cmp.get("v.autodocUniqueId"), autodocSubId, "Policies");
        _autodoc.deleteAutodocComponent(cmp.get("v.autodocUniqueId"), autodocSubId, "Member Details");

        var interactionCard = cmp.get("v.interactionCard");
        var providerFullName = '';
        var providerComponentName = '';
        if(!$A.util.isUndefinedOrNull(interactionCard) && !$A.util.isEmpty(interactionCard)){
            providerFullName = interactionCard.firstName + ' ' + interactionCard.lastName;
            providerComponentName = 'Provider: '+ ($A.util.isEmpty(providerFullName) ? "" : providerFullName);
        }
        _autodoc.deleteAutodocComponent(cmp.get("v.autodocUniqueId"), autodocSubId, providerComponentName);
    },

    getAutoDocObject: function (cmp) {

        //var defaultAutoDoc = _autodoc.getAutodoc(cmp.get("v.memberautodocUniqueId"));
        var selectedString = _autodoc.getAutodoc(cmp.get("v.autodocUniqueId"));
        /*for(var i=0; i < selectedString.length; i++) {
            defaultAutoDoc.push(selectedString[i]);
        }*/

        return selectedString;

    },
    //US3068299 - Sravan - Start
    deleteAutoDoc : function(component){
        var autoDocToBeDeleted = component.get("v.autoDocToBeDeleted");
        console.log('autoDocToBeDeleted'+ JSON.stringify(component.get("v.autoDocToBeDeleted")));
        console.log('cmp.get("v.autodocUniqueId")'+ component.get("v.autodocUniqueId"));
        if(!$A.util.isUndefinedOrNull(autoDocToBeDeleted) && !$A.util.isEmpty(autoDocToBeDeleted)){
             if(autoDocToBeDeleted.doNotRetainAutodDoc){
                 _autodoc.deleteAutodoc(component.get("v.autodocUniqueId"),component.get("v.autodocUniqueId")+autoDocToBeDeleted.selectedPolicyKey);
             }
    }
    },
    //US3068299 - Sravan - End
    openProvDetails : function (cmp, event, helper, cellIndex) {
         debugger;
        
        var memberDetails = cmp.get("v.memberDetails");
        if($A.util.isEmpty(memberDetails)) {
            memberDetails = new Object();
        }
        memberDetails.noMemberToSearch = cmp.get("v.noMemberToSearch");
        var getUniqueKey = cmp.get("v.getUniqueKey");
        
        var pDetails = getUniqueKey.split(',');

        var providerDetails = new Object();
        
        providerDetails.taxId = pDetails[0];
        providerDetails.providerId = pDetails[1];
        
        providerDetails.addressId = pDetails[2];
        providerDetails.addressSequence = pDetails[3];
        providerDetails.isPhysician = pDetails[5];

        let pageFeature = cmp.get("v.autodocPageFeature");
        let autodocKey = cmp.get("v.AutodocKey");
        
        let policyDetails = cmp.get("v.policyDetails");
        let contractFilterData = {};

        let memberCardData = cmp.get('v.memberCardData');
        let policySelectedIndex = cmp.get('v.policySelectedIndex');
        var insuranceTypeCode = '';
        if(!$A.util.isEmpty(memberCardData)){
            if (!$A.util.isUndefinedOrNull(memberCardData.CoverageLines[policySelectedIndex])) {
                if (!$A.util.isUndefinedOrNull(memberCardData.CoverageLines[policySelectedIndex].insuranceTypeCode)) {
                    insuranceTypeCode = memberCardData.CoverageLines[policySelectedIndex].insuranceTypeCode;
                }
                if (!$A.util.isUndefinedOrNull(memberCardData.CoverageLines[policySelectedIndex].patientInfo)) {
                     memberDetails.memberId=  memberCardData.CoverageLines[policySelectedIndex].patientInfo.MemberId;
                }
            }
        }

        if(!$A.util.isEmpty(policyDetails)){
            contractFilterData = {
                "productType": policyDetails.resultWrapper.policyRes.productType,
                "marketSite": policyDetails.resultWrapper.policyRes.marketSite,
                "marketType": policyDetails.resultWrapper.policyRes.marketType,
                "cosmosDiv": policyDetails.resultWrapper.policyRes.cosmosDivision,
                "providerDiv" : policyDetails.resultWrapper.policyRes.providerDiv, //US3574032
                "cosmosPanelNbr": policyDetails.resultWrapper.policyRes.groupPanelNumber,
                "policyNumber": policyDetails.resultWrapper.policyRes.policyNumber,
                "subscriberID": policyDetails.resultWrapper.policyRes.subscriberID, 
                "coverageLevelNum": policyDetails.resultWrapper.policyRes.coverageLevelNum, 
                "insuranceTypeCode": insuranceTypeCode 
            }
        }


        var matchingTabs = [];
        var workspaceAPI = cmp.find("workspace");
        
        workspaceAPI.getAllTabInfo().then(function (response) {
                let tabResponse;
                if (!$A.util.isUndefinedOrNull(response) && !$A.util.isEmpty(response)) {
                    for (let i = 0; i < response.length; i++) {
                        if (!$A.util.isUndefinedOrNull(response[i].subtabs.length) && response[i].subtabs.length > 0) {
                            for (let j = 0; j < response[i].subtabs.length; j++) {

                               if(response[i].subtabs[j].pageReference.state.c__providerID === providerDetails.providerId)
                               {

                                 tabResponse = response[i].subtabs[j];
                                 matchingTabs.push(response[i]);
                                 console.log("tabResponse: "+ tabResponse.pageReference.state.c__providerID);
                                 break;
                               }
                           }
                        }
                    }
                 }
                console.log("length: "+matchingTabs.length);
                if(!(matchingTabs.length == 0)){
                workspaceAPI.openTab({
                    url: tabResponse.url
                }).then(function (response) {
                    workspaceAPI.focusTab({
                        tabId: response
                    });
                }).catch(function (error) {
                });
            }
            else{

            workspaceAPI.openSubtab({
                pageReference: {
                    "type": "standard__component",
                    "attributes": {
                        "componentName": "c__ACET_ProviderLookupDetails"
                    },
                    "state": {
                        "c__slectedRowLinkData": null,  
                        "c__providerID": providerDetails.providerId,
                        "c__interactionRec": cmp.get("v.interactionRec"),
                        "c__memberDetails": memberDetails,
                        "c__noMemberToSearch": cmp.get("v.noMemberToSearch"),
                        "c__providerNotFound": cmp.get("v.providerNotFound"),
                        "c__providerDetails": providerDetails,
                        "c__sourceCode": cmp.get("v.sourceCode"),
                        "c__autodocPageFeature": cmp.get("v.autodocUniqueId"),
                        "c__autodocKey": autodocKey,
                        "c__currentRowIndex": cellIndex, 
                        "c__provSearchResultsUniqueId": null,
                        "c__resultsTableRowData": null,
                        "c__contactUniqueId": cmp.get("v.contactUniqueId"),
                        
                        "c__contractFilterData": contractFilterData,
                        "c__isProviderSnapshot": cmp.get("v.isProviderSnapshot"),
                        "c__hipaaEndpointUrl":cmp.get("v.hipaaEndpointUrl"),
                        "c__providerDetailsForRoutingScreen": null,
                        "c__flowDetailsForRoutingScreen": null,
                        "c__autodocUniqueId":cmp.get("v.autodocUniqueId"),
                        "c__autodocUniqueIdCmp":cmp.get("v.autodocUniqueIdCmp"),
                        "c__claimNo":cmp.get("v.claimNo"),
                        "c__currentIndexOfOpenedTabs":cmp.get("v.currentIndexOfOpenedTabs"),
                        "c__maxAutoDocComponents":cmp.get("v.maxAutoDocComponents"),
                        "c__interactionOverviewTabId": cmp.get("v.interactionOverviewTabId"), 
                        "c__isClaim" : true,
                        "c__transactionId": cmp.get("v.policyDetails.resultWrapper.policyRes.transactionId") 
                    }
                },
                focus: true
            }).then(function (subtabId) {

                workspaceAPI.setTabLabel({
                    tabId: subtabId,
                    label: pDetails[4]
                });
                workspaceAPI.setTabIcon({
                    tabId: subtabId,
                    icon: "custom:custom55",
                    iconAlt: "Provider Lookup Details"
                });
                cmp.set("v.provAlreadyOpened", true) ;
                cmp.set("v.openedSubTabId", subtabId);
            }).catch(function (error) {
                console.log(error);
            })};
        });
    },

 	getProviderData: function (component, event, helper, taxId, providerId, cellIndex) {

        debugger;
        
        var action = component.get("c.getclaimProviderLookupResults");

        action.setParams({
            taxId: taxId,
            npi: null,
            providerId: providerId,
            providerType: null,
            speciality: null,
            lastNameOrFacility: null,
            firstName: null,
            state: null,
            zipCode: null,
            radius: null,
            acceptNewPatients: null,
            prefferedLab: null,
            inactiveProvs: null,
            freestandingFac: null,
            cosmosDiv: null,
            cosmosPanelNum: null,
            tciTableNum: null,
            lineofBusiness: null,
            memType: null,
            start: 1,
            endCount: 50,
            filtered : true,
	    	benefitLevel : null,
            marketSite:null,
            entityType:null,
            sharedArrangement : null,
            obligorID : null,
            productCode : null,
            marketType : null,
            isDetailOpened : true

        });
		this.showSpinner(component);
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                if(!$A.util.isUndefinedOrNull(result.recordCount)){
                    
                    if(result.recordCount == 0){
                         helper.showToast(component,event,helper);
                         component.set("v.autoCheck",false);

                    }
                    else{
                        
                        var getUniqueKey = result.tableBody[0].rowDetails;
                        component.set("v.getUniqueKey",getUniqueKey);
                        console.log("provider search results "+ JSON.stringify(result));
                        helper.openProvDetails(component, event, helper, cellIndex);
                    }
                }
            } else {
                console.log('FAIL## ' + JSON.stringify(response.getReturnValue()));
            }
			this.hideSpinner(component);
        });
        $A.enqueueAction(action);
      },

      showToast : function(component, event, helper) {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "type": "error",
                "message": "No additional provider details found."
            });
            toastEvent.fire();
      },

      hideSpinner: function (cmp) {
        var spinner = cmp.find("lookup-spinner");
        $A.util.removeClass(spinner, "slds-show");
        $A.util.addClass(spinner, "slds-hide");
      },

      showSpinner: function (cmp) {
        var spinner = cmp.find("lookup-spinner");
        $A.util.removeClass(spinner, "slds-hide");
        $A.util.addClass(spinner, "slds-show");
      }   
})