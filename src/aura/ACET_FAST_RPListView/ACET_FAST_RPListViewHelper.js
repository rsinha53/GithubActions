({
    getReferenceRecords : function(component,event){
        this.showSpinner(component,event);
        var action = component.get("c.getReferences");
        action.setParams({ "caseId" : component.get("v.recordId") });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
               
                var storeResponse = result.pRefWrapList;
                if(storeResponse!=undefined && storeResponse!=null && storeResponse.length>0){
                    component.set("v.recordListSize",storeResponse.length);
                }else{
                    component.set("v.recordListSize",0);
                }
                component.set("v.refList", storeResponse);
                 if(storeResponse.length > 0)
                {
                    var pageSize = component.get("v.pageSize");
                    var totalLength = storeResponse.length ;
					component.set("v.totalRecordsCount",storeResponse.length); 
                    component.set("v.startPage",0);
                    component.set("v.endPage",pageSize-1);
                    var PaginationLst = [];
                    for(var i=0; i < pageSize; i++){
                        if(storeResponse.length > i){
                            PaginationLst.push(storeResponse[i]);    
                        } 
                    }
                    component.set('v.PaginationList', PaginationLst);
                    component.set("v.totalPagesCount", Math.ceil(totalLength / pageSize));
                }
               // component.set("v.isCaseItemLayout", result.isCaseItem);
                this.hideSpinner(component,event);
            }else{
                this.hideSpinner(component,event);
            }
        });
        $A.enqueueAction(action);
    },
    showSpinner: function(component, event) {
        var spinner = component.find("dropdown-spinner");
        $A.util.removeClass(spinner, "slds-hide");
    },
    hideSpinner: function(component, event) {
        var spinner = component.find("dropdown-spinner");
        $A.util.addClass(spinner, "slds-hide");
    },
    showToast: function(component, event, title,type,message){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "type": type,
            "message": message,
        });
        toastEvent.fire();
    },
     // navigate to next pagination record set   
    next : function(component,event,sObjectList,end,start,pageSize){
        var Paginationlist = [];
        var counter = 0;
        for(var i = end + 1; i < end + pageSize + 1; i++){
            if(sObjectList.length > i){ 
                Paginationlist.push(sObjectList[i]);
            }
            counter ++ ;
        }
        start = start + counter;
        end = end + counter;
        component.set("v.startPage",start);
        component.set("v.endPage",end);
        component.set('v.PaginationList', Paginationlist);
    },
   // navigate to previous pagination record set   
    previous : function(component,event,sObjectList,end,start,pageSize){
        var Paginationlist = [];
        var counter = 0;
        for(var i= start-pageSize; i < start ; i++){
            if(i > -1){
                 Paginationlist.push(sObjectList[i]); 
                counter ++;
            }else{
                start++;
            }
        }
        start = start - counter;
        end = end - counter;
        component.set("v.startPage",start);
        component.set("v.endPage",end);
        component.set('v.PaginationList', Paginationlist);
    },
})