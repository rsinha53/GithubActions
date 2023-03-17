({
     onChildAttributeChange : function(component,event,helper) {
        var dataMap = component.get("v.dataMap");
        var claimType = component.get("v.claimType");
        console.log(JSON.stringify(dataMap));
        //alert('test');
     }
    
})