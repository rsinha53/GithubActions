({
	doInit: function (cmp, event, helper) {
       
        var recid = cmp.get("v.recordId");
        cmp.set("v.recordId",recid)
       
		helper.getAuthDetails(cmp, event, helper);
       
    },
     displayCompleteComment : function(component, event, helper) {
		debugger;
        var comment ;
        var target = event.target;
        var dataEle = target.getAttribute("data-selected-Index");
        var Id = component.get("v.authorizeDetails");
        if(dataEle){
         comment = Id.bedDayDecisionDetail[dataEle].claimComments;
        }
        component.set("v.completeCaseComment",comment);
        component.set("v.completeCommentViewModalOpen",true);
},
    closeCommentModel : function(component, event, helper) {
         component.set("v.completeCommentViewModalOpen",false);
    }
})