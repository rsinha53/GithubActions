({
    noFuturedate  : function (component){
        var today = new Date();        
        var dd = today.getDate();
        var mm = today.getMonth() + 1; 
        var yyyy = today.getFullYear();
        let button = component.find('disablebuttonid');
        var validdata = this.validateRequired(component,event, this);
       if(dd < 10){
            dd = '0' + dd;
        } 
       if(mm < 10){
            mm = '0' + mm;
        }
       
        var todayFormattedDate = yyyy+'-'+mm+'-'+dd;
        if(component.get("v.enrollee.DateOfBirth") != '' && component.get("v.enrollee.DateOfBirth") > todayFormattedDate){
            component.set("v.dobvalidationError" , true);
            button.set('v.disabled',true);
        }else{
            button.set('v.disabled',false);
            component.set("v.dobvalidationError" , false);
        }
         if ($A.util.isUndefinedOrNull(component.get("v.enrollee.DateOfBirth"))) {
             button.set('v.disabled',true);
         }else{
             button.set('v.disabled',false);
         }
    },
	validateRequired:function(component, event, helper){
        //debugger;
        var valid=false;
        var counter = 0;
        console.log(counter);
        var reltnion = component.find("reltnion");
        if (!$A.util.isUndefinedOrNull(reltnion)) {
            var reltnionValid = reltnion.get("v.validity");
            
            if(reltnionValid.valid == false){
                counter =counter+1;
            }
            reltnion.showHelpMessageIfInvalid();
        }
        
        var firstName = component.find("firstname");
        if (!$A.util.isUndefinedOrNull(firstName)) {
            var firstNameValid = firstName.get("v.validity");
            
            if(firstNameValid.valid == false){
                counter =counter+1;
            }
            firstName.reportValidity();
        }
        var lastname = component.find("lastname");
        if (!$A.util.isUndefinedOrNull(lastname)) {
            var lastnameValid = lastname.get("v.validity");
            
            if(lastnameValid.valid == false){
                counter =counter+1;
            }
            
            lastname.reportValidity();
        }
        var dateofbirth = component.find("dateofbirth");
        if (!$A.util.isUndefinedOrNull(dateofbirth)) {
            var dateofbirthValid = dateofbirth.get("v.validity");
            
            if(dateofbirthValid.valid == false){
                counter =counter+1;
            }
            dateofbirth.reportValidity();
        }       
        
        var genID = component.find("genID");
        if (!$A.util.isUndefinedOrNull(genID)) {
            var genIDValid = genID.get("v.validity");
            //alert(genIDValid);
            
            if(genIDValid.valid == false){
                counter =counter+1;
            }
            console.log(genIDValid.ValidityState);
            genID.showHelpMessageIfInvalid();
            //genID.reportValidity();
        }
        
        var empID = component.find("empID");
        if (!$A.util.isUndefinedOrNull(empID)) {
            var empIDValid = empID.get("v.validity");
            
            if(empIDValid.valid == false){
                counter =counter+1;
            }
            empID.reportValidity();
        }
        
        var ssnId = component.find("ssnId");
        if (!$A.util.isUndefinedOrNull(ssnId)) {
            var ssnIdValid = ssnId.get("v.validity");
            
            if(ssnIdValid != undefined){
            if(ssnIdValid.valid == false){
                counter =counter+1;
            }
            }
            ssnId.reportValidity();
        }
        var addrs = component.find("addrs");
        if (!$A.util.isUndefinedOrNull(addrs)) {
            var addrsValid = addrs.get("v.validity");
            
            if(addrsValid.valid == false){
                counter =counter+1;
            }
            addrs.reportValidity();
        }
        var cty = component.find("cty");
        if (!$A.util.isUndefinedOrNull(cty)) {
            var ctyValid = cty.get("v.validity");
            
            if(ctyValid.valid == false){
                counter =counter+1;
            }
            cty.reportValidity();
        }        
        var stat = component.find("stat");
        if (!$A.util.isUndefinedOrNull(stat)) {
            var statValid = stat.get("v.validity");
            
            if(statValid.valid == false){
                counter =counter+1;
            }
            stat.reportValidity();
        }
        
        var zp = component.find("zp");
        if (!$A.util.isUndefinedOrNull(zp)) {
            var zpValid = zp.get("v.validity");
            
            if(zpValid.valid == false){
                counter =counter+1;
            }
            zp.reportValidity();
        }
         let button = component.find('disablebuttonid');   
        //alert(counter);
        if(counter>0){
            
             button.set('v.disabled',true);
            valid= false;
        }
        else{
             button.set('v.disabled',false);
            valid=true;
        }
        return valid;     
    },
})