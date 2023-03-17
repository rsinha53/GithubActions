({
    // US3304569 - Thanish - 17th Mar 2021
    benefitAccErrorMessage: "Unexpected Error Occurred in the Benefit Accumulations Card. Please try again. If problem persists please contact the help desk",

    /** getBenefitRecords: function (cmp, event, helper) {
        var action = cmp.get("c.getBenefitInfo");
        action.setParams({
            "transactionId": cmp.get("v.transactionId")
        });  
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set("v.benefitRecords", response.getReturnValue());
                cmp.set("v.benefitRecordsFiltered", response.getReturnValue());
                cmp.set("v.benefitRecordsSelected", []);
                cmp.set("v.benefitRecordsAccordian", []);
            }
        });
        $A.enqueueAction(action);
    },*/
    searchHelper: function (cmp, event, getInputkeyWord) {
        // call the apex class method 
        var action = cmp.get("c.fetchBenefitCodes");
        // set param to method  
        //console.log('Page Names :: ' + cmp.get("v.detailPgName"));

        action.setParams({
            'searchKeyWord': getInputkeyWord,
            'ObjectName': 'Benefit_Configuration__c',
            'ExcludeitemsList': cmp.get("v.lstSelectedRecords")

        });
        // set a callBack    
        action.setCallback(this, function (response) {
            // $A.util.removeClass(component.find("mySpinner"), "slds-show");
            var state = response.getState();
            console.log("-------" + state);
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                // if storeResponse size is equal 0 ,display No Records Found... message on screen.                }
                if (storeResponse.length == 0) {
                    cmp.set("v.Message", 'No Records Found...');
                } else {
                    cmp.set("v.Message", '');
                    // set searchResult list with return value from server.
                }
                cmp.set("v.listOfSearchRecords", storeResponse);
            }
        });
        // enqueue the Action  
        $A.enqueueAction(action);
    },

    getTherapyData: function (cmp, event, helper) {
        let policySelectedIndex = cmp.get('v.policySelectedIndex');
        let policyId = '';
        let patientKey = '';
        let memberCardData = cmp.get('v.memberCardData');
        if (!$A.util.isUndefinedOrNull(memberCardData.CoverageLines[policySelectedIndex])) {
            if (!$A.util.isUndefinedOrNull(memberCardData.CoverageLines[policySelectedIndex].patientInfo)) {
                patientKey = memberCardData.CoverageLines[policySelectedIndex].patientInfo.patientKey;
            }
        }
        if (!$A.util.isUndefinedOrNull(memberCardData.CoverageLines[policySelectedIndex].policyId)) {
            policyId = memberCardData.CoverageLines[policySelectedIndex].policyId;
        }
        var action = cmp.get("c.getTherapyAccumulations");
        action.setParams({
            'patienKey': patientKey,
            'policyId': policyId
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var therapyTable = response.getReturnValue().response;
                if (response.getReturnValue().isSuccess) {
                    cmp.set("v.accuData", therapyTable);
                    cmp.set("v.isShowBenefitAccordian", true);
                } else {
                    // US3304569 - Thanish - 17th Mar 2021
                    this.fireToastMessage("We hit a snag.", this.benefitAccErrorMessage, "error", "dismissible", "30000");
                    cmp.set("v.icon", "utility:chevronright");
                    cmp.set("v.toggleName", "slds-hide");
                }
            } else {
                // US3304569 - Thanish - 17th Mar 2021
                this.fireToastMessage("We hit a snag.", this.benefitAccErrorMessage, "error", "dismissible", "30000");
                cmp.set("v.icon", "utility:chevronright");
                cmp.set("v.toggleName", "slds-hide");
            }
        });
        $A.enqueueAction(action);
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
    getNonTherapyData: function(cmp, event, helper){
    // US3308339: E&I Plan Benefits - Non Therapy Benefit Accumulations Integration (with Auto Doc) - Krishna
    $A.util.addClass(cmp.find("nonTherapySpinnerAI"), "slds-show");
    var policyDetails = cmp.get('v.policyDetails');
        var action = cmp.get("c.getNonTherapy");
        var nonTherapyRequestParam ={
            'policyNumber': '',
            'subscriberId': '',
            'dependentNumber': '',
            'planYearStartDate': '',
        };
        var sourceCode = '';
        var dependentCode = cmp.get('v.dependentCode');
        // DE448573: Non-Therapy Accumulation issue Mapping enhancement from Extended Coverage to Eligbility Service - Krish - 26th May 2021
        let memberCardData = cmp.get('v.memberCardData');
        let policySelectedIndex = cmp.get('v.policySelectedIndex');
        var planYearStartDate = '';
        if (!$A.util.isEmpty(memberCardData) && !$A.util.isEmpty(memberCardData.CoverageLines[policySelectedIndex]) && !$A.util.isEmpty(memberCardData.CoverageLines[policySelectedIndex].EffectiveDate)) {
            planYearStartDate = $A.localizationService.formatDate(memberCardData.CoverageLines[policySelectedIndex].EffectiveDate, "YYYY-MM-DD");
        }else{
            if(!$A.util.isEmpty(policyDetails.resultWrapper) && !$A.util.isEmpty(policyDetails.resultWrapper.policyRes) && !$A.util.isEmpty(policyDetails.resultWrapper.policyRes.coverageStartDate)){
                planYearStartDate = policyDetails.resultWrapper.policyRes.coverageStartDate;
            }
        }
        if($A.util.isEmpty(dependentCode)){
            dependentCode = !$A.util.isEmpty(policyDetails.resultWrapper.policyRes.dependentSequenceNumber) ? policyDetails.resultWrapper.policyRes.dependentSequenceNumber : '';
        }
        if(!$A.util.isEmpty(policyDetails) && !$A.util.isEmpty(policyDetails.resultWrapper) && !$A.util.isEmpty(policyDetails.resultWrapper.policyRes)){
            nonTherapyRequestParam = {
                'policyNumber': !$A.util.isEmpty(policyDetails.resultWrapper.policyRes.policyNumber) ? policyDetails.resultWrapper.policyRes.policyNumber : '',
                'subscriberId': !$A.util.isEmpty(policyDetails.resultWrapper.policyRes.subscriberID) ? policyDetails.resultWrapper.policyRes.subscriberID : '',
                'dependentNumber': dependentCode,
                'planYearStartDate': planYearStartDate // DE448573: Non-Therapy Accumulation issue Mapping enhancement from Extended Coverage to Eligbility Service - Krish - 26th May 2021
            };
            sourceCode = !$A.util.isEmpty(policyDetails.resultWrapper.policyRes.sourceCode) ? policyDetails.resultWrapper.policyRes.sourceCode : '';
        }
        action.setParams({
            'nonTherapyRequestParam': nonTherapyRequestParam,
            'sourceCode' : sourceCode
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                // US3304569 - Thanish - 17th Mar 2021
                var result = response.getReturnValue();
                if(result.statusCode!=200){
                    this.fireToastMessage("We hit a snag.", this.benefitAccErrorMessage, "error", "dismissible", "30000");
                }
                var nonTherapyTable = result.response;
                nonTherapyTable.hideResolveColumn = true; // DE427123
                cmp.set("v.nonTherapyData", nonTherapyTable);
                var getRowNonTherapyData = cmp.get("v.nonTherapyData");
                console.log('getRowNonTherapyData-->'+getRowNonTherapyData);
                var getRowNonTherapyTableData = getRowNonTherapyData.tableBody;
                console.log('getRowNonTherapyTableData-->'+JSON.stringify(getRowNonTherapyTableData));
                var codeValue = '';
                var descriptionValue= '';
                for(var row in getRowNonTherapyTableData){
                    if(getRowNonTherapyTableData[row].rowColumnData.find( r=> r.fieldLabel == 'Code/Description')){
                    var nonTherapyCode = getRowNonTherapyTableData[row].rowColumnData.find( r=> r.fieldLabel == 'Code/Description').fieldValue;
                    var array = [];
                    array = nonTherapyCode.split('/');
                    if($A.util.isEmpty(array[0]) || $A.util.isUndefinedOrNull(array[0]))
                        codeValue ='--';
                    else
                        codeValue = array[0];
                    if($A.util.isEmpty(array[1]) || $A.util.isUndefinedOrNull(array[1]))
                        descriptionValue = '--';
                    else
                        descriptionValue = array[1];
                    getRowNonTherapyTableData[row].rowColumnData.find( r=> r.fieldLabel == 'Code/Description').fieldValue = codeValue+'/'+descriptionValue;

                    }
              	}

            }else{
                this.fireToastMessage("Error!", 'Server side error!', "error", "dismissible", "5000");
                var nonTherapyTable = new Object();
                nonTherapyTable.type = 'table';
                nonTherapyTable.showComponentName = false;
                nonTherapyTable.componentOrder = 1;
                nonTherapyTable.caseItemsEnabled = true;
                nonTherapyTable.componentName = '';
                nonTherapyTable.autodocHeaderName = 'Non-Therapy';
                nonTherapyTable.hideResolveColumn = true; // DE427123
                nonTherapyTable.tableHeaders = ['Coverage Level','Description','Benefit Period','Type','Used $','Used Count'];
                nonTherapyTable.tableBody = [];
                var row = {
                    "checked" : false,
                    "uniqueKey" : 0,
                    "caseItemsExtId" : "No Records Found",
                    "rowColumnData" : [
                        {
                            "isNoRecords" : true,
                            "fieldLabel" : "No Records",
                            "fieldValue" : "No Records Found",
                            "key" : 0
                        }
                    ]
                }
                nonTherapyTable.tableBody.push(row);
                cmp.set("v.nonTherapyData", nonTherapyTable);
                // US3304569 - Thanish - 17th Mar 2021
                this.fireToastMessage("We hit a snag.", this.benefitAccErrorMessage, "error", "dismissible", "30000");
            }
        });
        $A.enqueueAction(action);
        $A.util.addClass(cmp.find("nonTherapySpinnerAI"), "slds-hide");
    }
})