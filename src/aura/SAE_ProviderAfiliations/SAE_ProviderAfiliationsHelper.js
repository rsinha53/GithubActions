({
    getAffiliationData: function (component, event, helper) {
        var action = component.get("c.getAffliationData");
        action.setParams({
            providerId: component.get("v.providerId"),
            taxId: component.get("v.taxId"),
            start: 0,
            endCount: 50
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = JSON.parse(response.getReturnValue().service);
                helper.processTable(component, event, helper, result);
            } else {
                console.log('FAIL## ' + JSON.stringify(response.getReturnValue()));
            }
        });

        $A.enqueueAction(action);
    },

    getAffiliations: function (component, event, helper){
        this.showCaseSpinner(component);
        var action = component.get("c.getAffData");
        action.setParams({
            providerId: component.get("v.providerId"),
            taxId: component.get("v.taxId")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                // console.log(JSON.stringify(response.getReturnValue()));
                for (let index = 0; index < result.length; index++) {
                    var nameSubstring = result[index].Name.substring(0,20) + '...';
                    result[index].Name_Substr = nameSubstring;
                }
                component.set("v.Affiliations",result);
                component.set("v.webservicecalled",true);
                this.hideCaseSpinner(component);
            } else {
                console.log('FAIL## ' + JSON.stringify(response.getReturnValue()));
                this.hideCaseSpinner(component);
            }
        });

        $A.enqueueAction(action);
    },

    showCaseSpinner: function (cmp) {
        var spinner = cmp.find("case-spinner");
        $A.util.removeClass(spinner, "slds-hide");
        $A.util.addClass(spinner, "slds-show");
    },

    hideCaseSpinner: function (cmp) {
        var spinner = cmp.find("case-spinner");
        $A.util.removeClass(spinner, "slds-show");
        $A.util.addClass(spinner, "slds-hide");
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
        lgt_dt_DT_Object.lgt_dt_serviceName = 'SAE_ProviderAffiliationService';
        lgt_dt_DT_Object.lgt_dt_columns = JSON.parse('[{"title":"NAME","defaultContent":"","data":"Name"},{"title":"PROVIDER ID","defaultContent":"","data":"ProviderId"},{"title":"EFFECTIVE DATE","defaultContent":"","data":"EffectiveDate"},{"title":"AFFILIATION TYPE","defaultContent":"","data":"AffiliationType"},{"title":"ADMIT PRIVILEGE","defaultContent":"","data":"AdmittingPriv"}]');
        component.set("v.lgt_dt_DT_Object", JSON.stringify(lgt_dt_DT_Object));
        var lgt_dt_Cmp = component.find("providerAffiliations_auraid");
        //lgt_dt_Cmp.tableinit();
    }
})