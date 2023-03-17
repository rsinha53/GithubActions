({
    iconClicked: function(component, event, helper){
        var action = component.get('c.doInit');
        $A.enqueueAction(action);
        var currentIcon = component.get("v.selectedRecordType");
        if(currentIcon=='Reactive Resolution'){
           component.set("v.selectedRecordType","Proactive Action"); 
        }else{
            component.set("v.selectedRecordType","Reactive Resolution"); 
        }
    },
    toggleChange: function(component, event, helper){
        if(component.get("v.isProactive")){
            component.set("v.selectedRecordType","Proactive Action"); 
        }else{
            component.set("v.selectedRecordType","Reactive Resolution"); 
        }
        var action = component.get('c.doInit');
        $A.enqueueAction(action);
    },
    /*
     * This finction defined column header
     * and calls getAccounts helper method for column data
     * editable:'true' will make the column editable
     * */
    doInit : function(component, event, helper) {        
     
        component.set('v.columns', [
            {label: 'Assinged To', fieldName: 'owner', type: 'url', 
             typeAttributes: {label: { fieldName: 'assingedName' }, target: '_blank'}},
            {label: 'Due Date', fieldName: 'dueDate', type: 'Date'},
             {label: 'Related To', fieldName: 'relatedto', type: 'url', 
             typeAttributes: {label: { fieldName: 'relatedToName' }, target: '_blank'}},
             {label: 'Status', fieldName: 'status', type: 'text'}
        ]);
        helper.getRPRecords(component, helper);
    },
    
    onNext : function(component, event, helper) {        
        var pageNumber = component.get("v.currentPageNumber");
        component.set("v.currentPageNumber", pageNumber+1);
        helper.buildData(component, helper);
    },
    
    onPrev : function(component, event, helper) {        
        var pageNumber = component.get("v.currentPageNumber");
        component.set("v.currentPageNumber", pageNumber-1);
        helper.buildData(component, helper);
    },
    
    processMe : function(component, event, helper) {
        component.set("v.currentPageNumber", parseInt(event.target.name));
        helper.buildData(component, helper);
    },
    
    onFirst : function(component, event, helper) {        
        component.set("v.currentPageNumber", 1);
        helper.buildData(component, helper);
    },
    
    onLast : function(component, event, helper) {        
        component.set("v.currentPageNumber", component.get("v.totalPages"));
        helper.buildData(component, helper);
    },
})