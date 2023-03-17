({ 
    getaddressdetails: function(component,event,helper) {
      
var pagerefarance = component.get("v.pagerefaranceobj").state; 
    var action = component.get("c.findMemberInfo");
        action.setParams({ srk : pagerefarance.c__srk,
                          MemberId : pagerefarance.c__memberid});

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                component.set("v.AddOnFilePersonWrapper",response.getReturnValue());
                component.set("v.AddOnFilePersonWrappercopy",response.getReturnValue());


            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
},
	requirdmessgevalidationhelper: function(component,targetcmp) {
		targetcmp.setCustomValidity("Error: You must enter a value."); 
                targetcmp.reportValidity(); 

    },
    submithelper: function(component,event,helper) {
       var matformsmapstr = JSON.stringify(component.get("v.matformsmap"));
        helper.showspinnerhelper(component,event,helper);
        
        var AddOnFilePersonWrapper = component.get("v.AddOnFilePersonWrapper");
        if(component.get("v.addressTypeSelected")=="AlternateAddress"){
            AddOnFilePersonWrapper.personZipCode = component.find('altAddzipinputid').get("v.value");
            AddOnFilePersonWrapper.personState = component.find('altAddstateinputid').get("v.value");
            AddOnFilePersonWrapper.personCity = component.find('altAddCityinputid').get("v.value");
            AddOnFilePersonWrapper.personAddTwo = component.find('altAddAddress2inputid').get("v.value");
            AddOnFilePersonWrapper.personAddOne = component.find('altAddAddress1inputid').get("v.value");
            AddOnFilePersonWrapper.personOrganization2 = component.find('altAddorg2inputid').get("v.value");
            AddOnFilePersonWrapper.personSuffix = component.find('altpersonSuffixinputid').get("v.value");
            AddOnFilePersonWrapper.personLastName = component.find('altpersonLastNameinputid').get("v.value");
            AddOnFilePersonWrapper.personMiddleName = component.find('altpersonMiddleNameinputid').get("v.value");
            AddOnFilePersonWrapper.personFirstName = component.find('altpersonFirstNameinputid').get("v.value");  
        }
        var pagerefarance = component.get("v.pagerefaranceobj")
    var action = component.get("c.btnSubmit");
        action.setParams({ recepientId : pagerefarance.c__srk,
                          AddOnFilePersonWrap:AddOnFilePersonWrapper,
                          BusinessUnit:component.get("v.bussinessunit"),
                          selectedAddress:component.get("v.addressTypeSelected"),
                          matformids:matformsmapstr});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var isSuccess = response.getReturnValue().isSuccess;
        helper.hidespinnerhelper(component, event,helper);
                if(isSuccess){
                     component.set("v.submitbutndisable",true);
                    component.set("v.ordersubmitted",false);
                   
                    localStorage.setItem(component.get("v.AddOnFilePersonWrapper").recepientId+'_orderSubmitted','true');
                    
                    helper.toastmessagehelper(component,event,helper,'Success','Order submitted.','success');
                }else{
                      helper.toastmessagehelper(component,event,helper,'Error','Order failed.','error');

                }
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                }
            }
        });
        $A.enqueueAction(action);
},
    toastmessagehelper:function(component,event,helper,title,message,type){
         var toastEvent = $A.get("e.force:showToast");
    toastEvent.setParams({
        "title":title,
        "message": message,
        "type": type,
        "duration":'20000'
    });
    toastEvent.fire();
    },
     showspinnerhelper: function(component, event,helper) {
            component.set("v.Loadingspinner", true);
    },
    hidespinnerhelper: function(component, event,helper) {
            component.set("v.Loadingspinner", false);
    }
})