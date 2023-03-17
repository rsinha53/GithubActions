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
        var labelValue;
        var fieldValue;
        if(component.get("v.selectedRecordType")=='Reactive Resolution'){
            labelValue='SLA Due Date';
            fieldValue= 'sladueDate';
        }else{
            labelValue='Date Created';
            fieldValue= 'dateCreated';
        }
        component.set('v.columns', [
            {label: 'Case', fieldName: 'CaseNum', type: 'url', 
             typeAttributes: {label: { fieldName: 'caseNumber' }, target: '_blank'}},
            {label: 'RP Name', fieldName: 'rpName', type: 'text'},
            {label: labelValue, fieldName: fieldValue, type: 'Date'},
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
    
    processData : function(component, event, helper) {
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