({
    doInit: function(component, event, helper) {
        var pageReference = component.get("v.pageReference");
        //var userData = pageReference.state.c__topicList;

        
        var cseTopic = pageReference.state.c__callTopic;
        var srk = pageReference.state.c__srk;
        var int = pageReference.state.c__interaction;
        var intId = pageReference.state.c__intId;
        var memId = pageReference.state.c__Id;
        var grpNum = pageReference.state.c__gId;
        var uInfo = pageReference.state.c__userInfo;
		var Ismnf = pageReference.state.c__Ismnf;
        var hpi = pageReference.state.c__hgltPanelData;
        var bookOfBusinessTypeCode = '';
        if(component.get("v.pageReference").state.c__bookOfBusinessTypeCode != undefined){
            bookOfBusinessTypeCode = component.get("v.pageReference").state.c__bookOfBusinessTypeCode;
        }
        console.log('bookOfBusinessTypeCode',bookOfBusinessTypeCode);
        component.set('v.bookOfBusinessTypeCode',bookOfBusinessTypeCode);
        //console.log('highlightPanelData :: '+hpi);
        //alert('highlightPanelData json :: '+JSON.stringify(hpi));


        var hghString = pageReference.state.c__hgltPanelDataString;
        hpi = JSON.parse(hghString);

        
        var childComp = component.find('moi');
        childComp.callChildForPharmacy();

        component.set("v.highlightPanel", hpi);

        component.set("v.cseTopic", cseTopic);
        component.set("v.srk", srk);
        component.set("v.int", int);
        component.set("v.intId", intId);
        component.set("v.memId", memId);
        component.set("v.grpNum", grpNum);
        component.set("v.usInfo", uInfo);
        component.set("v.Ismnf", Ismnf);
        
		var bundleId = hpi.benefitBundleOptionId;
		var childCmp = component.find("cComp");
		childCmp.childMethodForAlerts(intId, memId, grpNum, '',bundleId);
        var tabKey = component.get("v.AutodocKey");
        var action = component.get("c.getCSRFURL");
        action.setParams({});
        
        action.setCallback(this, function(a) {
            var result = a.getReturnValue();
            //console.log('!!!'+result);
            component.set("v.csrfurl",result);
            setTimeout(function(){
                    //alert('----1----');
                    window.lgtAutodoc.initAutodoc(tabKey);
                },1);
        });
        $A.enqueueAction(action);
    },
    onchangecheckbox: function(component, event, helper) {
        var tableid =  "#"+component.get("v.AutodocKey")+"moetable";
        var checkboxid = "#"+component.get("v.AutodocKey")+"moetcheckbox";
        var checkboxResolved =  $(checkboxid).prop("checked");
        $(tableid).find("input.autodoc-case-item-resolved").prop("checked", checkboxResolved);
    },
    handleDynamicCallTypesSupportEvt:function(component, event, helper) {
         var dropDownSelectedVal = event.getParam("dropDownSelectedVal");
        component.set("v.dropDownSelectedVal",dropDownSelectedVal);
         var tableid =  "#"+component.get("v.AutodocKey")+"moetable";
        $(tableid).find("input.autodoc").prop("checked", true);
         var checkboxid = "#"+component.get("v.AutodocKey")+"moetcheckbox";
        var checkboxResolved =  $(checkboxid).prop("checked");
        if(!checkboxResolved){
                   $(tableid).find("input.autodoc-case-item-resolved").prop("checked", false);
 
        }

    },
	clearResults : function(component, event, helper) {
		
        //component.find("resolvedCheckbox").set("v.checked", false);
        //alert(component.get("v.dropDownSelectedValue"));
        //$A.get('e.force:refreshView').fire();
        component.set("v.checkboxResolved", '');
         var tableid =  "#"+component.get("v.AutodocKey")+"moetable";
       
        $(tableid).find("input").prop("checked", false);
        var stateCmpValueCB  = component.find("cComp").set("v.checkboxResolved", false);
        $A.util.removeClass(stateCmpValueCB, "slds-has-error");
        
        component.set("v.dropDownSelectedValue",''); 
        var stateCmpValue  = component.find("cComp").set("v.dropDownSelectedValue", "None");
        $A.util.removeClass(stateCmpValue, "slds-has-error");
        component.set("v.comments","");	
        component.set("v.checkboxResolved",false);
        
        
	},
    
    onCommentBlur : function(component, event, helper) {
        if(!(component.find("comments").get("v.comments")!=undefined)){
           component.set("v.isCommentSetError",false);
        }
    },
    onCommentsFocus : function(component, event, helper) {
        if(!(component.find("comments").get("v.comments")!=undefined)){
           component.set("v.isCommentSetError",true);
        }
    },
    
    handleCommentsChange : function(component, event, helper) {
        var commentVal = component.get("v.isCommentSetError");
        var commentCmp =  component.find('comments');
        
        if(commentVal){

        $A.util.addClass(commentCmp, "slds-has-error");
        }else{
            $A.util.removeClass(commentCmp, "slds-has-error");
        }
	} 
    
});