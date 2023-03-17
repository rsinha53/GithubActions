({
	showBenefits : function(component, event, helper) {
        var len = 22;
        var buf = [],
            chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789',
            charlen = chars.length,
            length = len || 32;
            
        for (var i = 0; i < length; i++) {
            buf[i] = chars.charAt(Math.floor(Math.random() * charlen));
        }
        var GUIkey = buf.join('');
        //helper.createGUID();
		component.set("v.GUIkey",GUIkey+'321');
       

		var today= $A.localizationService.formatDate(new Date(), "MM/DD/YYYY");
        component.set("v.todayDate",today);  
        var covInfoBenefits = component.get("v.attrcoverageBenefits");
		component.set('v.benefitDate',component.get('v.selectedBenefitDate')); 																	   
        /*
         *Below method is for setting up Benefit As OF Date, which is same as AccumsAsOfDt
         * which is already set in ACETLGT_CoverageOVerViewHelper.Js, so using the same value
         * in the component. Hence commenting below helper method cal
         */
        //helper.validateBenefitDate(component,event,helper,covInfoBenefits);
        helper.getBenefitLanguageIndicatorValues(component,event,helper);
	},
    showBenefitCodeKeyMap: function(component,event) {
        var params = event.getParam('arguments');
        if (params) {
            var param1 = params.childParam;
            component.set('v.allSearchRecords',param1);
        }
        //alert('test');
        //alert(component.get('v.allSearchRecords'));
        console.log('Manish -->' + component.get('v.allSearchRecords'));
    },
    showBenefitRadioGroup : function(component,event,helper) {
        var params = event.getParam('arguments');
        if (params) {
            var param1 = params.childParam;
            helper.generateUniqueName(component,param1);
        }
    },
    populateBenefitDate : function(component,event,helper) {
      var todayDate = component.get("v.todayDate");
      //var convertedTodayDate = $A.localizationService.formatDate(todayDate, "YYYY-MM-DD");
      component.set("v.benefitDate",todayDate);
    },
    showDetails:function (component, event, helper){
       var covInfoBenefits = component.get("v.attrcoverageBenefits");
       var returnError = false;
       var GlobalAutocomplete = component.find('PlanBenefitGlobalAutocomplete');
       var selectedBenefitList = GlobalAutocomplete.get('v.lstSelectedRecords');
        
       var GlobalAutocompletecmp = component.find('PlanBenefitGlobalAutocomplete').find('lookup-pill');  
       debugger;
       if(covInfoBenefits != undefined){
          var benefitcomp = component.find("benefitId");  
          var dateReg = /^([0-9]{2})\/([0-9]{2})\/([0-9]{4})$/;
          var dateReg1 = /^([0-9]{4})\-([0-9]{2})\-([0-9]{2})$/;
          var benstartDate = component.get('v.benefitEffectiveDate');
          var benendDate = component.get('v.benefitEndDate');
          var benefitdateSearch = component.get("v.benefitDate");
          var covertedBenefitDateSearch = $A.localizationService.formatDate(benefitdateSearch, "MM/DD/YYYY");
          var bundleId = component.get('v.selectedBundleId');
          debugger;
          var groupNumber = covInfoBenefits.GroupNumber; 
         // var accumsrch = $A.localizationService.formatDate(dtcmp, "MM/DD/YYYY");
         if($A.util.isEmpty(benefitdateSearch)){
               $A.util.addClass(benefitcomp, "slds-has-error-date");
               component.set("v.DOBErrorMessage","Error: You must enter a value.");  
               $A.util.removeClass(component.find("msgTxtDOB"), "slds-hide")
               $A.util.addClass(component.find("msgTxtDOB"), "slds-show");
               returnError = true; 
           }
		   else if(!benefitdateSearch.match(dateReg) && !benefitdateSearch.match(dateReg1)){
               $A.util.addClass(benefitcomp, "slds-has-error-date");
               component.set("v.DOBErrorMessage","Error: Invalid Date.");  
               $A.util.removeClass(component.find("msgTxtDOB"), "slds-hide")
               $A.util.addClass(component.find("msgTxtDOB"), "slds-show");
               returnError = true; 
		   }
           else if(new Date(covertedBenefitDateSearch) < new Date(benstartDate) || new Date(covertedBenefitDateSearch) > new Date(benendDate)){
               $A.util.addClass(benefitcomp, "slds-has-error-date");
               component.set("v.DOBErrorMessage","Error: Date selected outside of coverage period.");  
               $A.util.removeClass(component.find("msgTxtDOB"), "slds-hide")
               $A.util.addClass(component.find("msgTxtDOB"), "slds-show");
               returnError = true; 
           }else {
               $A.util.removeClass(benefitcomp, "slds-has-error-date");
              component.set("v.DOBErrorMessage","");  
              $A.util.addClass(component.find("msgTxtDOB"), "slds-hide")
              $A.util.removeClass(component.find("msgTxtDOB"), "slds-show");
           }
           if ($A.util.isEmpty(selectedBenefitList)){                    
                $A.util.addClass(GlobalAutocompletecmp, "slds-has-error");
                component.set("v.isBenefitSelected", "true");
                component.set("v.benefitError", "Error: You must enter a value.");   
                returnError = true;     
          }else {
              $A.util.removeClass(GlobalAutocompletecmp, "slds-has-error");
        }
         
       }   
        if(returnError) {
            return;
        }
        debugger;
        var benefitLanguageIndicatorArray = component.get('v.benefitLanguageIndicatorArray');
        var SitusState = component.get('v.SitusState');
        helper.callGetBenefitLanguageService(component,event,helper,selectedBenefitList,benefitdateSearch,bundleId,groupNumber,benefitLanguageIndicatorArray);
        debugger;
    },
    validateSearch : function(component,event,helper) {
            var benefitEffectiveDate = component.get("v.benefitEffectiveDate");    
            var benefitEndDate = component.get("v.benefitEndDate");
            var returnError = false;
            
        },
    onClickOfEnter : function(component,event, helper) {
        debugger;
        if (event.which == 13){
            //alert("HITS");
            console.log('hits :: '+component.find('PlanBenefitGlobalAutocomplete').get("v.listOfSearchRecords"));
            if (component.find('PlanBenefitGlobalAutocomplete').get("v.listOfSearchRecords") == null){
                
                var a = component.get('c.showDetails');
                $A.enqueueAction(a);
                
            }
            
        }
        
    },
    evntCalled : function(component, event, helper) {
        console.log('====selectedItems===',event.getParam('selectedItems'));
        var selectedOptionValue = event.getParam('selectedItems');
        component.set("v.selectedItemOptions", selectedOptionValue);
    },
    onChangeRadio : function(component,event,helper) {
        debugger;
        //var radioOption = event.currentTarget.getAttribute("data-radioGroupName");
        var radioGroupName = component.get("v.radioGroupName");
        var allRadios = document.getElementsByName(radioGroupName); 
        var allRecords = component.get("v.benefitCodeKeyMap");
        var specialtyList = [];
        for(var k =0; k < allRecords.length; k++) {
            if(allRecords[k].label.indexOf('*') >= 0 || allRecords[k].label.indexOf('%') >= 0){
                 specialtyList.push(allRecords[k].label);
            }
        }
        var specialtyString = specialtyList.join();
        console.log(JSON.stringify(specialtyString));
        debugger;
        for(var i = 0; i < allRadios.length; i++) { 
                if(allRadios[i].checked) {
                    var selectedValue = allRadios[i].value;
                    if(selectedValue == 'All') {
                        console.log('length');
                        console.log(allRecords.length);
                        component.set('v.allSearchRecords',allRecords);
                        component.set('v.selectedRadio',selectedValue);
                        
                        
                    }
                       if(selectedValue == 'Benefit Code') {
                           var allRecordsBenefitCode = JSON.parse(JSON.stringify(allRecords));
                           console.log('length');
                           component.set('v.selectedRadio',selectedValue);
                           console.log(allRecordsBenefitCode.length);
                           for(var j =0; j < allRecordsBenefitCode.length; j++) {
            					if(allRecordsBenefitCode[j].label==allRecordsBenefitCode[j].label.toUpperCase() || specialtyString.indexOf(allRecordsBenefitCode[j].label) >= 0){
                              		console.log(allRecordsBenefitCode[j].label);
                               		 allRecordsBenefitCode.splice(j,1);
                                     j--;
                                 }
                           console.log('benefit');
                           console.log(allRecordsBenefitCode.length);
                           console.log(allRecords.length);
                           component.set('v.allSearchRecords',allRecordsBenefitCode); 
                      }
                     }
                       if(selectedValue == 'CATEGORY') {
                       var allRecordsCategory = JSON.parse(JSON.stringify(allRecords));
                       console.log('length');
                       component.set('v.selectedRadio',selectedValue);
                       console.log(allRecordsCategory.length);
                         for(var j =0; j < allRecordsCategory.length; j++) {
            					if(allRecordsCategory[j].label !=allRecordsCategory[j].label.toUpperCase()){
                              		console.log(allRecordsCategory[j].label);
                               		 allRecordsCategory.splice(j,1);
                                     j--;
                                 }
                         }
                         console.log('category');
                         console.log(allRecordsCategory.length);
                         console.log(allRecords.length);
                         component.set('v.allSearchRecords',allRecordsCategory);
                         
                        }
                        if(selectedValue == 'Specialty') {
                       var allRecordsSpecialty = JSON.parse(JSON.stringify(allRecords));
                       component.set('v.selectedRadio',selectedValue);
                        for(var j =0; j < allRecordsSpecialty.length; j++) {
            					if(specialtyString.indexOf(allRecordsSpecialty[j].label) < 0){
                              		console.log(allRecordsSpecialty[j].label);
                               		 allRecordsSpecialty.splice(j,1);
                                     j--;
                                 }
                         }
                         console.log('specialty');
                         console.log(allRecordsSpecialty.length);
                         console.log(JSON.stringify(allRecordsSpecialty));
                         for(var k =0; k < allRecordsSpecialty.length; k++) {
                             if(allRecordsSpecialty[k].label.indexOf('%') >= 0) {
                                 allRecordsSpecialty[k].label = allRecordsSpecialty[k].label.replace('%','*');
                             }  
                             if(specialtyString.includes('%') && allRecordsSpecialty[k].label.indexOf('*') < 0) {
                               allRecordsSpecialty.splice(k,1);
                               k--;
                             }
                             if(specialtyString.includes('*') && allRecordsSpecialty[k].label.indexOf('*') < 0) {
                               allRecordsSpecialty.splice(k,1);
                               k--;
                             }
                       }   
                         component.set('v.allSearchRecords',allRecordsSpecialty);
                         
                      }
  
                }
                
            }
    },
    copycode_event: function(component, event, helper) {
               var textForCopy = event.currentTarget.getAttribute("data-codetocopy");
               helper.copyTextHelper(component,event,textForCopy);

  },
    AccumulatorsOnclick : function(component, event, helper) {
    
                var existsOnRiderPlanMapfinal;

           var accumId = event.currentTarget.getAttribute("data-accumulatorId");
                 var existsOnRiderPlanMap = component.get("v.existsOnRiderPlanMap");
                      
var riderPlan = new Array();
       for (var key in existsOnRiderPlanMap ) {
            riderPlan.push(key+'='+existsOnRiderPlanMap[key]);
       }
      
                     for(var k=0;k<riderPlan.length;k++){
                         if(riderPlan[k].includes(accumId)){
                            existsOnRiderPlanMapfinal = JSON.stringify(riderPlan[k]);
                         }                
                    }
        
                    var selectedAccums = [];
                    var htmlStr = '';
                    if(selectedAccums.indexOf(accumId) < 0){
                         selectedAccums.push(accumId);
                          var benefitCodejs = accumId;
                        if(benefitCodejs != null) {
                          if(benefitCodejs.indexOf('-') > 0){
                            benefitCodejs = benefitCodejs.split('-')[0];                                
                        }
                      }
                       var covInfoBenefits = component.get("v.attrcoverageBenefits");
                       var benefitdateSearch = component.get("v.benefitDate");
                       var accumCodeList = [];
                        if(covInfoBenefits != undefined){
                            var surrogateKey = covInfoBenefits.SurrogateKey;
                            var bundleId = component.get('v.selectedBundleId');
                            var enrollerSRK = covInfoBenefits.EnrolleeSurrogateKey;
                            var benstartDate = component.get('v.benefitEffectiveDate');
                            var benendDate = component.get('v.benefitEndDate');
                            var groupNumber = covInfoBenefits.GroupNumber; 
                         	var action = component.get("c.getBenefitAccumulatorResults");
                            var benefitStartDate = $A.localizationService.formatDate(benstartDate, "YYYY-MM-DD");
                            var benefitEndDate = $A.localizationService.formatDate(benendDate, "YYYY-MM-DD");
                            var reqParams = {
                            'surrogateKey': surrogateKey,
                            'bundleId': bundleId,
                            'enrollerSRK': enrollerSRK,
                            'startDate': benefitStartDate,
                            'endDate': benefitEndDate,
                            'groupNumber' : groupNumber,
                            'benefitCodes' : benefitCodejs,
                            'accumAsOf' : benefitdateSearch,
                            'tierTypeCodeList' : component.get("v.tierTypeCodeList"),
                            'membershipList' : component.get("v.timePeriodQualifier"),
                            'tierTypeIdentifierList' : component.get("v.tierTypeIdentifierList"),
                            'benefitRiderString' :existsOnRiderPlanMapfinal ,
   
                        
                       };
        action.setParams(reqParams);
            action.setCallback(this, function(response) {
                
                var state = response.getState();
                if (state === "SUCCESS") {
                    var result = response.getReturnValue();
                    console.log('result list==>'+JSON.stringify(result));
                    if(!$A.util.isEmpty(result) && !$A.util.isUndefined(result)){
						 if(!$A.util.isEmpty(result.resultBenefitAccumulatorWrapper) && !$A.util.isUndefined(result.resultBenefitAccumulatorWrapper)&& !$A.util.isEmpty(result.resultBenefitAccumulatorWrapper[0].accumulatorCodeList) && !$A.util.isUndefined(result.resultBenefitAccumulatorWrapper[0].accumulatorCodeList)) {
                      
                          var accumList = result.resultBenefitAccumulatorWrapper[0].accumulatorCodeList;
                          console.log(accumList);
                          var arr = new Array();
                          var arrVal = new Array();
						  console.log(accumId);
						  console.log(accumList.length);
                          if(accumList != null && accumList.length > 0){
                            htmlStr = htmlStr + "<br/>"; 
                            htmlStr = htmlStr + "<table  class='slds-p-left_small slds-table slds-table_cell-buffer slds-table_bordered' border='0' cellpadding='0' id='accumTable' cellspacing='0' >";
                            htmlStr = htmlStr + "<colgroup span='4'></colgroup>";                            
                            htmlStr = htmlStr + "<tr class='slds-line-height_reset' >";
                            htmlStr = htmlStr + "<th class='fontTable' scope='col' colspan='1'>Coverage Level</th>";
                            htmlStr = htmlStr + "<th class='fontTable' scope='col' colspan='1'>Coverage Type</th>";
                            htmlStr = htmlStr + "<th class='fontTable' scope='col' colspan='1'>Cost Share Type</th>";
                            htmlStr = htmlStr + "<th class='fontTable' scope='col' colspan='1'>Limit</th>";
                            htmlStr = htmlStr + "<th class='fontTable' scope='col' colspan='1'>Limit Type</th>";
                            htmlStr = htmlStr + "<th class='fontTable' scope='col' colspan='1'>Duration</th>";
                            htmlStr = htmlStr + "<th class='fontTable' scope='col' colspan='1'>Applied</th>";
                            htmlStr = htmlStr + "<th class='fontTable' scope='col' colspan='1'>Remaining</th>";
                            htmlStr = htmlStr + "</tr>";
                            for(var k=0;k<accumList.length;k++){
                                
                                
                                var dateRangeVar = accumList[k].dateRangeValue;
                                htmlStr = htmlStr + "<tr class='dataRow' id='"+dateRangeVar+"dateRange"+accumId+"Select'>";
                                if(accumList[k].BenefitKey == accumId){
                                htmlStr = htmlStr + "<td class='dataCell'  colspan='1' >"+accumList[k].coverageLevel+"</td>";
                                htmlStr = htmlStr + "<td class='dataCell'  colspan='1' >"+accumList[k].coverageType+"</td>";
                                htmlStr = htmlStr + "<td class='dataCell'  colspan='1' >"+accumList[k].costShareType+"</td>";
                                htmlStr = htmlStr + "<td class='dataCell'  colspan='1' >"+accumList[k].benefitMaximumValue+"</td>";
                                htmlStr = htmlStr + "<td class='dataCell'  colspan='1' >"+accumList[k].benefitMaximumUnit+"</td>";
                                htmlStr = htmlStr + "<td class='dataCell'  colspan='1' >"+accumList[k].duration+"</td>"; 
                                htmlStr = htmlStr + "<td class='dataCell'  colspan='1' >"+accumList[k].benefitYTDValue+"</td>";
                                htmlStr = htmlStr + "<td class='dataCell'  colspan='1' >"+accumList[k].benefitRemainingValue+"</td>";
                                //htmlStr = htmlStr + "<td class='dataCell'  colspan='1' >"+accumList[k].dateVersion+"</td>";
                                }
                                htmlStr = htmlStr + "</tr>";
                                
                            }
                            htmlStr = htmlStr + "</table>";
							console.log(htmlStr);
							var accumDivId = document.getElementById(accumId+'accumeLevel');
							accumDivId.innerHTML = htmlStr;
                            //$("[id="+accumId+"accumeLevel]").html(htmlStr);
                          }
                        }else {
                              htmlStr = htmlStr + '<div class="accumCls slds-icon-utility-info slds-icon_container"><img src="'+$A.get('$Resource.SLDS') + '/assets/icons/utility/info_60.png" style="max-width:16px;"></img></div>'+"<b style='color:blue'> Alert : No accumulation for this benefit. Review benefit language.</b>";                                 
                              var accumDivId = document.getElementById(accumId+'accumeLevel');
							  accumDivId.innerHTML = htmlStr;
                       } 
                        
                         
                        
                        
                    }
                    
                } else if (state === "ERROR") {
                    //component.set("v.Spinner",false);
                    
                }
                
            });
            $A.enqueueAction(action);
    
                          }
                   }         
    

  },
    handleBenefitKeyEvent : function(component,event,helper) {
        var viewBenefitButtonSelectedOptionsList = event.getParam("viewBenefitButtonSelectedOptions");
        var selectedBenefitLangcodesList = event.getParam("selectedBenefitLangcodes");
        var selectedBenefitLangcodestring = event.getParam("selectedBenefitLangcodestring");
        console.log(viewBenefitButtonSelectedOptionsList);
        console.log(selectedBenefitLangcodesList);
        helper.removeBenefitCode(component,event,helper,viewBenefitButtonSelectedOptionsList,selectedBenefitLangcodesList,selectedBenefitLangcodestring);
    },
    sectionopenandcloase: function(component,event,helper) {
       var accdatacmpdivid = '#'+event.currentTarget.getAttribute("data-compid");
       var acciconidcmpid_close = '#'+event.currentTarget.getAttribute("data-acciconid_close");
       var acciconidcmpid_open = '#'+event.currentTarget.getAttribute("data-acciconid_open");
        if( $(accdatacmpdivid).attr('class') =="slds-show"){
               $(acciconidcmpid_open).removeClass("slds-show");
             $(acciconidcmpid_open).addClass("slds-hide");
              $(acciconidcmpid_close).removeClass("slds-hide");
             $(acciconidcmpid_close).addClass("slds-show");
             $(accdatacmpdivid).addClass("slds-hide");
             $(accdatacmpdivid).removeClass("slds-show");
                }else{
                $(accdatacmpdivid).removeClass("slds-hide");
             $(accdatacmpdivid).addClass("slds-show");
               $(acciconidcmpid_open).addClass("slds-show");
             $(acciconidcmpid_open).removeClass("slds-hide");
              $(acciconidcmpid_close).addClass("slds-hide");
             $(acciconidcmpid_close).removeClass("slds-show");
                }
  
    }
})