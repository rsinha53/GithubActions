({
    copyTextHelper : function(component,event,text) {
        // Create an hidden input
        var hiddenInput = document.createElement("input");
        // passed text into the input
        hiddenInput.setAttribute("value", text);
        // Append the hiddenInput input to the body
        document.body.appendChild(hiddenInput);
        // select the content
        hiddenInput.select();
        // Execute the copy command
        document.execCommand("copy");
        // Remove the input from the body after copy text
        document.body.removeChild(hiddenInput); 
        
    },
	/* validateBenefitDate : function(component,event,helper,covInfoBenefits) {
        if(covInfoBenefits != undefined){
            var benstartDate = covInfoBenefits.BenEffectiveDate;
            var benendDate = covInfoBenefits.BenEndDate;
            var today= $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
            var benefitEndDate = $A.localizationService.formatDate(benendDate, "YYYY-MM-DD");
            var benefitEffectiveDate = $A.localizationService.formatDate(benstartDate,"YYYY-MM-DD");
            component.set('v.benefitEffectiveDate',benefitEffectiveDate);
            component.set('v.benefitEndDate',benefitEndDate);
            if(!$A.util.isEmpty(benefitEffectiveDate) && !$A.util.isUndefined(benefitEffectiveDate) && !$A.util.isEmpty(benefitEndDate) && !$A.util.isUndefined(benefitEndDate)) {
            if(benefitEndDate >= today && benefitEffectiveDate <  today) {              
                 component.set("v.benefitDate",today);
             }
            else if(benefitEndDate < today) {
                   component.set("v.benefitDate",benefitEndDate);
            }
            else if(benefitEffectiveDate > today && benefitEndDate >= today) {              
                  component.set("v.benefitDate",benefitEffectiveDate);
            }
        }  
        }
     },*/
    onChangeBenefitDateSearch : function(component, event, helper) {
       debugger;
       var covInfoBenefits = component.get("v.attrcoverageBenefits");
       var returnError = false;  
       if(covInfoBenefits != undefined){
           var benefitDatecomp = component.find("benefitId");
           var benefitDateValue = benefitDatecomp.get("v.value");
           var benstartDate = covInfoBenefits.BenEffectiveDate;
           var benendDate = covInfoBenefits.BenEndDate;
           var benefitDatebadinput = benefitDatecomp.get("v.validity").badInput;
           if($A.util.isEmpty(benefitDateValue)){
              benefitDatecomp.setCustomValidity("Error: You must enter a value."); 
              benefitDatecomp.reportValidity();
              return false;
           }
           if(benefitDatebadinput){
                benefitDatecomp.setCustomValidity("Error: Invalid Date.");
                benefitDatecomp.reportValidity();
                return false;
           }
           if(new Date(benefitDateValue) < new Date(benstartDate) || new Date(benefitDateValue) > new Date(benendDate)){
              benefitDatecomp.setCustomValidity("Error: Date selected outside of coverage period.");
              benefitDatecomp.reportValidity();
              return false;
          }else{
               benefitDatecomp.setCustomValidity(""); 
               benefitDatecomp.reportValidity();
               return true;
          }
            
         }
    },
    callGetBenefitLanguageService : function(component,event,helper,selectedBenefitList,benefitdateSearch,bundleId,groupNumber,benefitLanguageIndicatorArray) {
          debugger;
          //alert(JSON.stringify(component.get('v.benefitLanguageWrapperList')));
          //component.set('v.benefitLanguageWrapperList',[]);
          helper.showSpinner2(component, event, helper);
          var result = true;
          var selectedBenefitLangcodes = [];
          var selectedBenefitCodesList = [];
          var selectedBenefitCodesWithUnderScoresArray = [];
          var selectedBenefitCodesWithoutUnderScoresArray = [];
          var selectedBenefitCodesFinalValues = '';
          var tempValueWithoutUnderscoresFinal = [];
          var selectedBenefitLangcodesWOCategories=[];
          for(var i =0; i <selectedBenefitList.length; i++) {
            selectedBenefitLangcodes.push(selectedBenefitList[i].value);
          }
          for(var a=0; a<selectedBenefitLangcodes.length; a++){
                    if(selectedBenefitLangcodes[a].indexOf(';')>-1){
                        var tempSelectedBenefitLangcodes = selectedBenefitLangcodes[a].split(';');
                        console.log('tempSelectedBenefitLangcodes');
                        if(!$A.util.isEmpty(tempSelectedBenefitLangcodes) && !$A.util.isUndefined(tempSelectedBenefitLangcodes)) {
                        for(var b = 0; b<tempSelectedBenefitLangcodes.length;b++){
                            if(!$A.util.isEmpty(tempSelectedBenefitLangcodes[b]) && !$A.util.isUndefined(tempSelectedBenefitLangcodes[b])) {
                            var st1 = tempSelectedBenefitLangcodes[b];
             
                              if(st1.includes("@")){ 
                                
                                st1 = st1.split('@')[0];
                             } 
                            
                            selectedBenefitCodesWithUnderScoresArray.push(st1);
                           }
                        }
                      
                    }
                    }else{
                        selectedBenefitLangcodesWOCategories.push(selectedBenefitLangcodes[a]);
                    }
                    
                }
                console.log('selectedBenefitLangcodesWOCategories...'+selectedBenefitLangcodesWOCategories);
                console.log(JSON.stringify(selectedBenefitCodesWithUnderScoresArray));
                var selectedBenefitcodesJSON = JSON.stringify(selectedBenefitLangcodesWOCategories);
                var noDataSelectedBenefit = selectedBenefitLangcodesWOCategories;
               if(!$A.util.isEmpty(selectedBenefitcodesJSON) && !$A.util.isUndefined(selectedBenefitcodesJSON)) {
                 selectedBenefitcodesJSON = selectedBenefitcodesJSON.toString().split('-');
               }
                console.log(selectedBenefitcodesJSON); 
        		if(!$A.util.isEmpty(selectedBenefitcodesJSON) && !$A.util.isUndefined(selectedBenefitcodesJSON)) {
                  selectedBenefitcodesJSON = selectedBenefitcodesJSON.toString().split('"');
                }
                console.log(selectedBenefitcodesJSON);
                debugger;
        if(!$A.util.isEmpty(selectedBenefitcodesJSON) && !$A.util.isUndefined(selectedBenefitcodesJSON)) {
                for(var a = 0 ; a < selectedBenefitcodesJSON.length ; a++){
                    if(selectedBenefitcodesJSON[a].includes('_')){ //includes
                        selectedBenefitCodesList.push(selectedBenefitcodesJSON[a]);
                    }else if(!selectedBenefitcodesJSON[a].includes('_')){ //!selectedBenefitcodesJSON[a].includes("_")
                        if(selectedBenefitcodesJSON[a]){
                            console.log('selectedBenefitcodesJSON[a].....'+selectedBenefitcodesJSON[a]);
                             var tempValueWithoutUnderscoresVal = selectedBenefitcodesJSON[a].replace('[','').replace(']','').replace(/,/g , '');
                            if(tempValueWithoutUnderscoresVal){
                                tempValueWithoutUnderscoresFinal.push(tempValueWithoutUnderscoresVal);    
                            }
                            
                        }
                        
                    }
                }
        }
                console.log('tempValueWithoutUnderscoresFinal' +tempValueWithoutUnderscoresFinal);
                debugger;
        if(!$A.util.isEmpty(tempValueWithoutUnderscoresFinal) && !$A.util.isUndefined(tempValueWithoutUnderscoresFinal)) {
               for(var c = 0 ; c < tempValueWithoutUnderscoresFinal.length ; c++){
                    if(!$A.util.isEmpty(tempValueWithoutUnderscoresFinal[c]) && !$A.util.isUndefined(tempValueWithoutUnderscoresFinal[c])){
                        if(tempValueWithoutUnderscoresFinal[c].indexOf(' ') >-1) {
                        var tempValueWithoutUnderscores = tempValueWithoutUnderscoresFinal[c].split(' ');
                        var st2 = tempValueWithoutUnderscores[0];
                        if(st2 != 'undefined') {
                             if(st2.includes('@')){  //includes
                                st2 = st2.split('@')[0];
                             }
                        }
                        selectedBenefitCodesWithUnderScoresArray.push(st2);
                    }
                  }
                }
                }
                debugger;
        if(!$A.util.isEmpty(selectedBenefitCodesList) && !$A.util.isUndefined(selectedBenefitCodesList)) {
                for(var b = 0 ; b < selectedBenefitCodesList.length ; b++){
                    if(selectedBenefitCodesList[b].indexOf(',') > -1) {
                    var singleBenefitCode = selectedBenefitCodesList[b].split(',');
                   // alert('singleBenefitCode'+singleBenefitCode);
                    if(singleBenefitCode != 'undefined') {
                    var st3 = singleBenefitCode[0];
                             if(st3.includes('@')){ //includes
                                st3 = st3.split('@')[0];
                             } 
                    }
                    selectedBenefitCodesWithUnderScoresArray.push(st3);    
                }
              }
        }
                console.log('selectedBenefitCodesWithUnderScoresArray' +selectedBenefitCodesWithUnderScoresArray);
                selectedBenefitCodesFinalValues = selectedBenefitCodesWithUnderScoresArray.join().trim();
                console.log('selectedBenefitCodesFinalValues' +selectedBenefitCodesFinalValues);
                //var convertedBenefitDate = $A.localizationService.formatDate(dtcmp, "YYYY-MM-DD");
               var benefitDisplayMap = component.get('v.benefitDisplayMap');
               var benefitValues = new Array();
               for (var key in benefitDisplayMap ) {
                   benefitValues.push(key+'!'+benefitDisplayMap[key]);
               }
               console.log(benefitValues);
               console.log(benefitValues[0]); 
               var benefitDisplayListJSON = JSON.stringify(benefitValues);
               console.log(benefitDisplayListJSON);
               var benefitLanguageIndicatorListJSON = JSON.stringify(benefitLanguageIndicatorArray);
               console.log(benefitLanguageIndicatorListJSON);
               var effectiveStartDate = component.get('v.benefitEffectiveDate');
               effectiveStartDate = $A.localizationService.formatDate(effectiveStartDate, "YYYY-MM-DD") ;
               console.log('effectiveStartDate --> ' + effectiveStartDate);
               debugger;
                var action = component.get("c.getBenefitLanguageResults");
                var reqParams = {
                'bundleId': bundleId,
                'benefitCodes': selectedBenefitCodesFinalValues,
                'asOfDate': benefitdateSearch,
                'groupNumber': groupNumber,
                'hippaServiceType': '',
                'multiple' : true,
                'benefitDisplayString' : benefitDisplayListJSON,
                'languageString' : benefitLanguageIndicatorListJSON,
                'EffectiveStartDate' : effectiveStartDate
                
            };
            if (result){
            action.setParams(reqParams);
            action.setCallback(this, function(response) {
                
                var state = response.getState();
                if (state === "SUCCESS") {
                    var result = response.getReturnValue();
                    console.log('result list==>'+JSON.stringify(result));
                    if(!$A.util.isEmpty(result) && !$A.util.isUndefined(result)){
                       console.log(result.resultBenefitLanguageWrapper);
                       //alert(result.resultBenefitLanguageWrapper[0]);
                        for(var i = 0; i< result.resultBenefitLanguageWrapper.length; i++) {
                            console.log(result.resultBenefitLanguageWrapper[i].parStatusList);
                        }
                        component.set('v.benefitLanguageWrapperList',result.resultBenefitLanguageWrapper);
                       console.log(JSON.stringify(component.get('v.benefitLanguageWrapperList')));
                        setTimeout(function(){
		            var tabKey = component.get("v.AutodocKey")+ component.get("v.GUIkey");
                            if(window.lgtAutodoc != undefined){
		            	window.lgtAutodoc.initAutodoc(tabKey);
                         helper.hideSpinner2(component, event, helper);
                            }
                  $("#benifitdetailresultstable tr th.autodoc-case-item-resolved").css("display","none");
                      $("#benifitdetailresultstable tr td.autodoc-case-item-resolved").css("display","none");
                            $("#benifitdetailresultstable tr th.autodoc").css("display","none");
		        },10);
                    }
                    
                } else if (state === "ERROR") {
                    
                    
                }
            });
            $A.enqueueAction(action);
           }  
        
    },
     hideSpinner2 : function(component, event, helper) {	
        console.log('Hiding Spinner2');
        var spinner = component.find("mySpinner");
        $A.util.addClass(spinner,"slds-hide");
    },
    showSpinner2: function(component, event, helper) {
        // make Spinner attribute true for display loading spinner
        console.log('Showing Spinner2'); 
        var spinner = component.find("mySpinner");
        $A.util.removeClass(spinner,"slds-hide");
    },
   getBenefitLanguageIndicatorValues : function(component,event,helper) {
        var action = component.get("c.getBenefitLanguageIndicatormdt");
        action.setCallback(this, function(a) {
            var state = a.getState();
            if(state == "SUCCESS"){
                var result = a.getReturnValue();
                if(!$A.util.isEmpty(result) && !$A.util.isUndefined(result)){
                    var opts = [];
                    for(var i=0; i < result.length; i++) {
                        opts.push(result[i].Benefit_Code__c);
                    }
                    console.log("@@ opts: " + opts);
                    component.set('v.benefitLanguageIndicatorArray',opts);
                }
            }
        });
        $A.enqueueAction(action);
    },
    removeBenefitCode : function(component,event,helper,viewBenefitButtonSelectedOptionsList,selectedBenefitLangcodesList,selectedBenefitLangcodestring) {
       debugger;       
       
        console.log('selectedBenefitLangcodesList==>'+selectedBenefitLangcodesList);
        console.log('viewBenefitButtonSelectedOptionsList==>'+viewBenefitButtonSelectedOptionsList);
        if(selectedBenefitLangcodestring.length == 0){
                    if(viewBenefitButtonSelectedOptionsList != null){
                        for(var i=0;i<viewBenefitButtonSelectedOptionsList.length;i++){
            
                            if(viewBenefitButtonSelectedOptionsList[i].indexOf(';')>-1){
                                var tempSelectedBenefitLangcodes = viewBenefitButtonSelectedOptionsList[i].split(';'); 
                                for(var b = 0; b<tempSelectedBenefitLangcodes.length;b++){ 
                                    var string1= tempSelectedBenefitLangcodes[b];
                                    if(string1.indexOf('@') >-1){ //includes
                                            string1 = string1.split('@')[0];
                                    }
                                    console.log(string1);
                                    debugger;
                                    if(string1) {
                                        var benefitKeyId = document.querySelector('[id^='+string1+']');
                                        if(benefitKeyId) {
                                           var benefitKeyDiv = '#'+document.getElementById(benefitKeyId.id);
                                           if(benefitKeyDiv) {
                                               $A.util.removeClass(benefitKeyDiv,"slds-show");
                                               $A.util.addClass(benefitKeyDiv,"slds-hide");
                 
                                           }
                                       }
                                    }
                                  }  
                            }else{
                                var benefitKeyToRemove = viewBenefitButtonSelectedOptionsList[i];  // added by Som
                                if(document.getElementById(benefitKeyToRemove+'benefitKeyId')) {
                                   var benefitKeyDiv = document.getElementById(benefitKeyToRemove+'benefitKeyId');  
                                  console.log('benefitKeyToRemove' +benefitKeyToRemove);
                                   console.log(benefitKeyDiv);
                                   $A.util.removeClass(benefitKeyDiv,"slds-show");
                                   $A.util.addClass(benefitKeyDiv,"slds-hide"); 
                                   
                                }
                                                         
                            }
                            
                        } 
                    
                    } 
                   
                        
                      
                }else if(viewBenefitButtonSelectedOptionsList != null && selectedBenefitLangcodesList != null){
                    if(viewBenefitButtonSelectedOptionsList.length != selectedBenefitLangcodesList.length){
                        var uniqueBenefitCode = viewBenefitButtonSelectedOptionsList.filter(function(obj) { return selectedBenefitLangcodesList.indexOf(obj) == -1; });
                        var selectedBenefitLangcodesString = selectedBenefitLangcodesList.join();
                        console.log('uniqueBenefitCode...'+uniqueBenefitCode);
                        console.log('selectedBenefitLangcodesString...'+selectedBenefitLangcodesString);
                        for(var i=0;i<uniqueBenefitCode.length;i++){
                            if(uniqueBenefitCode[i].indexOf(';')>-1){
                                var tempSelectedBenefitLangcodes = uniqueBenefitCode[i].split(';');
                                console.log('tempSelectedBenefitLangcodes' +tempSelectedBenefitLangcodes);
                                for(var b = 0; b<tempSelectedBenefitLangcodes.length;b++){
                                console.log('tempSelectedBenefitLangcodes[b]...'+tempSelectedBenefitLangcodes[b]);
                                    var string2= tempSelectedBenefitLangcodes[b];
                                    if(string2.indexOf('@') >-1){ //includes
                                            string2 = string2.split('@')[0];
                                    }
                                    if(selectedBenefitLangcodesString.indexOf(string2)<0){
                                        if(string2) {
                                        var benefitKeyId = document.querySelector('[id^='+string2+']');

                                        if(benefitKeyId) {
                                            var benefitKeyDiv = document.getElementById(benefitKeyId.id);
                                        	console.log(benefitKeyDiv);
                                        	$A.util.removeClass(benefitKeyDiv,"slds-show");
                                        	$A.util.addClass(benefitKeyDiv,"slds-hide");
                                            
                                 
                                        }
                                     }
                                    }
                                    
                                }
                            }else{
                                var benefitKeyToRemove = uniqueBenefitCode[i]; //added by Som
                                console.log('benefitKeyToRemove' +benefitKeyToRemove);
                                if(document.getElementById(benefitKeyToRemove+'benefitKeyId')) {
                                    var benefitKeyDiv = document.getElementById(benefitKeyToRemove+'benefitKeyId');
                                   	$A.util.removeClass(benefitKeyDiv,"slds-show");
                                	$A.util.addClass(benefitKeyDiv,"slds-hide"); 
                                 
                                }
                    
                            }
                        }
                        
                    }
                }
               debugger;                            

    },
     generateUniqueName: function(component,param1) {
        debugger;
        var len = 10;
        var buf = [],
            chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789',
            charlen = chars.length,
            length = len || 32;
            
        for (var i = 0; i < length; i++) {
            buf[i] = chars.charAt(Math.floor(Math.random() * charlen));
        }
        var GUIkey = buf.join('');
        component.set("v.radioGroupName", param1+GUIkey);
     }  
      
})