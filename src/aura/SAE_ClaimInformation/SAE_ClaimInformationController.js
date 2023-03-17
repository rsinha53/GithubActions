({
    doInit : function(component, event, helper) {
       
    },
    enableLink : function(component, event, helper) {
        var closedClaimDetails=component.get("v.closedClaimDetails");
        var openedLinkData = event.getParam("openedLinkData");
        closedClaimDetails.push(openedLinkData.uniqueKey);
        if(component.get("v.showClaimResults")){
        if( component.find("claimSearchResults").length>0)
          component.find("claimSearchResults")[0].enableLink(openedLinkData );
         else
	    component.find("claimSearchResults").enableLink(openedLinkData );
          }
    },
    togglePopup : function(cmp, event) {
        let showPopup = event.currentTarget.getAttribute("data-popupId");
        cmp.find(showPopup).toggleVisibility();
    },
    handleSearchResultEvent : function(cmp, event) {
		console.log('event>>> ' + event.getParams("claimSearchResult"));
        var searchResult = event.getParam("claimSearchResult");
        var searchClaimDetails = JSON.stringify(event.getParam("mapClaimDetails"));
        if(searchResult != undefined && searchResult != null){
            cmp.set("v.claimSearchResult",searchResult);
            cmp.set("v.mapClaimDetails",searchClaimDetails);            
        }
    },
    handleAcetSearchResultEvent : function(cmp, event,helper) {

        
		var isEvent = event.getParam("isEvent");
        if(isEvent){
            var claimInput = event.getParam("claimInput");
            cmp.set("v.showNewMessage",true);
            }
            else{
        var claimInput = cmp.get("v.claimInput2");
        }
        if( !$A.util.isEmpty(claimInput)  ){

            if(claimInput != undefined && claimInput != null){
               cmp.set("v.claimInput",claimInput);
            }

            var showClaimResults = cmp.get('v.showClaimResults');
            if(showClaimResults){
                //refresh
                var childComp = cmp.find("claimSearchResults");
                cmp.set("v.showNewMessage",true);
                if(Array.isArray(childComp)){
                   		childComp = childComp[0];
                }
                childComp.refreshClaimSearch();
                childComp.getElement().scrollIntoView({
                        behavior: 'smooth',
                        block: 'center'
                });
            }
            else{
                //first time display of claim search result
                console.log('Claiminput value passed to claimSearchResult cmp ' + JSON.stringify(cmp.get("v.claimInput")));
                cmp.set('v.showClaimResults', true);
            }
        }
        else{
            //clear
            var childComp = cmp.find("claimSearchResults");

            if (childComp != null && childComp != undefined) {
                    if(Array.isArray(childComp)){
                   		childComp = childComp[0];
            		}
            		childComp.clearTable();
            }
        }
    },
    //US1956058 : Malinda
    addRemoveClaimDetailsCmps : function(component, event, helper) {
        let claimNo = event.getParam("selectedClaimNo");
        let processedDate = event.getParam("selectedProcessDate");
        let selectedRows = event.getParam("selectedClaimNumbers");//USE THIS FOR ROW REMOVAL
        let claimDetails = component.get("v.mapClaimDetails");
        
        console.log('###SELECTED-ROWS:',selectedRows);

        //creating details map
        let claimObj = JSON.parse(claimDetails);      
        let claimDetailsMap = new Map(Object.entries(claimObj));
        console.log('##-MAP', claimDetailsMap);
		console.log('##-MAP-SIZE', claimDetailsMap.size);
        
        let setOpenedCards = new Set(component.get("v.openedCards"));

        
        if(claimDetailsMap != undefined && claimDetailsMap != null) {
            /*
            for(let i = 0; i < claimDetailsMap.size; i++) {
               
            }
            */
                if(claimDetailsMap.has(claimNo) && !setOpenedCards.has(claimNo)) {
                    //Track opened cards
                    setOpenedCards.add(claimNo);
                    component.set("v.openedCards",setOpenedCards);
                    
                    let selectedClaim = claimDetailsMap.get(claimNo);
                    selectedClaim.claimNumber = claimNo;
                    selectedClaim.processDate = processedDate;
                    
                    //CLAIM INFO CARDS
                    $A.createComponent(
                    "c:SAE_ClaimDetails",
                    {
                        "aura:id": selectedClaim.claimNumber,
                        "selectedClaim": selectedClaim
                    },
                    function(newComponent, status, errorMessage){
                        //Add the new button to the body array
                        if (status === "SUCCESS") {
                            let body = component.get("v.claimDetailCmp");                            
                            //body[0] = newComponent;  
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
                    
                //PAYMENT INFO CARDS
                $A.createComponent(
                    "c:SAE_Claim_PaymentInfo",
                    {
                        "aura:id": selectedClaim.claimNumber,
                        "claimNo": selectedClaim.claimNumber
                    },
                    function(newComponent, status, errorMessage){
                        //Add the new button to the body array
                        if (status === "SUCCESS") {
                            let body = component.get("v.paymentDetailCmp");                            
                            //body[0] = newComponent;  
                            body.push(newComponent);                      
                            component.set("v.paymentDetailCmp", body);

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
                    
                console.log('###OPENED:',setOpenedCards);
                    
            }
        } else {
            console.log('### MAP-ERROR:',claimDetailsMap);
        }
	},
    clearClaimDetails : function(component, event, helper) {
        let visible = component.get("v.showClaimResults");
        if(!visible) {
            let claimDetailCmpBody = component.get("v.claimDetailCmp"); 
            let paymentDetailCmpBody = component.get("v.paymentDetailCmp");
            claimDetailCmpBody = [];   
            paymentDetailCmpBody = [];
            component.set("v.claimDetailCmp", claimDetailCmpBody);
            component.set("v.paymentDetailCmp", paymentDetailCmpBody);
        }
        //clear the opened card tracker
         component.set("v.openedCards",[]);
    },
    dohideClaimResults: function(component, event, helper){
        var uniqueTabId = event.getParam("uniqueTabID");
        var memberId=component.get("v.memberTabId");      
        console.log('switch policy event handled');
        console.log('uniqueTabId from Event>>'+uniqueTabId);
        console.log('uniqueTabId from aura>>'+memberId);
        if(!$A.util.isUndefinedOrNull(uniqueTabId) && (memberId==uniqueTabId))
        component.set("v.showClaimResults", false);
    }
})