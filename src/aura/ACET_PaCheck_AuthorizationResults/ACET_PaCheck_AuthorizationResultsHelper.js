({
    pacheckSpInsErrMsg : "Unexpected error occurred with Conditional details Please try again. If problem persists please contact the help desk.",
    //US3067258- Swapnil
    setTableData: function (component, event) {

        var memInfo = component.get('v.memberInfo');
        if( !$A.util.isUndefinedOrNull(memInfo)){
            var sCode = memInfo.sourceCode;
            component.set("v.sourceCode",sCode);
            var lstOfOptions = component.get("v.csMedNecOptions");
            if(sCode == 'CS'){
                var csOption= {'label': 'Genetic Testing', 'value': 'Genetic Testing'};
                lstOfOptions.push(csOption);
                component.set("v.csMedNecOptions",lstOfOptions);
            }

        }

        var tableDetails = new Object();
        tableDetails.type = "table";
        var pacheckData = component.get('v.PACheckData');
        pacheckData.DOSAndPOS.PlaceOfService
        // US2828663	Pre Authorization Details in Autodoc - Sarma - 16/12/2020
        var inpMap = {};
        if(pacheckData && pacheckData.ProcedureCode && pacheckData.ProcedureCode.ProcedureCodes){
            var inpList= pacheckData.ProcedureCode.ProcedureCodes;
            for(var a = 0; a < inpList.length; a++){
                if(inpList[a].procedureCode){
                    inpMap[inpList[a].procedureCode] = inpList[a];
                }
            }
        }
        component.set('v.inpMap',inpMap);
        tableDetails.showComponentName = false;
        tableDetails.componentName = 'Benefit/PA Check';
        tableDetails.autodocHeaderName = 'Authorization/Benefits Check Results';
        tableDetails.tableHeaders = ["CODE", "UHC PRIOR AUTH REQ'D", "DISCLAIMER", "DECISION SUMMARY", "CONDITIONAL DETAILS"];// "PROCEDURE CODE DESCRIPTION", "Prior Auth Required" // "OPTUMHEALTH AUTH REQ'D",
        if(component.get('v.sourceCode')  == 'CS'){
        	tableDetails.tableHeaders = ["CODE","Code Details","Coverage","Remark Code","UHC PRIOR AUTH REQ'D", "DISCLAIMER", "DECISION SUMMARY", "CONDITIONAL DETAILS"];// "PROCEDURE CODE DESCRIPTION", "Prior Auth Required" // "OPTUMHEALTH AUTH REQ'D",

        }
        // US3241842 Plan Benefits: PA Check - Save Case Subtype - Swapnil
        tableDetails.caseItemsEnabled = true;

        tableDetails.tableBody = [];
        var mapPlaceOfService = {
            '34 - Hospice': '34',
            '2 - Telehealth': '2',
            '11 - Office': '11',
            '12 - Home': '12',
            '13 - Assisted Living Facility': '13',
            '17 - Walk-in Retail Health Clinic': '17',
            '20 - Urgent Care Facility': '20',
            '21 - Inpatient Hospital': '21',
            '22 - On Campus - Outpatient Hospital': '22',
            '23 - Emergency Room Hospital': '23',
            '24 - Ambulatory Surgery Center': '24',
            '25 - Birthing Center': '25',
            '31 - Skilled Nursing Facility': '31',
            '33 - Custodial Care Facility': '33',
            '41 - Ambulance Land': '41',
            '42 - Ambulance Air Or Water': '42',
            '49 - Independent Clinic': '49',
            '52 - Psychiatric Facility': '52',
            '55 - Residual Substance Abuse Treatment': '55',
            '61 - Comprehensive Inpatient Rehabilitaty Facility': '61',
            '62 - Comprehensive Outpatient Rehabilitation Facility': '62',
            '81 - Independent Laboratory': '81',
            '99 - Other Unlisted Facility': '99'
        };
        var sosType = 'ALL';
        var sosString = '';

        var selectedKLDataMap = component.get('v.selectedKLDataMap');

        // US3290723
        var priorAuthResultList = component.get('v.priorAuthResult');

        var benifitResult = component.get('v.benefitResult');


        var codeMap = {};
        var coverMap = {};
        var codeToHoverMap = {};
        if(benifitResult){
            if(benifitResult.codeMap){
                codeMap = benifitResult.codeMap;
            }
             if(benifitResult.coverMap){
                coverMap = benifitResult.coverMap;
            }
             if(benifitResult.codeToHoverMap){
                codeToHoverMap = benifitResult.codeToHoverMap;
            }
        }
        // US3290723
        var j = 0;
        for (var x = 0; x < priorAuthResultList.length; x++) {

            var priorAuthResult = priorAuthResultList[x];

            if (!$A.util.isUndefinedOrNull(priorAuthResult.preliminaryDetermination)) {
                for (var i = 0; i < priorAuthResult.preliminaryDetermination.length; i++) {
                    ++j;
                    var conDetailsStr = '';
                    var conflg = false;
                    var sosString = '';
                    var matchFound = false;
                    for (var sos = 0; ((!$A.util.isUndefinedOrNull(priorAuthResult.preliminaryDetermination[i].siteOfService))
                        && (sos < priorAuthResult.preliminaryDetermination[i].siteOfService.length)); sos++) {
                        if ((priorAuthResult.preliminaryDetermination[i].siteOfService[sos].siteOfServiceType
                            == mapPlaceOfService[pacheckData.DOSAndPOS.PlaceOfService]))//match check
                        {
                            sosString = priorAuthResult.preliminaryDetermination[i].siteOfService[sos].decisionDescription;
                            matchFound = true;
                        }
                        else if ((priorAuthResult.preliminaryDetermination[i].siteOfService[sos].siteOfServiceType.ignoreCase == sosType.ignoreCase) && !matchFound) {
                            sosString = sosString.length <= 0 ? (priorAuthResult.preliminaryDetermination[i].siteOfService[sos].decisionDescription) :
                                sosString + '\n' + priorAuthResult.preliminaryDetermination[i].siteOfService[sos].decisionDescription;
                        } else {
                            if (!matchFound) {
                                sosString = sosString.length <= 0 ? (priorAuthResult.preliminaryDetermination[i].siteOfService[sos].decisionDescription) :
                                    sosString + '\n' + priorAuthResult.preliminaryDetermination[i].siteOfService[sos].decisionDescription;
                            }

                }
                if (!conflg) {
                    if (matchFound) {
                        conDetailsStr = '';
                        conflg = true;
                    }
                    for (var ct = 0; ((!$A.util.isUndefinedOrNull(priorAuthResult.preliminaryDetermination[i].siteOfService[sos].conditionType))
                        && (ct < priorAuthResult.preliminaryDetermination[i].siteOfService[sos].conditionType.length)); ct++) {
                        conDetailsStr = (conDetailsStr.length > 0) ? (conDetailsStr + "\n" + priorAuthResult.preliminaryDetermination[i].siteOfService[sos].conditionType[ct].conditionDetail)
                            : (priorAuthResult.preliminaryDetermination[i].siteOfService[sos].conditionType[ct].conditionDetail);
                    }

                }
            }
            var procedureCode = priorAuthResult.preliminaryDetermination[i].procedureCode;
                    var priorAuthRequired =   (sosString.length > 0) ? (sosString.substring(0, 27) != "Prior Auth is Not Required")  ? true : false : false;
                    var conditionFieldValue = '--';
                    var conTitleValue = '--';
                    var conDetailLink = false;
                    if(priorAuthRequired && component.get('v.sourceCode')  == 'CS' ){
                        conditionFieldValue = 'Click here for Special Instructions';
                        conTitleValue = 'Click here for Special Instructions';
                        conDetailLink = true;
                    }
                    else{
                        conditionFieldValue = (conDetailsStr.length > 0) ? (conDetailsStr.length >= 20) ? conDetailsStr.substring(0, 20) + '...' : conDetailsStr : '--';
                        conTitleValue = (conDetailsStr.length > 0) ? conDetailsStr : '--';
                    }
                    var codeHoverDescription = '--';
                    if(codeMap && codeMap.hasOwnProperty(procedureCode)){
                        var codeValue = codeMap[procedureCode];
                        if(codeToHoverMap && codeToHoverMap.hasOwnProperty(codeValue)){
                            var hoverInfo = codeToHoverMap[codeValue];
                            if(hoverInfo && hoverInfo.TOPS_Description__c){
                                codeHoverDescription = hoverInfo.TOPS_Description__c;
                            }
                        }
                    }
                    var codeDetailsValue = this.processCodeDetails(component, event,priorAuthResult.preliminaryDetermination[i].procedureCode);
            //var optumHealthAuthREQD = this.getOptumHealthAuthREQD(component, event);
            var row = {
                "checked": false,
                "uniqueKey": j,
                "rowColumnData": [
                    {
                        "isOutputText": true,
                        "fieldLabel": "Code",
                        "fieldValue": priorAuthResult.preliminaryDetermination[i].procedureCode,
                        "titleName": selectedKLDataMap[procedureCode],
                        "key": 1,
                        "isReportable": true,
                        "tdStyle": "overflow: hidden;"
                            },
                            {
                                "isLink": true,
                                "fieldLabel": "Code Details",
                                "fieldValue": codeDetailsValue,
                                "titleName": codeDetailsValue,
                                "key": 2,
                                "isReportable": true,
                                "tdStyle": "overflow: hidden;"
                            },
                            {
                                "isOutputText": true,
                                "fieldLabel": "Coverage",
                                "fieldValue": (coverMap && coverMap.hasOwnProperty(procedureCode) ) ? coverMap[procedureCode] : '--'  ,
                                "titleName": (coverMap && coverMap.hasOwnProperty(procedureCode)) ? coverMap[procedureCode] : '--',
                                "key": 2,
                                "isReportable": true,
                                "tdStyle": "overflow: hidden;"
                            },
                            {
                                "isOutputText": true,
                                "fieldLabel": "Remark Code",
                                "fieldValue": (codeMap && codeMap.hasOwnProperty(procedureCode)) ? codeMap[procedureCode] : '--' ,
                                "titleName": codeHoverDescription,
                                "key": 2,
                                "isReportable": true,
                                "tdStyle": "overflow: hidden;"
                    },
                    /*{
                        "isOutputText": true,
                        "fieldLabel": "Procedure Code Description",
                        "fieldValue": "--",
                        "titleName": "--",
                        "key": 2,
                        "isReportable": true,
                        "tdStyle": "overflow: hidden;"
                    },*/
                    {
                        "isOutputText": true,
                        "fieldLabel": "UHC PRIOR AUTH REQ'D",
                        "fieldValue": (sosString.length > 0) ? (sosString.length >= 20) ? sosString.substring(0, 20) + '...' : sosString : '--',
                        "titleName": (sosString.length > 0) ? sosString : '--',
                        "key": 3,
                        "isReportable": true,
                        "tdStyle": (sosString.length > 0) ? (sosString.substring(0, 22) == "Prior Auth is Required") ? "overflow: hidden;background-color: yellow" :"overflow: hidden;":"overflow: hidden;"
                    },
                    /*{
                        "isOutputText": true,
                        "fieldLabel": "OPTUMHEALTH AUTH REQ'D",
                        "fieldValue": (!$A.util.isUndefinedOrNull(optumHealthAuthREQD) && !$A.util.isEmpty(optumHealthAuthREQD)) > 0 ? optumHealthAuthREQD:"--",
                        "titleName": optumHealthAuthREQD == "Contact OptumHealth  for PT, OT, and Chiro" ? "OptumHealth Contact Info: 800-873-4575":"",
                        "key": 3,
                        "isReportable": true,
                        "tdStyle": "overflow: hidden;"
                    },*/
                    {
                        "isOutputText": true,
                        "fieldLabel": "Disclaimer",
                        "fieldValue": (priorAuthResult.disclaimerText.length > 0) ? (priorAuthResult.disclaimerText.length >= 20) ? priorAuthResult.disclaimerText.substring(0, 20) + '...' : priorAuthResult.disclaimerText : '--',
                        "titleName": (priorAuthResult.disclaimerText.length > 0) ? priorAuthResult.disclaimerText : '--',
                        "key": 4,
                        "isReportable": true,
                        "tdStyle": "overflow: hidden;"
                    },
                    {
                        "isOutputText": true,
                        "fieldLabel": "Decision Summary",
                        //"fieldValue": (!(sosString.length > 0 && (sosString.toUpperCase().includes("BLOCKED")))) ? (priorAuthResult.preliminaryDetermination[i].decisionSummaryText.length > 0) ? (priorAuthResult.preliminaryDetermination[i].decisionSummaryText.length >= 20) ? priorAuthResult.preliminaryDetermination[i].decisionSummaryText.substring(0, 20) + '...' : priorAuthResult.preliminaryDetermination[i].decisionSummaryText : '--':"Refer to the Med Nec Indicator",
                        //"titleName": (!(sosString.length > 0 && (sosString.toUpperCase().includes("BLOCKED")))) ? (priorAuthResult.preliminaryDetermination[i].decisionSummaryText.length > 0) ? priorAuthResult.preliminaryDetermination[i].decisionSummaryText : '--':"Refer to the Med Nec Indicator",
                        "fieldValue": (priorAuthResult.preliminaryDetermination[i].decisionSummaryText.length  > 0) ? (priorAuthResult.preliminaryDetermination[i].decisionSummaryText.length  >= 20) ? priorAuthResult.preliminaryDetermination[i].decisionSummaryText.substring(0, 20) + '...' : priorAuthResult.preliminaryDetermination[i].decisionSummaryText  : '--',
                        "titleName": (priorAuthResult.preliminaryDetermination[i].decisionSummaryText.length > 0) ? priorAuthResult.preliminaryDetermination[i].decisionSummaryText : '--',
                        "key": 5,
                        "isReportable": true,
                        "tdStyle": "overflow: hidden;white-space: pre-line;"
                    },
                    {
                        "isLink" : conDetailLink,
                        "isOutputText": !conDetailLink,
                        "fieldLabel": "Conditional Details",
                        "fieldValue": conditionFieldValue,
                        "titleName": conTitleValue,
                        "key": 6,
                        "isReportable": true,
                        "tdStyle": "overflow: hidden;white-space: pre-line;"
                    }
                ]
            };
            // US3241842 Swapnil
            row.caseItemsExtId= 'PA Check'; // US3742854
            row.uniqueKey=procedureCode;
                    if(component.get('v.sourceCode')  == 'CS'){
                        tableDetails.tableBody.push(row);
                    }
                    else{
                        var ColToRemove = component.get('v.CSSpecificFields');
                        var colToRemoveMap = {};
                        for (var colIndex in ColToRemove) {
                            colToRemoveMap[ColToRemove[colIndex]] = ColToRemove[colIndex];
                        }
                        var rowdataList = row.rowColumnData;
                        var newrowData = [];
                        for(var b = 0; b < rowdataList.length; b++){
                            if(!colToRemoveMap.hasOwnProperty(rowdataList[b].fieldLabel)){
                                newrowData.push(rowdataList[b]);
                            }
                        }
                        row.rowColumnData = newrowData;
            tableDetails.tableBody.push(row);
        }


                }
		}
		}
        //US3356000 - Sravan - Start
        var autoCheck = component.get("v.autoCheck");
            if(autoCheck){
                component.set("v.autoCheck",false);
            }
             else{
                component.set("v.autoCheck",true);
             }
         //US3356000 - Sravan - End
        component.set("v.tableDetails", tableDetails);
        _autodoc.setAutodoc(component.get("v.autodocUniqueId"), component.get("v.autodocUniqueIdCmp"), tableDetails);

    },

    getSpInData: function(cmp,event,helper,selectedRowData){

        var spinner = cmp.find('pacheckAuthorizationReslt');
        $A.util.removeClass(spinner, 'slds-hide');
        $A.util.addClass(spinner, 'slds-show');

        var cardDetails = new Object();
        cardDetails.componentName = "Special Instructions";
        cardDetails.componentOrder = 0;
        cardDetails.noOfColumns = "slds-size_1-of-1";
        cardDetails.type = "card";
        cardDetails.allChecked = false;
        cardDetails.cardData = [
            {
                "checked": true,
                "disableCheckbox": true,
                "fieldName": "Special Instructions",
                "fieldType": "outputText",
                "fieldValue": "Accessed"
            }
        ];
        _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"), 0, cardDetails);

        var spInpReq = {
            "diagnosisCode": "",
            "procedureCode": "",
            "dateOfService":"",
            "marketType": "",
            "productCode": "",
            "productGroup": "UHC Commercial",
            "provState": "",
            "siteOfService": ""
        };

        var spInsSiteofService = {
            '2 - Telehealth': '99-OTHER LISTED FACILITY',
            '11 - Office': '11-OFFICE',
            '12 - Home': '12-HOME',
            '13 - Assisted Living Facility': '99-OTHER LISTED FACILITY',
            '17 - Walk-in Retail Health Clinic': '99-OTHER LISTED FACILITY',
            '20 - Urgent Care Facility': '20-URGENT CARE FACILITY',
            '21 - Inpatient Hospital': '21-INPATIENT HOSPITAL',
            '22 - On Campus - Outpatient Hospital': '22-ON CAMPUS-OUTPATIENT HOSPITAL',
            '23 - Emergency Room Hospital': '99-OTHER LISTED FACILITY',
            '24 - Ambulatory Surgery Center': '24-AMBULATORY SURGICAL CENTER',
            '25 - Birthing Center': '99-OTHER LISTED FACILITY',
            '31 - Skilled Nursing Facility': '31-SKILLED NURSING FACILITY',
            '33 - Custodial Care Facility': '99-OTHER LISTED FACILITY',
            '34 - Hospice': '99-OTHER LISTED FACILITY',
            '41 - Ambulance Land': '99-OTHER LISTED FACILITY',
            '42 - Ambulance Air Or Water': '99-OTHER LISTED FACILITY',
            '49 - Independent Clinic': '99-OTHER LISTED FACILITY',
            '52 - Psychiatric Facility': '99-OTHER LISTED FACILITY',
            '55 - Residual Substance Abuse Treatment': '99-OTHER LISTED FACILITY',
            '61 - Comprehensive Inpatient Rehabilitaty Facility': '61-COMPREHENSIVE INPATIENT REHAB FACILITY',
            '62 - Comprehensive Outpatient Rehabilitation Facility': '99-OTHER LISTED FACILITY',
            '81 - Independent Laboratory': '99-OTHER LISTED FACILITY',
            '99 - Other Unlisted Facility': '99-OTHER LISTED FACILITY'
        };
        spInpReq.siteOfService = '99-OTHER LISTED FACILITY';
        var pacheckData = cmp.get('v.PACheckData');
        if(pacheckData && pacheckData.DOSAndPOS){
            if(pacheckData && pacheckData.DOSAndPOS.DateOfService){
                spInpReq.dateOfService = pacheckData.DOSAndPOS.DateOfService;
            }
            if(pacheckData && pacheckData.DOSAndPOS.PlaceOfService){
                if(spInsSiteofService.hasOwnProperty(pacheckData.DOSAndPOS.PlaceOfService)){
                	spInpReq.siteOfService = spInsSiteofService[pacheckData.DOSAndPOS.PlaceOfService];
            	}
            }
        }

        if(selectedRowData && selectedRowData.rowColumnData){
            var inpList = selectedRowData.rowColumnData;
            for(var a = 0; a < inpList.length; a++){
                if(inpList[a].fieldLabel && inpList[a].fieldLabel == 'Code'){
                    spInpReq.procedureCode = inpList[a].fieldValue;
                    var inputCodeMap = cmp.get('v.inpMap');
                    if(inputCodeMap && inputCodeMap.hasOwnProperty(inpList[a].fieldValue)){
                        var inputValue = inputCodeMap[inpList[a].fieldValue];
                        if(inputValue && inputValue.diagnosisCode){
                            spInpReq.diagnosisCode = inputValue.diagnosisCode;
                        }
                    }
                }
            }
        }

        var interactionOverviewTabId = cmp.get("v.interactionOverviewTabId");
        var interactionOverviewData = _setAndGetSessionValues.getInteractionDetails(interactionOverviewTabId);
        var providerDetails = interactionOverviewData.providerDetails;

        if(providerDetails && providerDetails.state){
            spInpReq.provState = providerDetails.state;
        }

        var currentid = cmp.get('v.currenttabId');
        var extended = _setAndGetSessionValues.gettingValue("Policy:" + currentid + ":" + currentid);
        var memberData = _setAndGetSessionValues.gettingValue("Member:" + currentid + ":" + currentid);


        if (!$A.util.isUndefinedOrNull(extended) && !$A.util.isUndefinedOrNull(extended.policyResultWrapper) &&
            !$A.util.isUndefinedOrNull(extended.policyResultWrapper.resultWrapper) &&
            !$A.util.isUndefinedOrNull(extended.policyResultWrapper.resultWrapper.policyRes)) {
            if(!$A.util.isUndefinedOrNull(extended.policyResultWrapper.resultWrapper.policyRes.marketType)){
                spInpReq.marketType = extended.policyResultWrapper.resultWrapper.policyRes.marketType;
            }
            if(!$A.util.isUndefinedOrNull(extended.policyResultWrapper.resultWrapper.policyRes.productType)){
                spInpReq.productCode = extended.policyResultWrapper.resultWrapper.policyRes.productType;
            }
        }
        console.log('=@spInpReq'+JSON.stringify(spInpReq));

        var action = cmp.get('c.getSPInsString');

        action.setParams({
            "inpReq": spInpReq
        });

        action.setCallback(this,function(response){
            var state = response.getState();
            console.log('State'+ state);
            if(state == 'SUCCESS'){
                var result = response.getReturnValue();
                console.log('==result'+JSON.stringify(result));
                if(result.isSuccess ){
                    if (result.statusCode == 200) {

                        if(result && result.response && result.response.result && result.response.result[0] && result.response.result[0].specialInstructions &&
                           result.response.result[0].specialInstructions[0] && result.response.result[0].specialInstructions[0].data ){
                            cmp.set('v.openSpInsPopUP',true);
                            cmp.set('v.spInstructionString',result.response.result[0].specialInstructions[0].data);
                        }
                        else{
                            this.showToastMessage("We hit a snag.", this.pacheckSpInsErrMsg, "error", "dismissible", "30000");
                        }
                    }
                    else{
                        this.showToastMessage("We hit a snag.", this.pacheckSpInsErrMsg, "error", "dismissible", "30000");
                    }
                }
                else{
                    this.showToastMessage("We hit a snag.", this.pacheckSpInsErrMsg, "error", "dismissible", "30000");
                }
            }
            else if (state == 'ERROR') {
                this.showToastMessage("We hit a snag.", this.pacheckSpInsErrMsg, "error", "dismissible", "30000");
            }
            $A.util.removeClass(spinner, 'slds-show');
            $A.util.addClass(spinner, 'slds-hide');
        })
        $A.enqueueAction(action);

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

    //US2828663	Pre Authorization Details in Autodoc
    updateQuestionAuodoc: function (component, event) {

        var autodocCmp = _autodoc.getAutodocComponent(component.get("v.autodocUniqueId"), component.get("v.autodocUniqueIdCmp"), 'Benefit/PA Check');
		var sCode = component.get("v.sourceCode");
        if (!$A.util.isUndefinedOrNull(autodocCmp)) {

            var questionList = [];
            if(sCode == 'AP'){
            //questionList.push(new fieldDetails(true, 'slds-size_2-of-2', 'Did the Prior Auth Required field come back as Yes or Maybe?', component.get('v.priorAuthRadioButton')));
            questionList.push(new fieldDetails(true, 'slds-size_2-of-2', 'Did the UHC Prior Auth Required field come back as Blocked?', component.get('v.uhcComeAsBlocked')));

            if (component.get('v.uhcComeAsBlocked') == 'Yes' ){
                questionList.push(new fieldDetails(true, 'slds-size_2-of-2', 'Review the Decision Summary field  and transfer the call appropriately (i.e. Evicore, OptumHealth, Beacon)', ''));
            }
            if (component.get('v.uhcComeAsBlocked') == 'No' ){
            questionList.push(new fieldDetails(true, 'slds-size_2-of-2', 'Did the Prior Auth Required field come back as Yes or Maybe?', component.get('v.priorAuthRadioButton')));
            }
            if (component.get("v.priorAuthRadioButton") == 'Yes') {
                questionList.push(new fieldDetails(true, 'slds-size_2-of-2', 'Is this a Delegated Plan?', component.get('v.delegatedPlanRadioButton')));
            }
            if (component.get("v.priorAuthRadioButton") == 'No') {
                questionList.push(new fieldDetails(true, 'slds-size_2-of-2', 'Authorization is not required.', ''));
            }
            if (component.get("v.delegatedPlanRadioButton") == 'Yes') {
                questionList.push(new fieldDetails(true, 'slds-size_2-of-2', 'Is Authorizations handled by UHC?', component.get('v.handledByUHCRadioButton')));
            }
            if (component.get("v.delegatedPlanRadioButton") == 'No' || component.get("v.handledByUHCRadioButton") == 'Yes') {
                questionList.push(new fieldDetails(true, 'slds-size_2-of-2', 'Is UHC Primary?', component.get('v.uhcPrimaryRadioButton')));
            }
            if (component.get("v.handledByUHCRadioButton") == 'No') {
                questionList.push(new fieldDetails(true, 'slds-size_2-of-2', 'Authorization is handled by Delegation, follow your standard processes for transferring the call.', ''));
            }
            if (component.get("v.uhcPrimaryRadioButton") == 'Yes') {
                questionList.push(new fieldDetails(true, 'slds-size_2-of-2', 'Is this a member notification requirement?', component.get('v.memberNotifRadioButton')));
            }
            if (component.get("v.uhcPrimaryRadioButton") == 'No') {
                questionList.push(new fieldDetails(true, 'slds-size_2-of-2', 'Authorization is not required due to this policy being secondary to UHC. If  the provider insist on having an authorization created, please follow your process for Auth creation.', ''));
            }
            if (component.get("v.memberNotifRadioButton") == 'Yes') {
                questionList.push(new fieldDetails(true, 'slds-size_2-of-2', 'Advise the provider of the member notification requirements.', ''));
            }
            //US3244407
            if (component.get("v.memberNotifRadioButton") == 'No') {
                questionList.push(new fieldDetails(true, 'slds-size_2-of-2', 'Authorization is required, please follow your process for Auth creation.', ''));
            }
            /*if (component.get("v.testingRadioButton") == 'Yes') {
                questionList.push(new fieldDetails(true, 'slds-size_2-of-2', 'Follow your standard process of transferring the call to the appropriate area.', ''));
            }
            if (component.get("v.testingRadioButton") == 'No') {
                questionList.push(new fieldDetails(true, 'slds-size_2-of-2', 'Authorization is required, please follow your process for Auth creation.', ''));
            }*/
            }
            else if(sCode == 'CS' || sCode == 'CO'){
                questionList.push(new fieldDetails(true, 'slds-size_2-of-2', 'Is UHC Primary?', component.get('v.uhcPrimaryRadioButton')));

                if (component.get('v.uhcPrimaryRadioButton') == 'No' ){
                    questionList.push(new fieldDetails(true, 'slds-size_2-of-2', 'Authorization is not required due to this policy being secondary to UHC.  If the provider insists on having an authorization created, please follow your process for Auth creation.', ''));
                }
                if (component.get('v.uhcPrimaryRadioButton') == 'Yes' ){
                    questionList.push(new fieldDetails(true, 'slds-size_2-of-2', 'Did the UHC Prior Auth Required field come back as Blocked/Maybe Blocked - Conditionally?', component.get('v.uhcComeAsBlocked')));
                }
                if (component.get('v.uhcComeAsBlocked') == 'Yes' && sCode == 'CS' ){
                    questionList.push(new fieldDetails(true, 'slds-size_2-of-2', 'Based on the service type of the code, is the corresponding Med Nec Indicator Yes or No?',  component.get('v.medNecIndValue')));
                }
                if (component.get('v.medNecIndValue') == 'Yes' || (component.get('v.uhcComeAsBlocked') == 'Yes' && sCode == 'CO') ){
                    questionList.push(new fieldDetails(true, 'slds-size_2-of-2', 'Select Service Type',  component.get('v.SST')));
                }
                if (component.get('v.uhcComeAsBlocked') == 'No' || component.get('v.medNecIndValue') == 'No'){
                    questionList.push(new fieldDetails(true, 'slds-size_2-of-2', 'Did the UHC Prior Auth Required field come back as Yes or Prior Auth Maybe Required?', component.get('v.priorAuthRadioButton')));
                }
                if (component.get('v.SST') == 'Radiology/Cardiology' ){
                    questionList.push(new fieldDetails(true, 'slds-size_2-of-2', 'Advise provider that authorization is required.  Advise to submit online at uhcprovider.com or contact Evicore at 866-889-8054.',  ''));
                }
                if (component.get('v.SST') == 'Oncology/Chemotherapy' ){
                    questionList.push(new fieldDetails(true, 'slds-size_2-of-2', 'Advise provider that authorization is required.  Advise to submit online at uhcprovider.com or contact Optum at 888-397-8129',  ''));
                }
                if (component.get('v.SST') == 'Genetic Testing' ){
                    questionList.push(new fieldDetails(true, 'slds-size_2-of-2', 'Advise provider that authorization is required.  Advise to submit online at uhcprovider.com or contact Beacon at 800-377-8809.',  ''));
                }
                if (component.get('v.priorAuthRadioButton') == 'No' ){
                    questionList.push(new fieldDetails(true, 'slds-size_2-of-2', 'Authorization is not required.', ''));
                }
                if (component.get('v.priorAuthRadioButton') == 'Yes' ){
                    questionList.push(new fieldDetails(true, 'slds-size_2-of-2', 'Is this a Delegated Plan?',  component.get('v.delegatedPlanRadioButton')));
                }
                if (component.get('v.delegatedPlanRadioButton') == 'Yes' ){
                    questionList.push(new fieldDetails(true, 'slds-size_2-of-2', 'Is Authorizations handled by UHC?',  component.get('v.handledByUHCRadioButton')));
                }
                if ((component.get('v.delegatedPlanRadioButton') == 'No' || component.get('v.handledByUHCRadioButton') == 'Yes') &&  sCode == 'CS' ){
                    questionList.push(new fieldDetails(true, 'slds-size_2-of-2', 'Is this a member notification requirement?',  component.get('v.memberNotifRadioButton')));
                }
                if ((component.get('v.delegatedPlanRadioButton') == 'No' || component.get('v.handledByUHCRadioButton') == 'Yes') &&  sCode == 'CO' ){
                    questionList.push(new fieldDetails(true, 'slds-size_2-of-2', 'Authorization is required, please follow your process for Auth creation.', ''));
                }
                if (component.get('v.handledByUHCRadioButton') == 'No' ){
                    questionList.push(new fieldDetails(true, 'slds-size_2-of-2', 'Authorization is handled by Delegation, follow your standard processes for transferring the call.', ''));
                }
                if (component.get('v.memberNotifRadioButton') == 'No' ){
                    questionList.push(new fieldDetails(true, 'slds-size_2-of-2', 'Authorization is required, please follow your process for Auth creation.', ''));
                }
                if (component.get('v.memberNotifRadioButton') == 'Yes' ){
                    questionList.push(new fieldDetails(true, 'slds-size_2-of-2', 'Advise the provider of the member notification requirements.', ''));
                }
            }


            autodocCmp.additionalSectionData = questionList;
            autodocCmp.caseItemsExtId = 'PA Check'; // US3742854

            _autodoc.setAutodoc(component.get("v.autodocUniqueId"), component.get("v.autodocUniqueIdCmp"), autodocCmp);

        }

        var autodocCmp = _autodoc.getAutodocComponent(component.get("v.autodocUniqueId"), component.get("v.autodocUniqueIdCmp"), 'Benefit/PA Check');

        function fieldDetails(c, nc, fn, fv) {
            this.checked = c;
            this.noOfColumns = nc;
            this.fieldName = fn;
            this.fieldValue = fv;
            this.isReportable = true;
        }
    },

    //US3219740 - Sravan - Start
    getProviderNotificationTool : function(component, event, helper){
        var action = component.get("c.getProviderNotification");
        action.setCallback(this,function(response){
            var state = response.getState();
            console.log('State'+ state);
            if(state == 'SUCCESS'){
                var responseUrl = response.getReturnValue();
                console.log('Provider Notification Tool'+ responseUrl);
                component.set("v.providerNotificationTool",responseUrl);
    }
})
        $A.enqueueAction(action);
    },/*,
    //US3219740 - Sravan - End
    getOptumHealthAuthREQD : function(component, event){
        console.log('healthServiceProductCode: '+ component.get("v.healthServiceProductCode"));
        console.log('vendorBenefitOptionTypeCode: '+ component.get("v.vendorBenefitOptionTypeCode"));
        console.log('isParticipating: '+ component.get("v.isParticipating"));
        var healthServiceProductCode = component.get("v.healthServiceProductCode");
        var vendorBenefitOptionTypeCode = component.get("v.vendorBenefitOptionTypeCode")
        var isParticipating = component.get("v.isParticipating")
        var getOptumHealthAuthREQDStr ="";
        if(!$A.util.isUndefinedOrNull(healthServiceProductCode) && !$A.util.isUndefinedOrNull(vendorBenefitOptionTypeCode)){
            if(healthServiceProductCode == "AC" && isParticipating){
                if(vendorBenefitOptionTypeCode == "NTOY"){
                    getOptumHealthAuthREQDStr = "No OptumHealth Contact Needed";
                }else{
                    //getOptumHealthAuthREQDStr = "Contact OptumHealth";//'Contact OptumHealth  for PT, OT, and Chiro
                    getOptumHealthAuthREQDStr = "Contact OptumHealth  for PT, OT, and Chiro";
                }
            }
            if(healthServiceProductCode == "AC" && !isParticipating){
                getOptumHealthAuthREQDStr = "Not Participating";
            }

            if(healthServiceProductCode != "AC"){
                getOptumHealthAuthREQDStr = "Member Not Enrolled";
            }
        }
        return getOptumHealthAuthREQDStr;
    }*/
    addCodeDetails : function(component, event, helper,selectedRowData){
        var selectedRowDataRec = selectedRowData;
        var code="";
        if(selectedRowData && selectedRowData.rowColumnData){
            var inpList = selectedRowData.rowColumnData;
            for(var a = 0; a < inpList.length; a++){
                if(inpList[a].fieldLabel && inpList[a].fieldLabel == 'Code'){
                    code = inpList[a].fieldValue;
                }
            }
        }
        console.log("selectedRowData: "+selectedRowData);
        var codeDetialsMap = component.get("v.procedureCodeMap");
        var procedureCodeDetailsList = component.get("v.procedureCodeDetailsList");
        /*
        if(!$A.util.isUndefinedOrNull(procedureCodeDetailsList) && !$A.util.isEmpty(procedureCodeDetailsList)){
            console.log("procedureCodeDetailsList: "+procedureCodeDetailsList);
            if(codeDetialsMap && codeDetialsMap.hasOwnProperty(code)){
                console.log("codeDetialsMap: "+codeDetialsMap);

                var codeDetialsRec = codeDetialsMap[code];
                for(var j=0; j<codeDetialsRec.length;j++){
                    procedureCodeDetailsList.push(codeDetialsRec[j]);
                }

            }

            component.set("v.procedureCodeDetailsList",procedureCodeDetailsList);
        }else{
            if(codeDetialsMap && codeDetialsMap.hasOwnProperty(code)){
                console.log("codeDetialsMap: "+codeDetialsMap);
                var codeDetialsRec = codeDetialsMap[code];
                for(var j=0; j<codeDetialsRec.length;j++){
                    procedureCodeDetailsList.push(codeDetialsRec[j]);
                }
                component.set("v.procedureCodeDetailsList",procedureCodeDetailsList);
            }

        }      */
        /****************/
        var pcodeListDisplayed = component.get("v.procedureCodeDetailsListNew");
        const codeFound = pcodeListDisplayed.find(i => i.code == code);
        if(!codeFound){
            var pCodeDetailsList;
            if(pcodeListDisplayed){
                pCodeDetailsList = pcodeListDisplayed;
            }else{
                pCodeDetailsList = [];
            }
            var procedureCodeDetailsListNew = [];
            var codeDetialsRecNew = codeDetialsMap[code];
            var CodeDesc = "";
            var CodeDescription = "";
            for(var j=0; j<codeDetialsRecNew.length;j++){
                CodeDesc = codeDetialsRecNew[j].CodeDescription;
                CodeDescription = (CodeDesc.length > 0) ? (CodeDesc.length >= 80) ? CodeDesc.substring(0, 80) + '...' : CodeDesc : '';
                procedureCodeDetailsListNew.push(codeDetialsRecNew[j]);
            }

            var pcRec = {"code":code,"CodeDescription":CodeDescription,"title":CodeDesc,"details":procedureCodeDetailsListNew};

            pCodeDetailsList.push(pcRec);

            component.set("v.procedureCodeDetailsListNew",pCodeDetailsList);
            helper.codeDetailsAccessedAutoDoc(component, event, helper);

        }
        helper.scrollCodeDetailsToView(component, event, helper);



    },
    scrollCodeDetailsToView : function(component, event, helper) {
        var elementId = component.find("codeDetailsCards")
        setTimeout(function() {
            if (!$A.util.isUndefinedOrNull(elementId)) {
                elementId.getElement().scrollIntoView({
                    behavior: 'smooth',
                    block: 'start',
                    inline: 'end'
                });
            }
        }, 100);

    },
    codeDetailsAccessedAutoDoc : function(component, event, helper) {
        if(!component.get("v.isCodeDetailsAccessed")){
            component.set("v.isCodeDetailsAccessed",true)
            var cardDetails = new Object();
            cardDetails.componentName = "Code Details";
            cardDetails.componentOrder = 18;
            cardDetails.noOfColumns = "slds-size_1-of-1";
            cardDetails.type = "card";
            cardDetails.allChecked = false;
            cardDetails.cardData = [
                {
                    "checked": true,
                    "disableCheckbox": true,
                    "fieldName": "Code Details",
                    "fieldType": "outputText",
                    "fieldValue": "Accessed"
                }
            ];
            _autodoc.setAutodoc(component.get("v.autodocUniqueId"), component.get("v.autodocUniqueIdCmp"), cardDetails);
        }
    },

    processCodeDetails : function(component, event,code) {
        var codeDetails ="Code Details";
        var codeDetialsMap = component.get("v.procedureCodeMap");
        if(codeDetialsMap){
            var codeDetialsRec = codeDetialsMap[code];
            for(var j=0; j<codeDetialsRec.length;j++){
                var CodeIndicatorType = codeDetialsRec[j].CodeIndicatorType;
                if(CodeIndicatorType =="Claim Processing Instruction"){
                    codeDetails = codeDetialsRec[j].Value;
                }
            }
        }

        return codeDetails;
    }

})