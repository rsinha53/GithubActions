({
    showSpinner: function(component, event){
        var spinner = component.find("dropdown-spinner");
        $A.util.removeClass(spinner, "slds-hide");
    },
    hideSpinner: function(component, event){
        var spinner = component.find("dropdown-spinner");
        $A.util.addClass(spinner, "slds-hide");
    },
   validateMandatoryFields: function(component, event){
        var isValidationSucces = true;
        var emptyFields=[]; 
      
        if($A.util.isEmpty(component.find("prMatrixRct").get("v.value"))){emptyFields.push("Resolution Partners Name");}
        if($A.util.isEmpty(component.find("slaRoute").get("v.value"))){emptyFields.push("SLA Routed Date");}    
         if(emptyFields.length>0){
            isValidationSucces=false;
            var fieldsToShow = '';
            for (var i = 0; i < emptyFields.length; i++) {
                fieldsToShow = fieldsToShow+'* '+emptyFields[i]+' \n';
            }
            this.showToast(component,event,"Below fields are required","Error",fieldsToShow,5000);
        }
        return isValidationSucces;
    },
   showToast: function(component, event, title,type,message ){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "type": type,
            "message": message
            
        });
        toastEvent.fire();
    },
    
     valdRPRecord: function(component, event, matrixId,caseId,fields){
            
        var casItemRec = component.get("v.caseItemRecord");
         var isvalidateSuccess = component.get("v.validateSuccess");
         var rectrId;
       var action = component.get("c.validateRPRecord");
            action.setParams({
                "prMatrixId":matrixId,
                "caseId":caseId
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                
                if(state === "SUCCESS"){
                    var finalResult = response.getReturnValue();
                                     
             if(finalResult.rpID!='' && finalResult.rpID!=null && finalResult.rpID!=undefined ){
                
              this.updateCasItem(component, event, finalResult.rpID,finalResult); 
                           
             }else {
             component.find("FastForm").submit(fields);
           
             }
     
         }

     });
            $A.enqueueAction(action);
          
    },
    updateCasItem: function(component, event, rPID,finalResult){
        var casItemRecord = component.get("v.caseItemRecord");
            casItemRecord.Resolution_Partner__c=rPID;
    // Update Case Item record
   //  alert(JSON.stringify(casItemRecord));
        var action = component.get("c.updateCaseItem");
        action.setParams({
            "caseItemRec":casItemRecord
        });
        action.setCallback(this, function(response) { 
            var state = response.getState();
            if (state === "SUCCESS"){
                var result = response.getReturnValue();
               console.log('Case Item record updated Successfuly');
                 var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Success',
                    message: 'Resolution Partner '+ finalResult.rpName+' saved successfully',
                    duration:' 3000',
                    key: 'info_alt',
                    type: 'success',
                    mode: 'pester'
                });
                toastEvent.fire();
                
                var workspaceAPI = component.find("workspace");
                workspaceAPI.getFocusedTabInfo().then(function(response) {
                    var focusedTabId = response.tabId;
                    workspaceAPI.closeTab({tabId: focusedTabId});
                    $A.get('e.force:refreshView').fire();
                    workspaceAPI.openTab({
                        url: '/lightning/r/Case_Item__c/'+ casItemRecord.Id +'/view',
                        focus: true
                    }).then(function(response) {})
                    .catch(function(error) {
                    });
                })
            }
           // window.location.reload( );
            //$A.get("e.force:refreshView").fire();
           // component.set("v.editPIRVar",false);
            
            
            
        });
        $A.enqueueAction(action);
    
    }
})