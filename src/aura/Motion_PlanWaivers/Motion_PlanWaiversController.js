({
	doInit : function(component, event, helper) {
	    
	},
    
    showToolTipActive:function(component,event,helper){
        var index=event.currentTarget.getAttribute("data-index");
       var prIndex=document.getElementById(index);
        prIndex.style.display="block";
       
    },
   
    HideToolTipActive:function(component,event,helper){
       var index=event.currentTarget.getAttribute("data-index");
       var prIndex=document.getElementById(index);
        prIndex.style.display="none";
    },
    showToolTipExpired:function(component,event,helper){
       
        var index=event.currentTarget.getAttribute("data-index");
        var prIndex=document.getElementById(index);
        prIndex.style.display="block";
       
        
    },
    HideToolTipExpired:function(component,event,helper){
         var index=event.currentTarget.getAttribute("data-index");
        var prIndex=document.getElementById(index);
        prIndex.style.display="none";
        
    },
     showToolTipIncomplete:function(component,event,helper){
        var index=event.currentTarget.getAttribute("data-index");
        var prIndex=document.getElementById(index);
        prIndex.style.display="block";
         
        
    },
    HideToolTipIncomplete:function(component,event,helper){
        var index=event.currentTarget.getAttribute("data-index");
        var prIndex=document.getElementById(index);
        prIndex.style.display="none";
    },
	 //Pagination code - start
	 firstPage: function (cmp, event, helper) {
        cmp.set("v.pageNumber", 1);
        cmp.set("v.currentStartNumber", cmp.get("v.pageNumber"));
        if (cmp.get("v.noOfRecordPerPage") > cmp.get("v.paginationDetail.recordCount")) {
            cmp.set("v.currentEndNumber", cmp.get("v.paginationDetail.recordCount"));
        } else {
            cmp.set("v.currentEndNumber", cmp.get("v.noOfRecordPerPage"));
        }
        
        var changePageEvent = cmp.getEvent("changePageEvent");
        changePageEvent.setParams({
            "requestedPageNumber": cmp.get("v.pageNumber")
        });
        changePageEvent.fire();
    },
    
    prevPage: function (cmp, event, helper) {
        cmp.set("v.pageNumber", Math.max(cmp.get("v.pageNumber") - 1, 1));
        cmp.set("v.currentStartNumber", (cmp.get("v.currentStartNumber") - cmp.get("v.noOfRecordPerPage")));
        cmp.set("v.currentEndNumber", (cmp.get("v.currentStartNumber") + cmp.get("v.noOfRecordPerPage")) - 1);
       
        var changePageEvent = cmp.getEvent("changePageEvent");
        changePageEvent.setParams({
            "requestedPageNumber": cmp.get("v.pageNumber")
        });
        changePageEvent.fire();
    },
    
    nextPage: function (cmp, event, helper) {
        
        cmp.set("v.pageNumber", Math.min(cmp.get("v.pageNumber") + 1, cmp.get("v.maxPageNumber")));
        var pageNumber = cmp.get("v.pageNumber");
		cmp.set("v.currentStartNumber", ((pageNumber-1) * cmp.get("v.noOfRecordPerPage")) + 1);
        //cmp.set("v.currentStartNumber", ((cmp.get("v.paginationDetail.endNumber") * cmp.get("v.noOfRecordPerPage")) + 1));
        var endNumber = cmp.get("v.currentStartNumber");
        cmp.set("v.currentEndNumber", Math.min((endNumber + cmp.get("v.noOfRecordPerPage")) - 1, cmp.get("v.paginationDetail.recordCount"))) ;
        
        var changePageEvent = cmp.getEvent("changePageEvent");
        changePageEvent.setParams({
            "requestedPageNumber": cmp.get("v.pageNumber")
        });
      
        changePageEvent.fire();
    },
    
    lastPage: function (cmp, event, helper) {
        
        cmp.set("v.pageNumber", cmp.get("v.maxPageNumber"));
        var pageNumber = cmp.get("v.pageNumber");
        var pageSize = cmp.get("v.noOfRecordPerPage");
        var allData = cmp.get("v.paginationDetail.recordCount");
        var x = (pageNumber - 1) * pageSize;
        cmp.set("v.currentStartNumber", x + 1);
        cmp.set("v.currentEndNumber", cmp.get("v.paginationDetail.recordCount"));
        
        var changePageEvent = cmp.getEvent("changePageEvent");
        changePageEvent.setParams({
            "requestedPageNumber": cmp.get("v.pageNumber")            
        });
        changePageEvent.fire();
    },
    
    enterPage: function (cmp, event, helper) {
        var enteredValue = event.getSource().get("v.value");        
        if (!$A.util.isEmpty(enteredValue)) {
            if (enteredValue > cmp.get("v.maxPageNumber")) {
                event.getSource().set('v.value', cmp.get("v.maxPageNumber"));
            } else if (isNaN(enteredValue) || enteredValue <= 0) {
                event.getSource().set('v.value', 1);
            }         
        } else {
            event.getSource().set('v.value', 1);            
        }
        
        var changePageEvent = cmp.getEvent("changePageEvent");
            changePageEvent.setParams({
                "requestedPageNumber": cmp.get("v.pageNumber")
                
            });
            changePageEvent.fire();
    },
    
    //Pagination code - end
    //Table change handler - start
    dataLoaded: function (cmp, event, helper) {
        console.log('Called dataLoaded in tablewith controller');
        cmp.set("v.pageNumber", cmp.get("v.paginationDetail.startNumber"));
        var pageNumber = cmp.get("v.pageNumber");
        var pageSize = cmp.get("v.noOfRecordPerPage");

        var tableDetails = cmp.get("v.tableBody");    

        if (tableDetails != null) {
            
            //cmp.set("v.currentStartNumber", ((cmp.get("v.paginationDetail.endNumber") * cmp.get("v.noOfRecordPerPage")) + 1));
            cmp.set("v.currentStartNumber", ((pageNumber-1) * cmp.get("v.noOfRecordPerPage")) + 1);
            var x = pageNumber * pageSize;           
            cmp.set("v.currentEndNumber", Math.min(x, cmp.get("v.paginationDetail.recordCount")));
            cmp.set("v.maxPageNumber",cmp.get("v.paginationDetail.noOfPages"));         
           
            cmp.set("v.bodySize", tableDetails.length);
        }        
        helper.search(cmp, event);
    },
    
    refreshTable: function (cmp, event, helper) {
        console.log('Inside refresh table');        
        var tableBody = cmp.get("v.tableBody");       
        cmp.set("v.tableBodyOriginal", tableBody);        
    },
    //Table change handler - end
})