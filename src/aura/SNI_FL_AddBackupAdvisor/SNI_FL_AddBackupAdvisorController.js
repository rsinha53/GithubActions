({
    doInit: function(component, event, helper) {
        var str  = component.get('v.selectedUserLookUpRecords');
        component.set('v.BackupUserLookUpRecords',component.get('v.selectedUserLookUpRecords'));
    },
   
    closeModel : function(component, event, helper) {
        component.set("v.openBackupAgentModal",false);
        component.set('v.selectedUserLookUpRecords',component.get('v.BackupUserLookUpRecords'));
    },
    clearedPilled:function(component,event,helper){
        var selectedPills = event.getParam("message");
        component.set('v.TodeleteclearedRecords',component.get('v.TodeleteclearedRecords').concat(selectedPills));  
    }, 
    
    save:function(component,event,helper){   
        helper.hlprsaveRecords(component,event,helper);        
    }
})