({
    getRPRecords : function(component, helper) {
        var action = component.get("c.getRPRecords");
        action.setParams({"selRecType" : component.get("v.selectedRecordType")});
        action.setCallback(this,function(response) {
            var state = response.getState();
            console.log('state==>'+state);
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                component.set("v.dispWrap", result);
                if(result.isValidUser){
                    if(result.recordListExists){
                        var rows = result.rpListView;
                        component.set("v.totalPages", Math.ceil(rows.length/component.get("v.pageSize")));
                        for (var i = 0; i < rows.length; i++) {
                            console.log('row==>'+row);
                            var row = rows[i];
                            row.CaseNum = '/'+row.caseId;
                            row.dateCreated = $A.localizationService.formatDate(row.dateCreated, "YYYY-MM-DD")
                        }
                        component.set("v.allData", rows);
                        component.set("v.currentPageNumber",1);
                        helper.buildData(component, helper);
                    }
                }else{
                    
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    /*
     * this function will build table data
     * based on current page selection
     * */
    buildData : function(component, helper) {
        var data = [];
        var pageNumber = component.get("v.currentPageNumber");
        var pageSize = component.get("v.pageSize");
        var allData = component.get("v.allData");
        var x = (pageNumber-1)*pageSize;
        
        //creating data-table data
        for(; x<=(pageNumber)*pageSize; x++){
            if(allData[x]){
                data.push(allData[x]);
            }
        }
        component.set("v.data", data);
        
        helper.generatePageList(component, pageNumber);
    },
    
    /*
     * this function generate page list
     * */
    generatePageList : function(component, pageNumber){
        pageNumber = parseInt(pageNumber);
        var pageList = [];
        var totalPages = component.get("v.totalPages");
        if(totalPages > 1){
            if(totalPages <= 10){
                var counter = 2;
                for(; counter < (totalPages); counter++){
                    pageList.push(counter);
                } 
            } else{
                if(pageNumber < 5){
                    pageList.push(2, 3, 4, 5, 6);
                } else{
                    if(pageNumber>(totalPages-5)){
                        pageList.push(totalPages-5, totalPages-4, totalPages-3, totalPages-2, totalPages-1);
                    } else{
                        pageList.push(pageNumber-2, pageNumber-1, pageNumber, pageNumber+1, pageNumber+2);
                    }
                }
            }
        }
        component.set("v.pageList", pageList);
    },
})