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
        debugger;
    	if (component.get("v.pageReference") != null) {
            var state = component.get("v.pageReference").state;
            component.set("v.AutodocKey",state.c__AutodocKey);
            component.set("v.Ismnf",state.c__Ismnf);
           // alert(state.c__Ismnf);
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
            component.set('v.tiered', state.c__tiered);
            var tiered = component.get("v.tiered");
            component.set('v.gender', state.c__gender);
            var gender = component.get("v.gender");
            component.set('v.uphd', state.c__uphd);
            var uphd = component.get("v.uphd");
            component.set('v.Platinum', state.c__Platinum);
            var Platinum = component.get("v.Platinum");
            component.set('v.radious', state.c__radious);
            var radious = component.get("v.radious");
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
            var intId = state.c__intId;
            component.set("v.intId",intId);
            component.set("v.grpNum",groupNumber);
            component.set("v.srk",srk);
            var hData = state.c__hgltPanelData;
            var hghString = state.c__hgltPanelDataString;
            hData = JSON.parse(hghString);
            component.set("v.highlightPanel",hData);
            component.set("v.highlightPanelstring", hghString);
			 var ddpType = state.c__ddpType;
            if(null != ddpType && undefined != ddpType){
            component.set('v.ddpType',ddpType);
            }
            var returningFrom = 'providerLookup';
        //adding bbid untill we get fighlets pannel 
            //var BenefitPlanID ='M000000144';            
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
    }
})