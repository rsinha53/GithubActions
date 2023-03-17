({
    onInit : function(component, event, helper) {
        
        // function to get epmp service details: US2368815 - sunil vennam 
        helper.callEpmpApi(component, event, helper);
        helper.getPHIContacts(component, event, helper);
        helper.getMemberInfo(component, event, helper);
        helper.getlanguagePreference(component, event, helper);
        var memberDOB = component.get("v.memberDOB");
        var selectedMemberAge = helper.calculateAge(helper,memberDOB);
          component.set("v.selectedMemberAge", selectedMemberAge);
    },
    
    // Advocate Text Box for EPMP Flag
    EPMPFlagButton: function(component, event, helper) {
        component.set("v.isEPMPTextBoxVisible", true);
    },
    
    //Clase Advocate Text Box for EPMP Flag
    closeAdvocateActionBoxButton : function(component, event, helper) {
        component.set("v.isEPMPTextBoxVisible", false);
    },
    
    //Get Hover section for Communication Preference
    handleMouseOverCommunicationPreference : function(component, event, helper){
        component.set("v.togglehover",true);
    },
    
    //Remove Hover section for Communication Preference
    handleMouseOutCommunicationPreference : function(component, event, helper){
        component.set("v.togglehover",false);
    },
    
    //Get Hover section for Phone
    handleMouseOverForPhone : function(component, event, helper){
        component.set("v.togglehoverforPhone",true);
    },
    
    //Remove Hover section for Phone
    handleMouseOutForPhone : function(component, event, helper){
        component.set("v.togglehoverforPhone",false);
    },
    
    //Get Hover section for Email
    handleMouseOverForEmail: function(component, event, helper){
        component.set("v.togglehoverforEmail",true);
    },
    
    //Remove Hover section for Email
    handleMouseOutForEmail : function(component, event, helper){
        component.set("v.togglehoverforEmail",false);
    },
    // Open PHI Url - US2781361 : Sunil Vennam
    openPHIUrl : function(component, event, helper){
        helper.launchPHIUrl(component, event, helper);
    },
    //Refresh Dashboard 
    refresh : function(component, event, helper){
        component.set('v.memberSelected',true);
        var memlastName = event.currentTarget.dataset.lastname;
        var memfirstName = event.currentTarget.dataset.firstname;
        var memDob = event.currentTarget.dataset.memdob;
        var memberRelation = event.currentTarget.dataset.relationship;
        var cardVisibility = true;
        
        console.log('refresh details::memlastName'+memlastName+'::memfirstName'+memfirstName+'::memDob'+memDob+'::memberRelation'+memberRelation);
        var memberRefresh = component.getEvent("memberRefresh");
        memberRefresh.setParams({"memFirstName" : memfirstName,
                                 "memLastName" : memlastName,
                                 "memDob" : memDob,
                                 "memberRelation":memberRelation,
                                 "cardVisibility" : cardVisibility});
        memberRefresh.fire();
    },
    launchICUE : function (component, event, helper) {
        helper.launchICUEHomeUrl(component, event, helper);
    },
    enableCommPreference: function (component, event, helper) {
        console.log('in onclick method');
        
        var currentEditFld = event.currentTarget.id;
        var savdEditFld = component.get('v.currentEpmpFld');
        if(savdEditFld == '' || currentEditFld == savdEditFld){
        	component.set('v.currentEpmpFld',currentEditFld);    
            component.set('v.enableCommPref',true);
            component.set('v.enableEpmpAddress',false);
        	component.set('v.renderEpmpSave',false);
            //hiding the other two edit icons
            component.set('v.renderEpmpPhoneEdit',false);
            component.set('v.renderEpmpMailEdit',false);
        }
        
    },
    renderEpmpPhone : function (component, event, helper) {
        var currentEditFld = event.currentTarget.id;
        var savdEditFld = component.get('v.currentEpmpFld');
         if(savdEditFld == '' || currentEditFld == savdEditFld){
        	component.set('v.currentEpmpFld',currentEditFld); 
       		component.set('v.enableEpmpPhone',true);
        	component.set('v.renderEpmpSave',false);
             //hiding edit icons
             component.set('v.renderEpmpCommPrefEdit',false);
             component.set('v.renderEpmpMailEdit',false);
             
         }
    },
    cancelEpmpSave : function (component, event, helper) {
        component.set('v.enableCommPref',false);
        component.set('v.renderEpmpSave',true);
        component.set('v.enableEpmpPhone',false);
        component.set('v.enableEpmpAddress',false);
        component.set('v.currentEpmpFld','');
        component.set('v.renderEpmpPhoneEdit',true);
        component.set('v.renderEpmpMailEdit',true);
        component.set('v.renderEpmpCommPrefEdit',true);
        
        component.set('v.epmpTempPhone',component.get('v.epmpDetails.phone'));
		component.set('v.epmpTempEmail',component.get('v.epmpDetails.email_Address'));
		component.set('v.epmpTempCommPref',component.get('v.epmpDetails.communication_Preference'));
        
    },
    renderEpmpAddress: function (component, event, helper) {
        var currentEditFld = event.currentTarget.id;
        var savdEditFld = component.get('v.currentEpmpFld');
         if(savdEditFld == '' || currentEditFld == savdEditFld){
             component.set('v.currentEpmpFld',currentEditFld); 
        component.set('v.enableEpmpAddress',true);
        component.set('v.renderEpmpSave',false);
             //hiding the edit icons
           component.set('v.renderEpmpCommPrefEdit',false);
             component.set('v.renderEpmpPhoneEdit',false);
         }
    },
    
    updateEpmpComPref: function (component, event, helper) {
        if(component.find('epmpCommPrefnce') != null && component.find('epmpCommPrefnce') != undefined){
            var prefVal = component.find('epmpCommPrefnce').get('v.value');
            if(prefVal != ''){
                component.set('v.epmpTempCommPref',prefVal);
            }
        }
    },
    updateEpmpTimezone: function (component, event, helper) {
        if(component.find('epmpEnrollTimezone') != null && component.find('epmpEnrollTimezone') != undefined){
            var prefVal = component.find('epmpEnrollTimezone').get('v.value');
            if(prefVal != ''){
                component.set('v.epmpEnrollTimezone',prefVal);
            }
        }
    },
    updateEpmpMobilePh : function (component, event, helper) {
        if(component.find('epmpMobilePh') != null && component.find('epmpMobilePh') != undefined){
            var phVal = component.find('epmpMobilePh').get('v.value');
            if(phVal != ''){
                component.set('v.epmpTempPhone',phVal);
            }
        }
        
    },
    updateCommPrefTerms : function (component, event, helper) {
        var commPrefCHeckVal = component.get('v.commPrefTermsCheck');
        if(commPrefCHeckVal != ''){
            component.set('v.disableCommPrefConsentSave',false);
        }
    },
    closeEpmpMailError:function (component, event, helper) {
        component.set('v.renderEpmpMailError',false);
        component.set('v.disableCommPrefConsentSave',true);
    },
    closeEpmpPhError:function (component, event, helper) {
    component.set('v.renderEpmpPhError',false);
        component.set('v.disableMobileCnsentSave',true);
    },
    showConsent : function(component, event, helper) {
        var saveepmp = component.get('c.saveEpmp');
        if(component.get('v.renderEpmpCommPrefEdit')){
            var compPrefVal = component.get('v.epmpTempCommPref');
            
                if(compPrefVal != '' && compPrefVal != null  && compPrefVal == 'Paperless'){
                            component.set('v.renderEpmpCommPrefConsent',true);
                        }else{
                            //$A.enqueueAction(saveepmp);
                            helper.saveEpmpCommPreference(component,event,helper,compPrefVal);
                        }
            	
            
        }else if(component.get('v.renderEpmpMailEdit')){
				var emailFieldValue = component.get("v.epmpTempEmail");
                var regExpEmailformat = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;  
            
                if(!$A.util.isEmpty(emailFieldValue)){   
                    if(emailFieldValue.match(regExpEmailformat)){
                        helper.saveEpmpMail(component,event,helper,emailFieldValue);
                            //$A.enqueueAction(saveepmp);
                    }else{
                        component.set('v.renderEpmpMailError',true);
                    }
            	}
            }
        
        else if(component.get('v.renderEpmpPhoneEdit')){
            var tempPhVal = component.get('v.epmpTempPhone');
            if(tempPhVal != '' && tempPhVal != null && tempPhVal != component.get('v.epmpDetails.phone')){
                var regexPh = /^[(]\d{3}[)]?\d{3}[\s.-]\d{4}$/
                if(tempPhVal.match(regexPh)){
					tempPhVal = tempPhVal.replace('(','').replace(')','').replace('-','');
                    //helper.saveEpmpPhone(component,event,helper,tempPhVal);
					 component.set('v.epmpTxtServiceOpt','');
                    component.set('v.epmpEnrollTimezone','');
                    component.set('v.enableEpmpConsentSaveBtn',true);
                    component.set('v.renderEpmpMobilePhConsent',true); 
                    
                }else{
					component.set('v.renderEpmpPhError',true);
                }
                
            }else{
                $A.enqueueAction(saveepmp);
            }
            
            
        }else{
            
            $A.enqueueAction(saveepmp);
        }
        
    },
    
    savePhoneNumber : function (component, event, helper) {
        var selectdVal = component.get('v.epmpTxtServiceOpt');
        var tempPhVal = component.get('v.epmpTempPhone');
            tempPhVal = tempPhVal.replace('(','').replace(')','').replace('-','');
        if(selectdVal == 'Yes'){
            helper.saveEpmpPhoneTextServices(component,event,helper,tempPhVal);
        }else if(selectdVal == 'No'){
            
            helper.saveEpmpPhone(component,event,helper,tempPhVal);
        }
    },
    
    closeEpmpPhConsent : function (component, event, helper){
        component.set('v.renderEpmpMobileSuccess',false);  
        component.set('v.renderEpmpMobilePhConsent',false); 
        
    },
    
    saveEpmpComnctnPref : function (component, event, helper) {
        console.log('calling helper save method');
        var compPrefVal = component.get('v.epmpTempCommPref');
         helper.saveEpmpCommPreference(component,event,helper,compPrefVal);
    },
    updateTextServiceOpt: function (component, event, helper) {
        component.set('v.disableMobileCnsentSave',false);
        var selectdVal = component.get('v.epmpTxtServiceOpt');
        console.log('selected val'+selectdVal);
        if(selectdVal == 'Yes'){
        	component.set('v.enableTimezone',false);
            component.set('v.enableEpmpConsentSaveBtn',false);
        }else{
            component.set('v.enableTimezone',true);
            component.set('v.enableEpmpConsentSaveBtn',false);
        }
    },
    saveEpmp : function (component, event, helper) {
        component.set('v.showSpinnerForEpmp',true);
        var epmpPh = component.get('v.epmpTempPhone');
        var epmpEmail = component.get('v.epmpTempEmail');
        var epmpComPref = component.get('v.epmpTempCommPref');
        //setting the newly entered values in fields after save - temporary till API is available
        component.set('v.epmpDetails.phone',epmpPh);
		component.set('v.epmpDetails.email_Address',epmpEmail);
		component.set('v.epmpDetails.communication_Preference',epmpComPref);
        //enabling the edit icons
        component.set('v.enableCommPref',false);
        component.set('v.enableEpmpPhone',false);
        component.set('v.enableEpmpAddress',false);
         component.set('v.renderEpmpSave',true);
        component.set('v.currentEpmpFld','');
        //component.set("v.epmpDetails.", result);
        component.set('v.renderEpmpPhoneEdit',true);
        component.set('v.renderEpmpMailEdit',true);
        component.set('v.renderEpmpCommPrefEdit',true);
        //hiding the consent modals
        component.set('v.renderEpmpCommPrefConsent',false);
        component.set('v.renderEpmpMobilePhConsent',false);
        component.set('v.disableCommPrefConsentSave',true);
        component.set('v.disableMobileCnsentSave',true);
        //checking the epmp text services opt in status
        var txtOpt = component.get('v.epmpTxtServiceOpt');
        if(txtOpt == 'Yes'){
            component.set('v.epmpDetails.ganActivationStatus','Enrolled');
        }else if(txtOpt == 'No'){
			component.set('v.epmpDetails.ganActivationStatus','Not Enrolled');
        }
        
        
        window.setTimeout(function(){
            component.set('v.showSpinnerForEpmp',false);
        },1000);
        
    },
    
    closeEpmpConsent : function (component, event, helper) {
        if(component.get('v.renderEpmpCommPrefEdit') ){
            component.set('v.renderEpmpCommPrefConsent',false);
        }else if(component.get('v.renderEpmpPhoneEdit')){
			component.set('v.renderEpmpMobilePhConsent',false);
            component.set('v.disableMobileCnsentSave',true);
        }
    },
    closeEpmpPhoneConsent : function (component, event, helper) {
        component.set('v.renderEpmpMobilePhConsent',false);  
        component.set('v.renderEpmpUpdateSuccess',false);
        component.set('v.epmpFailMessage','');
        component.set('v.renderEpmpMailSuccess',false);
        component.set('v.renderEpmpMobileSuccess',false);
        helper.callEpmpApi(component, event, helper);
    },
    closeEpmpFailModal : function (component, event, helper) {
         component.set('v.renderEpmpUpdateFail',false);
         component.set('v.epmpFailMessage','');
    },
    navigateEmailAddressUrl : function (component, event, helper) {
		// to navigate to Email Address URL
		helper.openEPMPLinkUrl(component, event, helper, 'Email');
	},

	navigateCommunicationPrefUrl : function (component, event, helper) {
		// to navigate to Communication URL
		helper.openEPMPLinkUrl(component, event, helper,'CommPref');
	},

	navigateMobilePhoneUrl : function (component, event, helper) {
		// to navigate to MobilePhone URL
		helper.openEPMPLinkUrl(component, event, helper, 'MobilePhone');
	},
})