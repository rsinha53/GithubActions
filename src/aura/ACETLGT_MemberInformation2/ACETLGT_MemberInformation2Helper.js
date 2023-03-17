({
    showResults: function(component, event, helper) {        
        var resultflag = true;
		var identifier = component.get("v.identifier");
        var eid = component.get("v.EID");
        var srkkeychain = component.get("v.srkkeychain");
        var action = component.get("c.getSearchResults");
        var IntId = component.get("v.IntId");
        //action.setStorable();
        
        if (resultflag && identifier!=undefined) {
        //helper.showSpinner2(component,event,helper);
            component.set("v.MemberdetailInd");

            // Setting the apex parameters
            action.setParams({
                srk: identifier,
                EID: eid,
                SurrogateKeysStr: srkkeychain,
                IntId: IntId
            });

            //Setting the Callback
            action.setCallback(this, function(a) {
                //get the response state
                var state = a.getState();              
                //alert('------sub----'+state);
                if (state == "SUCCESS") {
                    console.log('getInd State Success');
                    var result = a.getReturnValue();                                  
                    if (!$A.util.isEmpty(result) && !$A.util.isUndefined(result)) {
                        if ($A.util.isEmpty(result.ErrorMessage) && !$A.util.isEmpty(result.resultWrapper) && !$A.util.isUndefined(result.resultWrapper)) {
							//alert('------sub---->>>>>'+ result.resultWrapper.SFrecId);
                            component.set("v.MemberdetailInd", result.resultWrapper);
                            console.log('------Emp---->>>>>'+ JSON.stringify(result.resultWrapper.EmploymentStartDate)+JSON.stringify(result.resultWrapper.EmploymentStatus) );
                            console.log('------SSN---->>>>>'+ JSON.stringify(result.resultWrapper.SSN) );
                            console.log('------CPTIN---->>>>>'+ JSON.stringify(result.resultWrapper.CPTIN) ); 
                            var appEvent = component.getEvent("getIndividualEvent");
                            appEvent.setParams({
                                "dateOfEmployment" : result.resultWrapper.EmploymentStartDate ,
                                "employmentStatus" : result.resultWrapper.EmploymentStatus ,
                                "spokenLanguage" : result.resultWrapper.SpokenLanguage ,
                                "writtenLanguage" : result.resultWrapper.WrittenLanguage,
                                "MemberdetailInd": result.resultWrapper
                            });
                            appEvent.fire();
                        }else{
                            var appEvent = component.getEvent("getIndividualEvent");
                            appEvent.setParams({
                                "errorMessage" : result.ErrorMessage
                            });
                            appEvent.fire();
                        }
                    }
                } else if (state == "ERROR") {
                    component.set("v.MemberdetailInd");
                }
                //helper.hideSpinner2(component,event,helper);
            });

            //adds the server-side action to the queue        
            $A.enqueueAction(action);
        }
        
        return resultflag;
    },
    hideSpinner2: function(component, event, helper) {        
        component.set("v.Spinner", false);
        console.log('Hide');
    },
    // this function automatic call by aura:waiting event  
    showSpinner2: function(component, event, helper) {
        // make Spinner attribute true for display loading spinner 
        component.set("v.Spinner", true);
        console.log('show');
    }
})