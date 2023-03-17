({
    // 20th Aug 2019 US1958806 ViewPayment UI - Payment Details Coming from topic : Sarma
    searchButtonClick: function(component, event, helper) {
        component.set("v.isShowCheckPaymentDetails", true);
    },

    onChangePaymentOption: function(cmp, event, helper) {
        cmp.set("v.paymentOption", event.getParam("value"));
    }

})