({
    //US3625667: View Payments -  Error Code Handling - Swapnil
    paymentResultsErrorMsg: "Unexpected Error Occurred in the Payment Result Card. Please try again. If problem persists please contact help desk. ",

    initSetData: function (cmp, event) {
        var readCheckResp = cmp.get('v.readCheckResp');
         var isreadCheck=false;
        if(!$A.util.isEmpty(readCheckResp) && (!$A.util.isUndefinedOrNull(readCheckResp)))
         isreadCheck = ((!$A.util.isUndefinedOrNull(readCheckResp.response))
            && (!$A.util.isUndefinedOrNull(readCheckResp.response.data))) ? true : false;
        var tableDetails = new Object();
        tableDetails.type = "table";
        tableDetails.showComponentName = false;
        tableDetails.componentName = 'Payment Result: ' + cmp.get('v.checkNumber');
        tableDetails.autodocHeaderName = 'Payment Result: ' + cmp.get('v.checkNumber');
        tableDetails.tableHeaders = ["PAYMENT #", "ISSUED", "TYPE", "STATUS", "TOTAL", "PAYEE NAME", "PAYEE TYPE", "ADDRESS", "CASHED/REDEEMED", "VOID/STOP", "RETURNED", "REMAILED", "REISSUED", "REISSUED #"];
        tableDetails.caseItemsEnabled = true;
        tableDetails.componentOrder= 3;
        tableDetails.tableBody = [];
		var policyDetails = cmp.get('v.policyDetails');
        var hasCaseItems = false;
        var caseNotSavedTopics = cmp.get("v.caseNotSavedTopics");
			if (!caseNotSavedTopics.includes("View Payments")) {
				caseNotSavedTopics.push("View Payments");
			}
			cmp.set("v.caseNotSavedTopics", caseNotSavedTopics);
        if (isreadCheck) {
            var readCheckObj = isreadCheck ? readCheckResp.response.data : null;
            cmp.set("v.platform", readCheckObj.platform);
            var checkSearchResp = '';
            if (!$A.util.isUndefinedOrNull(cmp.get('v.checkSearchRespObj')[0].response)) {
                checkSearchResp = cmp.get('v.checkSearchRespObj')[0].response;
            }
            var payeeName = '--';
            var payeeType = '--';
            var payeeAdderss = '--';
            var payeeData;
            hasCaseItems = true;
            var issearchResp = ((!$A.util.isUndefinedOrNull(checkSearchResp))
                && (!$A.util.isUndefinedOrNull(checkSearchResp.data)) &&
                (!$A.util.isUndefinedOrNull(checkSearchResp.data.checkSummary))
                && (!$A.util.isUndefinedOrNull(checkSearchResp.data.checkSummary.payee))) ? true : false;
            if (issearchResp) {
                payeeData = checkSearchResp.data.checkSummary.payee;
                payeeName = (!$A.util.isUndefinedOrNull(payeeData.payeeFirstName)) ? payeeData.payeeFirstName : '--';
                payeeName = (!$A.util.isUndefinedOrNull(payeeData.payeelastName)) ?
                    payeeName != '--' ? ' ' + payeeData.payeelastName : payeeData.payeelastName : '--';
                payeeType = (!$A.util.isUndefinedOrNull(payeeData.payeeTypeDescription)) ? payeeData.payeeTypeDescription : '--';

                hasCaseItems = true;

                if (!$A.util.isUndefinedOrNull(payeeData.postalAddress)) {
                    var adrs = payeeData.postalAddress;
                    if (!$A.util.isUndefinedOrNull(adrs.addressLine1)) {
                        payeeAdderss = adrs.addressLine1;
                    }
                    if (!$A.util.isUndefinedOrNull(adrs.addressLine2)) {
                        payeeAdderss = payeeAdderss != '--' ? payeeAdderss + ', ' + adrs.addressLine2 : adrs.addressLine2;
                    }
                    if (!$A.util.isUndefinedOrNull(adrs.city)) {
                        payeeAdderss = payeeAdderss != '--' ? payeeAdderss + ', ' + adrs.city : adrs.city;
                    }
                    if (!$A.util.isUndefinedOrNull(adrs.state)) {
                        payeeAdderss = payeeAdderss != '--' ? payeeAdderss + ', ' + adrs.state : adrs.state;
                    }
                    if (!$A.util.isUndefinedOrNull(adrs.zip)) {
                        payeeAdderss = payeeAdderss != '--' ? payeeAdderss + ', ' + adrs.zip : adrs.zip;
                    }
                }
            }
            var rowColumnData = [];

            rowColumnData.push(this.setRowColumnData('link', cmp.get('v.seriesDesignator')+cmp.get('v.checkNumber'), 1, ''));
            rowColumnData.push(this.setRowColumnData('outputText', ((!$A.util.isUndefinedOrNull(readCheckObj.issuedDate)) && (!$A.util.isEmpty(readCheckObj.issuedDate)))
                                                     ? this.convertMilitaryDate(cmp, readCheckObj.issuedDate, 'dt') : '', 1, ''));
            rowColumnData.push(this.setRowColumnData('outputText', 'Paper', 1, ''));
            rowColumnData.push(this.setRowColumnData('outputText', readCheckObj.status, 1, ''));
            rowColumnData.push(this.setRowColumnData('Currency',readCheckObj.checkTotal, 1, ''));
            var isMemberFlow = false;
            var sourceCode = '';
            if(((!$A.util.isUndefinedOrNull(policyDetails)) && (!$A.util.isEmpty(policyDetails)))){
                sourceCode  = policyDetails.resultWrapper.policyRes.sourceCode;
                isMemberFlow = true;
            }
            if(isMemberFlow){
            if(sourceCode != 'CO' && sourceCode != 'CS'){
                rowColumnData.push(this.setRowColumnData('outputText', payeeName, 1, ''));
                rowColumnData.push(this.setRowColumnData('outputText', payeeType, 1, ''));
                rowColumnData.push(this.setRowColumnData('outputText', payeeAdderss, 1, ''));
                rowColumnData.push(this.setRowColumnData('outputText', ((!$A.util.isUndefinedOrNull(readCheckObj.cashedDate)) && (!$A.util.isEmpty(readCheckObj.cashedDate)))
                                                         ? this.convertMilitaryDate(cmp, readCheckObj.cashedDate, 'dt') : '', 1, ''));
                rowColumnData.push(this.setRowColumnData('outputText', ((!$A.util.isUndefinedOrNull(readCheckObj.voidDate)) && (!$A.util.isEmpty(readCheckObj.voidDate)))
                                                         ? this.convertMilitaryDate(cmp, readCheckObj.voidDate, 'dt') : '', 1, ''));
                rowColumnData.push(this.setRowColumnData('outputText', ((!$A.util.isUndefinedOrNull(readCheckObj.returnedDate)) && (!$A.util.isEmpty(readCheckObj.returnedDate)))
                                                         ? this.convertMilitaryDate(cmp, readCheckObj.returnedDate, 'dt') : '', 1, ''));
                rowColumnData.push(this.setRowColumnData('outputText', ((!$A.util.isUndefinedOrNull(readCheckObj.remailedDate)) && (!$A.util.isEmpty(readCheckObj.remailedDate)))
                                                         ? this.convertMilitaryDate(cmp, readCheckObj.remailedDate, 'dt') : '', 1, ''));
                rowColumnData.push(this.setRowColumnData('outputText', '', 1, ''));
                rowColumnData.push(this.setRowColumnData('outputText', '', 1, ''));
            }else {
                if(sourceCode =='CS'){

                    	rowColumnData.push(this.setRowColumnData('outputText', payeeName, 1, ''));
                		rowColumnData.push(this.setRowColumnData('outputText', payeeType, 1, ''));
                		rowColumnData.push(this.setRowColumnData('outputText', payeeAdderss, 1, ''));
                    	if(readCheckObj.status == 'Check Cashed' ){
                		rowColumnData.push(this.setRowColumnData('outputText', ((!$A.util.isUndefinedOrNull(readCheckObj.cashedDate)) && (!$A.util.isEmpty(readCheckObj.cashedDate)))
                                                         ? this.convertMilitaryDate(cmp, readCheckObj.cashedDate, 'dt') : '', 1, ''));
                        }if(readCheckObj.status == 'Check Outstanding' || readCheckObj.status == 'Voided'){
                        	rowColumnData.push(this.setRowColumnData('outputText', '', 1, ''));
                        }if(readCheckObj.status == 'Voided'){
                        	rowColumnData.push(this.setRowColumnData('outputText', ((!$A.util.isUndefinedOrNull(readCheckObj.voidDate)) && (!$A.util.isEmpty(readCheckObj.voidDate)))
                                                         ? this.convertMilitaryDate(cmp, readCheckObj.voidDate, 'dt') : '', 1, ''));
                			rowColumnData.push(this.setRowColumnData('outputText', ((!$A.util.isUndefinedOrNull(readCheckObj.returnedDate)) && (!$A.util.isEmpty(readCheckObj.returnedDate)))
                                                         ? this.convertMilitaryDate(cmp, readCheckObj.returnedDate, 'dt') : '', 1, ''));
                			rowColumnData.push(this.setRowColumnData('outputText', ((!$A.util.isUndefinedOrNull(readCheckObj.remailedDate)) && (!$A.util.isEmpty(readCheckObj.remailedDate)))
                                                         ? this.convertMilitaryDate(cmp, readCheckObj.remailedDate, 'dt') : '', 1, ''));
                        }else{
                        	rowColumnData.push(this.setRowColumnData('outputText', '', 1, ''));
                        	rowColumnData.push(this.setRowColumnData('outputText', '', 1, ''));
                        	rowColumnData.push(this.setRowColumnData('outputText', '', 1, ''));
                        }
                        rowColumnData.push(this.setRowColumnData('outputText', '', 1, ''));
                        rowColumnData.push(this.setRowColumnData('outputText', '', 1, ''));

                } else if(sourceCode =='CO'){

                    	rowColumnData.push(this.setRowColumnData('outputText', '', 1, ''));
                    	rowColumnData.push(this.setRowColumnData('outputText', '', 1, ''));
                    	rowColumnData.push(this.setRowColumnData('outputText', '', 1, ''));
                    if(readCheckObj.status == 'Check Cashed'){
                    	rowColumnData.push(this.setRowColumnData('outputText', ((!$A.util.isUndefinedOrNull(readCheckObj.cashedDate)) && (!$A.util.isEmpty(readCheckObj.cashedDate)))
                                                         ? this.convertMilitaryDate(cmp, readCheckObj.cashedDate, 'dt') : '', 1, ''));
                    } if(readCheckObj.status == 'Check Outstanding' || readCheckObj.status == 'Voided'){
                    	rowColumnData.push(this.setRowColumnData('outputText', '', 1, ''));
                    }
                        rowColumnData.push(this.setRowColumnData('outputText', '', 1, ''));
                        rowColumnData.push(this.setRowColumnData('outputText', '', 1, ''));
                        rowColumnData.push(this.setRowColumnData('outputText', '', 1, ''));
                        rowColumnData.push(this.setRowColumnData('outputText', '', 1, ''));
                        rowColumnData.push(this.setRowColumnData('outputText', '', 1, ''));


                }
            }
            }else{
                if(readCheckObj.platform == 'UNET'){

                	rowColumnData.push(this.setRowColumnData('outputText', payeeName, 1, ''));
                		rowColumnData.push(this.setRowColumnData('outputText', payeeType, 1, ''));
                		rowColumnData.push(this.setRowColumnData('outputText', payeeAdderss, 1, ''));
                    	if(readCheckObj.status == 'Check Cashed' ){
                		rowColumnData.push(this.setRowColumnData('outputText', ((!$A.util.isUndefinedOrNull(readCheckObj.cashedDate)) && (!$A.util.isEmpty(readCheckObj.cashedDate)))
                                                         ? this.convertMilitaryDate(cmp, readCheckObj.cashedDate, 'dt') : '', 1, ''));
                        }if(readCheckObj.status == 'Check Outstanding' || readCheckObj.status == 'Voided'){
                        	rowColumnData.push(this.setRowColumnData('outputText', '', 1, ''));
                        }if(readCheckObj.status == 'Voided'){
                        	rowColumnData.push(this.setRowColumnData('outputText', ((!$A.util.isUndefinedOrNull(readCheckObj.voidDate)) && (!$A.util.isEmpty(readCheckObj.voidDate)))
                                                         ? this.convertMilitaryDate(cmp, readCheckObj.voidDate, 'dt') : '', 1, ''));
                			rowColumnData.push(this.setRowColumnData('outputText', ((!$A.util.isUndefinedOrNull(readCheckObj.returnedDate)) && (!$A.util.isEmpty(readCheckObj.returnedDate)))
                                                         ? this.convertMilitaryDate(cmp, readCheckObj.returnedDate, 'dt') : '', 1, ''));
                			rowColumnData.push(this.setRowColumnData('outputText', ((!$A.util.isUndefinedOrNull(readCheckObj.remailedDate)) && (!$A.util.isEmpty(readCheckObj.remailedDate)))
                                                         ? this.convertMilitaryDate(cmp, readCheckObj.remailedDate, 'dt') : '', 1, ''));
                        }else{
                        	rowColumnData.push(this.setRowColumnData('outputText', '', 1, ''));
                        	rowColumnData.push(this.setRowColumnData('outputText', '', 1, ''));
                        	rowColumnData.push(this.setRowColumnData('outputText', '', 1, ''));
                        }
                        rowColumnData.push(this.setRowColumnData('outputText', '', 1, ''));
                        rowColumnData.push(this.setRowColumnData('outputText', '', 1, ''));
                } else if(readCheckObj.platform == 'COSMOS') {
                	rowColumnData.push(this.setRowColumnData('outputText', '', 1, ''));
                    	rowColumnData.push(this.setRowColumnData('outputText', '', 1, ''));
                    	rowColumnData.push(this.setRowColumnData('outputText', '', 1, ''));
                    if(readCheckObj.status == 'Check Cashed'){
                    	rowColumnData.push(this.setRowColumnData('outputText', ((!$A.util.isUndefinedOrNull(readCheckObj.cashedDate)) && (!$A.util.isEmpty(readCheckObj.cashedDate)))
                                                         ? this.convertMilitaryDate(cmp, readCheckObj.cashedDate, 'dt') : '', 1, ''));
                    } if(readCheckObj.status == 'Check Outstanding' || readCheckObj.status == 'Voided'){
                    	rowColumnData.push(this.setRowColumnData('outputText', '', 1, ''));
                    }
                        rowColumnData.push(this.setRowColumnData('outputText', '', 1, ''));
                        rowColumnData.push(this.setRowColumnData('outputText', '', 1, ''));
                        rowColumnData.push(this.setRowColumnData('outputText', '', 1, ''));
                        rowColumnData.push(this.setRowColumnData('outputText', '', 1, ''));
                        rowColumnData.push(this.setRowColumnData('outputText', '', 1, ''));
                }
            }
        } else {
            var rowColumnData = [{
                "isNoRecords": true,
                "fieldLabel": "No Records",
                "fieldValue": "No Matching Payment Results Found",
                "key": 0
            }];
            hasCaseItems = false;
        }
         var  row = {
            "checked": false,
            "uniqueKey": "0",
            "rowColumnData": rowColumnData,
            "additionalData": payeeData
        };
        row.isResolvedDisabled =!hasCaseItems;
        row.checked = !hasCaseItems;
        row.resolved = !hasCaseItems;
        row.uniqueKey = (isreadCheck ? 1 : 0);
        if(hasCaseItems)
        row.caseItemsExtId=cmp.get('v.checkNumber'); // US3632386 Swapnil
        else{
        row.caseItemsExtId='No Matching Payment Results Found';
           var selectedRows = [];
            selectedRows.push(row);
        tableDetails.selectedRows =selectedRows;
        }
        tableDetails.tableBody.push(row);
        for(var i in tableDetails.tableBody){
            if(tableDetails.tableBody[i].rowColumnData.length > 1){
                tableDetails.tableBody[i].rowColumnData.find( r=> r.fieldType == 'Currency').isOutputText = false;
                tableDetails.tableBody[i].rowColumnData.find( r=> r.fieldType == 'Currency').isCurrencyOutputText = true;
            }
        }
        cmp.set("v.tableDetails", tableDetails);
        cmp.set('v.hasCaseItems', true);
       _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"), cmp.get("v.autodocUniqueIdCmp"),  tableDetails);
       },

    setRowColumnData: function (ft, fv, uk, hover) {
        var rowColumnData = new Object();
        rowColumnData.fieldType = ft;
        rowColumnData.key = uk;
        if (!$A.util.isUndefinedOrNull(fv) && !$A.util.isEmpty(fv) && fv.length > 0) {
            if (fv.length > 20) {
                rowColumnData.fieldValue = fv.substring(0, 20) + '...';
                rowColumnData.titleName = (hover != '' ? hover : fv);
            } else {
                rowColumnData.fieldValue = fv;
                rowColumnData.titleName = (hover != '' ? hover : '');
            }
        } else {
            rowColumnData.fieldValue = '--';
            rowColumnData.titleName = '';
        }
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
    },

    convertMilitaryDate: function (cmp, dateParam, type) {
        let format = "";
        if (type == 'dt') {
            format = 'MM/dd/yyyy';
        } else if (type == 'dttm') {
            format = 'MM/dd/yyyy hh:mm:ss a';
        }
        let returnDate = '';
        if (!$A.util.isUndefinedOrNull(dateParam)) {
            try {
                if (type == 'dt') {
                    var dttm = dateParam;
                    if (!$A.util.isUndefinedOrNull(dateParam.split('-')[3])) {
                        var arr = dateParam.split('-');
                        dttm = arr[0] + '-' + arr[1] + '-' + arr[2];
                    }
                    returnDate = $A.localizationService.formatDateUTC(dttm, format);
                } else if (type == 'dttm') {
                    var arr = dateParam.split('-');
                    var dttm = arr[0] + '-' + arr[1] + '-' + arr[2];
                    returnDate = $A.localizationService.formatDateTimeUTC(dttm, format);
                }
            } catch (error) { }
        }
        return returnDate;
    },

    // US3597656
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

    //US3691404: View Payments Topic - Enable/Disable Auto Doc, Add Comments & Route Buttons - Swapnil
    setDefaultAutodoc: function(cmp){
        if( !$A.util.isUndefinedOrNull(cmp.get('v.memberautodocUniqueId')) ){
            var defaultAutoDocPolicy = _autodoc.getAutodocComponent(cmp.get("v.memberautodocUniqueId"),cmp.get("v.policySelectedIndex"),'Policies');
            var defaultAutoDocMember = _autodoc.getAutodocComponent(cmp.get("v.memberautodocUniqueId"),cmp.get("v.policySelectedIndex"),'Member Details');
            var memberAutodoc = new Object();
            memberAutodoc.type = 'card';
            memberAutodoc.componentName = "Member Details";
            memberAutodoc.autodocHeaderName = "Member Details";
            memberAutodoc.noOfColumns = "slds-size_6-of-12";
            memberAutodoc.componentOrder = 0.5;
            var cardData = [];
            if(!$A.util.isUndefinedOrNull(defaultAutoDocMember)){ // US3476452 - adding null check
            cardData = defaultAutoDocMember.cardData.filter(function(el){
                if(!$A.util.isEmpty(el.defaultChecked) && el.defaultChecked) {
                    return el;
                }
            });
            }

            memberAutodoc.cardData = cardData;
            memberAutodoc.ignoreAutodocWarningMsg = true;
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
            policyAutodoc.ignoreAutodocWarningMsg = true;
            _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"), cmp.get("v.autodocUniqueIdCmp"), policyAutodoc);
            _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"), cmp.get("v.autodocUniqueIdCmp"), memberAutodoc);

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
                defaultAutoDocProvider.componentOrder = 0.25;
                defaultAutoDocProvider.ignoreClearAutodoc = false;
                _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"), cmp.get("v.autodocUniqueIdCmp"), defaultAutoDocProvider);
            }
        }
    },

    // DE482674 - Thanish - 1st Sep 2021
    deleteDefaultAutodoc: function(cmp){
        _autodoc.deleteAutodocComponent(cmp.get("v.autodocUniqueId"), cmp.get("v.autodocUniqueIdCmp"), "Policies");
        _autodoc.deleteAutodocComponent(cmp.get("v.autodocUniqueId"), cmp.get("v.autodocUniqueIdCmp"), "Member Details");

        var interactionCard = cmp.get("v.interactionCard");
        var providerFullName = '';
        var providerComponentName = '';
        if(!$A.util.isUndefinedOrNull(interactionCard) && !$A.util.isEmpty(interactionCard)){
            providerFullName = interactionCard.firstName + ' ' + interactionCard.lastName;
            providerComponentName = 'Provider: '+ ($A.util.isEmpty(providerFullName) ? "" : providerFullName);
        }
        _autodoc.deleteAutodocComponent(cmp.get("v.autodocUniqueId"), cmp.get("v.autodocUniqueIdCmp"), providerComponentName);
    },

    //US3691404: View Payments Topic - Enable/Disable Auto Doc, Add Comments & Route Buttons - Swapnil
    checkUnresolved: function(cmp, event, helper) {
        var data = event.getParam("selectedRows");
        var tableDetails = cmp.get("v.tableDetails");
        if ($A.util.isEmpty(data)) {
            tableDetails.hasUnresolved = false;
            cmp.set("v.tableDetails", tableDetails);
        }
        var hasUnresolved = ( !$A.util.isEmpty(tableDetails) && !$A.util.isUndefinedOrNull(tableDetails.selectedRows[0]) ) ? !(tableDetails.selectedRows[0].resolved) : false;

        cmp.set("v.disableButtons", !hasUnresolved);
        if (cmp.get("v.disableButtons")) {
            cmp.set("v.showComments", false);
            cmp.set("v.commentsValue", "");
        }
    }

})