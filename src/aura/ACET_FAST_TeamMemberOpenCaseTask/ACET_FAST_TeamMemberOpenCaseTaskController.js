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
       /* var labelValue;
        var fieldValue;
        if(component.get("v.selectedRecordType")=='Reactive Resolution'){
            labelValue='SLA Due Date';
            fieldValue= 'sladueDate';
        }else{
            labelValue='Date Created';
            fieldValue= 'dateCreated';
        }*/
        component.set('v.columns', [
            {label: 'Case Number', fieldName: 'CaseNum', type: 'url', 
             typeAttributes: {label: { fieldName: 'caseNumber' }, target: '_blank'}},
            {label: 'Provider TIN', fieldName: 'providerTIN', type: 'text'},
             {label: 'Owner Name', fieldName: 'ownername', type: 'text'},
             {label: 'Status', fieldName: 'status', type: 'text'},
             {label: 'Subject', fieldName: 'subject', type: 'text'},
             {label: 'Topic', fieldName: 'topic', type: 'text'},
            {label: 'Type', fieldName: 'type', type: 'text'},
            {label: 'Subtype', fieldName: 'subType', type: 'text'},
            {label: 'Last Modified Date', fieldName: 'lastModifiedDate', type: 'Date'},
            {label: 'Event Age', fieldName: 'eventAge', type: 'Decimal'}
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