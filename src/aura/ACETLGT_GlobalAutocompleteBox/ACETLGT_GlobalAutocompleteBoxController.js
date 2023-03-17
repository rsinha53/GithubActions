({
    selectRecord : function(component, event, helper){      
       
        var getSelectRecord = component.get("v.oRecord");  
        
        //Fire App Event to work for the enter button
        var appEvent = $A.get("e.c:ACETLGT_FocusTopicTextEvent");        
        appEvent.setParams({"valueSelected" : "true" });
        appEvent.fire();
        
        var compEvent = component.getEvent("oSelectedRecordEvent");
        
        compEvent.setParams({"recordByEvent" : getSelectRecord });
        compEvent.setParams({"isSelectValue" : "true" });
        compEvent.fire();        
        
    },
    focusRecord : function(component, event, helper){
        alert("----Focus Rec----->");
        var focusedRec = component.get("v.oRecord.Name");
        
        focusedRec.focus();
    },
    keyDown : function(component, event, helper){
        alert("----Focus Rec----->");
        //var focusedRec = component.get("v.oRecord.Name");
        
        //focusedRec.focus();
    },
    KeyPresss : function(component, event, helper) {
        //alert("KEY press" );
        //var getSelectRecord = component.get("v.oRecord");
        // call the event   
        //var compEvent = component.getEvent("oSelectedRecordEvent");
        // set the Selected sObject Record to the event attribute. 
        //alert("Inside LI-1" + getSelectRecord); 
        //compEvent.setParams({"recordByEvent" : getSelectRecord });  
        // fire the event  
        //compEvent.fire();
        
    }
})