({
    getContractExceptions: function (cmp, event, helper) {
        let parameters = cmp.get("v.contractApiParameters");
        var contractId = cmp.get("v.contractId");
        if(!$A.util.isEmpty(parameters.providerId) && !$A.util.isEmpty(parameters.taxId) && !$A.util.isEmpty(contractId)){
            var action =  cmp.get("c.getContractExceptions");
            action.setParams({
                "providerId": parameters.providerId,
                "taxId": parameters.taxId,
                "contractId": contractId,
            });
            action.setCallback(this, function (response) {
                var data = response.getReturnValue();
                console.log('data@@-->',JSON.stringify(data));
                if (response.getState() === "SUCCESS") {
                    if(data.statusCode === 200 && data.success == true){
                        var indicator = data.medicalNecessityIndicator;
                        if(indicator == 'Y'){
                            helper.populateCEField(cmp, event, data.medicalNecessityIndicator, "hoverText");
                        }else{
                            helper.populateCEField(cmp, event, data.medicalNecessityIndicator, "outputText");
                        }
                    } else {
                        this.showToastMessage("We hit a snag.", data.message, "error", "dismissible", "30000");
                        helper.populateCEField(cmp, event, 'N', "outputText");
                    }
                } else {
                    this.showToastMessage("We hit a snag.", data.message, "error", "dismissible", "30000");
                    helper.populateCEField(cmp, event, 'N', "outputText");
                }
            });
            $A.enqueueAction(action);
        }else{
            helper.populateCEField(cmp, event, 'N', "outputText");
        }
    },
    // populate Contract Exceptions field
    populateCEField: function (cmp, event, ceValue, fieldType) {
        var contractDetail = cmp.get("v.data");
        var popId = Date.now();
        contractDetail.contractDetails.cardData.push({
            checked : false,
            defaultChecked : false,
            description : "Able to submit notes for no auth denials.",
            fieldName : "Contract Exceptions",
            fieldType : fieldType,
            fieldValue : ceValue,
            isNubbinLeft : true,
            isReportable : true,
            popupId : popId,
            popupWidth : "210px",
            showCheckbox : true,
        });
        cmp.set("v.data",contractDetail);
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
    }
})