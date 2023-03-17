({
    doInit : function(component, event, helper) {

        var today = $A.localizationService.formatDate(new Date(), "MM/DD/YYYY");
        component.set('v.today', today);
        var curURL = window.location.href;
        var sPageURL = decodeURIComponent(curURL);
        if(sPageURL.indexOf('?')> -1){
            var  params = sPageURL.split('?');
            console.log('curParam--params--'+params);
            var arrayMapKeys = [];
            if(params[1].indexOf('&')> -1){
                var allParams = params[1].split('&');
                for(var j=0;j<allParams.length;j++){
                    var curParam = allParams[j];
                    if(curParam.indexOf('=')>-1){
                        var memParm = curParam.split('=');
                        arrayMapKeys.push(memParm[1]);
                    }
                }
            }
            else{
                if(params[1].indexOf('=')>-1){
                    var memParm = params[1].split('=');
                    arrayMapKeys.push(memParm[1]);
                }
            }
            if(arrayMapKeys.length > 0 ){
                // if(arrayMapKeys.length > 0 && curMemId != ''){
                component.set('v.roidIds',arrayMapKeys);
                console.log('arrayMapKeys------'+arrayMapKeys);
               //console.log('curMemId------'+component.get("v.curMemId"));
                var action = component.get('c.getRoiMembers');
                action.setParams({
                    // "curRoiId" : component.get("v.curMemId"),
                    "lstRoiIds" : arrayMapKeys
                });
                action.setCallback(this, function(actionResult) {
                    var stateResponse = actionResult.getState();
                    console.log('actionResult------'+stateResponse);
                    var result = actionResult.getReturnValue();
                    console.log('actionResult--result----'+JSON.stringify(actionResult.getReturnValue()));
                    if(stateResponse == 'SUCCESS') {
                        //var result = JSON.stringify(actionResult.getReturnValue());
                         //component.set("v.curMemName", result.curMemName);
                        component.set("v.memROILst", result);
                        if(result.length > 0){
                            var curMemNam = result[0].SNI_FL_Member__r.SNI_FL_Member__r.FirstName + ' ' +result[0].SNI_FL_Member__r.SNI_FL_Member__r.LastName;
                            component.set("v.curMemName", curMemNam);
                           
                        }
                        else{
                            component.set("v.isChecked", true);
                        }
                    }
                });
                $A.enqueueAction(action);
            }
            // }
        }
    },
    signClick : function(component, event, helper){
        var fullName = component.get('v.fullName');
        var fullNamCmp = component.find('fullNameDId');
        var curMemName = component.get('v.curMemName');
        console.log('--fullName---'+fullName);
        console.log('---curMemName--'+curMemName);
        var isValid = true;
        if($A.util.isEmpty(fullName)){
            fullNamCmp.setCustomValidity("Signature cannot be blank.");
            isValid = false;
        }
        else if(fullName != curMemName ){
            fullNamCmp.setCustomValidity("Signature does not match.");
            isValid = false;
        }
            else{
                fullNamCmp.setCustomValidity("");
            }
        fullNamCmp.reportValidity();
        console.log('----22-');
        if(isValid){
            var action = component.get('c.saveRoiDetails');
            var memRoilist = component.get("v.memROILst");
            console.log('----memRoilist----'+memRoilist);
            action.setParams({
                "lstRoiIds" : memRoilist
            });
            action.setCallback(this, function(actionResult) {
                var stateResponse = actionResult.getState();
                console.log('----stateResponse----'+stateResponse);
                if(stateResponse == 'SUCCESS') {
                    var roids =  component.get('v.roidIds');
                    var params = '';
                    if(roids.length > 0){
                        for(var cur in roids){
                            if(params == ''){
                                params = 'p'+cur+'='+roids[cur];
                            }
                            else{
                                params = params+'&'+'p'+cur+'='+roids[cur];
                            }
                        }
                    }
                    var flURl = $A.get("$Label.c.FamilyLinkUrl");
                    var url = flURl+'Family_Link_PublicView?'+params;
                    component.set("v.iframeurl", url);
                    if(screen.width < 500 || screen.height < 500) {
                        var myWindow = window.open(url,'_parent', "Family_Link", "width=500px,height=500px");
                    }
                    else{
                        component.set("v.iframeurl", url);
                    }
                    component.set("v.editMode", false);
                }
            });
            $A.enqueueAction(action);
        }
    },
    onChangeName: function(component, event, helper){
        var nameEntered = component.find("fullNameDId").get("v.value");
        component.set("v.enteredName", nameEntered);
    },
    closeWarning : function(component, event, helper){
        component.destroy();
    }
})