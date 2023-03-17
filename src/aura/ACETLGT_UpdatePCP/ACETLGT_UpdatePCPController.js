({
    doInit : function(component, event, helper) {
      // var today = $A.localizationService.formatDate(new Date(), "MM/DD/YYYY");
        var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
    	component.set('v.pcpDate', today); 
    },
    updatePCPModal : function(component, event, helper) {
        helper.showSpinner(component);
        helper.getPCPVals(component, helper); 
        component.set("v.showUpdatePCPModal",true);
    },
    
    closePCPModal: function(component, event, helper) {
        component.set("v.showUpdatePCPModal",false);  
        component.set("v.pcpDate","");
        component.set("v.isFailedUpdate",false);
        component.set("v.dateError", "");
        component.set("v.isExistingPatient", false);
        var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
    	component.set('v.pcpDate', today); 
    },
        
    onExistingPatientChange: function(component, event, helper) {
        var val = event.getSource().get('v.checked');
        component.set('v.isExistingPatient',val);
    },
        
    onSubmit: function(component, event, helper) {
        helper.showSpinner(component);	//	show spinner till response is back
		var effDatePicker = component.find('expdate');	//	get date picker to show/hide error styles
        $A.util.removeClass(effDatePicker, 'invalid_date');	//	remove error styles if already added
        
        var hgltPanel = component.get("v.highlightPanel"); 
        var detailResults = component.get("v.detailResult");
        var isExistingPatient = component.get("v.isExistingPatient");
        var currentpcpAssignmentType = component.get("v.PCPRole");
        var effectiveDate_val = component.find('expdate').get("v.value");
        var pcpObgnID = component.get("v.pcpObgnID");
        var memId_val,scrId_val,groupNumber_val,dob_val,relationshipcode_val;
        if(hgltPanel != undefined && hgltPanel!= null){
            memId_val = hgltPanel.MemberId;
            scrId_val = hgltPanel.SubscriberId;
            groupNumber_val = hgltPanel.GroupNumber; 
            dob_val = (hgltPanel.MemberDOB!= null)?hgltPanel.MemberDOB.split(' ')[0]:'';
            relationshipcode_val = hgltPanel.subjectRelationCode; 
        }
        var lastName_val = component.get("v.lName");
        var firstname_val = component.get("v.fName");;
        var middleName_val = component.get("v.mName");
        var nameSuffix_val = component.get("v.suffixName");
        var ssn_val = window.atob(component.get("v.ssn"));
        var gender_val = component.get("v.memGender"); 
        var npiType_val = 'NPI';
        var npiVal_val = detailResults.generalInfo.npi;
        var existpatientindicator_val = '';
        
        middleName_val = (middleName_val!=null && middleName_val!=undefined)?middleName_val:'';  
        nameSuffix_val = (nameSuffix_val!=null && nameSuffix_val!=undefined)?nameSuffix_val:'';
        ssn_val = (ssn_val!=null && ssn_val!=undefined)?ssn_val:'';
        
        var date1 = new Date(effectiveDate_val);//mm/dd/yyyy
        var date2 = new Date();//mm/dd/yyyy
        var timeDiffrence = Math.abs(date2.getTime() - date1.getTime());
        var differDays = Math.ceil(timeDiffrence / (1000 * 3600 * 24)); 
        
        if(differDays <= 90){
            
            component.set("v.dateError", "");
            
            if(isExistingPatient == true ){
                existpatientindicator_val = 'Y';
            }else{
                existpatientindicator_val = '';
            }
            
            
            if(currentpcpAssignmentType == 'PCP' || currentpcpAssignmentType == 'PCP / OBGYN' || currentpcpAssignmentType == 'OBGYN / PCP'){
                currentpcpAssignmentType = 'PCP';
            }
            
            console.log('memId_val :', memId_val);
            console.log('scrId_val :', scrId_val);
            console.log('lastName_val :', lastName_val);
            console.log('firstname_val :', firstname_val);
            console.log('middleName_val :', middleName_val);
            console.log('nameSuffix_val :', nameSuffix_val);
            console.log('existpatientindicator_val :', existpatientindicator_val);
            
            var action = component.get("c.UpdatePCPOBGYN");
            
            action.setParams({                 
                pcpObgnID : pcpObgnID, 
                memberId : memId_val,
                currentpcpAssignmentType : currentpcpAssignmentType,
                effectiveDate : effectiveDate_val,
                scrId : scrId_val,
                groupNumber : groupNumber_val,
                lastName : lastName_val,
                firstName : firstname_val,
                middleName : middleName_val,
                nameSuffix : nameSuffix_val,
                ssn : ssn_val,
                gender : gender_val,
                dob : dob_val,
                relationshipcode : relationshipcode_val,
                npiType : npiType_val,
                npiVal : npiVal_val,
                existpatientindicator : existpatientindicator_val                
            });
            
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {                    
                    var result = response.getReturnValue();
                    if(!$A.util.isEmpty(result) && !$A.util.isUndefined(result))  {                                              
                        if(result.Success){
                            component.set("v.message",'Update successful');
                            component.set("v.isSuccessUpdate",true);
                            helper.getPCPVals(component,helper); 
                        } else {
                            component.set("v.isFailedUpdate",true);
                            component.set("v.message",result.Message);
                        }                                                
                    }
                }
                
                helper.hideSpinner(component);	//	hide spinner
            });
            
            $A.enqueueAction(action);
            
        }else{
            //Show Date Error
            var errorMessage = $A.get("$Label.c.ACETInvalidDateRangeError");
            if(errorMessage != null && errorMessage != undefined) {
                errorMessage = errorMessage.replace('{0}', 'Effective date').replace('{1}', '90').replace('{2}', 'current date');
                component.set("v.dateError", errorMessage);            	
            }
            $A.util.addClass(effDatePicker, 'invalid_date');	// show error styles on datepicker
            helper.hideSpinner(component);	//	hide spinner
            
        }                        
    }
    
    
})