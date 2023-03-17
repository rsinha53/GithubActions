({
    onInit : function(component, event, helper) {
        
        component.set("v.toggleOCI", "slds-hide");
    },
    
    chevToggle : function(component, event, helper) {
        var iconName = component.find("chevInactive").get("v.iconName"); 
        
        if(iconName === "utility:chevrondown"){
            component.set("v.icon", "utility:chevronright");
            component.set("v.toggleName", "slds-hide");
            
        }else{
            component.set("v.icon", "utility:chevrondown");
            component.set("v.toggleName", "slds-show");
        }
    },
    
    SubmitCOBUpdate : function(component, event, helper) {
        
        var val = component.get("v.toggleOCI"); 
        component.set("v.showHide","show");
        var firstClickCheck = component.get('v.firstClickCheck');
        if(firstClickCheck){
            component.set('v.firstClickCheck',false);
            component.set('v.validationError',true);
            component.set("v.toggleOCI", "slds-show");
            component.set("v.toggleOCINo", "slds-hide");
        }
        else if(val === "slds-hide"){
            component.set("v.toggleOCI", "slds-show");
        }else{
            var otherInsuranceIdNum = document.getElementById('otherInsuranceIdNum').value;
            var comRadioChange = component.get('v.comRadioChange');
            if(!otherInsuranceIdNum && comRadioChange!='you'){
                //component.set('v.otherInsuranceIdNumErrorMessage',true);
                component.set('v.validationError',true);
                component.set("v.toggleOCINo", "slds-show");
            }
            else{
                //component.set('v.otherInsuranceIdNumErrorMessage',false);
                component.set("v.toggleOCI", "slds-hide");
                component.set("v.toggleOCINo", "slds-hide");
                component.set('v.validationError',false);
            }
        }
        
    },
    
    onClear : function(component, event, helper) {
        var radioYeselement  = document.getElementById('rco_oci_yes');
        if(!$A.util.isEmpty(radioYeselement)){
            radioYeselement.checked = false;
        }
        var radioNoelement  = document.getElementById('rco_oci_no');
        if(!$A.util.isEmpty(radioNoelement)){
            radioNoelement.checked = false; 
        }
        // Modify by Hasara 19/07/2021
        component.set("v.toggleOCINo", "slds-hide");
        
        var otherInsuranceType = document.getElementById("otherInsuranceType");
        otherInsuranceType.value = "None";
        
        var covType = document.getElementById("covType");
        covType.value = "Medical Care";
        
        var otherInsuranceCarrierName = document.getElementById("otherInsuranceCarrierName");
        otherInsuranceCarrierName.value = "";
        
        var otherInsuranceIdNum = document.getElementById("otherInsuranceIdNum");
        otherInsuranceIdNum.value = "";
        
        //component.set("v.effectiveDate","");
        //component.set("v.endDate","");
        var effdate = component.find("effdate").set("v.value",'');
        var effdate = component.find("enddate").set("v.value",'');
        var tabKey ='#'+ component.get("v.AutodocKey")+component.get("v.idValue");
        $(tabKey).find("input.autodoc").prop("checked", false);
        $(tabKey).find("input.autodoc-case-item-resolved").prop("checked", false);
        var selected = component.get("v.comRadioChange");
        if(selected!='you'){
            component.set('v.validationError',true); 
            //component.set('v.otherInsuranceIdNumErrorMessage',true);
        }
        
    },
    
    effectiveDateChange : function(component, event, helper) {
        try{
            var ov = component.get("v.effectiveDate");
            const RegExpNumberedCaptureGroups = /([0-9]{4})-([0-9]{2})-([0-9]{2})/
            
            const matchObj = RegExpNumberedCaptureGroups.exec(ov)
            
            console.log(matchObj[0]) // "2019-12-31"
            const year = matchObj[1] // 2019
            const month = matchObj[2] // 12
            const day = matchObj[3] // 31
            
            //alert(`${month}/${day}/${year}`) // "12/31/2019"
            var neweffdate = month+'/'+day+'/'+year;
            component.set("v.newEffectiveDate",neweffdate);
        }catch (error){
            console.log("");
            
        }
    },
    
    endDateDateChange : function(component, event, helper) {
        try{
            var ov = component.get("v.endDate");
            const RegExpNumberedCaptureGroups = /([0-9]{4})-([0-9]{2})-([0-9]{2})/
            
            const matchObj = RegExpNumberedCaptureGroups.exec(ov)
            
            console.log(matchObj[0]) // "2019-12-31"
            const year = matchObj[1] // 2019
            const month = matchObj[2] // 12
            const day = matchObj[3] // 31
            
            //alert(`${month}/${day}/${year}`) // "12/31/2019"
            var neweffdate = month+'/'+day+'/'+year;
            component.set("v.newendDate",neweffdate);
        }catch (error){
            console.log("");
            
        }
    },
    
    onOCIRadioChange : function(cmp, evt, helper) {
        var selected = evt.currentTarget.value;
        cmp.set("v.comRadioChange", selected);
        var otherInsuranceIdNum = document.getElementById('otherInsuranceIdNum').value;
        console.log('otherInsuranceIdNum'+otherInsuranceIdNum);
        if(/*!otherInsuranceIdNum && */selected!='you'){
            cmp.set('v.validationError',true); 
            //cmp.set('v.otherInsuranceIdNumErrorMessage',true);
            cmp.set("v.toggleOCINo", "slds-show");
            cmp.set("v.toggleClaim", "slds-hide");
            // helper.selectInsuranceType(cmp, evt, helper);
        }
        else{
            cmp.set('v.validationError',false); 
            //cmp.set('v.otherInsuranceIdNumErrorMessage',false);
            cmp.set("v.toggleOCINo", "slds-hide");
            // cmp.set('v.disableProcessBtn',true);
        }
        
    },
    
    checkValidation: function(cmp, evt, helper) {
        var selected = cmp.get("v.comRadioChange");
        var otherInsuranceIdNum = document.getElementById('otherInsuranceIdNum').value;
        var otherInsurancePhoneNumber = document.getElementById('otherInsurancePhoneNumber').value;
        var primacyIndicator = document.getElementById('primacyIndicator').value;
        var claimNumber = document.getElementById('claimNumber').value;
        var otherInsuranceType = document.getElementById('otherInsuranceType').value;
        var otherInsuranceCarrierName = document.getElementById('otherInsuranceCarrierName').value;
        var effectiveDate = cmp.get('v.effectiveDate');
        var covType = document.getElementById('covType').value;
        
        if(otherInsuranceType =='Motor Vehicle Accident' || otherInsuranceType =='Workers Compensation'){
            cmp.set("v.toggleClaim", "slds-show");
        }else{
            cmp.set("v.toggleClaim", "slds-hide");
			document.getElementById('claimNumber').value='';
        }
        var tog = cmp.get("v.toggleClaim");
        
        console.log('-->'+otherInsuranceIdNum+'-->'+otherInsurancePhoneNumber+'-->'+primacyIndicator+'-->'+claimNumber+'-->'+otherInsuranceType+'-->'+otherInsuranceCarrierName+'-->'+effectiveDate+'-->'+covType+'-->');
        if(($A.util.isEmpty(otherInsuranceIdNum) || $A.util.isEmpty(otherInsurancePhoneNumber) || $A.util.isEmpty(primacyIndicator) || primacyIndicator=='None'|| $A.util.isEmpty(otherInsuranceType) || otherInsuranceType=='None' || $A.util.isEmpty(effectiveDate) || $A.util.isEmpty(otherInsuranceCarrierName) || (tog == 'slds-show' && $A.util.isEmpty(claimNumber)) || $A.util.isEmpty(covType) ) && selected!='you'){
            cmp.set('v.validationError',true); 
            //cmp.set('v.otherInsuranceIdNumErrorMessage',true);
        }
        else{
            cmp.set('v.validationError',false);            
            //cmp.set('v.otherInsuranceIdNumErrorMessage',false);
        }
    },
    /*selectInsuType: function(cmp, evt, helper) {
        helper.selectInsuranceType(cmp, evt, helper);
    },*/
    
    NumberCheck: function(component, event, helper){
        var val_old = document.getElementById('otherInsurancePhoneNumber').value;
        console.log('otherInsuranceIdNum'+val_old);
        var val = val_old.replace(/\D/g, '');
        var len = val.length;
        if (len >= 2){
            val = val.substring(0, 3) + '-' + val.substring(3);
        } 
        if (len >= 5){
            val = val.substring(0, 7) + '-' + val.substring(7);
            component.set("v.otherInsurancePhoneNumber",val);
        }
        
    },
    
})