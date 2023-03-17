({
    doInitialize: function(component, event, helper){
        helper.showSpinner(component, event);
        var myPageRef = component.get("v.pageReference");
        var pMatrixRecId = myPageRef.state.c__providerMatrixId;
        var cRecId = myPageRef.state.c__caseRecordId;
        component.set("v.pMatrixId",pMatrixRecId);
        component.set("v.caseRecId",cRecId);
        var action = component.get("c.getCaseRPWrapper");
        action.setParams({
            "pMatrixId":pMatrixRecId,
            "caseId":cRecId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var result = response.getReturnValue();
                console.log("result==>"+JSON.stringify(result));
                component.set("v.rpNameValue",result.rpName);
                component.set("v.caseRecordTypeName",result.caseRecordType);
                component.set("v.rpRectypeId",result.rpRecTypeId);
                helper.hideSpinner(component, event);
            }else{
                helper.hideSpinner(component, event);
            }
        });
        $A.enqueueAction(action);
    },
    openPopUp: function(component, event, helper){
        component.set("v.rpRecordId",component.get("v.pMatrixId"));
        helper.openPopOver(component, event);
    },
    getRPNameId : function(component, event, helper){
        helper.showSpinner(component, event);
        component.set("v.rpRecordId","");
        var action = component.get("c.getResolutionPartnerId");
        action.setParams({"rpName":component.get("v.rpNameValue")});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var result = response.getReturnValue();
                if(result!=undefined && result!=null && result!=''){
                    component.set("v.rpRecordId",result);
                    helper.openPopOver(component, event);
                }else{
                    console.log("result==>"+result);
                    var title="Error"
                    var type="error";
                    var message = "There is no RP record with RP name"+" '"+component.get("v.rpNameValue")+"' "+"Please select a different Row";
                    helper.showToast(component, event, title, type,message);   
                }
                helper.hideSpinner(component, event);
            }else{
                helper.hideSpinner(component, event);
                console.log("state==>"+state);
                var title="Error"
                var type="error";
                var message = "There was an error while retrieving RP recordplease check with administrator";
                helper.showToast(component, event, title, type,message);
            }
        });
        $A.enqueueAction(action);
    },
    closeAction: function(component, event, helper){
        helper.closePopUp(component, event);
    },
    openAction: function(component, event, helper){
        helper.openPopOver(component, event);
    }
})