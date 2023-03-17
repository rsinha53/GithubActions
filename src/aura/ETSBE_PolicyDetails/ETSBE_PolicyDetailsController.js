({
	doInit : function(component, event, helper) {
        
        //alert(JSON.stringify(component.get("v.policyDetails")));
        /*
		component.set("v.otherPrimaryInsurance","Yes");
        component.set("v.lastUpdateDate","05/22/2019");
        component.set("v.type","Medicare");
        component.set("v.comments","COB Comments");
        component.set("v.beginDate","05/19/2019");
        component.set("v.endDate","05/19/2025");
        component.set("v.medicalInformation","[Entitlement Reason]/[Medicare Type Value]");
        */
        
        setTimeout(function(){
            //window.utilMethods.method1();
            //window.lgtAutodoc.initAutodoc();
        },500);
	},
    
    runExtendedService : function(component, event, helper) {     
        //US1761826 - UHC/Optum Exclusion UI
    	let allowCallouts = component.get("v.allowCallouts"); 
        if(allowCallouts) {
            var trId = component.get("v.transId");
            var conAdr = component.get("v.conAddress");
            console.log('trId::'+trId);
            helper.callPolicyWS(component, event, helper);    

        }
    },
    
    handlePolicyClick : function(component, event, helper) {
        var transactionId = event.getParam("transaction_id");
        var contactAddress = event.getParam("contact_address"); 
        //US1888880
        let isFireSpinner = event.getParam("show_spinner"); 
        
        //US2166406 - Application event Fix - Sanka
        var originPage = event.getParam("originPage");
        component.set("v.originPage", originPage);



        component.set("v.transId", transactionId);
        component.set("v.conAddress", contactAddress);
        //US1888880
        component.set("v.isFireSpinner", isFireSpinner);
    },
    
    showSpinner: function(component, event, helper) {       
        component.set("v.loadSpinner", true); 
   },    
 
    hideSpinner : function(component,event,helper){        
       component.set("v.loadSpinner", false);
    }
    /*
    ,
    changeConAddress: function(component,event,helper){  
        helper.hidePolicyDetailSpinner(component);  
    }
    */
})