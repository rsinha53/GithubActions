({
	doInit : function(component, event, helper) {
        component.set("v.isLoading", true);
		//Page Reference
		var pageReference = component.get("v.pageReference");
		
        var cseTopic = pageReference.state.c__callTopic;
        var srk = pageReference.state.c__srk;
        var int = pageReference.state.c__interaction;
        var intId = pageReference.state.c__intId;
        var memId = pageReference.state.c__memberid;
        var grpNum = pageReference.state.c__gId;  
		
        //Added by Abhinav - Start
        var contractOptionId = pageReference.state.c__contractOptionId;
        var contractOptionEffDate = pageReference.state.c__contractOptionEffDate;
        var contractOptionStatus = pageReference.state.c__contractOptionStatus;
        var benEffDate,benEndDate;
        
        var bookOfBusinessTypeCode = '';
        if(component.get("v.pageReference").state.c__bookOfBusinessTypeCode != undefined){
            bookOfBusinessTypeCode = component.get("v.pageReference").state.c__bookOfBusinessTypeCode;
        }
        console.log('bookOfBusinessTypeCode',bookOfBusinessTypeCode);
        component.set('v.bookOfBusinessTypeCode',bookOfBusinessTypeCode);
        
        var covInfoBenefits = pageReference.state.c__covInfoBenefits;
        if(covInfoBenefits != undefined){
            benEffDate = (covInfoBenefits.BenEffectiveDate != null)?covInfoBenefits.BenEffectiveDate:'';
            benEndDate = (covInfoBenefits.BenEndDate != null)?covInfoBenefits.BenEndDate:'';
        }   
         var isMemberFlow = pageReference.state.c__isMemberFlow;
        console.log('>>> Contract toption attr' +contractOptionId+'//'+contractOptionEffDate+'//'+contractOptionStatus+'//'+benEffDate+'//'+benEndDate+'//'+isMemberFlow);
        
        component.set("v.AutodocKey", intId+memId+'GE');
        //String Highlight panel data
        var hghString = pageReference.state.c__hgltPanelDataString;
        component.set("v.hgltPanelDataString", hghString);
        
        var hpi = JSON.parse(hghString);

        component.set("v.cseTopic", cseTopic);
        component.set("v.srk", srk);
        component.set("v.int", int);
        component.set("v.intId", intId);
        component.set("v.memId", memId);
        component.set("v.grpNum", grpNum);
		component.set("v.highlightPanel", hpi);
		component.set("v.contractOptionEffDate", contractOptionEffDate);
        component.set("v.contractOptionStatus", contractOptionStatus);
		component.set("v.contractOptionId", contractOptionId);
        component.set("v.benEffDate", benEffDate);
        component.set("v.benEndDate", benEndDate);
		component.set("v.isMemberFlow", isMemberFlow);
        var intId = component.get("v.intId");

        if(intId != undefined) {
            var childCmp = component.find("cComp");
            var memID = component.get("v.memId");
            var GrpNum = component.get("v.grpNum");
			var bundleId = hpi.benefitBundleOptionId;
            childCmp.childMethodForAlerts(intId,memID,GrpNum,'',bundleId);
        }
        
        helper.getEligibilities(component, event, helper);
        component.set("v.isLoading", false);
	},
    
    getUpdatedRules : function(component, event, helper) {
        component.set("v.isLoading", true);
        var AutodocKey = component.get("v.AutodocKey");
        setTimeout(function(){
         //alert('---1--'+ 'Coverage line change');
            window.lgtAutodoc.saveAutodocSelections(AutodocKey);
            window.lgtAutodoc.clearAutodocSelections(AutodocKey);
            var memId = component.get("v.memId");
            var dateSelected = document.getElementById(memId + 'insuringDates');
            var populationSelected = document.getElementById(memId + 'population');
            
            component.set("v.dateSelected", dateSelected.value);
            component.set("v.populationSelected", populationSelected.value);
            
            helper.getInsuringRules(component);
            component.set("v.isLoading", false);
        }, 1);
        
    }
    
})