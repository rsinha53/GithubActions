({
    doInit: function(component, event, helper) {
        var len = 10;
        var buf = [],
            chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789',
            charlen = chars.length,
            length = len || 32;
        for (var i = 0; i < length; i++) {
            buf[i] = chars.charAt(Math.floor(Math.random() * charlen));
        }
        var GUIkey = buf.join('');
        component.set("v.GUIkey", GUIkey);
        if (component.get("v.pageReference") != null) {

            var memid = component.get("v.pageReference").state.c__memberid;
            var srk = component.get("v.pageReference").state.c__srk;
            var eid = component.get("v.pageReference").state.c__eid;
            var callTopic = component.get("v.pageReference").state.c__callTopic;
            var interaction = component.get("v.pageReference").state.c__interaction;
            var intId = component.get("v.pageReference").state.c__intId;
            var groupId = component.get("v.pageReference").state.c__gId;
            var uInfo = component.get("v.pageReference").state.c__userInfo;
            var hData = JSON.parse(component.get("v.pageReference").state.c__hgltPanelDataString);
            var fname = component.get("v.pageReference").state.c__fname;
            var lname = component.get("v.pageReference").state.c__lname;
            var DOB = component.get("v.pageReference").state.c__dateOfBirth;
            var dataStr = component.get("v.pageReference").state.c__dataStr;
            var refId = component.get("v.pageReference").state.c__refId;
            var birthDate = component.get("v.pageReference").state.c__birthDate;
            var autodocKey = component.get("v.pageReference").state.c__AutodocKey;
            var data = JSON.parse(dataStr);
            component.set('v.refData', data);
            component.set('v.AutodocKey', autodocKey);
            component.set('v.grpNum', groupId);
            component.set('v.int', interaction);
            component.set('v.intId', intId);
            component.set('v.eid', eid);
            component.set('v.memberid', memid);
            component.set('v.srk', srk);
            component.set('v.firstName', fname);
            component.set('v.lastName', lname);
            console.log('hData :: ' + hData);
            console.log('hData 2:: ' + JSON.stringify(hData));
            component.set("v.highlightPanel", hData);
            component.set("v.refId", refId);
            component.set('v.birthDate', birthDate);
        }
        helper.getReferralDetail(component, event, helper);
        if (intId != undefined) {
            var childCmp = component.find("cComp");
            var memID = component.get("v.memberid");
            var GrpNum = component.get("v.grpNum");
            var bundleId = hData.benefitBundleOptionId;
            childCmp.childMethodForAlerts(intId, memID, GrpNum, '', bundleId);
        }
        
        

    }
})