({
	onInit : function(component, event, helper) {
	    var data = component.get("v.subjcallerList");
        if(data != null && data.length>0) {
            component.set('v.showSpinner',false);
        }
	},
    
    handlecallerdetails : function(component, event, helper) {
        var callerList = [];
        component.set("v.subjcallerList",callerList);
        callerList.push(component.get("v.callerdetails"));
        console.log('handlecaller'+JSON.stringify(callerList));
        component.set("v.subjcallerList",callerList);
        component.set('v.showSpinner',false);
    },
    
    handlesubjectdetails : function(component, event, helper) {
        var subjList = [];
        component.set("v.subjcallerList",subjList);
        subjList.push(component.get("v.subjectdetails"));
        component.set("v.subjcallerList",subjList);
        console.log('handlesubject'+JSON.stringify(subjList));
        component.set('v.showSpinner',false);
    },
    
})