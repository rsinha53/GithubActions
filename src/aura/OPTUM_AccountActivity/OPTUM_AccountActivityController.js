({
    doinit: function(component, event, helper) {
        var year = new Date().getFullYear();
        component.set("v.planyear" , year);
        component.set('v.Columns', [
            {label: 'Date', fieldName: 'paymentDate', type: 'text',initialWidth: 200,sortable : true},
            {label: 'Amount', fieldName: 'paymentAmount', type: 'currency',sortable : true,initialWidth: 200,cellAttributes: { alignment: 'left' }},
            {label: 'Type', fieldName: 'Type', type: 'text',initialWidth: 120,sortable : true },
            {label: 'Check Number', fieldName: 'paymentCheckNum', type: 'text',initialWidth: 200,sortable : true},
            {label: 'Contribution Comments', fieldName: 'contributionComments', type: 'text' ,wrapText: true,sortable : true }
            
        ]); 
        helper.fetchTransactions(component, event, helper);
    },
    //US3254524 Autodoc Account Activity
    updatePaginatedData : function(cmp,event,helper) {
        var currentPageNum = event.getParam('requestedPageNumber');
        var ealierPageNum = cmp.get('v.pageNum');
        if($A.util.isUndefinedOrNull(ealierPageNum) || currentPageNum>ealierPageNum){
            cmp.set('v.pageNum',currentPageNum);
            helper.next(cmp, event, helper);
        }else {
            cmp.set('v.pageNum',currentPageNum);
            helper.previous(cmp, event, helper); 
        }
    },
})