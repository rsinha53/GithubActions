({
	doInit : function(component, event, helper) {
         setTimeout(function(){    		helper.getaddressdetails(component,event,helper);
                             },1);
    },
    onclicktypebton:function(component,event,helper){
        if(component.get("v.addressTypeSelected")!="AlternateAddress"){
        setTimeout(function(){ 
                    var AddOnFilePersonWrapper = component.get("v.AddOnFilePersonWrappercopy");
component.find('altAddzipinputid').set("v.value",AddOnFilePersonWrapper.personZipCode);
component.find('altAddstateinputid').set("v.value",AddOnFilePersonWrapper.personState);
component.find('altAddCityinputid').set("v.value",AddOnFilePersonWrapper.personCity);
component.find('altAddAddress2inputid').set("v.value",AddOnFilePersonWrapper.personAddTwo);
component.find('altAddAddress1inputid').set("v.value",AddOnFilePersonWrapper.personAddOne);
component.find('altAddorg2inputid').set("v.value",AddOnFilePersonWrapper.personOrganization2);
component.find('altpersonSuffixinputid').set("v.value",AddOnFilePersonWrapper.personSuffix);
component.find('altpersonLastNameinputid').set("v.value",AddOnFilePersonWrapper.personLastName);
component.find('altpersonMiddleNameinputid').set("v.value",AddOnFilePersonWrapper.personMiddleName);
component.find('altpersonFirstNameinputid').set("v.value",AddOnFilePersonWrapper.personFirstName);                              }, 1);
        }
    },
    
    validateandsubmit: function(component, event, helper) {
        if(component.get("v.addressTypeSelected") =='AddressOnFile'){
                        helper.submithelper(component,event,helper);
        }else{
        var isvalid = 'true';
       var Address1inputcmp = component.find('altAddAddress1inputid');
        if($A.util.isEmpty(Address1inputcmp.get("v.value"))){
            isvalid ='';
        }
        var Cityinputcmp = component.find('altAddCityinputid');
        if($A.util.isEmpty(Cityinputcmp.get("v.value"))){
                        isvalid ='';
        }
         var stateinputcmp = component.find('altAddstateinputid');
        if($A.util.isEmpty(stateinputcmp.get("v.value"))){
                        isvalid ='';
        }
         var zipinputcmp = component.find('altAddzipinputid');
        if($A.util.isEmpty(zipinputcmp.get("v.value"))){
                        isvalid ='';
        }
        if(!$A.util.isEmpty(isvalid)){
            helper.submithelper(component,event,helper);
        }
        }
    },
    handleMaterialRequestformSupportevent: function(component, event, helper) {
        var orderNotsubmitted = component.get("v.ordersubmitted");
        if(orderNotsubmitted){
                                var matformsmap = event.getParam("matformsmap");
          var businessunitval = matformsmap.businessunitval;
            delete matformsmap.businessunitval;


     		component.set("v.matformsmap",matformsmap);
             var flagVar= localStorage.getItem(component.get("v.AddOnFilePersonWrapper").recepientId+'_orderSubmitted');
          if(!$A.util.isEmpty(matformsmap) && flagVar != 'true'){
            component.set("v.submitbutndisable",false);
            component.set("v.bussinessunit",businessunitval);
          }
        else{
         component.set("v.submitbutndisable",true);
        }
        }
    }
})