({

    // US2894783
    afterRender: function (cmp, helper) {
        this.superAfterRender();
        // US3507490	Mapping for Contract Org Type and Amendment Sarma - 19th May 2021
        let srnProviderDetailObject = cmp.get('v.srnProviderDetailObject');
        if(srnProviderDetailObject.isMainCard && srnProviderDetailObject.isShowProviderDetails){
            helper.getAdditionalProviderDetails(cmp,  helper);
        }
    }

})