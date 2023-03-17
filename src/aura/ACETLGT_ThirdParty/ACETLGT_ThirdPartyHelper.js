({
	createTP : function(cmp,helper,event){        

        var subject = cmp.get("v.subId");
        var fn = cmp.get("v.firstname") ;
        var ln = cmp.get("v.lastName");
        var phoneNum = cmp.get("v.phonenum");
        var intid = cmp.get("v.intID");
        var tpid = cmp.get("v.tpId");
        console.log("Interaction ID :: "+intid);
        var unFormattedValue = cmp.get("v.phonenum");
        if(phoneNum != undefined && phoneNum != null && phoneNum != ''){
            phoneNum = phoneNum.replace("-","");
        	phoneNum = phoneNum.replace("-","");
        }
        if(phoneNum != undefined ){
            if(phoneNum.length < 10){
                phoneNum = '';
       			var fieldval = cmp.find("phfieldId");
            	fieldval.setCustomValidity('Enter a valid 10 digit number');
            	fieldval.showHelpMessageIfInvalid();
            }
            else if(phoneNum.length > 11){
                field1.setCustomValidity('');
                fieldval.showHelpMessageIfInvalid();
            }
                else{
                    phoneNum = unFormattedValue;
                }
    	}
        
        var otherorgin = cmp.get("v.otherOriginator");
        var grpName = cmp.get("v.grpName");
        console.log('---1---->'+fn+'------->'+ln+'------->'+phoneNum+'----->'+otherorgin+'----->'+grpName+ ' :: '+tpid);
        if(fn != undefined && fn != null && fn.trim() != ''&&
          ln != undefined && ln != null && ln.trim() != ''&&
          phoneNum != undefined && phoneNum != null && phoneNum.trim() != ''&&
           otherorgin != undefined && otherorgin != null && otherorgin.trim() != ''){
            console.log("inside apex");
            
        	cmp.set("v.addTPBlock", false);
            var action = cmp.get("c.addNewThirdParty");
            action.setParams({
                "FirstName": fn,
                "LastName": ln,
                "PhoneNum": phoneNum,
                "originatortype": otherorgin,
                "GroupName": grpName,
                "SubjectId": subject,
                "InteractionId": intid,
                "tdId": tpid 
            });
            
            action.setCallback(this, function(a) {
                //console.log('---2---->'+a.status());
                var result = a.getReturnValue();
                cmp.set("v.originator", '');
                console.log('---3---->'+JSON.stringify(result));
                cmp.set("v.TPrecords", result);
                if (!$A.util.isEmpty(cmp.get("v.TPrecords"))){
                    cmp.set("v.tpRecordsAvailable", true);
                    cmp.set("v.tpAvailable", true);
                    //this.getAllTP();
                }

                
                //cmp.set("v.tpAvailable", true);
                cmp.set("v.addTPBlock", false);
            });
            
            $A.enqueueAction(action);
        }
        else{
            var allValid = cmp.find("fieldId").reduce(function (validSoFar, inputCmp) {
                inputCmp.showHelpMessageIfInvalid();
                return validSoFar && !inputCmp.get("v.validity").valueMissing;
            }, true);
            var field1 = cmp.find("phfieldId");
            //alert('======field1====>>'+ field1);
           // alert('======field1====>>'+ field1.get("v.validity").tooShort);
            if(field1.get("v.validity").valueMissing) {
                field1.showHelpMessageIfInvalid();
            }
            if(field1.get("v.validity").tooShort) {
                field1.showHelpMessageIfInvalid();
            }
            
        }
        console.log('---OOoriginator--1-->'+ cmp.get("v.originalOriginator")+'======'+cmp.get("v.originator"));
        if((cmp.get("v.originator") == undefined || cmp.get("v.originator") == null || cmp.get("v.originator") == '' || cmp.get("v.originator") == 'Third Party')&& cmp.get("v.originalOriginator") != 'Third Party')
        	cmp.set("v.originator", cmp.get("v.originalOriginator"));
        console.log('---originator--1-->'+ cmp.get("v.originator"));

        //MAKE SURE TO SET ALL VALUES TO EMPTY
        cmp.set("v.firstname", '');
        cmp.set("v.lastName", '');
        cmp.set("v.phonenum", '');
        cmp.set("v.grpName", '');
        cmp.set("v.otherOriginator", '');       
        
        
    },
    
    getAllTP : function(cmp,helper,event){        

        //var subject = '003m0000017cCjIAAU'; 
        var subject = '0030j00000Kbp4IAAR'; 
        console.log('SUBS :: '+cmp.get("v.subId"));
        subject = cmp.get("v.subId");
        var action = cmp.get("c.queryThirdParties");
        action.setParams({
            "SubjectId": subject
        });
        
        action.setCallback(this, function(a) {
            
            var result = a.getReturnValue();
            console.log('---4---->'+result);
            cmp.set("v.TPrecords", result);
            cmp.set("v.tpAvailable", true);
            
            
            //if(result == undefined || result == null || result == '')
            if ($A.util.isEmpty(result)){
                cmp.set("v.tpRecordsAvailable", false);                
            }    

        });
        $A.enqueueAction(action);
    },

    validatePhoneNumberChars : function(component, event, helper) {
        //  phone number field should only contain number and - mark
        var regEx = /[^0-9 -]/g;
        var fieldValue = component.get("v.phonenum");
        if (fieldValue!= undefined && fieldValue.match(regEx)) {
            component.set("v.phonenum", fieldValue.replace(regEx, ''));
        }		
    },
    
    fetchOtherOriginatorPicklistValues : function(component, event, helper) {
        var action = component.get("c.getOtherOriginatorPicklistValues");
        action.setParams({
                "objectName": 'Third_Party__c',
                "fieldName": 'Other_Originator__c'
        });
         action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();                           
                component.set("v.OriginatorMap", result);
            }
        });
        $A.enqueueAction(action);   
    },
})