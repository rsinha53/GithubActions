({
	doInit : function(component, event, helper) {
       if (component.get("v.pageReference") != null) {
       var pagerefarance = component.get("v.pageReference");
       var memid = component.get("v.pageReference").state.c__memberid;
       var srk = component.get("v.pageReference").state.c__srk;
       var callTopic = component.get("v.pageReference").state.c__callTopic;
       var interaction = component.get("v.pageReference").state.c__interaction;
       var intId = component.get("v.pageReference").state.c__intId;
       var groupId = component.get("v.pageReference").state.c__gId;
       var uInfo = component.get("v.pageReference").state.c__userInfo;
       var hData = component.get("v.pageReference").state.c__hgltPanelData;
       var fundingArrangement = component.get("v.pageReference").state.c__fundingArrangement;
       var hsaPlan = component.get("v.pageReference").state.c__hsaPlan;
       var cpid = component.get("v.pageReference").state.c__CPID;
      var COStartDate = component.get("v.pageReference").state.c__COStartDate;
       var COEndDate = component.get("v.pageReference").state.c__COEndDate;
		var planDatesList = component.get("v.pageReference").state.c__planDatesList;
       var planDts = Object.values(planDatesList);
        var selectedPlnDt = COStartDate+'-'+COEndDate;
           component.set('v.selectedPlnDt',selectedPlnDt);
           planDts.forEach(function(pl){
              if(pl.contractOptionStartDate == COStartDate &&
                 pl.contractOptionEndDate == COEndDate){
                  pl.selected = true;
              } 
           });
        component.set('v.planDatesList',planDts); 																		   
       if(!$A.util.isUndefinedOrNull(COStartDate)){
       component.set("v.COStartDate", COStartDate);
        } 
       if(!$A.util.isUndefinedOrNull(COEndDate)){
       component.set("v.COEndDate", COEndDate);
        }  
       component.set('v.cpid', cpid);
       component.set('v.grpNum', groupId);
       component.set('v.int', interaction);
       component.set('v.intId', intId);
       component.set('v.memberid', memid);
       component.set('v.srk', srk);
       component.set("v.usInfo", uInfo);
       console.log('hData :: ' + hData);
       console.log('hData 2:: ' + JSON.stringify(hData));
       var hghString = pagerefarance.state.c__hgltPanelDataString;  
       console.log(hghString);
       hData = JSON.parse(hghString);
       component.set("v.highlightPanel", hData);
           
       var bookOfBusinessTypeCode = '';
       if(component.get("v.pageReference").state.c__bookOfBusinessTypeCode != undefined){
           bookOfBusinessTypeCode = component.get("v.pageReference").state.c__bookOfBusinessTypeCode;
       }
       console.log('bookOfBusinessTypeCode',bookOfBusinessTypeCode);
       component.set('v.bookOfBusinessTypeCode',bookOfBusinessTypeCode);
           
       var len = 20;
        var buf = [],
            chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789',
            charlen = chars.length,
            length = len || 32;
            
        for (var i = 0; i < length; i++) {
            buf[i] = chars.charAt(Math.floor(Math.random() * charlen));
        }
        var GUIkey = buf.join('');
        //helper.createGUID();
		component.set("v.AutodocKey",GUIkey+'planBenefits');
       var coverageInfoBenefits = component.get("v.pageReference").state.c__coverageInfoBenefits;
       component.set('v.coverageData',coverageInfoBenefits);
       var exchangeType = component.get("v.pageReference").state.c__exchangeType;
       component.set('v.exchangeType',exchangeType);
       var SitusState = component.get("v.pageReference").state.c__SitusState;
       component.set('v.SitusState',SitusState);
       component.set('v.fundingArrangement',fundingArrangement);
       component.set('v.hsaPlan',hsaPlan);
       component.set("v.pagerefaranceobj",pagerefarance);
        }
      console.log(component.get('v.coverageData'));
      if (intId != undefined) {
       var childCmp = component.find("cComp");
       var memID = component.get("v.memberid");
       var GrpNum = component.get("v.grpNum");
       var bundleId = hData.benefitBundleOptionId;
       childCmp.childMethodForAlerts(intId, memID, GrpNum, '', bundleId);
  }
        if(!$A.util.isEmpty(memid) && !$A.util.isUndefined(memid)) {
            helper.getCoverageInfoBenefits(component,event,helper);
        }		
        else{
            component.set("v.Spinner",false);
        }
},

    navPlanBenefitDetail : function(component,event,helper) {
      var planId = event.currentTarget.getAttribute("data-planId");
      var productId = event.currentTarget.getAttribute("data-productId");
      var productId = event.currentTarget.getAttribute("data-gatedProductIndicator");
      var planTypeCode = event.currentTarget.getAttribute("data-planTypeCode");
      var timePeriodQualifier = event.currentTarget.getAttribute("data-timePeriodQualifier");
      var administeredByName =  event.currentTarget.getAttribute("data-administeredByName");
      var pcpRequiredIndicator = event.currentTarget.getAttribute("data-pcpRequiredIndicator");
      var legalSubsidiary = event.currentTarget.getAttribute("data-legalSubsidiary");
      var planMetallicLevel = event.currentTarget.getAttribute("data-planMetallicLevel");
      var gatedProductIndicator = event.currentTarget.getAttribute("data-gatedProductIndicator");
        var effctDtSlctd = event.currentTarget.getAttribute("data-effctDt");
      var expiryDtSlctd = event.currentTarget.getAttribute("data-expiryDt");
        var benefitBOId = '';
        var effctDt = '';
        var expiryDt = '';
        var  planDatesList = component.get('v.planDatesList');
		var selectedPlnObj = component.get('v.selectedPlanObj');
        benefitBOId = selectedPlnObj.benefitBundleOptionId;
                effctDt =   selectedPlnObj.contractOptionStartDate;
                expiryDt =  selectedPlnObj.contractOptionEndDate ;
           
      
      helper.navigatePlanBenefitDetail(component,event,helper,planId,productId,planTypeCode,timePeriodQualifier,administeredByName,pcpRequiredIndicator,gatedProductIndicator,legalSubsidiary,planMetallicLevel,effctDt,expiryDt,benefitBOId);
    },
	updatePlanInfo : function(component,event,helper) {
        
        var planDtSlctd = component.find("planDtsSelect").get("v.value");
        if(planDtSlctd != undefined && planDtSlctd != ''){
            var planDtSlctdAry = planDtSlctd.split('-');
            var slctdStrtDt = planDtSlctdAry[0];
            var slctdEndDt = planDtSlctdAry[1];
            var plnDts = component.get('v.planDatesList');
            var coStrtDt = '';
            var coEndDt = '';
            var benefitBOId = '';
            var purchaseId = '';
            plnDts.forEach(function(pl){
                if(pl.contractOptionStartDate == slctdStrtDt && pl.contractOptionEndDate == slctdEndDt){
                    coStrtDt = pl.contractOptionStartDate;
                    coEndDt = pl.contractOptionEndDate;
                    benefitBOId = pl.benefitBundleOptionId;
                    purchaseId = pl.customerPurchaseId;
                } 
            });
			var selectedPlnObj = {};
            
            selectedPlnObj.benefitBundleOptionId = benefitBOId;
                  selectedPlnObj.contractOptionStartDate = coStrtDt;
                 selectedPlnObj.contractOptionEndDate = coEndDt;
            component.set('v.selectedPlanObj',selectedPlnObj);
            
            
        helper.updatetCoverageInfoBenefits(component,event,helper,coStrtDt,coEndDt,benefitBOId,purchaseId);
        }
    }
})