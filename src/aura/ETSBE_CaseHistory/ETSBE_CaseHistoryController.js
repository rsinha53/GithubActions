({
    doInit : function(cmp, event, helper) { 
        
    },
    scriptsLoaded : function(component, event, helper) {
        console.log('Script loaded..'); 
        
    },showCaseSpinner: function (component) {
        var spinner = component.find("case-spinner");
        $A.util.removeClass(spinner, "slds-hide");
        $A.util.addClass(spinner, "slds-show");
    },
    openCaseDetail: function (component, event, helper) {
        debugger;
        var caseId = event.currentTarget.getAttribute("data-caseId");
        console.log(caseId);
        
        var workspaceAPI = component.find("workspace");
        workspaceAPI.openSubtab({
            pageReference: {
                type: 'standard__recordPage',
                attributes: {
                    actionName: 'view',
                    objectApiName: 'Case',
                    recordId : caseId  
                },
            },
            focus: true
        }).then(function(response) {
            workspaceAPI.getTabInfo({
                tabId: response
                
            }).then(function(tabInfo) {

            });
        }).catch(function(error) {
            console.log(error);
        });
    },
    showResultsToggle: function(cmp, event, helper) {
        helper.hideCaseSpinner(cmp);
        if(cmp.get("v.globalId") != null && cmp.get("v.globalId") != undefined && cmp.get("v.globalId") != ''){
	        var table = $('#'+cmp.get("v.globalId"));
	        if(table != null && table != undefined && table != ''){
		        if(table.length>0){
                    setTimeout(function(){ 
	     			var jstable = table.DataTable();
	     			jstable.destroy();
                        }, 20); 
	     		}
	        }
	        
	        
	        var caseHistoryList = event.getParam("caseHistoryList");
	        cmp.set("v.caseHistoryList", caseHistoryList);
	        if(caseHistoryList.length>0){
	            cmp.set("v.displaytable",true);
	        }else{
	            cmp.set("v.displaytable",false);
	        }
	        var table;
	         if(!$A.util.isUndefinedOrNull(caseHistoryList)
	           && $A.util.isEmpty(caseHistoryList) == false){
	        setTimeout(function(){ 
	        	if(cmp.get("v.globalId") != null && cmp.get("v.globalId") != undefined && cmp.get("v.globalId") != ''){
	        		table=   $('#'+cmp.get("v.globalId"));
	        		if(table != null && table != undefined  && table != ''){
		        		if(table.length>0){
		        			table.DataTable({"pageLength": 25,"order": [[ 4, "desc" ]]});
		        		}
	        		}
	        	}
	            
	        }, 20);  
	         }
        }
    },
    showResults: function(cmp, event, helper) {
        debugger;
       
        var comibinedCaseHistory = [];
        var globalId = cmp.getGlobalId();
         var workspaceAPI = cmp.find("workspace");
        workspaceAPI.getEnclosingTabId().then(function(tabId) {
            console.log(tabId);
            cmp.set("v.globalId",tabId);
       })
        .catch(function(error) {
            console.log(error);
        });
        workspaceAPI.getTabInfo().then(function (tabInfo) {
        	console.log('TABINFO1: ' + tabInfo.tabId);
        	//console.log('TABINFO2: ' + JSON.stringify(tabInfo));
        });
        workspaceAPI.getAllTabInfo().then(function (tabInfo) {
        	//console.log('ALLTABINFO1: ' + tabInfo.tabId);
        	console.log('ALLTABINFO2: ' + JSON.stringify(tabInfo));
        });

        if(cmp.get("v.globalId") != null && cmp.get("v.globalId") != undefined && cmp.get("v.globalId") != ''){
	         var table = $('#'+cmp.get("v.globalId"));
	         if(table != null && table != undefined && table != ''){
		         if(table.length>0){
                     setTimeout(function(){ 
	     			var jstable =  table.DataTable();
	     			jstable.destroy();
                         }, 20);
	     		}
	         }
	        
        }
        var caseHistoryList = event.getParam("caseHistoryList");
        if(caseHistoryList.length>0){
            cmp.set("v.displaytable",true);
        }else{
            cmp.set("v.displaytable",false);
        }
        cmp.set("v.xRefId",event.getParam("xRefId"));
        var table;
        //alert(caseHistoryList);
        
        var table;
        if(!$A.util.isUndefinedOrNull(caseHistoryList)
           && $A.util.isEmpty(caseHistoryList) == false){
        setTimeout(function(){ 
        	if(cmp.get("v.globalId") != null && cmp.get("v.globalId") != undefined && cmp.get("v.globalId") != ''){
        		table=   $('#'+cmp.get("v.globalId"));
        		if(table != null && table != undefined  && table != ''){
	        		if(table.length>0){
	        			table.DataTable({"pageLength": 25,"order": [[ 4, "desc" ]]});
	        		}
        		}
        	}
            // add lightning class to search filter field with some bottom margin..  
           // $('div.dataTables_filter input').addClass('slds-input');
            
        }, 20);  
        }
        helper.hideCaseSpinner(cmp);
        
    },
    
    
    
    
})