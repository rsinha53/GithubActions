({
    validateData:function(component, event, helper){
        helper.validateRequired(component, event, helper);
        
    },
    doInit:function(component, event, helper){
       let button = component.find('disablebuttonid');
        //var validdata = helper.validateRequired(component,event, helper);
        var relationship = component.get("v.enrollee.relationship");
        
        component.set("v.isrequired",true);
        component.set("v.showTable",true);
        if(relationship =='Employee'|| relationship == 'Retiree'){
                component.set("v.isssnrequired",true);
                component.set("v.showSSN",true);
            }else{
                component.set("v.isssnrequired",false);
                component.set("v.showSSN",false);
            }
    },
    setPickLStValue : function(component, event, helper){
        var selRelVal=component.find("reltnion").get("v.value");
        let button = component.find('disablebuttonid');
       
        if(selRelVal !='') {
            component.set("v.isrequired",true);
            if(selRelVal =='Employee'|| selRelVal == 'Retiree'){
                component.set("v.isssnrequired",true);
                component.set("v.showSSN",true);
            }else{
                component.set("v.isssnrequired",false);
                component.set("v.showSSN",false);
            }
        }else{ 
            component.set("v.isrequired",false); 
            component.set("v.isssnrequired",false);
        }
        component.set("v.Relationship",selRelVal);
        
         var validdata = helper.validateRequired(component,event, helper);
        if(!component.get("v.dobvalidationError") &&  !component.get("v.ssnvalidationError") && validdata==true){
            
            button.set('v.disabled',false);
        }else{
            button.set('v.disabled',true); 
        }
       
    },
    checkSSNValidity : function(component,event, helper){
        var inputCmp = component.find("ssnId");
        var value = inputCmp.get("v.value");
        let isnum = /^\d+$/.test(value);
        let button = component.find('disablebuttonid');
        var validdata = helper.validateRequired(component,event, helper);
        if(value.length<9 && isnum){
            component.set("v.ssnvalidationError" , true);
        }else{
            component.set("v.ssnvalidationError" , false);
        }
        
        if(!component.get("v.dobvalidationError") &&  !component.get("v.ssnvalidationError") && validdata==true){           
            button.set('v.disabled',false);
        }else{
            button.set('v.disabled',true); 
        }        
    },
    closenavigate:function(component,event,helper){
        //alert('close');
        /* var navEvt = $A.get("e.force:navigateToSObject");   
        navEvt.setParams({ 
            "recordId": component.get("v.caseRecordID"),
            "slideDevName": "detail"
        });  
        navEvt.fire();*/
        //component.set("v.showTable",false);
        var compEvent = component.getEvent("closeEvent");
		compEvent.fire();
        //$A.get('e.force:refreshView').fire();
    },
    updateEnrolle :function(component, event, helper){
        let action = component.get("c.updateEnrolleData"); 
        var selectedEnrolleData = component.get("v.updateEnrolle");
        selectedEnrolleData.Id=component.get("v.enrollee.id");
        selectedEnrolleData.First_Name__c = component.get("v.enrollee.firstName");
        selectedEnrolleData.MiddleName__c=component.get("v.enrollee.middleName");
        selectedEnrolleData.Last_Name__c = component.get("v.enrollee.lastName");
        selectedEnrolleData.SSN__c	= component.get("v.enrollee.SSN");
        selectedEnrolleData.CorrectedUpdatedSSN__c =component.get("v.enrollee.updatedSSN");
        //DateOfBirth: $A.localizationService.formatDate(component.get("v.DateOfBirth");'YYYY-MM-DD');
        selectedEnrolleData.Date_of_Birth__c=component.get("v.enrollee.DateOfBirth");
        selectedEnrolleData.Gender__c= component.get("v.enrollee.gender");
        selectedEnrolleData.Employee_ID__c= component.get("v.enrollee.EmployeeId");
        selectedEnrolleData.Relationship__c= component.get("v.enrollee.relationship");
        selectedEnrolleData.Address__c= component.get("v.enrollee.address");
        selectedEnrolleData.City__c= component.get("v.enrollee.city");
        selectedEnrolleData.State__c= component.get("v.enrollee.state");
        selectedEnrolleData.Zip__c= component.get("v.enrollee.zip");
        selectedEnrolleData.HomePhone__c= component.get("v.enrollee.HomePhone");
        selectedEnrolleData.PrimaryCarePhysician__c= component.get("v.enrollee.PrimaryCarePhysician");
        selectedEnrolleData.PrimaryCareDentist__c= component.get("v.enrollee.PrimaryCareDentist");
        selectedEnrolleData.AnnualSalary__c=component.get("v.enrollee.anuualSalary");
        selectedEnrolleData.CoordinationofBenefitsBegin_Date__c=component.get("v.enrollee.cobBeginDate");
        selectedEnrolleData.CoordinationofBenefitsEnd_Date__c=component.get("v.enrollee.cobEndDate");
        selectedEnrolleData.MedicarePartAStartDate__c=component.get("v.enrollee.medCareAStrtDate");
        selectedEnrolleData.MedicarePartAEndDate__c=component.get("v.enrollee.medCareAEndDate");
        selectedEnrolleData.MedicarePartBStartDate__c=component.get("v.enrollee.medCareBStrtDate");
        selectedEnrolleData.MedicarePartBEndDate__c=component.get("v.enrollee.medCareBEndDate");
        selectedEnrolleData.MedicarePartDStartDate__c=component.get("v.enrollee.medCareDStrtDate");
        selectedEnrolleData.MedicarePartDEndDate__c=component.get("v.enrollee.medCareDEndDate");
        selectedEnrolleData.PriorCoverageBeginDate__c=component.get("v.enrollee.priorCovBegnDate");
        selectedEnrolleData.PriorCoverageEndDate__c=component.get("v.enrollee.priorCovEndDate");
        selectedEnrolleData.ExistingPatient__c=component.get("v.enrollee.existingPatient");
        selectedEnrolleData.Email__c = component.get("v.enrollee.emailAttr");
        selectedEnrolleData.DeliveryPreference__c=component.get("v.enrollee.deliveryPreffered");
        
        //alert(component.get("v.editEnrollee"));
        if(component.get("v.editEnrollee") == false){
        		var compEvent = component.getEvent("closeEvent");
                compEvent.setParams({"updatedData":selectedEnrolleData,
                                     "index":component.get("v.index"),
                                     "enrolleId":''});
				compEvent.fire();
        }else{
        
       
        console.log(JSON.stringify(selectedEnrolleData));
        
        //alert(component.get("v.enrollee.id"));
        action.setParams({"enrolleId":component.get("v.enrollee.id"),"updateData":selectedEnrolleData,"caseId":component.get("v.caseRecordID")});
        action.setCallback( this, function( response ) {
            let state = response.getState();
            var reqData = response.getReturnValue();
            //alert(reqData);
            if( state === "SUCCESS") {
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    
                    "type":"success",
                    "message": "The Enrollee has been updated successfully."
                });
                toastEvent.fire();
                var compEvent = component.getEvent("closeEvent");
                compEvent.setParams({"updatedData":selectedEnrolleData,
                                     "index":component.get("v.index"),
                                     "enrolleId":reqData});
				compEvent.fire();
            }
        });
        $A.enqueueAction(action);
        }
    },
    closeModel:function(component,event,helper){
        //window.location.reload();
        $A.get('e.force:refreshView').fire();
    },
    validateDate : function(component, event, helper){
        helper.noFuturedate(component);
    }
})