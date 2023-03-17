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
            var state = component.get("v.pageReference").state;
            component.set('v.AutodocKey', state.c__AutodocKey );
            console.log('===========>'+Object.getOwnPropertyNames(component.get('v.pageReference').state));
            var memid = component.get("v.pageReference").state.c__memberId;
            var groupId = component.get("v.pageReference").state.c__grpNum;
            var intId = component.get("v.pageReference").state.c__intId;
            var Ismnf= component.get("v.pageReference").state.c__Ismnf;
            component.set("v.Ismnf",Ismnf);
            var rowData = JSON.parse(state.c__rowData);
            var providerinfoObj = JSON.parse(state.c__providerinfoObj);
            var hghString = state.c__highlightPanel;
            var hData = JSON.parse(hghString);
            component.set("v.highlightPanel", hData);
            component.set('v.contractrowdata', rowData);
            component.set('v.providerdata', providerinfoObj);
            component.set('v.grpNum', groupId);
            component.set('v.memberId', memid);
            component.set('v.intId', intId);
            helper.getProvAgreementWebservice(component,event,helper,rowData,providerinfoObj);
        }
        console.log('======>intId'+intId);
        console.log('======>memid'+memid);
        console.log('======>groupId'+groupId);
        console.log('======>hData.benefitBundleOptionId'+hData.benefitBundleOptionId);
        if (intId != undefined) {
            var childCmp = component.find("cComp");
            var memID = component.get("v.memberId");
            var GrpNum = component.get("v.grpNum");
            var bundleId = hData.benefitBundleOptionId;
            childCmp.childMethodForAlerts(intId, memID, GrpNum, '',bundleId);
        }
         
    }
})