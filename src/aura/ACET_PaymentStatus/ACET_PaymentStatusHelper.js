({
    paymentSearchErrorMsg: "Unexpected Error Occurred in the Payment Status Card. Please try again. If problem persists please contact help desk. ",

    getpaymentDetails : function (component, event, helper){
        console.log('transactionId@@@' + component.get('v.transactionId'));
        var transactionId = component.get('v.transactionId');
        var claimInput = component.get('v.claimInput');
        var action ;
        //component.set("v.paymentNo",'TR37241627');
        var paymentNo = component.get('v.paymentNo');
        console.log('paymentNo@@@' + paymentNo);
        console.log('claimInput@@@' + JSON.stringify(claimInput));
        console.log('payerId@@@' + claimInput.payerId);
        var isClaim=component.get('v.isClaim');
        if(isClaim ){
         action = component.get('c.getPaymentDetailsForPTI');
            var PaymentInput={};
            var pDetails=component.get('v.selectedClaimDetailCard');
            var providerId= pDetails.cardData.find(x => x.fieldName === 'Adjudicated Provider ID').fieldValue;
            var adTaxId=pDetails.cardData.find(x => x.fieldName === 'AdjTaxID').fieldValue;
            PaymentInput.taxid=claimInput.taxId;
            PaymentInput.providerId=providerId;
            PaymentInput.sourceCode=component.get('v.policyDetails').resultWrapper.policyRes.sourceCode;
            PaymentInput.transactionId=transactionId;
            PaymentInput.PaymentNo=paymentNo;
            PaymentInput.isClaim=isClaim;
            PaymentInput.adTaxId=adTaxId;
            PaymentInput.payerId=claimInput.payerId;
        action.setParams({
          input:PaymentInput,
        });
        }else{
          action = component.get('c.getPaymentDetails');
        action.setParams({
            "taxid": claimInput.taxId,
            "payerId": claimInput.payerId,
            "transactionId": transactionId,
            "PaymentNo": paymentNo
        });
        }
        action.setCallback(this, function(response) {
             var state = response.getState();
            console.log('state@@@' + state);
            if (state == "SUCCESS") {
                var data = response.getReturnValue();
                if(data != null && data.isSuccess){ // added sravani for Error code handling
                    console.log('test 16**'+JSON.stringify(data));
                    // US3653575
                    if(!$A.util.isEmpty(data.paymentDetailInfo)){
                        data.paymentDetailInfo.caseItemsExtId = claimInput.claimNumber;
                    }
                    component.set("v.selectedpaymentDetailCard",data.paymentDetailInfo);
					component.set("v.paymentDetails",data.paymentDetails);
                    // US3449703
                    this.callBulkRecovery(component, data.paymentDetails, data.taxId);
                    //KJ multiple tabs autodoc component order begin
        			var selectedpaymentDetailCard = component.get('v.selectedpaymentDetailCard');
        			var currentIndexOfOpenedTabs = component.get("v.currentIndexOfOpenedTabs");
        			selectedpaymentDetailCard.componentOrder = selectedpaymentDetailCard.componentOrder + (20*currentIndexOfOpenedTabs);
            		component.set("v.selectedpaymentDetailCard",selectedpaymentDetailCard);
        			//KJ multiple tabs autodoc component order end
                    console.log('test 16**'+component.get('v.selectedpaymentDetailCard'));
                }
                // added sravani for Error code handling
                else{
                     this.showToastMessage("Error!",data.errorMessage, "error", "dismissible", "10000");
                }
            }
            else if (state === "INCOMPLETE") {}
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("error :"+errors[0].message);
                        }
                    }
                }
            helper.hideSpinner(component, event, helper);
        });
        $A.enqueueAction(action);
    },
    showSpinner: function (component, event, helper) {
        var spinner = component.find("lookup-spinner");
        $A.util.removeClass(spinner, "slds-hide");
        $A.util.addClass(spinner, "slds-show");
    },

    hideSpinner: function (component, event, helper) {
        //alert('test');
        var spinner = component.find("lookup-spinner");
        $A.util.removeClass(spinner, "slds-show");
        $A.util.addClass(spinner, "slds-hide");
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


    getPaymentImage : function (component, event, helper, docClass){
        helper.showToastMessage('Warning','You are being redirected to Doc360 to view your document.','warning',"dismissible",'20000') ;
        var autoDocValue = '';
        var paymentDetails = component.get('v.paymentDetails');
        var claimInput = component.get('v.claimInput');
        var relatedDocData = component.get('v.relatedDocData');
        var selectedpaymentDetailCard = component.get('v.selectedpaymentDetailCard');
        var paymentImageImputWrapper = {};
        paymentImageImputWrapper.checkNbr = paymentDetails.checkNbr;
        paymentImageImputWrapper.chkSrsDesg = paymentDetails.chkSrsDesg;
        paymentImageImputWrapper.checkEFTIndicator = paymentDetails.checkEFTIndicator;
        paymentImageImputWrapper.checkStatus = paymentDetails.checkStatus;
        paymentImageImputWrapper.memberId = claimInput.memberId;
        paymentImageImputWrapper.tin = claimInput.taxId;
        paymentImageImputWrapper.clNum = claimInput.claimNumber;
        paymentImageImputWrapper.docClass = docClass;
        if(selectedpaymentDetailCard.cardData[1].fieldValue == 'VCP'){
            paymentImageImputWrapper.paperCheck = false;
            autoDocValue = 'VCP payment image was selected.';
        }else{
            paymentImageImputWrapper.paperCheck = true;
            autoDocValue = 'Paper check image was selected.';
        }
        console.log('paymentImageImputWrapper**'+JSON.stringify(paymentImageImputWrapper));
        var action = component.get('c.getPaymentStatusImage');
        action.setParams({
            "paymentImageImputWrapper":paymentImageImputWrapper
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state@@@' + state);
            if (state == "SUCCESS") {
                var data = response.getReturnValue();
                if(data != null){
                    setTimeout(function(){
                        component.set("v.showWarning",true);
                        window.open(data , '_blank');
                    }, 2500);
                    var autoDoc=component.get("v.autoDocLink")
                    if(autoDoc){
                        component.set("v.autoDocLink",false); 
                    var cardDetails = component.get("v.selectedpaymentDetailCard");
                    
                        cardDetails.cardData.push({
                            "checked": true,
                            "disableCheckbox": false,
                            "showCheckbox": false,
                            "fieldName": '',
                            "fieldType": "outputText",
                            "fieldValue": autoDocValue,
                            "hideField": true,
                            "isReportable": true
                        });
                    _autodoc.setAutodoc(component.get("v.autodocUniqueId"),component.get("v.autodocUniqueIdCmp"), cardDetails); 
                    }
                }
                else{
                    this.showToastMessage("We hit a snag.",data.errorMessage, "error", "dismissible", "30000");
                }
            }
            else if (state === "INCOMPLETE") {}
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("error :"+errors[0].message);
                        }
                    }
                }
        });
        $A.enqueueAction(action);
    }, 

    // US3678785
    searchPaymentResults: function (cmp, event, helper) {

        cmp.set('v.openPayDetails', false);
        var spinner = cmp.find('lookup-spinner');
        cmp.set("v.checkSearchRespObj", "");
        var paymentDetails = cmp.get('v.paymentDetails');

        //Contructing parameters
        var requestObj = cmp.get('v.requestObject');
        if ($A.util.isUndefinedOrNull(requestObj)) {
            requestObj = new Object();
        }

        var checkSearchRespObj = [];

        requestObj.seriesDesignator = (!$A.util.isUndefinedOrNull(paymentDetails.chkSrsDesg) ? paymentDetails.chkSrsDesg : '');
        requestObj.checkNumber = (!$A.util.isUndefinedOrNull(paymentDetails.checkNbr) ? paymentDetails.checkNbr : '');
        requestObj.remitNumber = '';
        requestObj.nextKey = '';

        cmp.set('v.requestObject', requestObj);

        $A.util.removeClass(spinner, 'slds-hide');
        $A.util.addClass(spinner, 'slds-show');

        var action = cmp.get("c.searchPayment");
        action.setParams({
            requestObject: requestObj
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state == 'SUCCESS') {
                var result = response.getReturnValue();

                if ((!$A.util.isUndefinedOrNull(result['checkSearchResp'])) && (result['checkSearchResp'].statusCode == 200 || result['checkSearchResp'].statusCode == 201)) {
                    checkSearchRespObj.push(result['checkSearchResp']);
                    cmp.set("v.checkSearchRespObj", checkSearchRespObj);
                    cmp.set('v.openPayDetails', true);
                } else {
                    this.fireToastMessage("We hit a snag.", this.paymentSearchErrorMsg, "error", "dismissible", "6000");
                    cmp.set('v.openPayDetails', false);
                }
            } else {
                this.fireToastMessage("We hit a snag.", this.paymentSearchErrorMsg, "error", "dismissible", "6000");
                console.log("Error :" + JSON.stringify(response.getError()));
            }
            $A.util.removeClass(spinner, 'slds-show');
            $A.util.addClass(spinner, 'slds-hide');
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

    callBulkRecovery: function(cmp, paymentdata, taxid){
        var action = cmp.get("c.getBulkRecoveryData");
        var requestObj = new Object();
        requestObj.paymentReference = paymentdata.checkNbr;
        requestObj.paymentType = paymentdata.paymentType == 'VCP' ? paymentdata.paymentType : paymentdata.checkEFTIndicator;
        requestObj.chkSerDeg = paymentdata.chkSrsDesg;
        requestObj.taxId = taxid;
        action.setParams({
            bulkRequest: requestObj
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state == 'SUCCESS') {
                var result = response.getReturnValue();
                cmp.set("v.bulkRecoveryData",result);
            } else {
                this.fireToastMessage("We hit a snag.", this.paymentSearchErrorMsg, "error", "dismissible", "6000");
            }
        });
        $A.enqueueAction(action);
    }

})