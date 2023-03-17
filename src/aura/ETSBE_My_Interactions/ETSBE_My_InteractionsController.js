({
    scriptsLoaded : function(component, event, helper) {
        console.log('Script loaded..'); 
        
    },
    handleClick: function(component,event,helper){
        helper.callmycasesrecursive(component,event,helper);
    },
    intractionScoreCard : function(component,event,helper) {
        // Load report data
        
        component.set("v.displaytable",false);
        
        var params = event.getParam('arguments');
        var selectedUser='';
        var selectedBUnit='';
        if (params) {
            selectedUser = params.selectedUSer;
            selectedBUnit = params.selectedBU;
            component.set("v.username",selectedUser);
                    component.set("v.businessunit",selectedBUnit);
                    component.set("v.lastId",'');
        }
        helper.showSpinner(component, event, helper);
        var action = component.get("c.getReportResponse");
        
        action.setParams({
            "UserName":selectedUser
            ,"reportId": component.get("v.reportId")
            ,"ObjectName":component.get("v.objectname")
            ,"SelectedBU":selectedBUnit
            ,"lastId":component.get("v.lastId")
        });
        var self = this;
        action.setCallback(this, function(response){
            var state = action.getState();
            // Display toast message to indicate load status
            //var toastEvent = $A.get("e.force:showToast");
            if(state ==='SUCCESS'){
                console.log(response.getReturnValue());
                var reportResponseObj = JSON.parse(response.getReturnValue()); 
                component.set("v.reportResponse", reportResponseObj); 
                var lastId ;
                var data= reportResponseObj.tabResp.fieldDataList;
                component.set("v.recordCount",reportResponseObj.tabResp.recordcount);
                if(reportResponseObj.tabResp.recordcount >25){
                    component.set("v.displayloadmore",true);
                }else{
                    component.set("v.displayloadmore",false);
                }

                var dataSize = reportResponseObj.tabResp.fieldDataList.length;
                if(reportResponseObj.tabResp.fieldDataList.length >0){
                    lastId = data[dataSize - 1][0].fieldLabel;
                    console.log('--lastId----'+lastId);
                     component.set("v.lastId",lastId);
                    component.set("v.displaytable",true);
                }
                //if(reportResponseObj.tabResp.alldata == false)
                 //$A.enqueueAction(action);
                var table;
                setTimeout(function(){ 
                    table=   $('#inttableId').DataTable({"pageLength": 25, "order": [[ 0, "desc" ]]});
                    // add lightning class to search filter field with some bottom margin..  
                    $('div.dataTables_filter input').addClass('slds-input');
                   
                	}, 5);  
                helper.hideSpinner(component, event, helper);
            }
            if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message in intractionScoreCard while calling getReportResponse: " + 
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
                helper.hideSpinner(component, event, helper);
            }
            //toastEvent.fire();
        });
        $A.enqueueAction(action);
    },
    showSpinner: function(component, event, helper) {
        // make Spinner attribute true for displaying loading spinner 
        component.set("v.spinner", true); 
    },
    
    // function automatic called by aura:doneWaiting event 
    hideSpinner : function(component,event,helper){
        // make Spinner attribute to false for hiding loading spinner    
        component.set("v.spinner", false);
    },
    loadResources : function() {
        this.loadCSS('/resource/jquery_mobile_145/jquery.mobile-1.4.5.min.css', function() {
        });
        this.loadJS('/resource/jquery_mobile_145/jquery-1.11.2.min.js', function() {
        });
        this.loadJS('/resource/jquery_mobile_145/jquery.mobile-1.4.5.min.js', function() {
        });
    },
    loadJS : function(source, callback) {
        var loadScript = document.createElement('script');
        loadScript.setAttribute('src', source);
        loadScript.onload = callback;
        document.head.appendChild(loadScript);
    },
    loadCSS : function(source, callback) {
        var fileref = document.createElement('link');
        fileref.setAttribute("rel", "stylesheet");
        fileref.setAttribute("type", "text/css");
        fileref.setAttribute("href", source);
        fileref.onload = callback;
        document.head.appendChild(fileref);
    }    
})