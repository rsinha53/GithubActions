({
	getPCPVals : function(component, helper) {
        helper.showSpinner(component);	//	show spinner till response is back
        var action = component.get("c.getPCP");
        
        if(component.get("v.highlightPanel") != undefined){            
            var pcp_subsrk = component.get("v.subSrk");
            var pcp_grpNum,pcp_effectiveDate,pcp_memId;
            if(component.get("v.highlightPanel")!=undefined){
             	pcp_grpNum = component.get("v.highlightPanel.GroupNumber");
             	pcp_effectiveDate = component.get("v.highlightPanel.EffectiveDate");
            	pcp_memId = component.get("v.highlightPanel.MemberId");
            }
            console.log('------sub comp----'+pcp_subsrk);
            console.log('------grpnumber comp----'+pcp_grpNum);
            console.log('------effectiveDate comp----'+pcp_effectiveDate);
            console.log('------memId comp----'+pcp_memId);
            
            if(pcp_grpNum != undefined && pcp_subsrk != undefined && pcp_effectiveDate != undefined && pcp_memId != undefined){
                
                // Setting the apex parameters
                action.setParams({
                    subsrk: pcp_subsrk,
                    groupNumber: pcp_grpNum,
                    effectiveDate: pcp_effectiveDate,
                    memberId:pcp_memId
                });                
                
                //Setting the Callback
                action.setCallback(this,function(a){
                    //get the response state
                    var state = a.getState();
                    console.log('~~~~----state---'+state);
                    //check if result is successfull
                    if(state == "SUCCESS"){
                        var result = a.getReturnValue();
                        
                        console.log("result service ::: " +JSON.stringify(result));                        
                        if(!$A.util.isEmpty(result) && !$A.util.isUndefined(result)){
                            if (!$A.util.isEmpty(result.resultWrapper) && !$A.util.isUndefined(result.resultWrapper)){
                                
                                component.set("v.Memberdetail",result.resultWrapper);
                                component.set("v.physicianInfo",result.resultWrapper.PCPAssignments);
                                console.log(':::pcp'+JSON.stringify(result.resultWrapper.PCPAssignments));
                            }  
                        }
                            }
                    
                    helper.hideSpinner(component);
                });    
                
                //adds the server-side action to the queue        
                $A.enqueueAction(action);                
            }            
        }
        //component.set("v.showUpdatePCPModal",true);
    },
    
    hideSpinner : function(component) {	
		component.set("v.Spinner", false);
	},
      
    showSpinner : function(component) {
       // make Spinner attribute true for display loading spinner 
        component.set("v.Spinner", true); 
   	}
})