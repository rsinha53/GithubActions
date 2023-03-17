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
        var memberGender = pageReference.state.c__memGender;
        var memberFirstName = pageReference.state.c__fname;
        var memberLastName = pageReference.state.c__lname;
        var coverageInfoBenefits = pageReference.state.c__coverageInfoBenefits;  
        var bookOfBusinessTypeCode = '';
        var customerPurchaseId = pageReference.state.c__CPID;
        let COStartDate = component.get("v.pageReference").state.c__COStartDate;
        let COEndDate = component.get("v.pageReference").state.c__COEndDate;
        if(component.get("v.pageReference").state.c__bookOfBusinessTypeCode != undefined){
            bookOfBusinessTypeCode = component.get("v.pageReference").state.c__bookOfBusinessTypeCode;
        }
        console.log('bookOfBusinessTypeCode',bookOfBusinessTypeCode);
        component.set('v.bookOfBusinessTypeCode',bookOfBusinessTypeCode);
        console.log('c__coverageInfoBenefits--->'+JSON.stringify(coverageInfoBenefits));
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
        component.set("v.memberGender", memberGender);
        component.set("v.memberFirstName", memberFirstName);
        component.set("v.memberLastName", memberLastName);
        component.set('v.coverageInfoBenefits', coverageInfoBenefits);
        if(!$A.util.isUndefinedOrNull(customerPurchaseId)){
            component.set('v.customerPurchaseId',customerPurchaseId);
            }
            if(!$A.util.isUndefinedOrNull(COStartDate)){
            component.set('v.COStartDate',COStartDate);
            }
            if(!$A.util.isUndefinedOrNull(COEndDate)){
            component.set('v.COEndDate',COEndDate);
            }
        if(hData != null && hData != undefined && hData.MemberDOB != null && hData.MemberDOB != undefined) {
            var dob = hData.MemberDOB.split(' ')[0];
            component.set("v.memberDOB", dob);
        }
        
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
        
        //	get CarrierId from SSB callout : to be used to generate ISET URL
        helper.getCarrierId(component);
    },
    
    callChildForPharmacy: function(component, event, helper) {
        var childCmp = component.find("callChildPharmacyMethod");
        childCmp.callChildForPharmacy(component.get("v.AutodocKey"));
    },
    
    openCSRFWindow: function(component, event, helper) {
        var csrfurl = component.get("v.csrfurl");
        console.log('~~~'+csrfurl);
        window.open(csrfurl, 'CSRFwindow', 'toolbars=0,width=1200,height=800,left=0,top=0,scrollbars=1,resizable=1');
    },
    
    redirectToISET: function(component, event, helper) {
        helper.getISETURL(component, helper);        
    },

    yesRadioButtonChanged: function(component, event, helper) {
        component.set("v.isCSRFVisible", true);
        component.set("v.isPharCheckSetError",false);
        
        component.set("v.PharmacyCSRFYes",true);
        component.set("v.PharmacyCSRFNo",false);
    },
    
    noRadioButtonChanged: function(component, event, helper) {
        component.set("v.isCSRFVisible", false);
        component.set("v.isPharCheckSetError",false);
        component.set("v.isPharCSRFSetError",false);
        //component.find('CSRF').set('v.value',' ');
        
        component.set("v.PharmacyCSRFNo",true);
        component.set("v.PharmacyCSRFYes",false);
    },
    
    //userstory : US1917159   
    restrictCSRFCharacters: function(component, event, helper) {
        var regex = new RegExp("^[0-9]+$");
        var str = String.fromCharCode(
            !event.charCode ? event.which : event.charCode
        );
        
        //Check more than 5 characters
        var csrfVal = component.get("v.CSRF");
        if (csrfVal.length > 5) {
            event.preventDefault();
            return false;
        }
        
        if (regex.test(str)) {
            return true;
        } else {
            event.preventDefault();
            return false;
        }
    },
    
    
    onPharmacyCommentBlur: function(component, event, helper) {
        if(!(component.find("comments").get("v.comments")!=undefined)){
           component.set("v.isPharCommentSetError",false);
        }
    },
    
    onPharmacyCommentsFocus: function(component, event, helper) {
        if(!(component.find("comments").get("v.comments")!=undefined)){
           component.set("v.isPharCommentSetError",true);
        }
	},

    onPharmacyCSRFBlur: function(component, event, helper) {
        var CSRFValue = document.getElementById('csrf').value;//component.get("v.CSRF");
        //alert(CSRFValue);
        var CSRFCmp =  document.getElementById('csrf');
        //alert(CSRFValue);
        if(CSRFValue != undefined){
           component.set("v.isPharCSRFSetError",false);
                       
            if(CSRFValue.length <6){
				component.set("v.isPharInvalidValueError",true);
                document.getElementById('csrf').classList.add("slds-has-error");
                
            }else{
                component.set("v.isPharInvalidValueError",false);
                component.set("v.CSRF", CSRFValue);
                document.getElementById('csrf').classList.remove("slds-has-error");
            }  
        }
    },
    
    onPharmacyCSRFFocus: function(component, event, helper) {

        if(document.getElementById('csrf').value != undefined){
           component.set("v.isPharCSRFSetError",true);

        }
	},

    handlePharCSRFChange: function(component, event, helper) {
        var csrfVal = component.get("v.isPharCSRFSetError");
        var csrfCmp =  component.find('CSRF');

        if(csrfVal){

        $A.util.addClass(csrfCmp, "slds-has-error");
        }else{
            $A.util.removeClass(csrfCmp, "slds-has-error");
        }
	},
    
    handlePharCommentsChange : function(component, event, helper) {
        var commentVal = component.get("v.isPharCommentSetError");
        var commentCmp =  component.find('comments');

        if(commentVal){

        $A.util.addClass(commentCmp, "slds-has-error");
        }else{
            $A.util.removeClass(commentCmp, "slds-has-error");
        }
	},
    
    handleExpand: function(cmp, event, helper) {
        var panelExpanded = cmp.get('v.panelExpanded');
        if (panelExpanded) {
            cmp.set('v.panelExpanded', false);
        } else {
            cmp.set('v.panelExpanded', true);
        }
    }
    
});