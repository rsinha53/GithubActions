({
	doInit : function(component, event, helper) {
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
            debugger;
            var state = component.get("v.pageReference").state;
            var Ismnf = state.c__Ismnf;
            var fName = state.c__fName;
            var lName = state.c__lName;
            var mName = state.c__mName;
            var tiered = state.c__qualityBenefitTier;
            var memGender = state.c__memGender;
            var suffixName = state.c__suffixName;
            var NetworkId = state.c__NetworkId;
            var isTieredProvider = state.c__isTieredProvider;
            var qualityProviderRuleId = state.c__qualityProviderRuleId;
            var ssn;
            if (state.c__SSN != undefined) {
                ssn = state.c__SSN;    
            }   
            component.set('v.Ismnf',Ismnf);
    		    component.set('v.fName',fName);
            component.set('v.lName', lName);
            component.set('v.mName', mName);
            component.set('v.memGender', memGender);
            component.set('v.qualityBenefitTier', tiered);
            component.set('v.suffixName', suffixName);
            component.set('v.ssn', ssn);
            component.set('v.AutodocKey',state.c__AutodocKey);
            component.set('v.providerId', state.c__providerId);
            var providerId = component.get("v.providerId");
            console.log('provider ' +providerId);
            component.set('v.providerType', state.c__providerType);
            var providerType = component.get("v.providerType");
            component.set('v.taxId', state.c__taxId);
            var taxId = component.get("v.taxId"); 
            component.set('v.address', state.c__address);
            var address = component.get("v.address");
            component.set('v.phoneNumber', state.c__phoneNumber);
            var phoneNumber = component.get("v.phoneNumber");
            component.set('v.speciality', state.c__speciality);
            var speciality = component.get("v.speciality");
            component.set('v.PCPRole', state.c__PCPRole);
            var PCPRole = component.get("v.PCPRole");
            component.set('v.pcpObgnID', state.c__pcpObgnID);
            var pcpObgnID = component.get("v.pcpObgnID");
            component.set('v.gender', state.c__gender);
            var gender = component.get("v.gender");
            component.set('v.uphd', state.c__uphd);
            var uphd = component.get("v.uphd");
            component.set('v.Platinum', state.c__Platinum);
            var Platinum = component.get("v.Platinum");
            component.set('v.radious', state.c__radious);
            var radious = component.get("v.radious");
            component.set('v.providerLocationAffiliationsStatusCode', state.c__providerLocationAffiliationsStatusCode);
            var providerLocationAffiliationsStatusCode = component.get("v.providerLocationAffiliationsStatusCode");
            component.set('v.addressId', state.c__addressId);
            var addressId = component.get("v.addressId");
            component.set('v.addressTypeCode', state.c__addressTypeCode);
            var addressTypeCode = component.get("v.addressTypeCode");
            component.set('v.providerTINTypeCode', state.c__providerTINTypeCode);
            var providerTINTypeCode = component.get("v.providerTINTypeCode");
            component.set('v.memberId', state.c__memberId);
            component.set('v.fullName', state.c__fullName);
            var fullName = component.get("v.fullName");
            var groupNumber = state.c__gId;
            var srk = state.c__srk;
            var subSrk = state.c__subSrk;
            component.set("v.subSrk",subSrk);
            var network = state.c__network;
            component.set("v.network",network);
            var intId = state.c__intId;
            component.set("v.intId",intId);
            component.set("v.grpNum",groupNumber);
            component.set("v.srk",srk);
            component.set("v.networkId", NetworkId);
            component.set("v.isTieredProvider", isTieredProvider);
            component.set("v.qualityProviderRuleId", qualityProviderRuleId);
            var hData = state.c__hgltPanelData;
            var hghString = state.c__hgltPanelDataString;
            hData = JSON.parse(hghString);
            component.set("v.highlightPanel", hData);
            component.set("v.highlightPanelstring", hghString);
            var returningFrom = 'providerLookup';
            helper.getProviderLookupDetail(component,event,helper,providerId,taxId,providerTINTypeCode,addressId,addressTypeCode,returningFrom); 
            var contractComponent = component.find("contractsSection");
            console.log('contractComponent');
            contractComponent.showResults(component,event,helper); 
            if (intId != undefined) {
                var childCmp = component.find("cComp");
                var memID = component.get("v.memberId");
                var GrpNum = component.get("v.grpNum");
                var bundleId = hData.benefitBundleOptionId;
                childCmp.childMethodForAlerts(intId, memID, GrpNum, '',bundleId);
        	}
            var tabKey = component.get("v.AutodocKey")+component.get("v.GUIkey");
       
            setTimeout(function(){
                //alert("====");
                window.lgtAutodoc.initAutodoc(tabKey);
            },1); 
            
        }


    },
    handleProviderPanelClose : function(component, event, helper) {
        var isProviderPanelClosed = event.getParam("isProviderPanelClosed");
        component.set("v.isProviderPanelClosed", isProviderPanelClosed);
    }
    
})