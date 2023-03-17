({
	handleMouseOveroncasenumber : function(component, event,CaseId) {
      
        var AllRelatedCases = component.get("v.AllRelatedCases");
        var AllRelatedCaseComments = component.get("v.AllRelatedCaseComments");
        debugger;
        console.log(AllRelatedCases);
        console.log(AllRelatedCaseComments);
        debugger;
        var i;
        for (i = 0; i < AllRelatedCases.length; i++) {
             if(AllRelatedCases[i].Id == CaseId){
                       component.set("v.caseobj",AllRelatedCases[i]);
                        break;
           } 
        }
        var j;
        var CaseCommentslst =[];
        for (j = 0; j < AllRelatedCaseComments.length; j++) {
           if(AllRelatedCaseComments[j].ParentId == CaseId){
                       CaseCommentslst.push(AllRelatedCaseComments[j]);
            }
         }
            component.set("v.CaseCommentslst",CaseCommentslst);
        }
    
})