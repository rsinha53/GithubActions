({
    loadHSAValues: function (component,helper)  {
        // create a one-time use instance of the serverEcho action
        // in the server-side controller
        
        var CPTIN = component.get("v.CPTIN");
        console.log(CPTIN);
        
        var action = component.get("c.GetHsaSummaryValues");
        action.setParams({ 
            
            ssn :  CPTIN
            
        });
        
        // Create a callback that is executed after 
        // the server-side action returns
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var responseVals = response.getReturnValue();
                if($A.util.isEmpty(responseVals.ErrorMessage) && !$A.util.isEmpty(responseVals.resultWrapper) && !$A.util.isUndefined(responseVals.resultWrapper)  && !$A.util.isEmpty(responseVals) && !$A.util.isUndefined(responseVals)){
                    component.set("v.summaryResult",responseVals.resultWrapper);
                    helper.hideSpinner(component,event,helper);
                }else{
                        helper.displayToast('Error!', responseVals.ErrorMessage);
                        helper.hideSpinner(component,event,helper);
                    }
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        
        // optionally set storable, abortable, background flag here
        
        // A client-side action could cause multiple events, 
        // which could trigger other events and 
        // other server-side action calls.
        // $A.enqueueAction adds the server-side action to the queue.
        $A.enqueueAction(action);
        
    },
    
    
    // function automatic called by aura:doneWaiting event 
    hideSpinner : function(component,event,helper){
        // make Spinner attribute to false for hiding loading spinner    
        component.set("v.spinner", false);
    },    
    
    loadTransactionValues: function (component,helper)  {
        // create a one-time use instance of the serverEcho action
        // in the server-side controller
        
        var hsaid = component.get("v.hsaId");
        var status = component.get("v.status");
        console.log("hsaId :::"+hsaid);
        console.log("Status :::"+status);
        
        var action = component.get("c.GetHsaTrasactionValues");
        action.setParams({ 
            
            hsaid :  hsaid,
            status : status
            
        });
        
        // Create a callback that is executed after 
        // the server-side action returns
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var responseVals = response.getReturnValue();
                console.log('response val for transactions', responseVals);
                if(status === 'All'){
                    if($A.util.isEmpty(responseVals.ErrorMessage) && !$A.util.isEmpty(responseVals.transactionResultWrapper) && !$A.util.isUndefined(responseVals.transactionResultWrapper)  && !$A.util.isEmpty(responseVals) && !$A.util.isUndefined(responseVals)){
                    
                    component.set("v.allTransactions",responseVals.transactionResultWrapper);
                    var transactionLengthVal = component.get("v.allTransactions");
                    component.set("v.allTransactionSize",transactionLengthVal.length);
                    }else{
                        console.log('response val for transactions', responseVals.ErrorMessage);
                        helper.displayToast('Error!', responseVals.ErrorMessage);
                    }
                    
                }
                helper.hideSpinner(component,event,helper);
            }
        });
        
        // optionally set storable, abortable, background flag here
        
        // A client-side action could cause multiple events, 
        // which could trigger other events and 
        // other server-side action calls.
        // $A.enqueueAction adds the server-side action to the queue.
        $A.enqueueAction(action);
        
    },
    
    loadDataTableValues: function (component,helper)  {
        // create a one-time use instance of the serverEcho action
        // in the server-side controller
        
        var hsaid = component.get("v.hsaId");
        var status = component.get("v.status");
        console.log("hsaId DT:::"+hsaid);
        console.log("Status DT:::"+status);
        
        var action = component.get("c.GetHsaDTTrasactionValues");
        action.setParams({ 
            
            hsaid :  hsaid,
            status : status
            
        });
        
        // Create a callback that is executed after 
        // the server-side action returns
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var responseVals = response.getReturnValue();
                
                if(status != 'All'){
                    console.log('>>> Success Resp');
                    var responce = JSON.parse(response.getReturnValue().responce);
                    helper.processdatatable(component,event,helper,responce);
                }
                
                helper.hideSpinner(component,event,helper);
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        $A.enqueueAction(action);
        
    },
    displayToast: function(title, messages){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": messages,
            "type": "error",
            "mode": "dismissible",
            "duration": "10000"
        });
        toastEvent.fire();
		return;
    } ,  
    
    processdatatable:function(component,event,helper,responce){
        
        var showEntries = component.get("v.showEntries");
        console.log('>>>process dt Entries'+showEntries);
        var lgt_dt_DT_Object = new Object();
        lgt_dt_DT_Object.lgt_dt_PageSize = showEntries;
        lgt_dt_DT_Object.lgt_dt_StartRecord =1;
        lgt_dt_DT_Object.lgt_dt_PageNumber=1;
        lgt_dt_DT_Object.lgt_dt_SortBy = '';
        lgt_dt_DT_Object.lgt_dt_SortDir = '';
        lgt_dt_DT_Object.lgt_dt_serviceName = 'ACETLGT_HSATransactionWebservice';
        lgt_dt_DT_Object.lgt_dt_columns = JSON.parse('[{"title":"Date","defaultContent":"","data":"transactionDate","type": "string" },{"title":"Status","defaultContent":"","data":"status","type": "string"},{"title":"Description","defaultContent":"","data":"description","type": "string"},{"title":"Amount","defaultContent":"","data":"amount","type": "string"}]');
        lgt_dt_DT_Object.lgt_dt_serviceObj = responce;
        lgt_dt_DT_Object.lgt_dt_lock_headers = "300"
        component.set("v.lgt_dt_DT_Object", JSON.stringify(lgt_dt_DT_Object));
        var lgt_dt_Cmp = component.find("HSATransactionTable_auraid");
        lgt_dt_Cmp.tableinit();
        //debugger;
    }    
})