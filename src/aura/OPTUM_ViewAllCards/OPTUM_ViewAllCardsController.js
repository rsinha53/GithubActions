({
	doInit: function(component, event, helper) {
	    let today = new Date();
        let uniqueString = today.getTime();
        component.set('v.autodocUniqueId', uniqueString);
        component.set('v.autodocUniqueIdCmp', uniqueString);
        console.log('controller entered');
        //Added by Santhi to Create New Case From Claims Page-
        component.set("v.memberDetails", component.get("v.pageReference").state.c__memberDetail);
        component.set("v.userInfo", component.get("v.pageReference").state.c__userInfo);
        component.set("v.optumEID", component.get("v.pageReference").state.c__optumEID);
        component.set("v.optumInt", component.get("v.pageReference").state.c__optumInt);
         component.set("v.SubjectId", component.get("v.optumInt.Originator__c"));
        helper.accountPicklist(component, event, helper);
       //END Create New Case
        component.set("v.columnsList",[
            {
                label : 'Last 4 Card Digits',
                fieldName: 'cardDigits',
                type: 'text'
                
            },
            {
                label : 'Embossed Name',
                fieldName: 'embossedName',
                type: 'text'
                
            },
            {
                label : 'Card Type',
                fieldName: 'cardType',
                type: 'text'
                
            },
            {
                label : 'Card Status',
                fieldName: 'status',
                type: 'text',
                sortable : true
                
            },
            {
                label : 'Card Order Status*',
                fieldName: '',
                type: 'text'
                
            },
            {
                label : 'Order Date',
                fieldName : 'requestDate',
                type : 'date', typeAttributes: { month: '2-digit',  
                                                 day: '2-digit',  
                                                year: 'numeric'},
                sortable : true
                
            },
            {
                label : 'Mailed Date*',
                fieldName: '',
                type: 'text'
                
            },
            {
                label : 'Expiration Date',
                fieldName: 'expirationDate',
                type: 'text'
                
            }
            /*{label: '', fieldName: '',type:'button', typeAttributes: {
            label: 'Transactions',
            name: 'Transactions',
            title: 'Transactions'
            }
            },
            {label: '', fieldName: '',type:'button', typeAttributes: {
            label: 'Update',
            name: 'Update',
            title: 'Update'
            }
            }*/
        ]);
        helper.debitcards(component, event, helper);
    },
    onChange: function(component, event, helper) {
        helper.getData(component, event, helper);
        helper.debitcards(component, event, helper);
    },
    handleSort : function(component,event,helper){
        var sortBy = event.getParam("fieldName");
        var sortDirection = event.getParam("sortDirection");
        component.set("v.sortBy",sortBy);
        component.set("v.sortDirection",sortDirection);
        helper.sortData(component,event,helper,sortBy,sortDirection);
    },
    handleCaseComments: function(cmp, event, helper){
       var caseComment = event.getParam("caseComment");
       cmp.set("v.comments",caseComment);
     },
   /*  openPreview : function(cmp) {
      var selectedString = _autodoc.getAutodoc(cmp.get("v.autodocUniqueId"));
        cmp.set("v.tableDetails_prev",selectedString);
        cmp.set("v.showpreview",true);

	},    */
})