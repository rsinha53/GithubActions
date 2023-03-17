({
    /* doInitHelper funcation to fetch all records, and set attributes value on component load */
    doInitHelper : function(component,event){ 
               var selectedProviderDetails = {
            "firstName": "",
            "lastName": "",
            "taxidornpi": "",
            "corporateOwnerLastName":"",
            "corpMPIN": "",
            "payeeProviderId": ""
         
        };
        component.set("v.selectedProviderDetails",selectedProviderDetails); 
       var oRes =component.get('v.providerSearchResults');
      
                if(oRes.length > 0){ 
                    component.set('v.providerSearchResults', oRes);
                    //alert(component.get('v.providerSearchResults').accountListWrapper.objAccount);
                    var pageSize = component.get("v.pageSize");
                    var totalRecordsList = oRes;
                    var totalLength = totalRecordsList.length ;
                    component.set("v.totalRecordsCount", totalLength);
                    component.set("v.startPage",0);
                    component.set("v.endPage",pageSize-1);
                    
                    var PaginationLst = [];
                    for(var i=0; i < pageSize; i++){ 
                        if(component.get("v.providerSearchResults").length > i){
                            PaginationLst.push(oRes[i]);    
                        }  
                    
                    component.set('v.PaginationList', PaginationLst);
                    component.set("v.selectedCount" , 0);
                    //use Math.ceil() to Round a number upward to its nearest integer
                    component.set("v.totalPagesCount", Math.ceil(totalLength / pageSize)); 
                         
                } 
				}
             
    },
    // navigate to next pagination record set   
    next : function(component,event,sObjectList,end,start,pageSize){
     
        var Paginationlist = [];
        var counter = 0;
        for(var i = end + 1; i < end + pageSize + 1; i++){
            if(sObjectList.length > i){ 
                if(/*component.find("selectAllId").get("v.value")*/ true){
                    Paginationlist.push(sObjectList[i]);
                }else{
                    Paginationlist.push(sObjectList[i]);  
                }
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
                if(/*component.find("selectAllId").get("v.value")*/true){
                    Paginationlist.push(sObjectList[i]);
                }else{
                    Paginationlist.push(sObjectList[i]); 
                }
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