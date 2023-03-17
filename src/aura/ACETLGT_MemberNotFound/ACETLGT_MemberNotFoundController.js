({
    doInit : function(component, event, helper) {
        component.set("v.memberid",component.get("v.pageReference").state.c__Id);
        component.set("v.FirstName",component.get("v.pageReference").state.c__fstname);
        component.set("v.LastName",component.get("v.pageReference").state.c__lstname);
        component.set("v.dateOfBirth",component.get("v.pageReference").state.c__dob);
        component.set("v.zipcode",component.get("v.pageReference").state.c__zipcode);
        component.find('selOption').find('selstate').set("v.value",component.get("v.pageReference").state.c__state);
        component.set("v.intractType",component.get("v.pageReference").state.c__intractType);
    },
    restrictCharacters: function (component, event, helper) {	
        var regex = new RegExp("^[0-9]+$");
        var str = String.fromCharCode(!event.charCode ? event.which : event.charCode);
        
        //Check more than 5 characters
        var zip = component.get("v.zipcode");
        if (zip.length > 4){
            event.preventDefault();
            return false;
        }
        
        if (regex.test(str)){
            return true;
        }else{ 
            event.preventDefault();
            return false;
        }
    },
    maskphonenumberkeydown: function (component, event, helper) {	
        var regex = new RegExp("^[0-9]+$");
        var str = String.fromCharCode(!event.charCode ? event.which : event.charCode);
        if (regex.test(str)){
            return true;
        }else{ 
            event.preventDefault();
            return false;
        }
        
    },
    addHyphen : function (cmp, event, helper) {        
        // formatting the phone number into xxx-xxx-xxxx while typing
        var fieldValue = cmp.get("v.PhoneNumber");
        if(fieldValue!= undefined){
            fieldValue = fieldValue.replace(/\D/g,'');
            var newValue = '';
            var count = 0;
            
            while(fieldValue.length > 3) {
                if(count < 2) {
                    newValue += fieldValue.substr(0, 3) + '-';
                    fieldValue = fieldValue.substr(3);
                    count++;
                }
                if(count == 2) {
                    break;
                }			
            }
            newValue += fieldValue;
            cmp.set("v.PhoneNumber",newValue);
        }
    },
    maskphonenumberkeyup: function (component, event, helper) {
        var regEx = /[^0-9 -]/g;
        var fieldValue = component.get("v.PhoneNumber");
        if (fieldValue!= undefined && fieldValue.match(regEx)) {
            component.set("v.PhoneNumber", fieldValue.replace(regEx, ''));
        }
        
     },
    submitresults: function (component, event, helper) {
        var phonenum = component.get("v.PhoneNumber");
        var zipcode = component.get("v.zipcode");
        var firstname = component.get("v.FirstName");
        var lastname = component.get("v.LastName");
        var intType = component.get("v.intType");
        var EmpName = component.get("v.EmployerName");
        var GrpNumber = component.get("v.GroupNumber");
        var state = component.find('selOption').find('selstate').get("v.value");
        var dob = component.get("v.dateOfBirth");
        var zip = component.get("v.zipcode");
        var membid = component.get("v.memberid");
        var name =  firstname+" "+lastname;
        var isAllValid = false;
        var zipvalid =false;
        var phonevalid =false;
        var mandatoryFields = ["phonenum", "firstname", "lastname"];
        isAllValid = helper.validateAllFields(component, event, mandatoryFields);
        
        console.log("check point 1"); 
        
        if (isAllValid) {             
            if (zipcode.length > 0 && zipcode.length < 5){
                component.find("zipcode").setCustomValidity("Error: Enter a valid 5 digit Zip Code");        
            }else{
                component.find("zipcode").setCustomValidity(""); 
                zipvalid=true;
            }
            component.find("zipcode").reportValidity(); 
            phonenum = phonenum.replace(/-/g, "");
            if(phonenum.length < 10){
                component.find("phonenum").setCustomValidity("Error: Enter a valid 10 digit number");
            }else{
                component.find("phonenum").setCustomValidity(""); 
                phonevalid = true;
            }
            component.find("phonenum").reportValidity(); 
            
            console.log("check point 2"); 
        }
        else {
            if ($A.util.isEmpty(lastname) || $A.util.isEmpty(firstname) ||$A.util.isEmpty(phonenum)){             
                helper.fireToast("Error: Invalid Data", "Review all error messages below to correct your data.");
                if (zipcode.length > 0 && zipcode.length < 5){
                    component.find("zipcode").setCustomValidity("Error: Enter a valid 5 digit Zip Code");        
                }else{
                    component.find("zipcode").setCustomValidity(""); 
                    zipvalid=true;
                }
                component.find("zipcode").reportValidity(); 
                if(phonenum != undefined && phonenum.length > 0 && phonenum.length < 10){
                    phonenum = phonenum.replace(/-/g, "");
                    if(phonenum.length < 10){
                        component.find("phonenum").setCustomValidity("Error: Enter a valid 10 digit number");
                    }else{
                        component.find("phonenum").setCustomValidity("");  
                        phonevalid = true;
                    }
                    component.find("phonenum").reportValidity(); 
                }
            }
            
            console.log("check point 3"); 
            
        }   
        if(isAllValid == true && zipvalid==true && phonevalid==true){
            console.log("check point 4"); 
            var action = component.get("c.createInteraction");
            action.setParams({
                "interactionType": intType,
                "OriginatorType": "Other",
                "EmployerName": EmpName,
                "LastName": lastname,
                "FirstName": firstname,
                "PhoneNumber": phonenum,
                "dob": dob,
                "State": state,
                "Zip": zip,
                "GroupNum": GrpNumber,
                "NotFoundFLowName": "MemberNotFoundFlow"
            });
            
            action.setCallback(this, function(a) {
                var result = a.getReturnValue();
                console.log(result);
                var state1 = a.getState();
                if (state1 === "SUCCESS") {
                    if(!$A.util.isEmpty(phonenum)){
                        phonenum = phonenum.slice(0,3) + "-" + phonenum.slice(3,6) + "-" + phonenum.slice(6);
                    }
                    if(!$A.util.isEmpty(dob)){
                        dob = helper.getFormattedDate(component, event, dob);
                    } 
                    
                    console.log("check point 5"); 
                    helper.navigate(component,event,helper,result,result.Id,name,lastname,firstname,intType,EmpName,GrpNumber,state,dob,zip,membid,phonenum);
                }
                else{
                    console.log('Error resp : '+a.getError());   
                }     
            });
            $A.enqueueAction(action);
        }
    },
    cancelresults: function (component, event, helper) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            var focusedTabId = response.tabId;
            workspaceAPI.closeTab({tabId: focusedTabId});
        })
        .catch(function(error) {
            console.log(error);
        });
        
    }
})