({
	doInit: function(component, event, helper) {
        var len = 10;
        var buf = [],
            chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789',
            charlen = chars.length,
            length = len || 32;
            
        for (var i = 0; i < length; i++) {
            buf[i] = chars.charAt(Math.floor(Math.random() * charlen));
        }
        var GUIkey = buf.join('');
        component.set("v.GUIkey",GUIkey);
       var rowList = [];
      for (var i = 0; i < 15; i++){ 
              var providerFeeScheduleObj = {
              "dateOfServiceFrom" : '',
              "startDateRequired" : false,
              "dateOfServicethru" : '',
              "placeOfServiceCode" : '',
              "endDateRequired" : false,
              "cptRequired" : false,
              "posRequired" : false,
              "daysRequired" : false,
              "chargesRequired" : false,
              "revcodeRequired":false,
              "procedureCode" :'',
              "revCode" : '',
              "modifierCode1" : '',
              "modifierCode2" : '',
              "modifierCode3" : '',
              "modifierCode4" : '',
              "rxNationalDrugCode" : '',
              "serviceUnits" : '',
              "billedAmount" :'',
              "rowIndex" : i
          };
          rowList.push(providerFeeScheduleObj);
     }
       component.set('v.inputList',rowList);
       var diagnosisCodeObj = {
              "diagnosisCode1": '',
              "diagnosisCode2" :'',
              "diagnosisCode3" :'',
              "diagnosisCode4" : '',
              "diagnosisCode5" : '',
              "diagnosisCode6" : '',
              "diagnosisCode7" : '',
              "diagnosisCode8" : '',
              "diagnosisCode9" : '',
              "diagnosisCode10" : '',
              "diagnosisCode11" : '',
              "diagnosisCode12" : ''
          };
       component.set("v.diagnosisCode",diagnosisCodeObj);
       helper.getPlaceOfServiceValues(component,event,helper);
     

      
    },
    
    keyCheck : function(component, event, helper){
        component.find('addServiceLinesInput').reportValidity();

        if (event.which == 13){
            component.addServiceLinesOnEnter();
        }    
    },
    
    addServiceLines: function(component,event,helper){
        var addServicelinescmp = component.find('addServiceLinesInput');
        var addServicelinesvalue = addServicelinescmp.get("v.value");
        if($A.util.isEmpty(addServicelinesvalue)){
            addServicelinescmp.setCustomValidity("Error: You must enter a value.");   
        }else{
             addServicelinescmp.setCustomValidity("");   
        }
        addServicelinescmp.reportValidity();
    	var rowList = component.get("v.inputList");
     	var oldLength = rowList.length;
    	var additionalLines = component.get("v.addServiceLines");
    	var newLength = parseInt(oldLength) + parseInt(additionalLines);
    	if(newLength<76){
	    	for (var i = oldLength; i < newLength; i++){ 
	              var providerFeeScheduleObj = {
	              "dateOfServiceFrom" : '',
	              "startDateRequired" : false,
	              "dateOfServicethru" : '',
	              "placeOfServiceCode" : '',
	              "endDateRequired" : false,
	              "cptRequired" : false,
	              "posRequired" : false,
	              "daysRequired" : false,
	              "chargesRequired" : false,
	              "revcodeRequired":false,
	              "procedureCode" :'',
	              "revCode" : '',
	              "modifierCode1" : '',
	              "modifierCode2" : '',
	              "modifierCode3" : '',
	              "modifierCode4" : '',
	              "rxNationalDrugCode" : '',
	              "serviceUnits" : '',
	              "billedAmount" :'',
	              "rowIndex" : i
	          };
	          rowList.push(providerFeeScheduleObj);
	    	}
	    	var remainingLength = 75-parseInt(newLength);
	    	if(remainingLength>0){
	    		component.set('v.addServiceLinesMax','1...'+remainingLength);
	    		component.set('v.addServiceLinesRemaining', parseInt(remainingLength));
                if(newLength != 75){
	    		component.set('v.addServiceLinesMaxError','Max number of lines is 75, enter ' + remainingLength + ' or less');
                }}
	    	else{
	    		component.set('v.addServiceLinesMax','Max Rows');
//	    		component.set('v.addServiceLinesMax','');
	    		component.set('v.addServiceLinesDisabled', true);
	    	}
	    	component.set('v.addServiceLines','');
    	}
    	component.set('v.inputList',rowList);

    },
    
    searchResults: function(component,event,helper) {
        /**for (var i in startDateIdList) {
            console.log("@@: " + startDateIdList[i].get("v.value"));
        } */
         var returnError = false;
         var inValidData = false;
         var isValid;
         var claimForType;
         debugger;
       // var validatereqfields = helper.validatereqfields(component,event,helper); 
        if(component.get("v.claimType") == 'Professional-CMS1500') {
            claimForType = 'PROF';
        }else {
            claimForType = 'INST';
            var TypeOfBill = component.get("v.TypeOfBill");
             var isTypeofBillvalid = helper.isTypeofBillvalid(component,event,helper,TypeOfBill);
                                    if(!$A.util.isEmpty(TypeOfBill) && !isTypeofBillvalid){
                                       inValidData = true;
                                    }else if($A.util.isEmpty(TypeOfBill)) {
                                        inValidData = true;
                                    }
            var Admission_Date = component.find("Admission_Date_auraid").get('v.value');
            if($A.util.isEmpty(Admission_Date)){
                inValidData = true;
             }
            var Discharge_Date = component.find("Discharge_Date_auraid").get('v.value');
            var Invoice_Amount = component.get("v.Invoice_Amount");
            var DRG_Code = component.get("v.DRG_Code");
            if(!$A.util.isEmpty(DRG_Code)) {
            var isDRGCodevalid = helper.isDRGCodevalid(component,event,helper,DRG_Code);
                                    if(!isDRGCodevalid){
                                       inValidData = true;
                                    }   
            }
            /**var isDischargeadmissiondatesvalid = helper.isDischargeadmissiondatesvalid(component,event,helper,Admission_Date,Discharge_Date);
               if(!isDischargeadmissiondatesvalid){
                                       returnError = true;
                                    } */
        }
        var inputListValue= component.get("v.inputList");
        var claimLinesInput = new Array();
        for(var i in inputListValue) {
            var startDateValue = inputListValue[i].dateOfServiceFrom;
            var endDateValue =  inputListValue[i].dateOfServicethru;
            var cptValue = inputListValue[i].procedureCode;
            var revCodeValue = inputListValue[i].revCode;
            var modifier1IdList = component.find("modifierCode1"); 
            var modifier2IdList = component.find("modifierCode2"); 
            var modifier3IdList = component.find("modifierCode3"); 
            var modifier4IdList = component.find("modifierCode4");
            var modifier1Value = inputListValue[i].modifierCode1;
            var modifier2Value = inputListValue[i].modifierCode2;
            var modifier3Value = inputListValue[i].modifierCode3;
            var modifier4Value = inputListValue[i].modifierCode4;
            var drugValue = inputListValue[i].rxNationalDrugCode;
            var posValue = inputListValue[i].placeOfServiceCode;
            var daysValue = inputListValue[i].serviceUnits;
            var chargeValue = inputListValue[i].billedAmount;
            var rowIndex = inputListValue[i].rowIndex;
            debugger;
            if(claimForType != 'INST'){
               if(!$A.util.isEmpty(inputListValue[i].dateOfServiceFrom) || !$A.util.isEmpty(inputListValue[i].dateOfServicethru) || !$A.util.isEmpty(inputListValue[i].procedureCode) || !$A.util.isEmpty(inputListValue[i].placeOfServiceCode) || !$A.util.isEmpty(inputListValue[i].serviceUnits) || !$A.util.isEmpty(inputListValue[i].billedAmount)){
                inputListValue[i].startDateRequired = true;
                inputListValue[i].endDateRequired = true;
                inputListValue[i].daysRequired = true;
                inputListValue[i].chargesRequired = true;
              }
            }else {
                if(!$A.util.isEmpty(inputListValue[i].dateOfServiceFrom) || !$A.util.isEmpty(inputListValue[i].dateOfServicethru) || !$A.util.isEmpty(inputListValue[i].revCode) || !$A.util.isEmpty(inputListValue[i].serviceUnits) || !$A.util.isEmpty(inputListValue[i].billedAmount)) {
                   inputListValue[i].startDateRequired = true;
                   inputListValue[i].endDateRequired = true;
                   inputListValue[i].daysRequired = true;
                   inputListValue[i].chargesRequired = true; 
                }
            }
            component.set('v.inputList',inputListValue);
            var startDateRequired = inputListValue[i].startDateRequired;
            var endDateRequired = inputListValue[i].endDateRequired;
            var daysRequired = inputListValue[i].daysRequired;
            var chargesRequired = inputListValue[i].chargesRequired;
            if(startDateRequired == true && endDateRequired == true && daysRequired == true && chargesRequired == true) {
                claimLinesInput.push(inputListValue[i]);
                if(claimForType != 'INST'){
                    if (rowIndex != '0' && $A.util.isEmpty(inputListValue[i].dateOfServiceFrom) || $A.util.isEmpty(inputListValue[i].dateOfServicethru) || $A.util.isEmpty(inputListValue[i].procedureCode) || $A.util.isEmpty(inputListValue[i].placeOfServiceCode) || $A.util.isEmpty(inputListValue[i].serviceUnits) || $A.util.isEmpty(inputListValue[i].billedAmount)){
                        isValid = true;
                   } 
                }else{
                     if (rowIndex != '0' && $A.util.isEmpty(inputListValue[i].dateOfServiceFrom) || $A.util.isEmpty(inputListValue[i].dateOfServicethru) || $A.util.isEmpty(inputListValue[i].revCode) || $A.util.isEmpty(inputListValue[i].serviceUnits) || $A.util.isEmpty(inputListValue[i].billedAmount)){
                          isValid = true; 
                   }
                }
            }
          
            if(!$A.util.isEmpty(startDateValue) && !$A.util.isEmpty(endDateValue)) {
              var isDateValid = helper.validateDate(component,event,helper,startDateValue,endDateValue,rowIndex);
              if (!isDateValid){  
                   inValidData = true;
                 }
            }
            if(!$A.util.isEmpty(cptValue)) {
                var isValidCpt = helper.validateCpt(component,event,helper,5,rowIndex);
                if (!isValidCpt){                
                    inValidData = true;
                 }
            }
            if(!$A.util.isEmpty(modifier1Value)) {
                var isValidModifier1 = helper.validateModifier1(component,event,helper,2,rowIndex);
                if (!isValidModifier1){ 
                    inValidData = true;
                 }
            }
            if(!$A.util.isEmpty(modifier2Value)) {
                var isValidModifier2 = helper.validateModifier2(component,event,helper,2,rowIndex);
                if (!isValidModifier2){   
                    inValidData = true;
                 }
            }
            if(!$A.util.isEmpty(modifier3Value)) {
                var isValidModifier3 = helper.validateModifier3(component,event,helper,2,rowIndex);
                if (!isValidModifier3){ 
                    inValidData = true;
                 }
            }
            if(!$A.util.isEmpty(modifier4Value)) {
                var isValidModifier4 = helper.validateModifier4(component,event,helper,2,rowIndex);
                if (!isValidModifier4){ 
                    inValidData = true;
                 }
            }
            if(!$A.util.isEmpty(drugValue)) {
                var isValidDrugCode = helper.validateDrugCode(component,event,helper,11,rowIndex);
                if (!isValidDrugCode){ 
                    inValidData = true;
                 }
            }
            if(claimForType == 'INST'){
            if(!$A.util.isEmpty(revCodeValue)) {
                var validaterevCode = helper.validaterevCode(component,event,helper,4,rowIndex);
                if (!validaterevCode){                  
                    inValidData = true;
                 }
            }
               
            }
        }
         //Search without field
            if(claimForType != 'INST'){
            if ($A.util.isEmpty(inputListValue[0].dateOfServiceFrom) || $A.util.isEmpty(inputListValue[0].dateOfServicethru) || $A.util.isEmpty(inputListValue[0].procedureCode) || $A.util.isEmpty(inputListValue[0].placeOfServiceCode) || $A.util.isEmpty(inputListValue[0].serviceUnits) || $A.util.isEmpty(inputListValue[0].billedAmount)){
                            isValid = true;
                   } 
                }else{
                     if ($A.util.isEmpty(inputListValue[0].dateOfServiceFrom) || $A.util.isEmpty(inputListValue[0].dateOfServiceFrom) || $A.util.isEmpty(inputListValue[0].serviceUnits) || $A.util.isEmpty(inputListValue[0].billedAmount)){
                            isValid = true; 
                                }
                }
            if(inValidData) {
                 helper.fireToast("Error:", "You must enter a valid value", component, event, helper);
                 returnError = true; 
            }else {
                if(isValid) {
                   helper.fireToast("Error:", "You must enter a value", component, event, helper);
                   returnError = true; 
                }
                 
            }
        
        //cmp.set("v.inputList", invar);
         //console.log(jsonObj);
        // var jsonStr = JSON.stringify(jsonObj);
        debugger;
        var DOSFromToday = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
        var DOSThruToday = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
        var pricingSetId = component.get("v.pricingSetId");
        var claimLinesInputStr = JSON.stringify(claimLinesInput);
        console.log('Json' +claimLinesInputStr);
        //alert(claimLinesInputStr);
        //var pricingSetId = 'MSPSNEWNG93052';
        var diagCodes = component.get("v.diagnosisCode");
        if(returnError) {
            return;  
        }
        helper.showResults(component,event,helper,DOSFromToday,DOSThruToday,pricingSetId,diagCodes,claimLinesInputStr,claimForType);
    },
    providerFeeScheduleToggle : function(component,event,helper) {
       component.set("v.doCollapse",true);
},
    diagCodeValidations: function (component, event, helper) {
       var regex = new RegExp("^[a-zA-Z0-9. ]+$");  
        var str = String.fromCharCode(!event.charCode ? event.which : event.charCode);
        if (regex.test(str)){
            return true;
        }else{ 
            event.preventDefault();
            return false;
        }
	},
    allowAlphaNumericCharacters: function (component, event, helper) {
       var regex = new RegExp("^[a-zA-Z0-9 ]+$");  
        var str = String.fromCharCode(!event.charCode ? event.which : event.charCode);
        if (regex.test(str)){
            return true;
        }else{ 
            event.preventDefault();
            return false;
        }
	},
    allowNumbersAndDot: function (component, event, helper) {
       var regex = new RegExp("^[0-9.]+$"); 
        var str = String.fromCharCode(!event.charCode ? event.which : event.charCode);
        if (regex.test(str)){
            return true;
        }else{ 
            event.preventDefault();
            return false;
        }
    },
    chargeValidation : function(component,event,helper) {
         var chargeAmount = event.currentTarget.getAttribute("data-Charges");
         if(!$A.util.isEmpty(chargeAmount)) {
             helper.onlyDotsAndNumbers(component,event,helper,chargeAmount);
         }
    },
    clearResults : function(component,event,helper) {
   helper.clearresultshelper(component,event,helper);
    helper.reinstatetablerowshelper(component,event,helper);   
            component.find('addServiceLinesInput').reportValidity();
    
    },
    requiredfieldval :  function(component, event, helper) {
         var cmpauraid = event.currentTarget.getAttribute("data-auraid") ; 
          var rowIndex = event.currentTarget.getAttribute("data-Index") ;  
           var claimtypye = component.get("v.claimType");
        	
		  var startDatecmp = component.find('startDateId')[rowIndex];
        var startDatecmpval  = startDatecmp.get("v.value");
        var startDatecmpisbadinput = startDatecmp.get("v.validity").badInput;
         var endDatecmp = component.find('endDateId')[rowIndex];
        var endDatecmpval  = endDatecmp.get("v.value");
        var endDatecmpisbadinput = endDatecmp.get("v.validity").badInput;
         var chargescmp = component.find('charges')[rowIndex];
        var chargescmpval  = chargescmp.get("v.value");
      
         var daysOrUnitscmp = component.find('daysOrUnits')[rowIndex];
        var daysOrUnitscmpval  = daysOrUnitscmp.get("v.value");
        
        if(claimtypye =='Facility-UB04'){
        var revcodecmp = component.find('revcodeid')[rowIndex];
       var revcodecmpval  = revcodecmp.get("v.value");
        }else{
              var cptCodecmp = component.find('cptCodeId')[rowIndex];
        var cptCodecmpval  = cptCodecmp.get("v.value");
           
       var poscmp = component.find('posId')[rowIndex];
       var poscmpcmpval  = poscmp.get("v.value");
        }
       var clearvalidations ;
         if(claimtypye !='Facility-UB04' && $A.util.isEmpty(startDatecmpval)&& !startDatecmpisbadinput && $A.util.isEmpty(endDatecmpval) &&!endDatecmpisbadinput&&$A.util.isEmpty(cptCodecmpval)&& $A.util.isEmpty(daysOrUnitscmpval)&&$A.util.isEmpty(chargescmpval)&&$A.util.isEmpty(poscmpcmpval)){
                      clearvalidations = 'true';
         }else if(claimtypye =='Facility-UB04' && $A.util.isEmpty(startDatecmpval)&& !startDatecmpisbadinput && $A.util.isEmpty(endDatecmpval) &&!endDatecmpisbadinput&& $A.util.isEmpty(daysOrUnitscmpval)&&$A.util.isEmpty(chargescmpval)&&$A.util.isEmpty(revcodecmpval)){
            
             clearvalidations = 'true';
         } 
	   if(clearvalidations){
           clearvalidations='';
           if(claimtypye =='Facility-UB04'){
            helper.clearvalidationContent(component,event,helper,'revcodeid',rowIndex);
           // helper.cleardatesvalidationContent(component,event,helper,'TypeOfBill_auraid','');
          //  helper.cleardatesvalidationContent(component,event,helper,'Admission_Date_auraid','');
        }else{
        helper.clearposvalidationContent(component,event,helper,rowIndex);
        helper.clearvalidationContent(component,event,helper,'cptCodeId',rowIndex);

        }
        helper.cleardatesvalidationContent(component,event,helper,'startDateId',rowIndex);
        helper.cleardatesvalidationContent(component,event,helper,'endDateId',rowIndex);
        helper.clearvalidationContent(component,event,helper,'daysOrUnits',rowIndex);
        helper.clearvalidationContent(component,event,helper,'charges',rowIndex);

       }else{
         if(claimtypye =='Facility-UB04'){
            helper.validateinputshelper(component,event,helper,'revcodeid',rowIndex);
          // helper.validateinputshelper(component,event,helper,'TypeOfBill_auraid','');
         //   helper.validateinputshelper(component,event,helper,'Admission_Date_auraid','');
        }else{
              debugger;
              helper.posfieldvalidationhelper(component,event,helper,rowIndex);
        helper.validateinputshelper(component,event,helper,'cptCodeId',rowIndex);

        }
        helper.requiredfieldvaldates(component,event,helper,'startDateId',rowIndex);
        helper.requiredfieldvaldates(component,event,helper,'endDateId',rowIndex);
        helper.validateinputshelper(component,event,helper,'daysOrUnits',rowIndex);
       helper.validateinputshelper(component,event,helper,'charges',rowIndex);       

       }
},
  
   requiredfieldvalpos :  function(component, event, helper) {
         var cmpauraid = event.currentTarget.getAttribute("data-auraid") ; 
          var rowIndex = event.currentTarget.getAttribute("data-Index") ;  
         var inputcmp  = component.find(cmpauraid)[rowIndex];
         var inputcmpval = inputcmp.get("v.value");
        
        if(inputcmpval == '--None--'){
        inputcmp.setCustomValidity("Error: You must enter a value.");
        }else{
         inputcmp.setCustomValidity("");
        }
         inputcmp.reportValidity();
},
     onchangeTypeOfBill : function(component, event, helper) {
         var TypeOfBill = component.get("v.TypeOfBill");
         var inputTypeOfBill = component.find("TypeOfBill_auraid");
         if(isNaN(TypeOfBill)){
            component.set("v.TypeOfBill","");
        }
        if($A.util.isEmpty(TypeOfBill)){
        inputTypeOfBill.setCustomValidity("Error: You must enter a value.");
           inputTypeOfBill.reportValidity();
            return false;
        }else{
            if(TypeOfBill.length < 4){ 
        inputTypeOfBill.setCustomValidity("Error: You must enter 4 digits.");
           inputTypeOfBill.reportValidity();
            return false;
        }else {
         component.set('v.TypeOfBill',TypeOfBill.substring(0,4));
            inputTypeOfBill.setCustomValidity("");
            inputTypeOfBill.reportValidity();
            return true;
        }
        }
 
    },
     onchangeDRGCode : function(component, event, helper) {
         var DRG_Code = component.get("v.DRG_Code");
         var inputDrgcodecmp = component.find("DRG_Code_auraid"); 
               if(!$A.util.isEmpty(DRG_Code)){
            if(DRG_Code.length < 3){ 
        inputDrgcodecmp.setCustomValidity("Error: You must enter 3 digits.");
            return false;
        }else {
            component.set('v.DRG_Code',DRG_Code.substring(0,3));
            inputDrgcodecmp.setCustomValidity("");
            return true;
        }
               }else{
                              inputDrgcodecmp.setCustomValidity("");
 
               }
                     inputDrgcodecmp.reportValidity();

    },
    onchangeAdmissionDate: function(component, event, helper) {
         var admissionDateCmp = component.find("Admission_Date_auraid"); 
        var admissiondateval = admissionDateCmp.get("v.value");
               var admissionDatebadinput = admissionDateCmp.get("v.validity").badInput;

               if($A.util.isEmpty(admissiondateval)){
         admissionDateCmp.setCustomValidity("Error: You must enter a value."); 
                
               }
         if(admissionDatebadinput){
                               admissionDateCmp.setCustomValidity("Valid Format: MM/DD/YYYY"); 
                   }
            else{
                            admissionDateCmp.setCustomValidity(""); 
               }
 admissionDateCmp.reportValidity();
    },
     OnchangeDischargeDate : function(component, event, helper) {
         var Admission_Date = new Date(component.find("Admission_Date_auraid").get("v.value"));
         var Discharge_Date = new Date(component.find("Discharge_Date_auraid").get("v.value"));
         var inputCmp = component.find("Discharge_Date_auraid");
        if(Admission_Date > Discharge_Date){
         inputCmp.setCustomValidity("Error: Discharge Date must be later than Admission Date.");
        }else{
          inputCmp.setCustomValidity(""); 
        }
         inputCmp.reportValidity();

    },
    onchangeclaimtype:function(component,event,helper){
     component.set('v.providerFeeScheduleMap','');
     component.set('v.providerMap','');
      debugger;    
   helper.clearresultshelper(component,event,helper);
    helper.reinstatetablerowshelper(component,event,helper); 

    },
    onchangepos:function(component,event,helper){
        var poscmp = event.getSource();
        poscmp.set("v.value","");
         poscmp.setCustomValidity("Error: You must enter 4 digits.");
            poscmp.reportValidity();
        
    },
    clearServiceLine : function(component,event,helper) {
        var rowIndex = event.currentTarget.getAttribute("data-Index"); 
        console.log('rowIndex'+rowIndex);
        var date1 = new Date();
        var today = date1.getFullYear() + "/" + (date1.getMonth() + 1) + "/" + date1.getDate();
        var cmpstart =  component.find("startDateId")[rowIndex];
        var cmpend =  component.find("endDateId")[rowIndex];
        cmpstart.set("v.value",today);  
        cmpend.set("v.value",today); 
        helper.clearvalidationContent(component,event,helper,'startDateId',rowIndex);
        helper.clearvalidationContent(component,event,helper,'endDateId',rowIndex);
        helper.clearvalidationContent(component,event,helper,'cptCodeId',rowIndex);
        helper.clearvalidationContent(component,event,helper,'daysOrUnits',rowIndex);
        helper.clearvalidationContent(component,event,helper,'charges',rowIndex); 
        helper.clearvalidationContent(component,event,helper,'revcodeid',rowIndex);
        helper.clearvalidationContent(component,event,helper,'modifierId1',rowIndex);
        helper.clearvalidationContent(component,event,helper,'modifierId2',rowIndex);
        helper.clearvalidationContent(component,event,helper,'modifierId3',rowIndex);
        helper.clearvalidationContent(component,event,helper,'modifierId4',rowIndex);
        helper.clearvalidationContent(component,event,helper,'drugCode',rowIndex);
        helper.clearposvalidationContent(component,event,helper,'posId',rowIndex);
        var inputListRequired = component.get("v.inputList");
        inputListRequired[rowIndex].startDateRequired = false;
        inputListRequired[rowIndex].daysRequired= false;
        inputListRequired[rowIndex].chargesRequired= false;
        inputListRequired[rowIndex].endDateRequired = false;
        component.set('v.inputList',inputListRequired);
    },
    copyServiceLine : function(component,event,helper) {
        var rowIndex = event.currentTarget.getAttribute("data-Index");
        console.log('rowIndex'+rowIndex);
        var dataAvailableInCurrentRow = false;
        var startDateVal,endDateVal,modifier1Val,modifier2Val,modifier3Val,modifier4Val,posVal,daysOrUnitsVal;
        var claimType = component.get("v.claimType");
        if(dataAvailableInCurrentRow == false){
           var startDateCmp = component.find('startDateId')[rowIndex];
           startDateVal = startDateCmp.get("v.value");
           var endDateCmp = component.find('endDateId')[rowIndex];
           endDateVal = endDateCmp.get("v.value");
           var modifier1Cmp = component.find('modifierId1')[rowIndex];
           modifier1Val = modifier1Cmp.get("v.value");
           var modifier2Cmp = component.find('modifierId2')[rowIndex];
           modifier2Val = modifier2Cmp.get("v.value");
           var modifier3Cmp = component.find('modifierId3')[rowIndex];
           modifier3Val= modifier3Cmp.get("v.value");
           var modifier4Cmp = component.find('modifierId4')[rowIndex];
           modifier4Val= modifier4Cmp.get("v.value");
           if(claimType == 'Professional-CMS1500') {
             var posCmp = component.find('posId')[rowIndex];
             posVal= posCmp.get("v.value");
           }
           var daysOrUnitsCmp = component.find('daysOrUnits')[rowIndex];
           daysOrUnitsVal= daysOrUnitsCmp.get("v.value");
        }
            if(!$A.util.isEmpty(startDateVal) || !$A.util.isEmpty(endDateVal) || !$A.util.isEmpty(modifier1Val) || !$A.util.isEmpty(modifier2Val) || !$A.util.isEmpty(modifier3Val) || !$A.util.isEmpty(modifier4Val) || !$A.util.isEmpty(posVal) || !$A.util.isEmpty(daysOrUnitsVal)) {
               dataAvailableInCurrentRow = true;
            }
            if(dataAvailableInCurrentRow == false) {
                return;
            }
            var rowNumToCopy = parseInt(rowIndex)+1;
            var allServiceLines = [];
            for(var i=rowNumToCopy;i<76;i++){
                allServiceLines.push(i);
            }
            var rowData;
             for(var i in allServiceLines) {
                 i  = rowNumToCopy;
             var dataNotAvailableInNextRow = true;
             var startDateValNextRow =  component.find('startDateId')[i].get("v.value");  
             var endDateValNextRow = component.find('endDateId')[i].get("v.value");
             var modifier1ValNextRow = component.find('modifierId1')[i].get("v.value");
             var modifier2ValNextRow = component.find('modifierId2')[i].get("v.value");
             var modifier3ValNextRow = component.find('modifierId3')[i].get("v.value");
             var modifier4ValNextRow = component.find('modifierId4')[i].get("v.value");
             var daysOrUnitsValNextRow = component.find('daysOrUnits')[i].get("v.value");
             var chargesValNextRow = component.find('charges')[i].get("v.value");
             var drugCodeValNextRow =  component.find('drugCode')[i].get("v.value");
             var cptValNextRow = component.find('cptCodeId')[i].get("v.value");
             if(claimType == 'Professional-CMS1500') {
                var posValNextRow = component.find('posId')[i].get("v.value");
                if(!$A.util.isEmpty(startDateValNextRow) || !$A.util.isEmpty(endDateValNextRow) || !$A.util.isEmpty(modifier1ValNextRow) || !$A.util.isEmpty(modifier2ValNextRow) || !$A.util.isEmpty(modifier3ValNextRow) || !$A.util.isEmpty(modifier4ValNextRow) || !$A.util.isEmpty(posValNextRow) || !$A.util.isEmpty(daysOrUnitsValNextRow) || !$A.util.isEmpty(cptValNextRow) ||  !$A.util.isEmpty(drugCodeValNextRow) || !$A.util.isEmpty(chargesValNextRow)) {
                   dataNotAvailableInNextRow = false; 
                   rowNumToCopy = rowNumToCopy+1;
                }
             }else {
                 var revCodeValNextRow = component.find('revcodeid')[i].get("v.value");
                 if(!$A.util.isEmpty(startDateValNextRow) || !$A.util.isEmpty(endDateValNextRow) || !$A.util.isEmpty(modifier1ValNextRow) || !$A.util.isEmpty(modifier2ValNextRow) || !$A.util.isEmpty(modifier3ValNextRow) || !$A.util.isEmpty(modifier4ValNextRow) || !$A.util.isEmpty(revCodeValNextRow) || !$A.util.isEmpty(daysOrUnitsValNextRow) || !$A.util.isEmpty(cptValNextRow) ||  !$A.util.isEmpty(drugCodeValNextRow) || !$A.util.isEmpty(chargesValNextRow)) {
                   dataNotAvailableInNextRow = false; 
                   rowNumToCopy = rowNumToCopy+1;
                }
             }
                if(dataNotAvailableInNextRow == true){ 
                    //rowNumToCopy = i;
                    break;
                } 
            } 
            console.log(rowNumToCopy);
            component.find('startDateId')[rowNumToCopy].set("v.value",startDateVal);
            helper.requiredfieldvaldates(component,event,helper,'startDateId',rowNumToCopy);
            component.find('endDateId')[rowNumToCopy].set("v.value",endDateVal);
            helper.requiredfieldvaldates(component,event,helper,'endDateId',rowNumToCopy);
            component.find('modifierId1')[rowNumToCopy].set("v.value",modifier1Val);
            component.find('modifierId2')[rowNumToCopy].set("v.value",modifier2Val);
            component.find('modifierId3')[rowNumToCopy].set("v.value",modifier3Val);
            component.find('modifierId4')[rowNumToCopy].set("v.value",modifier4Val);
            if(claimType == 'Professional-CMS1500') {
               component.find('posId')[rowNumToCopy].set("v.value",posVal);
               helper.posfieldvalidationhelper(component,event,helper,rowNumToCopy);
               helper.validateinputshelper(component,event,helper,'cptCodeId',rowNumToCopy);
            }else {
                helper.validateinputshelper(component,event,helper,'revcodeid',rowNumToCopy);
            }
            component.find('daysOrUnits')[rowNumToCopy].set("v.value",daysOrUnitsVal);
            helper.validateinputshelper(component,event,helper,'daysOrUnits',rowNumToCopy);
            helper.validateinputshelper(component,event,helper,'charges',rowNumToCopy);   
    }
})