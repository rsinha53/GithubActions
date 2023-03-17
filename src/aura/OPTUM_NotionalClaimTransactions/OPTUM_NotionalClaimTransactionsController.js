({
    doInit: function(component, event, helper) {
        component.set("v.acctType", component.get("v.pageReference").state.c__acctType);
        component.set("v.memberDetails", component.get("v.pageReference").state.c__memberDetail);
	component.set("v.userInfo", component.get("v.pageReference").state.c__userInfo);
        component.set("v.optumEID", component.get("v.pageReference").state.c__optumEID);
        component.set("v.optumInt", component.get("v.pageReference").state.c__optumInt);
        helper.initialiseData(component, event, helper);
        component.set('v.Columns', [{
                label: 'Claim Number',
                fieldName: 'claimNumber',
                type: 'text',
				sortable: true
            },
            {
                label: 'Effective Date of Service',
                fieldName: 'claimDateofServiceEffectiveDate',
                type: 'text',
				sortable: true
            },
            {
                label: 'Submitted Amount',
                fieldName: 'submittedClaimAmount',
                type: 'currency',
				cellAttributes: { alignment: 'left' },
				sortable: true
            },
            {
                label: 'Denied Amount',
                fieldName: 'deniedClaimAmount',
                type: 'currency',
				cellAttributes: { alignment: 'left' },
				sortable: true
            },
            {
                label: 'Pending Amount',
                fieldName: 'pendingClaimAmount',
                type: 'currency',
				cellAttributes: { alignment: 'left' },
				sortable: true
            },
            {
                label: 'Paid Amount',
                fieldName: 'paidClaimAmount',
                type: 'currency',
				cellAttributes: { alignment: 'left' },
				sortable: true
            },
            {
                label: 'Approved Amount',
                fieldName: 'approvedClaimAmount',
                type: 'currency',
				cellAttributes: { alignment: 'left' },
				sortable: true
            },
            {
                label: 'Status',
                fieldName: 'claimStatus',
                type: 'text',
				initialWidth: 110,
				sortable: true
            },
            {
                label: 'Receipt Status',
                fieldName: 'receiptStatus',
                type: 'text',
				sortable: true
            },
        ]);
        helper.fetchTransactions(component, event, helper);
    },
    onChange: function(component, event, helper) {
        helper.fetchData(component, event, helper);
        helper.fetchTransactions(component, event, helper);
    },
    previous: function(component, event, helper) {
        helper.previous(component, event, helper);
    },
    next: function(component, event, helper) {
		component.set("v.checkNext", true);
        helper.next(component, event, helper);
    },
	 //added by srikanya                              
    handleSort: function(component, event, helper) {
        var sortBy = event.getParam("fieldName");
        var sortDirection = event.getParam("sortDirection");
        component.set("v.sortBy", sortBy);
        component.set("v.sortDirection", sortDirection);
        helper.sortData(component, event, helper, sortBy, sortDirection);
    },
    // added by srikanya 
    selectRow: function(component, event, helper) {
        var selectedRows = event.getParam("selectedRows");
        component.set("v.SelectedRow", selectedRows);
        helper.fireEventToViewClaims(component, event, helper, selectedRows);
    },
	showResults: function(component, event, helper) {
        helper.filterData(component, event, helper);
    },
    clearResults: function(component, event, helper) {
        var fData = false;
        component.set("v.filteredData", false);                            
        helper.paginationData(component, event, helper, fData);
        component.set("v.ShowSelectedClaim", false);
    },
	handleCaseComments: function(cmp, event, helper){
       var caseComment = event.getParam("caseComment");   
       cmp.set("v.comments",caseComment);
    },
	// for Preview button
	openPreview : function(cmp) {
      var selectedString = _autodoc.getAutodoc(cmp.get("v.autodocUniqueId"));
      cmp.set("v.tableDetails_prev",selectedString);
      cmp.set("v.showpreview",true);
		
	}
})