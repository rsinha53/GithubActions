({
	doInit : function(component, event, helper) {
        
        component.set("v.columns",[
                           {label: 'Name', fieldName: 'famName', type: 'text'},
                           {label: 'Member ID', fieldName: 'famMemberId', type: 'text' },
                           {label: 'Policy Number', fieldName: 'famPolicyID', type: 'text' }]);
        component.set("v.header",'Select Families Visible in Family Link');
        component.set("v.saveDisablePopUp",true);
        helper.fetchAccounts(component, event); 
	},
    saveDetails: function(component, event, helper) {
        
         helper.showGlobalSpinner(component); 
         helper.updateDetails(component, event);
        
    },
    rowselect : function(component, event, helper){

        var selectedRows = event.getParam('selectedRows'); 
        component.set('v.selectedRowsCount', selectedRows.length);
        var setRows = [];
        for ( var i = 0; i < selectedRows.length; i++ ) {
            console.log(selectedRows[i]);
            console.log('selectedRows[i].Id='+selectedRows[i].Id);
            setRows.push(selectedRows[i].Id);
        }
        component.set("v.selectedRow", setRows);        
        console.log('setRows:'+setRows.length);
        if(selectedRows.length>0) {
          component.set("v.saveDisablePopUp",false);
        }
        else{
          component.set("v.saveDisablePopUp",true);  
        }
     },
    
    closeModel : function(component, event, helper){
         component.set("v.showModal",false);
    }
})