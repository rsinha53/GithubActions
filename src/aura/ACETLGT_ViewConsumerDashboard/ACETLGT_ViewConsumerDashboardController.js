({
	onInit : function(component, event, helper) {

        //All to do with Autodoc
		var len = 20;
		var buf = [],
			chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789',
			charlen = chars.length,
			length = len || 32;
			
		for (var i = 0; i < length; i++) {
			buf[i] = chars.charAt(Math.floor(Math.random() * charlen));
		}
		var GUIkey = buf.join('');
		component.set("v.AutodocKey", GUIkey);        
        
		var pageReference = component.get("v.pageReference");
		//var userData = pageReference.state.c__topicList;


		//TTS Data
		var cseTopic = pageReference.state.c__callTopic;
		var srk = pageReference.state.c__srk;
		var int = pageReference.state.c__interaction;
		var intId = pageReference.state.c__intId; 
		var memid = pageReference.state.c__Id;
		var grpnumber = pageReference.state.c__gId;
        var fName = pageReference.state.c__subject_firstname;
        var lName = pageReference.state.c__subject_lastname;
		var bookOfBusinessTypeCode = '';
        if(component.get("v.pageReference").state.c__bookOfBusinessTypeCode != undefined){
            bookOfBusinessTypeCode = component.get("v.pageReference").state.c__bookOfBusinessTypeCode;
        }
        console.log('bookOfBusinessTypeCode',bookOfBusinessTypeCode);
        component.set('v.bookOfBusinessTypeCode',bookOfBusinessTypeCode);
		component.set("v.cseTopic", cseTopic);
		component.set("v.srk", srk);
		component.set("v.int", int);
		component.set("v.intId", intId);
		component.set("v.memId", memid);  
		component.set("v.grpNum", grpnumber);
        component.set("v.firstName", fName);
        component.set("v.lastName", lName);

		var hpi = pageReference.state.c__hgltPanelData;
		
		var hghString = pageReference.state.c__hgltPanelDataString;
		hpi = JSON.parse(hghString);
    component.set("v.highlightPanel", hpi);
		

		//Alerts Data
		var intId = component.get("v.intId");

		if(intId != undefined ){
			var childCmp = component.find("cComp");
			var memID = component.get("v.memId");
			var GrpNum = component.get("v.grpNum");
			var bundleId = hpi.benefitBundleOptionId;
			childCmp.childMethodForAlerts(intId,memID,GrpNum,'',bundleId);
		}
        
        //	US2528274 : by Madhura 23-June-2020 to call child aura method
        var dynamicCallTypes = component.find("dynamicCallTypes");
        dynamicCallTypes.callChildForPharmacy();
	},

    onClear : function(component, event, helper) {
        component.set("v.radioChange",'SelectedFalse');
        document.querySelector('input[name=VConDash][value=SelectedFalse]').checked = true;
        component.set("v.ncName",'');
        component.set("v.vcDate",'');
        component.set("v.vcTime",'');
        component.set("v.comments",'');
        component.set("v.opportunity",'');
        //Reset Nurse/Coach Name
        component.set("v.show_ncNameError",false); 
        $A.util.removeClass(component.find("ncName"), "slds-has-error");
        component.set("v.isValid_VCD_Appointment",false);
    },
	onRadioChange : function(component, event, helper) {
		var selected = event.currentTarget.value;
        if(selected == 'SelectedFalse' ){
            component.set("v.ncName",'');
            component.set("v.vcDate",'');
        	component.set("v.vcTime",'');
            //Reset Nurse/Coach Name
            component.set("v.show_ncNameError",false); 
            component.set("v.show_vcDateError",false); 
            component.set("v.show_vcTimeError",false); 
	    
            component.set("v.show_vcPriorDateError",false);
            component.set("v.show_vcPriorTimeError",false);
            $A.util.removeClass(component.find("ncName"), "slds-has-error");
	    $A.util.removeClass(component.find("vcDate"), "slds-has-error");
            $A.util.removeClass(component.find("vcTime"), "slds-has-error");

            component.set("v.isValid_VCD_Appointment",false);
            component.set("v.isValid_VCD_Date",false);
            component.set("v.isValid_VCD_PriorDate",false);
            component.set("v.isValid_VCD_Time",false);
            component.set("v.isValid_VCD_ncName",false);

        }else if(selected == 'SelectedTrue' ){
            component.set("v.radioChange", selected);
            component.set("v.isValid_VCD_Appointment",true);
        }
    	component.set("v.radioChange", selected);
    },
    onOppChange : function(component, event, helper) {
		var selected = component.get("v.opportunity");
        if(selected != 'Accepted' ){
            component.set("v.radioChange",'SelectedFalse');
            component.set("v.ncName",'');
            component.set("v.vcDate",'');
            component.set("v.vcTime",'');
            
           document.querySelector('input[name=VConDash][value=SelectedFalse]').checked = true;
            //Reset Nurse/Coach Name
            component.set("v.show_ncNameError",false); 
            component.set("v.show_vcDateError",false); 
            component.set("v.show_vcTimeError",false); 
            $A.util.removeClass(component.find("ncName"), "slds-has-error");
	    $A.util.removeClass(component.find("vcDate"), "slds-has-error");
            $A.util.removeClass(component.find("vcTime"), "slds-has-error");
            //Error Validations
            component.set("v.isValid_VCD_Appointment",false);
        }else if(selected == '' ){
            //Error Validations
            component.set("v.isValid_VCD_Opportunity",false);
        }
	},
    onDateBlur : function(component, event, helper) {
		var dateval = component.get("v.vcDate");
        if((dateval == '') || (dateval == undefined)){
           $A.util.addClass(component.find("vcDate"), "slds-has-error");
           //component.set("v.show_vcDateError",true);
        }else{
           component.set("v.show_vcDateError",false); 
           component.set("v.show_vcPriorDateError",false);
           $A.util.removeClass(component.find("vcDate"), "slds-has-error");
        }
    },
    onTimeBlur : function(component, event, helper) {
		var timeval = component.get("v.vcTime");
        if((timeval == '') || (timeval == undefined)){
           $A.util.addClass(component.find("vcTime"), "slds-has-error");
           //component.set("v.show_vcTimeError",true);
        }else{
           component.set("v.show_vcTimeError",false); 
           component.set("v.show_vcPriorTimeError",false); 
           $A.util.removeClass(component.find("vcTime"), "slds-has-error");
        }
    },
    onNCNameBlur : function(component, event, helper) {
		var ncName_val = component.get("v.ncName");
        if((ncName_val == '') || (ncName_val == undefined)){
           $A.util.addClass(component.find("ncName"), "slds-has-error");
           component.set("v.show_ncNameError",true);

           //Error Validation
           component.set("v.isValid_VCD_ncName",false);
        }else{
           component.set("v.show_ncNameError",false); 
           $A.util.removeClass(component.find("ncName"), "slds-has-error");

           //Error Validation
           component.set("v.isValid_VCD_ncName",true);
        }
    },
    onOppBlur : function(component, event, helper) {
        var selected = component.get("v.opportunity");
        
        if(selected != '' ){
            //Set Bool value to false to send to : TTS
            component.set("v.isValid_VCD_Opportunity",true);
            component.set("v.isCDDropdownSetError",false);
        }else if((selected == 'None' )|| (selected = '')){
            component.set("v.isCDDropdownSetError",true);
            component.set("v.isValid_VCD_Opportunity",false);
        }else{
			//Set Bool value to true to send to : TTS
            component.set("v.isValid_VCD_Opportunity",false);
        }
    },
    handleOppChange: function(component, event, helper) {
        console.log('handleOppChange');
        var oppVal = component.get("v.isCDDropdownSetError");
        var oppCmp =  component.find('opp');
        if(oppVal){
        	$A.util.addClass(oppCmp, "slds-has-error");
        }else{
            $A.util.removeClass(oppCmp, "slds-has-error");
            $A.util.removeClass(component.find('errorSelection'), "slds-show");
            $A.util.addClass(component.find('errorSelection'), "slds-hide");
        }
            $A.util.removeClass(component.find('errorSelection'), "slds-show");
            $A.util.addClass(component.find('errorSelection'), "slds-hide");
    },
    handleNurseNameChange : function(component, event, helper) {
        console.log('handleNurseNameChange');
        var nurseVal = component.get("v.show_ncNameError");
        var nurseCmp =  component.find('ncName');
        if(nurseVal){
        	$A.util.addClass(nurseCmp, "slds-has-error");
        }else{
            $A.util.removeClass(nurseCmp, "slds-has-error");
        }
            $A.util.removeClass(component.find('errorBlank'), "slds-show");
            $A.util.addClass(component.find('errorBlank'), "slds-hide");
    }, 
    handlCVDateChange: function(component, event, helper) {
        var dateVal = component.get("v.show_vcDateError");
        var priordateVal = component.get("v.show_vcPriorDateError");
        console.log('>>>date>>priordateVal'+dateVal+priordateVal);
        var dateCmp =  component.find('vcDate');
        if(priordateVal){
        	$A.util.addClass(dateCmp, "slds-has-error");
        	$A.util.removeClass(component.find('errorDate'), "slds-show");
            $A.util.addClass(component.find('errorDate'), "slds-hide");
        }
        else if(dateVal){
        	$A.util.removeClass(component.find('errorPriorDate'), "slds-show");
            $A.util.addClass(component.find('errorPriorDate'), "slds-hide");
        	$A.util.addClass(dateCmp, "slds-has-error");
        }else{
            $A.util.removeClass(dateCmp, "slds-has-error");
        }
    },
    handlCVTimeChange: function(component, event, helper) {
        var timeVal = component.get("v.show_vcTimeError");
        var priortimeVal = component.get("v.show_vcPriorTimeError");
        console.log('time>>>priortime'+timeVal+priortimeVal);
        var timeCmp =  component.find('vcTime');
        if(priortimeVal){
        	$A.util.addClass(timeCmp, "slds-has-error");
        	$A.util.removeClass(component.find('errorTime'), "slds-show");
            $A.util.addClass(component.find('errorTime'), "slds-hide");
        }
        else if(timeVal){
            console.log('Invalid Time blank');
        	$A.util.removeClass(component.find('errorPriorTime'), "slds-show");
            $A.util.addClass(component.find('errorPriorTime'), "slds-hide");
        	$A.util.addClass(timeCmp, "slds-has-error");
        }else{
            $A.util.removeClass(timeCmp, "slds-has-error");
        }
    }
})