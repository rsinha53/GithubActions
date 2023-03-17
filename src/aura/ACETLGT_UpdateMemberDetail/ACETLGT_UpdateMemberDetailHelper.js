({
    getMemberInformation : function(component, event, helper) {
        var identifier = component.get("v.srk");
        var action = component.get("c.getSearchResults");
        var errormsg = '';
        component.set("v.isUpdating", true);
        
        // Setting the apex parameters
        action.setParams({
            srk: identifier
        });
        
        //Setting the Callback
        action.setCallback(this, function(response) {
            //get the response state
            var state = response.getState();              
            
            if (state == "SUCCESS") {
                var result = response.getReturnValue();                             
                if (!$A.util.isEmpty(result) && !$A.util.isUndefined(result)) {
                    errormsg = result.ErrorMessage;
                    if ($A.util.isEmpty(errormsg) && !$A.util.isEmpty(result.resultWrapper) && !$A.util.isUndefined(result.resultWrapper)) {
                        component.set("v.MemberdetailInd", result.resultWrapper);
                        var phoneTypeOriginal = component.get("v.phoneOptionsAll");
                        var phoneOptionsCurrent = ['Home','Work','Fax','Mobile'];
                        var phones = result.resultWrapper.Phones;
                        var uiPhones = [];
                        var primaryIndicator = '';
                        var email = result.resultWrapper.Email;
                        if(!$A.util.isUndefined(phones)) {
                            for(var i = 0; i < phones.length; i++) {
                                //  primary indicator comes as 'Primary' or ''. Adjusting it to 'Yes' or 'No'
                                //  for the display purposes
                                primaryIndicator = (phones[i].primaryIndicator == 'Primary') ? 'Yes' : 'No';
                                
                                //  push list elements to plug into the UI
                                uiPhones.push({
                                    "PhoneNumber" : phones[i].PhoneNumber, 
                                    "PhoneNumberType" : (phones[i].PhoneNumberType == undefined || phones[i].PhoneNumberType == '') ? phoneOptionsCurrent[0] : phones[i].PhoneNumberType,
                                    "WorkExt" : phones[i].WorkExt,
                                    "PrimaryIndicator" : primaryIndicator,
                                    "FromService" : (phones[i].PhoneNumberType == undefined || phones[i].PhoneNumberType == '') ? false : true,
                                    "phoneNumberTypeOG" : phones[i].PhoneNumberType,
                                    "isHomeAvailable" : true,
                                    "isWorkAvailable" : true,
                                    "isFaxAvailable" : true,
                                    "isMobileAvailable" : true
                                });
                                
                                var indexOfSelection = phoneOptionsCurrent.indexOf(phones[i].PhoneNumberType);
                                if(indexOfSelection != -1) {
                                    var removed = phoneOptionsCurrent.splice(indexOfSelection, 1);
                                } else if(phones[i].PhoneNumberType == '' || phones[i].PhoneNumberType == undefined) {
                                    //	when the service returns empty Phone Number Type, blindly set the first element from
                                    //	the remaining phone number types and remove it from the available list
                                    phoneOptionsCurrent.splice(0, 1);
                                }
                            }
                        }
                        
                        component.set("v.phones", uiPhones);
                        component.set("v.phoneOptionsCurrent", phoneOptionsCurrent);

                        
                        
                        
                        if(!$A.util.isUndefined(email)) {
                            component.set("v.email", email);
                            component.set("v.newEmailClicked", true);
                            component.set("v.isEmailFromService", true);
                        } else {
                            component.set("v.email", "");
                            component.set("v.isEmailFromService", false);
                            component.set("v.newEmailClicked", false);
                        }
                        
                        if(!$A.util.isUndefined(result.resultWrapper.firstName)){
                            component.set("v.firstname",result.resultWrapper.firstName);
                        }
                        if(!$A.util.isUndefined(result.resultWrapper.lastName)){
                            component.set("v.lastname",result.resultWrapper.lastName);
                        }
                        if(!$A.util.isUndefined(result.resultWrapper.middleName)){
                            component.set("v.middlename",result.resultWrapper.middleName);
                        }
                        if(!$A.util.isUndefined(result.resultWrapper.suffix)){
                            component.set("v.suffix",result.resultWrapper.suffix);
                        }
                        if(!$A.util.isUndefined(result.resultWrapper.gender)){
                            component.set("v.gender",result.resultWrapper.gender);
                        }
                        if(!$A.util.isUndefined(result.resultWrapper.dob)){
                            component.set("v.dob",result.resultWrapper.dob);
                        }
                        if(!$A.util.isUndefined(result.resultWrapper.FullSSN)){
                            var fullssn = result.resultWrapper.FullSSN;
                            component.set("v.fullssn",result.resultWrapper.FullSSN);
                            component.set("v.ssn",result.resultWrapper.FullSSN);
                        }
                        
                        var addresslist = result.resultWrapper.Addresses;
                        var addressnewlist=[];
                        var addtypelist = ['Home','Work','Mail'];
                        if(!$A.util.isUndefined(addresslist)){     
                            for(var i=0; i<addresslist.length; i++){
                                let address = {};
                                address.addressTypeCode = addresslist[i].AddressType;
                                address.addressLine1 = addresslist[i].AddressLine1;
                                address.addressLine2 = addresslist[i].AddressLine2;
                                address.city = addresslist[i].City;
                                address.stateCode = addresslist[i].State;
                                address.postalCode = addresslist[i].Zip;
                                addressnewlist.push(address);
                                const index = addtypelist.indexOf(address.addressTypeCode);
                                if(index > -1) {
                                  addtypelist.splice(index, 1);
                                }
                            }  
                        }
                        for(var k=0; k<addtypelist.length; k++){
                            let addresswrap3 = {};
                            addresswrap3.addressTypeCode = addtypelist[k];
                            addresswrap3.addressLine1 = '';
                            addresswrap3.addressLine2 = '';
                            addresswrap3.city = '';
                            addresswrap3.stateCode = '';
                            addresswrap3.postalCode = ''; 
                            addressnewlist.push(addresswrap3);
                        }
                        component.set("v.addresslist",addressnewlist);

                        var tabKey = component.get("v.AutodocKey");

                        setTimeout(function(){
                        //alert("Test");
                        window.lgtAutodoc.initAutodoc(tabKey);
            
                        },1);
                    }else{
                        helper.displayToast('Error!', errormsg, component, helper, event);
                    }
                }
                component.set("v.isUpdating", false);
            } else if (state == "ERROR") {
                component.set("v.MemberdetailInd");
                component.set("v.isUpdating", false);
            }
            //helper.hideSpinner2(component,event,helper);
        });
        
        //adds the server-side action to the queue        
        $A.enqueueAction(action);
    },
    
    displayToast: function(title, messages, component, helper, event){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": messages,
            "type": "error",
            "mode": "dismissible",
            "duration": "10000"
        });
        toastEvent.fire();
        return;
    },
     
    getStateOptions: function (cmp) {
        var action = cmp.get('c.getStateValues');
        action.setCallback(this, function (actionResult) {
            var stateOptions = [];
            var state = actionResult.getState();              
            if (state == "SUCCESS") {
                if(actionResult.getReturnValue() && actionResult.getReturnValue()!=null){
                    for (var i = 0; i < actionResult.getReturnValue().length; i++) {
                        stateOptions.push({
                            label: actionResult.getReturnValue()[i].MasterLabel,
                            value: actionResult.getReturnValue()[i].MasterLabel
                        });
                    }
                }
            }
            stateOptions.unshift({
                label: '--None--',
                value: ''
            });
            cmp.set('v.stateOptions', stateOptions);
        });
        $A.enqueueAction(action);
    },    
})