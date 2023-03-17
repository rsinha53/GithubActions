({
    getPlaceOfServiceValues : function(component,event,helper) {
        var action = component.get("c.getPlaceOfServicecmdt");
        action.setCallback(this, function(a) {
            var state = a.getState();
            if(state == "SUCCESS"){
                var result = a.getReturnValue();
                if(!$A.util.isEmpty(result) && !$A.util.isUndefined(result)){
                    var opts = [];
                    opts.push({label:'--None--',value:''});
                    for(var i=0; i < result.length; i++) {
                        opts.push({label:result[i].Place_Of_Service__c+'-'+result[i].Description__c,value:result[i].Place_Of_Service__c});
                    }
                    console.log("@@ opts: " + opts);
                    component.set('v.posOptions',opts);
                }
            }
        });
        $A.enqueueAction(action);
    },
    onlyDotsAndNumbers : function(component,event,helper,chargeAmount) {
        var charCode = (event.which) ? event.which : event.keyCode;
        if (charCode == 46) {
            if (chargeAmount.indexOf(".") < 0)
                return true;
            else {
                event.preventDefault();
                return false;
            }
        }
        
        if (chargeAmount.indexOf(".") > 0) {
            var txtlen = chargeAmount.length;
            var dotpos = chargeAmount.indexOf(".");
            if ((txtlen - dotpos) > 2)
                return false;
        }
        
        if (charCode > 31 && (charCode < 48 || charCode > 57))
            return false;
        
        return true;
    },
    validateDate : function(component,event,helper,startDateValue,endDateValue,rowIndex) {
       
        var startDateIdList = component.find("startDateId");
        var endDateIdList = component.find("endDateId");
        if(new Date(startDateValue) > new Date(endDateValue)) {
            endDateIdList[rowIndex].setCustomValidity("Error: End Date must be later than Start Date.");
            endDateIdList[rowIndex].reportValidity();
            return false;
        }else {
            endDateIdList[rowIndex].setCustomValidity("");
            endDateIdList[rowIndex].reportValidity();
            return true;
        }
        
    },
    validateCpt : function(component,event,helper,charlengthNum,rowIndex) {
        var cptIdList = component.find("cptCodeId");  
        var charString = cptIdList[rowIndex].get("v.value");
        if(charString.length != charlengthNum) {
            cptIdList[rowIndex].setCustomValidity("Error: You must enter 5 digits.");
            cptIdList[rowIndex].reportValidity();
            return false;
        }else {
            cptIdList[rowIndex].setCustomValidity("");
            cptIdList[rowIndex].reportValidity();
            return true;
        }
    },
    validateModifier1 : function(component,event,helper,charlengthNum,rowIndex) {  
        var modifiercmp = component.find("modifierId1");  
        
        var charString = modifiercmp[rowIndex].get("v.value");
        if(charString.length != charlengthNum) {
            modifiercmp[rowIndex].setCustomValidity("Error: You must enter 2 digits.");
            modifiercmp[rowIndex].reportValidity();
            return false;
        }else {
            modifiercmp[rowIndex].setCustomValidity("");
            modifiercmp[rowIndex].reportValidity();
            return true;
        }
    },
    validateModifier2 : function(component,event,helper,charlengthNum,rowIndex) {  
        var modifiercmp = component.find("modifierId2");  
        
        var charString = modifiercmp[rowIndex].get("v.value");
        if(charString.length != charlengthNum) {
            modifiercmp[rowIndex].setCustomValidity("Error: You must enter 2 digits.");
            modifiercmp[rowIndex].reportValidity();
            return false;
        }else {
            modifiercmp[rowIndex].setCustomValidity("");
            modifiercmp[rowIndex].reportValidity();
            return true;
        }
    },
    validateModifier3 : function(component,event,helper,charlengthNum,rowIndex) {  
        var modifiercmp = component.find("modifierId3");  
        
        var charString = modifiercmp[rowIndex].get("v.value");
        if(charString.length != charlengthNum) {
            modifiercmp[rowIndex].setCustomValidity("Error: You must enter 2 digits.");
            modifiercmp[rowIndex].reportValidity();
            return false;
        }else {
            modifiercmp[rowIndex].setCustomValidity("");
            modifiercmp[rowIndex].reportValidity();
            return true;
        }
    },
    validateModifier4 : function(component,event,helper,charlengthNum,rowIndex) {  
        var modifiercmp = component.find("modifierId4");  
        
        var charString = modifiercmp[rowIndex].get("v.value");
        if(charString.length != charlengthNum) {
            modifiercmp[rowIndex].setCustomValidity("Error: You must enter 2 digits.");
            modifiercmp[rowIndex].reportValidity();
            return false;
        }else {
            modifiercmp[rowIndex].setCustomValidity("");
            modifiercmp[rowIndex].reportValidity();
            return true;
        }
    },
    validateDrugCode : function(component,event,helper,charlengthNum,rowIndex) {
        var drugCodeIdList = component.find("drugCode");  
        var charString = drugCodeIdList[rowIndex].get("v.value");
        if(charString.length != charlengthNum) {
            drugCodeIdList[rowIndex].setCustomValidity("Error: You must enter 11 digits.");
            drugCodeIdList[rowIndex].reportValidity();
            return false;
        }else {
            drugCodeIdList[rowIndex].setCustomValidity("");
            drugCodeIdList[rowIndex].reportValidity();
            return true;
        }
    },  validaterevCode : function(component,event,helper,charlengthNum,rowIndex) {
        var revCodeIdList = component.find("revcodeid");  
        var charString = revCodeIdList[rowIndex].get("v.value");
        if(charString.length != charlengthNum) {
            revCodeIdList[rowIndex].setCustomValidity("Error: You must enter 4 digits.");
            revCodeIdList[rowIndex].reportValidity();
            return false;
        }else {
            revCodeIdList[rowIndex].setCustomValidity("");
            revCodeIdList[rowIndex].reportValidity();
            return true;
        }
                    

    }  ,
    fireToast: function(title, messages, component, event, helper){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": messages,
            "type": "error",
            "mode": "dismissible",
            "duration": "20000"
        });
        toastEvent.fire();
        //helper.hideSpinner2(component, event, helper);
        return;
        
    },
    isTypeofBillvalid:function(component,event,helper,TypeOfBill) {
        var inputTypeOfBill = component.find("TypeOfBill_auraid"); 
        if($A.util.isEmpty(TypeOfBill)){
            inputTypeOfBill.setCustomValidity("Error: You must enter a value.");
            return false;
        }else{
            if(TypeOfBill.length < 4){ 
                inputTypeOfBill.setCustomValidity("Error: You must enter 4 digits.");
                return false;
            }else {
                inputTypeOfBill.setCustomValidity("");
                return true;
            }
        }
                        inputTypeOfBill.reportValidity();

    },
    isDRGCodevalid:function(component,event,helper,DRG_Code){
        var inputDrgcodecmp = component.find("DRG_Code_auraid"); 
        if(!$A.util.isEmpty(DRG_Code)){
            
            if(DRG_Code.length < 3){ 
                inputDrgcodecmp.setCustomValidity("Error: You must enter 3 digits.");
                inputDrgcodecmp.reportValidity();
                return false;
            }else {
                inputDrgcodecmp.setCustomValidity("");
                inputDrgcodecmp.reportValidity();
                return true;
            }
        }
    },
    isDischargeadmissiondatesvalid: function(component,event,helper,Admission_Date,Discharge_Date) {
        var Admission_Date_cmp = component.find("Admission_Date_auraid");
        var Discharge_Date_auraid = component.find("Discharge_Date_auraid");
        
        if($A.util.isEmpty(Admission_Date)){

            Admission_Date_cmp.reportValidity();
            return false;
        }else{
            if(new date(Admission_Date) > new date(Discharge_Date)){ 
                Discharge_Date_auraid.setCustomValidity("Error: Discharge Date must be later than Admission Date.");
                Discharge_Date_auraid.reportValidity();
                return false;
            }else {
                inputTypeOfBill.setCustomValidity("");
                inputTypeOfBill.reportValidity();
                return true;
            }
            Admission_Date_cmp.setCustomValidity("");
            Admission_Date_cmp.reportValidity();
            return true;
        }        
    },
    clearvalidationContent: function(component,event,helper,cmpauraid,indexnum) {
       if(!$A.util.isUndefined(component.find(cmpauraid))) {
        if(indexnum){
            if(!$A.util.isUndefined(component.find(cmpauraid+'div'))) {
                  var inputcmpdiv = component.find(cmpauraid+'div')[indexnum];
            }
                 var inputcmp = component.find(cmpauraid)[indexnum];
       }else{
                 var inputcmp = component.find(cmpauraid);
            }
        if(!$A.util.isUndefined(inputcmpdiv)) {
             $A.util.removeClass(inputcmpdiv, 'slds-has-error');
        }
        inputcmp.set("v.value","");
        inputcmp.setCustomValidity("");
        inputcmp.reportValidity();  
       }
    },
    
    clearresultshelper:function(component,event,helper){
          debugger;
             component.set("v.requiredfields",false);  
        
        var claimDataListValue= component.get("v.inputList");
        var claimtypye = component.get("v.claimType");
        if(claimtypye =='Facility-UB04'){
            component.find('TypeOfBill_auraid').set("v.value","");
            helper.clearvalidationContent(component,event,helper,'TypeOfBill_auraid','');
            helper.clearvalidationContent(component,event,helper,'DRG_Code_auraid','');
            helper.cleardatesvalidationContent(component, event, helper,'Admission_Date_auraid','');
            helper.cleardatesvalidationContent(component,event,helper,'Discharge_Date_auraid','');                                helper.clearvalidationContent(component,event,helper,'Invoice_Amount_auraid','');
        } 
        component.find("diagCode1").set("v.value","");
        component.find("diagCode2").set("v.value","");
        component.find("diagCode3").set("v.value","");
        component.find("diagCode4").set("v.value","");
        component.find("diagCode5").set("v.value","");
        component.find("diagCode6").set("v.value","");
        component.find("diagCode7").set("v.value","");
        component.find("diagCode8").set("v.value","");
        component.find("diagCode9").set("v.value","");
        component.find("diagCode10").set("v.value","");
        component.find("diagCode11").set("v.value","");
        component.find("diagCode12").set("v.value","");
        
        for(var i in claimDataListValue) {
            var oggi = new Date();
            var today = oggi.getFullYear() + "/" + (oggi.getMonth() + 1) + "/" + oggi.getDate();
            var cmpstart =  component.find("startDateId")[i];
            var cmpend =  component.find("endDateId")[i];
            cmpstart.set("v.value",today);  
            cmpend.set("v.value",today);  
            helper.clearvalidationContent(component,event,helper,'startDateId',i);
            helper.clearvalidationContent(component,event,helper,'endDateId',i);
            helper.clearvalidationContent(component,event,helper,'cptCodeId',i);
            helper.clearvalidationContent(component,event,helper,'daysOrUnits',i);
            helper.clearvalidationContent(component,event,helper,'charges',i);            
            helper.clearvalidationContent(component,event,helper,'revcodeid',i);
            helper.clearposvalidationContent(component,event,helper,'posId',i);

            
            helper.clearvalidationContent(component,event,helper,'modifierId1',i);
            helper.clearvalidationContent(component,event,helper,'modifierId2',i);
            helper.clearvalidationContent(component,event,helper,'modifierId3',i);
            helper.clearvalidationContent(component,event,helper,'modifierId4',i);
            helper.clearvalidationContent(component,event,helper,'drugCode',i);
            claimDataListValue[i].startDateRequired = false;
            claimDataListValue[i].endDateRequired = false;
            claimDataListValue[i].daysRequired = false;
            claimDataListValue[i].chargesRequired = false;
            claimDataListValue[i].cptRequired = false;
            claimDataListValue[i].posRequired = false;
            claimDataListValue[i].revcodeRequired =false;
        }
        
         component.set("v.requiredfields",true);
         var addServicelinescmp = component.find('addServiceLinesInput');
         addServicelinescmp.setCustomValidity("");   
         addServicelinescmp.reportValidity();   
        
}
    ,
    showResults : function(component,event,helper,DOSFromToday,DOSThruToday,pricingSetId,diagCodes,claimLinesInputStr,claimForType) {  
        debugger;
        console.log('Inside Search');
        var claimType = component.get("v.claimType");
        var drgCode = component.get("v.DRG_Code");
        var invoiceAmountValue = component.get("v.Invoice_Amount");
        var typeOfBill = component.get("v.TypeOfBill");
        var admissionDate;
        var dischargeDate;
        var invoiceAmountValue;
        var invoiceAmount = '';
        if(claimType == 'Facility-UB04') {
            admissionDate = component.find("Admission_Date_auraid").get("v.value"); 
            dischargeDate = component.find("Discharge_Date_auraid").get("v.value");
            invoiceAmountValue = component.find("Invoice_Amount_auraid").get("v.value");
        } 
        helper.showSpinner2(component, event, helper);
        var result = true;
        var action = component.get("c.getProviderFeeScheduleSearchResults");
        console.log('Inside Search  11');
        if(!$A.util.isEmpty(invoiceAmountValue) && !$A.util.isUndefined(invoiceAmountValue)) {
             invoiceAmount = invoiceAmountValue;
        }
        var firstSearch = false;
        if (result){
            // Setting the apex parameters
            action.setParams({
                "DOSFromToday": DOSFromToday,
                "DOSThruToday" : DOSThruToday,
                "pricingSetId" : pricingSetId,
                "diagCodes" : diagCodes,  
                "claimLinesInput" : claimLinesInputStr,
                "claimType" : claimType,
                "drgCode" : drgCode,
                "invoiceAmount" : invoiceAmount,
                "admissionDate" : admissionDate,
                "dischargeDate" : '',
                "revcode" : '',
                "claimforType" : claimForType,
                "typeOfBill" : typeOfBill
                
            });
            console.log('Inside Search  22');
            
            //Setting the Callback
            action.setCallback(this,function(a){
                //get the response state
                
                var state = a.getState();
                console.log('----state---'+state);
                debugger;
                if(claimType == 'Professional-CMS1500') {
                   var recordExists = component.get('v.providerMap');
                   console.log('recordExists-----'+recordExists);
                }else if(claimType == 'Facility-UB04') {
                      var existingMap = component.get('v.providerMap');
                     if(existingMap && existingMap != '') {
                       var providerMap = component.get('v.providerMap');
                    }else {
                        var providerMap = new Array();
                    }     
                }
                if(state == "SUCCESS"){                   
                    var result = a.getReturnValue();
                    
                    console.log('------result--------'+result);
                    if(!$A.util.isEmpty(result) && !$A.util.isUndefined(result)){
                        console.log(result.resultWrapper);     
                        component.set("v.providerFeeScheduleMap",result.resultWrapper);
                        firstSearch = true;
                        for(var singleKey in result.resultWrapper) {   
                            var currResponse = new Array();
                            
                            currResponse.push({"key": singleKey, "value": result.resultWrapper[singleKey]});
                            console.log('before check dup');
                            if(claimType == 'Professional-CMS1500') {
                                helper.checkDuplicate(component,currResponse,recordExists);
                  
        
                            }else if(claimType == 'Facility-UB04') {
                                providerMap.push({"key": singleKey, "value": result.resultWrapper[singleKey]});
                            }
                            
                            //if(retVal){
                            //providerMap.push({"key": singleKey, "value": result.resultWrapper[singleKey]});
                            //} 
                            
                        }
                        console.log(JSON.stringify(providerMap));
                        if(claimType == 'Facility-UB04') {
                            component.set('v.providerMap',providerMap);
                            
                        }
                        //component.set('v.providerMap',providerMap);
                    }
                    setTimeout(function(){
                                 var tabKey = component.get("v.AutodocKey")+component.get("v.GUIkey");
                                 console.log(tabKey);
                                 window.lgtAutodoc.initAutodoc(tabKey);
                              },2); 
                } else if(state == "ERROR"){
                    
                }
                helper.hideSpinner2(component, event, helper);
            });
            
            //adds the server-side action to the queue        
            $A.enqueueAction(action);
        }
    },
    checkDuplicate: function(component,currResponse,recordExists){
            debugger;
            console.log('start fun');
            console.log(JSON.stringify(currResponse));
            console.log(JSON.stringify(recordExists));
            var providerMap = component.get('v.providerMap');
            let prvIdentifierSet = new Set();
            var arrval = recordExists;
            console.log(arrval); 
            console.log(currResponse);
            var currChildArray = new Array();
            var currChildArray = currResponse[0].value;
            console.log(JSON.stringify(currChildArray)); 
            console.log('End fun');
            if(recordExists != null && recordExists != '') {
            for(var i=0; i < recordExists.length; i++){
                var itemVal = recordExists[i].value;
                if(itemVal != null && itemVal != '' && itemVal != 'undefined') {
                     //alert(itemVal);
                     console.log(JSON.stringify(itemVal));
                     let identifier = itemVal[0].dateOfServiceFrom + '' + itemVal[0].dateOfServiceThru + '' + itemVal[0].procedureCode + '' + itemVal[0].modifierPricedList +  itemVal[0].placeOfServiceCode + '' + itemVal[0].drgCode + '' + itemVal[0].serviceUnits + '' + itemVal[0].billedAmount + '' + itemVal[0].pricingSetId;
                    if(!prvIdentifierSet.has(identifier)){
                        prvIdentifierSet.add(identifier);
                   }
                }
               }
            }  
          if(currChildArray != null && currChildArray != '') {
            for(var i=0; i < currChildArray.length; i++){
                let identifier = currChildArray[i].dateOfServiceFrom + '' + currChildArray[i].dateOfServiceThru + '' + currChildArray[i].procedureCode + '' + currChildArray[i].modifierPricedList + '' + currChildArray[i].placeOfServiceCode + '' + currChildArray[i].drgCode + '' + currChildArray[i].serviceUnits + '' + currChildArray[i].billedAmount + '' + currChildArray[i].pricingSetId;
                if(!prvIdentifierSet.has(identifier)){
                    prvIdentifierSet.add(identifier);
                    providerMap.push({"key": currResponse[0].key, "value": new Array(currChildArray[i])});
                }
            }
           }
        component.set('v.providerMap', providerMap);
        //alert(component.get('v.providerMap'));
    },
    validatereqfields: function(component,event,helper){
        for(var i=0;i<50;i++){
            document.getElementById("0_startDateId").getAttribute("data-value");
        }
    },
    hideSpinner2 : function(component, event, helper) {	
        console.log('Hiding Spinner2');
        component.set("v.Spinner", false);
    },
    showSpinner2: function(component, event, helper) {
        // make Spinner attribute true for display loading spinner 
        component.set("v.Spinner", true); 
    },
    validateinputshelper: function(component, event, helper,cmpauraid,indexnum) {
        if(indexnum){
            var inputcmp = component.find(cmpauraid)[indexnum];
                        var inputcmpdiv = component.find(cmpauraid+'div')[indexnum];

        }else{
            var inputcmp = component.find(cmpauraid);
                                    var inputcmpdiv = component.find(cmpauraid+'div');

        }
        var inputcmpval = inputcmp.get("v.value");
        if($A.util.isEmpty(inputcmpval)  ){
          $A.util.addClass(inputcmpdiv, 'slds-has-error');
        }else{
          $A.util.removeClass(inputcmpdiv, 'slds-has-error');
        }
    },
    posfieldvalidationhelper: function(component, event, helper,Indexnum) {
        debugger;
        var posinputcmp = component.find('posId')[Indexnum];
       var posinputcmpval = posinputcmp.get("v.value");
        var posmessgediv = component.find('posmessgediv')[Indexnum];
        var posmessgedivtext = component.find('posmessgedivtext')[Indexnum];
      var posmessgedivtextval = posmessgedivtext.get("v.value");
        if($A.util.isEmpty(posinputcmpval) ){
          $A.util.addClass(posmessgediv, 'slds-has-error');
      //  posmessgedivtext.set("v.value","Error: You must enter a value.");
        }else{
             $A.util.removeClass(posmessgediv, 'slds-has-error');
       // posmessgedivtext.set("v.value","");
        }
          
          },
    requiredfieldvaldates :  function(component, event, helper,cmpauraid,rowIndex) {
        if(rowIndex){
         var inputcmp  = component.find(cmpauraid)[rowIndex];
                         var inputcmpdiv  = component.find(cmpauraid+'div')[rowIndex];
        } else{
              var inputcmp  = component.find(cmpauraid);
                         var inputcmpdiv  = component.find(cmpauraid+'div');
           
            }
        
         var inputcmpval = inputcmp.get("v.value");
         var inputcmpvalidity = inputcmp.get("v.validity");
        var inputcmpisbadinput = inputcmpvalidity.badInput;
        var inputcmpiscustomerror  = inputcmpvalidity.customError;
        if($A.util.isEmpty(inputcmpval) ){
          $A.util.addClass(inputcmpdiv, 'slds-has-error');
        }else{
          $A.util.removeClass(inputcmpdiv, 'slds-has-error');
        }
          if(inputcmpisbadinput){
             inputcmp.setCustomValidity("Valid Format: MM/DD/YYYY");
              $A.util.removeClass(inputcmpdiv, 'slds-has-error');

            }
         inputcmp.reportValidity();
        
},
    clearposvalidationContent: function(component,event,helper,cmpauraid,rowIndex) {
        debugger;   
        if(!$A.util.isUndefined(component.find(cmpauraid))) {
       var posinputcmp = component.find(cmpauraid)[rowIndex];
        var posmessgediv = component.find('posmessgediv')[rowIndex];
        var posmessgedivtext = component.find('posmessgedivtext')[rowIndex];
        posinputcmp.set("v.value","");
        $A.util.removeClass(posmessgediv, 'slds-has-error');
        posmessgedivtext.set("v.value","");
        }
    },
     cleardatesvalidationContent: function(component,event,helper,cmpauraid,indexnum) {
        if(!$A.util.isUndefined(component.find(cmpauraid))) {
        if(indexnum){
            var inputcmp = component.find(cmpauraid)[indexnum];
                        var inputcmpdiv = component.find(cmpauraid+'div')[indexnum];

        }else{
            var inputcmp = component.find(cmpauraid);
                        var inputcmpdiv = component.find(cmpauraid+'div');

        }

          var inputcmpvalidity = inputcmp.get("v.validity");
            if(inputcmpvalidity){
        var inputcmpisbadinput = inputcmpvalidity.badInput;
                if(inputcmpisbadinput){
            inputcmp.set("v.value","2019-11-11");
         }
            }
        
        inputcmp.set("v.value","");
        inputcmp.setCustomValidity("");
        $A.util.removeClass(inputcmpdiv, 'slds-has-error');
        inputcmp.reportValidity();  
         }
    },
       reinstatetablerowshelper: function(component,event,helper,cmpauraid,indexnum) {
           
                	var rowList = component.get("v.inputList");
           var rowlength = rowList.length-15;
          rowList.splice(0, rowlength);
           component.set("v.inputList",rowList);
           	    	component.set('v.addServiceLines','');
	    	        //component.set('v.addServiceLinesMaxError','');

  	    		component.set('v.addServiceLinesMax','1...60');
	    		component.set('v.addServiceLinesDisabled', false);

    }
})