({
    doInit : function(component, event, helper){
        
        var selectedRecordList = component.get("v.selectedListRecords");
        console.log('selectedRecordList------------->'+JSON.stringify(selectedRecordList))
        var getSelectRecord = component.get("v.oRecord");

        for(var i = 0; i<selectedRecordList.length; i++) {
            if(selectedRecordList[i].label == getSelectRecord.label){
                component.set("v.disabled", true);
                break;
            }            
        }
    },
    
    selectRecord : function(component, event, helper) {

        var getSelectRecord = component.get("v.oRecord");
        var compEvent = component.getEvent("oSelectedRecordEvent");

        compEvent.setParams({"recordByEvent" : getSelectRecord});
        compEvent.fire();
        var cmpEvent = component.getEvent("SNI_FL_MessageOnclickCurtainEvent");
        cmpEvent.setParams({
            showOnclickCurtain : false
        });
        cmpEvent.fire();
        component.set("v.disabled", !component.get("v.disabled"));
    },
    
    
})