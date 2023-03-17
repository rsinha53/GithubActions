({
	myAction : function(component, event, helper) {
       
		//helper.getWODetails(component, event, helper);
		
	},
   handlePriorAuthDetails: function(component, event,helper) { 
        var priorAuthOwner = event.getParam("priorAuthOwner"); 
        var hostSysDatTime = event.getParam("hostSysDatTime"); 
        var canceledReason = event.getParam("canceledReason"); 
       console.log('priorAuthOwner---------------'+priorAuthOwner);
       console.log('hostSysDatTime---------------'+hostSysDatTime);
       console.log('canceledReason---------------'+canceledReason);
        component.set('v.pAuthOwner',priorAuthOwner);
        component.set('v.hostSysDate',hostSysDatTime);
        component.set('v.canceledRes',canceledReason);
    }
})