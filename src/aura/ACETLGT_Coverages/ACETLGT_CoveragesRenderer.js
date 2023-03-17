({
    afterRender : function(cmp, helper) {
        setTimeout(function(){ 
        	var covRecs = cmp.get("v.mydata");
            
            if(covRecs.length > 0){
                //alert("-00--");
                for(var i=0; i < covRecs.length; i++){
                    //alert("-0--");
                    if(!covRecs[i].isActive && covRecs[i].isPreferred){
                        //alert("---");
                        cmp.set("v.isToggled", "false");
                    }
                    if(covRecs[i].isActive){
                        cmp.set("v.isInactiveOnly", "false");
                    }
                }
            }
        }, 500);
        
        var  originatorType= cmp.get("v.originatorType");
        console.log('~~~onloadoriginatorType'+originatorType);
        cmp.set("v.origType", originatorType);
        
        
        var cov = cmp.get("v.covdata");
        console.log('~~~~77~~~~'+cov);
        //cov = cov[0];
        
        var coverages = [];
        var i = 0,grpNum,effDate,endDate,beneffDate,benendDate,srk,Esrk,covLine,benefitPlanId,bundleId,isActive,isTermed,memberId,planOptionId;
        covLine='';
        var showAllCovs = false;
        var customerPurchaseId = '';//US3584878
        console.log('=====>>'+ cov);
        for(i=0;i<= 100;i++){
            if(cov[i] != undefined && cov[i] != null && cov[i] != '' ){
                console.log('>>>===>>'+cov[i]+'>>>'+cov[i].isPreferred+'>>>'+cov[i].GroupNumber+'>>>'+cov[i].EffectiveDate+'>>>'+cov[i].BenefitPlanId+'>>>'+cov[i].isActive);
                console.log('@@@ covBenefit dates'+cov[i].BenEffectiveDate+'//'+cov[i].BenEndDate+'//'+cov[i].LatestCOStartDate+'//'+cov[i].LatestCOEndDate+'??'+cov[i].planOptionID);
                if(cov[i].isActive && cov[i].isPreferred){
                   showAllCovs = true; 
                }
                if(cov[i].isPreferred){
                    //cmp.set("v.covGroupNumber",cov[i].GroupNumber);
                    //cmp.set("v.covEffectiveDate",cov[i].EffectiveDate);
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
                    customerPurchaseId = cov[i].customerPurchaseId;//US3584878
                    //bundleId = cov[i].BenefitBundleOptionId;
                    covLine = cov[i]; 
                }
                coverages.push(cov[i]);
            }
        }
        if(!showAllCovs){
           //var covs = document.getElementsByClassName("customautoclick");
           var covs = cmp.find("togglebutton").getElement();
           //component.set("v.isToggled", "false");
           //alert('-----2----'+covs);
           
           covs.click();
           //component.set("v.isToggled", "false");
        }
        console.log('>>>>>Cov onload'+grpNum+effDate+srk+'///'+JSON.stringify(covLine));
        
        cmp.set("v.mycolumns", [
            {label: "Active", fieldName: "isActive", type: "text"},
            {label: "Coverage Type", fieldName: "CoverageType", type: "text"},
            {label: "Group Number", fieldName: "GroupNumber", type: "text"},
            {label: "Group Name", fieldName: "GroupName", type: "text"},
            {label: "Product", fieldName: "Product", type: "text"},
            {label: "Effective date", fieldName: "EffectiveDate", type: "date"},
            {label: "End Date", fieldName: "EndDate", type: "date"},
            {label: "Source Code", fieldName: "SourceCode", type: "text"},
            {label: "Onshore Restriction", fieldName: "OnshoreRestriction", type: "text"}
            
        ]);
        cmp.set("v.mydata", coverages);
        console.log('----13--'+memberId);
	//US3584878 Start
        cmp.set('v.customerPurchaseId',customerPurchaseId);
        cmp.set('v.bookOfBusinessTypeCode', '');
        cmp.set('v.bookOfBusinessTypeDesc', '');
	//US3584878 End
        //New Code 
        helper.showfamilyMemberships(cmp, helper,srk,Esrk,grpNum,effDate,endDate,benefitPlanId,originatorType,isActive,isTermed,memberId,beneffDate,benendDate,planOptionId);
        //helper.showGroupDetails(cmp, helper,grpNum,effDate,endDate,benefitPlanId,bundleId);
        
    },
    rerender : function(component, helper){
        this.superRerender();
        // custom rerendering logic here
        
    }
})