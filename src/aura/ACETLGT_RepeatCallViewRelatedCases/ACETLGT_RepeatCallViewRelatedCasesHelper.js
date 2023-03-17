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
    },
    
    hideSpinner2: function(component, event, helper) {        
        window.setTimeout($A.getCallback(function(){
            component.set("v.Spinner", false);
        }),1000)
        console.log('Hide');
    },
    userCheck:function(component, event, helper) {  
        var action = component.get("c.getProfileUser");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
            	var storeResponse = response.getReturnValue();
                console.log('storeResponse::: '+JSON.stringify(storeResponse));
                if(storeResponse.Profile.Name =='ECM Back Office Agent'){
                    component.set("v.showrelatedcases",false);
                }else{
                   component.set("v.showrelatedcases",true);

                }
           }
        });
      $A.enqueueAction(action);
    },
    handleMouseOveroncaseParentnumber : function(component, event,CaseId) {
     if(CaseId != null || CaseId !='' || CaseId !='undefined'){  
        var action = component.get("c.getParentCaseInfo");     
        action.setParams({ "caseId" : CaseId 
        }); 

        action.setCallback(this, function(response) {
        var state = response.getState();        
        if (state === "SUCCESS") {            
             var parentCase = response.getReturnValue().AllRelatedCases;
             var AllRelatedCaseComments =response.getReturnValue().AllRelatedCaseComments;
             var i;
             for (i = 0; i < parentCase.length; i++) {
                if(parentCase[i].Id == CaseId ){
                         component.set("v.caseobj",parentCase[i]);
                      break;
                } 
             }
             var j;
             var CaseCommentslst =[];
             for (j = 0; j < AllRelatedCaseComments.length; j++) {
                if(AllRelatedCaseComments[j].ParentId == CaseId ){
                         CaseCommentslst.push(AllRelatedCaseComments[j]);
                }         
             }
             component.set("v.CaseCommentslst",CaseCommentslst); 
        }
        else {
            console.log(state);
        }
     });
     $A.enqueueAction(action);
    }            
   } 
})