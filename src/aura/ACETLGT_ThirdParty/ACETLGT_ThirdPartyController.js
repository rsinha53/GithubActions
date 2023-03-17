({
    init: function (cmp, event, helper) {
        
    },
    
    checkLength: function (cmp, event, helper) {
        var num = cmp.get("v.phonenum");
        
        var field1 = cmp.find("phfieldId");
        if(field1.get("v.validity").tooShort) {
            field1.showHelpMessageIfInvalid();
        }
        
        if (!$A.util.isEmpty(num)){
            
            if(num.length < 12){
                //alert('---1--'); 
                field1.setCustomValidity('Enter a valid 10 digit number');
                field1.showHelpMessageIfInvalid();
            }
            if(num.length > 11){
                field1.setCustomValidity('');
                field1.showHelpMessageIfInvalid();
            }
        }            
    },
    
    addHyphen : function (cmp, event, helper) {        
        // formatting the phone number into xxx-xxx-xxxx while typing
        var fieldValue = cmp.get("v.phonenum");
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
            cmp.set("v.phonenum",newValue); 
        }
    },
    phoneNumberKeyUpHandler : function(component, event, helper) {
        
        helper.validatePhoneNumberChars(component, event, helper);
        
    },
    onTPselected:function(component, event, helper) {
        
        var selected = event.getSource().get('v.value');
        var tpoID = selected.split("||")[0];
        var originatorName = selected.split("||")[1];
        var tpRelation = selected.split("||")[2];
        //evt.getSource().get('v.value'));      
        //var tpoID = event.getSource().get("v.label");
        //var tid = event.getSource().get("v.id");
        //var tpId = event.getSource().get("v.data-tpid");
        //var tpValues = document.getElementsByName("tpRec");
        //var finalVals = JSON.stringify(tpValues);
        console.log('------selected tpValues----->'+selected);        
        console.log('------tpoID----->'+tpoID);
        console.log('------originatorName----->'+originatorName);
        console.log('------tpRelation----->'+tpRelation);
        
        component.set("v.isTPSelected", true);
        
        component.set("v.originator", originatorName);
        component.set("v.tpRelation", tpRelation);
        
        //Sets the selected TP to the Interactions
        var intid = component.get("v.intID");
        console.log("Interaction ID :: "+intid);
        
        var action = component.get("c.setInteractions");
        action.setParams({
            "intId": intid,            
            "tpId": tpoID
        });
        
        action.setCallback(this, function(a) {
            
            var result = a.getReturnValue();
            console.log('---4---->'+JSON.stringify(result));
            component.set("v.intUpdated", result);           
            
            /*Run the spinner
            if ($A.util.isEmpty(result))
                cmp.set("v.tpRecordsAvailable", false);
            */    
            
        });
        $A.enqueueAction(action);
        
        
        
    },
    closeModal: function(component, event, helper) {
        // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
        var compEvent = component.getEvent("tpevent");
        component.set("v.showTPpopUp", false);
        if (!component.get("v.isTPSelected")){
            console.log('TP Not selected');
            console.log('Original Originator :: '+component.get("v.originalOriginator"));
            console.log('Originator :: '+component.get("v.originator"));
            
            compEvent.setParams({ "isTPModalOpen" : component.get("v.showTPpopUp"),
                                 "originator" : component.get("v.originalOriginator")	});
            
            
        }else{
            
            console.log('TP selected');
            console.log('---OOoriginator--2-->'+ component.get("v.originalOriginator") +'======='+component.get("v.originator"));
            if((component.get("v.originator") == undefined || component.get("v.originator") == null || component.get("v.originator") == '' || component.get("v.originator") == 'Third Party') && component.get("v.originalOriginator") != 'Third Party'){
                component.set("v.originator", component.get("v.originalOriginator"));
                console.log('WITHOUT Originator');
            }
            
            
            
            console.log('---originator--2-->>> tpRelation'+ component.get("v.originator")+ component.get("v.tpRelation"));
            
            if(component.get("v.originator") != undefined && component.get("v.originator") != null && component.get("v.originator") != '' && component.get("v.tpRelation") != undefined && component.get("v.tpRelation") != null && component.get("v.tpRelation") != ''){
                
                /*if (component.get("v.originalOriginator") == 'Third Party' && $A.util.isEmpty(component.get("v.originator"))){
                    component.set("v.originator", component.get("v.originalOriginator"));
                }*/
                
                compEvent.setParams({ "isTPModalOpen" : component.get("v.showTPpopUp"),
                                     "originator" : component.get("v.originator"),
                                     "tpRelation" : component.get("v.tpRelation")});
                console.log('WITHIN Originator');                      
            }                          
            else{
                compEvent.setParams({ "isTPModalOpen" : component.get("v.showTPpopUp")	});
            }  
        }
        
        
        
        
        
        //component.set("v.originator", "");
        component.set("v.isTPSelected", false);
        compEvent.fire();
    },
    addNewTP: function(component, event, helper) {
        component.set("v.tpAvailable", false);
        component.set("v.addTPBlock", true);
        component.set("v.idEditTP", false);
        
    },
    addTP: function(component, event, helper) {  
        component.find('firstname').showHelpMessageIfInvalid();  
        component.find('lastname').showHelpMessageIfInvalid();
        component.find('phfieldId').showHelpMessageIfInvalid();
        component.find('fieldId').showHelpMessageIfInvalid();
        var validFname = component.find("firstname").get("v.validity").valid;
        var validLname = component.find("lastname").get("v.validity").valid;
        var validPhone = component.find("phfieldId").get("v.validity").valid;
        var validOrg = component.find("fieldId").get("v.validity").valid;
        
        if (validFname &&  validLname && validPhone && validOrg){
            console.log('comes valid');
            component.set("v.tpAvailable", false);            
            helper.createTP(component, event, helper);
            
            
        }
        
        
        
        //helper.getAllTP(component, event, helper);
        /*
        console.log('TPRecs valuesss :: '+!$A.util.isEmpty(component.get("v.TPrecords")));
        if (!$A.util.isEmpty(component.get("v.TPrecords")))
        component.set("v.tpRecordsAvailable", true);
        */
        
    },
    handleOptionSelected: function(cmp,event,helper){
        helper.fetchOtherOriginatorPicklistValues(cmp, event, helper);
        helper.getAllTP(cmp, event, helper);
        //cmp.set("v.TPrecords", result);
        if (!$A.util.isEmpty(cmp.get("v.TPrecords")))
            cmp.set("v.tpRecordsAvailable", true);
    },
    
    onClickTP: function(cmp, event, helper){        
        console.log('COMES');
        //var cmbutton = cmp.find('commonbtnid');
        //cmbutton.set('v.label','Update');
        
        var fname =event.currentTarget.getAttribute("data-fname");       
        var lname =event.currentTarget.getAttribute("data-lname");
        var phonenumber =event.currentTarget.getAttribute("data-phone");
        var originator =event.currentTarget.getAttribute("data-originator");
        var gpname =  event.currentTarget.getAttribute("data-groupname");
        var tpid =event.currentTarget.getAttribute("data-tpid");        
        
        console.log('Values :: '+ fname +'-'+lname+'-'+ phonenumber +'-'+originator+'-'+tpid+'-'+gpname);
        cmp.set("v.firstname", fname);     
        cmp.set("v.lastName", lname);
        cmp.set("v.phonenum", phonenumber);
        cmp.set("v.grpName", gpname);
        cmp.set("v.otherOriginator", originator);        
        cmp.set("v.tpId", tpid);               
        
        cmp.set("v.addTPBlock", true);
        cmp.set("v.idEditTP", true);
    }
    
    /*
    restrictCharacters: function(cmp, event, helper){
        
        //Check more than 40 characters
        var el = event.srcElement;
   		var idValue = el.dataset.id;
        console.log('idValue :: '+idValue);
        
        if (idValue == 'Fname'){
            var fname = cmp.get("v.firstname");
            if (fname.length > 39){
                event.preventDefault();
                retType = false;
        	}
        }
        
        if (idValue == 'Lname'){
            var lname = cmp.get("v.lastName");
            if(lname.length > 39){
           		event.preventDefault();
            	retType = false;
        	}
        }
        
          
       
        
    }
    */
})