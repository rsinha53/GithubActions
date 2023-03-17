({
    doInit: function (cmp, event, helper) {
        var globalId  =  cmp.getGlobalId();
        var index = globalId.indexOf(":"); 
       if (index != -1) 
        {
            globalId= globalId.substring(0 , index);
        }
        globalId = "footer"+ globalId
        cmp.set("v.globalId",globalId);
        var caseCommentBox = cmp.find('caseCommentBoxNew');
        $A.util.toggleClass(caseCommentBox, 'slds-is-closed');
        
    },
    toggleCaseComment: function(cmp, event,helper) {
        helper.toggleCaseComment(cmp, event);  
    },
    handleCaseComment: function(cmp, event, helper){
        var globalvalue = cmp.get("v.globalId");
        var caseComment = document.getElementById(globalvalue).value;
        if (caseComment != null || !caseComment ==="") {
            cmp.set("v.comments",caseComment);
            var compEvent = cmp.getEvent("caseCommentEvent");
            compEvent.setParams({"caseComment" : caseComment });
            compEvent.fire();
        }
    },
})