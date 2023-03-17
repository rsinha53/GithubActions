({
	openPayTable : function(cmp, event, helper) {
		// US3678785
        helper.searchPaymentResults(cmp, event, helper);
    },
    doInit: function(component, event, helper) {
        helper.showSpinner(component, event, helper);
        helper.getpaymentDetails(component, event, helper);



    },
    getPaymentImage: function(component, event, helper) {
        var selectedpaymentDetailCard = component.get('v.selectedpaymentDetailCard');
        var relatedDocData = component.get('v.relatedDocData');
        if(selectedpaymentDetailCard.cardData[1].fieldValue == 'VCP'){
            if(relatedDocData.platform == 'UNET'){
              helper.getPaymentImage(component, event, helper,'u_unet_gflx_eob');
            }else if(relatedDocData.platform == 'COSMOS'){
                helper.getPaymentImage(component, event, helper,'u_cosmos_pra');
                helper.getPaymentImage(component, event, helper,'u_cosmos_pra_ub');
            }
        }else{
            helper.getPaymentImage(component, event, helper,'');
        }
    },
    selectAll : function (component, event, helper){
        component.find("paymentDtloAutoCard").selectAllByDefault();
	}

})