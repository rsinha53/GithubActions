({

    //Retrieves list of case which are open and close that are related to the 
    //familyLink user and users who signed ROI
    //Author: Sameera Silva ACDC
    getListOfCases:function(component,event,logedInUserID,familyAccountId){
        
        var action = component.get("c.getListOfCases");

        action.setParams({
            "familyLinkUserID":logedInUserID,
            "familyAccountID":familyAccountId
        });

        action.setCallback(this,function(response){
            
            if(response.getState()=='SUCCESS'){
               
                var openCases = [];
                var closeCases = [];
                var index;
                var cases = response.getReturnValue();
                console.log(cases);
                component.set("v.listOfCases",cases);
                for(index in cases){
                    
                    if(cases[index].caseStatus != 'Closed'){
                        
                        openCases.push(cases[index]);

                    }else{
                        
                        closeCases.push(cases[index]);
                        
                    }
                }
                
                component.set("v.listOfOpenCases",openCases);
                component.set("v.listOfClosedCases",closeCases);
                
            }
            
        });
        
        $A.enqueueAction(action);

    }

})