({
    clearAllErrorMessage: function(component,event,helper){
        component.set("v.showBenCatSelError", false);
        component.set("v.showKeywordInputError", false);
        component.set("v.showError", false);
        component.set("v.showDOBErrorMessage", false);
        component.set("v.benefitError","");
        component.set("v.DOBErrorMessage","");
    },

    validateBenDate: function(component,event,helper){
        debugger;
        var pattern1 = /^([0-9]{2})\/([0-9]{2})\/([0-9]{4})$/;
        var pattern2 = /^([0-9]{4})\-([0-9]{2})\-([0-9]{2})$/;
        var selectedBenefitDateVal = component.get("v.benefitDate");
        var benefitEffectiveDateVal = component.get("v.benefitEffectiveDate");
        var benefitEffectiveDate = new Date(benefitEffectiveDateVal);
        var benefitEndDateVal = component.get("v.benefitEndDate");
        var benefitEndDate = new Date(benefitEndDateVal);
        component.set("v.showDOBErrorMessage", true);
        if($A.util.isEmpty(selectedBenefitDateVal)){ 
            component.set("v.DOBErrorMessage", "Error: You must enter a value");
            return false;
        }
        if(!pattern1.test(selectedBenefitDateVal) && !pattern2.test(selectedBenefitDateVal)){
            component.set("v.DOBErrorMessage", "Error: Invalid Date.")
            return false;
        }
        if(!Date.parse(selectedBenefitDateVal)){
            component.set("v.DOBErrorMessage", "Error: Invalid Date.")
            return false;
        }
        // All dates are in the same format YYYY/MM/DD for the comparisons
        selectedBenefitDateVal = $A.localizationService.formatDate(selectedBenefitDateVal, "YYYY/MM/DD");
        var selectedBenefitDate = new Date(selectedBenefitDateVal);
        if(selectedBenefitDate && (selectedBenefitDate < benefitEffectiveDate || selectedBenefitDate > benefitEndDate)){                    
            component.set("v.DOBErrorMessage", "Error: Date selected outside of coverage period.")
            return false;
        }   
        component.set("v.showDOBErrorMessage", false);
        component.set("v.DOBErrorMessage", "");
        return true;
    },

     validateBenDateForAccums: function(component,event,helper){
        debugger;
        var pattern1 = /^([0-9]{2})\/([0-9]{2})\/([0-9]{4})$/;
        var pattern2 = /^([0-9]{4})\-([0-9]{2})\-([0-9]{2})$/;
        var selectedBenefitDateVal = component.get("v.benefitDateForAccums");
        var benefitEffectiveDateVal = component.get("v.benefitEffectiveDate");
        var benefitEffectiveDate = new Date(benefitEffectiveDateVal);
        var benefitEndDateVal = component.get("v.benefitEndDate");
        var benefitEndDate = new Date(benefitEndDateVal);
        component.set("v.showDOBErrorMessageForAccums", true);
        if($A.util.isEmpty(selectedBenefitDateVal)){ 
            component.set("v.DOBErrorMessageForAccums", "Error: You must enter a value");
            return false;
        }
        if(!pattern1.test(selectedBenefitDateVal) && !pattern2.test(selectedBenefitDateVal)){
            component.set("v.DOBErrorMessageForAccums", "Error: Invalid Date.")
            return false;
        }
        if(!Date.parse(selectedBenefitDateVal)){
            component.set("v.DOBErrorMessageForAccums", "Error: Invalid Date.")
            return false;
        }
        // All dates are in the same format YYYY/MM/DD for the comparisons
        selectedBenefitDateVal = $A.localizationService.formatDate(selectedBenefitDateVal, "YYYY/MM/DD");
        var selectedBenefitDate = new Date(selectedBenefitDateVal);
        if(selectedBenefitDate && (selectedBenefitDate < benefitEffectiveDate || selectedBenefitDate > benefitEndDate)){                    
            component.set("v.DOBErrorMessageForAccums", "Error: Date selected outside of coverage period.")
            return false;
        }   
        component.set("v.showDOBErrorMessageForAccums", false);
        component.set("v.DOBErrorMessageForAccums", "");
        return true;
    },
    getBenefitCategory:function(component, event,helper){
        debugger;
        component.set("v.benefitCategoryOptionList",[]);
        component.set("v.benefitCategoryChildrenMap",{});
        component.set("v.isBenefitAvailable", false);
        component.set('v.showBenCatServError', false);
        component.set('v.benCatServErrorMessage','');
        var asOfDate = component.get("v.benefitDate");
        asOfDate = (asOfDate) ? $A.localizationService.formatDate(asOfDate, "YYYY-MM-DD") : '';
        /*var groupNumber = component.get("v.groupNumber");
        var bundleId = component.get("v.selectedBundleId");
        groupNumber = '1008812';
        bundleId = '11958488';
        asOfDate = '2021-01-01';*/
        var benefitPlanId = component.get("v.b360BenefitPlanId");
        benefitPlanId = benefitPlanId ? benefitPlanId : '';
        
        var action = component.get("c.isAvailableServiceCall");
        var reqParams = {
                'benefitPlanId': benefitPlanId,
                'accumulatorAsOf': asOfDate
            };
        action.setParams(reqParams);
        debugger;
        component.set('v.langNotFoundError','');
        action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var result = response.getReturnValue();
                    console.log('B360 Benefit Available : ' + result);
                    if(result)
                    {
                        component.set("v.isBenefitAvailable", true);
                        helper.callB360BenefitCategoryAPI(component, event, helper);
                    }
                    else{
                      component.set('v.showBenCatServError', true);
                      component.set('v.benCatServErrorMessage','Error: No benefit language found'); 
                      component.set('v.renderSpinner',false);  
                    }
                }else{
                  component.set('v.showBenCatServError', true);
                  component.set('v.benCatServErrorMessage','Error: Web Service or External System is temporarily unavailable.'); 
                  component.set('v.renderSpinner',false);
                }
                
        });
         $A.enqueueAction(action);
        
    },
    callB360BenefitCategoryAPI  : function(component, event, helper){
        debugger;
        if(component.get("v.isBenefitAvailable"))
        {
            var asOfDate = component.get("v.benefitDate");
            asOfDate = (asOfDate) ? $A.localizationService.formatDate(asOfDate, "YYYY-MM-DD") : '';
            var benefitPlanId = component.get("v.b360BenefitPlanId");
            benefitPlanId = benefitPlanId ? benefitPlanId : '';
            var action = component.get("c.getB360BenefitCategory");
            var reqParams = {
                'benefitPlanId' : benefitPlanId,
                'dateOfService' : asOfDate
            };
            action.setParams(reqParams);
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var result = response.getReturnValue();
                    console.log(JSON.stringify(result));
                    if(result)
                    {
                        var benefitCategoryList = result.benefitCategoryList ? result.benefitCategoryList : [];
                        var benefitCategoryOptionList = [];
                        benefitCategoryList.forEach(function (benefitCategory, index) {
  							benefitCategoryOptionList.push({"label":benefitCategory,"value": benefitCategory});
						});
                        var benefitCategoryChildrenMap = result.benefitCategoryChildrenMap ? result.benefitCategoryChildrenMap : {};
                        for(var key in benefitCategoryChildrenMap){
                            console.log('>>> key : ' + key);
                            var childBenefits = benefitCategoryChildrenMap[key];
                            childBenefits.forEach(function(benefit,index){
                                console.log('>>> ' + benefit.categoryName + ' : ' + benefit.benefitId);
                            });
                        }
                        if(benefitCategoryOptionList && benefitCategoryOptionList.length==0){
                            component.set('v.showBenCatServError', true);
                      		component.set('v.benCatServErrorMessage','Error: No benefit language found'); 
                        }
                        component.set("v.benefitCategoryOptionList" , benefitCategoryOptionList);
                        component.set("v.benefitCategoryChildrenMap", benefitCategoryChildrenMap);
                        
                         setTimeout(function(){
		            var tabKey = component.get("v.AutodocKey")+ component.get("v.GUIkey");
                            if(window.lgtAutodoc != undefined){
		            	window.lgtAutodoc.initAutodoc(tabKey);
                         helper.hideSpinner2(component, event, helper);
                            }
                             $("#b360benifitdetailresultstable tr th.autodoc-case-item-resolved").css("display","none");
		        },10);
                    }
                    else
                    {
                        component.set('v.showBenCatServError', true);
                  		component.set('v.benCatServErrorMessage','Error: Web Service or External System is temporarily unavailable.'); 
                    }
                }
                else
                {
                    component.set('v.showBenCatServError', true);
                    component.set('v.benCatServErrorMessage','Error: Web Service or External System is temporarily unavailable.'); 
                }
                component.set('v.renderSpinner',false);
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
     },
    
    helperSearchBenefits: function(component,event,helper,searchPhrase){
        var asOfDate = component.get("v.benefitDate");
        asOfDate = (asOfDate) ? $A.localizationService.formatDate(asOfDate, "YYYY-MM-DD") : '';
        var benefitPlnId = component.get("v.b360BenefitPlanId");
        
        var action = component.get("c.searchBenefitsByPhrase");
        var reqParams = {
            'benefitPlanId' : benefitPlnId,
            'searchedPhrase' : searchPhrase,
            'dateOfService' : asOfDate
            };
        action.setParams(reqParams);
        action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var result = response.getReturnValue();
                   console.log('result'+result);
                    var searchBenResults = [];
                    if(result != null && result.benefits != null && result.benefits.length > 0 ){
                        result.benefits.forEach(function(ben,index){
                            if(ben.benefitName && ben.benefitId)
                            {
                                searchBenResults.push(ben);
                            }
                        });
                    	component.set('v.searchBenefitsResults',searchBenResults);
                    }else{
                        component.set('v.showError',true);
                    }
                    
                     setTimeout(function(){
		            var tabKey = component.get("v.AutodocKey")+ component.get("v.GUIkey");
                            if(window.lgtAutodoc != undefined){
		            	window.lgtAutodoc.initAutodoc(tabKey);
                         helper.hideSpinner2(component, event, helper);
                            }
                         $("#b360benifitdetailresultstable tr th.autodoc-case-item-resolved").css("display","none");
                          $("#b360benifitdetailresultstable tr td.autodoc-case-item-resolved").css("display","none");
                            $("#b360benifitdetailresultstable tr th.autodoc").css("display","none");
                 
		        },10);
                }
            component.set('v.renderSpinner',false);
        });
         $A.enqueueAction(action);
    },
    
    fetchBenefitSection : function(component,event,helper,benefitId,sectionAuraId){
        	 var action = component.get("c.getBenefitSection");
        var reqParams = {
            'benefitId' : benefitId
            };
        action.setParams(reqParams);
        debugger;
        action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var result = response.getReturnValue();
                   console.log('result'+result);
                    if(result != null && result.benefits != null){
                        result.benefits[0].benefitId = benefitId;
                   component.set('v.searchResultBenefitData',result.benefits);
                    $A.enqueueAction(component.get('c.renderBenefiSectionData'));
                    
                  
                    }else{
                       // component.set('v.showError',true);
                    }
                }else{
                    //component.set('v.renderSpinner',false);
                }
            component.set('v.renderSpinner',false);
        });
         $A.enqueueAction(action);
        
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
                        }else{
                            selectedBenefitCodesWithUnderScoresArray.push(tempValueWithoutUnderscoresFinal[c]);
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
        		benefitdateSearch =  $A.localizationService.formatDate(benefitdateSearch, "YYYY-MM-DD") ;
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
      
})