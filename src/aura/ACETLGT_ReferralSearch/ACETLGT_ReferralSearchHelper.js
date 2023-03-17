({
    runReferralSearch: function(component, event, helper) {
        //		alert(component.get('v.birthDate'));
        var action = component.get("c.getReferralSearchResults");
        action.setParams({
            firstName: component.get('v.firstName'),
            lastName: component.get('v.lastName'),
            birthDate: component.get('v.birthDate'),
            srk: component.get('v.srk')
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
            console.log('----state---' + state);
            //check if result is successfull
            if (state == "SUCCESS") {
                var response = JSON.parse(a.getReturnValue().response);
                console.log('response' + response);
                if (!$A.util.isEmpty(response) && !$A.util.isUndefined(response)) {
                    var lgt_dt_DT_Object = new Object();
                    lgt_dt_DT_Object.lgt_dt_PageSize = 50;
                    lgt_dt_DT_Object.lgt_dt_SortBy = '0';
                    lgt_dt_DT_Object.lgt_dt_SortDir = 'desc';
                    lgt_dt_DT_Object.lgt_dt_serviceObj = response;
                    lgt_dt_DT_Object.lgt_dt_lock_headers = "300";
                    lgt_dt_DT_Object.lgt_dt_StartRecord = 1;
                    lgt_dt_DT_Object.lgt_dt_PageNumber = 1;
                    lgt_dt_DT_Object.lgt_dt_serviceName = 'ACETLGT_ReferralWebservice';
                    lgt_dt_DT_Object.lgt_dt_columns = JSON.parse('[{"title":"Referral Number","defaultContent":"","data":"resultreferralExternalID","type":"string"},{"title":"Referral Type","defaultContent":"","data":"resultReferaltype","type":"string"},{"title":"Start Date","defaultContent":"","data":"resultStartdate","type":"date"},{"title":"End Date","defaultContent":"","data":"resultEnddate","type":"date"},{"title":"Referral Status","defaultContent":"","data":"resultReferralstatus","type":"string"},{"title":"Requesting TIN","defaultContent":"","data":"resultRequestingtin","type":"string"},{"title":"Requesting Provider","defaultContent":"","data":"resultRequestingprovider","type":"string"},{"title":"Servicing TIN","defaultContent":"","data":"resultServicingtin","type":"date"},{"title":"Servicing Provider","defaultContent":"","data":"resultServicingprovider","type":"string"},{"title":"Dx Code","defaultContent":"","data":"resultDxcode","type":"string"},{"title":"Dx Description","defaultContent":"","data":"resultDXDescription","type":"date"}]');
                    component.set("v.lgt_dt_DT_Object", JSON.stringify(lgt_dt_DT_Object));
                    var lgt_dt_Cmp = component.find("ReferralSearchResultsDatatable_auraid");
                    lgt_dt_Cmp.tableinit();
                }
            }
        });
        $A.enqueueAction(action);
    },
      getErrorMsg: function(prefix, statusCode, component,event,helper) {
        //build action to query global error handling component
        var errorMsg;
        var action = component.get("c.getStdErrMsg");
        action.setParams({
            prefix: prefix,
            resultStatusCode: statusCode
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                errorMsg = response.getReturnValue();
                //component.set(errorLoc, errorMsg);
               if(errorMsg != 'undefined' && errorMsg != null){
                  helper.fireToast("Error:", errorMsg,component,event,helper);
               }
            }
        });
        $A.enqueueAction(action);
    },
    fireToast: function(title, messages,component,event,helper){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": messages,
            "type": "error",
            "mode": "dismissible",
            "duration": "10000"
        });
        toastEvent.fire();
    }
})