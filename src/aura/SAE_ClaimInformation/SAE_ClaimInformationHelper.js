({
    //US1956058 : Malinda
    claimDetailsCmpCreator : function(component,selectedObj) {
            
        $A.createComponent(
            "c:SAE_ClaimDetails",
            {
                "aura:id": selectedObj.claimNumber,
                "selectedClaim": selectedObj
            },
            function(newComponent, status, errorMessage){
                //Add the new button to the body array
                if (status === "SUCCESS") {
                    let body = component.get("v.claimDetailCmp");                    
                    body.push(newComponent);                    
                    
                    component.set("v.claimDetailCmp", body);
                }
                else if (status === "INCOMPLETE") {
                    console.log("No response from server or client is offline.")
                    // Show offline error
                }
                else if (status === "ERROR") {
                    console.log("Error: " + errorMessage);
                    // Show error message
                }
            }
        );
    }
})