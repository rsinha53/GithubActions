({

    // US2894783
    afterRender: function (cmp, helper) {
        this.superAfterRender();
        helper.createAdditionalDiagnosisCodes(cmp, null);
        helper.createAdditionalProcedureCodes(cmp, null);
        var type = cmp.get('v.type');
        // if (type == 'Outpatient' || type == 'Outpatient Facility') {
        //     helper.createAdditionalModifierCodes(cmp, null);
        // }
    },

})