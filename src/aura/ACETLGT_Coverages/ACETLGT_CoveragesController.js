({
    doIInit : function(component, event, helper) {
        
        
    },
    handleOnclick: function (cmp, event, helper) {
        
        console.log("SSS Intial Load");
        var htmlrec = event.currentTarget.getAttribute("data-Index") ;
        var htmlcmp = event.currentTarget;
        var customerPurchaseId = htmlcmp.getAttribute("data-customerPurchaseId");
        var planOptionId = htmlcmp.getAttribute("data-planOptiId");
        var origType = cmp.get("v.origType");
        console.log('--------- plan option'+planOptionId);
        
        //alert("htmlrec" + htmlrec);
        var spinnerEvent = cmp.getEvent("startSpinnerEvent");
        spinnerEvent.setParams({
                                "GUID" : htmlrec,
                                                                               "EffectiveDate" : htmlcmp.getAttribute("data-covEffDate")
                                });
        spinnerEvent.fire();
        
        console.log ('First load of coverages');
        var AutodocKey = cmp.get("v.AutodocKey");
        setTimeout(function(){
         //alert('---1--'+ 'Coverage line change');
            window.lgtAutodoc.saveAutodocSelections(AutodocKey);
            window.lgtAutodoc.clearAutodocSelections(AutodocKey);
        }, 1);
        
        
        var htmlrec = event.currentTarget.getAttribute("data-Index") ;
        //var guid = event.currentTarget.getAttribute("data-Index") ;
        console.log('----1--'+htmlrec);
        
        console.log('----2--'+htmlcmp);
        var cmpTarget = document.getElementsByClassName("activecol");  
        //console.log('----2--'+cmpTarget.length);
        var covGroup = htmlcmp.getAttribute("data-covGroup");
        var covEffectiveDate = htmlcmp.getAttribute("data-covEffDate");
        var covEndDate = htmlcmp.getAttribute("data-covEndDate");
        var covBenEffectiveDate = htmlcmp.getAttribute("data-covBenEffDate");
        var covBenEndDate = htmlcmp.getAttribute("data-covBenEndDate");
        var benefitPlanId = htmlcmp.getAttribute("data-benefitPlanId");
        var planOptionId = htmlcmp.getAttribute("data-planOptiId");
        var covSrk = htmlcmp.getAttribute("data-srk");
        var customerPurchaseId = htmlcmp.getAttribute("data-customerPurchaseId");
        //localStorage.setItem(memberId+'_surrogateKey', covSrk);
        var enSrk = htmlcmp.getAttribute("data-ensrk");
        var isActive = htmlcmp.getAttribute("data-isActive");
        var isTermed = htmlcmp.getAttribute("data-isTermed");
        var memberId = htmlcmp.getAttribute("data-memid");
        var Index  = htmlcmp.getAttribute("data-Index");
 
        console.log('??? plan option'+planOptionId);
        console.log('end date--->'+covEndDate);
        console.log('@@@cov Ben dates--->'+covBenEffectiveDate+'//'+covBenEndDate);
        console.log('coverageGroup--->'+covGroup);
        console.log('benefitPlanId--->'+benefitPlanId);
        cmp.set("v.covGroupNumber",covGroup);
        cmp.set("v.covEffectiveDate",covEffectiveDate);
        //var covLine = htmlcmp.getAttribute("data-covLine");
        var origType = cmp.get("v.origType");
        console.log('~~~origType'+origType);
        
        //alert("test "+htmlrec)
        
        var allCoverages = cmp.get("v.mydata");
        //var i;
        var covline;
        console.log('htmlrec=====>>'+htmlrec);
        if(allCoverages != undefined){
        for (var i = 0; i < allCoverages.length; i++) {
               //alert('----'+i+'--'+allCoverages[i].GUID);                   
            if(allCoverages[i].GUID == htmlrec){
                //alert('--P--'+i+'--'+allCoverages[i].GUID + "--" + htmlrec);
                
                //alert('--P--'+i+'--'+allCoverages[i].GUID);
                covline = allCoverages[i];
            }
                
        }
        }
        
        var tableData = htmlcmp.parentElement.parentElement.getElementsByClassName('activecol');
        if(tableData != undefined){
        for(var i = 0; i < tableData.length; i++){
            $A.util.removeClass(tableData[i], 'activecol');
        }
        }
        console.log('----12--'+htmlcmp);
        $A.util.addClass(htmlcmp, 'activecol');
        console.log('----13--'+memberId);
	//US3584878 Start
        cmp.set("v.customerPurchaseId", covline.customerPurchaseId);
        cmp.set('v.bookOfBusinessTypeCode', '');
        cmp.set('v.bookOfBusinessTypeDesc', '');
	//US3584878 End
        helper.showfamilyMemberships(cmp, helper,covSrk, enSrk,covGroup,covEffectiveDate,covEndDate,benefitPlanId,origType,isActive,isTermed,covline.memberId,covBenEffectiveDate,covBenEndDate,planOptionId,covline.customerPurchaseId,covline.LatestCOStartDate,covline.LatestCOEndDate,covline.Product);
           
    },
    selectChange : function(component, event, helper) {
        console.log('when different coverage is chosen 2');
        // first get the div element. by using aura:id
        
        component.set("v.isToggled", !component.get("v.isToggled"));
        if(component.get("v.isToggled")){
            var cov = component.get("v.covdata");
            for(var i=0;i<= 100;i++){
                if(cov[i] != undefined && cov[i] != null && cov[i] != '' ){
                    
                    if(cov[i].isPreferred && cov[i].isActive){
                        var prefcov = cov[i];
                    } 
            }
            }
        }
       if(!$A.util.isUndefinedOrNull(prefcov)){
           setTimeout(function(){ 
        	var covRecs = component.get("v.mydata");
            if(covRecs.length > 0){
              
                for(var i=0; i < covRecs.length; i++){
                    if(!covRecs[i].isActive && covRecs[i].isPreferred){
                        component.set("v.isToggled", "false");
                    }
                    if(covRecs[i].isActive){
                        component.set("v.isInactiveOnly", "false");
                    }
                }
            }
        }, 500);
		
		
        var  originatorType= component.get("v.originatorType");
        component.set("v.origType", originatorType);
        
        var cov = component.get("v.covdata");
        var coverages = [];
        var i = 0,grpNum,effDate,endDate,beneffDate,benendDate,srk,Esrk,covLine,benefitPlanId,bundleId,isActive,isTermed,memberId,planOptionId,customerPurchaseId,LatestCOStartDate,LatestCOEndDate,Product;
        covLine='';
        var showAllCovs = false;
        console.log('=====>>'+ cov);
        for(i=0;i<= 100;i++){
            if(cov[i] != undefined && cov[i] != null && cov[i] != '' ){
                
                if(cov[i].isActive && cov[i].isPreferred){
                   showAllCovs = true; 
                }
                if(cov[i].isPreferred){
                    grpNum = cov[i].GroupNumber;
                    effDate = cov[i].EffectiveDate; 
                    endDate = cov[i].EndDate; 
                    beneffDate = cov[i].BenEffectiveDate; 
                    benendDate = cov[i].BenEndDate; 
                    planOptionId = cov[i].planOptionID;
                    srk = cov[i].SurrogateKey;
                    Esrk = cov[i].EnrolleeSurrogateKey;
                    benefitPlanId = cov[i].BenefitPlanId;
                    isActive = cov[i].isActive;
                    isTermed = cov[i].isTermed;
                    memberId = cov[i].memberId;
                    customerPurchaseId= cov[i].customerPurchaseId;
                    LatestCOStartDate =  cov[i].LatestCOStartDate;
                    LatestCOEndDate = cov[i].LatestCOEndDate;
                    Product = cov[i].Product;
                    
                    covLine = cov[i];
                                    }
                coverages.push(cov[i]);
            }
        }
		 component.set("v.mydata", coverages);
       	 //US3584878 Start
         component.set("v.customerPurchaseId", customerPurchaseId);
         component.set('v.bookOfBusinessTypeCode', '');
         component.set('v.bookOfBusinessTypeDesc', '');
	 //US3584878 End
		         helper.showfamilyMemberships(component, helper,srk,Esrk,grpNum,effDate,endDate,benefitPlanId,originatorType,isActive,isTermed,memberId,beneffDate,benendDate,planOptionId,customerPurchaseId,LatestCOStartDate,LatestCOEndDate,Product);

        }

    },
    handleDestroy : function(component,helper){
        var memId = component.get('v.memId');
        localStroage.removeItem(memId+'_memDOB');
        localStroage.removeItem(memId+'_memPolicyId');
        localStroage.removeItem(memId+'_memFirstName');
        localStroage.removeItem(memId+'_memLastName');
        localStorage.removeItem(memId+'_effectiveDate');
        //localStorage.removeItem(memId+'_surrogateKey');
    }
})