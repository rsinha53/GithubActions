({
    onDoInit : function(component, event, helper) {
        let result, mapofData = new Map(), mapCodeNdState = new Map();
        let action = component.get("c.getStateDetails");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state == "SUCCESS"){
                result = response.getReturnValue();
                if(result && result.length > 0) {
                    result.forEach(function(objKey){
                        mapofData.set(objKey['Full_Name__c'],  objKey['Label']);
                        mapCodeNdState.set(objKey['Label'],  objKey['Full_Name__c']);
                    });
                    component.set("v.mapOfStateandCodes", mapofData);
                    component.set("v.mapOfCodesandStates", mapCodeNdState);
                }
            }
        });
        $A.enqueueAction(action);
    },

    handleOnChange : function(component, event) {
        let strSelectedVal, mapOfStatesandCodes;
        if(event && event.getParam("value")) {
            strSelectedVal = event.getParam("value");
            mapOfStatesandCodes = component.get("v.mapOfStateandCodes");
            if(mapOfStatesandCodes!=null)
            component.set("v.strSelectedCode", mapOfStatesandCodes.get(strSelectedVal));
        }
    },
 validation : function(cmp, event, helper) {
   cmp.find("StateAI").validation();
    },
    updateSelecetedValue : function(component, event) {
        let strSelectedValue, params, strInput, mapOfCodesandStates;
        try {
            params = event.getParam('arguments');
            if(params) {
                strSelectedValue = params.strCode;
                mapOfCodesandStates = component.get("v.mapOfCodesandStates");
                strInput = mapOfCodesandStates.get(strSelectedValue);
                component.set("v.strSelectedCode", strSelectedValue);
                component.set("v.strInput", strInput);
                let stateCmp = component.find("StateAI");
        		stateCmp.updateSearchKeyWord(strInput);
            }
        } catch(exception) {

        }
    }
})