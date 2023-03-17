({
    refreshValue : function(component,event,helper){
	component.set("v.accountList",event.getParam("accountList"));
        component.set("v.rowIndex",event.getParam("index"));
        component.set("v.accountType", event.getParam("accountType"));
        helper.getTransaction(component, event, helper, 0); 
    },
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