({
    getProviderData: function (component, event, helper, offset) {
        var action = component.get("c.getAddressData");
        action.setParams({
            providerId: component.get("v.providerId"),
            taxId: component.get("v.taxId"),
            start: 0,
            endCount: 50,
            filtered : component.get("v.isCombo"),
            onlyActive : component.get("v.isActive")
        });

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = JSON.parse(response.getReturnValue().service);
                // console.log('SUCCESS## ' + result);
                component.set("v.webservicecalled",true);
                helper.processTable(component, event, helper, result);
            } else {
                console.log('FAIL## ' + JSON.stringify(response.getReturnValue()));
            }
        });

        $A.enqueueAction(action);
    },

    processTable: function (component, event, helper, result) {
        var lgt_dt_DT_Object = new Object();
        lgt_dt_DT_Object.lgt_dt_PageSize = JSON.parse(result).PageSize;
        lgt_dt_DT_Object.lgt_dt_SortBy = -1;
        lgt_dt_DT_Object.lgt_dt_SortDir = '';
        lgt_dt_DT_Object.lgt_dt_serviceObj = result;
        lgt_dt_DT_Object.lgt_dt_lock_headers = "300";
        lgt_dt_DT_Object.lgt_dt_StartRecord = 0;
        lgt_dt_DT_Object.lgt_dt_PageNumber = 1;
        lgt_dt_DT_Object.lgt_dt_serviceName = 'SAE_AdditionalAddressService';
        lgt_dt_DT_Object.lgt_dt_columns = JSON.parse('[{"title":"ADDRESS TYPE","defaultContent":"","data":"AddressType"},{"title":"ACTIVE","defaultContent":"","data":"ActiveClass"},{"title":"ADDRESS","defaultContent":"","data":"Address"},{"title":"COUNTY","defaultContent":"","data":"Country"},{"title":"PHONE","defaultContent":"","data":"PhoneNumber"},{"title":"FAX","defaultContent":"","data":"FAXNumber"},{"title":"EMAIL","defaultContent":"","data":"Email"}]');

        component.set("v.lgt_dt_DT_Object", JSON.stringify(lgt_dt_DT_Object));
        var lgt_dt_Cmp = component.find("ProviderDetailResultsAddressSectionTable_auraid");
        lgt_dt_Cmp.tableinit();
    }
})