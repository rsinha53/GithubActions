({
    doInit : function(component, event, helper) {
        debugger;
        //helper.showSpinner2(component, event, helper);
        var len = 22;
        var buf = [],
            chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789',
            charlen = chars.length,
            length = len || 32;
            
        for (var i = 0; i < length; i++) {
            buf[i] = chars.charAt(Math.floor(Math.random() * charlen));
        }
        var GUIkey = buf.join('');
		component.set("v.GUIkey",GUIkey+'321');
       

		var today= $A.localizationService.formatDate(new Date(), "MM/DD/YYYY");
        component.set("v.todayDate",today);  
        //var covInfoBenefits = component.get("v.attrcoverageBenefits");
		component.set('v.benefitDate',component.get('v.selectedBenefitDate')); 
        component.set('v.benefitDate',today); 
        component.set('v.benefitDateForAccums',component.get('v.selectedBenefitDate')); 
        component.set('v.benefitDateForAccums',today); 
        
        component.set("v.allSelChildBenefitList",[]);
        component.set("v.selectedLookUpRecords",[]);
        component.set("v.benefitSearchPhase","");
        component.set("v.searchBenefitsResults",[]);
        component.set('v.searchResultBenefitData',[]);
        component.set('v.benefitNetworkSectionList',[]);
        
        var bboId = component.get("v.selectedBundleId") ? component.get("v.selectedBundleId") : '';
        var groupNumber = component.get("v.groupNumber") ? component.get("v.groupNumber") : '';
        var benefitPlanId = ( bboId && groupNumber) ? groupNumber + '_' + bboId : '';
       // benefitPlanId = '1008812_11958488';
        component.set("v.b360BenefitPlanId", benefitPlanId);
        helper.getBenefitCategory(component,event,helper); 
        helper.getBenefitLanguageIndicatorValues(component,event,helper);
    },
    showBenefitCategory: function(component,event,helper){
        debugger;
        helper.clearAllErrorMessage(component,event,helper);
        component.set('v.searchResultBenefitData',[]);
        component.set('v.searchBenefitsResults',[]);
       // component.set('v.showError',false);
        component.set('v.benefitSearchPhase','');
        component.set('v.benefitNetworkSectionList',[]);
        
        var isValidBenDate = helper.validateBenDate(component,event,helper);
        if(!isValidBenDate) return false;
        
        var returnError = false;
        var benefitCategoryChildrenMap = component.get("v.benefitCategoryChildrenMap");
        benefitCategoryChildrenMap = benefitCategoryChildrenMap ? benefitCategoryChildrenMap : {};
        var GlobalAutocompletecmp = component.find('B360BenefitGlobalAutocomplete');
       	var selectedBenefitList = GlobalAutocompletecmp.get('v.lstSelectedRecords');
        var benefitdateSearch = component.get("v.benefitDate");
        console.log('>>> Selected Benefit :' + JSON.stringify(selectedBenefitList));
        console.log('>>> Child Benefits Map : ' + JSON.stringify(benefitCategoryChildrenMap));
        /*if($A.util.isEmpty(benefitdateSearch)){
               $A.util.addClass(benefitcomp, "slds-has-error-date");
               component.set("v.DOBErrorMessage","Error: You must enter a value.");  
               $A.util.removeClass(component.find("msgTxtDOB"), "slds-hide")
               $A.util.addClass(component.find("msgTxtDOB"), "slds-show");
               returnError = true; 
       }*/
       if ($A.util.isEmpty(selectedBenefitList)){                    
               // $A.util.addClass(GlobalAutocompletecmp, "slds-has-error");
                component.set("v.showBenCatSelError", true);
                component.set("v.benefitError", "Error: You must select a value.");   
                returnError = true;     
          }else {
              $A.util.removeClass(GlobalAutocompletecmp, "slds-has-error");
        }
        if(returnError)
            return;
        var allChildBenefits = [];
        selectedBenefitList.forEach(function(selBenefit, index){
            var selBenefitCategory = selBenefit.value;
            
            var childBenefits = benefitCategoryChildrenMap[selBenefitCategory];
            if(!$A.util.isEmpty(selectedBenefitList))
            {
                Array.prototype.push.apply(allChildBenefits, childBenefits);
            }
            
        });
        
        component.set("v.allSelChildBenefitList", allChildBenefits);
        if(allChildBenefits.length == 0){
            component.set('v.showError',true);
		}
        
        
          setTimeout(function(){
		            var tabKey = component.get("v.AutodocKey")+ component.get("v.GUIkey");
                            if(window.lgtAutodoc != undefined){
		            	window.lgtAutodoc.initAutodoc(tabKey);
                         helper.hideSpinner2(component, event, helper);
                            }
                         $("#b360benifitCategoryresultstable tr th.autodoc-case-item-resolved").css("display","none");
                          $("#b360benifitCategoryresultstable tr td.autodoc-case-item-resolved").css("display","none");
                            $("#b360benifitCategoryresultstable tr th.autodoc").css("display","none");
                 
		        },10);
        
    },
    populateBenefitDate : function(component,event,helper) {
      var todayDate = component.get("v.todayDate");
      //var convertedTodayDate = $A.localizationService.formatDate(todayDate, "YYYY-MM-DD");
      component.set("v.benefitDate",todayDate);
      var a = component.get('c.updateCategoryList');
      $A.enqueueAction(a);
    },
    populateBenefitDateForBA : function(component,event,helper) {
      var todayDate = component.get("v.todayDate");
      //var convertedTodayDate = $A.localizationService.formatDate(todayDate, "YYYY-MM-DD");
      component.set("v.benefitDateForAccums",todayDate);
        component.set("v.showDOBErrorMessageForAccums", false);
        component.set("v.DOBErrorMessageForAccums", "");
      
    },
    
    onClickOfEnter : function(component,event, helper) {
        debugger;
        if (event.which == 13){
            
            //alert("HITS");
            console.log('hits :: '+component.find('B360BenefitGlobalAutocomplete').get("v.listOfSearchRecords"));
            if (component.find('B360BenefitGlobalAutocomplete').get("v.listOfSearchRecords") == null){
                
                var a = component.get('c.doInit');
                $A.enqueueAction(a);
                
            }
            
        }
        
    },
    evntCalled : function(component, event, helper) {
        console.log('====selectedItems===',event.getParam('selectedItems'));
        var selectedOptionValue = event.getParam('selectedItems');
        component.set("v.selectedItemOptions", selectedOptionValue);
    },
    //Below method is triggered when Benefit search is happening using a phrase
    benefitSearch : function(component,event,helper){
        helper.clearAllErrorMessage(component,event,helper);
        component.set("v.allSelChildBenefitList", []);
        //component.set('v.showError',false);
        component.set('v.selectedLookUpRecords',[]);
        component.set('v.searchBenefitsResults',[]);
        component.set('v.benefitNetworkSectionList',[]);
        
        var isValidBenDate = helper.validateBenDate(component,event,helper);
        if(!isValidBenDate) return false;
        
        var searchPhrase = component.get('v.benefitSearchPhase');
        searchPhrase = searchPhrase ? searchPhrase.trim() : searchPhrase;
        if(!searchPhrase)
        {
            component.set('v.showKeywordInputError', true);
            component.set('v.benefitError','Error : You must enter a value');
            return;
        }
        component.set('v.renderSpinner',true);
        console.log('searched phase'+searchPhrase);
        if(searchPhrase != '' && searchPhrase != undefined){
        helper.helperSearchBenefits(component,event,helper,searchPhrase);
        }
    },
    
    showBenefitSection : function(component,event,helper){
        helper.clearAllErrorMessage(component,event,helper);
        component.set('v.showError',false);
        component.set('v.renderSpinner',true);
        var sectionAuraId = event.currentTarget.getAttribute("data-auraId");
        var sectionDiv1 = document.getElementById(sectionAuraId);
        component.set('v.selectedSectionId',sectionAuraId);
        var sectionState = sectionDiv1.getAttribute('class').search('slds-is-open'); 
      
        // -1 if 'slds-is-open' class is missing...then set 'slds-is-open' class else set slds-is-close class to element
        if(sectionState == -1){
            sectionDiv1.setAttribute('class' , 'slds-section slds-is-open');
           // component.set("v.benefitNetworkSectionList",[]);
            var benefitId = event.currentTarget.getAttribute("data-benefitId");
            helper.fetchBenefitSection(component,event,helper,benefitId,sectionAuraId,document);
            
        }else{
            sectionDiv1.setAttribute('class' , 'slds-section slds-is-close');
            component.set('v.renderSpinner',false);
        }
        /*Clear the Prev Result
        var contentDiv = sectionDiv1.getElementsByClassName('slds-section__content');
        contentDiv[0].innerHTML = '';
        */
       
    },
    
    renderBenefiSectionData : function(component,event,helper){
        var resltData = component.get('v.searchResultBenefitData');
        var sectionData = resltData;
        var sectionAuraId = component.get('v.selectedSectionId');
        var sectionDiv =  document.getElementById(sectionAuraId);
        var netwrkObj = {};
                   netwrkObj.label = sectionData[0].benefitName;
        			var netwrkSection = sectionData;
              
                   netwrkObj.value = netwrkSection;
        			netwrkObj.benefitId = sectionData[0].benefitId;
        			var netwrkList = [];
                    netwrkList = component.get('v.benefitNetworkSectionList');
        netwrkList.forEach(function(item,index){
            if(item.benefitId === netwrkObj.benefitId){
				netwrkList.splice(index,1);
                //break;
            }
        });
                   netwrkList.push(netwrkObj);
                   component.set('v.benefitNetworkSectionList',netwrkList);
        
       
          window.setTimeout(
            $A.getCallback(function() {
        	var divs1 = document.querySelectorAll('[id=networkLangDiv]');
                for(var a=0;a<divs1.length;a++){
         //  divs1.forEach(function(el){
               var innerContent = divs1[a].innerText;
                    if(divs1[a].innerText.indexOf('<') > -1){
                        innerContent = divs1[a].innerText;
                        divs1[a].innerHTML =innerContent;
                    }else{
                        innerContent = divs1[a].innerHTML;
                        var parser = new DOMParser();
                    
						var ac = parser.parseFromString(innerContent, 'text/html');
                		divs1[a].innerHTML = ac.firstChild.lastChild.innerHTML; 
                    }
               
           }
                
        }), 1000);
        component.set('v.renderSpinner',false);
    },
    
    updateCategoryList : function(component,event,helper){
        debugger;
        helper.clearAllErrorMessage(component,event,helper);
        component.set("v.allSelChildBenefitList",[]);
        component.set("v.selectedLookUpRecords",[]);
        component.set("v.benefitSearchPhase","");
        component.set("v.searchBenefitsResults",[]);
        component.set('v.searchResultBenefitData',[]);
        var isValidBenDate = helper.validateBenDate(component,event,helper);
        if(!isValidBenDate) return false;
        component.set('v.renderSpinner',true);
        helper.getBenefitCategory(component,event,helper); 
    },
    
    validateBenefitDtForBA : function(component,event,helper){
        helper.validateBenDateForAccums(component,event,helper);
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
          var groupNumber = component.get('v.groupNumber'); 
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
    
    handleBenefitKeyEvent : function(component,event,helper){
        component.set("v.allSelChildBenefitList", []);
        var clearedBenefit = event.getParam('selectedBenefitLangcodestring');
        var selectedBnfs = component.get('v.selectedBenefits');
        
        selectedBnfs.forEach(function(selBenefit,index){
            var selBenefitCategory = selBenefit.label;
            if(selBenefitCategory == clearedBenefit){
                selectedBnfs.splice(index,1);
            }
        });
        component.set('v.selectedBenefits',selectedBnfs);
        
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
    showAccumsSections : function(component,event,helper){
        component.set('v.renderSpinnerForBA',true);
        var GlobalAutocomplete = component.find('PlanBenefitGlobalAutocomplete');
       var selectedBenefitList = GlobalAutocomplete.get('v.lstSelectedRecords');
        
        if(selectedBenefitList.length > 0){
            selectedBenefitList.forEach(function(item,index){
                var lb = item.value;
                var accumsDivId = document.getElementById(lb+'accumeLevel');
                if(accumsDivId != null){
                accumsDivId.innerHTML = '';
                }
            });
        setTimeout(function(){
        component.set('v.renderSpinnerForBA',false);
            component.set('v.showErrorViewAccums',false);
        component.set('v.selectedBenefits',selectedBenefitList);
          
            component.set('v.activeSections',[]);
           
        }, 1000);
        }else{
            component.set('v.renderSpinnerForBA',false);
            component.set("v.errorMsgViewAccums", "Error: You must enter a value");
            component.set('v.showErrorViewAccums',true);
            component.set('v.renderAccums',false);
        }
    },
    
    AccumulatorsOnclick : function(component, event, helper) {
                var existsOnRiderPlanMapfinal;
         var GlobalAutocomplete = component.find('PlanBenefitGlobalAutocomplete');
       var selectedBenefitList = GlobalAutocomplete.get('v.lstSelectedRecords');
        
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
                       var benefitdateSearch = component.get("v.benefitDateForAccums");
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
                            benefitdateSearch = $A.localizationService.formatDate(benefitdateSearch, "YYYY-MM-DD");
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
                            htmlStr = htmlStr + "<b style='padding: 2%;'>Accumulators </b>";
                             
                            htmlStr = htmlStr + "<br/><br/>"; 
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
							//var accumDivId = document.getElementById('accumeLevel');
                              var accumDivId = document.getElementById(accumId+'accumeLevel');
							accumDivId.innerHTML = htmlStr;
                           // $("[id=accumeLevel]").html(htmlStr);
                              //$("[id="+accumId+"accumeLevel]").html(htmlStr);
                          }
                        }else {
                              htmlStr = htmlStr + '<div class="accumCls slds-icon-utility-info slds-icon_container"><img src="'+$A.get('$Resource.SLDS') + '/assets/icons/utility/info_60.png" style="max-width:16px;"></img></div>'+"<b style='color:blue'> Alert : No accumulation for this benefit. Review benefit language. </b>";                                 
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
     copycode_event: function(component, event, helper) {
               var textForCopy = event.currentTarget.getAttribute("data-codetocopy");
         if(textForCopy != null){
             if(textForCopy.indexOf('-') > -1){
             	var updatedVal = textForCopy.split('-')[0];
                 updatedVal = updatedVal.trimEnd();
                helper.copyTextHelper(component,event,updatedVal);
             }else{
                helper.copyTextHelper(component,event,textForCopy); 
             }
         }

  },
})