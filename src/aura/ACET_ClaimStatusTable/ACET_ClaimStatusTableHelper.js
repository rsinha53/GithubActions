({
	sortPayStatusCards: function (cmp) {
        var paymentStatusList = cmp.get("v.paymentStatusList");
        var order = 1;
        for (var i = paymentStatusList.length; i > 0; i--) {
            paymentStatusList[(i - 1)].set('v.cardOrder', order);
            ++order;
        }
        cmp.set("v.paymentStatusList", paymentStatusList);
    },
    //US3120337 - Chandra Start
    navigateToCallTopic : function(component, event, helper) {

        setTimeout(function() {
            //var callTopicName = component.get("v.callTopicName");
            //var callTopicName = event.getParam('selectedCallTopic');
            var params = event.getParam('topicname');
            var callTopicName;
            if (params) {
                var callTopicName = params.selectedCallTopic;
            }
            if (!$A.util.isUndefinedOrNull(params) && params == "referrals") {
                component.find("viewReferralsDetails").getElement().scrollIntoView({
                    behavior: 'smooth',
                    block: 'center',
                    inline: 'nearest'
                });

            } else if (!$A.util.isUndefinedOrNull(params) && params == "authorizations") {
                component.find("AuthorizationDetails").getElement().scrollIntoView({
                    behavior: 'smooth',
                    block: 'center',
                    inline: 'nearest'
                });
                console.log("selectedPolicy in CallTopic"+component.get("v.selectedPolicy"));
                console.log("memberPolicies in CallTopic"+component.get("v.memberPolicies"));

            } else if (!$A.util.isUndefinedOrNull(callTopicName) && callTopicName == "View PCP Referrals") {
                component.find("ViewPCPReferralsMbSnapshot").getElement().scrollIntoView({
                    behavior: 'smooth',
                    block: 'center',
                    inline: 'nearest'
                });
            }
            component.set("v.callTopicName","");
        }, 100);
    },
    getPaymentNumber : function(component, event, helper){
        var selectedClaimStatusTable = component.get("v.selectedClaimStatusTable");
        if(!$A.util.isUndefinedOrNull(selectedClaimStatusTable) && !$A.util.isEmpty(selectedClaimStatusTable)){
            var tableBody = [];
            tableBody = selectedClaimStatusTable.tableBody;
            console.log('Table Data'+ JSON.stringify(tableBody));
            if(!$A.util.isUndefinedOrNull(tableBody) && !$A.util.isEmpty(tableBody)){
                var rowData = tableBody[0].rowColumnData;
                console.log('Table Row Data'+ JSON.stringify(rowData));
                if(!$A.util.isUndefinedOrNull(rowData) && !$A.util.isEmpty(rowData)){
                    var paymentNumber = rowData[13].fieldValue;
                    console.log('Payment Number'+ paymentNumber);
                    var paidAmount = rowData[10].fieldValue;
                    if(!$A.util.isUndefinedOrNull(paidAmount) && !$A.util.isEmpty(paidAmount) && paidAmount != '$0.00'){
                        if($A.util.isUndefinedOrNull(paymentNumber) || $A.util.isEmpty(paymentNumber) || paymentNumber == '--'){
                            //Call Payment Details
                            var claimInput = component.get("v.claimInput");
                            var transactionId = component.get("v.transactionId");
                            var action = component.get('c.getPaymentNumber');
                            action.setParams({
                                "taxId" : claimInput.taxId,
                                "payerId" : claimInput.payerId,
                                "transactionId" :transactionId
                            });
                            action.setCallback(this, function(response) {
                                var state = response.getState();
                                if (state == "SUCCESS"){
                                    console.log('Get Payment Number'+ response.getReturnValue());
                                    var paymentNum = response.getReturnValue();
                                    var row = [];
                                    for(var key in rowData){
                                        if(rowData[key].fieldLabel == 'PAYMENT #'){
                                            rowData[key].fieldValue = $A.util.isEmpty(paymentNum) ? '--' : paymentNum;
                                            rowData[key].fieldType = $A.util.isEmpty(paymentNum) ? 'outputText' : 'Link';
                                            rowData[key].isLink = $A.util.isEmpty(paymentNum) ? false : true;
                                            rowData[key].isOutputText = $A.util.isEmpty(paymentNum) ? true : false;


                                        }
                                        row.push(rowData[key]);
                                    }
                                    console.log('Update Row Data'+ JSON.stringify(row));
                                    var tableRow = [];
                                    tableBody[0].rowColumnData = row;
                                    tableRow.push(tableBody[0]);
                                    console.log('Update Table Data'+ JSON.stringify(tableRow));
                                    selectedClaimStatusTable.tableBody = tableRow;
                                    component.set("v.selectedClaimStatusTable",selectedClaimStatusTable);
                                    component.set("v.claimStatusList",selectedClaimStatusTable);
                                    var claimStatusList = component.get("v.claimStatusList");
                                    let PaymentNumber = claimStatusList.tableBody[0].rowColumnData[13].fieldValue;
                                    component.set("v.PaymentNumber",PaymentNumber);

                                }
                            });
                            $A.enqueueAction(action);
                        }
                        else{
                            var  claimStatusList = component.get("v.selectedClaimStatusTable");
                            component.set("v.claimStatusList",claimStatusList);
                            var claimStatusList = component.get("v.claimStatusList");
                            let PaymentNumber = claimStatusList.tableBody[0].rowColumnData[13].fieldValue;
                            component.set("v.PaymentNumber",PaymentNumber);

                        }
                    }
                    else{
                        var row = [];
                        for(var key in rowData){
                            if(rowData[key].fieldLabel == 'PAYMENT #'){
                                rowData[key].fieldValue = '--';
                                rowData[key].fieldType = 'outputText';
                                rowData[key].isLink = false;
                               rowData[key].isOutputText = true;
                            }
                            row.push(rowData[key]);
                        }
                        console.log('Update Row Data'+ JSON.stringify(row));
                        var tableRow = [];
                        tableBody[0].rowColumnData = row;
                        tableRow.push(tableBody[0]);
                        console.log('Update Table Data'+ JSON.stringify(tableRow));
                        selectedClaimStatusTable.tableBody = tableRow;
                        component.set("v.selectedClaimStatusTable",selectedClaimStatusTable);
                        component.set("v.claimStatusList",selectedClaimStatusTable);
                        var claimStatusList = component.get("v.claimStatusList");
                        let PaymentNumber = claimStatusList.tableBody[0].rowColumnData[13].fieldValue;
                        component.set("v.PaymentNumber",PaymentNumber);

                    }
                }
            }
        }
    }
    //US3120337 - Chandra End
})