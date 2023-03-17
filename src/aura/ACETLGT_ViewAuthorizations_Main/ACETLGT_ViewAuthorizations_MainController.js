({
    doInit : function(component, event, helper){

        var pageReference = component.get("v.pageReference");
        //var userData = pageReference.state.c__topicList;
        console.log("View - Auth" + pageReference.state.c__intId);
        
        var cseTopic = pageReference.state.c__callTopic;
        
        var srk = pageReference.state.c__srk;
        var int = pageReference.state.c__interaction;
        var intId = pageReference.state.c__intId;
        var memId = pageReference.state.c__Id;
        var grpNum = pageReference.state.c__gId;
        var uInfo = pageReference.state.c__userInfo;
        var bookOfBusinessTypeCode = '';
        if(component.get("v.pageReference").state.c__bookOfBusinessTypeCode != undefined){
            bookOfBusinessTypeCode = component.get("v.pageReference").state.c__bookOfBusinessTypeCode;
        }
        console.log('bookOfBusinessTypeCode',bookOfBusinessTypeCode);
        component.set('v.bookOfBusinessTypeCode',bookOfBusinessTypeCode);
        var len = 20;
        var buf = [],
            chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789',
            charlen = chars.length,
            length = len || 32;
            
        for (var i = 0; i < length; i++) {
            buf[i] = chars.charAt(Math.floor(Math.random() * charlen));
        }
        var GUIkey = buf.join('');
        //helper.createGUID();
		component.set("v.AutodocKey",GUIkey+'viewAuthorization');
        var hpi = pageReference.state.c__hgltPanelData;
        console.log('highlightPanelData :: '+hpi);
        //alert('highlightPanelData json :: '+JSON.stringify(hpi));
        
        var hghString = pageReference.state.c__hgltPanelDataString;
        component.set("v.highlightPanel_String", hghString);
          var pageReference = component.get("v.pageReference");
        if(pageReference.state.c__fromClaimDetail){
            component.set("v.Auth_Number",pageReference.state.c__authnum);
        }
        hpi = JSON.parse(hghString);
        component.set("v.highlightPanel", hpi);
 
        component.set("v.cseTopic", cseTopic);
        component.set("v.srk", srk);
        component.set("v.int", int);
        component.set("v.intId", intId);
        component.set("v.memId", memId);
        component.set("v.usInfo", uInfo);
        component.set("v.grpNum", grpNum);
 		setTimeout(function(){
        	helper.findAuthsOnLoad(component, event, helper); 
        }, 1);
	},
    
    
    handleSectionToggle: function (cmp, event) {
    	var openSections = event.getParam('openSections');
    },
    
    displayStartDate : function(component,event,helper){

        var startTodayDateValue = (component.find("startTodayDate").get("v.value"));
        component.find("startDate").set("v.value", startTodayDateValue);
    },

    displayEndDate : function(component,event,helper){
        
        var endTodayDateValue = (component.find("endTodayDate").get("v.value"));
        component.find("endDate").set("v.value", endTodayDateValue);
    },
    
    createAuth:function(component,event,helper){
    	console.log('Clicked Create Auth');
        
        		var memId = component.get("v.memberId");
                var firstName = component.get("v.firstName");  			//Contact First Name
                var lastName = component.get("v.lastName");	   			// Contact Last Name
                var contactName = component.get("v.contactName");		// Originator Name
                var groupNum = component.get("v.grpNum");				//group Number
                //var originatorType = component.get("v.origType");
                
                console.log(' Parameters ::: '+memId+' :: '+firstName+' :: '+lastName+' :: '+contactName +' :: '+groupNum);
                
                var actionicue = component.get("c.GenerateICUEURL");
                actionicue.setParams({
                        /*"MemberId": '39045843900',
                        "firstName": 'Danica',
                        "lastName": 'Frazier',
                        "contactName": 'Danica Frazier',
                        "originatorType": 'Member'*/
                		"MemberId": memId,
                        "firstName": firstName,
                        "lastName": lastName,
                        "contactName": contactName,
                        "originatorType": 'Member',
                  		 "groupNumber" :groupNum
                });
                actionicue.setCallback(this, function(response) {
                        var state = response.getState();
                        if (state === "SUCCESS") {
                                var storeResponse = response.getReturnValue();                
                            console.log('storeResponse'+storeResponse);    
                            component.set("v.ICUEURL", storeResponse); 
                                helper.getICUEURL(component, event, helper);               
                        }
                });
                $A.enqueueAction(actionicue);
    },
    
    clearFilter:function(component,event,helper){
        var AutodocKey = component.get("v.AutodocKey");
        //setTimeout(function(){
         //alert('---1--'+ 'Coverage line change');
            window.lgtAutodoc.saveAutodocSelections(AutodocKey);
            window.lgtAutodoc.clearAutodocSelections(AutodocKey);
            
        //}, 1);
      	var allAuths = component.get("v.mainList");
    	component.set("v.Auth_Number",'');
        component.set("v.Auth_Type",'None');
        component.set("v.Auth_Status",'None');
        component.set("v.startDateValue",null);
        component.set("v.endDateValue",null);
        component.set("v.isDataCleared", "true");
        component.set("v.startdate",null);
        component.set("v.enddate",null);
        
        //$A.get('e.force:refreshView').fire();
        
        console.log('inside');
        if(!$A.util.isEmpty(allAuths)){
            if(allAuths.length > 0)
                helper.getAuthorizationsByType(component,event,helper,'All');
        }        
        component.set("v.isDataCleared", "true");
        
    },

    onClickOfEnter : function(component,event, helper) {
        
        // if (event.keyCode === 13) {
        //         //alert('Key press');
        //         var a = component.get('c.applyFilter');
        //         $A.enqueueAction(a);
        // }
		
        try {
            if (event.which == 13){
                //helper.applyFilters(component, event, helper);
                //var a = component.get('c.applyFilter');
        	    //$A.enqueueAction(a);
            //component.find("filterButton").focus();   
            component.find("authNo").focus();
            //component.find("startdateValue").blur();  
                
        	//component.find("dob").focus();
            var a = component.get('c.applyFilter');
            //document.activeElement.blur();
            $A.enqueueAction(a);
            //document.activeElement.blur();
        
            }
          }
          catch(err) {
            console.log("If Error Null : "+err);
          }
    },
    
    onDateChangeSelect: function(component, event, helper){
        console.log('Select change');
        component.find("authNo").focus(); 
    },

   startdateChange: function(component, event, helper) {
        console.warn("dateChange");
        var date = component.get("v.startdate");
       
       component.set("v.startDateValue",date);
        console.warn("Start date is: ++ ", date);
      
    },

   enddateChange: function(component, event, helper) {
        console.warn("dateChange");
        var date = component.get("v.enddate");
       
       component.set("v.endDateValue",date);
        console.warn("End date is: ++ ", date);
      
    },
    
    applyFilter:function(component,event,helper){
        var AutodocKey = component.get("v.AutodocKey");
        component.set("v.Spinner",true);
        setTimeout(function(){
        console.log("-----"+ component.get("v.isDataCleared"));
        if(AutodocKey != undefined && !component.get("v.isDataCleared")){
            window.lgtAutodoc.saveAutodocSelections(AutodocKey);
            //window.lgtAutodoc.clearAutodocSelections(AutodocKey);
        }
        
        
		
        //Changes Made : Nadeem :  23-11-2019
        //alert("START ------->")
        var s_comp = component.find("startdateValue"); 

        var s_date = component.get("v.startDateValue");
        var s_check = $A.util.isEmpty(s_date);
        var s_len =  s_date ? s_date.length : 0;
        let s_reg = /^([0-9]{4})\-([0-9]{2})\-([0-9]{2})$/;
        var s_date_val = (s_reg.test(s_date));

        //alert("Value : "+s_date);
        //alert("is empty : "+$A.util.isEmpty(s_date));
        
        //alert("Match : "+s_date_val);
        //alert("Length : "+s_len);


        //End
        //alert("END --------->")
        var e_comp = component.find("enddateValue"); 

        var e_date = component.get("v.endDateValue");
        var e_check = $A.util.isEmpty(e_date);
        var e_len = e_date ? e_date.length : 0;
        let e_reg = /^([0-9]{4})\-([0-9]{2})\-([0-9]{2})$/;
        var e_date_val = (e_reg.test(e_date));

        
        //alert("Value : "+e_date);
        //alert("is empty : "+$A.util.isEmpty(e_date));
        
        //alert("Match : "+e_date_val);
        //alert("Length : "+e_len);


        
        if((s_date_val == false) && (s_len != 0)){

            $A.util.addClass(s_comp, "slds-has-error-date");
            component.set("v.Start_ErrorMessage","Error : Invalid Start Date");  
            $A.util.removeClass(component.find("sd_msgTxt"), "slds-hide")
            $A.util.addClass(component.find("sd_msgTxt"), "slds-show");
        }

        if ((e_date_val == false) && (e_len != 0)){

            $A.util.addClass(e_comp, "slds-has-error-date");
            component.set("v.End_ErrorMessage","Error : Invalid End Date");  
            $A.util.removeClass(component.find("ed_msgTxt"), "slds-hide")
            $A.util.addClass(component.find("ed_msgTxt"), "slds-show");

        }

        if ((e_check == true) && (e_len == 0)){

            $A.util.removeClass(e_comp, "slds-has-error-date");
            component.set("v.End_ErrorMessage","");  
            $A.util.addClass(component.find("ed_msgTxt"), "slds-hide")
            $A.util.removeClass(component.find("ed_msgTxt"), "slds-show");

        }

        if ((s_check == true) && (s_len == 0)){

            $A.util.removeClass(s_comp, "slds-has-error-date");
            component.set("v.Start_ErrorMessage","");  
            $A.util.addClass(component.find("sd_msgTxt"), "slds-hide")
            $A.util.removeClass(component.find("sd_msgTxt"), "slds-show");

        }
        
        if ((s_check == true) && (s_len == 0) && (e_check == true) && (e_len == 0)){

            $A.util.removeClass(s_comp, "slds-has-error-date");
            component.set("v.Start_ErrorMessage","");  
            $A.util.addClass(component.find("sd_msgTxt"), "slds-hide")
            $A.util.removeClass(component.find("sd_msgTxt"), "slds-show");
            
            $A.util.removeClass(e_comp, "slds-has-error-date");
            component.set("v.End_ErrorMessage","");  
            $A.util.addClass(component.find("ed_msgTxt"), "slds-hide")
            $A.util.removeClass(component.find("ed_msgTxt"), "slds-show");
           
            helper.applyFilters(component,event,helper);

        }

        if ((s_check == false) && ( s_date_val== true) &&  (s_len == 10)){
           
            $A.util.removeClass(s_comp, "slds-has-error-date");
            component.set("v.Start_ErrorMessage","");  
            $A.util.addClass(component.find("sd_msgTxt"), "slds-hide")
            $A.util.removeClass(component.find("sd_msgTxt"), "slds-show");
            
            $A.util.removeClass(e_comp, "slds-has-error-date");
            component.set("v.End_ErrorMessage","");  
            $A.util.addClass(component.find("ed_msgTxt"), "slds-hide")
            $A.util.removeClass(component.find("ed_msgTxt"), "slds-show");
            
            helper.applyFilters(component,event,helper);

        }

        if ((e_check == false) && ( e_date_val== true) &&  (e_len == 10)){
           
            $A.util.removeClass(s_comp, "slds-has-error-date");
            component.set("v.Start_ErrorMessage","");  
            $A.util.addClass(component.find("sd_msgTxt"), "slds-hide")
            $A.util.removeClass(component.find("sd_msgTxt"), "slds-show");
            
            $A.util.removeClass(e_comp, "slds-has-error-date");
            component.set("v.End_ErrorMessage","");  
            $A.util.addClass(component.find("ed_msgTxt"), "slds-hide")
            $A.util.removeClass(component.find("ed_msgTxt"), "slds-show");
            
            helper.applyFilters(component,event,helper);

        }

        if((s_check == false) && ( s_date_val== true) &&  (s_len == 10) && (e_check == false) && ( e_date_val== true) &&  (e_len == 10)){

            $A.util.removeClass(s_comp, "slds-has-error-date");
            component.set("v.Start_ErrorMessage","");  
            $A.util.addClass(component.find("sd_msgTxt"), "slds-hide")
            $A.util.removeClass(component.find("sd_msgTxt"), "slds-show");
            
            $A.util.removeClass(e_comp, "slds-has-error-date");
            component.set("v.End_ErrorMessage","");  
            $A.util.addClass(component.find("ed_msgTxt"), "slds-hide")
            $A.util.removeClass(component.find("ed_msgTxt"), "slds-show");

            helper.applyFilters(component,event,helper);

        }





        //console.log('DOB :: '+component.get("v.dob"));
        

        //helper.applyFilters(component,event,helper);

        console.log('Inpatient :: '+component.get("v.inPatientList"));
        console.log('Outpatient :: '+component.get("v.outPatientList"));
        console.log('Out Facilty :: '+component.get("v.outPatientFacilityList"));
        //component.find("filterButton").focus();  
        //document.activeElement.blur();, 
        }, 1);    
    },

	handleChange: function (component, event) {
        // This will contain the string of the "value" attribute of the selected option
        var selectedOptionValue = event.getParam("value");
        console.log('selectedOptionValue ::: '+selectedOptionValue);
        component.set("v.Auth_Status2", selectedOptionValue);
    }
    
    
    
})