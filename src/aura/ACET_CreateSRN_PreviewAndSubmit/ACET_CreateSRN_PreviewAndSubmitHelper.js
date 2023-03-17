({
	formatDate : function(cmp, event)
    {
        cmp.set('v.servStartDt',(!$A.util.isUndefinedOrNull(cmp.get('v.reqInfo.ServiceStartDt')))?this.convertDate(cmp,cmp.get('v.reqInfo.ServiceStartDt')):'--');
        cmp.set('v.servEndDt',(!$A.util.isUndefinedOrNull(cmp.get('v.reqInfo.ServiceEndDt')))?this.convertDate(cmp,cmp.get('v.reqInfo.ServiceEndDt')):'--');
        cmp.set('v.actAdmitDt',(!$A.util.isUndefinedOrNull(cmp.get('v.reqInfo.ActualAdmissionDt')) && ((!$A.util.isEmpty(cmp.get('v.reqInfo.ActualAdmissionDt')))))?this.convertDate(cmp,cmp.get('v.reqInfo.ActualAdmissionDt')):'--');
        cmp.set('v.actDischargeDt',(!$A.util.isUndefinedOrNull(cmp.get('v.reqInfo.ActualDischargeDt')) && ((!$A.util.isEmpty(cmp.get('v.reqInfo.ActualDischargeDt')))))?this.convertDate(cmp,cmp.get('v.reqInfo.ActualDischargeDt')):'--');
        
		
	},
    convertDate : function(cmp, date)
    {
        return date.substring(5,7)+'/'+date.substring(8,10)+'/'+date.substring(0,4);
    },
    createProviderDetails : function(cmp, event)
    {
        let srnProviderDetailList = cmp.get('v.srnProviderDetailList');
        let hscProviderDetails = new Array();
        let policyCoverageType = '';
        let lineOfBusiness = '';//US3116511 TTAP Vishnu
        let insuranceTypeCode = '';//US3116511 TTAP Vishnu
        let providerSeqNo = 1;

        for(let i =0; i < srnProviderDetailList.length; i++){

            // Breaking the Iteration if the provider card is empty (Member only flow)
            if(srnProviderDetailList[i].isMainCard && !srnProviderDetailList[i].isShowProviderDetails){
                continue;
            }

            if($A.util.isEmpty(policyCoverageType)){
                policyCoverageType = srnProviderDetailList[i].policyCoverageType;
            }//US3116511 TTAP Vishnu
            if($A.util.isEmpty(lineOfBusiness)){
                lineOfBusiness=srnProviderDetailList[i].lineOfBusiness;
            }//US3116511 TTAP Vishnu
            if($A.util.isEmpty(insuranceTypeCode)){
                insuranceTypeCode=srnProviderDetailList[i].insuranceTypeCode

            }

            let providerRoleList = new Array();
            let providerRoles = {
                "providerRole" : []
            };
            
            let hscProviderDetailObject = srnProviderDetailList[i].hscProviderDetails;
            
            if(!$A.util.isUndefinedOrNull(srnProviderDetailList[i].providerRoleDetails)) {

                let providerRoleDetails = srnProviderDetailList[i].providerRoleDetails;
                if(providerRoleDetails.isProviderPCP){
                    let providerRole = {
                        "providerRole": "PC",
                        "providerRoleDesc": ""
                    };
                    providerRoleList.push(providerRole);
                }
                if(providerRoleDetails.isProviderFacility){
                    let providerRole = {
                        "providerRole": "FA",
                        "providerRoleDesc": ""
                    };
                    providerRoleList.push(providerRole);
                }
                if(providerRoleDetails.isProviderAttending){
                    let providerRole = {
                        "providerRole": "AT",
                        "providerRoleDesc": ""
                    };
                    providerRoleList.push(providerRole);
                }
                if(providerRoleDetails.isProviderRequesting){
                    let providerRole = {
                        "providerRole": "RF",
                        "providerRoleDesc": ""
                    };
                    providerRoleList.push(providerRole);
                }
                if(providerRoleDetails.isProviderAdmitting){
                    let providerRole = {
                        "providerRole": "AD",
                        "providerRoleDesc": ""
                    };
                    providerRoleList.push(providerRole);
                }
                if(providerRoleDetails.isProviderServicing){
                    let providerRole = {
                        "providerRole": "SJ",
                        "providerRoleDesc": ""
                    };
                    providerRoleList.push(providerRole);
                }
                providerRoles.providerRole = providerRoleList;
                hscProviderDetailObject.providerRoles = providerRoles;
            }

            hscProviderDetailObject.providerSeqNum = providerSeqNo;
            hscProviderDetails.push(hscProviderDetailObject);
            providerSeqNo++;
        }
        cmp.set('v.hscProviders',hscProviderDetails);
        cmp.set('v.policyCoverageType',policyCoverageType);
        cmp.set('v.lineOfBusiness',lineOfBusiness);//US3116511 TTAP Vishnu
        cmp.set('v.insuranceTypeCode',insuranceTypeCode);//US3116511 TTAP Vishnu


    },

    // Preview Autodoc - US2819895
    // Sanka - 23.10.2020
    createAutoDoc: function(cmp, SRNNumber)
    {
        var srnData = cmp.get("v.SRNData");
        var reqInfo = cmp.get("v.reqInfo");
        var adArray = [];
        // Setting Header with empty card
        // Empty Data
        var emptDta = [];
        emptDta.push(new fieldDetails(false, false, false, '', '', 'outputText'));
        adArray.push(new card('card','Auth Summary: ' + ( !$A.util.isEmpty(SRNNumber) ? SRNNumber : 'N/A'),'slds-size_3-of-12',4.1,emptDta));

        // Member Details
        var memberData = cmp.get("v.memberCardSnap");
        var mem_cardData = [];
        mem_cardData.push(new fieldDetails(true, false, true, 'Name', memberData.memberName, 'outputText'));
        mem_cardData.push(new fieldDetails(true, false, true, 'Member ID', memberData.memberId, 'outputText'));
        var memberAge = memberData.memberDOB + ', ' + memberData.age + ' Years';
        mem_cardData.push(new fieldDetails(true, false, true, 'DOB', memberAge, 'outputText'));
        adArray.push(new card('card','Member Details','slds-size_3-of-12',4.2,mem_cardData));

        // Provider Details
        var providers = cmp.get("v.srnProviderDetailList");
        providers.forEach(provider => {
            var providerName = provider.hscProviderDetails.providerCategory =='H' ? 
                                (!$A.util.isEmpty(provider.hscProviderDetails.businessName) ? provider.hscProviderDetails.businessName : '') : 
                                (!$A.util.isEmpty(provider.hscProviderDetails.firstName) ? provider.hscProviderDetails.firstName : '') + ' ' + (!$A.util.isEmpty(provider.hscProviderDetails.lastName) ? provider.hscProviderDetails.lastName : '');
            var prov_cardData = [];
            prov_cardData.push(new fieldDetails(true, false, true, 'TAX ID', !$A.util.isEmpty(provider.createSrnNetworkStatusRequestParams) ? provider.createSrnNetworkStatusRequestParams.taxId : '--', 'outputText'));
            prov_cardData.push(new fieldDetails(true, false, true, 'NPI', !$A.util.isEmpty(provider.createSrnNetworkStatusRequestParams) ? provider.createSrnNetworkStatusRequestParams.npi : '--', 'outputText'));
            prov_cardData.push(new fieldDetails(true, false, true, 'Status', provider.hscProviderDetails.networkStatusTypeDesc, 'outputText'));
            adArray.push(new card('card',('Provider: ' + providerName),'slds-size_3-of-12',4.3,prov_cardData));
        });

        // Date of servie Summary
        var dosData = [];
        dosData.push(new fieldDetails(true, false, true, 'Service Start Date', cmp.get("v.servStartDt"), 'outputText'));
        dosData.push(new fieldDetails(true, false, true, 'Service End Date', cmp.get("v.servEndDt"), 'outputText'));
        dosData.push(new fieldDetails(true, false, true, '', ' ', 'outputText'));
        dosData.push(new fieldDetails(true, false, true, '', ' ', 'outputText'));
        if(cmp.get("v.type") == 'Inpatient' && srnData.RequiredInfo.HasAdmitted=='Yes'){
            dosData.push(new fieldDetails(true, false, true, 'Actual Admission', cmp.get("v.actAdmitDt"), 'outputText'));
            dosData.push(new fieldDetails(true, false, true, 'Actual Discharge', cmp.get("v.actDischargeDt"), 'outputText'));
        }
        adArray.push(new card('card','Date of Service Summary','slds-size_3-of-12',4.4,dosData));

        // Diagnoses Codes Summary
        var diagData = [];
        diagData.push(new fieldDetails(true, false, true, 'Primary Diagnoses Code', reqInfo.PrimaryCode, 'outputText'));
        diagData.push(new fieldDetails(true, false, true, 'Primary Description', reqInfo.PrimaryDescription, 'outputText'));
        diagData.push(new fieldDetails(true, false, true, '', ' ', 'outputText'));
        diagData.push(new fieldDetails(true, false, true, '', ' ', 'outputText'));
        if(cmp.get("v.type") == 'Inpatient'){
            diagData.push(new fieldDetails(true, false, true, 'Admitting Diagnoses Code', reqInfo.AdmittingCode, 'outputText'));
            diagData.push(new fieldDetails(true, false, true, 'Admitting Description', reqInfo.AdmittingDescription, 'outputText'));
            diagData.push(new fieldDetails(true, false, true, '', ' ', 'outputText'));
            diagData.push(new fieldDetails(true, false, true, '', ' ', 'outputText'));
        }
        reqInfo.DiagnosisData.forEach(diag => {
            if(!$A.util.isEmpty(diag.DiagnosisCode) || !$A.util.isEmpty(diag.DiagnosisDesc)){
                diagData.push(new fieldDetails(true, false, true, 'Secondary Diagnoses Code', diag.DiagnosisCode, 'outputText'));
                diagData.push(new fieldDetails(true, false, true, 'Secondary Description', diag.DiagnosisDesc, 'outputText'));
                diagData.push(new fieldDetails(true, false, true, '', ' ', 'outputText'));
                diagData.push(new fieldDetails(true, false, true, '', ' ', 'outputText'));
            }
        });
        adArray.push(new card('card','Diagnoses Codes Summary','slds-size_3-of-12',4.5,diagData));

        // US3222360
        if (cmp.get("v.type") != 'Inpatient') {
            var stMsData = [];
            reqInfo.ProcedureData.forEach(proc => {
                // Standard of Measure Summary
                stMsData.push(new fieldDetails(true, false, true, 'Standard of Measure', proc.StandardOfMeasures, 'outputText'));
                stMsData.push(new fieldDetails(true, false, true, 'Count', proc.Count, 'outputText'));
                stMsData.push(new fieldDetails(true, false, true, 'Frequency', proc.Frequency, 'outputText'));
                stMsData.push(new fieldDetails(true, false, true, 'Total', proc.Total, 'outputText'));
            });
            adArray.push(new card('card', 'Standard of Measure Summary', 'slds-size_3-of-12', 4.6, stMsData));
            if (cmp.get("v.type") == 'Outpatient') {
                var dmeData = [];
                reqInfo.ProcedureData.forEach(proc => {
                    // DME Summary
                    dmeData.push(new fieldDetails(true, false, true, 'DME Procurement Type', proc.DMEProcurementType, 'outputText'));
                    dmeData.push(new fieldDetails(true, false, true, 'DME Total Cost', proc.DMETotalCost, 'outputText'));
                    dmeData.push(new fieldDetails(true, false, true, '', ' ', 'outputText'));
                    dmeData.push(new fieldDetails(true, false, true, '', ' ', 'outputText'));
                });
                adArray.push(new card('card', 'DME Summary', 'slds-size_3-of-12', 4.7, dmeData));
            }
        }

        // Procedure Code Summary
        var pcodeSumData = [];
        reqInfo.ProcedureData.forEach(proc => {
            if(!$A.util.isEmpty(proc.ProcedureCode) || !$A.util.isEmpty(proc.ProcedureDesc) || !$A.util.isEmpty(proc.ProcedureType)){
                pcodeSumData.push(new fieldDetails(true, false, true, 'Procedure Code', proc.ProcedureCode, 'outputText'));
                pcodeSumData.push(new fieldDetails(true, false, true, 'Procedure Description', proc.ProcedureDesc, 'outputText'));
                pcodeSumData.push(new fieldDetails(true, false, true, 'Procedure Type', proc.ProcedureType, 'outputText'));
                pcodeSumData.push(new fieldDetails(true, false, true, '', ' ', 'outputText'));
            }
        });        
        adArray.push(new card('card', 'Procedure Code Summary', 'slds-size_3-of-12', 4.8, pcodeSumData));

        // Notes
        if(cmp.get("v.type") == 'Outpatient' || cmp.get("v.type") == 'Outpatient Facility')
        {
            var notesData = [];
            notesData.push(new fieldDetails(true, false, true, 'Note Type', srnData.RequiredInfo.NoteType, 'outputText'));
            notesData.push(new fieldDetails(true, false, true, 'Subject Type', srnData.RequiredInfo.SubjectType, 'outputText'));
            notesData.push(new fieldDetails(true, false, true, '', ' ', 'outputText'));
            notesData.push(new fieldDetails(true, false, true, '', ' ', 'outputText'));
            notesData.push(new fieldDetails(true, false, true, 'Comments: Note Details', srnData.RequiredInfo.NoteDetails, 'outputText'));
            adArray.push(new card('card', 'Notes Summary', 'slds-size_3-of-12', 4.9, notesData));
        }       

        // Additional Information
        var adData = [];
        var cbData =[];
        adData.push(new fieldDetails(true, false, true, '', reqInfo.isSAIOpen ? 'Special Account Instructions accessed ' : '--', 'outputText'));
        cbData.push(new fieldDetails(true, false, true, 'Case Build Additional Information accessed.', reqInfo.CaseBuildAddInfo.length>0 ? reqInfo.CaseBuildAddInfo :'--', 'outputText'));
        cbData.push(new fieldDetails(true, false, true, 'Provider Roles:', reqInfo.providerRoles, 'outputText'));
        adArray.push(new card('card','Additional Information','slds-size_3-of-12',4.91,adData));
        adArray.push(new card('card','Case Build Additional Information','slds-size_12-of-12',4.9111,cbData));
        var descData = [];
        descData.push(new fieldDetails(true, false, true, '',(!cmp.get("v.flipflop"))? cmp.get("v.disclaimerMsg"):'TTAP link not accessed.', 'outputText'));
        adArray.push(new card('card','Disclaimer','slds-size_12-of-12',4.92,descData));

        var autodocString = JSON.stringify(adArray);
        return autodocString;

        function card(t, n, c, o, cd){
            this.type = t;
            this.componentName = n;
            this.noOfColumns = c;
            this.componentOrder = o;
            this.cardData = cd;
            this.caseItemsExtId = SRNNumber; // US3691220: Add missing fields/components to autodoc reporting (Topic = View Authorizations) - Krish - 19th Aug 2021
        }

        function fieldDetails(c, dc, sc, fn, fv, ft) {
            this.checked = c;
            this.defaultChecked = dc;
            this.showCheckbox = sc;
            this.fieldName = fn;
            this.fieldValue = !$A.util.isEmpty(fv) ? fv : '--';
            this.fieldType = ft;
            this.isReportable = ($A.util.isEmpty(fn) && ($A.util.isEmpty(fv) || fv==' ') ? false:true); // US3691220: Add missing fields/components to autodoc reporting (Topic = View Authorizations) - Krish - 19th Aug 2021
        }
    },
    fireToastMessage: function (title, message, type, mode, duration) {
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

    // US3587915 - Create Auth : Call new API for Case Provider Search Provider  Mappings - Sarma- 03rd June 2021
    createProviderRequestDetails: function (cmp, helper,currenttabId) {
        debugger;
        console.log('currenttabId :::: ' + currenttabId);
        let policyCoverageType = '';
        let srnProviderDetailList = cmp.get('v.srnProviderDetailList');
        let hscProvidersList = new Array();
        let hscProviders = {
            "hscProvider": []
        };
        let providerSeqNo = 1;

        for (let i = 0; i < srnProviderDetailList.length; i++) {

            // Breaking the Iteration if the provider card is empty (Member only flow)
            if (srnProviderDetailList[i].isMainCard && !srnProviderDetailList[i].isShowProviderDetails) {
                continue;
            }

            let providerRoleList = new Array();
            let providerRoles = {
                "providerRole": []
            };

            if ($A.util.isEmpty(policyCoverageType)) {
                policyCoverageType = srnProviderDetailList[i].policyCoverageType;
            }

            if (!$A.util.isUndefinedOrNull(srnProviderDetailList[i].providerRoleDetails)) {

                let providerRoleDetails = srnProviderDetailList[i].providerRoleDetails;
                if (providerRoleDetails.isProviderPCP) {
                    let providerRole = {
                        "providerRole": "PC",
                        "providerRoleDesc": ""
                    };
                    providerRoleList.push(providerRole);
                }
                if (providerRoleDetails.isProviderFacility) {
                    let providerRole = {
                        "providerRole": "FA",
                        "providerRoleDesc": ""
                    };
                    providerRoleList.push(providerRole);
                }
                if (providerRoleDetails.isProviderAttending) {
                    let providerRole = {
                        "providerRole": "AT",
                        "providerRoleDesc": ""
                    };
                    providerRoleList.push(providerRole);
                }
                if (providerRoleDetails.isProviderRequesting) {
                    let providerRole = {
                        "providerRole": "RF",
                        "providerRoleDesc": ""
                    };
                    providerRoleList.push(providerRole);
                }
                if (providerRoleDetails.isProviderAdmitting) {
                    let providerRole = {
                        "providerRole": "AD",
                        "providerRoleDesc": ""
                    };
                    providerRoleList.push(providerRole);
                }
                if (providerRoleDetails.isProviderServicing) {
                    let providerRole = {
                        "providerRole": "SJ",
                        "providerRoleDesc": ""
                    };
                    providerRoleList.push(providerRole);
    }
                providerRoles.providerRole = providerRoleList;
            }

            let hscProviderDetailObject = {
                "providerRoles": providerRoles,
                "providerIdentifiers": srnProviderDetailList[i].hscProviderDetails.providerIdentifiers,
                "providerCategory": srnProviderDetailList[i].hscProviderDetails.providerCategory,
                "firstName": srnProviderDetailList[i].hscProviderDetails.firstName,
                "middleName": srnProviderDetailList[i].hscProviderDetails.middleName,
                "lastName": srnProviderDetailList[i].hscProviderDetails.lastName,
                "providerSeqNum": providerSeqNo,
                "address1": srnProviderDetailList[i].hscProviderDetails.address1,
                "city": srnProviderDetailList[i].hscProviderDetails.city,
                "state": srnProviderDetailList[i].hscProviderDetails.state,
                "zip": srnProviderDetailList[i].hscProviderDetails.zip,
                "zipSuffix": srnProviderDetailList[i].hscProviderDetails.zipSuffix,
                "providerTerminationDate": srnProviderDetailList[i].hscProviderDetails.providerTerminationDate,
                "businessName": srnProviderDetailList[i].hscProviderDetails.businessName,
                "providerEffectiveDate" : srnProviderDetailList[i].hscProviderDetails.providerEffectiveDate
            };

            hscProvidersList.push(hscProviderDetailObject);
            providerSeqNo++;
        }
        hscProviders.hscProvider = hscProvidersList;
        cmp.set('v.caseProviderRequstProviders',hscProvidersList);

        var currentid = _setAndGetSessionValues.gettingValue(currenttabId);
        var extendedData = _setAndGetSessionValues.gettingValue("Policy:"+currentid+":"+currentid);
        var rced = _setAndGetSessionValues.gettingValue("RCED:"+currentid+":"+currentid);

        let memberDetails = new Object();
        if (!$A.util.isUndefinedOrNull(extendedData.policyResultWrapper) && !$A.util.isUndefinedOrNull(extendedData.policyResultWrapper.resultWrapper) && !$A.util.isUndefinedOrNull(extendedData.policyResultWrapper.resultWrapper.policyRes)){
            var policyRes = extendedData.policyResultWrapper.resultWrapper.policyRes;

            let coverageTypeCode = '';
            if(cmp.get('v.policyCoverageType') == 'Medical'){
                coverageTypeCode = 'M';
            }

            memberDetails = {
                "platform": $A.util.isEmpty(policyRes.platform) ? '' : policyRes.platform,
                "subscriberID": $A.util.isEmpty(policyRes.subscriberID) ? '' : policyRes.subscriberID,
                "xrefId": $A.util.isEmpty(policyRes.xrefId) ? '' : policyRes.xrefId,
                "xrefIdPartitionNumber": $A.util.isEmpty(policyRes.xrefIdPartitionNumber) ? '' : policyRes.xrefIdPartitionNumber,
                "sourceCode": $A.util.isEmpty(policyRes.sourceCode) ? '' : policyRes.sourceCode,
                "claimSourceSystemCode": $A.util.isEmpty(policyRes.claimSourceSystemCode) ? '' : policyRes.claimSourceSystemCode,
                "policyNumber": $A.util.isEmpty(policyRes.policyNumber) ? '' : policyRes.policyNumber,
                "firstName": $A.util.isEmpty(policyRes.memberInfo.firstName) ? '' : policyRes.memberInfo.firstName,
                "lastName": $A.util.isEmpty(policyRes.memberInfo.lastName) ? '' : policyRes.memberInfo.lastName,
                "middleName": $A.util.isEmpty(policyRes.memberInfo.middleName) ? '' : policyRes.memberInfo.middleName,
                "genderCode": $A.util.isEmpty(policyRes.memberInfo.genderCode) ? '' : policyRes.memberInfo.genderCode,
                "sourceId": '', // Gap
                "dob": $A.util.isEmpty(policyRes.memberInfo.dob) ? '' : policyRes.memberInfo.dob,
                "effectiveStartDate": $A.util.isEmpty(policyRes.coverageStartDate) ? '' : policyRes.coverageStartDate,
                "effectiveEndDate": $A.util.isEmpty(policyRes.coverageEndDate) ? '' : policyRes.coverageEndDate,
                "coverageTypeCode": coverageTypeCode, // Eligibility
                "stateOfIssueCode": $A.util.isEmpty(policyRes.stateOfIssueCode) ? '' : policyRes.stateOfIssueCode,
                "governmentProgramCode": $A.util.isEmpty(policyRes.governmentProgramCode) ? '' : policyRes.governmentProgramCode,
                "tciTableNumber": '', // Gap
                "marketSite": $A.util.isEmpty(policyRes.marketSite) ? '' : policyRes.marketSite,
                "marketType": $A.util.isEmpty(policyRes.marketType) ? '' : policyRes.marketType,
                "productCode": '',//$A.util.isEmpty(rced.productCode) ? '' : rced.productCode, // RCED
                "sharedArrangementCode": $A.util.isEmpty(policyRes.sharedArrangement) ? '' : policyRes.sharedArrangement,
                "obligorID": $A.util.isEmpty(policyRes.obligorID) ? '' : policyRes.obligorID,
                "cosmosDivision": $A.util.isEmpty(policyRes.cosmosDivision) ? '' : policyRes.cosmosDivision,
                "groupPanelNumber": $A.util.isEmpty(policyRes.groupPanelNumber) ? '' : policyRes.groupPanelNumber,
                "reportingCode": $A.util.isEmpty(policyRes.reportingCode) ? '' : policyRes.reportingCode,
                "databaseMemberId": '', // Gap
                "memberID": $A.util.isEmpty(policyRes.memberInfo.memberID) ? '' : policyRes.memberInfo.memberID,
                "alternateId": $A.util.isEmpty(policyRes.alternateId) ? '' : policyRes.alternateId,
                "individualIdentifier": '', // Gap
                "mbi": $A.util.isEmpty(policyRes.mbi) ? '' : policyRes.mbi,
                "lineOfBusiness": $A.util.isEmpty(policyRes.lineofBusiness) ? '' : policyRes.lineofBusiness,
                "cirrusMCHID": '' // Gap
            };
            cmp.set('v.caseProviderRequstMember',memberDetails);
        }
    },

    fetchProviderDetails: function (cmp, helper) {
        debugger;

        helper.showSpinner(cmp);

        var action = cmp.get('c.callCaseProviderSearch');

        let caseProviderRequstProviders = cmp.get('v.caseProviderRequstProviders');
        let caseProviderRequstMember = cmp.get('v.caseProviderRequstMember');



        action.setParams({
            "providerDetails": caseProviderRequstProviders,
            "memberDetails": caseProviderRequstMember
        });

        action.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {
                helper.hideSpinner(cmp);
                let result = response.getReturnValue();
                if (!$A.util.isUndefinedOrNull(result) && (!$A.util.isEmpty(result))) {
                    if(result.success && result.statusCode == 200){
                        let returnVal = result.response;
                        console.log('UUUUUUU :::: ' + JSON.stringify(returnVal));
                        if(!$A.util.isEmpty(returnVal) && !$A.util.isEmpty(returnVal.caseDetails)){
                            cmp.set('v.caseDetailsForCreateAuth', returnVal.caseDetails);
                        }

                    }
                }
            } else {
                helper.hideSpinner(cmp);
                //helper.fireToastMessage("We hit a snag.", 'Unexpected Error Occurred. Please try again. If problem persists please contact the help desk.', "error", "dismissible", "30000");
            }
        });
        $A.enqueueAction(action);
    },
    showSpinner: function (cmp) {
        var spinner = cmp.find('srncspinner');
        $A.util.removeClass(spinner, "slds-hide");
        $A.util.addClass(spinner, "slds-show");
    },

    hideSpinner: function (cmp) {
        var spinner = cmp.find('srncspinner');
        $A.util.removeClass(spinner, "slds-show");
        $A.util.addClass(spinner, "slds-hide");
    },
})