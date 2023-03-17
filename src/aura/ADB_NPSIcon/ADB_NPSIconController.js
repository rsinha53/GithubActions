({
    onInit : function(component, event, helper) {
        var isIntegrationUser = component.get("v.isIntegrationUser");
        if(component.get("v.decodedMemberId")!=undefined)
            helper.npsIconDataList(component,helper);
    },
    handleMouseOverIcon : function(component, event, helper){
        var surveyList = component.get("v.surveyList");
        if(surveyList.length > 1){
        component.set("v.togglehoverIcon",true);
        }
    },

    handleMouseOutIcon : function(component, event, helper){
       component.set("v.togglehoverIcon",false);
    }
})