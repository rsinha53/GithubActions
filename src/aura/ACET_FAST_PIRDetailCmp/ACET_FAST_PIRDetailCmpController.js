({
    getCaseRec : function(component, event, helper){
        var caseId = component.get("v.recordId");
        var action = component.get("c.getCaseRecord"); 
        action.setParams({
            "caseRecId":caseId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var result = response.getReturnValue();
              debugger;
                component.set("v.caseRec",result);
               	component.set("v.caseStatus",result.Status);
                component.set("v.CaseType", result.RecordType.Name); // caseRecordType added by Santhosh 
               var caseRecord=component.get("v.caseRec"); 
               console.log('Case type-->'+component.get("v.CaseType") );
                const eventDate= new Date(caseRecord.Original_Received_Date__c);
                 
              
               const today = new Date(helper.formatDate(new Date()));  
               const eventDay = new Date(helper.formatDate(eventDate));
               const diffTime = Math.abs(today - eventDay);
               const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
               //alert(diffDays);
                if(result.Status!='Closed' && caseRecord.Case_Type__c=='Reactive Resolution' && diffDays>50){
                    component.set("v.caseEventdateNotification",true);  /// Change
                   // alert('=='+  component.get("v.caseEventdateNotification"));
                }
              
               
                if(result.Status=='Closed')
                {
                    component.set("v.disableEditPIR",true);
                    
                }
                //var recordTypeId = component.get("v.pageReference").state.recordTypeId;
                //alert('recordTypeId---**>'+recordTypeId);
            }
        });
        $A.enqueueAction(action);
                
        var action = component.get("c.getUserDetails");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var result = response.getReturnValue();                
                //console.log('-1-'+result.UserRole.Name);
                if(result.UserRoleId != undefined && result.UserRole.Name == 'OPO PIR' ){
                    component.set("v.OPOuser",true);
                }
            }
        });
        $A.enqueueAction(action);
        
    },
    getPIRID: function(component, event, helper){
        var caseId = component.get("v.recordId");
       
        var action = component.get("c.getPIRRecId");
        action.setParams({
            "caseRecId":caseId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var result = response.getReturnValue();
               // alert(JSON.stringify(result.recType));
                component.set("v.pirId",result);
               
                if(result!=null){
                    component.set("v.saveButtonTitle",'Edit PIR Detail');
                    
                }
            }
        });
        $A.enqueueAction(action);
    },
    openPopUpEdit: function(component, event, helper){
        component.set("v.editPIR",true);
    },
    hideorCollapseAll: function(component, event, helper){
        var buttonTitle=component.get("v.hideorcollapseTitle");
        if(buttonTitle=='Expand All'){
            var allAccordians = ["A", "B", "C", "D", "E","F", "G", "H"];
            component.set('v.activeSections',allAccordians);  
            component.set("v.hideorcollapseTitle","Collapse All");
        }else{
            var allAccordians = [];
            component.set('v.activeSections',allAccordians); 
            component.set("v.hideorcollapseTitle","Expand All");
        }
        console.log('buttonTitle==>'+buttonTitle);
    },
    closeAction: function(component, event, helper){
        debugger;
        console.log('inside close action');
        var popVar = component.get("v.editPIR");
        var eventNotification=  component.get("v.caseEventdateNotification");
        if(eventNotification){
              component.set("v.caseEventdateNotification",false);
        }
        if(popVar){
            component.set("v.editPIR",false);
        }else{
            $A.get("e.force:closeQuickAction").fire();
            $A.get('e.force:refreshView').fire();
        }
    }    
})