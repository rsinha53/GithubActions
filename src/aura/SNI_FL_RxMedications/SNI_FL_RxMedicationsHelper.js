//US2841187: helper for RxMedications
//Author Name: Derek DuChene
({
	fetchRxMeds : function(component, event, intLimit) {

        var action = component.get("c.fetchRxMedications");
        action.setParams({
            'recordID':	component.get("v.recordId")
        });
        
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var records =response.getReturnValue();
                records.forEach(function(record){
                    record.linkName = '/'+record.Id;
                    if (record.Pharmacy_Phone_Number__c !== undefined && record.Pharmacy_Phone_Number__c !== null && record.Pharmacy_Phone_Number__c !== ''){
                    	record.formattedPhone = (record.Pharmacy_Phone_Number__c.length == 10) ? record.Pharmacy_Phone_Number__c.replace(/(\d{3})(\d{3})(\d{4})/, '($1) $2-$3'):record.Pharmacy_Phone_Number__c;
                    }
                    if(record.Refill_Date__c != undefined && record.Refill_Date__c != null){                                             
                        record.formatDate = record.Refill_Date__c.toString();
                        record.formatDate = record.formatDate.split('-')[1] + '/' + record.formatDate.split('-')[2] + '/' + record.formatDate.split('-')[0];
                    }
                });
                if(records.length > 5){
                	var recordList = [];
                	for(var i = 0; i < 5;i++){
                		recordList.push(records[i]);
                	}
                	component.set('v.lstRxM', recordList);
                	component.set('v.shortLstRxM', recordList);
                	component.set('v.showAllRxM', false);
                } else {
                	component.set('v.lstRxM', records);
                }
                component.set("v.File_count",records.length);
                component.set("v.fullLstRxM", records);
            }
        });
        
        
        $A.enqueueAction(action);
    }, 
     onChangePhoneValidation: function(component, event, helper){
        //Explicitly checking the custom validation: 
        var phoneCmp = component.find('phone');
        var phoneCmpValue = phoneCmp.get("v.value");
        //Custom regular expression for phone number
        var phoneRegexFormat = "^[0-9]*$";
        //Check for regular expression match with the field value
       
        if(!phoneCmpValue.match(phoneRegexFormat)) {
            //set the custom error message
            phoneCmp.setCustomValidity("Please enter a valid phone number.");
        } else{
            //reset the error message
            phoneCmp.setCustomValidity("");
        }
        phoneCmp.reportValidity(); 
    }
    
    
})