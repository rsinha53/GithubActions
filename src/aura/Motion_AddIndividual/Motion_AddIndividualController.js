({
	doInit : function(component, event, helper) {
		helper.populatePickListValues(component, event, helper);
	},
    clear: function(component, event, helper) {
        helper.clearSearch(component, event, helper);
           
    },
    createIndividualRecord : function(component, event, helper){
        helper.createIndividualAccount(component, event, helper);
    },
    
    addHyphen : function (cmp, event, helper) {        
        // formatting the phone number into xxx-xxx-xxxx while typing
        var fieldValue = cmp.get("v.phoneNumber");
        if(fieldValue!= undefined && fieldValue!=null && fieldValue!=''){
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
            cmp.set("v.phoneNumber",newValue);
        }
    },
    maskphonenumberkeyup: function (component, event, helper) {
        var regEx = /[^0-9 -]/g;
        var fieldValue = component.get("v.phoneNumber");
        if (fieldValue!= undefined && fieldValue.match(regEx)) {
            component.set("v.phoneNumber", fieldValue.replace(regEx, ''));
        }
        
     },
    restrictCharacters: function (component, event, helper) {	
        var regex = new RegExp("^[0-9]+$");
        var str = String.fromCharCode(!event.charCode ? event.which : event.charCode);
        
        //Check more than 5 characters
        var zip = component.find("zipCode").get("v.value");
        if (zip !=undefined && zip.length > 4){
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
   
})