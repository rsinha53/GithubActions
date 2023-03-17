({
    phonenumberFormat : function(component, event, helper) {
        var phoneMobile =  component.get("v.memberDetails.member.phoneMobile");
        var phoneWork =  component.get("v.memberDetails.member.phoneWork");
        var phoneHome =  component.get("v.memberDetails.member.phoneHome");
		component.set("v.rsphonepf", component.get("v.memberDetails.member.phonePreferred"));
		component.set("v.pHome", phoneHome);
        component.set("v.pWork", phoneWork);
        component.set("v.pMobile", phoneMobile);
        var emailID = component.get("v.memberDetails.member.emailAddress");
            if(emailID != null && emailID !="undefined" && emailID !=" "){
                emailID = emailID.trim();
                component.set("v.emailAdd", emailID);
        }
        if (typeof phoneMobile !== "undefined") {
            if(phoneMobile.length == 10){ 
                phoneMobile =    '('  + phoneMobile.substring(0,3) +')' + ' ' + phoneMobile.substring(3,6) + '-' + phoneMobile.substring(6,10); 
                component.set("v.phoneMobile",phoneMobile);
            }
        }        
        if (typeof phoneWork !== "undefined") {
            if(phoneWork.length == 10){ 
                phoneWork =    '('  + phoneWork.substring(0,3) +')' + ' ' + phoneWork.substring(3,6) + '-' + phoneWork.substring(6,10); 
                component.set("v.phoneWork",phoneWork);
                
            }}
        
        if (typeof phoneHome !== "undefined") {
            if(phoneHome.length == 10){ 
                phoneHome =    '('  + phoneHome.substring(0,3) +')' + ' ' + phoneHome.substring(3,6) + '-' + phoneHome.substring(6,10); 
                component.set("v.phoneHome",phoneHome);
            }
            else {
                component.set("v.phoneHome",(phoneHome + ' (M)'));
            }
        } 
    },
    
 AddressLines : function(component, event, helper) {
        var AdLine1 =  component.get("v.memberDetails.member.mailAddressLine1");
		var AdLine2 =  component.get("v.memberDetails.member.mailAddressLine2");
		var AdLine3 =  component.get("v.memberDetails.member.mailAddressLine3");
		var AdLine4 =  component.get("v.memberDetails.member.mailAddressLine4");
		var AdLine5 =  component.get("v.memberDetails.member.mailAddressLine5");
        var mcity =  component.get("v.memberDetails.member.mailAddressCity");
		var mState =  component.get("v.memberDetails.member.mailAddressState");
		var mZip =  component.get("v.memberDetails.member.mailAddressZip");
        if (typeof AdLine1 !== "undefined") {
                component.set("v.AddressLine1",AdLine1);
           
        } 
        if (typeof AdLine2 !== "undefined") {
                if (AdLine2 !== ' ') {
                 component.set("v.AddressLine2", AdLine2);
        }
           
        }  
        if (typeof AdLine3 !== "undefined") {
                component.set("v.AddressLine3",AdLine3);
           
        }  
        if (typeof AdLine4 !== "undefined") {
                component.set("v.AddressLine4",AdLine4);
           
        }  
		if (typeof AdLine5 !== "undefined") {
                component.set("v.AddressLine5",AdLine5);
           
        } 
     if (typeof mcity !== "undefined") {
               component.set("v.mailAddressCity",mcity);
           
        }  
        if (typeof mState !== "undefined") {
                component.set("v.mailAddressState",mState);
           
        }  
		if (typeof mZip !== "undefined") {
               component.set("v.mailAddressZip",mZip);
           
        }
        component.set("v.mAddLine1", component.get("v.memberDetails.member.mailAddressLine1"));
        component.set("v.mAddLine2", component.get("v.AddressLine2"));
        component.set("v.mCity", component.get("v.memberDetails.member.mailAddressCity"));
        component.set("v.mState", component.get("v.memberDetails.member.mailAddressState"));
        component.set("v.mZip", component.get("v.memberDetails.member.mailAddressZip"));		
	},
    HomeAddressLines : function(component, event, helper) {
        var AdLine1 =  component.get("v.memberDetails.member.homeAddressLine1");
		var AdLine2 =  component.get("v.memberDetails.member.homeAddressLine2");
		var AdLine3 =  component.get("v.memberDetails.member.homeAddressLine3");
		var AdLine4 =  component.get("v.memberDetails.member.homeAddressLine4");
		var AdLine5 =  component.get("v.memberDetails.member.homeAddressLine5");
        var city =  component.get("v.memberDetails.member.homeAddressCity");
		var State =  component.get("v.memberDetails.member.homeAddressState");
		var Zip =  component.get("v.memberDetails.member.homeAddressZip");
        if (typeof AdLine1 !== "undefined") { 
                component.set("v.HomeAddressLine1",AdLine1);
           
        } 
        if (typeof AdLine2 !== "undefined") {
                if (AdLine2 !== ' ') {
               component.set("v.HomeAddressLine2", AdLine2);
            }   
           
        }  
        if (typeof AdLine3 !== "undefined") {
                component.set("v.HomeAddressLine3",AdLine3);
           
        }  
        if (typeof AdLine4 !== "undefined") {
                component.set("v.HomeAddressLine4",AdLine4);
           
        }  
		if (typeof AdLine5 !== "undefined") {
                component.set("v.HomeAddressLine5",AdLine5);
           
        } 
        if (typeof city !== "undefined") {
                component.set("v.homeAddressCity",city);
           
        }  
        if (typeof State !== "undefined") {
                component.set("v.homeAddressState",State);
           
        }  
		if (typeof Zip !== "undefined") {
                component.set("v.homeAddressZip",Zip);
           
        }
        component.set("v.hAddLine1", component.get("v.HomeAddressLine1"));
        component.set("v.hAddLine2", component.get("v.HomeAddressLine2"));
        component.set("v.hCity", component.get("v.homeAddressCity"));
        component.set("v.hState", component.get("v.homeAddressState"));
        component.set("v.hZip", component.get("v.homeAddressZip"));		
	},
// Added by Iresh, Field mapping-Primary phone indicator: US3083536
    PhonePreferred : function(component, event, helper){
       component.set("v.rsphonepf", component.get("v.memberDetails.member.phonePreferred"));
       var phonePreferred = component.get("v.rsphonepf");
        if(phonePreferred == "H"){
            component.set("v.phonePreferredHomeNo", "(P)");
        }
        else if(phonePreferred == "M"){
            component.set("v.phonePreferredMobileNo", "(P)");
        }
        else if(phonePreferred == "W"){
            component.set("v.phonePreferredWorkNo", "(P)");
        }
        //US3241994 Autodoc Demographics
        helper.autoDocDemographicsAddress(component, event, helper);
        helper.autoDocDemographicsEmail(component, event, helper);
        helper.autoDocDemographicsPhone(component, event, helper);
    },
    //US3241994 Autodoc Demographics
  autoDocDemographicsEmail: function (cmp, event, helper) {
    var autodocCmp = _autodoc.getAutodocComponent(cmp.get("v.autodocUniqueId"), cmp.get("v.autodocUniqueIdCmp"), "Demographics");
       if(!$A.util.isEmpty(autodocCmp)){
       cmp.set("v.autoDocDemographicsEmail", autodocCmp);
       } 
      var cardDetails = new Object();
      cardDetails.componentName = "Email";
      cardDetails.componentOrder = 3;
      cardDetails.noOfColumns = "slds-size_1-of-1";
      cardDetails.type = "card";
      cardDetails.allChecked = false;
      cardDetails.cardData = [
          {
              "checked": false,
              "disableCheckbox": false,
              "defaultChecked": false,
              "fieldName": "Email",
              "fieldType":"outputText",
              "fieldValue": cmp.get("v.emailAdd"),
              "showCheckbox": true,
              "isReportable":true
          }
      ];
      cmp.set("v.autoDocDemographicsEmail", cardDetails);
},
    //US3241994 Autodoc Demographics
    autoDocDemographicsPhone: function(component, event, helper){
        var phome = component.get("v.phoneHome");
        var pmobile = component.get("v.phoneMobile");
        var pwork = component.get("v.phoneWork");
        var pHomePref = component.get("v.phonePreferredHomeNo");
        var pMobilePref = component.get("v.phonePreferredMobileNo");
        var pWorkPref = component.get("v.phonePreferredWorkNo");
        var phne = [];
        var phomeDetail={pwork:phome,extension:'',ptype:'Home',priIndi:pHomePref};
        var pmobileDetail={pwork:pmobile,extension:'',ptype:'Mobile',priIndi:pMobilePref};
        var pworkDetail={pwork:pwork,extension:'',ptype:'Work',priIndi:pWorkPref};
        phne.push(phomeDetail);
        phne.push(pmobileDetail);
        phne.push(pworkDetail);
        var action = component.get('c.getAutoDocDemographicsPhone');
        action.setParams({
            "credDetails": phne
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var responseValue = JSON.stringify(response.getReturnValue());
            if ((state === "SUCCESS")){
                component.set("v.autoDocDemographicsPhone" ,response.getReturnValue());
                var restValue = component.get("v.autoDocDemographicsPhone");
             }
        });
        $A.enqueueAction(action);
    },
        //US3241994 Autodoc Demographics
    autoDocDemographicsAddress: function(component, event, helper){
        //Mailing Address JSON
            var mailAddress = "";
            if ((typeof component.get("v.mAddLine1") !== "undefined") && (component.get("v.mAddLine1") !== "")) {
                mailAddress = component.get("v.mAddLine1");          
            } 
            if ((typeof component.get("v.mAddLine2") !== "undefined") && (component.get("v.mAddLine2") !== "")) {
                mailAddress = mailAddress + "\n" + component.get("v.mAddLine2");          
            } 
            if ((typeof component.get("v.memberDetails.member.mailAddressLine3") !== "undefined") && (component.get("v.memberDetails.member.mailAddressLine3") !== "")) {
                mailAddress = mailAddress + "\n" + component.get("v.memberDetails.member.mailAddressLine3");
            } 
            if ((typeof component.get("v.memberDetails.member.mailAddressLine4") !== "undefined") && (component.get("v.memberDetails.member.mailAddressLine4") !== "")) {
                mailAddress = mailAddress + "\n" + component.get("v.memberDetails.member.mailAddressLine4");            
            }
            if ((typeof component.get("v.memberDetails.member.mailAddressLine5") !== "undefined") && (component.get("v.memberDetails.member.mailAddressLine5") !== "")) {
                mailAddress = mailAddress + "\n" + component.get("v.memberDetails.member.mailAddressLin5");
            } 
            if ((typeof component.get("v.mCity") !== "undefined") && (component.get("v.mCity") !== "")){ 
            var mCity = component.get("v.mCity");
            }
            if((!$A.util.isUndefinedOrNull(component.get("v.mState")))){
            var mState = component.get("v.mState");
            }
           if((!$A.util.isUndefinedOrNull(component.get("v.mZip")))){
            var mZip = component.get("v.mZip");
           }
           if(typeof mCity !== "undefined" && typeof mState !== "undefined" && typeof mZip !== "undefined" && mCity !== "" && mState !== "" && mZip !== ""){
            var mailAddress1 = mCity + ', ' + mState + ' ' + mZip;
           }
        
          if(typeof mailAddress!=="undefined" && typeof mailAddress1!=="undefined" ){
            mailAddress = mailAddress + "\n" + mailAddress1;
           }
                   
         //Home Address JSON
            var homeAddress = "";
        var hd1 = component.get("v.hAddLine1");
        if (typeof hd1!== "undefined" && hd1 !== "") {
            homeAddress = component.get("v.hAddLine1"); 
            console.log("homeAddress1",homeAddress);
        } 
        var hd2 = component.get("v.hAddLine2");
        if (typeof hd2!== "undefined" && hd2!== "") {
            homeAddress = homeAddress+ "\n"  + component.get("v.hAddLine2"); 
            console.log("homeAddress2",homeAddress);
        }
        var hd3 = component.get("v.HomeAddressLine3");
        if ( typeof hd3 !== "undefined" && hd3 !== "") {
            homeAddress = homeAddress + "\n" + component.get("v.HomeAddressLine3"); 
            console.log("homeAddress3",homeAddress);
        }
        var hd4 = component.get("v.HomeAddressLine4");
        if (typeof hd4 !== "undefined" && hd4 !== "") {
           homeAddress = homeAddress + "\n" + component.get("v.HomeAddressLine4"); 
            console.log("homeAddress5",homeAddress);
        }
       var hd5 = component.get("v.HomeAddressLine5");
        if (typeof hd5!== "undefined" && hd5 !== "") {
            homeAddress = homeAddress + "\n" + component.get("v.HomeAddressLine5"); 
            console.log("homeAddress5",homeAddress);
        } 
        var hc = component.get("v.hCity");
        if (typeof hc !== "undefined" && hc!== "") {
            var hCity = component.get("v.hCity");
            console.log("hCity",hCity);
        }
        var hs = component.get("v.hState");
        if (typeof hs !== "undefined" && hs!== "") {
            var hState = component.get("v.hState");
            console.log("hState",hState);
        }
        var hz = component.get("v.hZip");
        if (typeof hz !== "undefined" &&  hz!== "") {
            var hZip = component.get("v.hZip");
            console.log("hZip",hZip);
        }
         if(typeof hCity !== "undefined" && typeof hState !== "undefined" && typeof hZip !== "undefined" && hCity !== "" && hState !== "" && hZip !== ""){
            var homeAddress1 = hCity + ', ' + hState + ' ' + hZip;
        }
         if(typeof homeAddress!=="undefined" && typeof homeAddress1!=="undefined" ){
            homeAddress = homeAddress + "\n" + homeAddress1;
        }
               
        var autodocCmp = _autodoc.getAutodocComponent(component.get("v.autodocUniqueId"), component.get("v.autodocUniqueIdCmp"), "Demographics");
                 if(!$A.util.isEmpty(autodocCmp)){
                 component.set("v.autoDocDemographicsAddress", autodocCmp);
                 } 
                var cardDetails = new Object();
                cardDetails.componentName = "Address";
                cardDetails.componentOrder = 3;
                cardDetails.noOfColumns = "slds-size_1-of-2";
                cardDetails.type = "card";
                cardDetails.allChecked = false;
                cardDetails.cardData = [
                    {
                        "checked": false,
                        "disableCheckbox": false,
                        "defaultChecked": false,
                        "fieldName": "Mailing Address",
                        "fieldType":"formattedText",
                        "fieldValue": mailAddress ,
                        "showCheckbox": true,
                        "isReportable":true
                    },
                    {
                        "checked": false,
                        "disableCheckbox": false,
                        "defaultChecked": false,
                        "fieldName": "Home Address",
                        "fieldType": "formattedText",
                        "fieldValue":homeAddress,
                        "showCheckbox": true,
                        "isReportable":true
                    }
                ];
                component.set("v.autoDocDemographicsAddress", cardDetails);
        },
	// Added by Sanjay for US3150934: Update Demographics - Validation
    populateData: function(component, event, helper) {
        component.set("v.isOpen", true);
        //var pPhone = component.get("v.memberDetails.member.phonePreferred");
		var pPhone = component.get("v.rsphonepf");
        if (pPhone == 'H') {
            component.set("v.value", component.get("v.home"));
        } else if (pPhone == 'W') {
            component.set("v.value", component.get("v.work"));
        } else if (pPhone == 'M') {
            component.set("v.value", component.get("v.mobile"));
        }
    },
    // Added by Sanjay for US3150934: Update Demographics - Validation    
    saveData: function(component, event, helper) {
        component.find("hAddressLine1").reportValidity();
        component.find("hCity").reportValidity();
        component.find("hState").reportValidity();
        component.find("hZip").reportValidity();
        component.find("mAddressLine1").reportValidity();
		component.find("mAddressLine2").reportValidity();
        component.find("mCity").reportValidity();
        component.find("mZip").reportValidity();
        component.find("hPhone").reportValidity();
        component.find("mPhone").reportValidity();
        component.find("wPhone").reportValidity();
        component.find("emailId").reportValidity();
        var hideErrorMessage = component.get("v.ppCheck");
		var stateValue = component.find("selectState").get("v.value");
		var ppfrd = component.get("v.value");
        if (ppfrd == 'Home') {
            component.set("v.pfvalue", component.get("v.prhome"));
        } else if (ppfrd == 'Work') {
            component.set("v.pfvalue", component.get("v.prwork"));
        } else if (ppfrd == 'Mobile') {
            component.set("v.pfvalue", component.get("v.prmobile"));
        }
        if ((component.find("hAddressLine1").checkValidity() && component.find("hCity").checkValidity() && component.find("hState").checkValidity() && component.find("hZip").checkValidity() && component.find("mAddressLine1").checkValidity() && component.find("mAddressLine2").checkValidity() && component.find("mCity").checkValidity() && component.find("selectState").checkValidity() && component.find("mZip").checkValidity() && component.find("hPhone").checkValidity() && component.find("mPhone").checkValidity() && component.find("wPhone").checkValidity() && component.find("emailId").checkValidity() && hideErrorMessage) == true) {
            component.set("v.isOpen", false);
			component.set("v.Spinner", true);
            component.set("v.faroId", component.get("v.memberDetails.member.faroId"));
            var fID = component.get("v.memberDetails.member.faroId");
            var zip;
            var zipPlus4;
            var valueOfMZip = component.find("mZip").get("v.value");
            if (valueOfMZip.length == 5){
                zip = valueOfMZip;
            }
            else if (valueOfMZip.length == 9) {
                zip =  valueOfMZip.substr(0, 5);
                zipPlus4 = valueOfMZip.substr(5, 4);    
            }
            else if (valueOfMZip.length == 10) {
                zip =  valueOfMZip.substr(0, 5);
                zipPlus4 = valueOfMZip.substr(6, 4);    
            }
            var email= component.find("emailId").get("v.value");
                if(email != null && email !="undefined" && email !=" "){
          		email = email.trim();
        	    component.set("v.emailAdd",email );
            }
            var action = component.get("c.updateDemographics");
            component.set("v.Spinner", true);
            action.setParams({
                "faroId": component.get("v.memberDetails.member.faroId"),
                "emailId": email,
                "mAddessLine1": component.get("v.memberDetails.member.mailAddressLine1"),
                "mAddessLine2": component.get("v.memberDetails.member.mailAddressLine2"),
                "mAddressCity": component.get("v.memberDetails.member.mailAddressCity"),
                "mAddressState": stateValue,
                "pMobile": component.get("v.pMobile"),
                "pWork": component.get("v.pWork"),
                "pHome": component.get("v.pHome"),
                "phonePreferred": component.get("v.pfvalue"),
                "wBrandId": component.get("v.memberDetails.member.webBrandId"),
                "zip": zip,
                "zipPlus4": zipPlus4
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                var toastEvent = $A.get("e.force:showToast");
                var responseValue = JSON.parse(JSON.stringify(response.getReturnValue()));
                if ((state === "SUCCESS")&& (component.isValid())){
					 if(responseValue != null &&  !($A.util.isUndefinedOrNull(responseValue.result)) && !((Object.keys(responseValue.result).length)==0) && !($A.util.isUndefinedOrNull(responseValue.result.data)) && !((Object.keys(responseValue.result.data).length) == 0)){ 
				   var res = JSON.stringify(responseValue.result.data);
                   if ((responseValue.result == undefined) || (res.length == 2)) {
                        component.set("v.Spinner", false);
                        toastEvent.setParams({
                            message: 'No response from the API',
                            type: 'error'
                        });
                        toastEvent.fire();
                    }  else if(responseValue != null &&  !($A.util.isUndefinedOrNull(responseValue.result)) && !((Object.keys(responseValue.result).length)==0) && !($A.util.isUndefinedOrNull(responseValue.result.data)) && !((Object.keys(responseValue.result.data).length) == 0)){ 
                        if(!responseValue.result.data.homePhone === null){ 
                        component.set("v.phoneHome", responseValue.result.data.homePhone);
                        }
                        if(!responseValue.result.data.mobilePhone === null){ 
                        component.set("v.phoneMobile", responseValue.result.data.mobilePhone);
                        }
                        if(!responseValue.result.data.workPhone === null){ 
                        component.set("v.phoneWork", responseValue.result.data.workPhone);
                        }
                        var mail= responseValue.result.data.emailAddress;
                        if(mail != null && mail !="undefined" && mail !=" "){
                             mail.replaceAll( '\\s+', '');
           					 mail = mail.trim();
        				component.set("v.emailAdd",mail );
       					}
                        component.set("v.mAddLine1", responseValue.result.data.addressLine1);
                        component.set("v.mAddLine2", responseValue.result.data.addressLine2);
                        component.set("v.mCity", responseValue.result.data.city);
                        component.set("v.mState", responseValue.result.data.state);
                        component.set("v.hAddLine1", responseValue.result.data.addressLine1);
                        component.set("v.hAddLine2", responseValue.result.data.addressLine2);
                        component.set("v.hCity", responseValue.result.data.city);
                        component.set("v.hState", responseValue.result.data.state);
                        var zZip = responseValue.result.data.zip;
                        var zZip4 = responseValue.result.data.zipPlus4;
                        if ((zZip.length == 5) && (zZip4 != 'null')) {
                            var zipCode = zZip + '-' + zZip4;
                            component.set("v.mZip", zipCode); 
                            component.set("v.hZip", zipCode);   
                        }
                        else if ((zZip.length == 5) && (zZip4 == 'null')){
                            component.set("v.mZip", zZip);
                            component.set("v.hZip", zZip);
                        }
                        var phonepf = responseValue.result.data.preferredPhoneType;
                        var pf = component.get("v.rsphonepf");
                        component.set("v.rsphonepf", responseValue.result.data.preferredPhoneType);
                        if(phonepf!=pf){
                             component.set("v.rsphonepf","");
                             component.set("v.phonePreferredMobileNo", "");
                             component.set("v.phonePreferredHomeNo", "");
                             component.set("v.phonePreferredWorkNo", ""); 
                        }
                           if(phonepf == "H"){
                                component.set("v.phonePreferredHomeNo", "(P)");
                            }
                              else if(phonepf == "M"){
                             component.set("v.phonePreferredMobileNo", "(P)");
                        }
                               else if(phonepf == "W"){
                               component.set("v.phonePreferredWorkNo", "(P)");
                         }                         
                        var pMobileValue = responseValue.result.data.mobilePhone;
                        var pHomeValue = responseValue.result.data.homePhone;
                        var pWorkValue = responseValue.result.data.workPhone;
						if(pMobileValue=="" ){
                         component.set("v.phoneMobile", "");   
                        }
                        if(pHomeValue==""){
                         component.set("v.phoneHome", "");   
                        }
                        if(pWorkValue==""){
                         component.set("v.phoneWork", "");   
                        }
                        if (pMobileValue!= null && pMobileValue!="") {
                            if (pMobileValue.length == 10) {
                                var pm = '(' + pMobileValue.substring(0, 3) + ')' + ' ' + pMobileValue.substring(3, 6) + '-' + pMobileValue.substring(6, 10);
                                component.set("v.phoneMobile", pm);
                            }
                        }                       
                        if (pHomeValue!= null && pHomeValue!="" ) {
                            if (pHomeValue.length == 10) {
                                var pm = '(' + pHomeValue.substring(0, 3) + ')' + ' ' + pHomeValue.substring(3, 6) + '-' + pHomeValue.substring(6, 10);
                                component.set("v.phoneHome", pm);
                            }
                        }
                        if (pWorkValue != null && pWorkValue!="") {
                            if (pWorkValue.length == 10) {
                                var pm = '(' + pWorkValue.substring(0, 3) + ')' + ' ' + pWorkValue.substring(3, 6) + '-' + pWorkValue.substring(6, 10);
                                component.set("v.phoneWork", pm);
                            }
                        }
                         //US3241994 Autodoc Demographics
                         helper.autoDocDemographicsAddress(component, event, helper);
                         helper.autoDocDemographicsEmail(component, event, helper);
                         helper.autoDocDemographicsPhone(component, event, helper);
						component.set("v.Spinner", false);                       
        toastEvent.setParams({
            message: 'Details sucessfully updated',
            type: 'success'
        });
        toastEvent.fire();
                    }
                }
                else if ((($A.util.isUndefinedOrNull(responseValue.result)))||($A.util.isUndefinedOrNull(responseValue.result.data)) || (state === "ERROR")) {
                component.set("v.Spinner", false);
                toastEvent.setParams({
                    message: 'Details updation failed',
                    type: 'error'
                });
                toastEvent.fire();
                }
                else if (state === "INCOMPLETE") {
                component.set("v.Spinner", false);
                toastEvent.setParams({
                    message: 'Details partially updated',
                    type: 'warning'
                });
                toastEvent.fire();
                }
				}
            });
            $A.enqueueAction(action);
        }
    },
    
})