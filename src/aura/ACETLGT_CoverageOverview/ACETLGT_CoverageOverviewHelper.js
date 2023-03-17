({
    getAccumSearchResults : function(component,event,helper,covInfoBenefits) {
        if(covInfoBenefits != undefined){
        var surrogateKey = covInfoBenefits.SurrogateKey;
		 var bundleId = '';
            if(undefined != component.get('v.selectedBundleId')){
                 bundleId = component.get('v.selectedBundleId');
            }else{
                  bundleId = covInfoBenefits.benefitBundleOptionId;
            }
            var enrollerSRK = covInfoBenefits.EnrolleeSurrogateKey;
            var benstartDate = '';
            if(undefined != component.get('v.selectedStrtDt')){
                 benstartDate = component.get('v.selectedStrtDt');
            }else{
                 benstartDate = covInfoBenefits.BenEffectiveDate;
            }
            var benendDate = '';
            if(undefined != component.get('v.selectedEndDt')){
                 benendDate = component.get('v.selectedEndDt');
            }else{
                  benendDate = covInfoBenefits.BenEndDate;
            }
            component.set('v.selectedBenefitEndDt',benendDate);
            var acumAsOfDt;
            var tdayDt = component.get('v.todaysdate');
            var tdayDtAry = tdayDt.split('/');
            tdayDt = tdayDtAry[2]+'/'+tdayDtAry[0]+'/'+tdayDtAry[1];
            var sltdStrtDt = component.get('v.selectedStrtDt');
            var sltdStrtDtAry = sltdStrtDt.split('/');//mm//dd//yyyy
            //yyy/mm//dd
            if(sltdStrtDtAry[0].indexOf('0') == -1 && sltdStrtDtAry[0] < 10){
                sltdStrtDtAry[0] = '0'+sltdStrtDtAry[0];
            }
            if(sltdStrtDtAry[1].indexOf('0') == -1 && sltdStrtDtAry[1] < 10){
                sltdStrtDtAry[1] = '0'+sltdStrtDtAry[1];
            }
            sltdStrtDt = sltdStrtDtAry[2]+'/'+sltdStrtDtAry[0]+'/'+sltdStrtDtAry[1];
			component.set('v.selectedBenefitStrtDt',sltdStrtDt);													
            
            var sltdEndDt = component.get('v.selectedEndDt');
            var sltdEndDtAry = sltdEndDt.split('/');
            if(sltdEndDtAry[0].indexOf('0') == -1 && sltdEndDtAry[0] < 10){
                sltdEndDtAry[0] = '0'+sltdEndDtAry[0];
            }
            if(sltdEndDtAry[1].indexOf('0') == -1 && sltdEndDtAry[1] < 10){
                sltdEndDtAry[1] = '0'+sltdEndDtAry[1];
            }
              sltdEndDt = sltdEndDtAry[2]+'/'+sltdEndDtAry[0]+'/'+sltdEndDtAry[1];
			component.set('v.selectedBenefitEndDt',sltdEndDt);												  
            if(new Date(sltdEndDt) < new Date(tdayDt)){
                acumAsOfDt = sltdEndDt;
            }else if(new Date(sltdEndDt) >= new Date(tdayDt)){
                acumAsOfDt = tdayDt;
            }
            if(new Date(sltdStrtDt) > new Date(tdayDt)){
                acumAsOfDt = sltdStrtDt;
            }
             if(undefined != acumAsOfDt){
                 var slctdEndDtAry = acumAsOfDt.split('/');
                 var slctdDt = slctdEndDtAry[0]+'-'+slctdEndDtAry[1]+'-'+slctdEndDtAry[2];
                 acumAsOfDt = slctdDt;
            }
            component.set('v.accumsdatesearch',acumAsOfDt);
            /*If  coverage end date < today's date then pick last date of coverage period
            If coverage end date >= today's date then pick todays date
            If coverage EffectiveDate> today's date then pick coverage start date
            */
            var groupNumber = covInfoBenefits.GroupNumber; 
            var coverageLevelCode=covInfoBenefits.CoverageLevelCode;

            if(coverageLevelCode!= null && coverageLevelCode!='' && coverageLevelCode != undefined){
                if(coverageLevelCode == 'IND' || coverageLevelCode == 'EMP')
                    coverageLevelCode = 'IND';
                else
                    coverageLevelCode ='FAM';
            }
            component.set("v.covLevelCode",coverageLevelCode);
            var action = component.get("c.getSearchAccumResults");
            var reqParams = {
                'surrogateKey': surrogateKey,
                'bundleId': bundleId,
                'enrollerSRK': enrollerSRK,
                'startDate': benstartDate,
                'endDate': benendDate,
                'coverageTypes': '',
                'groupNumber': groupNumber,
                'accumAsOf': acumAsOfDt,
                'SitusState' : component.get('v.SitusState')
            };
            action.setParams(reqParams);
            action.setCallback(this, function(response) {
                helper.hideSpinner2(component,event,helper);
                var state = response.getState();
                if (state === "SUCCESS") {
                    var result = response.getReturnValue();
                    console.log(JSON.stringify(result));
                    if(!$A.util.isEmpty(result) && !$A.util.isUndefined(result)){
                       console.log(result.resultWrapper);
                       component.set('v.individualAccumList',result.resultIndividualAccumWrapper);
                       component.set('v.familyAccumList',result.resultFamilyAccumWrapper);
                    }
                    console.log(JSON.stringify(component.get('v.individualAccumList')));
                    console.log(JSON.stringify(component.get('v.familyAccumList'))); 
                    var tabKey = component.get("v.accumAutodocKey") + component.get("v.accumGUIkey");
                    //alert(component.get("v.accumAutodocKey"));
                    //alert(component.get("v.accumGUIkey"));
                            setTimeout(function() {
                            //alert(tabKey);
                             //alert("====");
                                window.lgtAutodoc.initAutodoc(tabKey);
                                //alert("==done?==");
                            }, 1);
    	    } else if (state === "ERROR") {
                    helper.hideSpinner2(component,event,helper);
   			}  
			 });
         $A.enqueueAction(action);
        }else{
            
        }
    },
    validateDate : function(component,event,helper,covInfoBenefits) {
        if(covInfoBenefits != undefined){
            var benstartDate = covInfoBenefits.BenEffectiveDate;
            var benendDate = covInfoBenefits.BenEndDate;
            var today= $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
            var benefitEndDate = $A.localizationService.formatDate(benendDate, "YYYY-MM-DD");
            var benefitEffectiveDate = $A.localizationService.formatDate(benstartDate,"YYYY-MM-DD");
            if(!$A.util.isEmpty(benefitEffectiveDate) && !$A.util.isUndefined(benefitEffectiveDate) && !$A.util.isEmpty(benefitEndDate) && !$A.util.isUndefined(benefitEndDate)) {
          //   alert (benefitEndDate + today + benefitEffectiveDate);
            if(benefitEndDate >= today && benefitEffectiveDate <  today) {              
                 component.set("v.accumsdatesearch",today);
             }
            else if(benefitEndDate < today) {
                   component.set("v.accumsdatesearch",benefitEndDate);
            }
            else if(benefitEffectiveDate > today && benefitEndDate >= today) {              
                  component.set("v.accumsdatesearch",benefitEffectiveDate);
            }
        }  
        } 
    },
    hideSpinner2: function(component, event, helper) {        
        window.setTimeout($A.getCallback(function(){
            component.set("v.Spinner", false);
        }),3000)
        console.log('Hide');
    },
     
    getAccumSearchResultsUPdtd : function(component,event,helper,covInfoBenefits,accumsrch) {
        if(covInfoBenefits != undefined){
        var surrogateKey = covInfoBenefits.SurrogateKey;
		 var bundleId = '';
            if(undefined != component.get('v.selectedBundleId')){
                 bundleId = component.get('v.selectedBundleId');
            }else{
                  bundleId = covInfoBenefits.benefitBundleOptionId;
            }
            var enrollerSRK = covInfoBenefits.EnrolleeSurrogateKey;
            var benstartDate = '';
            if(undefined != component.get('v.selectedStrtDt')){
                 benstartDate = component.get('v.selectedStrtDt');
            }else{
                 benstartDate = covInfoBenefits.BenEffectiveDate;
            }
            
            var benendDate = '';
            if(undefined != component.get('v.selectedEndDt')){
                 benendDate = component.get('v.selectedEndDt');
            }else{
                  benendDate = covInfoBenefits.BenEndDate;
            }
            component.set('v.selectedBenefitEndDt',benendDate);
            var acumAsOfDt;
            var tdayDt = component.get('v.todaysdate');
            var tdayDtAry = tdayDt.split('/');
            tdayDt = tdayDtAry[2]+'/'+tdayDtAry[0]+'/'+tdayDtAry[1];
            var sltdStrtDt = component.get('v.selectedStrtDt');
            var sltdStrtDtAry = sltdStrtDt.split('/');//mm//dd//yyyy
            //yyy/mm//dd
            if(sltdStrtDtAry[0].indexOf('0') == -1 && sltdStrtDtAry[0] < 10){
                sltdStrtDtAry[0] = '0'+sltdStrtDtAry[0];
            }
            if(sltdStrtDtAry[1].indexOf('0') == -1 && sltdStrtDtAry[1] < 10){
                sltdStrtDtAry[1] = '0'+sltdStrtDtAry[1];
            }
            sltdStrtDt = sltdStrtDtAry[2]+'/'+sltdStrtDtAry[0]+'/'+sltdStrtDtAry[1];
            component.set('v.selectedBenefitStrtDt',sltdStrtDt);
            
            var sltdEndDt = component.get('v.selectedEndDt');
            var sltdEndDtAry = sltdEndDt.split('/');
            if(sltdEndDtAry[0].indexOf('0') == -1 && sltdEndDtAry[0] < 10){
                sltdEndDtAry[0] = '0'+sltdEndDtAry[0];
            }
            if(sltdEndDtAry[1].indexOf('0') == -1 && sltdEndDtAry[1] < 10){
                sltdEndDtAry[1] = '0'+sltdEndDtAry[1];
            }
              sltdEndDt = sltdEndDtAry[2]+'/'+sltdEndDtAry[0]+'/'+sltdEndDtAry[1];
            component.set('v.selectedBenefitEndDt',sltdEndDt);
            if(new Date(sltdEndDt) < new Date(tdayDt)){
                acumAsOfDt = sltdEndDt;
            }else if(new Date(sltdEndDt) >= new Date(tdayDt)){
                acumAsOfDt = tdayDt;
            }
            if(new Date(sltdStrtDt) > new Date(tdayDt)){
                acumAsOfDt = sltdStrtDt;
            }
             if(undefined != acumAsOfDt){
                 var slctdEndDtAry = acumAsOfDt.split('/');
                 var slctdDt = slctdEndDtAry[0]+'-'+slctdEndDtAry[1]+'-'+slctdEndDtAry[2];
                 acumAsOfDt = slctdDt;
            }
            //component.set('v.accumsdatesearch',acumAsOfDt);
            /*If  coverage end date < today's date then pick last date of coverage period
            If coverage end date >= today's date then pick todays date
            If coverage EffectiveDate> today's date then pick coverage start date
            */
            var groupNumber = covInfoBenefits.GroupNumber; 
            var coverageLevelCode=covInfoBenefits.CoverageLevelCode;

            if(coverageLevelCode!= null && coverageLevelCode!='' && coverageLevelCode != undefined){
                if(coverageLevelCode == 'IND' || coverageLevelCode == 'EMP')
                    coverageLevelCode = 'IND';
                else
                    coverageLevelCode ='FAM';
            }
            component.set("v.covLevelCode",coverageLevelCode);
            var action = component.get("c.getSearchAccumResults");
            var reqParams = {
                'surrogateKey': surrogateKey,
                'bundleId': bundleId,
                'enrollerSRK': enrollerSRK,
                'startDate': benstartDate,
                'endDate': benendDate,
                'coverageTypes': '',
                'groupNumber': groupNumber,
                'accumAsOf': accumsrch,
                'SitusState' : component.get('v.SitusState')
            };
            action.setParams(reqParams);
            action.setCallback(this, function(response) {
                helper.hideSpinner2(component,event,helper);
                var state = response.getState();
                if (state === "SUCCESS") {
                    var result = response.getReturnValue();
                    console.log(JSON.stringify(result));
                    if(!$A.util.isEmpty(result) && !$A.util.isUndefined(result)){
                       console.log(result.resultWrapper);
                       component.set('v.individualAccumList',result.resultIndividualAccumWrapper);
                       component.set('v.familyAccumList',result.resultFamilyAccumWrapper);
                    }
                    console.log(JSON.stringify(component.get('v.individualAccumList')));
                    console.log(JSON.stringify(component.get('v.familyAccumList'))); 
                    var tabKey = component.get("v.accumAutodocKey") + component.get("v.accumGUIkey");
                    //alert(component.get("v.accumAutodocKey"));
                    //alert(component.get("v.accumGUIkey"));
                            setTimeout(function() {
                            //alert(tabKey);
                             //alert("====");
                                window.lgtAutodoc.initAutodoc(tabKey);
                                //alert("==done?==");
                            }, 1);
    	    } else if (state === "ERROR") {
                    helper.hideSpinner2(component,event,helper);
   			}  
			 });
         $A.enqueueAction(action);
        }else{
            
        }
    },   
})