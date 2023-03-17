({ 
    doInit: function(component, event, helper) {
        //var uInf = window.localStorage.getItem('uProfile');
        //console.log('uInfwww ::: '+uInf);
        //if (uInf == 'hideSave')
            //compo
        //alert("====1====");
        var childCmp = component.find("callChildPharmacyMethod");
        
        var pageReference = component.get("v.pageReference");
        //var userData = pageReference.state.c__topicList;
        console.log("Pharmacy pageref" + pageReference.state);
        
        var cseTopic = pageReference.state.c__callTopic;
        var srk = pageReference.state.c__srk;
        var int = pageReference.state.c__interaction;
        var intId = pageReference.state.c__intId;
        var memId = pageReference.state.c__Id;
        var grpNum = pageReference.state.c__gId;
        var uInfo = pageReference.state.c__userInfo;
        var hData = pageReference.state.c__hgltPanelData;
        var hghString = pageReference.state.c__hgltPanelDataString;
        var Ismnf = pageReference.state.c__Ismnf;
        
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
        component.set("v.AutodocKey", GUIkey);
        var hdt = 'hd'+srk;
        console.log('hData new:: '+hData);
        console.log('hdt ::: '+hdt);
        console.log('hData 2:: '+JSON.stringify(hData));
        console.log('hghString :: '+hghString);
        /*
        if (JSON.stringify(hData) == '/"[object Object]/"')
            console.log('hdata parse :: '+JSON.parse(hData));
        */

        //console.log('hdata parse :: '+JSON.parse(hData));
        var hltdata = window.localStorage.getItem(srk);
        console.log('hgltData  ::: '+hltdata);
        hData = JSON.parse(hghString);
        //hData = JSON.parse(hltdata);

        childCmp.callChildForPharmacy();
        console.log('Pharmacy page ref'+cseTopic+srk+int+intId);
        component.set("v.cseTopic", cseTopic);
        component.set("v.srk", srk);
        component.set("v.int", int);
        component.set("v.intId", intId);
        component.set("v.memId", memId);
        component.set("v.usInfo", uInfo);
        component.set("v.grpNum", grpNum);
        component.set("v.highlightPanel", hData);
        component.set("v.Ismnf", Ismnf);
        
		var childCmp = component.find("cComp");
		var bundleId = hData.benefitBundleOptionId;
		childCmp.childMethodForAlerts(intId, memId, grpNum, '',bundleId);
        
        helper.checkProfile(component, event, helper);
        console.log('uInfo :: '+component.get("v.usInfo"));
        console.log('H info :: '+component.get("v.highlightPanel"));
        
        var action = component.get("c.getCSRFURL");
        action.setParams({});
        
        action.setCallback(this, function(a) {
            var result = a.getReturnValue();
            console.log('!!!'+result);
            component.set("v.csrfurl",result);
        });
        $A.enqueueAction(action);
        
        var action = component.get("c.getISETURL");
        action.setParams({});
        
        action.setCallback(this, function(a) {
            var result = a.getReturnValue();
            console.log('ISET :: !!!'+result);
            component.set("v.iseturl",result);
        });
        $A.enqueueAction(action);        


    },
    callChildForPharmacy: function(component, event, helper) {
        var childCmp = component.find("callChildPharmacyMethod");
        childCmp.callChildForPharmacy(component.get("v.AutodocKey"));
    },
    onClear: function(component, event, helper) {
        
        $A.get('e.force:refreshView').fire();
    
    }

    
});