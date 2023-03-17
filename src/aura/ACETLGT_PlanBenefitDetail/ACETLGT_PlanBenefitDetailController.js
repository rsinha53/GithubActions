({
 doinit : function(component, event, helper) {    
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
        component.set("v.GUIkey",GUIkey);
       if (component.get("v.pageReference") != null) {
      var pagerefarance = component.get("v.pageReference");
      var autodocKey = component.get("v.pageReference").state.c__AutodocKey;
      component.set('v.AutodocKey',autodocKey);
       var memid = component.get("v.pageReference").state.c__memberId;
       var srk = component.get("v.pageReference").state.c__srk;
       var intId = component.get("v.pageReference").state.c__intId;
       var groupId = component.get("v.pageReference").state.c__gId;
       var hData = component.get("v.pageReference").state.c__hgltPanelData;
       var planId = component.get("v.pageReference").state.c__planId;
       var productId = component.get("v.pageReference").state.c__productId;
       var planTypeCode = component.get("v.pageReference").state.c__planTypeCode;
       var timePeriodQualifier = component.get("v.pageReference").state.c__timePeriodQualifier;
       var administeredByName = component.get("v.pageReference").state.c__administeredByName;
       var networkScheduleList = component.get("v.pageReference").state.c__networkScheduleList;
       var coverageBenefits = component.get("v.pageReference").state.c__coverageBenefits;
       var legalSubsidiary = component.get("v.pageReference").state.c__legalSubsidiary;
       var planMetallicLevel = component.get("v.pageReference").state.c__planMetallicLevel;
       var fundingArrangement = component.get("v.pageReference").state.c__fundingArrangement;
       var hsaPlan = component.get("v.pageReference").state.c__hsaPlan;
       var memberPlanBenefitList = component.get("v.pageReference").state.c__memberPlanBenefitList;
       var OONReimbursementList = component.get("v.pageReference").state.c__OONReimbursementList;
       var pcpRequiredIndicator = component.get("v.pageReference").state.c__pcpRequiredIndicator;
       var gatedProductIndicator = component.get("v.pageReference").state.c__gatedProductIndicator;
       var eHBIndicator = component.get("v.pageReference").state.c__eHBIndicator;
       var benefitCodeKeyMap = component.get("v.pageReference").state.c__benefitCodeKeyMap;
       var varriableCoverageMap = component.get("v.pageReference").state.c__varriableCoverageMap;
       var benefitValues = component.get("v.pageReference").state.c__benefitDisplayMap;
       var tierTypeCodeList = component.get("v.pageReference").state.c__tierTypeCodeList;
       var tierTypeIdentifierList = component.get("v.pageReference").state.c__tierTypeIdentifierList;
              var existsOnRiderPlanMap = component.get("v.pageReference").state.c__existsOnRiderPlanMap;
		var selectedEftvDt = component.get("v.pageReference").state.c__selectedStrtDt;
           var selectedExpiryDt = component.get("v.pageReference").state.c__selectedEndDt;
           var selectedBenefirBOId = component.get("v.pageReference").state.c__selectedBundleId;
		          var bookOfBusinessTypeCode = component.get("v.pageReference").state.c__bookOfBusinessTypeCode; //US3582935 : Added By Manish
           component.set('v.selectedStrtDt',selectedEftvDt);
           component.set('v.selectedEndDt',selectedExpiryDt);
           component.set('v.selectedBundleId',selectedBenefirBOId);   
       component.set('v.grpNum', groupId);
       component.set('v.intId', intId);
       //component.set('v.memberid', memid);
       component.set('v.srk', srk);
       console.log('hData :: ' + hData);
       console.log('hData 2:: ' + JSON.stringify(hData));
       var hghString = pagerefarance.state.c__hgltPanelDataString;
       component.set("v.highlightPanelstring", hghString);
       hData = JSON.parse(hghString);
       component.set('v.memberid', hData.MemberId);
       component.set("v.highlightPanel", hData);
       component.set("v.planId", planId);
       component.set("v.bbundleId", hData.benefitBundleOptionId);    
       component.set("v.productId", productId);
       component.set("v.planTypeCode", planTypeCode);
       component.set("v.timePeriodQualifier", timePeriodQualifier);
       component.set("v.administeredByName", administeredByName);
       component.set("v.coverageBenefits",coverageBenefits);
       component.set('v.legalSubsidiary',legalSubsidiary);
       component.set('v.planMetallicLevel',planMetallicLevel);
       component.set('v.fundingArrangement',fundingArrangement);
       component.set('v.hsaPlan',hsaPlan);
       var SitusState = component.get("v.pageReference").state.c__SitusState;
       component.set('v.SitusState',SitusState);
       component.set('v.pcpRequiredIndicator',pcpRequiredIndicator);
       component.set('v.gatedProductIndicator',gatedProductIndicator);
       var eHBIndicatorVal;
       if(eHBIndicator == "true") {
           eHBIndicatorVal = "Y";
       }else if(eHBIndicator == "false") {
           eHBIndicatorVal = "N";
       }
       component.set('v.eHBIndicator',eHBIndicatorVal);
       var benefitList = [];
       var benefitWrapperList = [];
       benefitWrapperList = memberPlanBenefitList;
       for(var key in benefitWrapperList) {
           benefitList.push(benefitWrapperList[key]);  
       }
       var networkList = [];
       var networkWrapperList = [];
       networkWrapperList = networkScheduleList;
       for(var key in networkWrapperList) {
           networkList.push(networkWrapperList[key]);  
       }
       var OONList = [];
       var OONReimbursementWrapperList = [];
       OONReimbursementWrapperList = OONReimbursementList;
       for(var key in OONReimbursementWrapperList) {
           OONList.push(OONReimbursementWrapperList[key]);   
       }
       var benefitCodes = [];
       for (var key in benefitCodeKeyMap ) {
            benefitCodes.push({"label":key,"value":benefitCodeKeyMap[key]});
       }
       var variableCoverage = [];
       for (var key in varriableCoverageMap ) {
            variableCoverage.push({"key":key,"value":varriableCoverageMap[key]});
       } 
       //alert(JSON.stringify(variableCoverage));
       component.set('v.benefitCodeKeyMap',benefitCodes);
       component.set('v.memberPlanBenefitList',benefitList);
       component.set("v.networkScheduleList", networkList);
       component.set('v.OONReimbursementList',OONList);
       component.set('v.varriableCoverageMap',variableCoverage);
       component.set('v.benefitDisplayMap',benefitValues);
       component.set('v.tierTypeCodeList',tierTypeCodeList);
       component.set('v.tierTypeIdentifierList', tierTypeIdentifierList);
       component.set('v.existsOnRiderPlanMap',existsOnRiderPlanMap);   
       component.set("v.pagerefaranceobj",pagerefarance);
	   component.set("v.bookOfBusinessTypeCode" , bookOfBusinessTypeCode); //US3582935 : Added By Manish
       //US3582935 : Added By Manish
       if(bookOfBusinessTypeCode != 'OX' && bookOfBusinessTypeCode != 'LF' && bookOfBusinessTypeCode != 'OL')
       {
           component.set('v.showCirrusBenefit', false);
       }
      } 
       var accumComponent = component.find("AccumSection");
       console.log('accumComponent');
       accumComponent.showResults(component,event,helper); 
        if(component.get("v.showCirrusBenefit")){ //US3582935 : Added By Manish
       var benefitComponent = component.find("BenefitSection");
       console.log('benefitComponent');
        
       benefitComponent.showBenefits(component,event,helper); 
       benefitComponent.showBenefitCodeKeyMap(benefitCodes);
       benefitComponent.showBenefitRadioGroup(memid);
      }else{
                 
            
       //
       var benefitComponentB360 = component.find("B360BenefitSection");
       console.log('benefitComponent');
        
       benefitComponentB360.showBenefits(component,event,helper); 
       benefitComponentB360.showBenefitCodeKeyMap(benefitCodes);
        }
      if (intId != undefined) {
       var childCmp = component.find("cComp");
       var memID = hData.MemberId;
       var GrpNum =component.get("v.pageReference").state.c__gId;
       var bundleId = hData.benefitBundleOptionId;
       childCmp.childMethodForAlerts(intId, memID, GrpNum, '', bundleId);
      }
    
      
 }
})