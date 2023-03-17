({
    selectRecord : function(component, event, helper){      
       
        var getSelectRecord = component.get("v.EscGrp"); 
        console.log('getSelectRecord------------'+getSelectRecord);
        var compEvent = component.getEvent("oSelectedRecordEvent");
        compEvent.setParams({"recordByEvent" : getSelectRecord });
        compEvent.setParams({"isSelectValue" : "true" });
        compEvent.fire();        
        
    },
    focusRecord : function(component, event, helper){
        var focusedRec = component.get("v.EscGrp");
        focusedRec.focus();
    },
    keyDown : function(component, event, helper){
      
    },
    KeyPresss : function(component, event, helper) {
       
        
    }
})