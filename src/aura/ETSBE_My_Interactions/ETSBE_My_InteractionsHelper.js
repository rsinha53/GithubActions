({
    hideSpinner: function(component, event, helper) {
        component.set("v.Spinner", false);
    },
    
    showSpinner: function(component, event, helper) {
        component.set("v.Spinner", true);
    },
    callmycasesrecursive: function(component, event, helper){
        var spinner = component.find("loadspinnercase");
            $A.util.removeClass(spinner, "slds-hide");
            $A.util.addClass(spinner, "slds-show");
        if(component.get('v.reportResponse.tabResp.fieldDataList').length>0) {
            
         var table = $('#inttableId').DataTable();
        table.destroy();
        }
        component.set("v.displaytable",false);
      
        var recursiveaction = component.get('c.getReportResponse');
        recursiveaction.setParams({
            "UserName":component.get("v.username")
            ,"reportId":component.get("v.reportId")
            ,"ObjectName":component.get("v.objectname")
            ,"SelectedBU":component.get("v.businessunit")
            ,"lastId":component.get("v.lastId") 
        });
        
        recursiveaction.setCallback(this, function(recursiveresponse) {
            
            var currentData = component.get('v.reportResponse');
            
            var arrayname1 = currentData.tabResp.fieldDataList;
            var recursivewrapperData = JSON.parse(recursiveresponse.getReturnValue());
            console.log(recursivewrapperData);
            if(recursivewrapperData.tabResp.fieldDataList.length>0){
            arrayname1 = arrayname1.concat(recursivewrapperData.tabResp.fieldDataList);
            
            component.set('v.reportResponse.tabResp.fieldDataList',arrayname1);
            
            var tempData = recursivewrapperData.tabResp.fieldDataList;
            
            var tempdataSize = recursivewrapperData.tabResp.fieldDataList.length;
            
            
            var lastId ;
            if(tempdataSize>0){
                lastId = tempData[tempdataSize - 1][0].fieldLabel;
                component.set("v.displaytable",true);
            }
            console.log(JSON.stringify(tempData));
            component.set("v.lastId",lastId);
                if(component.get("v.recordCount")== arrayname1.length){
                       component.set("v.displayloadmore",false);
                }
              
            }else{
                
                component.set("v.displaytable",true);
                
                    component.set("v.displayloadmore",false);
                
            }
             var table;
                setTimeout(function(){ 
                    table=   $('#inttableId').DataTable({"pageLength": 25,"order": [[ 0, "desc" ]]});
                    // add lightning class to search filter field with some bottom margin..  
                  
                   
                	}, 5);  
            var spinner2 = component.find("loadspinnercase");
                    $A.util.removeClass(spinner2, "slds-show");
                    $A.util.addClass(spinner2, "slds-hide");
            
        });
        
        $A.enqueueAction(recursiveaction); 
        
    }
})