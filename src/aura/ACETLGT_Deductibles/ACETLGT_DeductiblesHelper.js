({
    getDataFromServer: function(cmp, event, helper){
        helper.showSpinner2(cmp,event,helper);
        var hasRequestSend = cmp.get('v.hasRequestSend');
        console.log('??'+hasRequestSend);
        if(hasRequestSend){
            helper.hideSpinner2(cmp,event,helper);
            return;
        }
        cmp.set('v.deductibleData', []);
        var covInfoBenefits = cmp.get('v.coverageData');
        if(covInfoBenefits != undefined){
            console.log('----covInfoBenefits'+covInfoBenefits.CoverageLevelCode);
            var surrogateKey = covInfoBenefits.SurrogateKey;
            var bundleId = covInfoBenefits.benefitBundleOptionId;
            var enrollerSRK = covInfoBenefits.EnrolleeSurrogateKey;
            var startDate = covInfoBenefits.EffectiveDate;
            var endDate = covInfoBenefits.EndDate;
            var benstartDate = covInfoBenefits.BenEffectiveDate;
            var benendDate = covInfoBenefits.BenEndDate;
            var coverageTypes = ''; //covInfoBenefits.CoverageTypes;
            var groupNumber = covInfoBenefits.GroupNumber;
            var accumsDate = ''; //covInfoBenefits.accumsDate;
            var accumAsOf = ''; //covInfoBenefits.AccumAsOf;
            var isActive = covInfoBenefits.isActive;
            var isTermed = covInfoBenefits.isTermed;
            var coverageLevelCode=covInfoBenefits.CoverageLevelCode;
			var customerPurchaseId = cmp.get('v.customerPurchaseId'); 
            
            if(coverageLevelCode!= null && coverageLevelCode!='' && coverageLevelCode != undefined){
                if(coverageLevelCode == 'IND' || coverageLevelCode == 'EMP')
                    coverageLevelCode = 'IND';
                else
                    coverageLevelCode ='FAM';
            }
            cmp.set("v.covLevelCode",coverageLevelCode);
            console.log('Benefit request/required attributes'+coverageLevelCode+startDate+'//'+endDate+'//'+benstartDate+'//'+benendDate+'??'+isActive+'??'+isTermed);
            
            
            var action = cmp.get("c.getSearchResults");
            var reqParams = {
                'surrogateKey': surrogateKey,
                'bundleId': bundleId,
                'enrollerSRK': enrollerSRK,
                'startDate': benstartDate,
                'endDate': benendDate,
                'coverageTypes': coverageTypes,
                'groupNumber': groupNumber,
                'accumsDate': accumsDate,
                'accumAsOf': accumAsOf,
                'isActive': isActive,
                'isTermed': isTermed,
				'getSearchResults':customerPurchaseId
            };
            action.setParams(reqParams);
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var retValue = response.getReturnValue();
                        console.log('retValue.ErrorMessage : ', retValue.ErrorMessage);
                        if($A.util.isEmpty(retValue.ErrorMessage) && !$A.util.isEmpty(retValue.resultWrapper) && !$A.util.isUndefined(retValue.resultWrapper)  && !$A.util.isEmpty(retValue) && !$A.util.isUndefined(retValue) ) {
                        var resp = retValue.resultWrapper;
                    console.log('KK 01');
                    console.log(resp);
                    console.log('KK 02');
                    cmp.set('v.deductibleData', resp);
                    helper.executeResponseValidations(cmp, event, helper);
                    cmp.set('v.doCollapse', true);
                    cmp.set('v.hasRequestSend', true);
                    setTimeout(function(){
                        var tabKey = cmp.get("v.AutodocKey") +'Deductibles';
                        //alert("tabKey"+tabKey);
                        if(window.lgtAutodoc != undefined)
                            window.lgtAutodoc.initAutodoc(tabKey);
                        helper.hideSpinner2(cmp,event,helper);
                    },1);
                    //helper.hideSpinner2(cmp,event,helper);
                    } else {
                        console.log('retValue.ErrorMessage : ', retValue.ErrorMessage);
                        helper.displayToast('Error!', retValue.ErrorMessage);
                        helper.hideSpinner2(cmp,event,helper);
                    }
                    } else if (state === "ERROR") {
                        var errors = response.getError();
                        helper.hideSpinner2(cmp,event,helper);
                } 
                
            });
            $A.enqueueAction(action);
            
        }else{
                cmp.set("v.isExpand", true);
                helper.displayToast('Error!', 'Unexpected error occured. Please try again.');
            helper.hideSpinner2(cmp,event,helper);
        }
    },
    
    executeResponseValidations: function(cmp, event, helper){
        
        function calRemaining(valMax, valMin){
            if(!isNaN(valMax) && !isNaN(valMin)){
                return '$' + (valMax - valMin).toFixed(2);
            }
            return 'N/A';
        }
        
        function validateValue(val){
            if(!isNaN(val)){
                return '$' + val;
            }
            return val;
        }
        
        var deductibleData = cmp.get('v.deductibleData');
        
        deductibleData.IIN_PLAN_REMAIN = calRemaining(deductibleData.IIN_PLAN_MAX, deductibleData.IIN_PLAN_MIN);
        deductibleData.IIN_PLAN_MIN = validateValue(deductibleData.IIN_PLAN_MIN);
        deductibleData.IIN_PLAN_MAX = validateValue(deductibleData.IIN_PLAN_MAX);
        
        deductibleData.FIN_PLAN_REMAIN = calRemaining(deductibleData.FIN_PLAN_MAX, deductibleData.FIN_PLAN_MIN);
        deductibleData.FIN_PLAN_MIN = validateValue(deductibleData.FIN_PLAN_MIN);
        deductibleData.FIN_PLAN_MAX = validateValue(deductibleData.FIN_PLAN_MAX);
        
        deductibleData.IIN_OOP_REMAIN = calRemaining(deductibleData.IIN_OOP_MAX, deductibleData.IIN_OOP_MIN);
        deductibleData.IIN_OOP_MIN = validateValue(deductibleData.IIN_OOP_MIN);
        deductibleData.IIN_OOP_MAX = validateValue(deductibleData.IIN_OOP_MAX);
        
        deductibleData.FIN_OOP_REMAIN = calRemaining(deductibleData.FIN_OOP_MAX, deductibleData.FIN_OOP_MIN);
        deductibleData.FIN_OOP_MIN = validateValue(deductibleData.FIN_OOP_MIN);
        deductibleData.FIN_OOP_MAX = validateValue(deductibleData.FIN_OOP_MAX);
        
        deductibleData.ION_PLAN_REMAIN = calRemaining(deductibleData.ION_PLAN_MAX, deductibleData.ION_PLAN_MIN);
        deductibleData.ION_PLAN_MIN = validateValue(deductibleData.ION_PLAN_MIN);
        deductibleData.ION_PLAN_MAX = validateValue(deductibleData.ION_PLAN_MAX);
        
        deductibleData.FON_PLAN_REMAIN = calRemaining(deductibleData.FON_PLAN_MAX, deductibleData.FON_PLAN_MIN);
        deductibleData.FON_PLAN_MIN = validateValue(deductibleData.FON_PLAN_MIN);
        deductibleData.FON_PLAN_MAX = validateValue(deductibleData.FON_PLAN_MAX);
        
        deductibleData.ION_OOP_REMAIN = calRemaining(deductibleData.ION_OOP_MAX, deductibleData.ION_OOP_MIN);
        deductibleData.ION_OOP_MIN = validateValue(deductibleData.ION_OOP_MIN);
        deductibleData.ION_OOP_MAX = validateValue(deductibleData.ION_OOP_MAX);
        
        deductibleData.FON_OOP_REMAIN = calRemaining(deductibleData.FON_OOP_MAX, deductibleData.FON_OOP_MIN);
        deductibleData.FON_OOP_MIN = validateValue(deductibleData.FON_OOP_MIN);
        deductibleData.FON_OOP_MAX = validateValue(deductibleData.FON_OOP_MAX);
        
        cmp.set('v.deductibleData', deductibleData);
    },
    hideSpinner2: function(cmp, event, helper) {        
        cmp.set("v.Spinner", false);
        console.log('Hide');
    },
    // this function automatic call by aura:waiting event  
    showSpinner2: function(cmp, event, helper) {
        // make Spinner attribute true for display loading spinner 
        cmp.set("v.Spinner", true);
        console.log('show');
    },
    
    showHelpText : function() {
        console.log('init');
        var a = document.getElementsByClassName('accumulators');
        console.log('a ', a);
        var div = document.createElement("div");
        div.setAttribute('style', 'color:red');
        div.setAttribute('class', 'error_email');
        var span0 = document.createTextNode("Embedded:-");
        var span = document.createTextNode("<b>Sit:-</b> <br />nulla est ex deserunt exercitation anim occaecat. Nostrud ullamco deserunt aute id consequat veniam incididunt duis in sint irure nisi.");
        div.appendChild(span0);
        div.appendChild(span);
        console.log('div : ', div);
        //console.log('a[0].parentElement.parentElement.firstElementChild : ', a[0].parentElement.parentElement.firstElementChild);
        //console.log('a[0].parentElement.parentElement : ', (a[0].parentElement.parentElement));
        //console.log('a[0].parentElement : ', a[0].parentElement);
        console.log('a[0] : ', a[0]);
        a[0].firstElementChild.firstElementChild.appendChild(div);
    },
    displayToast: function(title, messages){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": messages,
            "type": "error",
            "mode": "dismissible",
            "duration": "10000"
        });
        toastEvent.fire();
		return;
    }
    
})